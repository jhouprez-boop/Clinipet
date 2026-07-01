package com.clinipet.controller;

import com.clinipet.config.GoogleAuthConfig;
import com.clinipet.dao.UsuarioDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.json.JSONObject;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

/**
 * Recibe el "credential" (ID token JWT) que entrega el botón de
 * Google Identity Services en el navegador, lo valida directamente
 * contra los servidores de Google (sin necesidad de librerías pesadas)
 * y crea/inicia la sesión del usuario.
 */
@WebServlet(name = "GoogleLoginServlet", urlPatterns = {"/google-login"})
public class GoogleLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String credential = request.getParameter("credential");

        if (credential == null || credential.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/login?error=No se recibió el token de Google");
            return;
        }

        try {
            JSONObject payload = verificarTokenGoogle(credential);
            if (payload == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=No se pudo verificar la cuenta de Google");
                return;
            }

            String correo = payload.optString("email", null);
            String nombre = payload.optString("name", correo);
            String googleId = payload.optString("sub", null);
            boolean emailVerificado = payload.optBoolean("email_verified", false);

            if (correo == null || googleId == null || !emailVerificado) {
                response.sendRedirect(request.getContextPath() + "/login?error=Cuenta de Google no válida");
                return;
            }

            UsuarioDAO dao = new UsuarioDAO();
            Usuario usuario = dao.loginOrCreateGoogle(correo, nombre, googleId);

            if (usuario == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=No se pudo iniciar sesión con Google");
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);

            String rol = usuario.getRol();
            if ("ADMIN".equalsIgnoreCase(rol) || "ADMINISTRADOR".equalsIgnoreCase(rol)) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else if ("CLIENTE".equalsIgnoreCase(rol)) {
                response.sendRedirect(request.getContextPath() + "/cliente/dashboard");
            } else if ("RECEPCIONISTA".equalsIgnoreCase(rol)) {
                response.sendRedirect(request.getContextPath() + "/recepcionista/dashboard");
            } else if ("ENFERMERO".equalsIgnoreCase(rol) || "VETERINARIO".equalsIgnoreCase(rol)) {
                response.sendRedirect(request.getContextPath() + "/enfermero/dashboard");
            } else {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login?error=Rol no válido");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login?error=Error al iniciar sesión con Google");
        }
    }

    /**
     * Verifica el ID token contra el endpoint público de Google y revisa
     * que el "audience" coincida con nuestro Client ID, para evitar que
     * alguien falsifique un token de otra aplicación.
     */
    private JSONObject verificarTokenGoogle(String idToken) {
        try {
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest req = HttpRequest.newBuilder()
                    .uri(URI.create("https://oauth2.googleapis.com/tokeninfo?id_token=" + idToken))
                    .GET()
                    .build();

            HttpResponse<String> res = client.send(req, HttpResponse.BodyHandlers.ofString());
            if (res.statusCode() != 200) return null;

            JSONObject json = new JSONObject(res.body());

            String audience = json.optString("aud", "");
            if (!GoogleAuthConfig.CLIENT_ID.equals(audience)) {
                System.out.println("❌ Token de Google con audience inválida: " + audience);
                return null;
            }
            return json;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
