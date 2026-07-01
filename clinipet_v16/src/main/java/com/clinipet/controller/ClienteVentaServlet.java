package com.clinipet.controller;

import com.clinipet.dao.DashboardDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ClienteVentaServlet", urlPatterns = {"/cliente/ventas/eliminar"})
public class ClienteVentaServlet extends HttpServlet {

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

        if (!"CLIENTE".equalsIgnoreCase(usuario.getRol())) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            int idVenta = Integer.parseInt(request.getParameter("id"));
            DashboardDAO dao = new DashboardDAO();
            int res = dao.eliminarVentaCliente(idVenta, usuario.getId());
            if (res > 0) {
                response.sendRedirect(request.getContextPath() + "/cliente/dashboard?ok=Compra+eliminada+correctamente");
            } else {
                response.sendRedirect(request.getContextPath() + "/cliente/dashboard?error=No+se+pudo+eliminar+la+compra");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/cliente/dashboard?error=" + e.getMessage());
        }
    }
}
