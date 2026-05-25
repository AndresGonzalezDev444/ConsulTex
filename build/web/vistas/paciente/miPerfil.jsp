<%@page import="com.consultex.modelo.Paciente"%>
<%@page import="com.consultex.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioActivo");
    if (usuarioLogueado == null || !usuarioLogueado.getRol().equalsIgnoreCase("Paciente")) {
        response.sendRedirect("../../index.jsp");
        return; 
    }
    
    Paciente perfil = (Paciente) request.getAttribute("perfil");
    if (perfil == null) {
        // Redirigir al controlador si no hay datos
        response.sendRedirect(request.getContextPath() + "/ControladorPaciente?accion=verPerfil");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Mi Perfil</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        /* Ajuste de colores específicos para paciente si es necesario sobreescribir el sidebar */
        .sidebar { background: linear-gradient(180deg, var(--secondary) 0%, #1e8449 100%); }
    </style>
</head>
<body>
        <nav class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <i class="fas fa-heartbeat" style="font-size: 24px;"></i>
            <h3>ConsulTex</h3>
        </div>
        <div style="text-align: center; padding-bottom: 10px;">
            <span class="badge-role">Paciente</span>
        </div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/vistas/paciente/panelPaciente.jsp"><i class="fas fa-home"></i> Mi Inicio</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=verMiHistorial"><i class="fas fa-history"></i> Ver Historial</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorMedicamento?accion=misRecordatorios"><i class="fas fa-pills"></i> Mis Medicamentos</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorCita?accion=misCitasPaciente"><i class="fas fa-calendar-check"></i> Mis Citas</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=evaluarAtencion"><i class="fas fa-user-md"></i> Evaluar Médico</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=evaluarApp"><i class="fas fa-mobile-alt"></i> Evaluar App</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=verPerfil"><i class="fas fa-user-circle"></i> Mi Perfil</a></li>

        </ul>
        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/ControladorCerrarSesion" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
            </a>
        </div>
    </nav>

    <main class="main-wrapper">
        <header class="top-navbar">
            <div class="menu-toggle" id="menuToggle">
                <i class="fas fa-bars"></i>
            </div>
            <div class="user-info">
                <span><%= usuarioLogueado.getCorreo() %></span>
                <div class="avatar" style="color: var(--secondary); background: #e8f5e9;"><i class="fas fa-user-injured"></i></div>
            </div>
        </header>

        <div class="content-body">
            <div class="page-header">
                <div>
                    <h1><i class="fas fa-user-circle" style="color:var(--secondary);"></i> Configuración de Perfil</h1>
                    <p>Actualiza tu información personal y opciones de seguridad.</p>
                </div>
            </div>

            <% if (request.getAttribute("mensajeExito") != null) { %>
                <div class="alert alert-success" style="margin-bottom: 20px;"><i class="fas fa-check-circle"></i> <%= request.getAttribute("mensajeExito") %></div>
            <% } %>
            <% if (request.getAttribute("mensajeError") != null) { %>
                <div class="alert alert-danger" style="margin-bottom: 20px;"><i class="fas fa-exclamation-triangle"></i> <%= request.getAttribute("mensajeError") %></div>
            <% } %>

            <div class="grid-container" style="grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));">
                <!-- Sección de Información Personal -->
                <div class="card-panel">
                    <h2 style="color: var(--secondary); margin-bottom: 20px; font-size: 20px; border-bottom: 2px solid #eee; padding-bottom: 10px;"><i class="fas fa-address-card"></i> Información Personal</h2>
                    <form action="${pageContext.request.contextPath}/ControladorPaciente" method="POST">
                        <input type="hidden" name="accion" value="actualizarPerfil">
                        
                        <div class="form-group">
                            <label style="color: var(--dark); font-weight: 600;"><i class="fas fa-user" style="color:var(--text-muted);"></i> Nombre Completo</label>
                            <input type="text" class="form-control" value="<%= perfil.getNombreCompleto() %>" readonly style="background-color:#f8f9fa;">
                        </div>
                        
                        <div class="form-group">
                            <label style="color: var(--dark); font-weight: 600;"><i class="fas fa-user-md" style="color:var(--text-muted);"></i> Médico Vinculado</label>
                            <input type="text" class="form-control" value="<%= perfil.getNombreMedico() %>" readonly style="background-color:#f8f9fa;">
                        </div>

                        <div class="form-group">
                            <label style="color: var(--dark); font-weight: 600;"><i class="fas fa-id-badge" style="color:var(--text-muted);"></i> ID Paciente (Expediente)</label>
                            <input type="text" class="form-control" value="<%= perfil.getIdPaciente() %>" readonly style="background-color:#f8f9fa;">
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                            <div class="form-group">
                                <label style="color: var(--dark); font-weight: 600;"><i class="fas fa-calendar-alt" style="color:var(--text-muted);"></i> Edad (Años)</label>
                                <input type="number" name="edad" class="form-control" value="<%= perfil.getEdad() %>" min="0" required>
                            </div>

                            <div class="form-group">
                                <label style="color: var(--dark); font-weight: 600;"><i class="fas fa-venus-mars" style="color:var(--text-muted);"></i> Sexo</label>
                                <select name="sexo" class="form-control" required>
                                    <option value="Masculino" <%= "Masculino".equals(perfil.getSexo()) ? "selected" : "" %>>Masculino</option>
                                    <option value="Femenino" <%= "Femenino".equals(perfil.getSexo()) ? "selected" : "" %>>Femenino</option>
                                    <option value="LGBTIQ+" <%= "LGBTIQ+".equals(perfil.getSexo()) ? "selected" : "" %>>LGBTIQ+</option>
                                </select>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary btn-block" style="background-color: var(--secondary); border-color: var(--secondary); margin-top: 10px;"><i class="fas fa-save"></i> Guardar Cambios</button>
                    </form>
                </div>

                <!-- Sección de Seguridad de la Cuenta -->
                <div class="card-panel">
                    <h2 style="color: var(--dark); margin-bottom: 20px; font-size: 20px; border-bottom: 2px solid #eee; padding-bottom: 10px;"><i class="fas fa-lock" style="color:var(--primary);"></i> Seguridad de la Cuenta</h2>
                    
                    <div class="form-group">
                        <label style="color: var(--dark); font-weight: 600;"><i class="fas fa-envelope" style="color:var(--text-muted);"></i> Correo Electrónico Actual</label>
                        <input type="email" class="form-control" value="<%= perfil.getCorreo() %>" readonly style="background-color:#f8f9fa;">
                    </div>
                    
                    <div class="form-group">
                        <label style="color: var(--dark); font-weight: 600;"><i class="fas fa-envelope-open" style="color:var(--text-muted);"></i> Nuevo Correo Electrónico</label>
                        <input type="email" class="form-control" placeholder="ejemplo@correo.com">
                    </div>

                    <div class="form-group">
                        <label style="color: var(--dark); font-weight: 600;"><i class="fas fa-key" style="color:var(--text-muted);"></i> Nueva Contraseña</label>
                        <input type="password" class="form-control" placeholder="••••••••">
                    </div>
                    
                    <div class="form-group">
                        <label style="color: var(--dark); font-weight: 600;"><i class="fas fa-check-double" style="color:var(--text-muted);"></i> Confirmar Nueva Contraseña</label>
                        <input type="password" class="form-control" placeholder="••••••••">
                    </div>

                    <button type="button" class="btn btn-block" style="background-color: #e0e0e0; color: #757575; border: none; cursor: not-allowed; margin-top: 10px;" title="Esta función estará disponible próximamente" disabled><i class="fas fa-shield-alt"></i> Actualizar Seguridad (Próximamente)</button>
                </div>
            </div>
        </div>
    </main>

    <script>
        document.getElementById('menuToggle').addEventListener('click', function() {
            document.getElementById('sidebar').classList.toggle('active');
        });
    </script>
</body>
</html>
