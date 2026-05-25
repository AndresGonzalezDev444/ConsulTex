<%@page import="com.consultex.modelo.Cita"%>
<%@page import="com.consultex.modelo.Paciente"%>
<%@page import="java.util.List"%>
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
    <title>ConsulTex - Agenda</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body style="display:block; padding:30px;">
    <div class="form-container" style="max-width: 1200px;">
        <a href="${pageContext.request.contextPath}/vistas/medico/panelMedico.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Volver al Panel</a>
        
        <div class="page-header" style="margin-top: 10px;">
            <div>
                <h1> Mi Agenda</h1>
                <p>Gestiona tus citas programadas y agenda nuevas consultas con tus pacientes vinculados.</p>
            </div>
        </div>
        
        <div class="card-panel" style="margin-bottom: 25px; border-left: 5px solid var(--primary);">
            <h3 style="color:var(--dark); margin-bottom: 15px;"><i class="fas fa-calendar-plus" style="color:var(--primary);"></i> Agendar Nueva Cita</h3>
            <form action="${pageContext.request.contextPath}/ControladorCita" method="POST" style="display: flex; gap: 15px; align-items: flex-end; flex-wrap: wrap;">
                <input type="hidden" name="accion" value="agendar">
                <input type="hidden" name="idMedico" value="<%= request.getAttribute("idMedico") %>">
                
                <div class="form-group" style="flex: 1; min-width: 250px;">
                    <label>Paciente:</label>
                    <select name="idPaciente" required class="form-control">
                        <option value="" disabled selected>Seleccione un paciente vinculado</option>
                        <% 
                            List<Paciente> pacientes = (List<Paciente>) request.getAttribute("pacientesVinculados");
                            if(pacientes != null) {
                                for(Paciente p : pacientes) {
                        %>
                        <option value="<%= p.getIdPaciente() %>"><%= p.getNombreCompleto() %></option>
                        <% } } %>
                    </select>
                </div>
                
                <div class="form-group" style="flex: 1; min-width: 200px;">
                    <label>Fecha y Hora:</label>
                    <input type="datetime-local" name="fechaHora" required class="form-control">
                </div>
                
                <button type="submit" class="btn btn-primary" style="height: 42px; margin-bottom: 15px;"><i class="fas fa-save"></i> Agendar Cita</button>
            </form>
        </div>

        <h3 style="margin-bottom: 15px; color:var(--dark);"><i class="fas fa-list"></i> Citas Programadas</h3>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Paciente</th>
                        <th>Fecha y Hora</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Cita> citas = (List<Cita>) request.getAttribute("citas");
                        if(citas != null && !citas.isEmpty()){
                            for(Cita c : citas){ 
                                String colorBadge = "#3498db";
                                String bgBadge = "#ebf5fb";
                                if(c.getEstado().equalsIgnoreCase("Cancelada")) { colorBadge = "#e74c3c"; bgBadge = "#fdedec"; }
                                else if(c.getEstado().equalsIgnoreCase("Reprogramada")) { colorBadge = "#f39c12"; bgBadge = "#fef5e7"; }
                                else if(c.getEstado().equalsIgnoreCase("Realizada") || c.getEstado().equalsIgnoreCase("Completada")) { colorBadge = "#27ae60"; bgBadge = "#eaeded"; }
                    %>
                    <tr>
                        <td><strong><%= c.getIdCita() %></strong></td>
                        <td><div style="display:flex;align-items:center;gap:8px;"><i class="fas fa-user-injured" style="color:var(--text-muted);"></i> <%= c.getNombrePaciente() %></div></td>
                        <td style="font-size:14px;"><i class="far fa-clock" style="color:var(--text-muted);"></i> <%= c.getFechaHora() %></td>
                        <td>
                            <span class="status-badge" style="background-color:<%= bgBadge %>; color:<%= colorBadge %>; border: 1px solid <%= colorBadge %>;"><%= c.getEstado() %></span>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="4" style="text-align: center; padding: 40px; color: var(--text-muted);">
                            <i class="far fa-calendar-times" style="font-size: 32px; color: #e0e0e0; margin-bottom: 10px; display:block;"></i>
                            No tienes citas agendadas actualmente.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
