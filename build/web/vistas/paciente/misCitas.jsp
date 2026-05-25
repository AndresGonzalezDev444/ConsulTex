<%@page import="com.consultex.modelo.Cita"%>
<%@page import="java.util.List"%>
<%@page import="com.consultex.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioActivo");
    if (usuarioLogueado == null || !usuarioLogueado.getRol().equalsIgnoreCase("Paciente")) {
        response.sendRedirect("../../index.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Mis Citas</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body style="display:block; padding:30px;">
    <div class="form-container" style="max-width: 1000px; margin: 0 auto; padding: 40px;">
        <a href="${pageContext.request.contextPath}/vistas/paciente/panelPaciente.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Volver al panel</a>
        
        <div class="page-header" style="margin-top: 15px; margin-bottom: 30px;">
            <div>
                <h1 style="color:var(--dark);">Mis Citas Médicas</h1>
                <p style="color:var(--text-muted); margin-top:5px;">Consulta tus próximas citas y el estado de tu agenda.</p>
            </div>
        </div>
        
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Médico</th>
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
                                else if(c.getEstado().equalsIgnoreCase("Realizada") || c.getEstado().equalsIgnoreCase("Completada") || c.getEstado().equalsIgnoreCase("Programada")) { colorBadge = "#27ae60"; bgBadge = "#eaeded"; }
                    %>
                    <tr>
                        <td><strong><%= c.getIdCita() %></strong></td>
                        <td><div style="display:flex;align-items:center;gap:8px;"><i class="fas fa-user-md" style="color:var(--text-muted);"></i> Dr. <%= c.getNombreMedico() %></div></td>
                        <td style="font-size:14px;"><i class="far fa-clock" style="color:var(--text-muted);"></i> <%= c.getFechaHora() %></td>
                        <td>
                            <span class="status-badge" style="background-color:<%= bgBadge %>; color:<%= colorBadge %>; border: 1px solid <%= colorBadge %>;"><%= c.getEstado() %></span>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="4" style="text-align: center; padding: 40px; color: var(--text-muted);">
                            <i class="far fa-calendar-times" style="font-size: 32px; color: #e0e0e0; margin-bottom: 10px; display:block;"></i>
                            No tienes citas programadas actualmente.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
