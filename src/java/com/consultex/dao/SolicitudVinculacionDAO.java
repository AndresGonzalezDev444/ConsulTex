package com.consultex.dao;

import com.consultex.config.Conexion;
import com.consultex.modelo.SolicitudVinculacion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para la gestión de solicitudes de vinculación médico-paciente (F4).
 */
public class SolicitudVinculacionDAO {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    /**
     * Registra una nueva solicitud de vinculación.
     * Si ya existe una para ese par médico-paciente, la restaura a Pendiente.
     */
    public boolean solicitar(int idMedico, int idPaciente) {
        // Intentar INSERT; si ya existe (UNIQUE KEY), actualizar a Pendiente
        String sqlCheck = "SELECT id_solicitud, estado FROM SolicitudVinculacion WHERE id_medico = ? AND id_paciente = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sqlCheck);
            ps.setInt(1, idMedico);
            ps.setInt(2, idPaciente);
            rs = ps.executeQuery();
            if (rs.next()) {
                // Ya existe: si fue rechazada, la reabre
                String estado = rs.getString("estado");
                int idSol = rs.getInt("id_solicitud");
                if ("Rechazada".equalsIgnoreCase(estado)) {
                    String sqlUpd = "UPDATE SolicitudVinculacion SET estado = 'Pendiente', fecha_solicitud = NOW() WHERE id_solicitud = ?";
                    ps = con.prepareStatement(sqlUpd);
                    ps.setInt(1, idSol);
                    ps.executeUpdate();
                    return true;
                }
                // Si ya está Pendiente o Aprobada, no hacer nada
                return false;
            }
            // No existe: insertar
            String sqlIns = "INSERT INTO SolicitudVinculacion (id_medico, id_paciente) VALUES (?, ?)";
            ps = con.prepareStatement(sqlIns);
            ps.setInt(1, idMedico);
            ps.setInt(2, idPaciente);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error solicitar vinculacion: " + e.getMessage());
            return false;
        }
    }

    /**
     * Verifica si un médico ya tiene solicitud PENDIENTE para un paciente específico.
     */
    public boolean tieneSolicitudPendiente(int idMedico, int idPaciente) {
        String sql = "SELECT COUNT(*) FROM SolicitudVinculacion WHERE id_medico = ? AND id_paciente = ? AND estado = 'Pendiente'";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idMedico);
            ps.setInt(2, idPaciente);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) {
            System.err.println("Error tieneSolicitudPendiente: " + e.getMessage());
        }
        return false;
    }

    /**
     * Lista todas las solicitudes pendientes (para el admin).
     */
    public List<SolicitudVinculacion> listarPendientes() {
        List<SolicitudVinculacion> lista = new ArrayList<>();
        String sql = "SELECT sv.*, m.nombre_completo AS nombre_medico, m.especialidad AS especialidad_medico, "
                   + "p.nombre_completo AS nombre_paciente "
                   + "FROM SolicitudVinculacion sv "
                   + "INNER JOIN Medico m ON sv.id_medico = m.id_medico "
                   + "INNER JOIN Paciente p ON sv.id_paciente = p.id_paciente "
                   + "WHERE sv.estado = 'Pendiente' ORDER BY sv.fecha_solicitud ASC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                SolicitudVinculacion s = new SolicitudVinculacion();
                s.setIdSolicitud(rs.getInt("id_solicitud"));
                s.setIdMedico(rs.getInt("id_medico"));
                s.setIdPaciente(rs.getInt("id_paciente"));
                s.setEstado(rs.getString("estado"));
                s.setFechaSolicitud(rs.getString("fecha_solicitud"));
                s.setNombreMedico(rs.getString("nombre_medico"));
                s.setNombrePaciente(rs.getString("nombre_paciente"));
                s.setEspecialidadMedico(rs.getString("especialidad_medico"));
                lista.add(s);
            }
        } catch (Exception e) {
            System.err.println("Error listarPendientes vinculacion: " + e.getMessage());
        }
        return lista;
    }

    /**
     * Aprueba una solicitud: vincula el paciente al médico y actualiza estado.
     * Usa transacción para garantizar consistencia.
     */
    public boolean aprobar(int idSolicitud, int idMedico, int idPaciente) {
        try {
            con = cn.getConnection();
            con.setAutoCommit(false);

            // 1. Actualizar estado de la solicitud
            ps = con.prepareStatement("UPDATE SolicitudVinculacion SET estado = 'Aprobada' WHERE id_solicitud = ?");
            ps.setInt(1, idSolicitud);
            ps.executeUpdate();

            // 2. Vincular paciente al médico
            PreparedStatement psVinc = con.prepareStatement("UPDATE Paciente SET id_medico = ? WHERE id_paciente = ?");
            psVinc.setInt(1, idMedico);
            psVinc.setInt(2, idPaciente);
            psVinc.executeUpdate();

            // 3. Rechazar otras solicitudes pendientes para ese mismo paciente
            PreparedStatement psReject = con.prepareStatement(
                "UPDATE SolicitudVinculacion SET estado = 'Rechazada' WHERE id_paciente = ? AND id_solicitud != ? AND estado = 'Pendiente'"
            );
            psReject.setInt(1, idPaciente);
            psReject.setInt(2, idSolicitud);
            psReject.executeUpdate();

            con.commit();
            return true;
        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            System.err.println("Error aprobar vinculacion: " + e.getMessage());
            return false;
        } finally {
            try { if (con != null) con.setAutoCommit(true); } catch (Exception e) {}
        }
    }

    /**
     * Rechaza la solicitud y la elimina físicamente (el médico puede volver a solicitar).
     */
    public boolean rechazar(int idSolicitud) {
        String sql = "DELETE FROM SolicitudVinculacion WHERE id_solicitud = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idSolicitud);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error rechazar vinculacion: " + e.getMessage());
            return false;
        }
    }
}
