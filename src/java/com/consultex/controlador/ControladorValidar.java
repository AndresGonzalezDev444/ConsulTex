package com.consultex.controlador;

import com.consultex.dao.UsuarioDAO;
import com.consultex.modelo.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet encargado de interceptar el formulario de Login y gestionar las sesiones.
 */
@WebServlet(name = "ControladorValidar", urlPatterns = {"/ControladorValidar"})
public class ControladorValidar extends HttpServlet {

    UsuarioDAO udao = new UsuarioDAO();
    Usuario usu = new Usuario();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        
        if (accion.equalsIgnoreCase("Ingresar")) {
            String correo = request.getParameter("correo");
            String password = request.getParameter("password");

            // ── PASO 1: Verificar si es una solicitud de médico pendiente o rechazada ──
            com.consultex.dao.SolicitudMedicoDAO solicitudDao = new com.consultex.dao.SolicitudMedicoDAO();
            String estadoSolicitud = solicitudDao.buscarEstadoPorCorreo(correo);

            if (estadoSolicitud != null) {
                if ("Pendiente".equalsIgnoreCase(estadoSolicitud)) {
                    request.setAttribute("error", "⏳ Usuario en proceso de selección. Ten paciencia, validamos tus datos. ¡Éxitos!");
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                    return;
                } else if ("Rechazado".equalsIgnoreCase(estadoSolicitud)) {
                    // Eliminar la solicitud rechazada para liberar el correo
                    com.consultex.modelo.SolicitudMedico sol = solicitudDao.buscarPorCorreo(correo);
                    if (sol != null) solicitudDao.eliminarFisico(sol.getIdSolicitud());
                    request.setAttribute("error", "❌ Tu solicitud fue rechazada. Puedes registrarte nuevamente con las credenciales correctas.");
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                    return;
                }
            }

            // ── PASO 2: Login normal ──
            usu = udao.validarLogin(correo, password);
            if (usu.getCorreo() != null) {
                HttpSession session = request.getSession();
                session.setAttribute("usuarioActivo", usu);
                String rol = usu.getRol();
                if (rol.equalsIgnoreCase("Administrador") || rol.equalsIgnoreCase("Admin")) {
                    response.sendRedirect("vistas/admin/panelAdmin.jsp");
                } else if (rol.equalsIgnoreCase("Medico")) {
                    response.sendRedirect("vistas/medico/panelMedico.jsp");
                } else if (rol.equalsIgnoreCase("Paciente")) {
                    response.sendRedirect("vistas/paciente/panelPaciente.jsp");
                } else {
                    request.setAttribute("error", "Rol no reconocido.");
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Credenciales incorrectas o usuario inactivo.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }

        } else {
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Si intentan acceder al servlet por URL (GET), los mandamos al login
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}