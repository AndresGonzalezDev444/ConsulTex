package com.consultex.dao;

import com.consultex.config.Conexion;
import com.consultex.modelo.Medicamento;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para la entidad Medicamento. Implementa CRUD completo y borrado lógico.
 * Criterios 9, 10, 11, 12 y 13.
 */
public class MedicamentoDAO {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // CREAR - Criterio 12
    public void registrar(Medicamento m) throws Exception {
        // Quitamos estado_activo por si la BD antigua no lo tiene, o usamos la original
        String sql = "INSERT INTO Medicamento (id_medico, id_paciente, nombre_medicamento, dosis, frecuencia_horas, fecha_inicio, fecha_fin) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        con = cn.getConnection();
        ps = con.prepareStatement(sql);
        ps.setInt(1, m.getIdMedico());
        ps.setInt(2, m.getIdPaciente());
        ps.setString(3, m.getNombreMedicamento());
        ps.setString(4, m.getDosis());
        ps.setInt(5, m.getFrecuenciaHoras());
        ps.setString(6, m.getFechaInicio());
        ps.setString(7, m.getFechaFin());
        ps.executeUpdate();
    }

    // LEER: Medicamentos de un paciente específico (activos) - Criterio 13
    public List<Medicamento> listarPorPaciente(int idPaciente) {
        List<Medicamento> lista = new ArrayList<>();
        String sql = "SELECT med.*, m.nombre_completo AS nombre_medico FROM Medicamento med "
                   + "INNER JOIN Medico m ON med.id_medico = m.id_medico "
                   + "WHERE med.id_paciente = ? AND med.estado_activo = true "
                   + "ORDER BY med.fecha_inicio DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idPaciente);
            rs = ps.executeQuery();
            while (rs.next()) {
                Medicamento med = mapRow(rs);
                lista.add(med);
            }
        } catch (Exception e) {
            System.err.println("Error listarPorPaciente Medicamento: " + e.getMessage());
        }
        return lista;
    }

    // LEER: Medicamentos recetados por un médico - Criterio 13
    public List<Medicamento> listarPorMedico(int idMedico) {
        List<Medicamento> lista = new ArrayList<>();
        String sql = "SELECT med.*, p.nombre_completo AS nombre_paciente FROM Medicamento med "
                   + "INNER JOIN Paciente p ON med.id_paciente = p.id_paciente "
                   + "WHERE med.id_medico = ? AND med.estado_activo = true "
                   + "ORDER BY med.fecha_inicio DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idMedico);
            rs = ps.executeQuery();
            while (rs.next()) {
                Medicamento med = mapRow(rs);
                lista.add(med);
            }
        } catch (Exception e) {
            System.err.println("Error listarPorMedico Medicamento: " + e.getMessage());
        }
        return lista;
    }

    // LEER: Buscar por PK - Criterio 13
    public Medicamento buscarPorId(int id) {
        String sql = "SELECT med.*, m.nombre_completo AS nombre_medico, p.nombre_completo AS nombre_paciente "
                   + "FROM Medicamento med "
                   + "INNER JOIN Medico m ON med.id_medico = m.id_medico "
                   + "INNER JOIN Paciente p ON med.id_paciente = p.id_paciente "
                   + "WHERE med.id_medicamento = ? AND med.estado_activo = true";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (Exception e) {
            System.err.println("Error buscarPorId Medicamento: " + e.getMessage());
        }
        return null;
    }

    // ACTUALIZAR - Criterio 12
    public boolean actualizar(Medicamento m) {
        String sql = "UPDATE Medicamento SET nombre_medicamento = ?, dosis = ?, frecuencia_horas = ?, fecha_inicio = ?, fecha_fin = ? "
                   + "WHERE id_medicamento = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, m.getNombreMedicamento());
            ps.setString(2, m.getDosis());
            ps.setInt(3, m.getFrecuenciaHoras());
            ps.setString(4, m.getFechaInicio());
            ps.setString(5, m.getFechaFin());
            ps.setInt(6, m.getIdMedicamento());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error al actualizar Medicamento: " + e.getMessage());
            return false;
        }
    }

    // BORRADO LÓGICO - Criterio 12
    public boolean eliminarLogico(int id) {
        String sql = "UPDATE Medicamento SET estado_activo = false WHERE id_medicamento = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error eliminarLogico Medicamento: " + e.getMessage());
            return false;
        }
    }

    // Helper: mapear ResultSet a objeto
    private Medicamento mapRow(ResultSet rs) throws Exception {
        Medicamento med = new Medicamento();
        med.setIdMedicamento(rs.getInt("id_medicamento"));
        med.setIdMedico(rs.getInt("id_medico"));
        med.setIdPaciente(rs.getInt("id_paciente"));
        med.setNombreMedicamento(rs.getString("nombre_medicamento"));
        med.setDosis(rs.getString("dosis"));
        med.setFrecuenciaHoras(rs.getInt("frecuencia_horas"));
        med.setFechaInicio(rs.getString("fecha_inicio"));
        med.setFechaFin(rs.getString("fecha_fin"));
        med.setEstadoActivo(rs.getBoolean("estado_activo"));
        try { med.setNombreMedico(rs.getString("nombre_medico")); } catch (Exception ex) {}
        try { med.setNombrePaciente(rs.getString("nombre_paciente")); } catch (Exception ex) {}
        return med;
    }
}
