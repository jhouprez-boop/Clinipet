package com.clinipet.dao;

import com.clinipet.config.Conexion;
import java.sql.*;
import java.util.*;

public class CitaDAO {
    public boolean agendar(String duenio, String documento, String telefono, String correo, String direccion,
                           String mascota, String especie, String raza, String sexo,
                           String fecha, String hora, String motivo) throws SQLException {
        try (Connection con = Conexion.getConnection()) {
            con.setAutoCommit(false);
            try {
                int idDuenio = obtenerOCrearDuenio(con, duenio, documento, telefono, correo, direccion);
                int idMascota = crearMascota(con, mascota, especie, raza, sexo, idDuenio);
                String sql = "INSERT INTO citas (id_mascota, id_veterinario, fecha, hora, motivo, estado) VALUES (?, NULL, ?, ?, ?, 'PENDIENTE')";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, idMascota);
                    ps.setString(2, fecha);
                    ps.setString(3, hora);
                    ps.setString(4, motivo);
                    ps.executeUpdate();
                }
                con.commit();
                return true;
            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    private int obtenerOCrearDuenio(Connection con, String nombre, String documento, String telefono, String correo, String direccion) throws SQLException {
        String buscar = "SELECT id_duenio FROM duenios WHERE correo = ? OR documento = ?";
        try (PreparedStatement ps = con.prepareStatement(buscar)) {
            ps.setString(1, correo);
            ps.setString(2, documento);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("id_duenio");
            }
        }
        String insertar = "INSERT INTO duenios (nombre, documento, telefono, correo, direccion) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(insertar, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, nombre);
            ps.setString(2, documento);
            ps.setString(3, telefono);
            ps.setString(4, correo);
            ps.setString(5, direccion);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }
        throw new SQLException("No se pudo crear el dueño");
    }

    private int crearMascota(Connection con, String nombre, String especie, String raza, String sexo, int idDuenio) throws SQLException {
        String sql = "INSERT INTO mascotas (nombre, especie, raza, fecha_nacimiento, sexo, id_duenio) VALUES (?, ?, ?, NULL, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, nombre);
            ps.setString(2, especie);
            ps.setString(3, raza);
            ps.setString(4, sexo);
            ps.setInt(5, idDuenio);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }
        throw new SQLException("No se pudo crear la mascota");
    }

    public List<Map<String,Object>> ultimasCitas() throws SQLException {
        List<Map<String,Object>> lista = new ArrayList<>();
        String sql = "SELECT TOP 10 c.id_cita, d.nombre AS duenio, m.nombre AS mascota, m.especie, c.fecha, c.hora, c.motivo, c.estado " +
                     "FROM citas c INNER JOIN mascotas m ON c.id_mascota = m.id_mascota " +
                     "INNER JOIN duenios d ON m.id_duenio = d.id_duenio ORDER BY c.fecha DESC, c.hora DESC";
        try (Connection con = Conexion.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String,Object> m = new HashMap<>();
                m.put("id", rs.getInt("id_cita"));
                m.put("duenio", rs.getString("duenio"));
                m.put("mascota", rs.getString("mascota"));
                m.put("especie", rs.getString("especie"));
                m.put("fecha", rs.getDate("fecha"));
                m.put("hora", rs.getTime("hora"));
                m.put("motivo", rs.getString("motivo"));
                m.put("estado", rs.getString("estado"));
                lista.add(m);
            }
        }
        return lista;
    }
}
