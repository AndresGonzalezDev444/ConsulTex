<%@page import="com.consultex.modelo.Usuario"%>
<%@page import="com.consultex.modelo.SolicitudMedico"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioActivo");
    if (usuarioLogueado == null || (!usuarioLogueado.getRol().equalsIgnoreCase("Admin") && !usuarioLogueado.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    List<SolicitudMedico> solicitudes = (List<SolicitudMedico>) request.getAttribute("solicitudes");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Solicitudes de Médicos</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body style="display:block; padding:30px;">
    <div class="form-container" style="max-width: 1000px;">
        <a href="${pageContext.request.contextPath}/vistas/admin/panelAdmin.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Volver al Panel</a>
        
        <div class="page-header" style="margin-top: 10px;">
            <div>
                <h1>Solicitudes de Registro — Médicos</h1>
                <p>Revisa la documentación y aprueba o rechaza cada solicitud.</p>
            </div>
        </div>

        <% if (request.getAttribute("mensaje") != null) { %>
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= request.getAttribute("mensaje") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %></div>
        <% } %>

        <% if (solicitudes != null && !solicitudes.isEmpty()) {
            for (SolicitudMedico s : solicitudes) { %>
        <div class="card-panel" style="margin-bottom: 20px; border-left: 4px solid #f39c12;">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px;">
                <div>
                    <div style="font-size: 18px; font-weight: 700; color: var(--dark);"><i class="fas fa-user-md" style="color:var(--primary);"></i> <%= s.getNombre() %></div>
                    <div style="font-size: 13px; color: var(--text-muted); margin-top: 5px;"><i class="fas fa-envelope"></i> <%= s.getCorreo() %> &nbsp;|&nbsp; <i class="fas fa-calendar"></i> <%= s.getFechaSolicitud() %></div>
                </div>
                <span class="status-badge" style="background: #fef9e7; color: #b7770d; border: 1px solid #f8c471;"><i class="fas fa-clock"></i> Pendiente</span>
            </div>

            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-bottom: 20px;">
                <div style="background: var(--bg-main); padding: 12px; border-radius: 8px;">
                    <label style="font-size: 11px; color: var(--text-muted); text-transform: uppercase; font-weight: 600;">Identificación</label>
                    <div style="font-size: 14px; font-weight: 600; color: var(--dark); margin-top: 3px;"><%= s.getTipoId() %> — <%= s.getNumeroId() %></div>
                </div>
                <div style="background: var(--bg-main); padding: 12px; border-radius: 8px;">
                    <label style="font-size: 11px; color: var(--text-muted); text-transform: uppercase; font-weight: 600;">Edad / Sexo</label>
                    <div style="font-size: 14px; font-weight: 600; color: var(--dark); margin-top: 3px;"><%= s.getEdad() %> años / <%= s.getSexo() %></div>
                </div>
                <div style="background: var(--bg-main); padding: 12px; border-radius: 8px;">
                    <label style="font-size: 11px; color: var(--text-muted); text-transform: uppercase; font-weight: 600;">Especialidad</label>
                    <div style="font-size: 14px; font-weight: 600; color: var(--dark); margin-top: 3px;"><%= s.getNombreEspecialidad() != null ? s.getNombreEspecialidad() : "No especificada" %></div>
                </div>
                <% if (s.isTieneEspecializacion()) { %>
                <div style="background: var(--bg-main); padding: 12px; border-radius: 8px;">
                    <label style="font-size: 11px; color: var(--text-muted); text-transform: uppercase; font-weight: 600;">Especialización Adicional</label>
                    <div style="font-size: 14px; font-weight: 600; color: var(--dark); margin-top: 3px;"><%= s.getNombreEspecializacion() != null ? s.getNombreEspecializacion() : "-" %></div>
                </div>
                <% } %>
            </div>

            <!-- Documentos -->
            <div style="display: flex; gap: 10px; margin-bottom: 20px; flex-wrap: wrap;">
                <% if (s.getRutaPdfPregrado() != null) { %>
                <a href="${pageContext.request.contextPath}/<%= s.getRutaPdfPregrado() %>" target="_blank" class="btn btn-outline" style="border-color: #e74c3c; color: #e74c3c;">
                    <i class="fas fa-file-pdf"></i> Tarjeta Profesional
                </a>
                <% } %>
                <% if (s.getRutaPdfEspecializacion() != null) { %>
                <a href="${pageContext.request.contextPath}/<%= s.getRutaPdfEspecializacion() %>" target="_blank" class="btn btn-outline" style="border-color: #3498db; color: #3498db;">
                    <i class="fas fa-graduation-cap"></i> Cert. Especialización
                </a>
                <% } %>
            </div>

            <!-- Acciones -->
            <div style="display: flex; gap: 10px; border-top: 1px solid var(--border-light); padding-top: 15px;">
                <a href="${pageContext.request.contextPath}/ControladorSolicitudMedico?accion=aprobar&id=<%= s.getIdSolicitud() %>"
                class="btn btn-primary" onclick="return confirm('¿Aprobar y crear cuenta para Dr. <%= s.getNombre() %>?')">
                    <i class="fas fa-check"></i> Aprobar y Crear Cuenta
                </a>
                <a href="${pageContext.request.contextPath}/ControladorSolicitudMedico?accion=rechazar&id=<%= s.getIdSolicitud() %>"
                class="btn btn-danger" onclick="return confirm('¿Rechazar y eliminar la solicitud de <%= s.getNombre() %>? El correo quedará libre.')">
                    <i class="fas fa-times"></i> Rechazar
                </a>
            </div>
        </div>
        <% } } else { %>
        <div style="text-align: center; padding: 60px 20px; color: var(--text-muted); background: white; border-radius: 12px; border: 1px dashed var(--border-light);">
            <i class="fas fa-inbox" style="font-size: 48px; color: #e0e0e0; margin-bottom: 15px;"></i>
            <h3>No hay solicitudes pendientes</h3>
            <p style="margin-top: 5px;">Cuando un médico se registre, aparecerá aquí para revisión.</p>
        </div>
        <% } %>
    </div>
</body>
</html>
