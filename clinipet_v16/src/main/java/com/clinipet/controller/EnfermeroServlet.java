package com.clinipet.controller;

import com.clinipet.dao.DashboardDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "EnfermeroServlet", urlPatterns = {"/enfermero/dashboard"})
public class EnfermeroServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession s = request.getSession(false);
        Usuario u = s == null ? null : (Usuario) s.getAttribute("usuario");

        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // SOLO enfermeros y veterinarios pueden acceder
        String rol = u.getRol();
        if (!"ENFERMERO".equalsIgnoreCase(rol) && !"VETERINARIO".equalsIgnoreCase(rol)) {
            // Redirigir al panel correspondiente según su rol
            if ("ADMIN".equalsIgnoreCase(rol) || "ADMINISTRADOR".equalsIgnoreCase(rol)) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else if ("RECEPCIONISTA".equalsIgnoreCase(rol)) {
                response.sendRedirect(request.getContextPath() + "/recepcionista/dashboard");
            } else if ("CLIENTE".equalsIgnoreCase(rol)) {
                response.sendRedirect(request.getContextPath() + "/cliente/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return;
        }

        DashboardDAO dao = new DashboardDAO();
        int idVet = dao.getIdVeterinarioByUsuario(u.getId());
        request.setAttribute("misCitas", dao.listarMisCitas(idVet));
        request.getRequestDispatcher("/WEB-INF/views/enfermero.jsp").forward(request, response);
    }
}
