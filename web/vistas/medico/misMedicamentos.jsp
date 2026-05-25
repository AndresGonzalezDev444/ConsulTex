<%@page import="com.consultex.modelo.Usuario"%>
<%@page import="com.consultex.modelo.Medicamento"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioActivo");
    if (usuarioLogueado == null || !usuarioLogueado.getRol().equalsIgnoreCase("Medico")) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    List<Medicamento> medicamentos = (List<Medicamento>) request.getAttribute("medicamentos");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Medicamentos</title>
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
            <li><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=misPacientes"><i class="fas fa-users"></i> Mis Pacientes</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/ControladorMedicamento?accion=misMedicamentos"><i class="fas fa-pills"></i> Medicamentos</a></li>
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
        <div class="page-header" style="margin-bottom: 30px;">
            <div>
                <h1> Medicamentos</h1>
                <p>Gestión de medicamentos de tus pacientes vinculados.</p>
            </div>
        </div>

        <div class="table-container">
            <% if (session.getAttribute("mensaje") != null) { %>
                <div class="alert alert-success" style="background-color: #d4edda; color: #155724; padding: 15px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
                    <%= session.getAttribute("mensaje") %>
                </div>
            <% session.removeAttribute("mensaje"); } %>

            <% if (session.getAttribute("error") != null) { %>
                <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #f5c6cb;">
                    <%= session.getAttribute("error") %>
                </div>
            <% session.removeAttribute("error"); } %>

            <% 
                List<com.consultex.modelo.Paciente> lista = (List<com.consultex.modelo.Paciente>) request.getAttribute("pacientes");
                if (lista != null && !lista.isEmpty()) { 
            %>
            <table>
                <thead>
                    <tr>
                        <th>Nombre Completo</th>
                        <th>Fecha de Vinculación</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (com.consultex.modelo.Paciente p : lista) { %>
                    <tr>
                        <td><div style="display:flex;align-items:center;gap:10px;"><i class="fas fa-user-circle" style="font-size:24px;color:var(--text-muted);"></i> <strong><%= p.getNombreCompleto() %></strong></div></td>
                        <td style="font-size:14px; color:var(--text-muted);"><i class="far fa-calendar-alt"></i> <%= p.getFechaNacimiento() %></td>
                        <td>
                            <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                                <a href="${pageContext.request.contextPath}/ControladorMedicamento?accion=prescribir&idPaciente=<%= p.getIdPaciente() %>" class="btn btn-primary btn-sm" style="background-color: #9b59b6; border-color: #9b59b6;">
                                    <i class="fas fa-prescription-bottle-alt"></i> Registrar Medicamento
                                </a>
                                <a href="${pageContext.request.contextPath}/ControladorMedicamento?accion=historialPaciente&idPaciente=<%= p.getIdPaciente() %>" class="btn btn-primary btn-sm" style="background-color: var(--primary); border-color: var(--primary);">
                                    <i class="fas fa-pills"></i> Historial de medicamentos
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div style="text-align:center; padding:60px 20px; color:var(--text-muted);">
                <i class="fas fa-user-md" style="font-size:48px; margin-bottom:15px; display:block; color:#e0e0e0;"></i>
                <h3 style="color:var(--dark); margin-bottom: 5px;">Sin pacientes</h3>
                <p>Aún no tienes pacientes vinculados para gestionar sus medicamentos.</p>
            </div>
            <% } %>
        </div>
    </main>
</body>
</html>
