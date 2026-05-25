<%@page import="com.consultex.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Editar Usuario</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body style="display: flex; justify-content: center; align-items: flex-start; padding: 40px; background-color: var(--bg-main);">
    <div class="card-panel form-container" style="width: 100%; max-width: 400px;">
        <h2 style="margin-bottom: 25px; color: var(--dark); font-weight: 700; display: flex; align-items: center; gap: 10px;">
            <div class="avatar" style="width:40px;height:40px;font-size:18px;"><i class="fas fa-user-edit"></i></div> Editar Usuario
        </h2>
        <% 
            Usuario u = (Usuario) request.getAttribute("usuarioObj");
            if(u != null) {
        %>
        <form action="${pageContext.request.contextPath}/ControladorAdmin" method="POST">
            <input type="hidden" name="accion" value="actualizarUsuario">
            <input type="hidden" name="id" value="<%= u.getIdUsuario() %>">
            <input type="hidden" name="rol" value="<%= u.getRol() %>">
            <input type="hidden" name="tipoRetorno" value="<%= u.getRol().equals("Medico") ? "listarMedicos" : "listarPacientes" %>">
            
            <div class="form-group">
                <label>Correo Electrónico:</label>
                <div style="position: relative;">
                    <i class="fas fa-envelope" style="position: absolute; left: 15px; top: 15px; color: var(--text-muted);"></i>
                    <input type="email" name="correo" value="<%= u.getCorreo() %>" required style="padding-left: 45px;">
                </div>
            </div>
            
            <div class="form-group">
                <label>Contraseña:</label>
                <div style="position: relative;">
                    <i class="fas fa-lock" style="position: absolute; left: 15px; top: 15px; color: var(--text-muted);"></i>
                    <input type="text" name="password" value="<%= u.getPassword() %>" required style="padding-left: 45px;">
                </div>
            </div>
            
            <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 15px; padding: 12px;">
                <i class="fas fa-save"></i> Guardar Cambios
            </button>
            <a href="${pageContext.request.contextPath}/ControladorAdmin?accion=<%= u.getRol().equals("Medico") ? "listarMedicos" : "listarPacientes" %>" class="btn btn-outline" style="width: 100%; margin-top: 10px; padding: 12px; text-align: center;">
                <i class="fas fa-times"></i> Cancelar
            </a>
        </form>
        <% } else { %>
            <div class="alert alert-danger">Error al cargar el usuario.</div>
            <a href="${pageContext.request.contextPath}/vistas/admin/panelAdmin.jsp" class="btn btn-secondary" style="width:100%;"><i class="fas fa-arrow-left"></i> Volver al Panel</a>
        <% } %>
    </div>
</body>
</html>
