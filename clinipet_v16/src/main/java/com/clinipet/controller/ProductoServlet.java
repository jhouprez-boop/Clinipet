package com.clinipet.controller;

import com.clinipet.dao.ProductoDAO;
import com.clinipet.model.Producto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ProductoServlet", urlPatterns = {"/productos"})
public class ProductoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/productos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String codigo = request.getParameter("codigo");
            String nombre = request.getParameter("nombre");
            String categoria = request.getParameter("categoria");
            double precio = Double.parseDouble(request.getParameter("precio"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            int stockMinimo = Integer.parseInt(request.getParameter("stock_minimo"));
            String fechaVencimiento = request.getParameter("fecha_vencimiento");
            String especie = request.getParameter("especie");
            String descripcion = request.getParameter("descripcion");
            String imagenUrl = request.getParameter("imagen_url");

            Producto producto = new Producto(
                    codigo,
                    nombre,
                    categoria,
                    precio,
                    stock,
                    stockMinimo,
                    fechaVencimiento,
                    especie,
                    descripcion,
                    imagenUrl
            );

            boolean guardado = new ProductoDAO().guardar(producto);

            if (guardado) {
                request.setAttribute("success", "Producto guardado correctamente");
            } else {
                request.setAttribute("error", "No se pudo guardar el producto. Revisa que el código no esté repetido.");
            }

            request.getRequestDispatcher("/WEB-INF/views/productos.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/productos.jsp").forward(request, response);
        }
    }
}