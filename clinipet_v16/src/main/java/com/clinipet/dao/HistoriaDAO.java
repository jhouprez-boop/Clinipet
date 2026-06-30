package com.clinipet.dao;

import com.clinipet.config.Conexion;
import java.sql.*;
import java.util.*;

public class HistoriaDAO {

    /**
     * Guarda o actualiza la historia clínica de una cita.
     */
    public void guardarOActualizar(int idMascota, int idCita,
            String diagnostico, String tratamiento,
            String medicacion, String observaciones) throws SQLException {

        try (Connection con = Conexion.getConnection()) {
            // Verificar si ya existe
            String check = "SELECT id_historia FROM historias_clinicas WHERE id_cita = ?";
            try (PreparedStatement ps = con.prepareStatement(check)) {
                ps.setInt(1, idCita);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        // UPDATE
                        String upd = "UPDATE historias_clinicas " +
                                     "SET diagnostico=?, tratamiento=?, medicacion=?, observaciones=? " +
                                     "WHERE id_cita=?";
                        try (PreparedStatement pu = con.prepareStatement(upd)) {
                            pu.setString(1, diagnostico);
                            pu.setString(2, tratamiento);
                            pu.setString(3, medicacion);
                            pu.setString(4, observaciones);
                            pu.setInt(5, idCita);
                            pu.executeUpdate();
                        }
                        return;
                    }
                }
            }
            // INSERT
            String ins = "INSERT INTO historias_clinicas " +
                         "(id_mascota, id_cita, diagnostico, tratamiento, medicacion, observaciones) " +
                         "VALUES (?,?,?,?,?,?)";
            try (PreparedStatement pi = con.prepareStatement(ins)) {
                pi.setInt(1, idMascota);
                pi.setInt(2, idCita);
                pi.setString(3, diagnostico);
                pi.setString(4, tratamiento);
                pi.setString(5, medicacion);
                pi.setString(6, observaciones);
                pi.executeUpdate();
            }
        }
    }

    /**
     * Obtiene todos los datos necesarios para generar el PDF de tratamiento,
     * verificando que la cita pertenezca al usuario dado (seguridad).
     */
    public Map<String, Object> getDatosPDF(int idCita, int idUsuario) {
        String sql =
            "SELECT c.id_cita, c.fecha, TIME_FORMAT(c.hora,'%H:%i') AS hora, c.motivo, " +
            "m.nombre AS mascota, m.especie, m.raza, m.sexo, " +
            "d.nombre AS duenio, d.telefono AS tel_duenio, d.correo AS correo_duenio, " +
            "uv.nombre AS veterinario, " +
            "h.diagnostico, h.tratamiento, h.medicacion, h.observaciones, " +
            "h.fecha AS fecha_historia " +
            "FROM citas c " +
            "INNER JOIN mascotas m ON c.id_mascota = m.id_mascota " +
            "INNER JOIN duenios d ON m.id_duenio = d.id_duenio " +
            "LEFT JOIN usuarios uv ON c.id_veterinario = uv.id_usuario " +
            "LEFT JOIN historias_clinicas h ON h.id_cita = c.id_cita " +
            "WHERE c.id_cita = ? AND d.id_usuario = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCita);
            ps.setInt(2, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> data = new HashMap<>();
                    ResultSetMetaData md = rs.getMetaData();
                    for (int i = 1; i <= md.getColumnCount(); i++) {
                        data.put(md.getColumnLabel(i), rs.getObject(i));
                    }
                    return data;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Obtiene la historia clínica de una cita específica para pre-llenar el formulario del veterinario.
     */
    public Map<String, Object> getHistoriaByCita(int idCita) {
        String sql =
            "SELECT h.id_historia, h.diagnostico, h.tratamiento, h.medicacion, h.observaciones, " +
            "c.id_cita, c.id_mascota, c.motivo, c.fecha, TIME_FORMAT(c.hora,'%H:%i') AS hora, " +
            "m.nombre AS mascota, m.especie, m.raza, m.sexo, " +
            "d.nombre AS duenio, d.telefono AS tel_duenio " +
            "FROM citas c " +
            "INNER JOIN mascotas m ON c.id_mascota = m.id_mascota " +
            "INNER JOIN duenios d ON m.id_duenio = d.id_duenio " +
            "LEFT JOIN historias_clinicas h ON h.id_cita = c.id_cita " +
            "WHERE c.id_cita = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCita);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> data = new HashMap<>();
                    ResultSetMetaData md = rs.getMetaData();
                    for (int i = 1; i <= md.getColumnCount(); i++) {
                        data.put(md.getColumnLabel(i), rs.getObject(i));
                    }
                    return data;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lista las historias clínicas con tratamiento de un cliente (para el dashboard cliente).
     */
    public List<Map<String, Object>> listarCitasConHistoriaCliente(int idUsuario) {
        String sql =
            "SELECT c.id_cita, c.fecha, TIME_FORMAT(c.hora,'%H:%i') AS hora, c.motivo, " +
            "IFNULL(c.estado,'PENDIENTE') AS estado, " +
            "m.nombre AS mascota, m.especie, " +
            "uv.nombre AS veterinario, " +
            "h.diagnostico, h.tratamiento, h.medicacion, h.observaciones " +
            "FROM citas c " +
            "INNER JOIN mascotas m ON c.id_mascota = m.id_mascota " +
            "INNER JOIN duenios d ON m.id_duenio = d.id_duenio " +
            "LEFT JOIN usuarios uv ON c.id_veterinario = uv.id_usuario " +
            "LEFT JOIN historias_clinicas h ON h.id_cita = c.id_cita " +
            "WHERE d.id_usuario = ? " +
            "ORDER BY c.fecha DESC, c.hora DESC " +
            "LIMIT 20";

        List<Map<String, Object>> lista = new ArrayList<>();
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    ResultSetMetaData md = rs.getMetaData();
                    for (int i = 1; i <= md.getColumnCount(); i++) {
                        row.put(md.getColumnLabel(i), rs.getObject(i));
                    }
                    lista.add(row);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
}
