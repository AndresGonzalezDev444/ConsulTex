<%@page import="com.consultex.modelo.Evaluacion"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Evaluaciones</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body style="display:block; padding:30px;">
    <div class="form-container" style="max-width: 1200px;">
        <a href="${pageContext.request.contextPath}/vistas/admin/panelAdmin.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Volver al Panel</a>
        
        <div class="page-header" style="margin-top: 10px;">
            <div>
                <h1>Reporte de Evaluaciones</h1>
                <p>Monitoreo del feedback y calificación de la aplicación web y médicos.</p>
            </div>
        </div>
        
        <div class="card-panel" style="margin-bottom: 20px; border-left: 5px solid #8e44ad;">
            <h3 style="color:var(--dark); margin-bottom: 10px;"><i class="fas fa-laptop-code" style="color:#8e44ad;"></i> Feedback de la App Web</h3>
            <p style="color:var(--text-muted); margin-bottom: 15px;">Acciones para mejorar la aplicación basadas en las calificaciones de los pacientes.</p>
            <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                <button class="btn btn-primary" style="background-color: #f39c12; border-color: #f39c12;" onclick="alert('Enviando informe a los desarrolladores...\n\n(LLegó de forma exitosa)');"><i class="fas fa-paper-plane"></i> Enviar a los desarrolladores</button>
                <a href="https://codepulse-col.netlify.app/" target="_blank" class="btn btn-primary" style="background-color: #8e44ad; border-color: #8e44ad;"><i class="fas fa-envelope"></i> Contacto Developers</a>
            </div>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Paciente</th>
                        <th>Médico Evaluado</th>
                        <th>Calificación Médico</th>
                        <th>Nota Médico</th>
                        <th>Calificación App</th>
                        <th>Nota App</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Evaluacion> lista = (List<Evaluacion>) request.getAttribute("evaluaciones");
                        if(lista != null && !lista.isEmpty()){
                            for(Evaluacion e : lista){ 
                    %>
                    <tr>
                        <td style="font-size:13px; color:var(--text-muted);"><%= e.getFechaEvaluacion() %></td>
                        <td><strong><%= e.getNombrePaciente() != null ? e.getNombrePaciente() : "Desconocido" %></strong></td>
                        <td><%= e.getNombreMedico() != null ? e.getNombreMedico() : "N/A" %></td>
                        <td>
                            <% if(e.getCalificacionMedico() != null && !e.getCalificacionMedico().isEmpty()) { 
                                String c = e.getCalificacionMedico().toLowerCase();
                                String bg = "#ebf5fb", color = "#3498db";
                                if(c.equals("excelente")) { bg = "#e8f8f5"; color = "#27ae60"; }
                                else if(c.equals("intermedia")) { bg = "#fef5e7"; color = "#f39c12"; }
                                else if(c.equals("mala")) { bg = "#fdedec"; color = "#e74c3c"; }
                            %>
                                <span class="status-badge" style="background:<%=bg%>; color:<%=color%>; border:1px solid <%=color%>;"><%= e.getCalificacionMedico() %></span>
                            <% } else { out.print("<span style='color:#ccc'>N/A</span>"); } %>
                        </td>
                        <td><span style="color:var(--text-muted); font-size:13px;"><%= e.getNotaMedico() != null ? e.getNotaMedico() : "" %></span></td>
                        <td>
                            <% if(e.getCalificacionApp() != null && !e.getCalificacionApp().isEmpty()) { 
                                String c = e.getCalificacionApp().toLowerCase();
                                String bg = "#ebf5fb", color = "#3498db";
                                if(c.equals("excelente")) { bg = "#e8f8f5"; color = "#27ae60"; }
                                else if(c.equals("intermedia")) { bg = "#fef5e7"; color = "#f39c12"; }
                                else if(c.equals("mala")) { bg = "#fdedec"; color = "#e74c3c"; }
                            %>
                                <span class="status-badge" style="background:<%=bg%>; color:<%=color%>; border:1px solid <%=color%>;"><%= e.getCalificacionApp() %></span>
                            <% } else { out.print("<span style='color:#ccc'>N/A</span>"); } %>
                        </td>
                        <td><span style="color:var(--text-muted); font-size:13px;"><%= e.getNotaApp() != null ? e.getNotaApp() : "" %></span></td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="7" style="text-align: center; padding: 40px; color: var(--text-muted);">
                        <i class="fas fa-star" style="font-size: 32px; color: #e0e0e0; margin-bottom: 10px; display:block;"></i>
                        No hay evaluaciones registradas.
                    </td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
