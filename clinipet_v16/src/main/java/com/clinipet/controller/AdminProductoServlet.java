package com.clinipet.controller;

import com.clinipet.dao.DashboardDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "AdminProductoServlet", urlPatterns = {
    "/productos/guardar",
    "/productos/actualizar",
    "/productos/eliminar"
})
public class AdminProductoServlet extends HttpServlet {

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
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Acceso no permitido");
            return;
        }

        String path = request.getServletPath();
        DashboardDAO dao = new DashboardDAO();

        try {
            if ("/productos/guardar".equals(path)) {
                String codigo       = request.getParameter("codigo");
                String nombre       = request.getParameter("nombre");
                String categoria    = request.getParameter("categoria");
                String especie      = request.getParameter("especie");
                double precio       = Double.parseDouble(request.getParameter("precio"));
                int    stock        = Integer.parseInt(request.getParameter("stock"));
                int    stockMinimo  = Integer.parseInt(request.getParameter("stock_minimo"));
                String imagenUrl    = request.getParameter("imagen_url");
                String descripcion  = request.getParameter("descripcion");
                String fechaVenc    = request.getParameter("fecha_vencimiento");

                // Usamos actualizarProducto con id=0 → INSERT directo
                int res = dao.guardarProducto(codigo, nombre, categoria, especie,
                                              precio, stock, stockMinimo, imagenUrl,
                                              descripcion, fechaVenc);
                if (res > 0) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?ok=Producto+guardado+correctamente");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=No+se+pudo+guardar+el+producto");
                }

            } else if ("/productos/actualizar".equals(path)) {
                int    id           = Integer.parseInt(request.getParameter("id"));
                String codigo       = request.getParameter("codigo");
                String nombre       = request.getParameter("nombre");
                String categoria    = request.getParameter("categoria");
                String especie      = request.getParameter("especie");
                double precio       = Double.parseDouble(request.getParameter("precio"));
                int    stock        = Integer.parseInt(request.getParameter("stock"));
                int    stockMinimo  = Integer.parseInt(request.getParameter("stock_minimo"));
                String imagenUrl    = request.getParameter("imagen_url");
                String descripcion  = request.getParameter("descripcion");
                if (descripcion == null) descripcion = "";

                int res = dao.actualizarProducto(id, codigo, nombre, categoria, especie,
                                                 precio, stock, stockMinimo, imagenUrl, descripcion);
                if (res > 0) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?ok=Producto+actualizado+correctamente");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=No+se+pudo+actualizar+el+producto");
                }

            } else if ("/productos/eliminar".equals(path)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int res = dao.eliminarProducto(id);
                if (res > 0) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?ok=Producto+eliminado");
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=No+se+pudo+eliminar+el+producto");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard?error=" + e.getMessage());
        }
    }
}
