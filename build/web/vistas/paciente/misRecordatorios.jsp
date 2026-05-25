<%@page import="com.consultex.modelo.Usuario"%>
<%@page import="com.consultex.modelo.Medicamento"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioActivo");
    if (usuarioLogueado == null || !usuarioLogueado.getRol().equalsIgnoreCase("Paciente")) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    List<Medicamento> medicamentos = (List<Medicamento>) request.getAttribute("medicamentos");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String hoy = sdf.format(Calendar.getInstance().getTime());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Mis Medicamentos</title>
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
            <li class="active"><a href="${pageContext.request.contextPath}/ControladorMedicamento?accion=misRecordatorios"><i class="fas fa-pills"></i> Mis Medicamentos</a></li>
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
            <div class="page-header" style="display:flex; justify-content:space-between; align-items:center;">
                <div>
                    <h1> Mis Medicamentos</h1>
                    <p>Tus medicamentos prescritos por tu médico. Te indicamos cuándo es tu próxima toma.</p>
                </div>
                <div style="text-align: right; color: var(--text-muted); font-size: 14px;">
                    Hora actual: <br><span id="reloj" style="font-weight: 600; color: var(--secondary); font-size: 20px;">--:--:--</span>
                </div>
            </div>

            <!-- Contenedor de alertas visuales en tiempo real -->
            <div id="alertas-container" style="margin-bottom: 20px;"></div>

            <% if (medicamentos != null && !medicamentos.isEmpty()) { %>
            <div class="alert alert-info" style="background: linear-gradient(135deg, var(--secondary), #2ecc71); color: white; border: none; padding: 25px; display: flex; align-items: center; gap: 20px; margin-bottom: 30px;">
                <i class="fas fa-bell" style="font-size: 40px; animation: pulse 1.5s infinite;"></i>
                <div>
                    <h3 style="font-size: 18px; margin-bottom: 5px;">¡Recuerda tomar tu medicación puntualmente!</h3>
                    <p style="font-size: 14px; opacity: 0.9; margin:0;">Tienes <strong><%= medicamentos.size() %></strong> medicamento(s) activo(s). Mantén tu tratamiento constante para una pronta recuperación.</p>
                </div>
            </div>

            <style>
                @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.15); } }
            </style>

            <div class="grid-container" style="grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));">
                <% for (Medicamento m : medicamentos) { %>
                <%
                    // Calcular si es urgente (frecuencia <= 8h)
                    boolean esUrgente = m.getFrecuenciaHoras() <= 8;
                    String colorBorde = esUrgente ? "#e74c3c" : "var(--secondary)";
                    String bgProgreso = esUrgente ? "linear-gradient(to right, #e74c3c, #e67e22)" : "linear-gradient(to right, var(--secondary), #2ecc71)";
                %>
                <div class="card-panel" style="border-left: 5px solid <%= colorBorde %>; padding: 25px; transition: transform 0.3s; margin-bottom:0;" onmouseover="this.style.transform='translateY(-5px)'" onmouseout="this.style.transform='none'">
                    <h4 style="font-size: 18px; color: var(--dark); margin-bottom: 5px; display: flex; align-items: center; gap: 10px;">
                        <i class="fas fa-pills" style="color: <%= colorBorde %>;"></i> <%= m.getNombreMedicamento() %>
                    </h4>
                    <span class="status-badge" style="background:#e8f4fd; color:#2980b9; border: 1px solid #2980b9; display:inline-block; margin-bottom:15px;"><i class="fas fa-user-md"></i> Dr. <%= m.getNombreMedico() %></span>

                    <div style="display: flex; flex-direction: column; gap: 10px; margin-bottom: 20px;">
                        <div style="display: flex; align-items: center; gap: 10px; font-size: 14px; color: var(--text-muted);"><i class="fas fa-syringe" style="width: 16px;"></i> <strong>Dosis:</strong> <%= m.getDosis() %></div>
                        <div style="display: flex; align-items: center; gap: 10px; font-size: 14px; color: var(--text-muted);"><i class="fas fa-clock" style="width: 16px;"></i> <strong>Frecuencia:</strong> Cada <%= m.getFrecuenciaHoras() %> hora(s)</div>
                        <div style="display: flex; align-items: center; gap: 10px; font-size: 14px; color: var(--text-muted);"><i class="fas fa-calendar-plus" style="width: 16px;"></i> <strong>Inicio:</strong> <%= m.getFechaInicio() %></div>
                        <div style="display: flex; align-items: center; gap: 10px; font-size: 14px; color: var(--text-muted);"><i class="fas fa-calendar-times" style="width: 16px;"></i> <strong>Hasta:</strong> <%= m.getFechaFin() %></div>
                    </div>

                    <div style="background: #f8f9fa; border-radius: 8px; padding: 15px; text-align: center; border: 1px solid var(--border-light);">
                        <div style="font-size:13px; color:var(--text-muted); margin-bottom:8px;">⏱ Próxima toma en:</div>
                        <span class="countdown-timer" data-freq="<%= m.getFrecuenciaHoras() %>" data-inicio="<%= m.getFechaInicio() %>" style="font-weight: 700; font-size: 18px; color: <%= colorBorde %>;">Calculando...</span>
                    </div>
                </div>
                <% } %>
            </div>
            <% } else { %>
            <div style="text-align: center; padding: 60px 20px; color: var(--text-muted); background: white; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05);">
                <i class="fas fa-prescription-bottle" style="font-size: 60px; color: #e0e0e0; display: block; margin-bottom: 15px;"></i>
                <h3 style="color:var(--dark); margin-bottom: 5px;">Sin medicamentos activos</h3>
                <p>Tu médico aún no te ha recetado ningún medicamento.</p>
            </div>
            <% } %>
        </div>
    </main>
    <script>
        document.getElementById('menuToggle').addEventListener('click', function() {
            document.getElementById('sidebar').classList.toggle('active');
        });

        // RELOJ EN TIEMPO REAL
        function actualizarReloj() {
            document.getElementById('reloj').textContent = new Date().toLocaleTimeString('es-CO');
        }
        actualizarReloj();
        setInterval(actualizarReloj, 1000);

        // SISTEMA DE NOTIFICACIONES CON SERVICE WORKER
        let swRegistration = null;
        let medicamentosActivos = [];

        // Registrar el Service Worker
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.register('${pageContext.request.contextPath}/sw.js')
                .then(reg => {
                    swRegistration = reg;
                    console.log('[ConsulTex] Service Worker registrado:', reg.scope);
                    // Escuchar mensajes del SW (ej. abrir recordatorios)
                    navigator.serviceWorker.addEventListener('message', e => {
                        if (e.data && e.data.type === 'ABRIR_RECORDATORIOS') {
                            window.location.reload();
                        }
                    });
                    // Pedir permiso y cargar medicamentos
                    iniciarNotificaciones();
                })
                .catch(err => {
                    console.warn('[ConsulTex] SW no disponible:', err);
                    iniciarNotificaciones();
                });
        } else {
            iniciarNotificaciones();
        }

        // Pedir permiso y cargar datos
        function iniciarNotificaciones() {
            if (!('Notification' in window)) {
                mostrarBannerInseguro();
                return;
            }
            if (Notification.permission === 'granted') {
                cargarMedicamentosYProgramar();
            } else if (Notification.permission !== 'denied') {
                mostrarBannerPermiso();
            }
        }

        // Banner para pedir permiso
        function mostrarBannerPermiso() {
            const banner = document.createElement('div');
            banner.id = 'banner-notif';
            banner.style.cssText = `
                position: fixed; top: 20px; right: 20px; left: 20px; z-index: 9999;
                background: linear-gradient(135deg, #2c3e50, #3498db);
                color: white; padding: 18px 24px; border-radius: 14px;
                box-shadow: 0 8px 30px rgba(0,0,0,0.3);
                display: flex; align-items: center; gap: 16px; flex-wrap: wrap;
                animation: slideIn 0.4s ease;
                max-width: 500px; margin: 0 auto;
            `;
            banner.innerHTML = `
                <style>@keyframes slideIn { from { opacity:0; transform:translateY(-20px); } to { opacity:1; transform:translateY(0); } }</style>
                <i class="fas fa-bell" style="font-size:28px; flex-shrink:0;"></i>
                <div style="flex:1; min-width:200px;">
                    <strong style="font-size:15px;">Activar recordatorios de medicamentos</strong>
                    <p style="margin:4px 0 0; font-size:13px; opacity:0.9;">
                        Te avisaremos 30, 15, 10, 5 y 2 minutos antes de cada toma.
                    </p>
                </div>
                <div style="display:flex; gap:10px;">
                    <button id="btn-activar-notif" onclick="pedirPermiso()" style="
                        background:#2ecc71; color:white; border:none; padding:10px 18px;
                        border-radius:8px; font-weight:700; cursor:pointer; font-size:14px;">
                        <i class="fas fa-bell"></i> Activar
                    </button>
                    <button onclick="document.getElementById('banner-notif').remove()" style="
                        background:rgba(255,255,255,0.2); color:white; border:none; padding:10px 14px;
                        border-radius:8px; cursor:pointer; font-size:14px;">
                        No ahora
                    </button>
                </div>
            `;
            document.body.appendChild(banner);
        }

        function pedirPermiso() {
            Notification.requestPermission().then(permission => {
                const banner = document.getElementById('banner-notif');
                if (banner) banner.remove();
                if (permission === 'granted') {
                    cargarMedicamentosYProgramar();
                    mostrarToast('¡Notificaciones activadas! Te avisaremos antes de cada toma.', '#2ecc71');
                } else {
                    mostrarToast('No podremos enviarte recordatorios. Puedes activarlos desde la configuración del navegador.', '#f39c12');
                }
            });
        }

        function mostrarBannerInseguro() {
            const b = document.createElement('div');
            b.style.cssText = 'position:fixed;top:16px;right:16px;left:16px;max-width:480px;margin:0 auto;background:linear-gradient(135deg,#e74c3c,#c0392b);color:white;padding:16px 20px;border-radius:14px;box-shadow:0 8px 25px rgba(0,0,0,0.25);display:flex;align-items:center;gap:14px;flex-wrap:wrap;z-index:9999;';
            b.innerHTML = '<i class="fas fa-exclamation-triangle" style="font-size:26px;"></i><div style="flex:1;"><strong>Notificaciones no disponibles</strong><p style="margin:3px 0 0;font-size:13px;opacity:.9;">Tu navegador bloquea las notificaciones (Requiere conexión segura HTTPS o añadir la app a la pantalla de inicio en iOS).</p></div>'
                + '<button onclick="this.closest(\'div\').remove()" style="background:rgba(255,255,255,.2);color:white;border:none;padding:10px 12px;border-radius:8px;cursor:pointer;">✕</button>';
            document.body.appendChild(b);
        }

        // Cargar medicamentos vía JSON y programar alertas
        function cargarMedicamentosYProgramar() {
            fetch('${pageContext.request.contextPath}/ControladorMedicamento?accion=obtenerRecordatoriosJSON')
                .then(r => r.json())
                .then(meds => {
                    medicamentosActivos = meds;
                    if (meds.length === 0) return;

                    console.log('[ConsulTex] Medicamentos cargados:', meds.length);

                    // Enviar al Service Worker para que los programe en segundo plano
                    if (swRegistration && swRegistration.active) {
                        swRegistration.active.postMessage({
                            type: 'PROGRAMAR_RECORDATORIOS',
                            medicamentos: meds
                        });
                    }

                    // También programar desde el cliente (pestaña abierta)
                    programarAlertas(meds);
                })
                .catch(err => console.error('[ConsulTex] Error al cargar medicamentos:', err));
        }

        // Programación de alertas desde el cliente
        const alertasMostradasHoy = new Set();
        let intervaloAlertas = null;

        function programarAlertas(meds) {
            if (intervaloAlertas) clearInterval(intervaloAlertas);

            intervaloAlertas = setInterval(() => {
                const ahora = new Date();
                meds.forEach(med => {
                    const proxima = calcularProximaToma(med, ahora);
                    if (!proxima) return;
                    
                    // Diferencia exacta en minutos (puede ser negativa si ya pasó un poquito)
                    const diffMin = Math.floor((proxima - ahora) / 60000);

                    const umbrales = [30, 15, 10, 5, 2];
                    umbrales.forEach(u => {
                        const clave = `${med.nombre}-${proxima.toISOString().slice(0,16)}-${u}`;
                        // Verificamos si estamos en el umbral o nos lo saltamos por suspensión (rango de 4 mins)
                        if (diffMin <= u && diffMin > (u - 4) && !alertasMostradasHoy.has(clave)) {
                            alertasMostradasHoy.add(clave);
                            lanzarNotificacion(med, u, proxima);
                            mostrarAlertaEnPantalla(med, u);
                        }
                    });

                    // Notificación exacta (0 minutos o acaba de pasar por suspensión)
                    if (diffMin <= 0 && diffMin > -5) {
                        const clave0 = `${med.nombre}-${proxima.toISOString().slice(0,16)}-0`;
                        if (!alertasMostradasHoy.has(clave0)) {
                            alertasMostradasHoy.add(clave0);
                            lanzarNotificacionExacta(med);
                            mostrarAlertaEnPantalla(med, 0);
                        }
                    }
                });
            }, 10000); // Revisar cada 10 segundos para mayor precisión
        }

        // Recargar datos de BD periódicamente sin refrescar la página
        setInterval(() => {
            fetch('${pageContext.request.contextPath}/ControladorMedicamento?accion=obtenerRecordatoriosJSON')
                .then(r => r.json())
                .then(meds => {
                    medicamentosActivos = meds;
                    programarAlertas(meds);
                })
                .catch(e => console.error('[ConsulTex] Error recarga auto:', e));
        }, 60000 * 5);

        function calcularProximaToma(med, ahora) {
            try {
                if (!med.fechaInicio) return null;
                var p = med.fechaInicio.split('-');
                var inicio = new Date(parseInt(p[0]), parseInt(p[1]) - 1, parseInt(p[2]), 8, 0, 0);
                var freqMs = med.frecuenciaHoras * 3600000;
                if (isNaN(inicio.getTime()) || freqMs <= 0) return null;
                var proxima = new Date(inicio);
                while (proxima <= ahora) proxima = new Date(proxima.getTime() + freqMs);
                if (proxima - ahora > 25 * 3600000) return null;
                return proxima;
            } catch(e) { return null; }
        }

        function lanzarNotificacion(med, minutos, proxima) {
            if (Notification.permission !== 'granted') return;
            var emojis = { 30:'⏰', 15:'⚠️', 10:'🔔', 5:'🚨', 2:'‼️' };
            var etiquetas = { 30:'Recordatorio', 15:'Próximamente', 10:'¡Atención!', 5:'¡Urgente!', 2:'¡Ahora mismo!' };
            var emoji = emojis[minutos] || '💊';
            var hora = proxima.toLocaleTimeString('es-CO', { hour:'2-digit', minute:'2-digit' });
            var plural = (minutos === 1) ? '' : 's';
            var titulo = emoji + ' ' + (etiquetas[minutos] || 'Recordatorio') + ': ' + med.nombre;
            var cuerpo = 'En ' + minutos + ' minuto' + plural + ' te toca tomarte "' + med.nombre + '". Dosis: ' + med.dosis + '. Se puntual. (' + hora + ')';
            var notif = new Notification(titulo, {
                body: cuerpo,
                icon: 'https://cdn-icons-png.flaticon.com/512/3004/3004458.png',
                tag: 'med-' + med.nombre + '-' + minutos,
                requireInteraction: (minutos <= 5),
                renotify: true
            });
            notif.onclick = function() { window.focus(); notif.close(); };
        }

        function lanzarNotificacionExacta(med) {
            if (Notification.permission !== 'granted') return;
            var titulo = '‼️ HORA DE TOMARTE: ' + med.nombre + '!';
            var cuerpo = 'Es la hora de tomar "' + med.nombre + '". Dosis: ' + med.dosis + '. No lo olvides!';
            var notif = new Notification(titulo, {
                body: cuerpo,
                icon: 'https://cdn-icons-png.flaticon.com/512/3004/3004458.png',
                tag: 'med-exacto-' + med.nombre,
                requireInteraction: true,
                renotify: true
            });
            notif.onclick = function() { window.focus(); notif.close(); };
        }

        function mostrarAlertaEnPantalla(med, minutos) {
            var container = document.getElementById('alertas-container');
            if (!container) return;
            var colores = { 30:'#3498db', 15:'#f39c12', 10:'#e67e22', 5:'#e74c3c', 2:'#c0392b', 0:'#8e44ad' };
            var color = colores[minutos] || '#e74c3c';
            var alerta = document.createElement('div');
            alerta.style.cssText = 'background:' + color + ';color:white;padding:16px 22px;border-radius:12px;box-shadow:0 6px 20px rgba(0,0,0,0.25);margin-bottom:12px;display:flex;align-items:center;gap:14px;font-size:15px;font-weight:600;';
            var texto = (minutos === 0)
                ? '‼️ Es la hora! Toma "' + med.nombre + '" AHORA. Dosis: ' + med.dosis + '.'
                : '💊 En ' + minutos + ' min te toca tomarte "' + med.nombre + '". Dosis: ' + med.dosis + '. Se puntual!';
            alerta.innerHTML = '<i class="fas fa-bell fa-lg"></i> ' + texto
                + '<button onclick="this.parentElement.remove()" style="margin-left:auto;background:rgba(255,255,255,0.3);border:none;color:white;padding:4px 10px;border-radius:6px;cursor:pointer;">✕</button>';
            container.prepend(alerta);
            if (minutos > 5) setTimeout(function() { alerta.remove(); }, 30000);
        }

        function mostrarToast(msg, color) {
            var t = document.createElement('div');
            t.style.cssText = 'position:fixed;bottom:24px;right:24px;background:' + color + ';color:white;padding:14px 20px;border-radius:10px;font-weight:600;z-index:9999;box-shadow:0 4px 15px rgba(0,0,0,0.2);';
            t.textContent = msg;
            document.body.appendChild(t);
            setTimeout(function() { t.remove(); }, 5000);
        }

        function actualizarContadores() {
            document.querySelectorAll('.countdown-timer').forEach(function(timer) {
                var frecHoras = parseInt(timer.dataset.freq);
                var fechaInicio = timer.dataset.inicio;
                if (!fechaInicio) return;
                var p = fechaInicio.split('-');
                var inicio = new Date(parseInt(p[0]), parseInt(p[1])-1, parseInt(p[2]), 8, 0, 0);
                var freqMs = frecHoras * 3600000;
                var ahora = new Date();
                var proxima = new Date(inicio);
                while (proxima <= ahora) proxima = new Date(proxima.getTime() + freqMs);
                var diff = proxima - ahora;
                var h = Math.floor(diff / 3600000);
                var m = Math.floor((diff % 3600000) / 60000);
                var s = Math.floor((diff % 60000) / 1000);
                timer.textContent = (h > 0 ? h + 'h ' : '') + m + 'm ' + s + 's';
                var esUrgente = diff < 30 * 60000;
                timer.style.color = esUrgente ? '#e74c3c' : 'var(--secondary)';
                timer.style.animation = esUrgente ? 'pulse 1s infinite' : 'none';
            });
        }
        actualizarContadores();
        setInterval(actualizarContadores, 1000);
    </script>
</body>
</html>
