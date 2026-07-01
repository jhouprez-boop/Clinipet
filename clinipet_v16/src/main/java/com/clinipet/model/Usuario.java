package com.clinipet.model;

public class Usuario {
    private int id;
    private String nombre;
    private String correo;
    private String rol;
    private String fotoPerfil; // ruta relativa de la imagen de avatar, puede ser null
    private String proveedor;  // "LOCAL" o "GOOGLE"

    // Constructor original (se mantiene por compatibilidad con c-digo existente)
    public Usuario(int id, String nombre, String correo, String rol) {
        this(id, nombre, correo, rol, null, "LOCAL");
    }

    public Usuario(int id, String nombre, String correo, String rol, String fotoPerfil, String proveedor) {
        this.id = id;
        this.nombre = nombre;
        this.correo = correo;
        this.rol = rol;
        this.fotoPerfil = fotoPerfil;
        this.proveedor = proveedor != null ? proveedor : "LOCAL";
    }

    public int getId() { return id; }
    public String getNombre() { return nombre; }
    public String getCorreo() { return correo; }
    public String getRol() { return rol; }
    public String getFotoPerfil() { return fotoPerfil; }
    public String getProveedor() { return proveedor; }

    public void setNombre(String nombre) { this.nombre = nombre; }
    public void setFotoPerfil(String fotoPerfil) { this.fotoPerfil = fotoPerfil; }

    /**
     * Devuelve la URL de avatar lista para usar en una vista (relativa al contexto),
     * o null si el usuario no tiene foto cargada todav-a.
     */
    public String getAvatarUrlOrNull() {
        if (fotoPerfil == null || fotoPerfil.isBlank()) return null;
        return "/assets/img/avatars/" + fotoPerfil;
    }
}
