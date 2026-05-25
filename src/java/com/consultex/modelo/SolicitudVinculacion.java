package com.consultex.modelo;

/**
 * Modelo para las solicitudes de vinculación médico-paciente (F4).
 */
public class SolicitudVinculacion {
    private int idSolicitud;
    private int idMedico;
    private int idPaciente;
    private String estado; // Pendiente, Aprobada, Rechazada
    private String fechaSolicitud;

    // Nombres para mostrar en la UI del admin
    private String nombreMedico;
    private String nombrePaciente;
    private String especialidadMedico;

    public SolicitudVinculacion() {}

    public int getIdSolicitud() { return idSolicitud; }
    public void setIdSolicitud(int idSolicitud) { this.idSolicitud = idSolicitud; }
    public int getIdMedico() { return idMedico; }
    public void setIdMedico(int idMedico) { this.idMedico = idMedico; }
    public int getIdPaciente() { return idPaciente; }
    public void setIdPaciente(int idPaciente) { this.idPaciente = idPaciente; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public String getFechaSolicitud() { return fechaSolicitud; }
    public void setFechaSolicitud(String fechaSolicitud) { this.fechaSolicitud = fechaSolicitud; }
    public String getNombreMedico() { return nombreMedico; }
    public void setNombreMedico(String nombreMedico) { this.nombreMedico = nombreMedico; }
    public String getNombrePaciente() { return nombrePaciente; }
    public void setNombrePaciente(String nombrePaciente) { this.nombrePaciente = nombrePaciente; }
    public String getEspecialidadMedico() { return especialidadMedico; }
    public void setEspecialidadMedico(String especialidadMedico) { this.especialidadMedico = especialidadMedico; }
}
