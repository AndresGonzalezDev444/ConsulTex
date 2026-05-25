package com.consultex.modelo;

public class Medicamento {
    private int idMedicamento;
    private int idMedico;
    private int idPaciente;
    private String nombreMedicamento;
    private String dosis;
    private int frecuenciaHoras;
    private String fechaInicio;
    private String fechaFin;
    private boolean estadoActivo = true; // Criterio 11

    // Nombres para mostrar en la UI
    private String nombreMedico;
    private String nombrePaciente;

    public Medicamento() {
    }

    public int getIdMedicamento() { return idMedicamento; }
    public void setIdMedicamento(int idMedicamento) { this.idMedicamento = idMedicamento; }

    public int getIdMedico() { return idMedico; }
    public void setIdMedico(int idMedico) { this.idMedico = idMedico; }

    public int getIdPaciente() { return idPaciente; }
    public void setIdPaciente(int idPaciente) { this.idPaciente = idPaciente; }

    public String getNombreMedicamento() { return nombreMedicamento; }
    public void setNombreMedicamento(String nombreMedicamento) { this.nombreMedicamento = nombreMedicamento; }

    public String getDosis() { return dosis; }
    public void setDosis(String dosis) { this.dosis = dosis; }

    public int getFrecuenciaHoras() { return frecuenciaHoras; }
    public void setFrecuenciaHoras(int frecuenciaHoras) { this.frecuenciaHoras = frecuenciaHoras; }

    public String getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(String fechaInicio) { this.fechaInicio = fechaInicio; }

    public String getFechaFin() { return fechaFin; }
    public void setFechaFin(String fechaFin) { this.fechaFin = fechaFin; }

    public boolean isEstadoActivo() { return estadoActivo; }
    public void setEstadoActivo(boolean estadoActivo) { this.estadoActivo = estadoActivo; }

    public String getNombreMedico() { return nombreMedico; }
    public void setNombreMedico(String nombreMedico) { this.nombreMedico = nombreMedico; }

    public String getNombrePaciente() { return nombrePaciente; }
    public void setNombrePaciente(String nombrePaciente) { this.nombrePaciente = nombrePaciente; }
}
