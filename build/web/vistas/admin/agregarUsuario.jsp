<%@page import="com.consultex.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioActivo");
    if (usuarioLogueado == null || !usuarioLogueado.getRol().equalsIgnoreCase("Administrador")) {
        response.sendRedirect("../../index.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Registrar Nuevo Usuario</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <script>
        function validatePassword() {
            var pass = document.getElementById("pass").value;
            var confirmPass = document.getElementById("pass_confirm").value;
            if (pass !== confirmPass) {
                alert("Las contraseñas no coinciden");
                return false;
            }
            return true;
        }
    </script>
</head>
<body style="display: flex; justify-content: center; align-items: flex-start; padding: 40px; background-color: var(--bg-main);">
    <div class="card-panel form-container" style="width: 100%; max-width: 500px;">
        <a href="${pageContext.request.contextPath}/vistas/admin/panelAdmin.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Volver al Panel</a>
        
        <h2 style="margin-bottom: 25px; color: var(--dark); font-weight: 700;">Registrar Nuevo Usuario</h2>
        
        <form action="${pageContext.request.contextPath}/ControladorAdmin" method="POST" onsubmit="return validatePassword()">
            <input type="hidden" name="accion" value="registrarNuevoUsuario">
            
            <div class="form-group">
                <label>Nombre Completo</label>
                <input type="text" name="nombre" placeholder="Ej. Juan Pérez" required>
            </div>
            
            <div style="display: flex; gap: 15px;">
                <div class="form-group" style="flex: 1;">
                    <label>Tipo ID</label>
                    <select name="tipoIdentificacion" required>
                        <option value="CC">CC</option>
                        <option value="TI">TI</option>
                        <option value="CE">CE</option>
                    </select>
                </div>
                <div class="form-group" style="flex: 2;">
                    <label>Número de Identificación</label>
                    <input type="text" name="numeroIdentificacion" placeholder="123456789" required>
                </div>
            </div>

            <div class="form-group">
                <label>Correo Electrónico</label>
                <input type="email" name="correo" placeholder="correo@ejemplo.com" required>
            </div>
            
            <div style="display: flex; gap: 15px;">
                <div class="form-group" style="flex: 1;">
                    <label>Contraseña</label>
                    <input type="password" name="password" id="pass" placeholder="******" required>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>Confirmar</label>
                    <input type="password" id="pass_confirm" placeholder="******" required>
                </div>
            </div>
            
            <div class="form-group">
                <label>Rol del Usuario</label>
                <select name="rol" required>
                    <option value="Paciente">Paciente</option>
                    <option value="Medico">Médico</option>
                </select>
            </div>
            
            <div style="display: flex; gap: 15px;">
                <div class="form-group" style="flex: 1;">
                    <label>Edad</label>
                    <input type="number" name="edad" min="0" placeholder="Años" required>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>Sexo</label>
                    <select name="sexo" required>
                        <option value="" disabled selected>Seleccione...</option>
                        <option value="Masculino">Masculino</option>
                        <option value="Femenino">Femenino</option>
                        <option value="LGBTIQ+">LGBTIQ+</option>
                    </select>
                </div>
            </div>
            
            <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 10px; padding: 14px;">
                <i class="fas fa-save"></i> Registrar Usuario
            </button>
        </form>
    </div>
</body>
</html>
