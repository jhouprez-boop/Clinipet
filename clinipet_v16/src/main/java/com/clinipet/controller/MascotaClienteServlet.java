package com.clinipet.controller;

import com.clinipet.dao.DashboardDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "MascotaClienteServlet", urlPatterns = {
    "/cliente/mascotas/guardar",
    "/cliente/mascotas/actualizar",
    "/cliente/mascotas/eliminar"
})
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

        String path = request.getServletPath();
        DashboardDAO dao = new DashboardDAO();

        try {
            if ("/cliente/mascotas/guardar".equals(path)) {
                String nombre          = request.getParameter("nombre");
                String especie         = request.getParameter("especie");
                String raza            = request.getParameter("raza");
                String fechaNacimiento = request.getParameter("fecha_nacimiento");
                String sexo            = request.getParameter("sexo");

                int ok = dao.registrarMascotaCliente(usuario.getId(), nombre, especie, raza, fechaNacimiento, sexo);
                if (ok > 0) {
                    response.sendRedirect(request.getContextPath() + "/cliente/dashboard?ok=mascota");
                } else {
                    response.sendRedirect(request.getContextPath() + "/cliente/dashboard?error=No+se+pudo+registrar+la+mascota");
                }

            } else if ("/cliente/mascotas/actualizar".equals(path)) {
                int    idMascota       = Integer.parseInt(request.getParameter("id_mascota"));
                String nombre          = request.getParameter("nombre");
                String especie         = request.getParameter("especie");
                String raza            = request.getParameter("raza");
                String fechaNacimiento = request.getParameter("fecha_nacimiento");
                String sexo            = request.getParameter("sexo");

                int res = dao.actualizarMascota(idMascota, usuario.getId(), nombre, especie, raza, fechaNacimiento, sexo);
                if (res > 0) {
                    response.sendRedirect(request.getContextPath() + "/cliente/dashboard?ok=mascota_actualizada");
                } else {
                    response.sendRedirect(request.getContextPath() + "/cliente/dashboard?error=No+se+pudo+actualizar+la+mascota");
                }

            } else if ("/cliente/mascotas/eliminar".equals(path)) {
                int idMascota = Integer.parseInt(request.getParameter("id_mascota"));
                int res = dao.eliminarMascota(idMascota, usuario.getId());
                if (res > 0) {
                    response.sendRedirect(request.getContextPath() + "/cliente/dashboard?ok=mascota_eliminada");
                } else if (res == -1) {
                    response.sendRedirect(request.getContextPath() + "/cliente/dashboard?error=La+mascota+tiene+citas+pendientes");
                } else {
                    response.sendRedirect(request.getContextPath() + "/cliente/dashboard?error=No+se+pudo+eliminar+la+mascota");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/cliente/dashboard?error=Error+inesperado");
        }
    }
}
