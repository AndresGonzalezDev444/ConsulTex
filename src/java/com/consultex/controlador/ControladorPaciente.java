package com.consultex.controlador;

import com.consultex.modelo.Paciente;
import com.consultex.modelo.Consulta;
import com.consultex.modelo.Usuario;
import com.consultex.dao.PacienteDAO;
import com.consultex.dao.MedicoDAO;
import com.consultex.dao.ConsultaDAO;
import com.consultex.dao.EvaluacionDAO;
import com.consultex.modelo.Evaluacion;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ControladorPaciente", urlPatterns = {"/ControladorPaciente"})
public class ControladorPaciente extends HttpServlet {

    PacienteDAO pdao = new PacienteDAO();
    MedicoDAO mdao = new MedicoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        // Si la acción es nula o dice listarDisponibles, cargamos la tabla
        if (accion == null || accion.equalsIgnoreCase("listarDisponibles")) {
            List<Paciente> listaPacientes = pdao.listarPacientesDisponibles();
            request.setAttribute("pacientes", listaPacientes);
            // Redirigimos a la vista enviando la lista de pacientes
            request.getRequestDispatcher("vistas/medico/vincularPaciente.jsp").forward(request, response);
        }
        if (accion.equalsIgnoreCase("misPacientes")) {
            HttpSession session = request.getSession();
            Usuario usu = (Usuario) session.getAttribute("usuarioActivo");
            if (usu != null) {
                    int idMedico = mdao.obtenerIdMedicoPorUsuario(usu.getIdUsuario());
                    List<Paciente> misPacientes = pdao.listarPacientesPorMedico(idMedico);
                    request.setAttribute("pacientes", misPacientes);
                    request.getRequestDispatcher("vistas/medico/misPacientes.jsp").forward(request, response);
                }
        }
        
            if (accion.equalsIgnoreCase("verMiHistorial")) {
            HttpSession session = request.getSession();
            Usuario usu = (Usuario) session.getAttribute("usuarioActivo");

            // 1. Obtener ID real del paciente
            int idPac = pdao.obtenerIdPacientePorUsuario(usu.getIdUsuario());

            // 2. Traer sus consultas (Usando ConsultaDAO)
            ConsultaDAO cdao = new ConsultaDAO();
            List<Consulta> historial = cdao.listarPorPaciente(idPac);

            // 3. Enviar a la vista
            request.setAttribute("historial", historial);
            request.getRequestDispatcher("vistas/paciente/miHistorial.jsp").forward(request, response);
        }
        
        if (accion.equalsIgnoreCase("evaluarAtencion")) {
            HttpSession session = request.getSession();
            Usuario usu = (Usuario) session.getAttribute("usuarioActivo");
            if (usu != null) {
                int idPac = pdao.obtenerIdPacientePorUsuario(usu.getIdUsuario());
                int idMedico = pdao.obtenerMedicoDePaciente(idPac);
                if (idMedico == 0) {
                    request.setAttribute("error", "No tienes médicos asociados. Solo se te permitirá evaluar la app web.");
                }
                request.getRequestDispatcher("vistas/paciente/evaluarAtencion.jsp").forward(request, response);
            }
        }
        
        if (accion.equalsIgnoreCase("evaluarApp")) {
            request.getRequestDispatcher("vistas/paciente/evaluarApp.jsp").forward(request, response);
        }
        
        if (accion.equalsIgnoreCase("verHistorialMedico")) {
            int idPac = Integer.parseInt(request.getParameter("idPaciente"));
            ConsultaDAO cdao = new ConsultaDAO();
            List<Consulta> historial = cdao.listarPorPaciente(idPac);
            request.setAttribute("historial", historial);
            request.getRequestDispatcher("vistas/medico/historialPaciente.jsp").forward(request, response);
        }
        
        if (accion.equalsIgnoreCase("verPerfil")) {
            HttpSession session = request.getSession();
            Usuario usu = (Usuario) session.getAttribute("usuarioActivo");
            if (usu != null) {
                Paciente perfil = pdao.obtenerPerfilPaciente(usu.getIdUsuario());
                request.setAttribute("perfil", perfil);
                request.getRequestDispatcher("vistas/paciente/miPerfil.jsp").forward(request, response);
            }
        }

        // F3: Cargar vista de remisión (doGet)
        if (accion.equalsIgnoreCase("cargarRemision")) {
            HttpSession session = request.getSession();
            Usuario usu = (Usuario) session.getAttribute("usuarioActivo");
            if (usu != null && usu.getRol().equalsIgnoreCase("Medico")) {
                int idMedicoLogueado = mdao.obtenerIdMedicoPorUsuario(usu.getIdUsuario());
                int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
                Paciente pac = pdao.obtenerPacientePorId(idPaciente);
                
                String filtroEsp = request.getParameter("filtroEsp");
                List<com.consultex.modelo.Medico> listaMedicos;
                if (filtroEsp != null && !filtroEsp.trim().isEmpty()) {
                    listaMedicos = mdao.listarPorEspecialidad(filtroEsp, idMedicoLogueado);
                } else {
                    listaMedicos = mdao.listarMedicosConConteo(idMedicoLogueado);
                }
                
                request.setAttribute("paciente", pac);
                request.setAttribute("medicos", listaMedicos);
                request.getRequestDispatcher("vistas/medico/remitirPaciente.jsp").forward(request, response);
            }
        }

