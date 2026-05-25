package com.consultex.controlador;

import com.consultex.dao.MedicoDAO;
import com.consultex.dao.SolicitudVinculacionDAO;
import com.consultex.modelo.SolicitudVinculacion;
import com.consultex.modelo.Usuario;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 * Controlador para el flujo de solicitudes de vinculación médico-paciente (F4).
 */
@WebServlet(name = "ControladorSolicitudVinculacion", urlPatterns = {"/ControladorSolicitudVinculacion"})
public class ControladorSolicitudVinculacion extends HttpServlet {

    SolicitudVinculacionDAO solicitudDao = new SolicitudVinculacionDAO();
    MedicoDAO medicoDao = new MedicoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario u = (Usuario) session.getAttribute("usuarioActivo");
        if (u == null) { response.sendRedirect(request.getContextPath() + "/index.jsp"); return; }

        String accion = request.getParameter("accion");
        String rol = u.getRol();

        if ("solicitar".equalsIgnoreCase(accion)) {
            // Médico solicita vincular un paciente
            if (!rol.equalsIgnoreCase("Medico")) { response.sendRedirect(request.getContextPath() + "/index.jsp"); return; }
            int idMedico = medicoDao.obtenerIdMedicoPorUsuario(u.getIdUsuario());
            int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
            boolean ok = solicitudDao.solicitar(idMedico, idPaciente);
            if (ok) {
                request.setAttribute("mensaje", "✅ Solicitud de vinculación enviada al administrador. Te notificarán cuando sea aprobada.");
            } else {
                request.setAttribute("error", "Ya tienes una solicitud pendiente para este paciente. Espera la respuesta del administrador.");
            }
            response.sendRedirect(request.getContextPath() + "/ControladorPaciente?accion=listarDisponibles&msg=" + (ok ? "ok" : "ya"));

        } else if ("listarPendientes".equalsIgnoreCase(accion)) {
            // Admin lista las solicitudes pendientes
            if (!rol.equalsIgnoreCase("Admin") && !rol.equalsIgnoreCase("Administrador")) {
                response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
            }
            List<SolicitudVinculacion> solicitudes = solicitudDao.listarPendientes();
            request.setAttribute("solicitudes", solicitudes);
            request.getRequestDispatcher("vistas/admin/solicitudesVinculacion.jsp").forward(request, response);

        } else if ("aprobar".equalsIgnoreCase(accion)) {
            // Admin aprueba
            if (!rol.equalsIgnoreCase("Admin") && !rol.equalsIgnoreCase("Administrador")) {
                response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
            }
            int idSolicitud = Integer.parseInt(request.getParameter("id"));
            int idMedico = Integer.parseInt(request.getParameter("idMedico"));
            int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
            boolean ok = solicitudDao.aprobar(idSolicitud, idMedico, idPaciente);
            request.setAttribute(ok ? "mensaje" : "error",
                ok ? "✅ Vinculación aprobada exitosamente." : "Error al aprobar la vinculación.");
            List<SolicitudVinculacion> solicitudes = solicitudDao.listarPendientes();
            request.setAttribute("solicitudes", solicitudes);
            request.getRequestDispatcher("vistas/admin/solicitudesVinculacion.jsp").forward(request, response);

        } else if ("rechazar".equalsIgnoreCase(accion)) {
            // Admin rechaza (borra físicamente → médico puede volver a solicitar)
            if (!rol.equalsIgnoreCase("Admin") && !rol.equalsIgnoreCase("Administrador")) {
                response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
            }
            int idSolicitud = Integer.parseInt(request.getParameter("id"));
            boolean ok = solicitudDao.rechazar(idSolicitud);
            request.setAttribute(ok ? "mensaje" : "error",
                ok ? "Solicitud rechazada. El médico podrá volver a solicitarla." : "Error al rechazar.");
            List<SolicitudVinculacion> solicitudes = solicitudDao.listarPendientes();
            request.setAttribute("solicitudes", solicitudes);
            request.getRequestDispatcher("vistas/admin/solicitudesVinculacion.jsp").forward(request, response);

        } else {
            response.sendRedirect(request.getContextPath() + "/ControladorSolicitudVinculacion?accion=listarPendientes");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
