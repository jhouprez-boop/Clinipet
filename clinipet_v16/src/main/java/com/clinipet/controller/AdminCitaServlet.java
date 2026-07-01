package com.clinipet.controller;

import com.clinipet.dao.DashboardDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "AdminCitaServlet", urlPatterns = {"/citas/actualizar"})
public class AdminCitaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int    id     = Integer.parseInt(request.getParameter("id"));
            String estado = request.getParameter("estado");
            String fecha  = request.getParameter("fecha");
            String hora   = request.getParameter("hora");
            String motivo = request.getParameter("motivo");
            String precioParam = request.getParameter("precio");
            double precio = (precioParam != null && !precioParam.isEmpty()) ? Double.parseDouble(precioParam) : 0;

            DashboardDAO dao = new DashboardDAO();
            int res = dao.actualizarCita(id, estado, fecha, hora, motivo, precio);

            if (res > 0) {
                response.sendRedirect(request.getContextPath() + "/dashboard?ok=Cita+actualizada+correctamente");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard?error=No+se+pudo+actualizar+la+cita");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard?error=" + e.getMessage());
        }
    }
}
