package com.consultex.dao;

import com.consultex.config.Conexion;
import com.consultex.modelo.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * Clase DAO para gestionar el CRUD y Login de la tabla Usuario.
 */
public class UsuarioDAO {
    
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // MÉTODO PARA EL LOGIN
    public Usuario validarLogin(String correo, String password) {
        Usuario usu = new Usuario();
        String sql = "SELECT * FROM Usuario WHERE correo = ? AND password = ? AND estado_activo = true";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, correo);
            ps.setString(2, password);
            rs = ps.executeQuery();
            while (rs.next()) {
                usu.setIdUsuario(rs.getInt("id_usuario"));
                usu.setCorreo(rs.getString("correo"));
                usu.setPassword(rs.getString("password"));
                usu.setRol(rs.getString("rol"));
                usu.setFechaRegistro(rs.getString("fecha_registro"));
                usu.setEstadoActivo(rs.getBoolean("estado_activo"));
            }
        } catch (Exception e) {
            System.err.println("Error en Login: " + e.getMessage());
        }
        return usu;
    }

    // MÉTODO LEER / CONSULTAR (Read del CRUD)
    public List<Usuario> listarActivos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM Usuario WHERE estado_activo = true";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setCorreo(rs.getString("correo"));
                u.setPassword(rs.getString("password"));
                u.setRol(rs.getString("rol"));
                u.setFechaRegistro(rs.getString("fecha_registro"));
                u.setEstadoActivo(rs.getBoolean("estado_activo"));
                lista.add(u);
            }
        } catch (Exception e) {
            System.err.println("Error al listar: " + e.getMessage());
        }
        return lista;
    }

    // MÉTODO LEER / CONSULTAR TODOS (Activos e Inactivos)
    public List<Usuario> listarTodos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM Usuario";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setCorreo(rs.getString("correo"));
                u.setPassword(rs.getString("password"));
                u.setRol(rs.getString("rol"));
                u.setFechaRegistro(rs.getString("fecha_registro"));
                u.setEstadoActivo(rs.getBoolean("estado_activo"));
                lista.add(u);
            }
        } catch (Exception e) {
            System.err.println("Error al listar todos: " + e.getMessage());
        }
        return lista;
    }

    // MÉTODO OBTENER POR ID
    public Usuario obtenerUsuarioPorId(int id) {
        Usuario u = new Usuario();
        String sql = "SELECT * FROM Usuario WHERE id_usuario = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setCorreo(rs.getString("correo"));
                u.setPassword(rs.getString("password"));
                u.setRol(rs.getString("rol"));
                u.setFechaRegistro(rs.getString("fecha_registro"));
                u.setEstadoActivo(rs.getBoolean("estado_activo"));
            }
        } catch (Exception e) {
            System.err.println("Error al obtener usuario: " + e.getMessage());
        }
        return u;
    }

    // MÉTODO CREAR BÁSICO (Create del CRUD)
    public boolean registrar(Usuario user) {
        String sql = "INSERT INTO Usuario (correo, password, rol) VALUES (?, ?, ?)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, user.getCorreo());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRol());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error al registrar: " + e.getMessage());
            return false;
        }
    }

    // MÉTODO ACTUALIZAR (Update del CRUD)
    public boolean actualizar(Usuario user) {
        String sql = "UPDATE Usuario SET correo=?, password=?, rol=? WHERE id_usuario=?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, user.getCorreo());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRol());
            ps.setInt(4, user.getIdUsuario());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error al actualizar: " + e.getMessage());
            return false;
        }
    }

    // MÉTODO BORRAR (Delete LÓGICO)
    public boolean eliminarLogico(int id) {
        String sql = "UPDATE Usuario SET estado_activo = false WHERE id_usuario=?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error en borrado lógico: " + e.getMessage());
            return false;
        }
    }

    // MÉTODO REGISTRAR COMPLETO (con tipo y número de identificación - F2)
    public boolean registrarUsuarioCompleto(String nombre, String correo, String password, String rol, int edad, String sexo, String tipoId, String numeroId) {
        boolean exito = false;
        String sqlUsuario = "INSERT INTO Usuario (correo, password, rol, tipo_identificacion, numero_identificacion) VALUES (?, ?, ?, ?, ?)";
        try {
            con = cn.getConnection();
            con.setAutoCommit(false);
            ps = con.prepareStatement(sqlUsuario, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, correo);
            ps.setString(2, password);
            ps.setString(3, rol);
            ps.setString(4, tipoId != null ? tipoId : "CC");
            ps.setString(5, numeroId != null ? numeroId : "");
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            int idUsuarioGenerado = 0;
            if (rs.next()) idUsuarioGenerado = rs.getInt(1);

            if (rol.equalsIgnoreCase("Medico")) {
                String sqlMedico = "INSERT INTO Medico (id_usuario, nombre_completo, especialidad, numero_licencia, edad, sexo, tipo_identificacion, numero_identificacion) VALUES (?, ?, 'Por definir', ?, ?, ?, ?, ?)";
                PreparedStatement psMed = con.prepareStatement(sqlMedico);
                psMed.setInt(1, idUsuarioGenerado);
                psMed.setString(2, nombre);
                psMed.setString(3, "TEMP-" + idUsuarioGenerado);
                psMed.setInt(4, edad);
                psMed.setString(5, sexo);
                psMed.setString(6, tipoId != null ? tipoId : "CC");
                psMed.setString(7, numeroId != null ? numeroId : "");
                psMed.executeUpdate();
            } else if (rol.equalsIgnoreCase("Paciente")) {
                String sqlPaciente = "INSERT INTO Paciente (id_usuario, nombre_completo, fecha_nacimiento, edad, sexo, tipo_identificacion, numero_identificacion) VALUES (?, ?, CURDATE(), ?, ?, ?, ?)";
                PreparedStatement psPac = con.prepareStatement(sqlPaciente);
                psPac.setInt(1, idUsuarioGenerado);
                psPac.setString(2, nombre);
                psPac.setInt(3, edad);
                psPac.setString(4, sexo);
                psPac.setString(5, tipoId != null ? tipoId : "CC");
                psPac.setString(6, numeroId != null ? numeroId : "");
                psPac.executeUpdate();
            }
            con.commit();
            exito = true;
        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            System.err.println("Error en transacci\u00f3n de registro: " + e.getMessage());
        } finally {
            try { if (con != null) con.setAutoCommit(true); } catch (Exception e) {}
        }
        return exito;
    }

    // Overload sin tipoId/numeroId (compatibilidad con llamadas desde ControladorSolicitudMedico)
    public boolean registrarUsuarioCompleto(String nombre, String correo, String password, String rol, int edad, String sexo) {
        return registrarUsuarioCompleto(nombre, correo, password, rol, edad, sexo, "CC", "");
    }

    // MÉTODO ACTIVAR USUARIO
    public boolean activarUsuario(int id) {
        String sql = "UPDATE Usuario SET estado_activo = true WHERE id_usuario=?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.err.println("Error al activar usuario: " + e.getMessage());
            return false;
        }
    }
}