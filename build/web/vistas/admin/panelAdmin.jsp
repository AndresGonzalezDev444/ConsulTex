<%@page import="com.consultex.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioActivo");
    if (usuarioLogueado == null || (!usuarioLogueado.getRol().equalsIgnoreCase("Admin") && !usuarioLogueado.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Panel Administrador</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
    <!-- Sidebar -->
        <nav class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <i class="fas fa-heartbeat" style="font-size: 24px;"></i>
            <h3>ConsulTex</h3>
        </div>
        <div style="text-align: center; padding-bottom: 10px;">
            <span class="badge-role">Administrador</span>
        </div>
        
        <ul class="nav-links">
            <li class="active"><a href="${pageContext.request.contextPath}/vistas/admin/panelAdmin.jsp"><i class="fas fa-home"></i> Inicio</a></li>
            <%-- <li><a href="${pageContext.request.contextPath}/ControladorUsuario?accion=listar"><i class="fas fa-users-cog"></i> Usuarios</a></li> --%>
            <li><a href="${pageContext.request.contextPath}/ControladorSolicitudMedico?accion=listar"><i class="fas fa-user-md"></i> Solicitudes Médicos</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorSolicitudVinculacion?accion=listarPendientes"><i class="fas fa-link"></i> Vinculaciones</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorEstadistica?accion=ver"><i class="fas fa-chart-pie"></i> Estadísticas</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorEspecialidad?accion=listar"><i class="fas fa-stethoscope"></i> Especialidades</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorAdmin?accion=verEvaluaciones"><i class="fas fa-star"></i> Evaluaciones</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorCita?accion=gestionCitasAdmin"><i class="fas fa-calendar-alt"></i> Citas Globales</a></li>
        </ul>

        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/ControladorCerrarSesion" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
            </a>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="main-wrapper">
        <header class="top-navbar">
            <div class="menu-toggle" id="menuToggle">
                <i class="fas fa-bars"></i>
            </div>
            <div class="user-info">
                <span><%= usuarioLogueado.getCorreo() %></span>
                <div class="avatar"><i class="fas fa-user"></i></div>
            </div>
        </header>

        <div class="content-body">
            <div class="page-header">
                <div>
                    <h1>Bienvenido, Administrador</h1>
                    <p>Panel de control global del sistema ConsulTex.</p>
                </div>
            </div>

            <div class="grid-container">
                <a href="${pageContext.request.contextPath}/ControladorAdmin?accion=listarMedicos" class="dashboard-card">
                    <i class="fas fa-user-md"></i>
                    <h3>Médicos</h3>
                    <p>Dar de alta, baja o editar personal médico.</p>
                </a>
                <a href="${pageContext.request.contextPath}/ControladorAdmin?accion=listarPacientes" class="dashboard-card">
                    <i class="fas fa-user-injured"></i>
                    <h3>Pacientes</h3>
                    <p>Control de registros y cuentas de pacientes.</p>
                </a>
                <a href="${pageContext.request.contextPath}/ControladorSolicitudMedico?accion=listar" class="dashboard-card">
                    <i class="fas fa-file-medical-alt"></i>
                    <h3>Solicitudes Médicos</h3>
                    <p>Revisar documentos y aprobar médicos.</p>
                </a>
                <a href="${pageContext.request.contextPath}/ControladorSolicitudVinculacion?accion=listarPendientes" class="dashboard-card">
                    <i class="fas fa-link"></i>
                    <h3>Vinculaciones</h3>
                    <p>Aprobar relaciones Médico-Paciente.</p>
                </a>
                <a href="${pageContext.request.contextPath}/ControladorEstadistica?accion=ver" class="dashboard-card">
                    <i class="fas fa-chart-pie"></i>
                    <h3>Estadísticas</h3>
                    <p>Ver consolidados y gráficos interactivos.</p>
                </a>
                <a href="${pageContext.request.contextPath}/ControladorEspecialidad?accion=listar" class="dashboard-card">
                    <i class="fas fa-stethoscope"></i>
                    <h3>Especialidades</h3>
                    <p>Crear y gestionar especialidades médicas.</p>
                </a>
                <a href="${pageContext.request.contextPath}/ControladorAdmin?accion=verEvaluaciones" class="dashboard-card">
                    <i class="fas fa-star-half-alt"></i>
                    <h3>Evaluaciones</h3>
                    <p>Ver feedback de pacientes y contactar devs.</p>
                </a>
                <a href="${pageContext.request.contextPath}/ControladorCita?accion=gestionCitasAdmin" class="dashboard-card">
                    <i class="fas fa-calendar-alt"></i>
                    <h3>Gestión Citas</h3>
                    <p>Reprogramar o cancelar citas del sistema.</p>
                </a>
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