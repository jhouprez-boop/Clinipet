package com.clinipet.controller;

import com.clinipet.dao.UsuarioDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String correo = request.getParameter("correo");
        String password = request.getParameter("password");

        try {
            UsuarioDAO dao = new UsuarioDAO();
            Usuario usuario = dao.login(correo, password);

            if (usuario == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=Correo o contraseña incorrectos");
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);

            String rol = usuario.getRol();

            if ("ADMIN".equalsIgnoreCase(rol) || "ADMINISTRADOR".equalsIgnoreCase(rol)) {
                response.sendRedirect(request.getContextPath() + "/dashboard");

            } else if ("CLIENTE".equalsIgnoreCase(rol)) {
                response.sendRedirect(request.getContextPath() + "/cliente/dashboard");

            } else if ("RECEPCIONISTA".equalsIgnoreCase(rol)) {
                response.sendRedirect(request.getContextPath() + "/recepcionista/dashboard");

            } else if ("ENFERMERO".equalsIgnoreCase(rol) || "VETERINARIO".equalsIgnoreCase(rol)) {
                response.sendRedirect(request.getContextPath() + "/enfermero/dashboard");

            } else {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login?error=Rol no válido");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login?error=Error al iniciar sesión");
        }
    }
}