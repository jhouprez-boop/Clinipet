package com.clinipet.controller;

import java.io.IOException;

import com.clinipet.dao.DashboardDAO;
import com.clinipet.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "DashboardServlet", urlPatterns = {
    "/dashboard",
    "/veterinarios/guardar",
    "/veterinarios/actualizar",
    "/veterinarios/eliminar"
})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String rol = usuario.getRol();

        if ("CLIENTE".equalsIgnoreCase(rol)) {
            response.sendRedirect(request.getContextPath() + "/cliente/dashboard");
            return;
        }

        if ("RECEPCIONISTA".equalsIgnoreCase(rol)) {
            response.sendRedirect(request.getContextPath() + "/recepcionista/dashboard");
            return;
        }

        if ("ENFERMERO".equalsIgnoreCase(rol) || "VETERINARIO".equalsIgnoreCase(rol)) {
            response.sendRedirect(request.getContextPath() + "/enfermero/dashboard");
            return;
        }

        if (!"ADMIN".equalsIgnoreCase(rol) && !"ADMINISTRADOR".equalsIgnoreCase(rol)) {
            response.sendRedirect(request.getContextPath() + "/login?error=Acceso no permitido");
            return;
        }

        try {
            DashboardDAO dao = new DashboardDAO();

            request.setAttribute("citas", dao.listarCitas());
            request.setAttribute("ventas", dao.listarVentas());
            request.setAttribute("productos", dao.listarProductos());
            request.setAttribute("usuarios", dao.listarUsuarios());

            Object veterinariosList = dao.listarVeterinarios();
            request.setAttribute("veterinarios", veterinariosList);
            request.setAttribute("listaVets", veterinariosList);

            System.out.println("✔ [DashboardServlet] Datos del panel administrativo cargados con éxito.");

        } catch (Exception e) {
            System.out.println("❌ [DashboardServlet] Error al interactuar con el DashboardDAO:");
            e.printStackTrace();
        }

        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        DashboardDAO dao = new DashboardDAO();

        try {
            // ✅ guardar nuevo veterinario + crear usuario de acceso
            if ("/veterinarios/guardar".equals(path)) {
                String nombre       = request.getParameter("nombre");
                String especialidad = request.getParameter("especialidad");
                String correo       = request.getParameter("correo");
                String telefono     = request.getParameter("telefono");
                String estado       = request.getParameter("estado");
                String contrasena   = request.getParameter("contrasena");

                if (nombre == null || nombre.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=El nombre es obligatorio");
                    return;
                }

                // 1. Crear usuario con rol VETERINARIO para que pueda iniciar sesión
                if (contrasena != null && !contrasena.trim().isEmpty() && correo != null && !correo.trim().isEmpty()) {
                    new com.clinipet.dao.UsuarioDAO().registrar(nombre.trim(), correo.trim(), contrasena.trim(), "VETERINARIO");
                }

                // 2. Insertar en tabla veterinarios (con id_usuario vinculado)
                int resultado = dao.guardarVeterinarioConUsuario(
                    nombre.trim(),
                    correo    != null ? correo.trim()       : "",
                    telefono  != null ? telefono.trim()     : "",
                    especialidad != null ? especialidad.trim() : "",
                    estado    != null ? estado              : "DISPONIBLE",
                    correo    != null ? correo.trim()       : ""  // correo para buscar id_usuario
                );

                if (resultado > 0) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?ok=Veterinario+guardado+con+éxito");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=No+se+pudo+guardar+el+veterinario");
                }
                return;
            }

            // ✅ actualizar veterinario existente
            if ("/veterinarios/actualizar".equals(path)) {
                int id              = Integer.parseInt(request.getParameter("id"));
                String nombre       = request.getParameter("nombre");
                String especialidad = request.getParameter("especialidad");
                String correo       = request.getParameter("correo");
                String telefono     = request.getParameter("telefono");
                String estado       = request.getParameter("estado");
                String contrasena   = request.getParameter("contrasena");

                int resultado = dao.actualizarVeterinario(
                    id,
                    nombre       != null ? nombre.trim()        : "",
                    correo       != null ? correo.trim()        : "",
                    telefono     != null ? telefono.trim()      : "",
                    especialidad != null ? especialidad.trim()  : "",
                    estado       != null ? estado               : "DISPONIBLE"
                );

                // Si se ingresó contraseña nueva, actualizar o crear usuario de acceso
                if (contrasena != null && !contrasena.trim().isEmpty() && correo != null && !correo.trim().isEmpty()) {
                    com.clinipet.dao.UsuarioDAO uDao = new com.clinipet.dao.UsuarioDAO();
                    boolean updated = uDao.actualizarContrasenaVeterinario(correo.trim(), contrasena.trim());
                    if (!updated) {
                        // Si no existe usuario, crearlo
                        uDao.registrar(nombre != null ? nombre.trim() : "", correo.trim(), contrasena.trim(), "VETERINARIO");
                        // Vincular id_usuario al veterinario
                        dao.vincularUsuarioVeterinario(correo.trim());
                    }
                }

                if (resultado > 0) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?ok=Veterinario+actualizado+con+éxito");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=No+se+pudo+actualizar+el+veterinario");
                }
                return;
            }

            // Eliminar veterinario
            if ("/veterinarios/eliminar".equals(path)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int resultado = dao.eliminarVeterinario(id);
                if (resultado > 0) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?ok=Veterinario+eliminado");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=No+se+pudo+eliminar");
                }
                return;
            }

        } catch (Exception e) {
            System.out.println("❌ [DashboardServlet] Error al procesar acción POST de veterinarios:");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard?error=" + e.getMessage());
            return;
        }

        // Si la ruta POST no coincide, redirige al dashboard por defecto
        doGet(request, response);
    }
}