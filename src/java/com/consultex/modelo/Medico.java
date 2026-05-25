package com.consultex.modelo;

/**
 * Modelo para la entidad Medico.
 */
public class Medico {
    private int idMedico;
    private int idUsuario;
    private String nombreCompleto;
    private String especialidad;
    private String numeroLicencia;
    private int edad;
    private String sexo;
    private boolean estadoActivo;
    private String tipoIdentificacion;
    private String numeroIdentificacion;

    // Campos calculados (para listados con JOIN)
    private int totalPacientes;
    private String correoUsuario;

    public Medico() {}

    public int getIdMedico() { return idMedico; }
    public void setIdMedico(int idMedico) { this.idMedico = idMedico; }
    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }
    public String getNombreCompleto() { return nombreCompleto; }
    public void setNombreCompleto(String nombreCompleto) { this.nombreCompleto = nombreCompleto; }
    public String getEspecialidad() { return especialidad; }
    public void setEspecialidad(String especialidad) { this.especialidad = especialidad; }
    public String getNumeroLicencia() { return numeroLicencia; }
    public void setNumeroLicencia(String numeroLicencia) { this.numeroLicencia = numeroLicencia; }
    public int getEdad() { return edad; }
    public void setEdad(int edad) { this.edad = edad; }
    public String getSexo() { return sexo; }
    public void setSexo(String sexo) { this.sexo = sexo; }
    public boolean isEstadoActivo() { return estadoActivo; }
    public void setEstadoActivo(boolean estadoActivo) { this.estadoActivo = estadoActivo; }
    public String getTipoIdentificacion() { return tipoIdentificacion; }
    public void setTipoIdentificacion(String tipoIdentificacion) { this.tipoIdentificacion = tipoIdentificacion; }
    public String getNumeroIdentificacion() { return numeroIdentificacion; }
    public void setNumeroIdentificacion(String numeroIdentificacion) { this.numeroIdentificacion = numeroIdentificacion; }
    public int getTotalPacientes() { return totalPacientes; }
    public void setTotalPacientes(int totalPacientes) { this.totalPacientes = totalPacientes; }
    public String getCorreoUsuario() { return correoUsuario; }
    public void setCorreoUsuario(String correoUsuario) { this.correoUsuario = correoUsuario; }
}
