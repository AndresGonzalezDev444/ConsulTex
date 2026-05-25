package com.consultex.dao;

import com.consultex.config.Conexion;
import com.consultex.modelo.Especialidad;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para la entidad Especialidad. Implementa CRUD completo y borrado lógico.
 * Criterios 9, 10, 11, 12 y 13.
 */
public class EspecialidadDAO {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // CREAR - Criterio 12
    public boolean registrar(Especialidad e) {
        String sql = "INSERT INTO Especialidad (nombre, descripcion) VALUES (?, ?)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, e.getNombre());
            ps.setString(2, e.getDescripcion());
            ps.executeUpdate();
            return true;
        } catch (Exception ex) {
            System.err.println("Error al registrar Especialidad: " + ex.getMessage());
            return false;
        }
    }

    // LEER (Listado General) - Criterio 13
    public List<Especialidad> listarActivas() {
        List<Especialidad> lista = new ArrayList<>();
        String sql = "SELECT * FROM Especialidad WHERE estado_activo = true ORDER BY nombre ASC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Especialidad e = new Especialidad();
                e.setIdEspecialidad(rs.getInt("id_especialidad"));
                e.setNombre(rs.getString("nombre"));
                e.setDescripcion(rs.getString("descripcion"));
                e.setFechaCreacion(rs.getString("fecha_creacion"));
                e.setEstadoActivo(rs.getBoolean("estado_activo"));
                lista.add(e);
            }
        } catch (Exception ex) {
            System.err.println("Error al listar Especialidades: " + ex.getMessage());
        }
        return lista;
    }

    // LEER (Buscar por PK) - Criterio 13
    public Especialidad buscarPorId(int id) {
        String sql = "SELECT * FROM Especialidad WHERE id_especialidad = ? AND estado_activo = true";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                Especialidad e = new Especialidad();
                e.setIdEspecialidad(rs.getInt("id_especialidad"));
                e.setNombre(rs.getString("nombre"));
                e.setDescripcion(rs.getString("descripcion"));
                e.setFechaCreacion(rs.getString("fecha_creacion"));
                e.setEstadoActivo(rs.getBoolean("estado_activo"));
                return e;
            }
        } catch (Exception ex) {
            System.err.println("Error buscarPorId Especialidad: " + ex.getMessage());
        }
        return null;
    }

    // ACTUALIZAR - Criterio 12
    public boolean actualizar(Especialidad e) {
        String sql = "UPDATE Especialidad SET nombre = ?, descripcion = ? WHERE id_especialidad = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, e.getNombre());
            ps.setString(2, e.getDescripcion());
            ps.setInt(3, e.getIdEspecialidad());
            ps.executeUpdate();
            return true;
        } catch (Exception ex) {
            System.err.println("Error al actualizar Especialidad: " + ex.getMessage());
            return false;
        }
    }

    // BORRADO LÓGICO - Criterio 12 (no se eliminan datos realmente)
    public boolean eliminarLogico(int id) {
        String sql = "UPDATE Especialidad SET estado_activo = false WHERE id_especialidad = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (Exception ex) {
            System.err.println("Error eliminarLogico Especialidad: " + ex.getMessage());
            return false;
        }
    }
}
