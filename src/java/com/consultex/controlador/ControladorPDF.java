package com.consultex.controlador;

import com.consultex.config.Conexion;
import com.consultex.dao.ConsultaDAO;
import com.consultex.dao.PacienteDAO;
import com.consultex.modelo.Consulta;
import com.consultex.modelo.Paciente;
import com.consultex.modelo.Usuario;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;
import java.io.*;
import java.util.List;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 * Controlador para generación de PDFs (Criterio 15)
 * y envío por correo electrónico (Criterio 16).
 */
@WebServlet(name = "ControladorPDF", urlPatterns = {"/ControladorPDF"})
public class ControladorPDF extends HttpServlet {

    // ============================================================
    //  CONFIGURACIÓN DE CORREO (cambiar por cuenta real)
    // ============================================================
    public static final String MAIL_FROM    = "adminconsultex@gmail.com";
    public static final String MAIL_PASS    = "lhne ojqz apsp trpy";  // App Password de Gmail
    public static final String MAIL_HOST    = "smtp.gmail.com";
    public static final String MAIL_PORT    = "587";

    ConsultaDAO consultaDAO = new ConsultaDAO();
    PacienteDAO pacienteDAO = new PacienteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario u = (Usuario) session.getAttribute("usuarioActivo");
        if (u == null) { response.sendRedirect(request.getContextPath() + "/index.jsp"); return; }

        String accion = request.getParameter("accion");

        if ("generarHistorial".equalsIgnoreCase(accion)) {
            // Generar PDF del historial clínico y enviarlo al navegador
            int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
            byte[] pdfBytes = generarPdfHistorial(idPaciente);

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=historial_clinico_" + idPaciente + ".pdf");
            response.setContentLength(pdfBytes.length);
            response.getOutputStream().write(pdfBytes);

        } else if ("enviarCorreo".equalsIgnoreCase(accion)) {
            // Generar PDF y enviarlo por correo al paciente
            int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
            
            // Obtener el correo real del paciente desde la base de datos
            Paciente pac = pacienteDAO.obtenerPacientePorId(idPaciente);
            Usuario uPac = new com.consultex.dao.UsuarioDAO().obtenerUsuarioPorId(pac.getIdUsuario());
            String correoDestino = uPac.getCorreo();

            if (correoDestino == null || correoDestino.isEmpty()) {
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println("<script>alert('Error: El paciente no tiene un correo registrado.'); window.history.back();</script>");
                return;
            }

            byte[] pdfBytes = generarPdfHistorial(idPaciente);
            boolean enviado = enviarCorreoConPDF(correoDestino, pdfBytes, idPaciente);

            if (enviado) {
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println("<script>alert('✅ Historial enviado exitosamente al correo: " + correoDestino + "'); window.history.back();</script>");
            } else {
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println("<script>alert('⚠️ Error al enviar el correo. Revisa la consola de Tomcat para ver el motivo exacto.'); window.history.back();</script>");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // ============================================================
    //  GENERACIÓN DEL PDF con iTextPDF (Criterio 15)
    // ============================================================
    private byte[] generarPdfHistorial(int idPaciente) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try {
            Document doc = new Document(PageSize.A4, 50, 50, 60, 60);
            PdfWriter.getInstance(doc, baos);
            doc.open();

            // Fuentes
            Font fuenteTitulo = new Font(Font.FontFamily.HELVETICA, 22, Font.BOLD, new BaseColor(0, 86, 179));
            Font fuenteSubtitulo = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD, BaseColor.DARK_GRAY);
            Font fuenteNormal = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL, BaseColor.BLACK);
            Font fuenteNegrita = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD, BaseColor.BLACK);
            Font fuenteChica = new Font(Font.FontFamily.HELVETICA, 9, Font.ITALIC, BaseColor.GRAY);

            // Encabezado
            Paragraph titulo = new Paragraph("ConsulTex - Historial Clínico", fuenteTitulo);
            titulo.setAlignment(Element.ALIGN_CENTER);
            doc.add(titulo);

            Paragraph subtitulo = new Paragraph("Sistema de Gestión Médica", fuenteChica);
            subtitulo.setAlignment(Element.ALIGN_CENTER);
            doc.add(subtitulo);

            doc.add(new Paragraph(" ")); // Espacio
            LineSeparator ls = new LineSeparator();
            ls.setLineColor(new BaseColor(0, 86, 179));
            doc.add(new Chunk(ls));
            doc.add(new Paragraph(" "));

