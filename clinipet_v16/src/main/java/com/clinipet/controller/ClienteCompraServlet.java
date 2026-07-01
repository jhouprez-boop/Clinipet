package com.clinipet.controller;

import com.clinipet.dao.DashboardDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ClienteCompraServlet", urlPatterns = {"/cliente/comprar"})
public class ClienteCompraServlet extends HttpServlet {

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

        request.setAttribute("productos", dao.listarProductos());

        request.getRequestDispatcher("/WEB-INF/views/cliente/comprar.jsp")
                .forward(request, response);
    }
}