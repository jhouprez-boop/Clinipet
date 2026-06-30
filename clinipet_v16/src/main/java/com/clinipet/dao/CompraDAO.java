package com.clinipet.dao;

import com.clinipet.config.Conexion;
import java.sql.*;
import java.util.*;

public class CompraDAO {
    public boolean registrarVenta(int idUsuario, int idProducto, int cantidad) throws SQLException {
        String buscarProducto = "SELECT precio, stock FROM productos WHERE id_producto = ?";
        String ventaSql = "INSERT INTO ventas (id_usuario, total, metodo_pago, estado, fecha) VALUES (?, ?, 'EFECTIVO', 'PENDIENTE', NOW())";
        String detalleSql = "INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario, subtotal) VALUES (?, ?, ?, ?, ?)";
        String stockSql = "UPDATE productos SET stock = stock - ? WHERE id_producto = ? AND stock >= ?";
        try (Connection con = Conexion.getConnection()) {
            con.setAutoCommit(false);
            try {
                double precio;
                int stock;
                try (PreparedStatement ps = con.prepareStatement(buscarProducto)) {
                    ps.setInt(1, idProducto);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) throw new SQLException("Producto no encontrado");
                        precio = rs.getDouble("precio");
                        stock = rs.getInt("stock");
                    }
                }
                if (cantidad <= 0) cantidad = 1;
                if (stock < cantidad) throw new SQLException("No hay stock suficiente");
                double total = precio * cantidad;
                int idVenta;
                try (PreparedStatement ps = con.prepareStatement(ventaSql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, idUsuario);
                    ps.setDouble(2, total);
                    ps.executeUpdate();
                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (!keys.next()) throw new SQLException("No se generó la venta");
                        idVenta = keys.getInt(1);
                    }
                }
                try (PreparedStatement ps = con.prepareStatement(detalleSql)) {
                    ps.setInt(1, idVenta);
                    ps.setInt(2, idProducto);
                    ps.setInt(3, cantidad);
                    ps.setDouble(4, precio);
                    ps.setDouble(5, total);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = con.prepareStatement(stockSql)) {
                    ps.setInt(1, cantidad);
                    ps.setInt(2, idProducto);
                    ps.setInt(3, cantidad);
                    ps.executeUpdate();
                }
                con.commit();
                return true;
            } catch (SQLException ex) {
                con.rollback();
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    public List<Map<String,Object>> ultimasVentas() throws SQLException {
        List<Map<String,Object>> lista = new ArrayList<>();
        String sql = "SELECT v.id_venta, u.nombre AS cliente, v.total, v.metodo_pago, v.fecha " +
                     "FROM ventas v INNER JOIN usuarios u ON v.id_usuario = u.id_usuario ORDER BY v.fecha DESC, v.id_venta DESC LIMIT 10";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> m = new HashMap<>();
                m.put("id", rs.getInt("id_venta"));
                m.put("cliente", rs.getString("cliente"));
                m.put("total", rs.getDouble("total"));
                m.put("metodo", rs.getString("metodo_pago"));
                m.put("fecha", rs.getTimestamp("fecha"));
                lista.add(m);
            }
        }
        return lista;
    }
}
