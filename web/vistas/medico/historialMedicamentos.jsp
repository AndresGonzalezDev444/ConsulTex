<%@page import="com.consultex.modelo.Medicamento"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Historial de Medicamentos</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body style="display:block; padding:30px;">
    <div class="form-container" style="max-width: 960px; margin: 0 auto; padding: 40px;">
        <a href="${pageContext.request.contextPath}/ControladorPaciente?accion=misPacientes" class="back-link"><i class="fas fa-arrow-left"></i> Volver a Mis Pacientes</a>
        
        <div class="page-header" style="margin-top: 15px; margin-bottom: 30px; display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 15px;">
            <div>
                <h1 style="color:var(--dark);"><i class="fas fa-pills" style="color:var(--primary);"></i> Historial de Medicamentos</h1>
                <p style="color:var(--text-muted); margin-top:5px;">Registro histórico de medicamentos suministrados al paciente.</p>
            </div>
            <div style="display:flex; gap:10px; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/ControladorMedicamento?accion=prescribir&idPaciente=${param.idPaciente}" class="btn btn-primary" style="background-color: #9b59b6; border-color: #9b59b6;">
                    <i class="fas fa-prescription-bottle-alt"></i> Registrar Medicamento
                </a>
            </div>
        </div>

        <% if (session.getAttribute("mensaje") != null) { %>
            <div class="alert alert-success" style="background-color: #d4edda; color: #155724; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #c3e6cb; display:flex; align-items:center; gap:10px;">
                <i class="fas fa-check-circle" style="font-size:18px;"></i>
                <%= session.getAttribute("mensaje") %>
            </div>
        <% session.removeAttribute("mensaje"); } %>

        <% if (session.getAttribute("error") != null) { %>
            <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #f5c6cb; display:flex; align-items:center; gap:10px;">
                <i class="fas fa-exclamation-circle" style="font-size:18px;"></i>
                <%= session.getAttribute("error") %>
            </div>
        <% session.removeAttribute("error"); } %>

        <div style="display: flex; flex-direction: column; gap: 20px;">
            <% 
                List<Medicamento> lista = (List<Medicamento>) request.getAttribute("medicamentos");
                if(lista != null && !lista.isEmpty()){
                    for(Medicamento m : lista){
            %>
            <div class="card-panel" style="border-left: 4px solid var(--primary); margin-bottom: 0; transition: box-shadow 0.3s;" onmouseover="this.style.boxShadow='0 8px 25px rgba(0,0,0,0.12)'" onmouseout="this.style.boxShadow=''">
                <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap: wrap; gap: 10px;">
                    <div style="display:flex; flex-direction:column; gap:12px; flex:1;">
                        <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:10px;">
                            <span style="font-weight: 700; color: var(--primary); font-size: 18px;">
                                <i class="fas fa-capsules"></i> <%= m.getNombreMedicamento() %>
                            </span>
                            <span style="background:#ebf5fb; padding:5px 12px; border-radius:20px; font-size:13px; color:#2980b9; font-weight: 600;">
                                <i class="fas fa-user-md"></i>
                                <% if(m.getNombreMedico() != null && !m.getNombreMedico().isEmpty()){ %>
                                    Dr. <%= m.getNombreMedico() %>
                                <% } else { %>
                                    Médico tratante
                                <% } %>
                            </span>
                        </div>

                        <div style="display: flex; gap: 15px; background: #f8f9fa; padding: 12px 15px; border-radius: 8px; font-size: 14px; color: var(--text-muted); flex-wrap: wrap;">
                            <span style="display:flex; align-items:center; gap:5px;"><i class="fas fa-syringe" style="color:#e74c3c;"></i> Dosis: <strong><%= m.getDosis() %></strong></span>
                            <span style="display:flex; align-items:center; gap:5px;"><i class="far fa-clock" style="color:#f39c12;"></i> Cada: <strong><%= m.getFrecuenciaHoras() %> horas</strong></span>
                            <span style="display:flex; align-items:center; gap:5px;"><i class="far fa-calendar-alt" style="color:#3498db;"></i> Inicio: <strong><%= m.getFechaInicio() %></strong></span>
                            <span style="display:flex; align-items:center; gap:5px;"><i class="far fa-calendar-check" style="color:#9b59b6;"></i> Fin: <strong><%= m.getFechaFin() %></strong></span>
                        </div>
                    </div>

                    <!-- Botón eliminar -->
                    <div style="padding-left: 15px;">
                        <form method="get" action="${pageContext.request.contextPath}/ControladorMedicamento"
                            onsubmit="return confirm('¿Estás seguro de eliminar el medicamento \"<%= m.getNombreMedicamento() %>\"?\n\nEsta acción lo quitará del panel del paciente.');"
                            style="margin:0;">
                            <input type="hidden" name="accion" value="eliminar">
                            <input type="hidden" name="id" value="<%= m.getIdMedicamento() %>">
                            <input type="hidden" name="idPaciente" value="${param.idPaciente}">
                            <button type="submit" class="btn btn-primary btn-sm"
                                    style="background-color: #e74c3c; border-color: #e74c3c; padding: 8px 16px; border-radius: 8px; cursor:pointer; transition: opacity 0.2s;"
                                    onmouseover="this.style.opacity='0.8'" onmouseout="this.style.opacity='1'">
                                <i class="fas fa-trash-alt"></i> Eliminar
                            </button>
                        </form>
                    </div>
                </div>
            </div>
            <% } } else { %>
                <div style="text-align: center; padding: 60px 20px; color: var(--text-muted); background: white; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05);">
                    <i class="fas fa-prescription-bottle" style="font-size: 48px; color: #e0e0e0; display: block; margin-bottom: 15px;"></i>
                    <h3 style="color:var(--dark); margin-bottom: 5px;">Sin medicamentos</h3>
                    <p>No se han suministrado medicamentos a este paciente.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
