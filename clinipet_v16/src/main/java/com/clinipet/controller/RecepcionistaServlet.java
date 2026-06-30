package com.clinipet.controller;

import com.clinipet.dao.DashboardDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "RecepcionistaServlet", urlPatterns = {"/recepcionista/dashboard"})
public class RecepcionistaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (!"RECEPCIONISTA".equalsIgnoreCase(usuario.getRol())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        DashboardDAO dao = new DashboardDAO();

        // Pasar tanto pendientes como todas las citas
        request.setAttribute("citasPendientes", dao.listarCitasPendientes());
        request.setAttribute("todasCitas", dao.listarCitas());
        request.setAttribute("doctores", dao.listarVeterinarios());

        request.getRequestDispatcher("/WEB-INF/views/recepcionista.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (!"RECEPCIONISTA".equalsIgnoreCase(usuario.getRol())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String accion = request.getParameter("accion");
        String idParam = request.getParameter("id");

        if (accion != null && idParam != null) {
            try {
                int idCita = Integer.parseInt(idParam);
                DashboardDAO dao = new DashboardDAO();
                if ("CONFIRMAR".equalsIgnoreCase(accion)) {
                    dao.actualizarEstadoCita(idCita, "CONFIRMADA");
                } else if ("CANCELAR".equalsIgnoreCase(accion)) {
                    dao.actualizarEstadoCita(idCita, "CANCELADA");
                } else if ("COMPLETAR".equalsIgnoreCase(accion)) {
                    dao.actualizarEstadoCita(idCita, "COMPLETADA");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/recepcionista/dashboard?ok=Acción+realizada");
    }
}
