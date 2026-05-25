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
    <title>ConsulTex - Mis Pacientes</title>
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
            <li><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=listarDisponibles"><i class="fas fa-user-plus"></i> Vincular Paciente</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=misPacientes"><i class="fas fa-users"></i> Mis Pacientes</a></li>
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
        <div class="page-header" style="margin-bottom: 25px;">
            <div>
                <h1>Mis Pacientes Asignados</h1>
                <p>Lista de pacientes bajo su supervisión médica.</p>
            </div>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Nombre Completo</th>
                        <th>Fecha de Vinculación</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Paciente> lista = (List<Paciente>) request.getAttribute("pacientes");
                        if (lista != null && !lista.isEmpty()) {
                            for (Paciente p : lista) {
                    %>
                    <tr>
                        <td><div style="display:flex;align-items:center;gap:10px;"><i class="fas fa-user-circle" style="font-size:24px;color:var(--text-muted);"></i> <strong><%= p.getNombreCompleto() %></strong></div></td>
                        <td style="font-size:14px; color:var(--text-muted);"><i class="far fa-calendar-alt"></i> <%= p.getFechaNacimiento() %></td>
                        <td>
                            <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                                <a href="${pageContext.request.contextPath}/ControladorConsulta?accion=verFicha&idPaciente=<%= p.getIdPaciente() %>" class="btn btn-primary btn-sm">
                                    <i class="fas fa-file-medical"></i> Registrar perfil clinico
                                </a>
                                <a href="${pageContext.request.contextPath}/ControladorMedicamento?accion=prescribir&idPaciente=<%= p.getIdPaciente() %>" class="btn btn-primary btn-sm" style="background-color: #9b59b6; border-color: #9b59b6;">
                                    <i class="fas fa-prescription-bottle-alt"></i> Registrar Medicamento
                                </a>
                                <a href="${pageContext.request.contextPath}/ControladorPaciente?accion=verHistorialMedico&idPaciente=<%= p.getIdPaciente() %>" class="btn btn-primary btn-sm" style="background-color: #1abc9c; border-color: #1abc9c;">
                                    <i class="fas fa-history"></i> Ver Historial
                                </a>
                                <a href="${pageContext.request.contextPath}/ControladorPaciente?accion=cargarRemision&idPaciente=<%= p.getIdPaciente() %>" class="btn btn-primary btn-sm" style="background-color: #f39c12; border-color: #f39c12;">
                                    <i class="fas fa-exchange-alt"></i> Remitir
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="3" style="text-align: center; padding: 40px; color: var(--text-muted);">
                            <i class="fas fa-user-md" style="font-size: 32px; color: #e0e0e0; margin-bottom: 10px; display:block;"></i>
                            Usted aún no tiene pacientes vinculados.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>