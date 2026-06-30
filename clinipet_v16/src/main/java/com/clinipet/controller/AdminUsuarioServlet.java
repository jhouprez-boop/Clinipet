package com.clinipet.controller;

import com.clinipet.dao.DashboardDAO;
import com.clinipet.dao.UsuarioDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "AdminUsuarioServlet", urlPatterns = {
    "/usuarios/guardar",
    "/usuarios/actualizar",
    "/usuarios/eliminar"
})
public class AdminUsuarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
        String rol = usuarioSesion.getRol();
        if (!"ADMIN".equalsIgnoreCase(rol) && !"ADMINISTRADOR".equalsIgnoreCase(rol)) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Acceso+no+permitido");
            return;
        }

        String path = request.getServletPath();
        DashboardDAO dao = new DashboardDAO();

        try {
            if ("/usuarios/guardar".equals(path)) {
                String nombre    = request.getParameter("nombre");
                String correo    = request.getParameter("correo");
                String password  = request.getParameter("password");
                String rolNuevo  = request.getParameter("rol");

                boolean ok = new UsuarioDAO().registrar(nombre, correo, password, rolNuevo);
                if (ok) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?ok=Usuario+creado+correctamente");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=No+se+pudo+crear+el+usuario");
                }

            } else if ("/usuarios/actualizar".equals(path)) {
                int    id     = Integer.parseInt(request.getParameter("id"));
                String nombre = request.getParameter("nombre");
                String correo = request.getParameter("correo");
                String rolUpd = request.getParameter("rol");
                String estado = request.getParameter("estado");

                int res = dao.actualizarUsuario(id, nombre, correo, rolUpd, estado);
                if (res > 0) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?ok=Usuario+actualizado+correctamente");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=No+se+pudo+actualizar+el+usuario");
                }

            } else if ("/usuarios/eliminar".equals(path)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int res = dao.eliminarUsuario(id);
                if (res > 0) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?ok=Usuario+eliminado");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=No+se+pudo+eliminar+el+usuario");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard?error=" + e.getMessage());
        }
    }
}
