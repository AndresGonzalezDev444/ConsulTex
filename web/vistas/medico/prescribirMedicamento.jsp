<%@page import="com.consultex.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioActivo");
    if (usuarioLogueado == null || !usuarioLogueado.getRol().equalsIgnoreCase("Medico")) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String idPaciente = (String) request.getAttribute("idPaciente");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Registrar Medicamento</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body style="display:flex; justify-content:center; align-items:center; min-height:100vh; background-color:var(--bg-light); padding:20px;">
    <div class="form-container" style="max-width: 600px; width: 100%; padding: 40px;">
        <h2 style="color: var(--primary); margin-bottom: 25px; font-size: 24px; text-align: center;"> Registrar Medicamento</h2>
        
        <div class="alert alert-info" style="margin-bottom: 25px; font-size: 14px;">
            <i class="fas fa-info-circle"></i> El paciente recibirá recordatorios automáticos en su panel personal según la frecuencia indicada.
        </div>

        <form method="post" action="${pageContext.request.contextPath}/ControladorMedicamento">
            <input type="hidden" name="accion" value="guardar">
            <input type="hidden" name="idPaciente" value="<%= idPaciente %>">

            <div class="form-group">
                <label for="nombreMedicamento"><i class="fas fa-capsules" style="color:var(--text-muted);"></i> Nombre del Medicamento *</label>
                <input type="text" id="nombreMedicamento" name="nombreMedicamento" required class="form-control" placeholder="Ej: Ibuprofeno 400mg, Amoxicilina...">
            </div>

            <div class="form-group">
                <label for="dosis"><i class="fas fa-syringe" style="color:var(--text-muted);"></i> Dosis *</label>
                <input type="text" id="dosis" name="dosis" required class="form-control" placeholder="Ej: 1 tableta, 5ml, 2 cápsulas...">
            </div>

            <div class="form-group">
                <label for="frecuenciaHoras"><i class="fas fa-clock" style="color:var(--text-muted);"></i> Frecuencia de Toma *</label>
                <select id="frecuenciaHoras" name="frecuenciaHoras" required class="form-control">
                    <option value="">-- Seleccionar frecuencia --</option>
                    <option value="4">Cada 4 horas</option>
                    <option value="6">Cada 6 horas</option>
                    <option value="8">Cada 8 horas</option>
                    <option value="12">Cada 12 horas (dos veces al día)</option>
                    <option value="24">Una vez al día</option>
                    <option value="48">Cada 2 días</option>
                    <option value="72">Cada 3 días</option>
                </select>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                <div class="form-group">
                    <label for="fechaInicio"><i class="fas fa-calendar-plus" style="color:var(--text-muted);"></i> Fecha de Inicio *</label>
                    <input type="date" id="fechaInicio" name="fechaInicio" required class="form-control">
                </div>
                <div class="form-group">
                    <label for="fechaFin"><i class="fas fa-calendar-times" style="color:var(--text-muted);"></i> Fecha de Fin *</label>
                    <input type="date" id="fechaFin" name="fechaFin" required class="form-control">
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-block" style="margin-top: 10px; padding: 12px; font-size: 16px;">
                <i class="fas fa-save"></i> Registrar Medicamento
            </button>
        </form>
        
        <div style="text-align: center; margin-top: 25px;">
            <a href="javascript:history.back()" class="back-link" style="display: inline-block;">
                <i class="fas fa-arrow-left"></i> Volver al historial
            </a>
        </div>
    </div>
    
    <script>
        // Fecha mínima = hoy
        document.getElementById('fechaInicio').min = new Date().toISOString().split('T')[0];
        document.getElementById('fechaFin').min = new Date().toISOString().split('T')[0];
        document.getElementById('fechaInicio').addEventListener('change', function() {
            document.getElementById('fechaFin').min = this.value;
        });
    </script>
</body>
</html>
