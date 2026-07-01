package com.clinipet.controller;

import com.clinipet.config.Conexion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.Duration;
import java.util.UUID;
import org.json.JSONObject;

/**
 * Recuperar contrase-a con env-o real de correo v-a Brevo (API HTTP).
 *
 * Nota: NO se usa SMTP porque los hostings gratuitos (Render, Railway, etc.)
 * bloquean los puertos SMTP (25/465/587) para evitar spam. Brevo env-a por
 * HTTPS (puerto 443), que nunca est- bloqueado.
 *
 * Flujo:
 *   GET  /recuperar           - formulario de correo
 *   POST /recuperar           - genera token, env-a email, redirige a confirmaci-n
 *   GET  /recuperar/nueva     - formulario de nueva contrase-a (con token en URL)
 *   POST /recuperar/nueva     - valida token y actualiza contrase-a
 *
 * Configuraci-n (Brevo):
 *   1. Crea cuenta gratis en https://www.brevo.com (300 emails/d-a gratis)
 *   2. Verifica tu remitente: Settings - Senders - agrega tu Gmail y conf-rmalo
 *      por el correo que te llega.
 *   3. Genera una API Key: Settings - SMTP & API - API Keys - Generate a new API key
 *   4. Configura las variables de entorno BREVO_API_KEY y GMAIL_USER (el remitente verificado)
 */
@WebServlet(name = "RecuperarContrasenaServlet",
            urlPatterns = {"/recuperar", "/recuperar/nueva"})
public class RecuperarContrasenaServlet extends HttpServlet {

    // -
    //  -  CONFIGURACI-N - se leen de variables de entorno
    // -
    private static final String GMAIL_USER     = envOrDefault("GMAIL_USER", "jhouprez@gmail.com");
    private static final String BREVO_API_KEY  = envOrDefault("BREVO_API_KEY", "");
    private static final String APP_NAME       = "CliniPet";

    private static String envOrDefault(String key, String def) {
        String v = System.getenv(key);
        return (v == null || v.isBlank()) ? def : v;
    }
    // -

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String uri = req.getRequestURI();

