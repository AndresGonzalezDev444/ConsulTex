<%@page import="com.consultex.modelo.Cita"%>
<%@page import="java.util.List"%>
<%@page import="com.consultex.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioActivo");
    if (usuarioLogueado == null || (!usuarioLogueado.getRol().equalsIgnoreCase("Admin") && !usuarioLogueado.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect("../../index.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Gestión de Citas</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body style="display:block; padding:30px;">
    <div class="form-container" style="max-width: 1100px;">
        <a href="${pageContext.request.contextPath}/vistas/admin/panelAdmin.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Volver al Panel</a>
        
        <div class="page-header" style="margin-top: 10px;">
            <div>
                <h1>Gestión Global de Citas</h1>
                <p>Administra y monitorea todas las citas del sistema.</p>
            </div>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Médico</th>
                        <th>Paciente</th>
                        <th>Fecha y Hora</th>
                        <th>Estado</th>
                        <th>Acciones</th>
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
                        <td><div style="display:flex;align-items:center;gap:8px;"><i class="fas fa-user-md" style="color:var(--text-muted);"></i> Dr. <%= c.getNombreMedico() %></div></td>
                        <td><div style="display:flex;align-items:center;gap:8px;"><i class="fas fa-user-injured" style="color:var(--text-muted);"></i> <%= c.getNombrePaciente() %></div></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/ControladorCita" method="POST" style="display:flex; gap:5px; align-items:center;">
                                <input type="hidden" name="accion" value="reprogramarAdmin">
                                <input type="hidden" name="idCita" value="<%= c.getIdCita() %>">
                                <input type="datetime-local" name="nuevaFechaHora" value="<%= c.getFechaHora().replace(" ", "T").substring(0, 16) %>" required <%= c.getEstado().equalsIgnoreCase("Cancelada") ? "disabled" : "" %> style="padding: 6px; border-radius: 4px; border: 1px solid var(--border-light); font-size:13px; outline:none;">
                                <% if(!c.getEstado().equalsIgnoreCase("Cancelada")) { %>
                                    <button type="submit" class="btn btn-outline btn-sm" title="Reprogramar" style="padding: 6px 10px; border-color:var(--warning); color:var(--warning);"><i class="fas fa-sync-alt"></i></button>
                                <% } %>
                            </form>
                        </td>
                        <td>
                            <span class="status-badge" style="background-color:<%= bgBadge %>; color:<%= colorBadge %>; border: 1px solid <%= colorBadge %>;"><%= c.getEstado() %></span>
                        </td>
                        <td>
                            <% if(!c.getEstado().equalsIgnoreCase("Cancelada")) { %>
                            <form action="${pageContext.request.contextPath}/ControladorCita" method="POST" style="display:inline;" onsubmit="return confirm('¿Está seguro de cancelar esta cita?');">
                                <input type="hidden" name="accion" value="cancelarAdmin">
                                <input type="hidden" name="idCita" value="<%= c.getIdCita() %>">
                                <button type="submit" class="btn btn-danger btn-sm" title="Cancelar Cita"><i class="fas fa-times"></i> Cancelar</button>
                            </form>
                            <% } %>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="6" style="text-align: center; padding: 40px; color: var(--text-muted);">
                            <i class="fas fa-calendar-times" style="font-size: 32px; color: #e0e0e0; margin-bottom: 10px; display:block;"></i>
                            No hay citas registradas en el sistema.
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
