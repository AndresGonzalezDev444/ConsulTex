package com.consultex.modelo;

/**
 * Modelo de la entidad Usuario.
 */
public class Usuario {
    
    private int idUsuario;
    private String correo;
    private String password;
    private String rol;
    private String fechaRegistro;
    private boolean estadoActivo; 

    // Constructor vacío
    public Usuario() {
    }

    // Constructor con parámetros
    public Usuario(int idUsuario, String correo, String password, String rol, String fechaRegistro, boolean estadoActivo) {
        this.idUsuario = idUsuario;
        this.correo = correo;
        this.password = password;
        this.rol = rol;
        this.fechaRegistro = fechaRegistro;
        this.estadoActivo = estadoActivo;
    }

    // Getters y Setters 
    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }

    public String getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(String fechaRegistro) { this.fechaRegistro = fechaRegistro; }

    public boolean isEstadoActivo() { return estadoActivo; }
    public void setEstadoActivo(boolean estadoActivo) { this.estadoActivo = estadoActivo; }
}