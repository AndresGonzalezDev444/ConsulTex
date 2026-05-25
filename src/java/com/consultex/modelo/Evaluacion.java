package com.consultex.modelo;

public class Evaluacion {
    private int idEvaluacion;
    private int idPaciente;
    private int idMedico;
    private String calificacionMedico;
    private String notaMedico;
    private String calificacionApp;
    private String notaApp;
    private String fechaEvaluacion;
    private boolean estadoActivo = true; // Criterio 11
    
    // Nombres para mostrar en la vista del administrador
    private String nombrePaciente;
    private String nombreMedico;

    public Evaluacion() {
    }

    public int getIdEvaluacion() { return idEvaluacion; }
    public void setIdEvaluacion(int idEvaluacion) { this.idEvaluacion = idEvaluacion; }

    public int getIdPaciente() { return idPaciente; }
    public void setIdPaciente(int idPaciente) { this.idPaciente = idPaciente; }

    public int getIdMedico() { return idMedico; }
    public void setIdMedico(int idMedico) { this.idMedico = idMedico; }

    public String getCalificacionMedico() { return calificacionMedico; }
    public void setCalificacionMedico(String calificacionMedico) { this.calificacionMedico = calificacionMedico; }

    public String getNotaMedico() { return notaMedico; }
    public void setNotaMedico(String notaMedico) { this.notaMedico = notaMedico; }

    public String getCalificacionApp() { return calificacionApp; }
    public void setCalificacionApp(String calificacionApp) { this.calificacionApp = calificacionApp; }

    public String getNotaApp() { return notaApp; }
    public void setNotaApp(String notaApp) { this.notaApp = notaApp; }

    public String getFechaEvaluacion() { return fechaEvaluacion; }
    public void setFechaEvaluacion(String fechaEvaluacion) { this.fechaEvaluacion = fechaEvaluacion; }

    public String getNombrePaciente() { return nombrePaciente; }
    public void setNombrePaciente(String nombrePaciente) { this.nombrePaciente = nombrePaciente; }

    public String getNombreMedico() { return nombreMedico; }
    public void setNombreMedico(String nombreMedico) { this.nombreMedico = nombreMedico; }

    public boolean isEstadoActivo() { return estadoActivo; }
    public void setEstadoActivo(boolean estadoActivo) { this.estadoActivo = estadoActivo; }
}
