package com.clinipet.controller;

import com.clinipet.dao.CompraDAO;
import com.clinipet.dao.DashboardDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CompraServlet", urlPatterns = {"/comprar"})
public class CompraServlet extends HttpServlet {

    // Número WhatsApp del admin (editable aquí o en BD)
    private static final String ADMIN_WHATSAPP = "573209230129"; // Cambia por el número real del admin

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login?msg=Debes iniciar sesion para comprar");
            return;
        }

        try {
            Usuario usuario = (Usuario) session.getAttribute("usuario");

            int idProducto = Integer.parseInt(request.getParameter("idProducto"));

            int cantidad = 1;
            String cantidadParam = request.getParameter("cantidad");
            if (cantidadParam != null && !cantidadParam.trim().isEmpty()) {
                cantidad = Integer.parseInt(cantidadParam);
            }

            // Obtener nombre del producto antes de comprar
            String nombreProducto = "producto";
            double precioProducto = 0;
            try {
                List<Map<String,Object>> prods = new DashboardDAO().listarProductos();
                for (Map<String,Object> p : prods) {
                    Object idP = p.get("id");
                    if (idP != null && Integer.parseInt(String.valueOf(idP)) == idProducto) {
                        nombreProducto = String.valueOf(p.get("nombre"));
                        try { precioProducto = Double.parseDouble(String.valueOf(p.get("precio"))); } catch(Exception ignored) {}
                        break;
                    }
                }
            } catch (Exception ignored) {}

            boolean ok = new CompraDAO().registrarVenta(usuario.getId(), idProducto, cantidad);

            String redirect = request.getParameter("redirect");

            if (ok) {
                // Construir mensaje WhatsApp para el admin
                double total = precioProducto * cantidad;
                String msg = "🐾 *Nueva compra en CliniPet*%0A" +
                             "👤 Cliente: " + usuario.getNombre() + "%0A" +
                             "📦 Producto: " + nombreProducto + "%0A" +
                             "🔢 Cantidad: " + cantidad + "%0A" +
                             "💰 Total: $" + String.format("%.0f", total) + "%0A" +
                             "✅ Por favor confirmar el pedido en el panel admin.";

                String waUrl = "https://wa.me/" + ADMIN_WHATSAPP + "?text=" + msg;
                String backUrl = request.getContextPath() + ("tienda".equals(redirect) ? "/cliente/comprar" : "/cliente/dashboard") + "?ok=compra";

                // Redirigir a página intermedia que abre WhatsApp y vuelve
                response.sendRedirect(request.getContextPath() + "/whatsapp-notif?waUrl=" +
                    URLEncoder.encode(waUrl, StandardCharsets.UTF_8) + "&back=" +
                    URLEncoder.encode(backUrl, StandardCharsets.UTF_8) +
                    "&producto=" + URLEncoder.encode(nombreProducto, StandardCharsets.UTF_8) +
                    "&total=" + String.format("%.0f", total));
            } else {
                String errUrl = "tienda".equals(redirect) ? "/cliente/comprar" : "/cliente/dashboard";
                response.sendRedirect(request.getContextPath() + errUrl + "?error=" +
                        URLEncoder.encode("No se pudo comprar o no hay stock", StandardCharsets.UTF_8));
            }

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/cliente/dashboard?error=" +
                    URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Error desconocido", StandardCharsets.UTF_8));
        }
    }
}