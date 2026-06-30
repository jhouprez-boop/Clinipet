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
import java.util.*;

// Parseo JSON simple sin librerías externas
@WebServlet(name = "CompraCarritoServlet", urlPatterns = {"/comprar-carrito"})
public class CompraCarritoServlet extends HttpServlet {

    private static final String ADMIN_WHATSAPP = "573209230129";

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
        String itemsJson = request.getParameter("items");

        if (itemsJson == null || itemsJson.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cliente/comprar?error=" +
                URLEncoder.encode("Carrito vacío", StandardCharsets.UTF_8));
            return;
        }

        try {
            // Parseo manual del JSON { "idProd": {qty:N, precio:P, nombre:"..."}, ... }
            CompraDAO compraDAO = new CompraDAO();
            List<Map<String,Object>> prods = new DashboardDAO().listarProductos();

            // Parsear JSON básico: extraer keys (ids) y sus qty
            Map<Integer, Integer> pedido = new LinkedHashMap<>();
            // formato: {"123":{"nombre":"...","precio":1000,"qty":2,"img":"...","stock":5},...}
            String json = itemsJson.trim();
            json = json.substring(1, json.length()-1); // quitar { }
            // Tokenizar por entries
            // Dividir por "}," o por key pattern
            String[] entries = json.split("(?<=\\}),(?=\")");
            for (String entry : entries) {
                int colonIdx = entry.indexOf(':');
                if (colonIdx < 0) continue;
                String key = entry.substring(0, colonIdx).replaceAll("[\"{}\\s]","").trim();
                String val = entry.substring(colonIdx+1).trim();
                // extraer qty
                int qty = 1;
                java.util.regex.Matcher m = java.util.regex.Pattern.compile("\"qty\"\\s*:\\s*(\\d+)").matcher(val);
                if (m.find()) qty = Integer.parseInt(m.group(1));
                try { pedido.put(Integer.parseInt(key), qty); } catch(Exception ignored){}
            }

            if (pedido.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cliente/comprar?error=" +
                    URLEncoder.encode("No se pudo procesar el pedido", StandardCharsets.UTF_8));
                return;
            }

            StringBuilder waMsg = new StringBuilder("🐾 *Nuevo pedido CliniPet*%0A")
                .append("👤 Cliente: ").append(usuario.getNombre()).append("%0A%0A")
                .append("📦 *Productos:*%0A");

            double totalGeneral = 0;
            int exitosos = 0;
            for (Map.Entry<Integer,Integer> pe : pedido.entrySet()) {
                int idProd = pe.getKey();
                int qty = pe.getValue();
                try {
                    // Buscar precio
                    double precio = 0;
                    String nomProd = "Producto";
                    for (Map<String,Object> p : prods) {
                        if (Integer.parseInt(String.valueOf(p.get("id"))) == idProd) {
                            precio = Double.parseDouble(String.valueOf(p.get("precio")));
                            nomProd = String.valueOf(p.get("nombre"));
                            break;
                        }
                    }
                    boolean ok = compraDAO.registrarVenta(usuario.getId(), idProd, qty);
                    if (ok) {
                        exitosos++;
                        double sub = precio * qty;
                        totalGeneral += sub;
                        waMsg.append("• ").append(nomProd).append(" x").append(qty)
                             .append(" = $").append(String.format("%.0f", sub)).append("%0A");
                    }
                } catch (Exception ignored) {}
            }

            if (exitosos == 0) {
                response.sendRedirect(request.getContextPath() + "/cliente/comprar?error=" +
                    URLEncoder.encode("No se pudo procesar ningún producto (posiblemente sin stock)", StandardCharsets.UTF_8));
                return;
            }

            waMsg.append("%0A💰 *Total: $").append(String.format("%.0f", totalGeneral)).append("*%0A")
                 .append("✅ Por favor confirmar el pedido en el panel admin.");

            String waUrl = "https://wa.me/" + ADMIN_WHATSAPP + "?text=" + waMsg;
            String backUrl = request.getContextPath() + "/cliente/comprar?ok=carrito";

            response.sendRedirect(request.getContextPath() + "/whatsapp-notif?waUrl=" +
                URLEncoder.encode(waUrl, StandardCharsets.UTF_8) + "&back=" +
                URLEncoder.encode(backUrl, StandardCharsets.UTF_8) +
                "&producto=" + URLEncoder.encode("Pedido (" + exitosos + " productos)", StandardCharsets.UTF_8) +
                "&total=" + String.format("%.0f", totalGeneral));

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/cliente/comprar?error=" +
                URLEncoder.encode("Error: " + e.getMessage(), StandardCharsets.UTF_8));
        }
    }
}
