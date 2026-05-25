package com.consultex.controlador;

import com.consultex.dao.CitaDAO;
import com.consultex.dao.MedicoDAO;
import com.consultex.dao.PacienteDAO;
import com.consultex.modelo.Cita;
import com.consultex.modelo.Paciente;
import com.consultex.modelo.Usuario;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ControladorCita", urlPatterns = {"/ControladorCita"})
public class ControladorCita extends HttpServlet {
    CitaDAO cdao = new CitaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        Usuario u = (Usuario) request.getSession().getAttribute("usuarioActivo");

        if (u == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        if (accion.equalsIgnoreCase("agendaMedico")) {
            MedicoDAO mdao = new MedicoDAO();
            int idMedico = mdao.obtenerIdMedicoPorUsuario(u.getIdUsuario());
            
            List<Cita> citas = cdao.listarCitasPorMedico(idMedico);
            
            PacienteDAO pdao = new PacienteDAO();
            List<Paciente> pacientes = pdao.listarPacientesPorMedico(idMedico);
            
            request.setAttribute("citas", citas);
            request.setAttribute("pacientesVinculados", pacientes);
            request.setAttribute("idMedico", idMedico);
            
            request.getRequestDispatcher("vistas/medico/agenda.jsp").forward(request, response);
        }
        else if (accion.equalsIgnoreCase("misCitasPaciente")) {
            PacienteDAO pdao = new PacienteDAO();
            int idPaciente = pdao.obtenerIdPacientePorUsuario(u.getIdUsuario());
            
            List<Cita> citas = cdao.listarCitasPorPaciente(idPaciente);
            request.setAttribute("citas", citas);
            
            request.getRequestDispatcher("vistas/paciente/misCitas.jsp").forward(request, response);
        }
        else if (accion.equalsIgnoreCase("gestionCitasAdmin")) {
            List<Cita> citas = cdao.listarTodasCitas();
            request.setAttribute("citas", citas);
            request.getRequestDispatcher("vistas/admin/gestionCitas.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if (accion.equalsIgnoreCase("agendar")) {
            int idMedico = Integer.parseInt(request.getParameter("idMedico"));
            int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
            String fechaHora = request.getParameter("fechaHora"); // Formato 'YYYY-MM-DDTHH:MM' (del input datetime-local)
            
            // Reemplazar la T para que mysql lo tome más natural, aunque datetime-local envía "YYYY-MM-DDTHH:MM"
            fechaHora = fechaHora.replace("T", " ") + ":00"; 
            
            Cita c = new Cita();
            c.setIdMedico(idMedico);
            c.setIdPaciente(idPaciente);
            c.setFechaHora(fechaHora);
            
            cdao.agendarCita(c);
            response.sendRedirect("ControladorCita?accion=agendaMedico");
        }
        else if (accion.equalsIgnoreCase("reprogramarAdmin")) {
            int idCita = Integer.parseInt(request.getParameter("idCita"));
            String nuevaFechaHora = request.getParameter("nuevaFechaHora").replace("T", " ") + ":00";
            
            cdao.actualizarCita(idCita, nuevaFechaHora);
            response.sendRedirect("ControladorCita?accion=gestionCitasAdmin");
        }
        else if (accion.equalsIgnoreCase("cancelarAdmin")) {
            int idCita = Integer.parseInt(request.getParameter("idCita"));
            cdao.cancelarCita(idCita);
            response.sendRedirect("ControladorCita?accion=gestionCitasAdmin");
        }
    }
}
