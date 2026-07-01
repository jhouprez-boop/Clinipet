package com.clinipet.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.clinipet.config.Conexion;
import com.clinipet.model.Veterinario;

public class VeterinarioDAO {

    /**
     * Recupera todos los veterinarios DISPONIBLES de la tabla veterinarios.
     * - CORREGIDO: se elimin- el INNER JOIN con usuarios (la tabla veterinarios
     * es independiente y ya tiene su propio campo correo y telefono).
     *
     * @return Lista de objetos Veterinario.
     * @throws SQLException Si ocurre un error al interactuar con MySQL.
     */
    public List<Veterinario> listarTodos() throws SQLException {
        List<Veterinario> lista = new ArrayList<>();

        // - CORREGIDO: consulta directa a veterinarios sin JOIN incorrecto
        // La columna se llama 'especialidad' (no 'specialty')
        String sql = "SELECT id_veterinario, nombre, correo, telefono, especialidad, estado " +
                     "FROM veterinarios " +
                     "WHERE estado = 'DISPONIBLE' OR estado IS NULL OR estado = ''";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Veterinario vet = new Veterinario();

                vet.setId(rs.getInt("id_veterinario"));
                vet.setNombre(rs.getString("nombre"));
                vet.setCorreo(rs.getString("correo"));
                vet.setTelefono(rs.getString("telefono"));
                vet.setEspecialidad(rs.getString("especialidad"));

                // Si el estado viene vac-o o nulo de la BD, asignamos "DISPONIBLE" por defecto
                String estadoDB = rs.getString("estado");
                if (estadoDB == null || estadoDB.trim().isEmpty()) {
                    vet.setEstado("DISPONIBLE");
                } else {
                    vet.setEstado(estadoDB);
                }

                lista.add(vet);
            }
            System.out.println("✔ [DAO] Veterinarios cargados correctamente. Total: " + lista.size());

        } catch (SQLException e) {
            System.out.println("❌ [DAO] Error al ejecutar la consulta de veterinarios");
            e.printStackTrace();
            throw e;
        }

        return lista;
    }
}