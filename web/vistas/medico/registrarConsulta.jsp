<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Registrar Consulta</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body style="display:flex; justify-content:center; align-items:center; min-height:100vh; background-color:var(--bg-light); padding:20px;">
    <div class="form-container" style="max-width: 700px; width: 100%; padding: 40px;">
        <h2 style="color: var(--primary); margin-bottom: 25px; font-size: 24px; text-align: center;"> Nueva Ficha Clínica</h2>
        
        <form action="${pageContext.request.contextPath}/ControladorConsulta" method="POST">
            <input type="hidden" name="idPaciente" value="<%= request.getAttribute("idP") %>">
            
            <div class="form-group" style="margin-bottom: 20px;">
                <label style="font-weight: 600; color: var(--dark); margin-bottom: 8px; display: block;"><i class="far fa-calendar-alt" style="color:var(--text-muted);"></i> Fecha de Consulta</label>
                <input type="date" name="fecha" required class="form-control">
            </div>
            
            <div class="form-group" style="margin-bottom: 20px;">
                <label style="font-weight: 600; color: var(--dark); margin-bottom: 8px; display: block;"><i class="fas fa-comment-medical" style="color:var(--text-muted);"></i> Motivo de la Consulta</label>
                <textarea name="motivo" rows="2" required class="form-control" placeholder="Describa el motivo principal de la consulta..."></textarea>
            </div>

            <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 25px; border-left: 4px solid var(--primary);">
                <h4 style="margin-bottom: 15px; color: var(--dark); font-size: 15px;"><i class="fas fa-heartbeat" style="color:var(--primary);"></i> Signos Vitales</h4>
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 15px;">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label style="font-size: 13px;">Presión Arterial</label>
                        <input type="text" name="presion" placeholder="120/80" class="form-control">
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label style="font-size: 13px;">Temperatura (°C)</label>
                        <input type="number" step="0.1" name="temperatura" class="form-control" placeholder="36.5">
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label style="font-size: 13px;">Frec. Cardíaca</label>
                        <input type="number" name="frecuencia" class="form-control" placeholder="80">
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label style="font-size: 13px;">Peso (Kg)</label>
                        <input type="number" step="0.1" name="peso" class="form-control" placeholder="70.5">
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label style="font-size: 13px;">Estatura (m)</label>
                        <input type="number" step="0.01" name="estatura" placeholder="1.75" class="form-control">
                    </div>
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 25px;">
                <label style="font-weight: 600; color: var(--dark); margin-bottom: 8px; display: block;"><i class="fas fa-stethoscope" style="color:var(--text-muted);"></i> Diagnóstico / Observaciones</label>
                <textarea name="diagnostico" rows="3" class="form-control" placeholder="Escriba el diagnóstico y observaciones adicionales..."></textarea>
            </div>

            <button type="submit" name="accion" value="GuardarConsulta" class="btn btn-primary btn-block" style="padding: 12px; font-size: 16px;">
                <i class="fas fa-save"></i> Guardar Ficha Médica
            </button>
        </form>
        
        <div style="text-align: center; margin-top: 25px;">
            <a href="javascript:history.back()" class="back-link" style="display: inline-block;">
                <i class="fas fa-arrow-left"></i> Volver al panel
            </a>
        </div>
    </div>
</body>
</html>