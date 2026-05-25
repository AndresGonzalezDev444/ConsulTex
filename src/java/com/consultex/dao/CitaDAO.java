package com.consultex.dao;

import com.consultex.config.Conexion;
import com.consultex.modelo.Cita;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CitaDAO {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public boolean agendarCita(Cita c) {
        String sql = "INSERT INTO Cita (id_medico, id_paciente, fecha_hora, estado) VALUES (?, ?, ?, 'Programada')";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, c.getIdMedico());
            ps.setInt(2, c.getIdPaciente());
            ps.setString(3, c.getFechaHora());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error al agendar cita: " + e.getMessage());
            return false;
        }
    }

    public List<Cita> listarCitasPorMedico(int idMedico) {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.*, p.nombre_completo AS nombre_paciente FROM Cita c "
                   + "INNER JOIN Paciente p ON c.id_paciente = p.id_paciente "
                   + "WHERE c.id_medico = ? ORDER BY c.fecha_hora ASC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idMedico);
            rs = ps.executeQuery();
            while (rs.next()) {
                Cita c = new Cita();
                c.setIdCita(rs.getInt("id_cita"));
                c.setIdMedico(rs.getInt("id_medico"));
                c.setIdPaciente(rs.getInt("id_paciente"));
                c.setFechaHora(rs.getString("fecha_hora"));
                c.setEstado(rs.getString("estado"));
                c.setNombrePaciente(rs.getString("nombre_paciente"));
                lista.add(c);
            }
        } catch (Exception e) {
            System.err.println("Error listarCitasPorMedico: " + e.getMessage());
        }
        return lista;
    }

    public List<Cita> listarCitasPorPaciente(int idPaciente) {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.*, m.nombre_completo AS nombre_medico FROM Cita c "
                   + "INNER JOIN Medico m ON c.id_medico = m.id_medico "
                   + "WHERE c.id_paciente = ? ORDER BY c.fecha_hora DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idPaciente);
            rs = ps.executeQuery();
            while (rs.next()) {
                Cita c = new Cita();
                c.setIdCita(rs.getInt("id_cita"));
                c.setIdMedico(rs.getInt("id_medico"));
                c.setIdPaciente(rs.getInt("id_paciente"));
                c.setFechaHora(rs.getString("fecha_hora"));
                c.setEstado(rs.getString("estado"));
                c.setNombreMedico(rs.getString("nombre_medico"));
                lista.add(c);
            }
        } catch (Exception e) {
            System.err.println("Error listarCitasPorPaciente: " + e.getMessage());
        }
        return lista;
    }

    public List<Cita> listarTodasCitas() {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.*, m.nombre_completo AS nombre_medico, p.nombre_completo AS nombre_paciente FROM Cita c "
                   + "INNER JOIN Medico m ON c.id_medico = m.id_medico "
                   + "INNER JOIN Paciente p ON c.id_paciente = p.id_paciente "
                   + "ORDER BY c.fecha_hora DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Cita c = new Cita();
                c.setIdCita(rs.getInt("id_cita"));
                c.setIdMedico(rs.getInt("id_medico"));
                c.setIdPaciente(rs.getInt("id_paciente"));
                c.setFechaHora(rs.getString("fecha_hora"));
                c.setEstado(rs.getString("estado"));
                c.setNombreMedico(rs.getString("nombre_medico"));
                c.setNombrePaciente(rs.getString("nombre_paciente"));
                lista.add(c);
            }
        } catch (Exception e) {
            System.err.println("Error listarTodasCitas: " + e.getMessage());
        }
        return lista;
    }

    public boolean actualizarCita(int idCita, String nuevaFechaHora) {
        String sql = "UPDATE Cita SET fecha_hora = ?, estado = 'Reprogramada' WHERE id_cita = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, nuevaFechaHora);
            ps.setInt(2, idCita);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error actualizarCita: " + e.getMessage());
            return false;
        }
    }

    public boolean cancelarCita(int idCita) {
        String sql = "UPDATE Cita SET estado = 'Cancelada' WHERE id_cita = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idCita);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error cancelarCita: " + e.getMessage());
            return false;
        }
    }

    // BORRADO LOGICO - Criterio 12
    public boolean eliminarLogico(int idCita) {
        String sql = "UPDATE Cita SET estado_activo = false WHERE id_cita = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idCita);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error eliminarLogico Cita: " + e.getMessage());
            return false;
        }
    }

    // BUSCAR POR PK - Criterio 13
    public Cita buscarPorId(int idCita) {
        String sql = "SELECT c.*, m.nombre_completo AS nombre_medico, p.nombre_completo AS nombre_paciente "
                   + "FROM Cita c "
                   + "INNER JOIN Medico m ON c.id_medico = m.id_medico "
                   + "INNER JOIN Paciente p ON c.id_paciente = p.id_paciente "
                   + "WHERE c.id_cita = ? AND c.estado_activo = true";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idCita);
            rs = ps.executeQuery();
            if (rs.next()) {
                Cita c = new Cita();
                c.setIdCita(rs.getInt("id_cita"));
                c.setIdMedico(rs.getInt("id_medico"));
                c.setIdPaciente(rs.getInt("id_paciente"));
                c.setFechaHora(rs.getString("fecha_hora"));
                c.setEstado(rs.getString("estado"));
                c.setNombreMedico(rs.getString("nombre_medico"));
                c.setNombrePaciente(rs.getString("nombre_paciente"));
                return c;
            }
        } catch (Exception e) {
            System.err.println("Error buscarPorId Cita: " + e.getMessage());
        }
        return null;
    }
}
