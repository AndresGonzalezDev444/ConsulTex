<%@page import="com.consultex.modelo.Paciente"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Activar Médico</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body style="display: flex; justify-content: center; align-items: flex-start; padding: 40px; background-color: var(--bg-main);">
    <div class="card-panel form-container" style="width: 100%; max-width: 600px; border-left: 5px solid #27ae60;">
        <h2 style="margin-bottom: 15px; color: var(--dark); font-weight: 700; display: flex; align-items: center; gap: 10px;">
            <div class="avatar" style="width:40px;height:40px;font-size:18px;background:#e8f8f5;color:#27ae60;"><i class="fas fa-user-check"></i></div> Activar Médico
        </h2>
        <p style="color: var(--text-muted); margin-bottom: 25px; line-height: 1.5; font-size: 14px;">
            Este médico tenía pacientes asociados antes de ser deshabilitado. Selecciona a cuáles pacientes deseas mantenerle asignados. Los pacientes desmarcados quedarán libres ("Sin Médico").
        </p>
        
        <form action="${pageContext.request.contextPath}/ControladorAdmin" method="POST">
            <input type="hidden" name="accion" value="activarYReasignar">
            <input type="hidden" name="idUsuario" value="<%= request.getAttribute("idUsuario") %>">
            <input type="hidden" name="todosIds" value="<%= request.getAttribute("todosIds") %>">
            
            <div style="margin: 20px 0; border: 1px solid var(--border-light); border-radius: 8px; padding: 10px; max-height: 300px; overflow-y: auto; background: white;">
                <% 
                    List<Paciente> lista = (List<Paciente>) request.getAttribute("pacientes");
                    if (lista != null && !lista.isEmpty()) {
                        for(Paciente p : lista) {
                %>
                <div style="padding: 12px; border-bottom: 1px solid var(--border-light); display: flex; align-items: center; gap: 12px;">
                    <input type="checkbox" name="pacientesAprobados" value="<%= p.getIdPaciente() %>" id="pac_<%= p.getIdPaciente() %>" checked style="width: 18px; height: 18px; cursor: pointer;">
                    <label for="pac_<%= p.getIdPaciente() %>" style="cursor: pointer; width: 100%; display: flex; align-items: center; gap: 10px;">
                        <i class="fas fa-user-injured" style="color:var(--text-muted);"></i>
                        <div>
                            <strong style="color:var(--dark);"><%= p.getNombreCompleto() %></strong>
                            <div style="font-size: 12px; color: var(--text-muted);">Nacido: <%= p.getFechaNacimiento() %></div>
                        </div>
                    </label>
                </div>
                <%      }
                    } else { %>
                    <div style="padding: 20px; text-align: center; color: var(--text-muted);">No se encontraron pacientes asociados.</div>
                <%  } %>
            </div>
            
            <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 15px; padding: 12px; background-color: #27ae60; border-color: #27ae60;">
                <i class="fas fa-check-circle"></i> Confirmar Activación
            </button>
            <a href="${pageContext.request.contextPath}/ControladorAdmin?accion=listarMedicos" class="btn btn-outline" style="width: 100%; margin-top: 10px; padding: 12px; text-align: center;">
                <i class="fas fa-times"></i> Cancelar
            </a>
        </form>
    </div>
</body>
</html>
