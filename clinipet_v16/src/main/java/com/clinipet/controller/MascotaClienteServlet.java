package com.clinipet.controller;

import com.clinipet.dao.DashboardDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "MascotaClienteServlet", urlPatterns = {"/cliente/mascotas/guardar"})
public class MascotaClienteServlet extends HttpServlet {

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

        String nombre = request.getParameter("nombre");
        String especie = request.getParameter("especie");
        String raza = request.getParameter("raza");
        String fechaNacimiento = request.getParameter("fecha_nacimiento");
        String sexo = request.getParameter("sexo");

        int ok = new DashboardDAO().registrarMascotaCliente(
                usuario.getId(),
                nombre,
                especie,
                raza,
                fechaNacimiento,
                sexo
        );

        if (ok > 0) {
            response.sendRedirect(request.getContextPath() + "/cliente/dashboard?ok=mascota");
        } else {
            response.sendRedirect(request.getContextPath() + "/cliente/dashboard?error=No se pudo registrar la mascota");
        }
    }
}