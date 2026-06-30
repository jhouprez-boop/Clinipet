package com.clinipet.controller;

import com.clinipet.dao.UsuarioDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

/**
 * Pantalla "Mi perfil", disponible para cualquier rol (admin, cliente,
 * veterinario/enfermero, recepcionista). Permite cambiar el nombre
 * visible y subir/editar el avatar.
 */
@WebServlet(name = "PerfilServlet", urlPatterns = {"/perfil"})
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,      // 5 MB por archivo
    maxRequestSize = 6 * 1024 * 1024
)
public class PerfilServlet extends HttpServlet {

    private static final String[] EXTENSIONES_PERMITIDAS = {"jpg", "jpeg", "png", "webp", "gif"};

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = session != null ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/perfil.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Usuario usuario = session != null ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String nombre = request.getParameter("nombre");
        if (nombre == null || nombre.isBlank()) nombre = usuario.getNombre();

        String nombreArchivoGuardado = null;

        Part filePart = request.getPart("avatar");
        if (filePart != null && filePart.getSize() > 0) {
            String original = filePart.getSubmittedFileName();
            String ext = extensionDe(original);

            if (!extensionValida(ext)) {
                request.setAttribute("error", "Formato de imagen no permitido. Usa JPG, PNG, WEBP o GIF.");
                request.getRequestDispatcher("/WEB-INF/views/perfil.jsp").forward(request, response);
                return;
            }

            String carpetaReal = getServletContext().getRealPath("/assets/img/avatars");
            File carpeta = new File(carpetaReal);
            if (!carpeta.exists()) carpeta.mkdirs();

            nombreArchivoGuardado = "user" + usuario.getId() + "_" + UUID.randomUUID().toString().substring(0, 8) + "." + ext;
            Path destino = new File(carpeta, nombreArchivoGuardado).toPath();

            try (InputStream in = filePart.getInputStream()) {
                Files.copy(in, destino, StandardCopyOption.REPLACE_EXISTING);
            }
        }

        UsuarioDAO dao = new UsuarioDAO();
        boolean ok = dao.actualizarPerfil(usuario.getId(), nombre, nombreArchivoGuardado);

        if (ok) {
            usuario.setNombre(nombre);
            if (nombreArchivoGuardado != null) usuario.setFotoPerfil(nombreArchivoGuardado);
            session.setAttribute("usuario", usuario);
            request.setAttribute("mensaje", "Perfil actualizado correctamente.");
        } else {
            request.setAttribute("error", "No se pudo actualizar el perfil. Intenta de nuevo.");
        }

        request.getRequestDispatcher("/WEB-INF/views/perfil.jsp").forward(request, response);
    }

    private String extensionDe(String nombreArchivo) {
        if (nombreArchivo == null || !nombreArchivo.contains(".")) return "";
        return nombreArchivo.substring(nombreArchivo.lastIndexOf('.') + 1).toLowerCase();
    }

    private boolean extensionValida(String ext) {
        for (String e : EXTENSIONES_PERMITIDAS) {
            if (e.equals(ext)) return true;
        }
        return false;
    }
}
