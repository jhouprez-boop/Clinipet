package com.clinipet.dao;

import com.clinipet.config.Conexion;
import com.clinipet.model.Usuario;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;

public class UsuarioDAO {

    private Usuario mapRow(ResultSet rs) throws SQLException {
        return new Usuario(
            rs.getInt("id_usuario"),
            rs.getString("nombre"),
            rs.getString("correo"),
            rs.getString("rol"),
            rs.getString("foto_perfil"),
            rs.getString("proveedor")
        );
    }

    /**
     * Login tradicional con correo y contraseña.
     * Soporta contraseñas antiguas en texto plano: si detecta una, valida
     * por igualdad y de inmediato la re-encripta con BCrypt en la base de
     * datos (migración automática y transparente para el usuario).
     */
    public Usuario login(String correo, String password) throws SQLException {
        String sql = "SELECT u.id_usuario, u.nombre, u.correo, u.contrasena, u.foto_perfil, u.proveedor, r.nombre AS rol "
                   + "FROM usuarios u "
                   + "INNER JOIN roles r ON u.id_rol = r.id_rol "
                   + "WHERE u.correo = ? AND IFNULL(u.estado, 'ACTIVO') = 'ACTIVO'";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, correo);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                String hashGuardado = rs.getString("contrasena");
                if (hashGuardado == null) return null; // cuenta creada solo con Google, no tiene password local

                boolean coincide;
                boolean esHashBcrypt = hashGuardado.startsWith("$2a$") || hashGuardado.startsWith("$2b$") || hashGuardado.startsWith("$2y$");

                if (esHashBcrypt) {
                    coincide = BCrypt.checkpw(password, hashGuardado);
                } else {
                    // Contraseña heredada en texto plano: comparar tal cual
                    coincide = hashGuardado.equals(password);
                    if (coincide) {
                        // Migración automática a BCrypt
                        int idUsuario = rs.getInt("id_usuario");
                        actualizarHash(idUsuario, BCrypt.hashpw(password, BCrypt.gensalt()));
                    }
                }