        // F3: Acción de remitir paciente (doGet, porque viene de form method="get")
        if (accion.equalsIgnoreCase("remitirPaciente")) {
            HttpSession session = request.getSession();
            Usuario usu = (Usuario) session.getAttribute("usuarioActivo");
            if (usu != null && usu.getRol().equalsIgnoreCase("Medico")) {
                int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
                int idNuevoMedico = Integer.parseInt(request.getParameter("idNuevoMedico"));
                boolean ok = pdao.remitirPaciente(idPaciente, idNuevoMedico);
                if (ok) {
                    request.setAttribute("mensaje", "✅ Paciente remitido exitosamente.");
                } else {
                    request.setAttribute("error", "Error al remitir el paciente.");
                }
                int idMedico = mdao.obtenerIdMedicoPorUsuario(usu.getIdUsuario());
                List<Paciente> misPacientes = pdao.listarPacientesPorMedico(idMedico);
                request.setAttribute("pacientes", misPacientes);
                request.getRequestDispatcher("vistas/medico/misPacientes.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        if (accion.equalsIgnoreCase("Vincular")) {
            HttpSession session = request.getSession();
            Usuario usu = (Usuario) session.getAttribute("usuarioActivo");

            // Validamos por seguridad
            if (usu != null && usu.getRol().equalsIgnoreCase("Medico")) {
                int idUsuario = usu.getIdUsuario();
                
                // Usamos nuestro nuevo DAO para sacar el id_medico
                int idMedico = mdao.obtenerIdMedicoPorUsuario(idUsuario);
                
                // Capturamos el ID del paciente que viene del botón en la tabla
                int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));

                // Hacemos el UPDATE (Vincular)
                boolean vinculado = pdao.vincularPacienteAMedico(idPaciente, idMedico);

                if (vinculado) {
                    request.setAttribute("mensaje", "¡Paciente vinculado con éxito a su consultorio!");
                } else {
                    request.setAttribute("error", "Hubo un error al intentar vincular el paciente.");
                }
            }
            // Volvemos a cargar la lista actualizada
            List<Paciente> listaPacientes = pdao.listarPacientesDisponibles();
            request.setAttribute("pacientes", listaPacientes);
            request.getRequestDispatcher("vistas/medico/vincularPaciente.jsp").forward(request, response);
        }
        
        if (accion.equalsIgnoreCase("guardarEvaluacionAtencion")) {
            HttpSession session = request.getSession();
            Usuario usu = (Usuario) session.getAttribute("usuarioActivo");
            if (usu != null) {
                int idPac = pdao.obtenerIdPacientePorUsuario(usu.getIdUsuario());
                int idMedico = pdao.obtenerMedicoDePaciente(idPac);
                
                Evaluacion eval = new Evaluacion();
                eval.setIdPaciente(idPac);
                eval.setIdMedico(idMedico);
                eval.setCalificacionMedico(request.getParameter("calificacion"));
                eval.setNotaMedico(request.getParameter("nota"));
                
                EvaluacionDAO edao = new EvaluacionDAO();
                edao.registrarEvaluacion(eval);
                
                response.sendRedirect("vistas/paciente/panelPaciente.jsp");
            }
        }
        
        if (accion.equalsIgnoreCase("guardarEvaluacionApp")) {
            HttpSession session = request.getSession();
            Usuario usu = (Usuario) session.getAttribute("usuarioActivo");
            if (usu != null) {
                int idPac = pdao.obtenerIdPacientePorUsuario(usu.getIdUsuario());
                
                Evaluacion eval = new Evaluacion();
                eval.setIdPaciente(idPac);
                eval.setCalificacionApp(request.getParameter("calificacion"));
                eval.setNotaApp(request.getParameter("nota"));
                
                EvaluacionDAO edao = new EvaluacionDAO();
                edao.registrarEvaluacion(eval);
                
                response.sendRedirect("vistas/paciente/panelPaciente.jsp");
            }
        }
        
        if (accion.equalsIgnoreCase("actualizarPerfil")) {
            HttpSession session = request.getSession();
            Usuario usu = (Usuario) session.getAttribute("usuarioActivo");
            if (usu != null) {
                int idPac = pdao.obtenerIdPacientePorUsuario(usu.getIdUsuario());
                int edad = Integer.parseInt(request.getParameter("edad"));
                String sexo = request.getParameter("sexo");
                
                boolean actualizado = pdao.actualizarEdadYSexo(idPac, edad, sexo);
                
                if (actualizado) {
                    request.setAttribute("mensajeExito", "¡Perfil actualizado correctamente!");
                } else {
                    request.setAttribute("mensajeError", "Error al actualizar el perfil.");
                }
                
                // Redirigir de nuevo a ver el perfil actualizado
                Paciente perfil = pdao.obtenerPerfilPaciente(usu.getIdUsuario());
                request.setAttribute("perfil", perfil);
                request.getRequestDispatcher("vistas/paciente/miPerfil.jsp").forward(request, response);
            }
        }
    }
}