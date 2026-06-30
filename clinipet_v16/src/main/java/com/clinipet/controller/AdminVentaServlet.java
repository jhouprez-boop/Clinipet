package com.clinipet.controller;

import com.clinipet.dao.DashboardDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "AdminVentaServlet", urlPatterns = {
    "/ventas/eliminar",
    "/ventas/actualizar",
    "/ventas/confirmar"
})
public class AdminVentaServlet extends HttpServlet {

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
        if (!"ADMIN".equalsIgnoreCase(rol) && !"ADMINISTRADOR".equalsIgnoreCase(rol)) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Acceso+no+permitido");
            return;
        }

        String path = request.getServletPath();
        DashboardDAO dao = new DashboardDAO();

        try {
            if ("/ventas/eliminar".equals(path)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int res = dao.eliminarVenta(id);
                if (res > 0) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?ok=Venta+eliminada+correctamente#ventas");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=No+se+pudo+eliminar+la+venta#ventas");
                }

            } else if ("/ventas/actualizar".equals(path)) {
                int id = Integer.parseInt(request.getParameter("id"));
                double total = Double.parseDouble(request.getParameter("total"));
                String metodoPago = request.getParameter("metodo_pago");
                String estado = request.getParameter("estado");
                if (metodoPago == null) metodoPago = "EFECTIVO";
                if (estado == null) estado = "CONFIRMADO";

                int res = dao.actualizarVenta(id, total, metodoPago, estado);
                if (res > 0) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?ok=Venta+actualizada+correctamente#ventas");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=No+se+pudo+actualizar+la+venta#ventas");
                }

            } else if ("/ventas/confirmar".equals(path)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int res = dao.confirmarVenta(id);
                if (res > 0) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?ok=Venta+confirmada+correctamente#ventas");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=No+se+pudo+confirmar+la+venta#ventas");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard?error=" + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Confirmar también puede llegar por GET (link directo)
        String path = request.getServletPath();
        if ("/ventas/confirmar".equals(path)) {
            doPost(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }
}
