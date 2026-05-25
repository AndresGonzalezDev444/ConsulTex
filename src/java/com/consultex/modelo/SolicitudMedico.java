package com.consultex.modelo;

/**
 * Modelo para las solicitudes de registro de médicos (F1).
 */
public class SolicitudMedico {
    private int idSolicitud;
    private String nombre;
    private String correo;
    private String password;
    private String tipoId;
    private String numeroId;
    private int edad;
    private String sexo;
    private Integer idEspecialidad;
    private boolean tieneEspecializacion;
    private String nombreEspecializacion;
    private String rutaPdfPregrado;
    private String rutaPdfEspecializacion;
    private String estado; // Pendiente, Aprobado, Rechazado
    private String fechaSolicitud;

    // Nombre de la especialidad (JOIN con tabla Especialidad)
    private String nombreEspecialidad;

    public SolicitudMedico() {}

    public int getIdSolicitud() { return idSolicitud; }
    public void setIdSolicitud(int idSolicitud) { this.idSolicitud = idSolicitud; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getTipoId() { return tipoId; }
    public void setTipoId(String tipoId) { this.tipoId = tipoId; }
    public String getNumeroId() { return numeroId; }
    public void setNumeroId(String numeroId) { this.numeroId = numeroId; }
    public int getEdad() { return edad; }
    public void setEdad(int edad) { this.edad = edad; }
    public String getSexo() { return sexo; }
    public void setSexo(String sexo) { this.sexo = sexo; }
    public Integer getIdEspecialidad() { return idEspecialidad; }
    public void setIdEspecialidad(Integer idEspecialidad) { this.idEspecialidad = idEspecialidad; }
    public boolean isTieneEspecializacion() { return tieneEspecializacion; }
    public void setTieneEspecializacion(boolean tieneEspecializacion) { this.tieneEspecializacion = tieneEspecializacion; }
    public String getNombreEspecializacion() { return nombreEspecializacion; }
    public void setNombreEspecializacion(String nombreEspecializacion) { this.nombreEspecializacion = nombreEspecializacion; }
    public String getRutaPdfPregrado() { return rutaPdfPregrado; }
    public void setRutaPdfPregrado(String rutaPdfPregrado) { this.rutaPdfPregrado = rutaPdfPregrado; }
    public String getRutaPdfEspecializacion() { return rutaPdfEspecializacion; }
    public void setRutaPdfEspecializacion(String rutaPdfEspecializacion) { this.rutaPdfEspecializacion = rutaPdfEspecializacion; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public String getFechaSolicitud() { return fechaSolicitud; }
    public void setFechaSolicitud(String fechaSolicitud) { this.fechaSolicitud = fechaSolicitud; }
    public String getNombreEspecialidad() { return nombreEspecialidad; }
    public void setNombreEspecialidad(String nombreEspecialidad) { this.nombreEspecialidad = nombreEspecialidad; }
}