        if (uri.endsWith("/nueva")) {
            String token = req.getParameter("token");
            String check = req.getParameter("check");  // "1" = solo validar, no redirigir

            if (token == null || token.isBlank()) {
                if ("1".equals(check)) {
                    res.setStatus(400); res.getWriter().write("invalid"); return;
                }
                res.sendRedirect(req.getContextPath() + "/recuperar?error=Token+inválido");
                return;
            }
            if (!tokenValido(token)) {
                if ("1".equals(check)) {
                    res.setStatus(400); res.getWriter().write("expired"); return;
                }
                res.sendRedirect(req.getContextPath()
                        + "/recuperar?error=El+enlace+ha+expirado+o+ya+fue+usado");
                return;
            }
            // Token v-lido
            if ("1".equals(check)) {
                res.setStatus(200); res.getWriter().write("ok"); return;
            }
            req.setAttribute("token", token);
            req.getRequestDispatcher("/WEB-INF/views/nueva_contrasena.jsp").forward(req, res);
        } else {
            req.getRequestDispatcher("/WEB-INF/views/recuperar_contrasena.jsp").forward(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        if (uri.endsWith("/nueva")) {
            // - Paso final: cambiar contrase-a -
            String token     = req.getParameter("token");
            String nueva     = req.getParameter("nueva");
            String confirmar = req.getParameter("confirmar");

            if (token == null || nueva == null || confirmar == null
                    || nueva.isBlank() || !nueva.equals(confirmar)) {
                res.sendRedirect(req.getContextPath() + "/recuperar/nueva?token=" + token
                        + "&error=Las+contraseñas+no+coinciden+o+están+vacías");
                return;
            }
            if (nueva.length() < 6) {
                res.sendRedirect(req.getContextPath() + "/recuperar/nueva?token=" + token
                        + "&error=La+contraseña+debe+tener+al+menos+6+caracteres");
                return;
            }

            boolean ok = cambiarContrasena(token, nueva);
            if (ok) {
                res.sendRedirect(req.getContextPath()
                        + "/login?msg=Contraseña+actualizada+correctamente.+Ya+puedes+iniciar+sesión");
            } else {
                res.sendRedirect(req.getContextPath()
                        + "/recuperar?error=El+enlace+expiró+o+ya+fue+usado");
            }

        } else {
            // - Paso 1: recibir correo, generar token, enviar email -
            String correo = req.getParameter("correo");
            if (correo == null || correo.isBlank()) {
                res.sendRedirect(req.getContextPath() + "/recuperar?error=Ingresa+tu+correo");
                return;
            }

            ensureTable();

            // Siempre mostrar el mismo mensaje (no revelar si existe)
            if (!correoExiste(correo)) {
                res.sendRedirect(req.getContextPath()
                        + "/recuperar?info=Si+el+correo+está+registrado+recibirás+un+código+en+tu+bandeja");
                return;
            }

            String token = generarToken(correo);
            if (token == null) {
                res.sendRedirect(req.getContextPath()
                        + "/recuperar?error=Error+interno,+intenta+de+nuevo");
                return;
            }

            // URL de cambio de contrase-a
            String baseUrl = req.getScheme() + "://" + req.getServerName()
                    + (req.getServerPort() == 80 || req.getServerPort() == 443
                        ? "" : ":" + req.getServerPort())
                    + req.getContextPath();
            String enlace = baseUrl + "/recuperar/nueva?token=" + token;

            boolean enviado = enviarCorreo(correo, token, enlace);

            // Siempre mostrar la p-gina de confirmaci-n con el token visible
            // (si el correo lleg-: el usuario puede ir directo; si no: lo usa manual)
            req.setAttribute("token",      token);
            req.setAttribute("correo",     correo);
            req.setAttribute("emailError", !enviado);
            req.getRequestDispatcher("/WEB-INF/views/recuperar_token_generado.jsp")
               .forward(req, res);
        }
    }

    /* ─── Envío de correo vía Brevo (API HTTP) ─────────────────── */

    private boolean enviarCorreo(String destinatario, String token, String enlace) {
        if (BREVO_API_KEY.isBlank()) {
            System.err.println("[CliniPet] BREVO_API_KEY no configurada; no se envía correo.");
            return false;
        }
        try {
            String html = buildEmailHtml(token, enlace);

            JSONObject sender = new JSONObject();
            sender.put("name", APP_NAME);
            sender.put("email", GMAIL_USER);

            JSONObject to = new JSONObject();
            to.put("email", destinatario);

            JSONObject body = new JSONObject();
            body.put("sender", sender);
            body.put("to", new org.json.JSONArray().put(to));
            body.put("subject", "🔑 Recupera tu contraseña — " + APP_NAME);
            body.put("htmlContent", html);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://api.brevo.com/v3/smtp/email"))
                    .timeout(Duration.ofSeconds(15))
                    .header("accept", "application/json")
                    .header("api-key", BREVO_API_KEY)
                    .header("content-type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(body.toString()))
                    .build();

            HttpClient client = HttpClient.newHttpClient();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() >= 200 && response.statusCode() < 300) {
                return true;
            } else {
                System.err.println("[CliniPet] Brevo respondió " + response.statusCode() + ": " + response.body());
                return false;
            }
        } catch (Exception e) {
            System.err.println("[CliniPet] Error enviando correo de recuperación: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private String buildEmailHtml(String token, String enlace) {
        return "<!doctype html><html lang='es'><head><meta charset='UTF-8'></head><body style='" +
               "margin:0;padding:0;background:#f0fdf4;font-family:Nunito,Arial,sans-serif'>" +
               "<table width='100%' cellpadding='0' cellspacing='0'><tr><td align='center' style='padding:40px 16px'>" +
               "<table width='540' cellpadding='0' cellspacing='0' style='background:white;border-radius:24px;" +
               "box-shadow:0 20px 60px rgba(0,80,40,.12);overflow:hidden;max-width:100%'>" +
               // Header
               "<tr><td style='background:linear-gradient(135deg,#003d25,#006b3c);padding:32px 36px;text-align:center'>" +
               "<div style='font-size:2.2rem'>🐾</div>" +
               "<h1 style='margin:10px 0 4px;color:white;font-size:1.8rem;font-family:Arial,sans-serif'>CliniPet</h1>" +
               "<p style='margin:0;color:rgba(255,255,255,.75);font-size:.95rem'>Recuperación de contraseña</p>" +
               "</td></tr>" +
               // Body
               "<tr><td style='padding:36px 36px 24px'>" +
               "<h2 style='margin:0 0 12px;color:#003d25;font-size:1.35rem'>¡Hola! 👋</h2>" +
               "<p style='color:#475569;line-height:1.7;margin:0 0 20px'>Recibimos una solicitud para restablecer la contraseña de tu cuenta en <strong>CliniPet</strong>. " +
               "Usa el código de verificación o el botón de abajo. Válido por <strong>30 minutos</strong>.</p>" +
               // Token box
               "<div style='background:#f0fdf4;border:2px dashed #00c875;border-radius:16px;padding:20px;text-align:center;margin:0 0 24px'>" +
               "<p style='margin:0 0 6px;font-size:.8rem;color:#64748b;text-transform:uppercase;letter-spacing:.07em;font-weight:700'>Tu código de recuperación</p>" +
               "<div style='font-size:1.6rem;font-weight:900;color:#003d25;letter-spacing:.12em;font-family:monospace'>" + token + "</div>" +
               "</div>" +
               // Button
               "<div style='text-align:center;margin:0 0 28px'>" +
               "<a href='" + enlace + "' style='display:inline-block;background:linear-gradient(135deg,#00c875,#00f5a0);" +
               "color:#003d25;font-weight:900;font-size:1rem;padding:14px 32px;border-radius:16px;text-decoration:none;" +
               "box-shadow:0 12px 30px rgba(0,200,117,.3)'>🔑 Cambiar contraseña</a></div>" +
               "<p style='color:#94a3b8;font-size:.82rem;line-height:1.6;margin:0'>Si no solicitaste este cambio, ignora este correo. Tu contraseña actual seguirá siendo la misma.</p>" +
               "</td></tr>" +
               // Footer
               "<tr><td style='background:#f8fffb;padding:18px 36px;text-align:center;border-top:1px solid #dbeee5'>" +
               "<p style='margin:0;font-size:.8rem;color:#94a3b8'>© " + java.time.Year.now().getValue() + " CliniPet · SENA CIMM, Sogamoso, Boyacá</p>" +
               "</td></tr>" +
               "</table></td></tr></table></body></html>";
    }

    /* ─── Helpers BD ────────────────────────────────────────────── */

    private boolean correoExiste(String correo) {
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT id_usuario FROM usuarios WHERE correo=? AND IFNULL(estado,'ACTIVO')='ACTIVO'")) {
            ps.setString(1, correo);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    private String generarToken(String correo) {
        // Token de 6 d-gitos (m-s f-cil de escribir a mano)
        String token = String.valueOf((int)(Math.random() * 900000) + 100000);
        // Nota: la expiraci-n se calcula con NOW() del propio servidor MySQL
        // (en vez de LocalDateTime.now() en Java) para evitar desfases de
        // zona horaria entre el contenedor de la app y la base de datos,
        // que hac-an que el token pareciera "expirado" apenas se generaba.
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "INSERT INTO password_reset_tokens(correo,token,expira_en,usado) " +
                "VALUES(?,?,DATE_ADD(NOW(), INTERVAL 30 MINUTE),0)")) {
            ps.setString(1, correo);
            ps.setString(2, token);
            ps.executeUpdate();
            return token;
        } catch (Exception e) { e.printStackTrace(); return null; }
    }

    private boolean tokenValido(String token) {
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT id FROM password_reset_tokens WHERE token=? AND usado=0 AND expira_en>NOW()")) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    private boolean cambiarContrasena(String token, String nueva) {
        String correo = null;
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT correo FROM password_reset_tokens WHERE token=? AND usado=0 AND expira_en>NOW()")) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) correo = rs.getString("correo");
            }
        } catch (Exception e) { e.printStackTrace(); return false; }

        if (correo == null) return false;

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "UPDATE usuarios SET contrasena=? WHERE correo=?")) {
            ps.setString(1, org.mindrot.jbcrypt.BCrypt.hashpw(nueva, org.mindrot.jbcrypt.BCrypt.gensalt()));
            ps.setString(2, correo);
            if (ps.executeUpdate() == 0) return false;
        } catch (Exception e) { e.printStackTrace(); return false; }

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "UPDATE password_reset_tokens SET usado=1 WHERE token=?")) {
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (Exception ignored) {}

        return true;
    }

    private void ensureTable() {
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "CREATE TABLE IF NOT EXISTS password_reset_tokens(" +
                "  id INT AUTO_INCREMENT PRIMARY KEY," +
                "  correo VARCHAR(100) NOT NULL," +
                "  token VARCHAR(64) NOT NULL," +
                "  expira_en DATETIME NOT NULL," +
                "  usado TINYINT NOT NULL DEFAULT 0," +
                "  creado_en DATETIME DEFAULT CURRENT_TIMESTAMP," +
                "  INDEX idx_token(token)," +
                "  INDEX idx_correo(correo)" +
                ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci")) {
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
