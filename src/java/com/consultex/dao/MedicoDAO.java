package com.consultex.dao;

import com.consultex.config.Conexion;
import com.consultex.modelo.Medico;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * Clase DAO para la entidad Medico.
 */
public class MedicoDAO {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // Método para obtener el ID real del médico logueado
    public int obtenerIdMedicoPorUsuario(int idUsuario) {
        int idMedico = 0;
        String sql = "SELECT id_medico FROM Medico WHERE id_usuario = ? AND estado_activo = true";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();
            if (rs.next()) idMedico = rs.getInt("id_medico");
        } catch (Exception e) {
            System.err.println("Error al obtener id medico: " + e.getMessage());
        }
        return idMedico;
    }

    // Método para obtener el ID sin importar si está activo o no
    public int obtenerIdMedicoPorUsuarioInactivo(int idUsuario) {
        int idMedico = 0;
        String sql = "SELECT id_medico FROM Medico WHERE id_usuario = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();
            if (rs.next()) idMedico = rs.getInt("id_medico");
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        }
        return idMedico;
    }

    // F3: Listar médicos activos con su conteo de pacientes (para remisión)
    public List<Medico> listarMedicosConConteo(int idMedicoExcluir) {
        List<Medico> lista = new ArrayList<>();
        String sql = "SELECT m.id_medico, m.nombre_completo, m.especialidad, "
                   + "COUNT(p.id_paciente) AS total_pacientes "
                   + "FROM Medico m "
                   + "LEFT JOIN Paciente p ON p.id_medico = m.id_medico AND p.estado_activo = true "
                   + "INNER JOIN Usuario u ON m.id_usuario = u.id_usuario "
                   + "WHERE m.estado_activo = true AND u.estado_activo = true AND m.id_medico != ? "
                   + "GROUP BY m.id_medico, m.nombre_completo, m.especialidad "
                   + "ORDER BY m.especialidad, m.nombre_completo";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idMedicoExcluir);
            rs = ps.executeQuery();
            while (rs.next()) {
                Medico m = new Medico();
                m.setIdMedico(rs.getInt("id_medico"));
                m.setNombreCompleto(rs.getString("nombre_completo"));
                m.setEspecialidad(rs.getString("especialidad"));
                m.setTotalPacientes(rs.getInt("total_pacientes"));
                lista.add(m);
            }
        } catch (Exception e) {
            System.err.println("Error listarMedicosConConteo: " + e.getMessage());
        }
        return lista;
    }

    // Lista todos los médicos activos filtrados por especialidad (para F3)
    public List<Medico> listarPorEspecialidad(String especialidad, int idMedicoExcluir) {
        List<Medico> lista = new ArrayList<>();
        String sql = "SELECT m.id_medico, m.nombre_completo, m.especialidad, "
                   + "COUNT(p.id_paciente) AS total_pacientes "
                   + "FROM Medico m "
                   + "LEFT JOIN Paciente p ON p.id_medico = m.id_medico AND p.estado_activo = true "
                   + "INNER JOIN Usuario u ON m.id_usuario = u.id_usuario "
                   + "WHERE m.estado_activo = true AND u.estado_activo = true AND m.id_medico != ? "
                   + "AND m.especialidad LIKE ? "
                   + "GROUP BY m.id_medico, m.nombre_completo, m.especialidad "
                   + "ORDER BY m.nombre_completo";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idMedicoExcluir);
            ps.setString(2, "%" + especialidad + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                Medico m = new Medico();
                m.setIdMedico(rs.getInt("id_medico"));
                m.setNombreCompleto(rs.getString("nombre_completo"));
                m.setEspecialidad(rs.getString("especialidad"));
                m.setTotalPacientes(rs.getInt("total_pacientes"));
                lista.add(m);
            }
        } catch (Exception e) {
            System.err.println("Error listarPorEspecialidad: " + e.getMessage());
        }
        return lista;
    }
}