package com.consultex.controlador;

import com.consultex.dao.MedicoDAO;
import com.consultex.dao.MedicamentoDAO;
import com.consultex.dao.PacienteDAO;
import com.consultex.modelo.Medicamento;
import com.consultex.modelo.Usuario;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 * Controlador para la gestión de Medicamentos (CRUD - Criterio 12).
 * Médico: prescribe y elimina. Paciente: visualiza sus recordatorios.
 */
@WebServlet(name = "ControladorMedicamento", urlPatterns = {"/ControladorMedicamento"})
public class ControladorMedicamento extends HttpServlet {

    MedicamentoDAO dao = new MedicamentoDAO();
    MedicoDAO medicoDao = new MedicoDAO();
    PacienteDAO pacienteDao = new PacienteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario u = (Usuario) session.getAttribute("usuarioActivo");
        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        if ("prescribir".equalsIgnoreCase(accion)) {
            // El médico va a prescribir: necesita saber a qué paciente
            String idPacienteStr = request.getParameter("idPaciente");
            request.setAttribute("idPaciente", idPacienteStr);
            request.getRequestDispatcher("vistas/medico/prescribirMedicamento.jsp").forward(request, response);

        } else if ("misMedicamentos".equalsIgnoreCase(accion)) {
            // Panel del médico: ver pacientes para luego ver o recetar medicamentos
            int idMedico = medicoDao.obtenerIdMedicoPorUsuario(u.getIdUsuario());
            List<com.consultex.modelo.Paciente> listaPacientes = pacienteDao.listarPacientesPorMedico(idMedico);
            request.setAttribute("pacientes", listaPacientes);
            request.getRequestDispatcher("vistas/medico/misMedicamentos.jsp").forward(request, response);

        } else if ("historialPaciente".equalsIgnoreCase(accion)) {
            String idPacienteStr = request.getParameter("idPaciente");
            int idPaciente = Integer.parseInt(idPacienteStr);
            List<Medicamento> lista = dao.listarPorPaciente(idPaciente);
            request.setAttribute("medicamentos", lista);
            request.setAttribute("idPaciente", idPacienteStr);
            request.getRequestDispatcher("vistas/medico/historialMedicamentos.jsp").forward(request, response);

        } else if ("misRecordatorios".equalsIgnoreCase(accion)) {
            // Panel del paciente: ver sus medicamentos activos con recordatorios
            int idPaciente = pacienteDao.obtenerIdPacientePorUsuario(u.getIdUsuario());
            List<Medicamento> lista = dao.listarPorPaciente(idPaciente);
            request.setAttribute("medicamentos", lista);
            request.getRequestDispatcher("vistas/paciente/misRecordatorios.jsp").forward(request, response);

        } else if ("obtenerRecordatoriosJSON".equalsIgnoreCase(accion)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            int idPaciente = pacienteDao.obtenerIdPacientePorUsuario(u.getIdUsuario());
            List<Medicamento> lista = dao.listarPorPaciente(idPaciente);
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < lista.size(); i++) {
                Medicamento m = lista.get(i);
                json.append("{")
                    .append("\"nombre\": \"").append(m.getNombreMedicamento()).append("\",")
                    .append("\"dosis\": \"").append(m.getDosis()).append("\",")
                    .append("\"frecuenciaHoras\": ").append(m.getFrecuenciaHoras()).append(",")
                    .append("\"fechaInicio\": \"").append(m.getFechaInicio()).append("\",")
                    .append("\"fechaFin\": \"").append(m.getFechaFin()).append("\"")
                    .append("}");
                if (i < lista.size() - 1) json.append(",");
            }
            json.append("]");
            response.getWriter().write(json.toString());

        } else if ("eliminar".equalsIgnoreCase(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String idPacienteStr = request.getParameter("idPaciente");
            dao.eliminarLogico(id);
            session.setAttribute("mensaje", "✅ Medicamento eliminado correctamente.");
            if (idPacienteStr != null && !idPacienteStr.isEmpty()) {
                List<Medicamento> lista = dao.listarPorPaciente(Integer.parseInt(idPacienteStr));
                request.setAttribute("medicamentos", lista);
                request.setAttribute("idPaciente", idPacienteStr);
                request.getRequestDispatcher("vistas/medico/historialMedicamentos.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/ControladorMedicamento?accion=misMedicamentos");
            }

        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario u = (Usuario) session.getAttribute("usuarioActivo");
        String accion = request.getParameter("accion");

        if ("guardar".equalsIgnoreCase(accion)) {
            try {
                int idMedico = medicoDao.obtenerIdMedicoPorUsuario(u.getIdUsuario());
                Medicamento m = new Medicamento();
                m.setIdMedico(idMedico);
                
                String idPacStr = request.getParameter("idPaciente");
                if(idPacStr == null || idPacStr.equals("null") || idPacStr.isEmpty()){
                    throw new Exception("ID de paciente no válido");
                }
                
                m.setIdPaciente(Integer.parseInt(idPacStr));
                m.setNombreMedicamento(request.getParameter("nombreMedicamento"));
                m.setDosis(request.getParameter("dosis"));
                m.setFrecuenciaHoras(Integer.parseInt(request.getParameter("frecuenciaHoras")));
                m.setFechaInicio(request.getParameter("fechaInicio"));
                m.setFechaFin(request.getParameter("fechaFin"));
                
                dao.registrar(m);
                session.setAttribute("mensaje", "✅ Medicamento registrado con éxito. Ya es visible en el panel del paciente.");
                
                // Redirigir al historial para ver el medicamento registrado
                response.sendRedirect(request.getContextPath() + "/ControladorMedicamento?accion=historialPaciente&idPaciente=" + idPacStr);
            } catch(Exception e) {
                session.setAttribute("error", "❌ Error del sistema: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/ControladorMedicamento?accion=misMedicamentos");
            }
        }
    }
}
