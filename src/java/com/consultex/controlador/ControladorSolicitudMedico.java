package com.consultex.controlador;

import com.consultex.dao.EspecialidadDAO;
import com.consultex.dao.SolicitudMedicoDAO;
import com.consultex.dao.UsuarioDAO;
import com.consultex.modelo.Especialidad;
import com.consultex.modelo.SolicitudMedico;
import com.consultex.modelo.Usuario;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 * Controlador para el flujo de solicitud de registro de médicos (F1).
 * Maneja subida de archivos PDF con @MultipartConfig.
 */
@WebServlet(name = "ControladorSolicitudMedico", urlPatterns = {"/ControladorSolicitudMedico"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize       = 10 * 1024 * 1024, // 10 MB por archivo
    maxRequestSize    = 25 * 1024 * 1024  // 25 MB total
)
public class ControladorSolicitudMedico extends HttpServlet {

    SolicitudMedicoDAO solicitudDao = new SolicitudMedicoDAO();
    EspecialidadDAO especialidadDao = new EspecialidadDAO();
    UsuarioDAO usuarioDao = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // El admin accede a la gestión de solicitudes
        HttpSession session = request.getSession();
        Usuario u = (Usuario) session.getAttribute("usuarioActivo");
        if (u == null || (!u.getRol().equalsIgnoreCase("Admin") && !u.getRol().equalsIgnoreCase("Administrador"))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        if ("listar".equalsIgnoreCase(accion)) {
            List<SolicitudMedico> solicitudes = solicitudDao.listarPendientes();
            request.setAttribute("solicitudes", solicitudes);
            request.getRequestDispatcher("vistas/admin/gestionSolicitudes.jsp").forward(request, response);

        } else if ("aprobar".equalsIgnoreCase(accion)) {
            int idSolicitud = Integer.parseInt(request.getParameter("id"));
            SolicitudMedico s = solicitudDao.buscarPorId(idSolicitud);
            if (s != null) {
                // Obtener idEspecialidad o null
                String espTxt = s.getNombreEspecialidad() != null ? s.getNombreEspecialidad() : "Por definir";
                boolean ok = usuarioDao.registrarUsuarioCompleto(
                    s.getNombre(), s.getCorreo(), s.getPassword(), "Medico", s.getEdad(), s.getSexo(), s.getTipoId(), s.getNumeroId()
                );
                if (ok) {
                    // Eliminar la solicitud de la tabla
                    solicitudDao.eliminarFisico(idSolicitud);
                    // Enviar correo de bienvenida
                    enviarCorreoNotificacion(s.getCorreo(), s.getNombre(), true);
                    
                    request.setAttribute("mensaje", "✅ Médico " + s.getNombre() + " registrado exitosamente. Se le notificará por correo.");
                } else {
                    request.setAttribute("error", "Error al registrar el médico. Verifique que el correo no exista.");
                }
            }
            List<SolicitudMedico> solicitudes = solicitudDao.listarPendientes();
            request.setAttribute("solicitudes", solicitudes);
            request.getRequestDispatcher("vistas/admin/gestionSolicitudes.jsp").forward(request, response);

        } else if ("rechazar".equalsIgnoreCase(accion)) {
            int idSolicitud = Integer.parseInt(request.getParameter("id"));
            SolicitudMedico s = solicitudDao.buscarPorId(idSolicitud);
            boolean ok = solicitudDao.eliminarFisico(idSolicitud);
            if (ok && s != null) {
                // Enviar correo de rechazo
                enviarCorreoNotificacion(s.getCorreo(), s.getNombre(), false);
                request.setAttribute("mensaje", "Solicitud de " + s.getNombre() + " rechazada y eliminada correctamente.");
            } else {
                request.setAttribute("error", "Error al rechazar la solicitud.");
            }
            List<SolicitudMedico> solicitudes = solicitudDao.listarPendientes();
            request.setAttribute("solicitudes", solicitudes);
            request.getRequestDispatcher("vistas/admin/gestionSolicitudes.jsp").forward(request, response);

        } else {
            response.sendRedirect(request.getContextPath() + "/ControladorSolicitudMedico?accion=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Recibir la solicitud del médico (desde index.jsp con multipart)
        String accion = request.getParameter("accion");

        if ("enviarSolicitud".equalsIgnoreCase(accion)) {
            // Validar que no tenga solicitud pendiente
            String correo = request.getParameter("correo");
            if (solicitudDao.existeSolicitudPendiente(correo)) {
                request.setAttribute("error", "Ya tienes una solicitud pendiente con este correo. Sé paciente, estamos revisando tu información.");
                List<Especialidad> especialidades = especialidadDao.listarActivas();
                request.setAttribute("especialidades", especialidades);
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }

            // Crear carpeta de uploads si no existe
            String uploadDir = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "docs";
            Files.createDirectories(Paths.get(uploadDir));

            // Guardar PDF de pregrado (obligatorio)
            String rutaPdfPregrado = guardarPdf(request, "pdfPregrado", uploadDir, correo + "_pregrado");

            // Guardar PDF de especialización (opcional)
            boolean tieneEsp = "on".equals(request.getParameter("tieneEspecializacion"));
            String rutaPdfEsp = null;
            if (tieneEsp) {
                rutaPdfEsp = guardarPdf(request, "pdfEspecializacion", uploadDir, correo + "_especializacion");
            }

            // Construir el objeto solicitud
            SolicitudMedico s = new SolicitudMedico();
            s.setNombre(request.getParameter("nombre"));
            s.setCorreo(correo);
            s.setPassword(request.getParameter("password"));
            s.setTipoId(request.getParameter("tipoId"));
            s.setNumeroId(request.getParameter("numeroId"));
            try { s.setEdad(Integer.parseInt(request.getParameter("edad"))); } catch (Exception e) {}
            s.setSexo(request.getParameter("sexo"));
            String idEspStr = request.getParameter("idEspecialidad");
            if (idEspStr != null && !idEspStr.isEmpty()) {
                try { s.setIdEspecialidad(Integer.parseInt(idEspStr)); } catch (Exception e) {}
            }
            s.setTieneEspecializacion(tieneEsp);
            s.setNombreEspecializacion(request.getParameter("nombreEspecializacion"));
            s.setRutaPdfPregrado(rutaPdfPregrado);
            s.setRutaPdfEspecializacion(rutaPdfEsp);

            boolean ok = solicitudDao.registrarSolicitud(s);
            if (ok) {
                request.setAttribute("mensajePendiente", "✅ Datos enviados correctamente. Serán revisados y en caso de ser aceptad@, se te notificará por el correo electrónico que hayas registrado. ¡Éxitos!");
            } else {
                request.setAttribute("error", "Error al enviar la solicitud. Es posible que el correo ya esté registrado.");
                List<Especialidad> especialidades = especialidadDao.listarActivas();
                request.setAttribute("especialidades", especialidades);
            }
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    /**
     * Guarda un archivo PDF del request multipart y retorna su ruta relativa.
     */
    private String guardarPdf(HttpServletRequest request, String campo, String uploadDir, String prefijo) {
        try {
            Part filePart = request.getPart(campo);
            if (filePart == null || filePart.getSize() == 0) return null;
            String fileName = prefijo + "_" + System.currentTimeMillis() + ".pdf";
            String filePath = uploadDir + File.separator + fileName;
            filePart.write(filePath);
            return "uploads/docs/" + fileName;
        } catch (Exception e) {
            System.err.println("Error guardarPdf (" + campo + "): " + e.getMessage());
            return null;
        }
    }

    private void enviarCorreoNotificacion(String correoDestino, String nombreMedico, boolean aceptado) {
        try {
            java.util.Properties props = new java.util.Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.host", ControladorPDF.MAIL_HOST);
            props.put("mail.smtp.port", ControladorPDF.MAIL_PORT);

            javax.mail.Session mailSession = javax.mail.Session.getInstance(props, new javax.mail.Authenticator() {
                @Override
                protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
                    return new javax.mail.PasswordAuthentication(ControladorPDF.MAIL_FROM, ControladorPDF.MAIL_PASS);
                }
            });

            javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(mailSession);
            message.setFrom(new javax.mail.internet.InternetAddress(ControladorPDF.MAIL_FROM, "ConsulTex Admin"));
            message.addRecipient(javax.mail.Message.RecipientType.TO, new javax.mail.internet.InternetAddress(correoDestino));
            
            if (aceptado) {
                message.setSubject("¡Felicidades! Ha sido aceptado en ConsulTex");
                message.setText("Estimado/a Dr/a. " + nombreMedico + ",\n\n"
                        + "Nos complace informarle que su solicitud ha sido revisada y ACEPTADA.\n"
                        + "Ya puede iniciar sesión en la plataforma ConsulTex con su correo electrónico y contraseña registrados.\n\n"
                        + "¡Bienvenido/a al equipo médico de ConsulTex!");
            } else {
                message.setSubject("Actualización sobre su solicitud en ConsulTex");
                message.setText("Estimado/a " + nombreMedico + ",\n\n"
                        + "Agradecemos profundamente su interés en formar parte de ConsulTex.\n"
                        + "Lamentamos informarle que, tras revisar su documentación, su solicitud ha sido RECHAZADA en esta ocasión.\n\n"
                        + "Le invitamos a verificar sus documentos e intentar registrarse nuevamente en el futuro.\n\n"
                        + "Saludos cordiales,\nEquipo de Administración de ConsulTex");
            }

            javax.mail.Transport.send(message);
        } catch (Exception e) {
            System.err.println("Error enviando correo de notificacion: " + e.getMessage());
        }
    }
}