            // Información del paciente
            doc.add(new Paragraph("ID Paciente: " + idPaciente, fuenteSubtitulo));
            doc.add(new Paragraph("Fecha de generación: " + new java.util.Date(), fuenteChica));
            doc.add(new Paragraph(" "));

            // Historial de consultas
            List<Consulta> historial = consultaDAO.obtenerHistorialPorPaciente(idPaciente);

            if (historial.isEmpty()) {
                doc.add(new Paragraph("No se encontraron consultas registradas para este paciente.", fuenteNormal));
            } else {
                // Tabla de consultas
                PdfPTable tabla = new PdfPTable(5);
                tabla.setWidthPercentage(100);
                tabla.setSpacingBefore(10f);
                float[] anchuras = {15f, 20f, 25f, 15f, 25f};
                tabla.setWidths(anchuras);

                // Cabecera de tabla
                String[] cabeceras = {"Fecha", "Motivo", "Diagnóstico", "Temp (°C)", "Médico"};
                for (String cab : cabeceras) {
                    PdfPCell cell = new PdfPCell(new Phrase(cab, new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, BaseColor.WHITE)));
                    cell.setBackgroundColor(new BaseColor(0, 86, 179));
                    cell.setPadding(8);
                    tabla.addCell(cell);
                }

                // Filas
                boolean alternate = false;
                for (Consulta c : historial) {
                    BaseColor rowColor = alternate ? new BaseColor(240, 245, 255) : BaseColor.WHITE;
                    String[] valores = {
                        c.getFecha(), c.getMotivo(), c.getDiagnostico(),
                        String.valueOf(c.getTemperatura()),
                        c.getNombreMedico() != null ? c.getNombreMedico() : "N/A"
                    };
                    for (String val : valores) {
                        PdfPCell cell = new PdfPCell(new Phrase(val != null ? val : "-", fuenteNormal));
                        cell.setBackgroundColor(rowColor);
                        cell.setPadding(6);
                        tabla.addCell(cell);
                    }
                    alternate = !alternate;
                }
                doc.add(new Paragraph("Registro de Consultas Médicas", fuenteSubtitulo));
                doc.add(tabla);
            }

            // Pie de página
            doc.add(new Paragraph(" "));
            doc.add(new Chunk(ls));
            Paragraph pie = new Paragraph("Documento generado automáticamente por ConsulTex. © " + java.util.Calendar.getInstance().get(java.util.Calendar.YEAR), fuenteChica);
            pie.setAlignment(Element.ALIGN_CENTER);
            doc.add(pie);

            doc.close();
        } catch (Exception e) {
            System.err.println("Error al generar PDF: " + e.getMessage());
        }
        return baos.toByteArray();
    }

    // ============================================================
    //  ENVÍO DE CORREO CON PDF ADJUNTO (Criterio 16)
    // ============================================================
    private boolean enviarCorreoConPDF(String correoDestino, byte[] pdfBytes, int idPaciente) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.host", MAIL_HOST);
            props.put("mail.smtp.port", MAIL_PORT);
            props.put("mail.debug", "true"); // Habilita logs detallados en la consola

            Session mailSession = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(MAIL_FROM, MAIL_PASS);
                }
            });

            MimeMessage message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(MAIL_FROM, "ConsulTex - Sistema Médico"));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(correoDestino));
            message.setSubject("ConsulTex - Historial Clínico del Paciente #" + idPaciente);

            // Cuerpo del correo
            MimeBodyPart textPart = new MimeBodyPart();
            textPart.setText("Estimado/a,\n\nAdjunto encontrará el historial clínico generado por ConsulTex.\n\nEste correo fue enviado automáticamente. Por favor no responda a este mensaje.\n\nSaludos,\nEquipo ConsulTex");

            // PDF adjunto
            MimeBodyPart pdfPart = new MimeBodyPart();
            pdfPart.setDataHandler(new javax.activation.DataHandler(
                new javax.mail.util.ByteArrayDataSource(pdfBytes, "application/pdf")
            ));
            pdfPart.setFileName("historial_clinico_paciente_" + idPaciente + ".pdf");

            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(textPart);
            multipart.addBodyPart(pdfPart);
            message.setContent(multipart);

            Transport.send(message);
            return true;
        } catch (Exception e) {
            System.err.println("Error al enviar correo: " + e.getMessage());
            return false;
        }
    }
}
