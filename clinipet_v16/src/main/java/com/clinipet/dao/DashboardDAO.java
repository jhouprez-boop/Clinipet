package com.clinipet.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.clinipet.config.Conexion;

public class DashboardDAO {

    private Map<String, Object> row(ResultSet rs) throws SQLException {
        Map<String, Object> m = new HashMap<>();
        ResultSetMetaData md = rs.getMetaData();

        for (int i = 1; i <= md.getColumnCount(); i++) {
            m.put(md.getColumnLabel(i), rs.getObject(i));
        }

        return m;
    }

    private List<Map<String, Object>> list(String sql, Object... params) {
        List<Map<String, Object>> out = new ArrayList<>();

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    out.add(row(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return out;
    }

    private int update(String sql, Object... params) {
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<Map<String, Object>> listarCitas() {
        return list(
            "SELECT c.id_cita AS id, d.nombre AS duenio, m.nombre AS mascota, m.especie, " +
            "uv.nombre AS doctor, c.fecha, TIME_FORMAT(c.hora, '%H:%i') AS hora, " +
            "c.motivo, IFNULL(c.estado,'PENDIENTE') AS estado, IFNULL(c.precio,0) AS precio " +
            "FROM citas c " +
            "INNER JOIN mascotas m ON c.id_mascota = m.id_mascota " +
            "INNER JOIN duenios d ON m.id_duenio = d.id_duenio " +
            "LEFT JOIN usuarios uv ON c.id_veterinario = uv.id_usuario " +
            "ORDER BY c.fecha DESC, c.hora DESC"
        );
    }

    public List<Map<String, Object>> listarCitasPendientes() {
        return list(
            "SELECT c.id_cita AS id, d.nombre AS duenio, m.nombre AS mascota, m.especie, " +
            "uv.nombre AS doctor, c.fecha, TIME_FORMAT(c.hora, '%H:%i') AS hora, " +
            "c.motivo, IFNULL(c.estado,'PENDIENTE') AS estado, IFNULL(c.precio,0) AS precio " +
            "FROM citas c " +
            "INNER JOIN mascotas m ON c.id_mascota = m.id_mascota " +
            "INNER JOIN duenios d ON m.id_duenio = d.id_duenio " +
            "LEFT JOIN usuarios uv ON c.id_veterinario = uv.id_usuario " +
            "WHERE UPPER(IFNULL(c.estado,'PENDIENTE')) = 'PENDIENTE' " +
            "ORDER BY c.fecha, c.hora"
        );
    }

    public List<Map<String, Object>> listarMisCitas(int idVeterinario) {
        return list(
            "SELECT c.id_cita AS id, d.nombre AS duenio, m.nombre AS mascota, m.especie, " +
            "c.fecha, TIME_FORMAT(c.hora, '%H:%i') AS hora, c.motivo, " +
            "IFNULL(c.estado,'PENDIENTE') AS estado, IFNULL(c.precio,0) AS precio " +
            "FROM citas c " +
            "INNER JOIN mascotas m ON c.id_mascota = m.id_mascota " +
            "INNER JOIN duenios d ON m.id_duenio = d.id_duenio " +
            "WHERE c.id_veterinario = ? " +
            "ORDER BY c.fecha, c.hora",
            idVeterinario
        );
    }

    public List<Map<String, Object>> listarCitasCliente(int idUsuario) {
        return list(
            "SELECT c.id_cita AS id, m.nombre AS mascota, m.especie, uv.nombre AS doctor, " +
            "c.fecha, TIME_FORMAT(c.hora, '%H:%i') AS hora, c.motivo, " +
            "IFNULL(c.estado,'PENDIENTE') AS estado, IFNULL(c.precio,0) AS precio " +
            "FROM citas c " +
            "INNER JOIN mascotas m ON c.id_mascota = m.id_mascota " +
            "INNER JOIN duenios d ON m.id_duenio = d.id_duenio " +
            "LEFT JOIN usuarios uv ON c.id_veterinario = uv.id_usuario " +
            "WHERE d.id_usuario = ? " +
            "ORDER BY c.fecha DESC, c.hora DESC",
            idUsuario
        );
    }

    public List<Map<String, Object>> listarVentas() {
        return list(
            "SELECT v.id_venta AS id, u.nombre AS cliente, v.fecha, v.total, " +
            "v.metodo_pago AS metodo, IFNULL(v.estado,'CONFIRMADO') AS estado " +
            "FROM ventas v " +
            "INNER JOIN usuarios u ON v.id_usuario = u.id_usuario " +
            "ORDER BY v.fecha DESC"
        );
    }

    public List<Map<String, Object>> listarVentasCliente(int idUsuario) {
        return list(
            "SELECT v.id_venta AS id, v.fecha, v.total, v.metodo_pago AS metodo, " +
            "IFNULL(v.estado,'CONFIRMADO') AS estado " +
            "FROM ventas v " +
            "WHERE v.id_usuario = ? " +
            "ORDER BY v.fecha DESC",
            idUsuario
        );
    }

    public List<Map<String, Object>> listarProductos() {
        return list(
            "SELECT id_producto AS id, codigo, nombre, categoria, precio, " +
            "IFNULL(stock,0) AS stock, IFNULL(stock_minimo,5) AS stock_minimo, " +
            "especie, imagen_url, descripcion " +
            "FROM productos " +
            "ORDER BY stock ASC, nombre"
        );
    }

    public List<Map<String, Object>> listarUsuarios() {
        return list(
            "SELECT u.id_usuario AS id, u.nombre, u.correo, r.nombre AS rol, " +
            "IFNULL(u.estado,'ACTIVO') AS estado " +
            "FROM usuarios u " +
            "INNER JOIN roles r ON u.id_rol = r.id_rol " +
            "ORDER BY u.id_usuario DESC"
        );
    }

    // ✅ CORREGIDO: se cambió 'specialty' por 'especialidad' para que coincida con la columna real de la BD
    public List<Map<String, Object>> listarVeterinarios() {
        try {
            return list(
                "SELECT id_veterinario AS id, nombre, correo, telefono, especialidad, " +
                "IFNULL(estado,'DISPONIBLE') AS estado, id_usuario " +
                "FROM veterinarios " +
                "ORDER BY nombre"
            );
        } catch (Exception e) {
            // Fallback si id_usuario no existe aún en la BD
            return list(
                "SELECT id_veterinario AS id, nombre, correo, telefono, especialidad, " +
                "IFNULL(estado,'DISPONIBLE') AS estado " +
                "FROM veterinarios " +
                "ORDER BY nombre"
            );
        }
    }

    public List<Map<String, Object>> listarMascotas() {
        return list(
            "SELECT m.id_mascota AS id, m.nombre, m.especie, m.raza, m.sexo, m.fecha_nacimiento, " +
            "d.nombre AS duenio, " +
            "CASE WHEN EXISTS(" +
            "   SELECT 1 FROM citas c " +
            "   WHERE c.id_mascota = m.id_mascota " +
            "   AND UPPER(IFNULL(c.estado,'PENDIENTE')) = 'PENDIENTE'" +
            ") THEN 'CON CITA PENDIENTE' ELSE 'SIN CITA PENDIENTE' END AS alerta " +
            "FROM mascotas m " +
            "INNER JOIN duenios d ON m.id_duenio = d.id_duenio " +
            "ORDER BY m.id_mascota DESC"
        );
    }

    public List<Map<String, Object>> listarMascotasPorUsuario(int idUsuario) {
        return list(
            "SELECT m.id_mascota AS id, m.nombre, m.especie, m.raza, m.sexo, m.fecha_nacimiento, " +
            "d.nombre AS duenio, " +
            "CASE WHEN EXISTS(" +
            "   SELECT 1 FROM citas c " +
            "   WHERE c.id_mascota = m.id_mascota " +
            "   AND UPPER(IFNULL(c.estado,'PENDIENTE')) = 'PENDIENTE'" +
            ") THEN 'CON CITA PENDIENTE' ELSE 'SIN CITA PENDIENTE' END AS alerta " +
            "FROM mascotas m " +
            "INNER JOIN duenios d ON m.id_duenio = d.id_duenio " +
            "WHERE d.id_usuario = ? " +
            "ORDER BY m.nombre",
            idUsuario
        );
    }

    public boolean mascotaTieneCitaPendiente(int idMascota) {
        return !list(
            "SELECT id_cita FROM citas " +
            "WHERE id_mascota = ? " +
            "AND UPPER(IFNULL(estado,'PENDIENTE')) = 'PENDIENTE'",
            idMascota
        ).isEmpty();
    }

    public boolean doctorOcupado(int idVet, String fecha, String hora) {
        return !list(
            "SELECT id_cita FROM citas " +
            "WHERE id_veterinario = ? " +
            "AND fecha = ? " +
            "AND hora = ? " +
            "AND UPPER(IFNULL(estado,'PENDIENTE')) IN ('PENDIENTE','CONFIRMADA','ACEPTADA')",
            idVet, fecha, hora
        ).isEmpty();
    }

    public boolean mascotaPerteneceUsuario(int idMascota, int idUsuario) {
        return !list(
            "SELECT m.id_mascota " +
            "FROM mascotas m " +
            "INNER JOIN duenios d ON m.id_duenio = d.id_duenio " +
            "WHERE m.id_mascota = ? AND d.id_usuario = ?",
            idMascota, idUsuario
        ).isEmpty();
    }

    public int actualizarEstadoCita(int id, String estado) {
        return update(
            "UPDATE citas SET estado = ? WHERE id_cita = ?",
            estado, id
        );
    }

    /** Retorna true si la fecha+hora dada ya pasó respecto a la actual */
    private boolean fechaHoraEnPasado(String fecha, String hora) {
        try {
            java.time.LocalDateTime ahora = java.time.LocalDateTime.now();
            java.time.LocalDate fechaCita = java.time.LocalDate.parse(fecha);
            java.time.LocalTime horaCita  = java.time.LocalTime.parse(hora);
            java.time.LocalDateTime citaDT = java.time.LocalDateTime.of(fechaCita, horaCita);
            return citaDT.isBefore(ahora);
        } catch (Exception e) {
            return false;
        }
    }

    public int guardarCita(int idMascota, int idVet, String fecha, String hora, String motivo, double precio) {
        // -4: fecha/hora en el pasado
        if (fechaHoraEnPasado(fecha, hora)) {
            return -4;
        }

        if (mascotaTieneCitaPendiente(idMascota)) {
            return -1;
        }

        if (idVet > 0 && doctorOcupado(idVet, fecha, hora)) {
            return -2;
        }

        return update(
            "INSERT INTO citas(id_mascota,id_veterinario,fecha,hora,motivo,estado,precio) " +
            "VALUES(?,?,?,?,?,'PENDIENTE',?)",
            idMascota,
            idVet == 0 ? null : idVet,
            fecha,
            hora,
            motivo,
            precio
        );
    }

    public int guardarCitaCliente(int idUsuario, int idMascota, int idVet,
                                  String fecha, String hora, String motivo) {

        if (!mascotaPerteneceUsuario(idMascota, idUsuario)) {
            return -1;
        }

        // -5: fecha/hora en el pasado
        if (fechaHoraEnPasado(fecha, hora)) {
            return -5;
        }

        if (mascotaTieneCitaPendiente(idMascota)) {
            return -2;
        }

        if (idVet > 0 && doctorOcupado(idVet, fecha, hora)) {
            return -3;
        }

        return update(
            "INSERT INTO citas(id_mascota,id_veterinario,fecha,hora,motivo,estado,precio) " +
            "VALUES(?,?,?,?,?,'PENDIENTE',30000)",
            idMascota,
            idVet == 0 ? null : idVet,
            fecha,
            hora,
            motivo
        );
    }

    public int actualizarProducto(int id, String codigo, String nombre, String categoria, String especie,
                                  double precio, int stock, int stockMinimo, String imagenUrl, String descripcion) {
        return update(
            "UPDATE productos SET codigo=?, nombre=?, categoria=?, especie=?, precio=?, stock=?, stock_minimo=?, imagen_url=?, descripcion=? " +
            "WHERE id_producto=?",
            codigo, nombre, categoria, especie, precio, stock, stockMinimo, imagenUrl, descripcion, id
        );
    }

    public int actualizarUsuario(int id, String nombre, String correo, String rol, String estado) {
        List<Map<String, Object>> roles = list(
            "SELECT id_rol FROM roles WHERE LOWER(nombre)=LOWER(?)",
            rol
        );

        int idRol = 0;

        if (!roles.isEmpty()) {
            idRol = Integer.parseInt(String.valueOf(roles.get(0).get("id_rol")));
        } else {
            update("INSERT INTO roles(nombre) VALUES(?)", rol);

            roles = list(
                "SELECT id_rol FROM roles WHERE LOWER(nombre)=LOWER(?)",
                rol
            );

            if (!roles.isEmpty()) {
                idRol = Integer.parseInt(String.valueOf(roles.get(0).get("id_rol")));
            }
        }

        return update(
            "UPDATE usuarios SET nombre=?, correo=?, id_rol=?, estado=? WHERE id_usuario=?",
            nombre, correo, idRol, estado, id
        );
    }

    // ✅ NUEVO: inserta un veterinario directamente en la tabla veterinarios
    /** Vincula el id_usuario al veterinario que tiene el mismo correo */
    public void vincularUsuarioVeterinario(String correo) {
        try {
            update(
                "UPDATE veterinarios v " +
                "INNER JOIN usuarios u ON u.correo = v.correo " +
                "SET v.id_usuario = u.id_usuario " +
                "WHERE v.correo = ?",
                correo
            );
        } catch (Exception e) {
            System.out.println("[INFO] vincularUsuarioVeterinario: " + e.getMessage());
        }
    }

    public int guardarVeterinario(String nombre, String correo, String telefono, String especialidad, String estado) {
        return update(
            "INSERT INTO veterinarios (nombre, correo, telefono, especialidad, estado) VALUES (?, ?, ?, ?, ?)",
            nombre, correo, telefono, especialidad, estado
        );
    }

    /** Inserta veterinario y vincula el id_usuario del usuario recién creado por correo */
    public int guardarVeterinarioConUsuario(String nombre, String correo, String telefono,
                                            String especialidad, String estado, String correoUsuario) {
        // Insertar el veterinario primero
        int res = update(
            "INSERT INTO veterinarios (nombre, correo, telefono, especialidad, estado) VALUES (?, ?, ?, ?, ?)",
            nombre, correo, telefono, especialidad, estado
        );
        if (res > 0 && correoUsuario != null && !correoUsuario.isEmpty()) {
            // Intentar vincular id_usuario si la columna existe
            try {
                update(
                    "UPDATE veterinarios v " +
                    "INNER JOIN usuarios u ON u.correo = ? " +
                    "SET v.id_usuario = u.id_usuario " +
                    "WHERE v.correo = ? AND v.id_usuario IS NULL " +
                    "ORDER BY v.id_veterinario DESC LIMIT 1",
                    correoUsuario, correo
                );
            } catch (Exception e) {
                // Si la columna id_usuario no existe aún, no falla
                System.out.println("[INFO] id_usuario no vinculado en veterinarios: " + e.getMessage());
            }
        }
        return res;
    }

    /** Devuelve el id_veterinario asociado a un id_usuario, buscando por correo */
    public int getIdVeterinarioByUsuario(int idUsuario) {
        // Primero intenta por columna id_usuario
        try {
            List<Map<String,Object>> r = list(
                "SELECT id_veterinario FROM veterinarios WHERE id_usuario = ? LIMIT 1", idUsuario
            );
            if (!r.isEmpty() && r.get(0).get("id_veterinario") != null) {
                return Integer.parseInt(String.valueOf(r.get(0).get("id_veterinario")));
            }
        } catch (Exception ignored) {}
        // Fallback: buscar por correo coincidente entre usuarios y veterinarios
        try {
            List<Map<String,Object>> r = list(
                "SELECT v.id_veterinario FROM veterinarios v " +
                "INNER JOIN usuarios u ON u.correo = v.correo " +
                "WHERE u.id_usuario = ? LIMIT 1", idUsuario
            );
            if (!r.isEmpty() && r.get(0).get("id_veterinario") != null) {
                return Integer.parseInt(String.valueOf(r.get(0).get("id_veterinario")));
            }
        } catch (Exception ignored) {}
        return idUsuario; // último fallback
    }

    // ✅ CORREGIDO: actualiza directamente la tabla veterinarios (no usuarios)
    public int actualizarVeterinario(int id, String nombre, String correo, String telefono, String especialidad, String estado) {
        return update(
            "UPDATE veterinarios SET nombre=?, correo=?, telefono=?, especialidad=?, estado=? WHERE id_veterinario=?",
            nombre, correo, telefono, especialidad, estado, id
        );
    }

    public int obtenerOCrearDuenioPorUsuario(int idUsuario) {
        List<Map<String, Object>> existe = list(
            "SELECT id_duenio FROM duenios WHERE id_usuario = ?",
            idUsuario
        );

        if (!existe.isEmpty()) {
            return Integer.parseInt(String.valueOf(existe.get(0).get("id_duenio")));
        }

        List<Map<String, Object>> usuario = list(
            "SELECT nombre, correo FROM usuarios WHERE id_usuario = ?",
            idUsuario
        );

        if (usuario.isEmpty()) {
            return 0;
        }

        String nombre = String.valueOf(usuario.get(0).get("nombre"));
        String correo = String.valueOf(usuario.get(0).get("correo"));

        update(
            "INSERT INTO duenios(nombre, documento, telefono, correo, direccion, id_usuario) " +
            "VALUES(?, '', '', ?, '', ?)",
            nombre, correo, idUsuario
        );

        List<Map<String, Object>> nuevo = list(
            "SELECT id_duenio FROM duenios WHERE id_usuario = ?",
            idUsuario
        );

        if (!nuevo.isEmpty()) {
            return Integer.parseInt(String.valueOf(nuevo.get(0).get("id_duenio")));
        }

        return 0;
    }

    public int registrarMascotaCliente(int idUsuario, String nombre, String especie, String raza,
                                       String fechaNacimiento, String sexo) {

        int idDuenio = obtenerOCrearDuenioPorUsuario(idUsuario);

        if (idDuenio == 0) {
            return 0;
        }

        return update(
            "INSERT INTO mascotas(nombre, especie, raza, fecha_nacimiento, sexo, id_duenio) " +
            "VALUES(?,?,?,?,?,?)",
            nombre, especie, raza, fechaNacimiento, sexo, idDuenio
        );
    }

    // ── PRODUCTOS ────────────────────────────────────────────────────────────────

    public int guardarProducto(String codigo, String nombre, String categoria, String especie,
                               double precio, int stock, int stockMinimo, String imagenUrl,
                               String descripcion, String fechaVencimiento) {
        return update(
            "INSERT INTO productos (codigo, nombre, categoria, especie, precio, stock, " +
            "stock_minimo, imagen_url, descripcion, fecha_vencimiento) VALUES (?,?,?,?,?,?,?,?,?,?)",
            codigo, nombre, categoria, especie, precio, stock, stockMinimo,
            (imagenUrl != null ? imagenUrl : ""),
            (descripcion != null ? descripcion : ""),
            (fechaVencimiento != null && !fechaVencimiento.isEmpty() ? fechaVencimiento : null)
        );
    }

    public int eliminarVeterinario(int id) {
        return update("DELETE FROM veterinarios WHERE id_veterinario = ?", id);
    }

    public int eliminarProducto(int id) {
        return update("DELETE FROM productos WHERE id_producto = ?", id);
    }

    // ── USUARIOS ─────────────────────────────────────────────────────────────────

    public int eliminarUsuario(int id) {
        return update("UPDATE usuarios SET estado = 'INACTIVO' WHERE id_usuario = ?", id);
    }

    // ── CITAS ────────────────────────────────────────────────────────────────────

    public int actualizarCita(int id, String estado, String fecha, String hora,
                              String motivo, double precio) {
        return update(
            "UPDATE citas SET estado=?, fecha=?, hora=?, motivo=?, precio=? WHERE id_cita=?",
            estado, fecha, hora, motivo, precio, id
        );
    }

    // ── VENTAS ───────────────────────────────────────────────────────────────────

    public int eliminarVenta(int id) {
        // Primero eliminar detalles para respetar FK, luego la venta
        update("DELETE FROM detalle_venta WHERE id_venta = ?", id);
        return update("DELETE FROM ventas WHERE id_venta = ?", id);
    }

    public int actualizarVenta(int id, double total, String metodoPago, String estado) {
        return update(
            "UPDATE ventas SET total=?, metodo_pago=?, estado=? WHERE id_venta=?",
            total, metodoPago, estado, id
        );
    }

    public int confirmarVenta(int id) {
        return update("UPDATE ventas SET estado='CONFIRMADO' WHERE id_venta=?", id);
    }

    // ── VENTAS CLIENTE ────────────────────────────────────────────────────────────

    public int eliminarVentaCliente(int idVenta, int idUsuario) {
        // Verificar que la venta pertenece al usuario antes de borrar
        List<Map<String,Object>> check = list(
            "SELECT id_venta FROM ventas WHERE id_venta=? AND id_usuario=?", idVenta, idUsuario
        );
        if (check.isEmpty()) return 0;
        update("DELETE FROM detalle_venta WHERE id_venta=?", idVenta);
        return update("DELETE FROM ventas WHERE id_venta=? AND id_usuario=?", idVenta, idUsuario);
    }

    // ── HISTORIA CLÍNICA ─────────────────────────────────────────────────────────

    /**
     * Cambia el estado de una cita (ej. a REALIZADA luego de guardar la historia).
     */
    public int cambiarEstadoCita(int idCita, String nuevoEstado) {
        return update("UPDATE citas SET estado=? WHERE id_cita=?", nuevoEstado, idCita);
    }
}