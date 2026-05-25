package com.consultex.controlador;

import com.consultex.dao.UsuarioDAO;
import com.consultex.dao.EvaluacionDAO;
import com.consultex.modelo.Usuario;
import com.consultex.modelo.Evaluacion;
import com.consultex.modelo.Paciente;
import com.consultex.dao.MedicoDAO;
import com.consultex.dao.PacienteDAO;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ControladorAdmin", urlPatterns = {"/ControladorAdmin"})
public class ControladorAdmin extends HttpServlet {
    UsuarioDAO udao = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if (accion.equalsIgnoreCase("listarMedicos")) {
            List<Usuario> lista = udao.listarTodos(); 
            request.setAttribute("usuarios", lista);
            request.setAttribute("tipo", "Médicos");
            request.getRequestDispatcher("vistas/admin/gestionUsuarios.jsp").forward(request, response);
        }
        else if (accion.equalsIgnoreCase("listarPacientes")) {
            List<Usuario> lista = udao.listarTodos();
            request.setAttribute("usuarios", lista);
            request.setAttribute("tipo", "Pacientes");
            request.getRequestDispatcher("vistas/admin/gestionUsuarios.jsp").forward(request, response);
        }
        else if (accion.equalsIgnoreCase("cargarUsuario")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Usuario u = udao.obtenerUsuarioPorId(id);
            request.setAttribute("usuarioObj", u);
            request.getRequestDispatcher("vistas/admin/editarUsuario.jsp").forward(request, response);
        }
        else if (accion.equalsIgnoreCase("deshabilitar")) {
            int id = Integer.parseInt(request.getParameter("id"));
            udao.eliminarLogico(id);
            String tipo = request.getParameter("tipo");
            if (tipo != null && tipo.equals("Medico")) {
                response.sendRedirect("ControladorAdmin?accion=listarMedicos");
            } else {
                response.sendRedirect("ControladorAdmin?accion=listarPacientes");
            }
        }
        else if (accion.equalsIgnoreCase("verEvaluaciones")) {
            EvaluacionDAO edao = new EvaluacionDAO();
            List<Evaluacion> lista = edao.listarEvaluaciones();
            request.setAttribute("evaluaciones", lista);
            request.getRequestDispatcher("vistas/admin/verEvaluaciones.jsp").forward(request, response);
        }
        else if (accion.equalsIgnoreCase("prepararActivacion")) {
            int idUsuario = Integer.parseInt(request.getParameter("id"));
            String tipo = request.getParameter("tipo");
            
            if (tipo.equals("Paciente")) {
                udao.activarUsuario(idUsuario);
                response.sendRedirect("ControladorAdmin?accion=listarPacientes");
            } else {
                MedicoDAO mdao = new MedicoDAO();
                int idMedico = mdao.obtenerIdMedicoPorUsuarioInactivo(idUsuario);
                PacienteDAO pdao = new PacienteDAO();
                List<Paciente> pacientes = pdao.listarPacientesPorMedico(idMedico);
                
                if (pacientes.isEmpty()) {
                    udao.activarUsuario(idUsuario);
                    response.sendRedirect("ControladorAdmin?accion=listarMedicos");
                } else {
                    request.setAttribute("pacientes", pacientes);
                    request.setAttribute("idUsuario", idUsuario);
                    
                    // Crear string de todos los IDs
                    StringBuilder sb = new StringBuilder();
                    for(Paciente p : pacientes) {
                        sb.append(p.getIdPaciente()).append(",");
                    }
                    request.setAttribute("todosIds", sb.toString());
                    
                    request.getRequestDispatcher("vistas/admin/reasignarPacientes.jsp").forward(request, response);
                }
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion.equalsIgnoreCase("actualizarUsuario")) {
            int id = Integer.parseInt(request.getParameter("id"));
            String correo = request.getParameter("correo");
            String password = request.getParameter("password");
            String rol = request.getParameter("rol");
            String tipoRetorno = request.getParameter("tipoRetorno"); // listarMedicos o listarPacientes
            
            Usuario u = new Usuario();
            u.setIdUsuario(id);
            u.setCorreo(correo);
            u.setPassword(password);
            u.setRol(rol);
            
            udao.actualizar(u);
            
            response.sendRedirect("ControladorAdmin?accion=" + tipoRetorno);
        }
        else if (accion.equalsIgnoreCase("activarYReasignar")) {
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            udao.activarUsuario(idUsuario);
            
            String[] aprobadosArray = request.getParameterValues("pacientesAprobados");
            List<String> aprobados = aprobadosArray != null ? Arrays.asList(aprobadosArray) : new ArrayList<>();
            
            String todosIdsStr = request.getParameter("todosIds");
            PacienteDAO pdao = new PacienteDAO();
            
            if (todosIdsStr != null && !todosIdsStr.isEmpty()) {
                String[] todos = todosIdsStr.split(",");
                for (String idStr : todos) {
                    if (!idStr.isEmpty() && !aprobados.contains(idStr)) {
                        // Desvincular paciente porque el admin no lo seleccionó
                        pdao.desvincularPaciente(Integer.parseInt(idStr));
                    }
                }
            }
            response.sendRedirect("ControladorAdmin?accion=listarMedicos");
        }
        else if (accion.equalsIgnoreCase("registrarNuevoUsuario")) {
            String nombre = request.getParameter("nombre");
            String correo = request.getParameter("correo");
            String password = request.getParameter("password");
            String rol = request.getParameter("rol");
            int edad = Integer.parseInt(request.getParameter("edad"));
            String sexo = request.getParameter("sexo");
            String tipoId = request.getParameter("tipoIdentificacion");
            String numeroId = request.getParameter("numeroIdentificacion");
            
            boolean registrado = udao.registrarUsuarioCompleto(nombre, correo, password, rol, edad, sexo, tipoId, numeroId);
            
            if (registrado) {
                if(rol.equalsIgnoreCase("Medico")) {
                    response.sendRedirect("ControladorAdmin?accion=listarMedicos");
                } else {
                    response.sendRedirect("ControladorAdmin?accion=listarPacientes");
                }
            } else {
                response.sendRedirect("vistas/admin/agregarUsuario.jsp?error=1");
            }
        }
    }
}