                if (!coincide) return null;
                return mapRow(rs);
            }
        }
    }

    private void actualizarHash(int idUsuario, String nuevoHash) {
        String sql = "UPDATE usuarios SET contrasena = ? WHERE id_usuario = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevoHash);
            ps.setInt(2, idUsuario);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean registrar(String nombre, String correo, String contrasena, String rol) {
        String sqlRol = "SELECT id_rol FROM roles WHERE LOWER(nombre) = LOWER(?)";
        String sqlIns = "INSERT INTO usuarios(nombre, correo, contrasena, id_rol, estado, proveedor, fecha_registro) VALUES(?, ?, ?, ?, 'ACTIVO', 'LOCAL', NOW())";

        try (Connection con = Conexion.getConnection()) {
            int idRol = 0;

            try (PreparedStatement ps = con.prepareStatement(sqlRol)) {
                ps.setString(1, rol);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) idRol = rs.getInt(1);
                }
            }

            if (idRol == 0) {
                try (PreparedStatement ps = con.prepareStatement("INSERT INTO roles(nombre) VALUES(?)", Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, rol);
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) idRol = rs.getInt(1);
                    }
                }
            }

            String hash = BCrypt.hashpw(contrasena, BCrypt.gensalt());

            try (PreparedStatement ps = con.prepareStatement(sqlIns)) {
                ps.setString(1, nombre);
                ps.setString(2, correo);
                ps.setString(3, hash);
                ps.setInt(4, idRol);
                return ps.executeUpdate() > 0;
            }

        } catch (Exception e) {
            System.out.println("❌ [DAO] Error al registrar usuario:");
            e.printStackTrace();
            return false;
        }
    }

    public boolean registrarCompleto(String nombre, String correo, String contrasena, String telefono, String documento, String direccion) {
        try (Connection con = Conexion.getConnection()) {
            con.setAutoCommit(false);
            if (!registrar(nombre, correo, contrasena, "CLIENTE")) return false;

            int idUsuario = 0;
            try (PreparedStatement ps = con.prepareStatement("SELECT id_usuario FROM usuarios WHERE correo=? ORDER BY id_usuario DESC LIMIT 1")) {
                ps.setString(1, correo);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) idUsuario = rs.getInt(1);
            }

            try (PreparedStatement ps = con.prepareStatement("INSERT INTO duenios(nombre, documento, telefono, correo, direccion, id_usuario) VALUES(?,?,?,?,?,?)")) {
                ps.setString(1, nombre);
                ps.setString(2, documento);
                ps.setString(3, telefono);
                ps.setString(4, correo);
                ps.setString(5, direccion);
                ps.setInt(6, idUsuario);
                ps.executeUpdate();
            }
            con.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarContrasenaVeterinario(String correo, String nuevaContrasena) {
        String sql = "UPDATE usuarios SET contrasena = ? WHERE correo = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, BCrypt.hashpw(nuevaContrasena, BCrypt.gensalt()));
            ps.setString(2, correo);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Usuario buscarPorCorreo(String correo) throws SQLException {
        String sql = "SELECT u.id_usuario, u.nombre, u.correo, u.contrasena, u.foto_perfil, u.proveedor, r.nombre AS rol "
                   + "FROM usuarios u INNER JOIN roles r ON u.id_rol = r.id_rol "
                   + "WHERE u.correo = ? AND IFNULL(u.estado, 'ACTIVO') = 'ACTIVO'";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, correo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    /**
     * Busca un usuario por su correo de Google; si no existe lo crea como
     * CLIENTE con proveedor GOOGLE y sin contraseña local utilizable.
     */
    public Usuario loginOrCreateGoogle(String correo, String nombre, String googleId) throws SQLException {
        Usuario existente = buscarPorCorreo(correo);
        if (existente != null) {
            // Vincula el google_id a la cuenta existente si todavía no lo tenía
            try (Connection con = Conexion.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                         "UPDATE usuarios SET google_id = COALESCE(google_id, ?) WHERE id_usuario = ?")) {
                ps.setString(1, googleId);
                ps.setInt(2, existente.getId());
                ps.executeUpdate();
            }
            return existente;
        }

        // No existe: se crea como cliente nuevo autenticado por Google
        String sqlRol = "SELECT id_rol FROM roles WHERE LOWER(nombre) = LOWER('CLIENTE')";
        int idRol = 0;
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sqlRol);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) idRol = rs.getInt(1);
        }

        String sqlIns = "INSERT INTO usuarios(nombre, correo, contrasena, id_rol, estado, proveedor, google_id, fecha_registro) "
                       + "VALUES(?, ?, NULL, ?, 'ACTIVO', 'GOOGLE', ?, NOW())";
        int idUsuario = 0;
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sqlIns, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, nombre);
            ps.setString(2, correo);
            ps.setInt(3, idRol);
            ps.setString(4, googleId);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) idUsuario = rs.getInt(1);
            }
        }

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO duenios(nombre, documento, telefono, correo, direccion, id_usuario) VALUES(?,?,?,?,?,?)")) {
            ps.setString(1, nombre);
            ps.setString(2, "");
            ps.setString(3, "");
            ps.setString(4, correo);
            ps.setString(5, "");
            ps.setInt(6, idUsuario);
            ps.executeUpdate();
        }

        return buscarPorCorreo(correo);
    }

    /** Actualiza nombre y foto de perfil del usuario (perfil editable). */
    public boolean actualizarPerfil(int idUsuario, String nombre, String fotoPerfil) {
        StringBuilder sql = new StringBuilder("UPDATE usuarios SET nombre = ?");
        if (fotoPerfil != null) sql.append(", foto_perfil = ?");
        sql.append(" WHERE id_usuario = ?");

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int i = 1;
            ps.setString(i++, nombre);
            if (fotoPerfil != null) ps.setString(i++, fotoPerfil);
            ps.setInt(i, idUsuario);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
