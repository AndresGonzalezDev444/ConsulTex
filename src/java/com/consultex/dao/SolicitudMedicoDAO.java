package com.consultex.dao;

import com.consultex.config.Conexion;
import com.consultex.modelo.SolicitudMedico;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para la gestión de solicitudes de registro de médicos (F1).
 */
public class SolicitudMedicoDAO {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    /**
     * Registra una nueva solicitud de médico en la BD.
     */
    public boolean registrarSolicitud(SolicitudMedico s) {
        String sql = "INSERT INTO SolicitudMedico (nombre, correo, password, tipo_id, numero_id, edad, sexo, "
                   + "id_especialidad, tiene_especializacion, nombre_especializacion, ruta_pdf_pregrado, ruta_pdf_especializacion) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, s.getNombre());
            ps.setString(2, s.getCorreo());
            ps.setString(3, s.getPassword());
            ps.setString(4, s.getTipoId());
            ps.setString(5, s.getNumeroId());
            ps.setInt(6, s.getEdad());
            ps.setString(7, s.getSexo());
            if (s.getIdEspecialidad() != null) ps.setInt(8, s.getIdEspecialidad());
            else ps.setNull(8, Types.INTEGER);
            ps.setBoolean(9, s.isTieneEspecializacion());
            ps.setString(10, s.getNombreEspecializacion());
            ps.setString(11, s.getRutaPdfPregrado());
            ps.setString(12, s.getRutaPdfEspecializacion());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error registrarSolicitud: " + e.getMessage());
            return false;
        }
    }

    /**
     * Busca el estado de una solicitud por correo (para el login).
     * Retorna null si no existe, "Pendiente" si está en espera.
     */
    public String buscarEstadoPorCorreo(String correo) {
        String sql = "SELECT estado FROM SolicitudMedico WHERE correo = ? ORDER BY fecha_solicitud DESC LIMIT 1";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, correo);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getString("estado");
        } catch (Exception e) {
            System.err.println("Error buscarEstadoPorCorreo: " + e.getMessage());
        }
        return null;
    }

    /**
     * Busca la solicitud completa por correo (para el admin al aprobar).
     */
    public SolicitudMedico buscarPorCorreo(String correo) {
        String sql = "SELECT s.*, e.nombre AS nombre_especialidad FROM SolicitudMedico s "
                   + "LEFT JOIN Especialidad e ON s.id_especialidad = e.id_especialidad "
                   + "WHERE s.correo = ? ORDER BY s.fecha_solicitud DESC LIMIT 1";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, correo);
            rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (Exception e) {
            System.err.println("Error buscarPorCorreo: " + e.getMessage());
        }
        return null;
    }

    /**
     * Busca una solicitud por su ID.
     */
    public SolicitudMedico buscarPorId(int id) {
        String sql = "SELECT s.*, e.nombre AS nombre_especialidad FROM SolicitudMedico s "
                   + "LEFT JOIN Especialidad e ON s.id_especialidad = e.id_especialidad "
                   + "WHERE s.id_solicitud = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (Exception e) {
            System.err.println("Error buscarPorId SolicitudMedico: " + e.getMessage());
        }
        return null;
    }

    /**
     * Lista todas las solicitudes pendientes (para el admin).
     */
    public List<SolicitudMedico> listarPendientes() {
        List<SolicitudMedico> lista = new ArrayList<>();
        String sql = "SELECT s.*, e.nombre AS nombre_especialidad FROM SolicitudMedico s "
                   + "LEFT JOIN Especialidad e ON s.id_especialidad = e.id_especialidad "
                   + "WHERE s.estado = 'Pendiente' ORDER BY s.fecha_solicitud ASC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) lista.add(mapRow(rs));
        } catch (Exception e) {
            System.err.println("Error listarPendientes: " + e.getMessage());
        }
        return lista;
    }

    /**
     * Elimina físicamente la solicitud (rechazo - para liberar el correo).
     */
    public boolean eliminarFisico(int idSolicitud) {
        String sql = "DELETE FROM SolicitudMedico WHERE id_solicitud = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idSolicitud);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error eliminarFisico SolicitudMedico: " + e.getMessage());
            return false;
        }
    }

    /**
     * Verifica si ya existe una solicitud pendiente para ese correo.
     */
    public boolean existeSolicitudPendiente(String correo) {
        String sql = "SELECT COUNT(*) FROM SolicitudMedico WHERE correo = ? AND estado = 'Pendiente'";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, correo);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) {
            System.err.println("Error existeSolicitudPendiente: " + e.getMessage());
        }
        return false;
    }

    private SolicitudMedico mapRow(ResultSet rs) throws Exception {
        SolicitudMedico s = new SolicitudMedico();
        s.setIdSolicitud(rs.getInt("id_solicitud"));
        s.setNombre(rs.getString("nombre"));
        s.setCorreo(rs.getString("correo"));
        s.setPassword(rs.getString("password"));
        s.setTipoId(rs.getString("tipo_id"));
        s.setNumeroId(rs.getString("numero_id"));
        s.setEdad(rs.getInt("edad"));
        s.setSexo(rs.getString("sexo"));
        int idEsp = rs.getInt("id_especialidad");
        s.setIdEspecialidad(rs.wasNull() ? null : idEsp);
        s.setTieneEspecializacion(rs.getBoolean("tiene_especializacion"));
        s.setNombreEspecializacion(rs.getString("nombre_especializacion"));
        s.setRutaPdfPregrado(rs.getString("ruta_pdf_pregrado"));
        s.setRutaPdfEspecializacion(rs.getString("ruta_pdf_especializacion"));
        s.setEstado(rs.getString("estado"));
        s.setFechaSolicitud(rs.getString("fecha_solicitud"));
        try { s.setNombreEspecialidad(rs.getString("nombre_especialidad")); } catch (Exception ex) {}
        return s;
    }
}
