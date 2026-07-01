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
import java.util.regex.*;

/**
 * Procesa el carrito de compras tanto desde la tienda completa del cliente
 * como desde el index (clientes logueados).  Soporta dos formatos de JSON:
 *
 *  A) Array — enviado por el index con fetch:
 *     [{"id":"5","nombre":"Shampoo","precio":12000,"qty":2}, ...]
 *
 *  B) Object map — enviado por la tienda completa con form POST:
 *     {"5":{"qty":2,"precio":12000,"nombre":"Shampoo","img":"..."}, ...}
 *
 * Si la petición es AJAX (header X-Requested-With o Fetch), responde 200 JSON.
 * Si es un form POST normal, hace redirect.
 */
@WebServlet(name = "CompraCarritoServlet", urlPatterns = {"/comprar-carrito"})
public class CompraCarritoServlet extends HttpServlet {

    private static final String ADMIN_WHATSAPP = "573209230129";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        boolean esAjax = "fetch".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"));

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            if (esAjax) { response.setStatus(401); response.getWriter().write("{\"ok\":false,\"msg\":\"Sin sesión\"}"); }
            else response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String itemsJson = request.getParameter("items");
        String metodoPago = request.getParameter("metodo_pago");
        if (metodoPago == null || metodoPago.isBlank()) metodoPago = "WhatsApp";

        if (itemsJson == null || itemsJson.trim().isEmpty()) {
            respondError(response, esAjax, request.getContextPath() + "/cliente/comprar?error=Carrito+vacío", "Carrito vacío");
            return;
        }

        try {
            // Parsear ambos formatos
            Map<Integer, Integer> pedido = parseItems(itemsJson.trim());

            if (pedido.isEmpty()) {
                respondError(response, esAjax, request.getContextPath() + "/cliente/comprar?error=Pedido+vacío", "Pedido vacío");
                return;
            }

            CompraDAO compraDAO = new CompraDAO();
            List<Map<String,Object>> prods = new DashboardDAO().listarProductos();

            StringBuilder waMsg = new StringBuilder("🐾 *Nuevo pedido CliniPet*%0A")
                    .append("👤 Cliente: ").append(usuario.getNombre()).append("%0A%0A")
                    .append("📦 *Productos:*%0A");

            double totalGeneral = 0;
            int exitosos = 0;

            for (Map.Entry<Integer,Integer> pe : pedido.entrySet()) {
                int idProd = pe.getKey();
                int qty    = pe.getValue();
                try {
                    double precio = 0;
                    String nomProd = "Producto";
                    for (Map<String,Object> p : prods) {
                        Object pId = p.get("id");
                        if (pId != null && Integer.parseInt(String.valueOf(pId)) == idProd) {
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
                respondError(response, esAjax,
                        request.getContextPath() + "/cliente/comprar?error=Sin+stock",
                        "No se pudo procesar ningún producto (posiblemente sin stock)");
                return;
            }

            waMsg.append("%0A💰 *Total: $").append(String.format("%.0f", totalGeneral)).append("*%0A")
                 .append("✅ Por favor confirmar el pedido en el panel admin.");

            if (esAjax) {
                // Respuesta JSON simple para el fetch del index
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"ok\":true,\"total\":" + totalGeneral + ",\"items\":" + exitosos + "}");
            } else {
                // Flujo normal de la tienda completa
                String waUrl  = "https://wa.me/" + ADMIN_WHATSAPP + "?text=" + waMsg;
                String back   = request.getContextPath() + "/cliente/comprar?ok=carrito";
                response.sendRedirect(request.getContextPath() + "/whatsapp-notif?waUrl="
                        + URLEncoder.encode(waUrl, StandardCharsets.UTF_8)
                        + "&back=" + URLEncoder.encode(back, StandardCharsets.UTF_8)
                        + "&producto=" + URLEncoder.encode("Pedido (" + exitosos + " productos)", StandardCharsets.UTF_8)
                        + "&total=" + String.format("%.0f", totalGeneral));
            }

        } catch (Exception e) {
            e.printStackTrace();
            respondError(response, esAjax,
                    request.getContextPath() + "/cliente/comprar?error=" + URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8),
                    e.getMessage());
        }
    }

    /** Parsea formato Array [{id,qty,...}] o Object {"id":{qty,...}} */
    private Map<Integer, Integer> parseItems(String json) {
        Map<Integer, Integer> pedido = new LinkedHashMap<>();
        json = json.trim();

        if (json.startsWith("[")) {
            // Formato array: [{"id":"5","qty":2}, ...]
            Matcher m = Pattern.compile("\\{([^}]+)\\}").matcher(json);
            while (m.find()) {
                String obj = m.group(1);
                String id  = extractStr(obj, "id");
                String qty = extractStr(obj, "qty");
                try { pedido.put(Integer.parseInt(id), Integer.parseInt(qty)); } catch (Exception ignored) {}
            }
        } else {
            // Formato objeto: {"5":{"qty":2,...}, ...}
            json = json.substring(1, json.length()-1);
            String[] entries = json.split("(?<=\\}),(?=\")");
            for (String entry : entries) {
                int colonIdx = entry.indexOf(':');
                if (colonIdx < 0) continue;
                String key = entry.substring(0, colonIdx).replaceAll("[\"{}\\s]","").trim();
                String val = entry.substring(colonIdx+1).trim();
                Matcher m = Pattern.compile("\"qty\"\\s*:\\s*(\\d+)").matcher(val);
                int qty = m.find() ? Integer.parseInt(m.group(1)) : 1;
                try { pedido.put(Integer.parseInt(key), qty); } catch (Exception ignored) {}
            }
        }
        return pedido;
    }

    private String extractStr(String obj, String key) {
        Matcher m = Pattern.compile("\"" + key + "\"\\s*:\\s*\"?([^,\"\\}]+)\"?").matcher(obj);
        return m.find() ? m.group(1).trim() : "0";
    }

    private void respondError(HttpServletResponse response, boolean esAjax, String redirectUrl, String msg)
            throws IOException {
        if (esAjax) {
            response.setContentType("application/json");
            response.setStatus(400);
            response.getWriter().write("{\"ok\":false,\"msg\":\"" + msg.replace("\"","'") + "\"}");
        } else {
            response.sendRedirect(redirectUrl);
        }
    }
}
