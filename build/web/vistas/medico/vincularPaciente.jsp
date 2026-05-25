<%@page import="java.util.List"%>
<%@page import="com.consultex.modelo.Paciente"%>
<%@page import="com.consultex.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioActivo");
    if (usuarioLogueado == null || !usuarioLogueado.getRol().equalsIgnoreCase("Medico")) {
        response.sendRedirect("../../index.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Solicitar Vinculación</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

        <nav class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <i class="fas fa-heartbeat" style="font-size: 24px;"></i>
            <h3>ConsulTex</h3>
        </div>
        <div style="text-align: center; padding-bottom: 10px;">
            <span class="badge-role">Médico</span>
        </div>
        
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/vistas/medico/panelMedico.jsp"><i class="fas fa-home"></i> Inicio</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=listarDisponibles"><i class="fas fa-user-plus"></i> Vincular Paciente</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=misPacientes"><i class="fas fa-users"></i> Mis Pacientes</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorMedicamento?accion=misMedicamentos"><i class="fas fa-pills"></i> Medicamentos</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorEstadistica?accion=medico"><i class="fas fa-chart-line"></i> Estadísticas</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorCita?accion=agendaMedico"><i class="fas fa-calendar-alt"></i> Agenda</a></li>
        </ul>

        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/ControladorCerrarSesion" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
            </a>
        </div>
    </nav>

    <main class="main-wrapper">
        <div class="header" style="margin-bottom: 25px;">
            <h1 style="color:var(--dark);"> Pacientes Disponibles</h1>
            <p style="color:var(--text-muted); margin-top:5px;">Envía una solicitud al administrador para vincular un paciente a tu consultorio. <strong>Solo puedes enviar 1 solicitud por paciente.</strong></p>
        </div>

        <% if(request.getAttribute("mensaje") != null) { %>
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= request.getAttribute("mensaje") %></div>
        <% } %>
        <% if(request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %></div>
        <% } %>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre Completo</th>
                        <th>Fecha de Nacimiento</th>
                        <th>Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        // Recuperamos la lista de pacientes enviada por el ControladorPaciente
                        List<Paciente> lista = (List<Paciente>) request.getAttribute("pacientes");
                        if (lista != null && !lista.isEmpty()) {
                            for (Paciente p : lista) {
                    %>
                    <tr>
                        <td><strong><%= p.getIdPaciente() %></strong></td>
                        <td><div style="display:flex;align-items:center;gap:8px;"><i class="fas fa-user" style="color:var(--text-muted);"></i> <%= p.getNombreCompleto() %></div></td>
                        <td style="font-size:13px; color:var(--text-muted);"><%= p.getFechaNacimiento() %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/ControladorSolicitudVinculacion?accion=solicitar&idPaciente=<%= p.getIdPaciente() %>"
                            class="btn btn-primary btn-sm"
                            onclick="return confirm('¿Solicitar vinculación con <%= p.getNombreCompleto() %>? El administrador revisará tu solicitud.')">
                                <i class="fas fa-paper-plane"></i> Solicitar Vinculación
                            </a>
                        </td>
                    </tr>
                    <% 
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="4" style="text-align: center; padding: 40px; color: var(--text-muted);">
                            <i class="fas fa-search" style="font-size: 32px; color: #e0e0e0; margin-bottom: 10px; display:block;"></i>
                            No hay pacientes nuevos buscando médico en este momento.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>

</body>
</html>