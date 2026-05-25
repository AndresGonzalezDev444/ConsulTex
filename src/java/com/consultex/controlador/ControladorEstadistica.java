package com.consultex.controlador;

import com.consultex.dao.EstadisticaDAO;
import com.consultex.modelo.Usuario;
import com.consultex.dao.MedicoDAO;
import java.io.PrintWriter;
import java.io.IOException;
import java.util.Map;
import com.google.gson.Gson;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet encargado de proveer los datos estadísticos a la vista del Administrador.
 */
@WebServlet(name = "ControladorEstadistica", urlPatterns = {"/ControladorEstadistica"})
public class ControladorEstadistica extends HttpServlet {

    EstadisticaDAO estDao = new EstadisticaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        
        // Verificamos que quiera ver las estadisticas
        if (accion != null && accion.equalsIgnoreCase("ver")) {
            
            // 1. OBTENER DATOS DE LA BASE DE DATOS
            Map<String, Integer> mapUsuariosRol = estDao.getUsuariosPorRol();
            Map<String, Integer> mapAsignacionPac = estDao.getAsignacionPacientes();
            Map<String, Integer> mapEspecialidades = estDao.getEspecialidadesMedicas();
            Map<String, Integer> mapConsultasDia = estDao.getConsultasPorDia();
            Map<String, Double> mapPromedioPesoEspecialidad = estDao.getPromedioPesoPorEspecialidad();

            // 2. OBTENER KPIs (Criterio 17)
            request.setAttribute("kpiPacientes", estDao.getTotalPacientesActivos());
            request.setAttribute("kpiConsultasHoy", estDao.getConsultasHoy());
            request.setAttribute("kpiMedicos", estDao.getMedicosActivos());
            request.setAttribute("kpiCalificacion", estDao.getPromedioCalificacionApp());
            request.setAttribute("kpiCitasCanceladas", estDao.getCitasCanceladas());

            // 3. ENVIAR DATOS A LA VISTA (JSP)
            request.setAttribute("usuariosRol", mapUsuariosRol);
            request.setAttribute("asignacionPacientes", mapAsignacionPac);
            request.setAttribute("especialidadesMedicas", mapEspecialidades);
            request.setAttribute("consultasPorDia", mapConsultasDia);
            request.setAttribute("promedioPesoEspecialidad", mapPromedioPesoEspecialidad);

            // 4. REDIRECCIONAR A LA VISTA
            request.getRequestDispatcher("vistas/admin/estadisticas.jsp").forward(request, response);

        } else if (accion != null && accion.equalsIgnoreCase("datosKpi")) {
            // ENDPOINT AJAX para tiempo real - devuelve KPIs en JSON
            HttpSession session = request.getSession();
            Usuario usuario = (Usuario) session.getAttribute("usuarioActivo");
            if (usuario == null) { response.getWriter().write("{}"); return; }
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            Gson gson = new Gson();
            java.util.Map<String, Object> kpis = new java.util.LinkedHashMap<>();
            kpis.put("pacientes", estDao.getTotalPacientesActivos());
            kpis.put("consultasHoy", estDao.getConsultasHoy());
            kpis.put("medicos", estDao.getMedicosActivos());
            kpis.put("calificacion", estDao.getPromedioCalificacionApp());
            kpis.put("citasCanceladas", estDao.getCitasCanceladas());
            // También los datos de los gráficos para el refresh
            kpis.put("usuariosRol", estDao.getUsuariosPorRol());
            kpis.put("asignacionPacientes", estDao.getAsignacionPacientes());
            kpis.put("especialidadesMedicas", estDao.getEspecialidadesMedicas());
            kpis.put("consultasPorDia", estDao.getConsultasPorDia());
            kpis.put("promedioPesoEspecialidad", estDao.getPromedioPesoPorEspecialidad());
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(kpis));
            out.flush();
            return;
        } else if (accion != null && accion.equalsIgnoreCase("medico")) {
            // Mostrar la vista principal de estadisticas del medico
            request.getRequestDispatcher("vistas/medico/estadisticasMedico.jsp").forward(request, response);
            
        } else if (accion != null && accion.equalsIgnoreCase("datosGraficaMedico")) {
            // Devolver los datos en formato JSON para AJAX
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            HttpSession session = request.getSession();
            Usuario usuario = (Usuario) session.getAttribute("usuarioActivo");
            if (usuario == null) {
                response.getWriter().write("{\"error\": \"No autenticado\"}");
                return;
            }
            
            MedicoDAO mdao = new MedicoDAO();
            int idMedico = mdao.obtenerIdMedicoPorUsuario(usuario.getIdUsuario());
            
            String tipo = request.getParameter("tipo");
            Map<String, Integer> datos = null;
            
            if (tipo.equals("edad")) {
                datos = estDao.getPacientesPorEdadMedico(idMedico);
            } else if (tipo.equals("sexo")) {
                datos = estDao.getPacientesPorSexoMedico(idMedico);
            } else if (tipo.equals("imc")) {
                datos = estDao.getPacientesPorIMCMedico(idMedico);
            }
            
            // Construir JSON usando la librería Gson
            Gson gson = new Gson();
            String jsonOutput = "{}";
            if (datos != null) {
                jsonOutput = gson.toJson(datos);
            }
            
            PrintWriter out = response.getWriter();
            out.print(jsonOutput);
            out.flush();
            
        } else {
            // Si entra de otra forma por error, lo mandamos al panel
            response.sendRedirect("vistas/admin/panelAdmin.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
