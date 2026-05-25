<%@page import="com.consultex.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioActivo");
    if (usuarioLogueado == null || !usuarioLogueado.getRol().equalsIgnoreCase("Medico")) {
        response.sendRedirect("../../index.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Panel Médico</title>
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
            <span class="badge-role">Médico</span>
        </div>
        
        <ul class="nav-links">
            <li class="active"><a href="${pageContext.request.contextPath}/vistas/medico/panelMedico.jsp"><i class="fas fa-home"></i> Inicio</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=listarDisponibles"><i class="fas fa-user-plus"></i> Vincular Paciente</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=misPacientes"><i class="fas fa-users"></i> Mis Pacientes</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorMedicamento?accion=misMedicamentos"><i class="fas fa-pills"></i> Medicamentos</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorEstadistica?accion=medico"><i class="fas fa-chart-line"></i> Estadísticas</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorCita?accion=agendaMedico"><i class="fas fa-calendar-alt"></i> Agenda</a></li>
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
                <div class="avatar"><i class="fas fa-user-md"></i></div>
            </div>
        </header>

        <div class="content-body">
            <div class="page-header">
                <div>
                    <h1>Bienvenido, Doc. <%= usuarioLogueado.getCorreo() %></h1>
                    <p>Panel principal de gestión médica.</p>
                </div>
            </div>

            <div class="grid-container">
                <a href="${pageContext.request.contextPath}/ControladorPaciente?accion=listarDisponibles" class="dashboard-card">
                    <i class="fas fa-user-plus"></i>
                    <h3>Vincular Paciente</h3>
                    <p>Encontrar nuevos pacientes.</p>
                </a>
                
                <a href="${pageContext.request.contextPath}/ControladorPaciente?accion=misPacientes" class="dashboard-card">
                    <i class="fas fa-users"></i>
                    <h3>Mis Pacientes</h3>
                    <p>Gestionar historia clínica y remitir.</p>
                </a>

                <a href="${pageContext.request.contextPath}/ControladorMedicamento?accion=misMedicamentos" class="dashboard-card">
                    <i class="fas fa-pills"></i>
                    <h3>Medicamentos</h3>
                    <p>Ver prescripciones activas.</p>
                </a>

                <a href="${pageContext.request.contextPath}/ControladorEstadistica?accion=medico" class="dashboard-card">
                    <i class="fas fa-chart-bar"></i>
                    <h3>Estadísticas</h3>
                    <p>Rendimiento y resumen.</p>
                </a>

                <a href="${pageContext.request.contextPath}/ControladorCita?accion=agendaMedico" class="dashboard-card">
                    <i class="fas fa-clock"></i>
                    <h3>Agenda</h3>
                    <p>Consultar citas programadas.</p>
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