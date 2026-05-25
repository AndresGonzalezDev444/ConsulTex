package com.consultex.dao;

import com.consultex.config.Conexion;
import com.consultex.modelo.Paciente;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * Clase DAO para la entidad Paciente (CRUD y Lógica de Negocio).
 */
public class PacienteDAO {
    
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // LEER: Listar pacientes sin médico asignado
    public List<Paciente> listarPacientesDisponibles() {
        List<Paciente> lista = new ArrayList<>();
        // Regla: Pacientes activos y que no tengan médico o cuyo médico esté inactivo
        String sql = "SELECT p.* FROM Paciente p " +
                     "LEFT JOIN Medico med ON p.id_medico = med.id_medico " +
                     "LEFT JOIN Usuario m ON med.id_usuario = m.id_usuario " +
                     "WHERE (p.id_medico IS NULL OR m.estado_activo = false) AND p.estado_activo = true";
        
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Paciente p = new Paciente();
                p.setIdPaciente(rs.getInt("id_paciente"));
                p.setIdUsuario(rs.getInt("id_usuario"));
                // id_medico no lo seteamos porque sabemos que es NULL en esta consulta
                p.setNombreCompleto(rs.getString("nombre_completo"));
                p.setFechaNacimiento(rs.getString("fecha_nacimiento"));
                p.setEstadoActivo(rs.getBoolean("estado_activo"));
                lista.add(p);
            }
        } catch (Exception e) {
            System.err.println("Error al listar pacientes disponibles: " + e.getMessage());
        }
        return lista;
    }

    //ACTUALIZAR: Vincular paciente a un médico
    public boolean vincularPacienteAMedico(int idPaciente, int idMedico) {
        // Actualizamos el id_medico del paciente específico
        String sql = "UPDATE Paciente SET id_medico = ? WHERE id_paciente = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idMedico);
            ps.setInt(2, idPaciente);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error al vincular paciente: " + e.getMessage());
            return false;
        }
    }
    
    // 3. LEER: Listar los pacientes de un médico específico (Mis Pacientes)
    public List<Paciente> listarPacientesPorMedico(int idMedico) {
        List<Paciente> lista = new ArrayList<>();
        String sql = "SELECT * FROM Paciente WHERE id_medico = ? AND estado_activo = true";
        
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idMedico);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Paciente p = new Paciente();
                p.setIdPaciente(rs.getInt("id_paciente"));
                p.setIdUsuario(rs.getInt("id_usuario"));
                p.setIdMedico(rs.getInt("id_medico"));
                p.setNombreCompleto(rs.getString("nombre_completo"));
                p.setFechaNacimiento(rs.getString("fecha_nacimiento"));
                p.setEstadoActivo(rs.getBoolean("estado_activo"));
                lista.add(p);
            }
        } catch (Exception e) {
            System.err.println("Error al listar mis pacientes: " + e.getMessage());
        }
        return lista;
    }
    
    public int obtenerIdPacientePorUsuario(int idUsuario) {
        int id = 0;
        String sql = "SELECT id_paciente FROM Paciente WHERE id_usuario = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();
            if (rs.next()) id = rs.getInt("id_paciente");
        } catch (Exception e) {}
        return id;
    }

    public int obtenerMedicoDePaciente(int idPaciente) {
        int idMedico = 0;
        String sql = "SELECT id_medico FROM Paciente WHERE id_paciente = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idPaciente);
            rs = ps.executeQuery();
            if (rs.next()) {
                idMedico = rs.getInt("id_medico");
                // getInt returns 0 if the value in DB is SQL NULL
            }
        } catch (Exception e) {}
        return idMedico;
    }

    public boolean desvincularPaciente(int idPaciente) {
        String sql = "UPDATE Paciente SET id_medico = NULL WHERE id_paciente = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idPaciente);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public Paciente obtenerPerfilPaciente(int idUsuario) {
        Paciente p = new Paciente();
        String sql = "SELECT p.*, u.correo, m.nombre_completo AS nombre_medico " +
                     "FROM Paciente p " +
                     "INNER JOIN Usuario u ON p.id_usuario = u.id_usuario " +
                     "LEFT JOIN Medico m ON p.id_medico = m.id_medico " +
                     "WHERE p.id_usuario = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();
            if (rs.next()) {
                p.setIdPaciente(rs.getInt("id_paciente"));
                p.setIdUsuario(rs.getInt("id_usuario"));
                p.setIdMedico(rs.getInt("id_medico"));
                p.setNombreCompleto(rs.getString("nombre_completo"));
                p.setFechaNacimiento(rs.getString("fecha_nacimiento"));
                p.setEdad(rs.getInt("edad"));
                p.setSexo(rs.getString("sexo"));
                p.setEstadoActivo(rs.getBoolean("estado_activo"));
                p.setCorreo(rs.getString("correo"));
                p.setNombreMedico(rs.getString("nombre_medico") != null ? rs.getString("nombre_medico") : "Sin Médico Asignado");
            }
        } catch (Exception e) {
            System.err.println("Error obtener perfil paciente: " + e.getMessage());
        }
        return p;
    }

    public boolean actualizarEdadYSexo(int idPaciente, int edad, String sexo) {
        String sql = "UPDATE Paciente SET edad = ?, sexo = ? WHERE id_paciente = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, edad);
            ps.setString(2, sexo);
            ps.setInt(3, idPaciente);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error actualizar edad y sexo: " + e.getMessage());
            return false;
        }
    }

    // F3: Remitir/transferir un paciente a otro médico
    public boolean remitirPaciente(int idPaciente, int idNuevoMedico) {
        String sql = "UPDATE Paciente SET id_medico = ? WHERE id_paciente = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idNuevoMedico);
            ps.setInt(2, idPaciente);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error remitirPaciente: " + e.getMessage());
            return false;
        }
    }

    // F3: Obtener paciente por ID
    public Paciente obtenerPacientePorId(int idPaciente) {
        Paciente p = null;
        String sql = "SELECT * FROM Paciente WHERE id_paciente = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idPaciente);
            rs = ps.executeQuery();
            if (rs.next()) {
                p = new Paciente();
                p.setIdPaciente(rs.getInt("id_paciente"));
                p.setIdUsuario(rs.getInt("id_usuario"));
                p.setIdMedico(rs.getInt("id_medico"));
                p.setNombreCompleto(rs.getString("nombre_completo"));
                p.setFechaNacimiento(rs.getString("fecha_nacimiento"));
                p.setEdad(rs.getInt("edad"));
                p.setSexo(rs.getString("sexo"));
                p.setEstadoActivo(rs.getBoolean("estado_activo"));
            }
        } catch (Exception e) {
            System.err.println("Error obtenerPacientePorId: " + e.getMessage());
        }
        return p;
    }

}