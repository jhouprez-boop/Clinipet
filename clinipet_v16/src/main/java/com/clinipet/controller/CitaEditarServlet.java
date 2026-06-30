package com.clinipet.controller;

import com.clinipet.dao.DashboardDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "CitaEditarServlet", urlPatterns = {"/citas/editar"})
public class CitaEditarServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String rol = usuario.getRol();

        // Solo admin y recepcionista pueden editar citas desde su panel
        if (!"ADMIN".equalsIgnoreCase(rol) && !"ADMINISTRADOR".equalsIgnoreCase(rol)
                && !"RECEPCIONISTA".equalsIgnoreCase(rol)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String fecha = request.getParameter("fecha");
            String hora = request.getParameter("hora");
            String motivo = request.getParameter("motivo");
            double precio = 0;
            try { precio = Double.parseDouble(request.getParameter("precio")); } catch(Exception ignored) {}

            DashboardDAO dao = new DashboardDAO();
            boolean ok = dao.actualizarCita(id, "PENDIENTE", fecha, hora, motivo, precio) > 0;

            String redirect = "RECEPCIONISTA".equalsIgnoreCase(rol)
                ? "/recepcionista/dashboard" : "/dashboard";

            if (ok) {
                response.sendRedirect(request.getContextPath() + redirect + "?ok=Cita+actualizada+correctamente");
            } else {
                response.sendRedirect(request.getContextPath() + redirect + "?error=" +
                    URLEncoder.encode("No se pudo actualizar la cita", StandardCharsets.UTF_8));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/recepcionista/dashboard?error=" +
                URLEncoder.encode("Error: " + e.getMessage(), StandardCharsets.UTF_8));
        }
    }
}
