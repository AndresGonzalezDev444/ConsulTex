package com.consultex.modelo;

/**
 * Modelo de la entidad Paciente.
 */
public class Paciente {
    
    private int idPaciente;
    private int idUsuario;
    private int idMedico; // Puede ser 0 o nulo si no tiene médico asignado
    private String nombreCompleto;
    private String fechaNacimiento;
    private int edad;
    private String sexo;
    private boolean estadoActivo;
    
    // Campos extra para el perfil
    private String nombreMedico;
    private String correo;

    public Paciente() {
    }

    // Getters y Setters
    public int getIdPaciente() { return idPaciente; }
    public void setIdPaciente(int idPaciente) { this.idPaciente = idPaciente; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public int getIdMedico() { return idMedico; }
    public void setIdMedico(int idMedico) { this.idMedico = idMedico; }

    public String getNombreCompleto() { return nombreCompleto; }
    public void setNombreCompleto(String nombreCompleto) { this.nombreCompleto = nombreCompleto; }

    public String getFechaNacimiento() { return fechaNacimiento; }
    public void setFechaNacimiento(String fechaNacimiento) { this.fechaNacimiento = fechaNacimiento; }

    public boolean isEstadoActivo() { return estadoActivo; }
    public void setEstadoActivo(boolean estadoActivo) { this.estadoActivo = estadoActivo; }

    public int getEdad() { return edad; }
    public void setEdad(int edad) { this.edad = edad; }

    public String getSexo() { return sexo; }
    public void setSexo(String sexo) { this.sexo = sexo; }

    public String getNombreMedico() { return nombreMedico; }
    public void setNombreMedico(String nombreMedico) { this.nombreMedico = nombreMedico; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }
}