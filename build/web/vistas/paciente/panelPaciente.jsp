<%@page import="com.consultex.modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioActivo");
    if (usuarioLogueado == null || !usuarioLogueado.getRol().equalsIgnoreCase("Paciente")) {
        response.sendRedirect("../../index.jsp");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Mi Salud</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <style>
        .sidebar { background: linear-gradient(180deg, var(--secondary) 0%, #1e8449 100%); }
    </style>
</head>
<body>
    <!-- Sidebar -->
        <nav class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <i class="fas fa-heartbeat" style="font-size: 24px;"></i>
            <h3>ConsulTex</h3>
        </div>
        <div style="text-align: center; padding-bottom: 10px;">
            <span class="badge-role">Paciente</span>
        </div>
        <ul class="nav-links">
            <li class="active"><a href="${pageContext.request.contextPath}/vistas/paciente/panelPaciente.jsp"><i class="fas fa-home"></i> Mi Inicio</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=verMiHistorial"><i class="fas fa-history"></i> Ver Historial</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorMedicamento?accion=misRecordatorios"><i class="fas fa-pills"></i> Mis Medicamentos</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorCita?accion=misCitasPaciente"><i class="fas fa-calendar-check"></i> Mis Citas</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=evaluarAtencion"><i class="fas fa-user-md"></i> Evaluar Médico</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=evaluarApp"><i class="fas fa-mobile-alt"></i> Evaluar App</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=verPerfil"><i class="fas fa-user-circle"></i> Mi Perfil</a></li>

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
                <div class="avatar" style="color: var(--secondary); background: #e8f5e9;"><i class="fas fa-user-injured"></i></div>
            </div>
        </header>

        <div class="content-body">
            <div class="page-header">
                <div>
                    <h1>¡Hola de nuevo!</h1>
                    <p>Bienvenido a tu portal de salud personal. Aquí puedes revisar tus diagnósticos y evolución médica.</p>
                </div>
            </div>

            <div class="grid-container">
                <a href="${pageContext.request.contextPath}/ControladorPaciente?accion=verMiHistorial" class="dashboard-card">
                    <i class="fas fa-history" style="color: var(--secondary);"></i>
                    <h3>Ver Historial</h3>
                    <p>Consulta tus signos vitales y diagnósticos.</p>
                </a>
                <a href="${pageContext.request.contextPath}/ControladorMedicamento?accion=misRecordatorios" class="dashboard-card">
                    <i class="fas fa-pills" style="color: var(--secondary);"></i>
                    <h3>Mis Medicamentos</h3>
                    <p>Recordatorios de medicación activa.</p>
                </a>
                <a href="${pageContext.request.contextPath}/ControladorCita?accion=misCitasPaciente" class="dashboard-card">
                    <i class="fas fa-calendar-check" style="color: var(--secondary);"></i>
                    <h3>Mis Citas</h3>
                    <p>Gestiona tus próximas visitas.</p>
                </a>
                <a href="${pageContext.request.contextPath}/ControladorPaciente?accion=evaluarAtencion" class="dashboard-card">
                    <i class="fas fa-user-md" style="color: var(--secondary);"></i>
                    <h3>Evaluar Atención</h3>
                    <p>Califica la atención de tu médico.</p>
                </a>
                <a href="${pageContext.request.contextPath}/ControladorPaciente?accion=evaluarApp" class="dashboard-card">
                    <i class="fas fa-mobile-alt" style="color: var(--secondary);"></i>
                    <h3>Evaluar App</h3>
                    <p>Danos tu opinión sobre ConsulTex.</p>
                </a>
            </div>
        </div>
    </main>

    <script>
        document.getElementById('menuToggle').addEventListener('click', function() {
            document.getElementById('sidebar').classList.toggle('active');
        });

        // Registrar SW y pedir permiso de notificaciones al entrar al panel
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.register('${pageContext.request.contextPath}/sw.js')
                .then(reg => {
                    console.log('[ConsulTex] SW registrado en panel:', reg.scope);
                    if (!('Notification' in window)) {
                        mostrarBannerInseguro();
                        return;
                    }
                    if (Notification.permission === 'granted') {
                        programarDesdePanel(reg);
                    } else if (Notification.permission !== 'denied') {
                        // Banner de permiso suave
                        mostrarBannerPermisoPaciente(reg);
                    }
                }).catch(err => console.warn('[SW] Error:', err));
        } else if (!('Notification' in window)) {
            mostrarBannerInseguro();
        }

        function mostrarBannerInseguro() {
            const b = document.createElement('div');
            b.style.cssText = 'position:fixed;top:16px;right:16px;left:16px;max-width:480px;margin:0 auto;background:linear-gradient(135deg,#e74c3c,#c0392b);color:white;padding:16px 20px;border-radius:14px;box-shadow:0 8px 25px rgba(0,0,0,0.25);display:flex;align-items:center;gap:14px;flex-wrap:wrap;z-index:9999;';
            b.innerHTML = '<i class="fas fa-exclamation-triangle" style="font-size:26px;"></i><div style="flex:1;"><strong>Notificaciones no disponibles</strong><p style="margin:3px 0 0;font-size:13px;opacity:.9;">Tu navegador bloquea las notificaciones (Requiere conexión segura HTTPS o añadir la app a la pantalla de inicio en iOS).</p></div>'
                + '<button onclick="this.closest(\'div\').remove()" style="background:rgba(255,255,255,.2);color:white;border:none;padding:10px 12px;border-radius:8px;cursor:pointer;">✕</button>';
            document.body.appendChild(b);
        }

        function mostrarBannerPermisoPaciente(reg) {
            const b = document.createElement('div');
            b.style.cssText = 'position:fixed;top:16px;right:16px;left:16px;max-width:480px;margin:0 auto;background:linear-gradient(135deg,#2c3e50,#2980b9);color:white;padding:16px 20px;border-radius:14px;box-shadow:0 8px 25px rgba(0,0,0,0.25);display:flex;align-items:center;gap:14px;flex-wrap:wrap;z-index:9999;';
            b.innerHTML = '<i class="fas fa-bell" style="font-size:26px;"></i><div style="flex:1;"><strong>¡Activa recordatorios de medicamentos!</strong><p style="margin:3px 0 0;font-size:13px;opacity:.9;">Te avisaremos 30, 15, 10, 5 y 2 minutos antes de cada toma.</p></div>'
                + '<button onclick="Notification.requestPermission().then(p=>{this.closest(\'div\').remove();if(p===\'granted\')programarDesdePanel(null);})" style="background:#27ae60;color:white;border:none;padding:10px 16px;border-radius:8px;font-weight:700;cursor:pointer;white-space:nowrap;"><i class="fas fa-bell"></i> Activar</button>'
                + '<button onclick="this.closest(\'div\').remove()" style="background:rgba(255,255,255,.2);color:white;border:none;padding:10px 12px;border-radius:8px;cursor:pointer;">✕</button>';
            document.body.appendChild(b);
        }

        function programarDesdePanel(reg) {
            fetch('${pageContext.request.contextPath}/ControladorMedicamento?accion=obtenerRecordatoriosJSON')
                .then(r => r.json())
                .then(meds => {
                    if (!meds.length) return;
                    if (reg && reg.active) {
                        reg.active.postMessage({ type: 'PROGRAMAR_RECORDATORIOS', medicamentos: meds });
                    }
                }).catch(e => console.warn(e));
        }
    </script>
</body>
</html>