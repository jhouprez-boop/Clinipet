package com.clinipet.controller;

import com.clinipet.dao.DashboardDAO;
import com.clinipet.dao.HistoriaDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ClienteDashboardServlet", urlPatterns = {"/cliente/dashboard"})
public class ClienteDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (!"CLIENTE".equalsIgnoreCase(usuario.getRol())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        DashboardDAO dao = new DashboardDAO();

        request.setAttribute("mascotas", dao.listarMascotasPorUsuario(usuario.getId()));
        request.setAttribute("citas", dao.listarCitasCliente(usuario.getId()));
        request.setAttribute("ventas", dao.listarVentasCliente(usuario.getId()));
        request.setAttribute("productos", dao.listarProductos());

        // Historia clínica: citas con diagnóstico/tratamiento/medicación
        HistoriaDAO hDao = new HistoriaDAO();
        request.setAttribute("citasHistoria", hDao.listarCitasConHistoriaCliente(usuario.getId()));

        request.getRequestDispatcher("/WEB-INF/views/cliente/dashboard_cliente.jsp")
                .forward(request, response);
    }
}