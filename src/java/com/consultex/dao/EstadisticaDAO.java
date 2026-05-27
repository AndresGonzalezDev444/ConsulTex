package com.consultex.dao;

import com.consultex.config.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Clase DAO para gestionar la obtención de datos estadísticos para los gráficos.
 */
public class EstadisticaDAO {
    
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    //Gráfico Circular: Usuarios según su Rol
    public Map<String, Integer> getUsuariosPorRol() {
        Map<String, Integer> datos = new LinkedHashMap<>();
        String sql = "SELECT rol, COUNT(*) as cantidad FROM Usuario WHERE estado_activo = true GROUP BY rol";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                datos.put(rs.getString("rol"), rs.getInt("cantidad"));
            }
        } catch (Exception e) {
            System.err.println("Error en Estadisticas - Usuarios por Rol: " + e.getMessage());
        }
        return datos;
    }

    //Gráfico Doughnut: Estado de Asignación de Pacientes
    public Map<String, Integer> getAsignacionPacientes() {
        Map<String, Integer> datos = new LinkedHashMap<>();
        String sql = "SELECT " +
                     "SUM(CASE WHEN p.id_medico IS NULL OR m.estado_activo = false THEN 1 ELSE 0 END) AS 'Sin Asignar', " +
                     "SUM(CASE WHEN p.id_medico IS NOT NULL AND (m.estado_activo = true OR m.estado_activo IS NULL) THEN 1 ELSE 0 END) AS 'Asignados' " +
                     "FROM Paciente p " +
                     "LEFT JOIN Medico med ON p.id_medico = med.id_medico " +
                     "LEFT JOIN Usuario m ON med.id_usuario = m.id_usuario " +
                     "WHERE p.estado_activo = true";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                datos.put("Sin Médico Asignado", rs.getInt("Sin Asignar"));
                datos.put("Con Médico Asignado", rs.getInt("Asignados"));
            }
        } catch (Exception e) {
            System.err.println("Error en Estadisticas - Asignacion Pacientes: " + e.getMessage());
        }
        return datos;
    }

    //Gráfico de Barras: Distribución de Especialidades Médicas
    public Map<String, Integer> getEspecialidadesMedicas() {
        Map<String, Integer> datos = new LinkedHashMap<>();
        String sql = "SELECT especialidad, COUNT(*) as cantidad FROM Medico WHERE estado_activo = true GROUP BY especialidad";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                datos.put(rs.getString("especialidad"), rs.getInt("cantidad"));
            }
        } catch (Exception e) {
            System.err.println("Error en Estadisticas - Especialidades: " + e.getMessage());
        }
        return datos;
    }

    //Gráfico de Líneas: Consultas por Día (los últimos registrados)
    public Map<String, Integer> getConsultasPorDia() {
        Map<String, Integer> datos = new LinkedHashMap<>();
        // Agrupamos por la fecha de consulta
        String sql = "SELECT DATE(fecha_consulta) as fecha, COUNT(*) as cantidad FROM Consulta WHERE estado_activo = true GROUP BY DATE(fecha_consulta) ORDER BY DATE(fecha_consulta) ASC LIMIT 10";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                datos.put(rs.getString("fecha"), rs.getInt("cantidad"));
            }
        } catch (Exception e) {
            System.err.println("Error en Estadisticas - Consultas por Día: " + e.getMessage());
        }
        return datos;
    }

    //Gráfico Polar Area: Promedio de Peso por Especialidad Médica (Aproximación usando Join)
    public Map<String, Double> getPromedioPesoPorEspecialidad() {
        Map<String, Double> datos = new LinkedHashMap<>();
        String sql = "SELECT m.especialidad, AVG(c.peso) as promedio_peso " +
                     "FROM Consulta c " +
                     "INNER JOIN Medico m ON c.id_medico = m.id_medico " +
                     "WHERE c.estado_activo = true AND c.peso > 0 " +
                     "GROUP BY m.especialidad";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                // Redondeamos a 1 decimal
                double promedio = Math.round(rs.getDouble("promedio_peso") * 10.0) / 10.0;
                datos.put(rs.getString("especialidad"), promedio);
            }
        } catch (Exception e) {
            System.err.println("Error en Estadisticas - Promedio peso especialidad: " + e.getMessage());
        }
        return datos;
    }

    // MÉTODOS PARA EL PANEL DEL MÉDICO 

    // Pacientes por Edad
    public Map<String, Integer> getPacientesPorEdadMedico(int idMedico) {
        Map<String, Integer> datos = new LinkedHashMap<>();
        // Inicializamos
        datos.put("0-12 años", 0);
        datos.put("13-17 años", 0);
        datos.put("18-35 años", 0);
        datos.put("36-50 años", 0);
        datos.put("51+ años", 0);

        String sql = "SELECT edad FROM Paciente WHERE id_medico = ? AND estado_activo = true";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idMedico);
            rs = ps.executeQuery();
            while (rs.next()) {
                int edad = rs.getInt("edad");
                if (edad <= 12) datos.put("0-12 años", datos.get("0-12 años") + 1);
                else if (edad <= 17) datos.put("13-17 años", datos.get("13-17 años") + 1);
                else if (edad <= 35) datos.put("18-35 años", datos.get("18-35 años") + 1);
                else if (edad <= 50) datos.put("36-50 años", datos.get("36-50 años") + 1);
                else datos.put("51+ años", datos.get("51+ años") + 1);
            }
        } catch (Exception e) {
            System.err.println("Error en Estadisticas Medico - Edad: " + e.getMessage());
        }
        return datos;
    }

    // Pacientes por Sexo
    public Map<String, Integer> getPacientesPorSexoMedico(int idMedico) {
        Map<String, Integer> datos = new LinkedHashMap<>();
        String sql = "SELECT sexo, COUNT(*) as cantidad FROM Paciente WHERE id_medico = ? AND estado_activo = true GROUP BY sexo";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idMedico);
            rs = ps.executeQuery();
            while (rs.next()) {
                String sexo = rs.getString("sexo");
                if (sexo != null && !sexo.isEmpty()) {
                    datos.put(sexo, rs.getInt("cantidad"));
                }
            }
        } catch (Exception e) {
            System.err.println("Error en Estadisticas Medico - Sexo: " + e.getMessage());
        }
        return datos;
    }

    // Pacientes por IMC (Relación Peso y Estatura de la última consulta)
    public Map<String, Integer> getPacientesPorIMCMedico(int idMedico) {
        Map<String, Integer> datos = new LinkedHashMap<>();
        datos.put("Bajo Peso", 0);
        datos.put("Normal", 0);
        datos.put("Sobrepeso", 0);
        datos.put("Obesidad", 0);

        // Obtenemos la última consulta de cada paciente vinculado al médico donde haya peso y estatura
        String sql = "SELECT c.peso, c.estatura " +
                     "FROM Consulta c " +
                     "INNER JOIN (SELECT id_paciente, MAX(fecha_consulta) as max_fecha FROM Consulta WHERE id_medico = ? GROUP BY id_paciente) c2 " +
                     "ON c.id_paciente = c2.id_paciente AND c.fecha_consulta = c2.max_fecha " +
                     "WHERE c.id_medico = ? AND c.estatura > 0 AND c.peso > 0";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idMedico);
            ps.setInt(2, idMedico);
            rs = ps.executeQuery();
            while (rs.next()) {
                double peso = rs.getDouble("peso");
                double estatura = rs.getDouble("estatura");
                double imc = peso / (estatura * estatura);

                if (imc < 18.5) datos.put("Bajo Peso", datos.get("Bajo Peso") + 1);
                else if (imc < 25) datos.put("Normal", datos.get("Normal") + 1);
                else if (imc < 30) datos.put("Sobrepeso", datos.get("Sobrepeso") + 1);
                else datos.put("Obesidad", datos.get("Obesidad") + 1);
            }
        } catch (Exception e) {
            System.err.println("Error en Estadisticas Medico - IMC: " + e.getMessage());
        }
        return datos;
    }

    // ==================== KPIs PARA EL DASHBOARD EN TIEMPO REAL (Criterio 17) ====================

    // KPI 1: Total Pacientes Activos
    public int getTotalPacientesActivos() {
        String sql = "SELECT COUNT(*) FROM Paciente WHERE estado_activo = true";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { System.err.println("KPI TotalPacientes: " + e.getMessage()); }
        return 0;
    }

    // KPI 2: Consultas de Hoy
    public int getConsultasHoy() {
        String sql = "SELECT COUNT(*) FROM Consulta WHERE DATE(fecha_consulta) = CURDATE() AND estado_activo = true";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { System.err.println("KPI ConsultasHoy: " + e.getMessage()); }
        return 0;
    }

    // KPI 3: Médicos Activos
    public int getMedicosActivos() {
        String sql = "SELECT COUNT(*) FROM Medico m INNER JOIN Usuario u ON m.id_usuario = u.id_usuario WHERE u.estado_activo = true AND m.estado_activo = true";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { System.err.println("KPI MedicosActivos: " + e.getMessage()); }
        return 0;
    }

    // KPI 4: Promedio de Calificación del Sistema (App)
    public double getPromedioCalificacionApp() {
        String sql = "SELECT AVG(" +
                     "CASE " +
                     "WHEN calificacion_app = 'Excelente' THEN 10.0 " +
                     "WHEN calificacion_app = 'Buena' THEN 8.0 " +
                     "WHEN calificacion_app = 'Intermedia' THEN 5.0 " +
                     "WHEN calificacion_app = 'Mala' THEN 1.0 " +
                     "ELSE NULL END) " +
                     "FROM Evaluacion WHERE estado_activo = true AND calificacion_app IS NOT NULL";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                double prom = rs.getDouble(1);
                return Math.round(prom * 10.0) / 10.0;
            }
        } catch (Exception e) { System.err.println("KPI PromedioCalifApp: " + e.getMessage()); }
        return 0.0;
    }

    // KPI NUEVO: Promedio de Calificación Médicos
    public double getPromedioCalificacionMedico() {
        String sql = "SELECT AVG(" +
                     "CASE " +
                     "WHEN calificacion_medico = 'Excelente' THEN 10.0 " +
                     "WHEN calificacion_medico = 'Buena' THEN 8.0 " +
                     "WHEN calificacion_medico = 'Intermedia' THEN 5.0 " +
                     "WHEN calificacion_medico = 'Mala' THEN 1.0 " +
                     "ELSE NULL END) " +
                     "FROM Evaluacion WHERE estado_activo = true AND calificacion_medico IS NOT NULL";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                double prom = rs.getDouble(1);
                return Math.round(prom * 10.0) / 10.0;
            }
        } catch (Exception e) { System.err.println("KPI PromedioCalifMed: " + e.getMessage()); }
        return 0.0;
    }

    // KPI 5: Citas Canceladas
    public int getCitasCanceladas() {
        String sql = "SELECT COUNT(*) FROM Cita WHERE estado = 'Cancelada' AND estado_activo = true";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { System.err.println("KPI CitasCanceladas: " + e.getMessage()); }
        return 0;
    }
}
