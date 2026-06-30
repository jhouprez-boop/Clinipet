package com.clinipet.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.clinipet.config.Conexion;
import com.clinipet.model.Producto;

public class ProductoDAO {

    public boolean guardar(Producto producto) {
        String sql = "INSERT INTO productos (codigo, nombre, categoria, precio, stock, stock_minimo, fecha_vencimiento, especie, imagen_url, descripcion) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, producto.getCodigo()); ps.setString(2, producto.getNombre()); ps.setString(3, producto.getCategoria()); ps.setDouble(4, producto.getPrecio());
            ps.setInt(5, producto.getStock()); ps.setInt(6, producto.getStockMinimo()); ps.setString(7, producto.getFechaVencimiento()); ps.setString(8, producto.getEspecie());
            ps.setString(9, producto.getImagenUrl()); ps.setString(10, producto.getDescripcion()); return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Producto> listar() {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT id_producto, codigo, nombre, categoria, precio, stock, stock_minimo, fecha_vencimiento, especie, imagen_url, descripcion FROM productos ORDER BY id_producto DESC";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    /**
     * ✅ NUEVO: Devuelve los productos ordenados por cantidad total vendida (más vendidos primero).
     * Si un producto nunca ha sido vendido aparece igualmente al final (LEFT JOIN).
     * Fallback automático en index.jsp a listar() si la lista está vacía.
     */
    public List<Producto> listarMasVendidos() {
        List<Producto> lista = new ArrayList<>();
        String sql =
            "SELECT p.id_producto, p.codigo, p.nombre, p.categoria, p.precio, p.stock, " +
            "       p.stock_minimo, p.fecha_vencimiento, p.especie, p.imagen_url, p.descripcion, " +
            "       COALESCE(SUM(dv.cantidad), 0) AS total_vendido " +
            "FROM productos p " +
            "LEFT JOIN detalle_venta dv ON dv.id_producto = p.id_producto " +
            "WHERE p.stock > 0 " +
            "GROUP BY p.id_producto, p.codigo, p.nombre, p.categoria, p.precio, p.stock, " +
            "         p.stock_minimo, p.fecha_vencimiento, p.especie, p.imagen_url, p.descripcion " +
            "ORDER BY total_vendido DESC, p.id_producto DESC";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    private Producto map(ResultSet rs) throws SQLException {
        Producto p = new Producto();
        p.setIdProducto(rs.getInt("id_producto")); p.setCodigo(rs.getString("codigo")); p.setNombre(rs.getString("nombre")); p.setCategoria(rs.getString("categoria"));
        p.setPrecio(rs.getDouble("precio")); p.setStock(rs.getInt("stock")); p.setStockMinimo(rs.getInt("stock_minimo")); p.setFechaVencimiento(String.valueOf(rs.getDate("fecha_vencimiento")));
        p.setEspecie(rs.getString("especie")); p.setImagenUrl(rs.getString("imagen_url")); p.setDescripcion(rs.getString("descripcion")); return p;
    }

    public Producto buscarPorId(int idProducto) {
        String sql = "SELECT id_producto, codigo, nombre, categoria, precio, stock, stock_minimo, fecha_vencimiento, especie, imagen_url, descripcion FROM productos WHERE id_producto=?";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idProducto); try(ResultSet rs = ps.executeQuery()){ if(rs.next()) return map(rs); }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean registrarVenta(int idUsuario, int idProducto, int cantidad) {
        Producto p = buscarPorId(idProducto); if(p == null || p.getStock() < cantidad) return false;
        double total = p.getPrecio() * cantidad;
        try(Connection con = Conexion.getConnection()){
            con.setAutoCommit(false); int idVenta;
            try(PreparedStatement ps = con.prepareStatement("INSERT INTO ventas(id_usuario,total,metodo_pago,fecha) VALUES(?,?,'CONFIRMADO',NOW())", Statement.RETURN_GENERATED_KEYS)){
                ps.setInt(1, idUsuario); ps.setDouble(2, total); ps.executeUpdate(); try(ResultSet rs = ps.getGeneratedKeys()){ if(!rs.next()) { con.rollback(); return false; } idVenta = rs.getInt(1); }
            }
            try(PreparedStatement ps = con.prepareStatement("INSERT INTO detalle_venta(id_venta,id_producto,cantidad,precio_unitario,subtotal) VALUES(?,?,?,?,?)")){
                ps.setInt(1,idVenta); ps.setInt(2,idProducto); ps.setInt(3,cantidad); ps.setDouble(4,p.getPrecio()); ps.setDouble(5,total); ps.executeUpdate();
            }
            try(PreparedStatement ps = con.prepareStatement("UPDATE productos SET stock = IFNULL(stock,0) - ? WHERE id_producto=?")){
                ps.setInt(1,cantidad); ps.setInt(2,idProducto); ps.executeUpdate();
            }
            con.commit(); return true;
        }catch(Exception e){ e.printStackTrace(); return false; }
    }
}