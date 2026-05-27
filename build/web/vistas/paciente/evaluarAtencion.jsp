<%@page import="com.consultex.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Evaluar Atención Médica</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body style="display:flex; justify-content:center; align-items:center; min-height:100vh; background-color:var(--bg-light); padding:20px;">
    <div class="form-container" style="max-width: 500px; width: 100%; padding: 40px; border-left: 5px solid var(--secondary);">
        <h2 style="color: var(--dark); margin-bottom: 10px; font-size: 24px;"> Evaluar Atención Médica</h2>
        <p style="color: var(--text-muted); margin-bottom: 25px;">Tu opinión es muy importante para mejorar nuestro servicio.</p>
        
        <% 
            String error = (String) request.getAttribute("error");
            if(error != null) {
        %>
            <div class="alert alert-danger" style="margin-bottom: 25px;"><i class="fas fa-exclamation-triangle"></i> <%= error %></div>
            <a href="${pageContext.request.contextPath}/vistas/paciente/panelPaciente.jsp" class="btn btn-primary btn-block" style="text-align: center; background-color: var(--secondary); border-color: var(--secondary);">Volver al Panel</a>
        <% } else { %>
            <form action="${pageContext.request.contextPath}/ControladorPaciente" method="POST">
                <input type="hidden" name="accion" value="guardarEvaluacionAtencion">
                
                <div class="form-group" style="margin-bottom: 25px;">
                    <label style="font-weight: 600; color: var(--dark); margin-bottom: 15px; display: block;">¿Cómo calificarías la atención y comunicación de tu médico?</label>
                    <div style="display: flex; flex-direction: column; gap: 12px; background: #f8f9fa; padding: 15px; border-radius: 8px; align-items: center;">
                        <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; font-weight: normal; width: 140px; justify-content: flex-start;"><input type="radio" name="calificacion" value="Mala" required> <span class="status-badge" style="background:#fdedec; color:#e74c3c; border: 1px solid #e74c3c; width: 90px; text-align: center;">Mala</span></label>
                        <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; font-weight: normal; width: 140px; justify-content: flex-start;"><input type="radio" name="calificacion" value="Intermedia" required> <span class="status-badge" style="background:#fef5e7; color:#f39c12; border: 1px solid #f39c12; width: 90px; text-align: center;">Intermedia</span></label>
                        <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; font-weight: normal; width: 140px; justify-content: flex-start;"><input type="radio" name="calificacion" value="Buena" required> <span class="status-badge" style="background:#ebf5fb; color:#3498db; border: 1px solid #3498db; width: 90px; text-align: center;">Buena</span></label>
                        <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; font-weight: normal; width: 140px; justify-content: flex-start;"><input type="radio" name="calificacion" value="Excelente" required> <span class="status-badge" style="background:#e8f8f5; color:#1abc9c; border: 1px solid #1abc9c; width: 90px; text-align: center;">Excelente</span></label>
                    </div>
                </div>
                
                <div class="form-group" style="margin-bottom: 25px;">
                    <label style="font-weight: 600; color: var(--dark); margin-bottom: 8px; display: block;">Comentarios adicionales (Opcional):</label>
                    <textarea name="nota" class="form-control" rows="3" placeholder="Cuéntanos más sobre tu experiencia..."></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary btn-block" style="padding: 12px; font-size: 16px; background-color: var(--secondary); border-color: var(--secondary);">Enviar Evaluación</button>
                <div style="text-align: center; margin-top: 15px;">
                    <a href="${pageContext.request.contextPath}/vistas/paciente/panelPaciente.jsp" class="back-link" style="display: inline-block;">Cancelar</a>
                </div>
            </form>
        <% } %>
    </div>
</body>
</html>
