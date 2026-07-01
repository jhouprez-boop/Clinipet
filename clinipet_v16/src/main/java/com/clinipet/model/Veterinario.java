package com.clinipet.model;

public class Veterinario {
    
    private int id;
    private String nombre;
    private String correo; 
    private String telefono; // ← Agregado para solucionar el error de compilación
    private String specialty; // Corresponde a especialidad en español
    private String especialidad;
    private String estado;

    public Veterinario() {
    }

    public Veterinario(int id, String nombre, String correo, String telefono, String especialidad, String estado) {
        this.id = id;
        this.nombre = nombre;
        this.correo = correo;
        this.telefono = telefono;
        this.especialidad = especialidad;
        this.estado = estado;
    }

    // ==========================================
    //          MÉTODOS GETTERS Y SETTERS
    // ==========================================

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getEspecialidad() {
        return especialidad;
    }

    public void setEspecialidad(String especialidad) {
        this.especialidad = especialidad;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}