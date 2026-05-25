package com.consultex.dao;

import com.consultex.config.Conexion;
import com.consultex.modelo.Consulta;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConsultaDAO {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public String registrarConsultaSegura(Consulta c) {
        String sql = "INSERT INTO Consulta (id_paciente, id_medico, fecha_consulta, motivo_consulta, diagnostico, presion_arterial, temperatura, frecuencia_cardiaca, peso, estatura) VALUES (?,?,?,?,?,?,?,?,?,?)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, c.getIdPaciente());
            ps.setInt(2, c.getIdMedico());
            ps.setString(3, c.getFecha());
            ps.setString(4, c.getMotivo());
            ps.setString(5, c.getDiagnostico());
            ps.setString(6, c.getPresionArterial());
            ps.setDouble(7, c.getTemperatura());
            ps.setInt(8, c.getFrecuenciaCardiaca());
            ps.setDouble(9, c.getPeso());
            ps.setDouble(10, c.getEstatura());
            ps.executeUpdate();
            return "OK";
        } catch (Exception e) {
            return e.getMessage();
        }
    }
    
    public List<Consulta> listarPorPaciente(int idPaciente) {
        List<Consulta> lista = new ArrayList<>();
        String sql = "SELECT c.*, m.nombre_completo AS nombre_medico FROM Consulta c LEFT JOIN Medico m ON c.id_medico = m.id_medico WHERE c.id_paciente = ? AND c.estado_activo = true ORDER BY c.fecha_consulta DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idPaciente);
            rs = ps.executeQuery();
            while (rs.next()) {
                Consulta c = new Consulta();
                c.setIdConsulta(rs.getInt("id_consulta"));
                c.setFecha(rs.getString("fecha_consulta"));
                c.setMotivo(rs.getString("motivo_consulta"));
                c.setDiagnostico(rs.getString("diagnostico"));
                c.setPresionArterial(rs.getString("presion_arterial"));
                c.setTemperatura(rs.getDouble("temperatura"));
                c.setFrecuenciaCardiaca(rs.getInt("frecuencia_cardiaca"));
                c.setPeso(rs.getDouble("peso"));
                c.setEstatura(rs.getDouble("estatura"));
                c.setNombreMedico(rs.getString("nombre_medico") != null ? rs.getString("nombre_medico") : "Desconocido");
                lista.add(c);
            }
        } catch (Exception e) {
            System.err.println("Error historial paciente: " + e.getMessage());
        }
        return lista;
    }

    // Alias para ser usado por ControladorPDF (Criterio 15)
    public List<Consulta> obtenerHistorialPorPaciente(int idPaciente) {
        return listarPorPaciente(idPaciente);
    }

    // BUSCAR POR PK - Criterio 13
    public Consulta buscarPorId(int idConsulta) {
        String sql = "SELECT c.*, m.nombre_completo AS nombre_medico FROM Consulta c "
                   + "LEFT JOIN Medico m ON c.id_medico = m.id_medico "
                   + "WHERE c.id_consulta = ? AND c.estado_activo = true";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idConsulta);
            rs = ps.executeQuery();
            if (rs.next()) {
                Consulta c = new Consulta();
                c.setIdConsulta(rs.getInt("id_consulta"));
                c.setIdPaciente(rs.getInt("id_paciente"));
                c.setIdMedico(rs.getInt("id_medico"));
                c.setFecha(rs.getString("fecha_consulta"));
                c.setMotivo(rs.getString("motivo_consulta"));
                c.setDiagnostico(rs.getString("diagnostico"));
                c.setPresionArterial(rs.getString("presion_arterial"));
                c.setTemperatura(rs.getDouble("temperatura"));
                c.setFrecuenciaCardiaca(rs.getInt("frecuencia_cardiaca"));
                c.setPeso(rs.getDouble("peso"));
                c.setEstatura(rs.getDouble("estatura"));
                c.setNombreMedico(rs.getString("nombre_medico"));
                return c;
            }
        } catch (Exception e) {
            System.err.println("Error buscarPorId Consulta: " + e.getMessage());
        }
        return null;
    }

    // BORRADO LÓGICO - Criterio 12
    public boolean eliminarLogico(int idConsulta) {
        String sql = "UPDATE Consulta SET estado_activo = false WHERE id_consulta = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idConsulta);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error eliminarLogico Consulta: " + e.getMessage());
            return false;
        }
    }
}