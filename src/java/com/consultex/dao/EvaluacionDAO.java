package com.consultex.dao;

import com.consultex.config.Conexion;
import com.consultex.modelo.Evaluacion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class EvaluacionDAO {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public boolean registrarEvaluacion(Evaluacion eval) {
        String sql = "INSERT INTO Evaluacion (id_paciente, id_medico, calificacion_medico, nota_medico, calificacion_app, nota_app) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, eval.getIdPaciente());
            if (eval.getIdMedico() > 0) {
                ps.setInt(2, eval.getIdMedico());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setString(3, eval.getCalificacionMedico());
            ps.setString(4, eval.getNotaMedico());
            ps.setString(5, eval.getCalificacionApp());
            ps.setString(6, eval.getNotaApp());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error al registrar evaluacion: " + e.getMessage());
            return false;
        }
    }

    public List<Evaluacion> listarEvaluaciones() {
        List<Evaluacion> lista = new ArrayList<>();
        String sql = "SELECT e.*, p.nombre_completo AS nombre_paciente, m.nombre_completo AS nombre_medico " +
                     "FROM Evaluacion e " +
                     "LEFT JOIN Paciente p ON e.id_paciente = p.id_paciente " +
                     "LEFT JOIN Medico m ON e.id_medico = m.id_medico ORDER BY e.fecha_evaluacion DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Evaluacion e = new Evaluacion();
                e.setIdEvaluacion(rs.getInt("id_evaluacion"));
                e.setIdPaciente(rs.getInt("id_paciente"));
                e.setIdMedico(rs.getInt("id_medico"));
                e.setCalificacionMedico(rs.getString("calificacion_medico"));
                e.setNotaMedico(rs.getString("nota_medico"));
                e.setCalificacionApp(rs.getString("calificacion_app"));
                e.setNotaApp(rs.getString("nota_app"));
                e.setFechaEvaluacion(rs.getString("fecha_evaluacion"));
                e.setNombrePaciente(rs.getString("nombre_paciente"));
                e.setNombreMedico(rs.getString("nombre_medico"));
                lista.add(e);
            }
        } catch (Exception e) {
            System.err.println("Error al listar evaluaciones: " + e.getMessage());
        }
        return lista;
    }

    // BORRADO LOGICO - Criterio 12
    public boolean eliminarLogico(int idEvaluacion) {
        String sql = "UPDATE Evaluacion SET estado_activo = false WHERE id_evaluacion = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idEvaluacion);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error eliminarLogico Evaluacion: " + e.getMessage());
            return false;
        }
    }

    // BUSCAR POR PK - Criterio 13
    public Evaluacion buscarPorId(int idEvaluacion) {
        String sql = "SELECT e.*, p.nombre_completo AS nombre_paciente, m.nombre_completo AS nombre_medico "
                   + "FROM Evaluacion e "
                   + "LEFT JOIN Paciente p ON e.id_paciente = p.id_paciente "
                   + "LEFT JOIN Medico m ON e.id_medico = m.id_medico "
                   + "WHERE e.id_evaluacion = ? AND e.estado_activo = true";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idEvaluacion);
            rs = ps.executeQuery();
            if (rs.next()) {
                Evaluacion e = new Evaluacion();
                e.setIdEvaluacion(rs.getInt("id_evaluacion"));
                e.setIdPaciente(rs.getInt("id_paciente"));
                e.setIdMedico(rs.getInt("id_medico"));
                e.setCalificacionMedico(rs.getString("calificacion_medico"));
                e.setNotaMedico(rs.getString("nota_medico"));
                e.setCalificacionApp(rs.getString("calificacion_app"));
                e.setNotaApp(rs.getString("nota_app"));
                e.setFechaEvaluacion(rs.getString("fecha_evaluacion"));
                e.setNombrePaciente(rs.getString("nombre_paciente"));
                e.setNombreMedico(rs.getString("nombre_medico"));
                return e;
            }
        } catch (Exception e) {
            System.err.println("Error buscarPorId Evaluacion: " + e.getMessage());
        }
        return null;
    }
}
