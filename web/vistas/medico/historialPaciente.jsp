<%@page import="com.consultex.modelo.Consulta"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Historial del Paciente</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body style="display:block; padding:30px;">
    <div class="form-container" style="max-width: 900px; margin: 0 auto; padding: 40px;">
        <a href="${pageContext.request.contextPath}/ControladorPaciente?accion=misPacientes" class="back-link"><i class="fas fa-arrow-left"></i> Volver a Mis Pacientes</a>
        
        <div class="page-header" style="margin-top: 15px; margin-bottom: 30px; display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 15px;">
            <div>
                <h1 style="color:var(--dark);"> Historial Clínico</h1>
                <p style="color:var(--text-muted); margin-top:5px;">Registro histórico de consultas y diagnósticos del paciente.</p>
            </div>
            <div style="display:flex; gap:10px; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/ControladorMedicamento?accion=historialPaciente&idPaciente=${param.idPaciente}" class="btn btn-primary" style="background-color: var(--primary); border-color: var(--primary);">
                    <i class="fas fa-pills"></i> Historial de medicamentos
                </a>
                <a href="${pageContext.request.contextPath}/ControladorPDF?accion=generarHistorial&idPaciente=${param.idPaciente}" class="btn btn-primary" style="background-color: #e74c3c; border-color: #e74c3c;" target="_blank">
                    <i class="fas fa-file-pdf"></i> Generar PDF
                </a>
                <a href="${pageContext.request.contextPath}/ControladorPDF?accion=enviarCorreo&idPaciente=${param.idPaciente}" class="btn btn-primary" style="background-color: #f39c12; border-color: #f39c12;" onclick="return confirm('¿Desea enviar el historial médico al correo del paciente?');">
                    <i class="fas fa-envelope"></i> Enviar al correo
                </a>
            </div>
        </div>

        <div style="display: flex; flex-direction: column; gap: 20px;">
            <%
                List<Consulta> lista = (List<Consulta>) request.getAttribute("historial");
                if(lista != null && !lista.isEmpty()){
                    for(Consulta c : lista){
            %>
            <div class="card-panel" style="border-left: 4px solid var(--primary); margin-bottom: 0;">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 15px; flex-wrap: wrap; gap: 10px;">
                    <span style="font-weight: 700; color: var(--primary); font-size: 16px;"> <%= c.getFecha() %></span>
                    <span style="background:#ebf5fb; padding:5px 12px; border-radius:20px; font-size:13px; color:#2980b9; font-weight: 600;">
                        <i class="fas fa-user-md"></i> Dr. <%= c.getNombreMedico() %>
                    </span>
                </div>
                
                <div style="margin-bottom: 15px;">
                    <strong style="color:var(--dark);">Motivo de Consulta:</strong>
                    <p style="color:var(--text-muted); margin-top: 5px; line-height: 1.5;"><%= c.getMotivo() %></p>
                </div>
                
                <div style="display: flex; gap: 15px; background: #f8f9fa; padding: 12px 15px; border-radius: 8px; margin: 15px 0; font-size: 13px; color: var(--text-muted); flex-wrap: wrap;">
                    <span style="display:flex; align-items:center; gap:5px;"><i class="fas fa-heartbeat" style="color:var(--primary);"></i> Pulso: <strong><%= c.getFrecuenciaCardiaca() %></strong></span>
                    <span style="display:flex; align-items:center; gap:5px;"><i class="fas fa-thermometer-half" style="color:var(--primary);"></i> Temp: <strong><%= c.getTemperatura() %>°C</strong></span>
                    <span style="display:flex; align-items:center; gap:5px;"><i class="fas fa-weight" style="color:var(--primary);"></i> Peso: <strong><%= c.getPeso() %>kg</strong></span>
                    <span style="display:flex; align-items:center; gap:5px;"><i class="fas fa-tint" style="color:var(--primary);"></i> Presión: <strong><%= c.getPresionArterial() %></strong></span>
                </div>
                
                <div>
                    <strong style="color:var(--dark);"></i> Diagnóstico:</strong>
                    <p style="color:var(--text-muted); margin-top: 5px; line-height: 1.5; background: #fdfefe; padding: 10px; border: 1px solid var(--border-light); border-radius: 5px;"><%= c.getDiagnostico() %></p>
                </div>
            </div>
            <% } } else { %>
                <div style="text-align: center; padding: 60px 20px; color: var(--text-muted); background: white; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05);">
                    <i class="fas fa-folder-open" style="font-size: 48px; color: #e0e0e0; display: block; margin-bottom: 15px;"></i>
                    <h3 style="color:var(--dark); margin-bottom: 5px;">Historial Vacío</h3>
                    <p>El paciente aún no tiene consultas registradas en el sistema.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
