<%@page import="com.consultex.modelo.Usuario"%>
<%@page import="com.consultex.modelo.SolicitudVinculacion"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioActivo");
    if (usuarioLogueado == null || (!usuarioLogueado.getRol().equalsIgnoreCase("Admin") && !usuarioLogueado.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    List<SolicitudVinculacion> solicitudes = (List<SolicitudVinculacion>) request.getAttribute("solicitudes");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Solicitudes de Vinculación</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body style="display:block; padding:30px;">
    <div class="form-container" style="max-width: 1000px;">
        <a href="${pageContext.request.contextPath}/vistas/admin/panelAdmin.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Volver al Panel</a>
        
        <div class="page-header" style="margin-top: 10px;">
            <div>
                <h1>Solicitudes de Vinculación Médico-Paciente</h1>
                <p>Aprueba o rechaza las solicitudes enviadas por los médicos para acceder al historial de un paciente.</p>
            </div>
        </div>

        <% if (request.getAttribute("mensaje") != null) { %>
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= request.getAttribute("mensaje") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %></div>
        <% } %>

        <% if (solicitudes != null && !solicitudes.isEmpty()) { %>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>#ID</th>
                        <th>Médico</th>
                        <th>Especialidad</th>
                        <th>Paciente Solicitado</th>
                        <th>Fecha Solicitud</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (SolicitudVinculacion s : solicitudes) { %>
                    <tr>
                        <td><strong><%= s.getIdSolicitud() %></strong></td>
                        <td><div style="display:flex;align-items:center;gap:8px;"><div class="avatar" style="width:30px;height:30px;font-size:14px;"><i class="fas fa-user-md"></i></div>Dr. <%= s.getNombreMedico() %></div></td>
                        <td><%= s.getEspecialidadMedico() != null ? s.getEspecialidadMedico() : "—" %></td>
                        <td><div style="display:flex;align-items:center;gap:8px;"><i class="fas fa-user-injured" style="color:var(--text-muted);"></i> <%= s.getNombrePaciente() %></div></td>
                        <td style="font-size:13px; color:var(--text-muted);"><%= s.getFechaSolicitud() %></td>
                        <td><span class="status-badge" style="background: #fef9e7; color: #b7770d; border: 1px solid #f8c471;"><i class="fas fa-clock"></i> Pendiente</span></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/ControladorSolicitudVinculacion?accion=aprobar&id=<%= s.getIdSolicitud() %>&idMedico=<%= s.getIdMedico() %>&idPaciente=<%= s.getIdPaciente() %>"
                               class="btn btn-primary btn-sm"
                               onclick="return confirm('¿Vincular a <%= s.getNombrePaciente() %> con Dr. <%= s.getNombreMedico() %>?')">
                                <i class="fas fa-check"></i> Aprobar
                            </a>
                            <a href="${pageContext.request.contextPath}/ControladorSolicitudVinculacion?accion=rechazar&id=<%= s.getIdSolicitud() %>"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('¿Rechazar esta solicitud de vinculación?')">
                                <i class="fas fa-times"></i> Rechazar
                            </a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
        <div style="text-align: center; padding: 60px 20px; color: var(--text-muted); background: white; border-radius: 12px; border: 1px dashed var(--border-light);">
            <i class="fas fa-inbox" style="font-size: 48px; color: #e0e0e0; margin-bottom: 15px;"></i>
            <h3>Sin solicitudes pendientes</h3>
            <p style="margin-top: 5px;">Cuando un médico solicite vincular un paciente, aparecerá aquí.</p>
        </div>
        <% } %>
    </div>
</body>
</html>
