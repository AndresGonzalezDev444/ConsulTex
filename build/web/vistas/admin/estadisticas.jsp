<%@page import="java.util.Map"%>
<%@page import="com.consultex.modelo.Usuario"%>
<%@page import="com.google.gson.Gson"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioActivo");
    if (usuarioLogueado == null || (!usuarioLogueado.getRol().equalsIgnoreCase("Admin") && !usuarioLogueado.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return; 
    }

    Map<String, Integer> mapUsuariosRol = (Map<String, Integer>) request.getAttribute("usuariosRol");
    Map<String, Integer> mapAsignacionPacientes = (Map<String, Integer>) request.getAttribute("asignacionPacientes");
    Map<String, Integer> mapEspecialidadesMedicas = (Map<String, Integer>) request.getAttribute("especialidadesMedicas");
    Map<String, Integer> mapConsultasPorDia = (Map<String, Integer>) request.getAttribute("consultasPorDia");
    Map<String, Double> mapPromedioPesoEspecialidad = (Map<String, Double>) request.getAttribute("promedioPesoEspecialidad");

    // KPIs iniciales
    int kpiPacientes = request.getAttribute("kpiPacientes") != null ? (int)request.getAttribute("kpiPacientes") : 0;
    int kpiConsultasHoy = request.getAttribute("kpiConsultasHoy") != null ? (int)request.getAttribute("kpiConsultasHoy") : 0;
    int kpiMedicos = request.getAttribute("kpiMedicos") != null ? (int)request.getAttribute("kpiMedicos") : 0;
    double kpiCalificacionApp = request.getAttribute("kpiCalificacionApp") != null ? (double)request.getAttribute("kpiCalificacionApp") : 0.0;
    double kpiCalificacionMedico = request.getAttribute("kpiCalificacionMedico") != null ? (double)request.getAttribute("kpiCalificacionMedico") : 0.0;
    int kpiCitasCanceladas = request.getAttribute("kpiCitasCanceladas") != null ? (int)request.getAttribute("kpiCitasCanceladas") : 0;

    Gson gson = new Gson();
    String jsonUsuariosRolLabels = mapUsuariosRol != null ? gson.toJson(mapUsuariosRol.keySet()) : "[]";
    String jsonUsuariosRolData = mapUsuariosRol != null ? gson.toJson(mapUsuariosRol.values()) : "[]";
    String jsonAsignaPacLabels = mapAsignacionPacientes != null ? gson.toJson(mapAsignacionPacientes.keySet()) : "[]";
    String jsonAsignaPacData = mapAsignacionPacientes != null ? gson.toJson(mapAsignacionPacientes.values()) : "[]";
    String jsonEspecialidadesLabels = mapEspecialidadesMedicas != null ? gson.toJson(mapEspecialidadesMedicas.keySet()) : "[]";
    String jsonEspecialidadesData = mapEspecialidadesMedicas != null ? gson.toJson(mapEspecialidadesMedicas.values()) : "[]";
    String jsonConsultasDiaLabels = mapConsultasPorDia != null ? gson.toJson(mapConsultasPorDia.keySet()) : "[]";
    String jsonConsultasDiaData = mapConsultasPorDia != null ? gson.toJson(mapConsultasPorDia.values()) : "[]";
    String jsonPromedioPesoLabels = mapPromedioPesoEspecialidad != null ? gson.toJson(mapPromedioPesoEspecialidad.keySet()) : "[]";
    String jsonPromedioPesoData = mapPromedioPesoEspecialidad != null ? gson.toJson(mapPromedioPesoEspecialidad.values()) : "[]";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Dashboard Estadísticas</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 35px;
        }
        .kpi-card {
            background: white;
            border-radius: 14px;
            padding: 20px 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
            text-align: center;
            border-top: 4px solid var(--primary);
            transition: transform 0.3s;
            position: relative;
            overflow: hidden;
        }
        .kpi-card:hover { transform: translateY(-4px); }
        .kpi-card.c1 { border-top-color: #3498db; }
        .kpi-card.c2 { border-top-color: #27ae60; }
        .kpi-card.c3 { border-top-color: #9b59b6; }
        .kpi-card.c4 { border-top-color: #f39c12; }
        .kpi-card.c5 { border-top-color: #e74c3c; }
        .kpi-icon { font-size: 26px; margin-bottom: 10px; }
        .kpi-card.c1 .kpi-icon { color: #3498db; }
        .kpi-card.c2 .kpi-icon { color: #27ae60; }
        .kpi-card.c3 .kpi-icon { color: #9b59b6; }
        .kpi-card.c4 .kpi-icon { color: #f39c12; }
        .kpi-card.c5 .kpi-icon { color: #e74c3c; }
        .kpi-card.c6 { border-top-color: #1abc9c; }
        .kpi-card.c6 .kpi-icon { color: #1abc9c; }
        .kpi-value { font-size: 32px; font-weight: 800; color: var(--dark); margin: 5px 0; transition: all 0.5s; }
        .kpi-label { font-size: 11px; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; }

        /* Live indicator */
        .live-badge {
            display: flex; align-items: center; gap: 8px;
            background: #e8f8f5; color: #27ae60; padding: 8px 15px;
            border-radius: 20px; font-size: 13px; font-weight: 600;
            margin-bottom: 20px; width: fit-content;
        }
        .live-dot { width: 9px; height: 9px; background: #27ae60; border-radius: 50%; animation: blink 1s infinite; }
        @keyframes blink { 0%, 100% { opacity: 1; } 50% { opacity: 0.2; } }

        /* Charts */
        .charts-container { display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 25px; }
        .chart-card.full-width { grid-column: 1 / -1; }
        .chart-card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); display: flex; flex-direction: column; align-items: center; }
        .chart-card h3 { color: var(--dark); margin-bottom: 15px; font-size: 1.05rem; text-align: center; width: 100%; border-bottom: 1px solid var(--border-light); padding-bottom: 10px; }
        .chart-wrapper { position: relative; height: 300px; width: 100%; }
        .chart-card.full-width .chart-wrapper { height: 380px; }
    </style>
</head>
<body style="display:block; padding:30px;">
    <div class="form-container" style="max-width: 1200px; padding: 30px;">
        <div class="page-header" style="margin-bottom: 25px; display: flex; justify-content: space-between; align-items: flex-start;">
            <div>
                <h1 style="color:var(--dark); margin-bottom: 5px;"> Dashboard Estadístico Global</h1>
                <p style="color:var(--text-muted);">Datos en tiempo real del sistema ConsulTex.</p>
            </div>
            <a href="${pageContext.request.contextPath}/vistas/admin/panelAdmin.jsp" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Volver al Panel</a>
        </div>

        <!-- Indicador de tiempo real -->
        <div class="live-badge">
            <div class="live-dot"></div>
            ACTUALIZACIÓN EN TIEMPO REAL — cada 5 segundos &nbsp;|&nbsp; Última: <span id="ultimaActualizacion">Cargando...</span>
        </div>

        <!-- 5 KPIs -->
        <div class="kpi-grid">
            <div class="kpi-card c1">
                <div class="kpi-icon"></div>
                <div class="kpi-value" id="kpi-pacientes"><%= kpiPacientes %></div>
                <div class="kpi-label">Total Pacientes</div>
            </div>
            <div class="kpi-card c2">
                <div class="kpi-icon"></div>
                <div class="kpi-value" id="kpi-consultas"><%= kpiConsultasHoy %></div>
                <div class="kpi-label">Consultas Hoy</div>
            </div>
            <div class="kpi-card c3">
                <div class="kpi-icon"></div>
                <div class="kpi-value" id="kpi-medicos"><%= kpiMedicos %></div>
                <div class="kpi-label">Médicos Activos</div>
            </div>
            <div class="kpi-card c4">
                <div class="kpi-icon"></div>
                <div class="kpi-value" id="kpi-calificacion-app"><%= kpiCalificacionApp %></div>
                <div class="kpi-label">Calif Promedio APP</div>
            </div>
            <div class="kpi-card c6">
                <div class="kpi-icon"></div>
                <div class="kpi-value" id="kpi-calificacion-medico"><%= kpiCalificacionMedico %></div>
                <div class="kpi-label">Calif Promedio Médicos</div>
            </div>
            <div class="kpi-card c5">
                <div class="kpi-icon"></div>
                <div class="kpi-value" id="kpi-canceladas"><%= kpiCitasCanceladas %></div>
                <div class="kpi-label">Citas Canceladas</div>
            </div>
        </div>

        <!-- 5 Gráficos -->
        <div class="charts-container">
            <div class="chart-card">
                <h3><i class="fas fa-users-cog"></i> 1. Distribución de Cuentas por Rol</h3>
                <div class="chart-wrapper"><canvas id="chartUsuariosRol"></canvas></div>
            </div>
            <div class="chart-card">
                <h3><i class="fas fa-hand-holding-medical"></i> 2. Estado de Asignación de Pacientes</h3>
                <div class="chart-wrapper"><canvas id="chartAsignacionPacientes"></canvas></div>
            </div>
            <div class="chart-card full-width">
                <h3><i class="fas fa-stethoscope"></i> 3. Cantidad de Médicos por Especialidad</h3>
                <div class="chart-wrapper"><canvas id="chartEspecialidades"></canvas></div>
            </div>
            <div class="chart-card full-width">
                <h3><i class="fas fa-calendar-check"></i> 4. Evolución de Consultas Registradas por Día</h3>
                <div class="chart-wrapper"><canvas id="chartConsultasDia"></canvas></div>
            </div>
            <div class="chart-card full-width">
                <h3><i class="fas fa-weight"></i> 5. Promedio de Peso de Pacientes por Especialidad (kg)</h3>
                <div class="chart-wrapper"><canvas id="chartPromedioPeso"></canvas></div>
            </div>
        </div>
    </div>

    <script>
        const bgColors = [
            'rgba(52, 152, 219, 0.75)', 'rgba(46, 204, 113, 0.75)', 'rgba(155, 89, 182, 0.75)',
            'rgba(241, 196, 15, 0.75)', 'rgba(230, 126, 34, 0.75)', 'rgba(231, 76, 60, 0.75)'
        ];
        const borderColors = [
            'rgba(52, 152, 219, 1)', 'rgba(46, 204, 113, 1)', 'rgba(155, 89, 182, 1)',
            'rgba(241, 196, 15, 1)', 'rgba(230, 126, 34, 1)', 'rgba(231, 76, 60, 1)'
        ];

        // Inicializar gráficos con datos del servidor
        const chart1 = new Chart(document.getElementById('chartUsuariosRol').getContext('2d'), {
            type: 'pie',
            data: { labels: <%= jsonUsuariosRolLabels %>, datasets: [{ data: <%= jsonUsuariosRolData %>, backgroundColor: bgColors, borderColor: borderColors, borderWidth: 1 }] },
            options: { responsive: true, maintainAspectRatio: false }
        });
        const chart2 = new Chart(document.getElementById('chartAsignacionPacientes').getContext('2d'), {
            type: 'doughnut',
            data: { labels: <%= jsonAsignaPacLabels %>, datasets: [{ data: <%= jsonAsignaPacData %>, backgroundColor: ['rgba(231,76,60,0.75)','rgba(46,204,113,0.75)'], borderColor: ['rgba(192,57,43,1)','rgba(39,174,96,1)'], borderWidth: 1 }] },
            options: { responsive: true, maintainAspectRatio: false }
        });
        const chart3 = new Chart(document.getElementById('chartEspecialidades').getContext('2d'), {
            type: 'bar',
            data: { labels: <%= jsonEspecialidadesLabels %>, datasets: [{ label: 'Número de Médicos', data: <%= jsonEspecialidadesData %>, backgroundColor: 'rgba(52,152,219,0.65)', borderColor: 'rgba(41,128,185,1)', borderWidth: 2, borderRadius: 6 }] },
            options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true, ticks: { precision: 0 } } } }
        });
        const chart4 = new Chart(document.getElementById('chartConsultasDia').getContext('2d'), {
            type: 'line',
            data: { labels: <%= jsonConsultasDiaLabels %>, datasets: [{ label: 'Consultas Diarias', data: <%= jsonConsultasDiaData %>, backgroundColor: 'rgba(155,89,182,0.2)', borderColor: 'rgba(142,68,173,1)', borderWidth: 3, tension: 0.4, fill: true, pointBackgroundColor: 'rgba(142,68,173,1)' }] },
            options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true, ticks: { precision: 0 } } } }
        });
        const chart5 = new Chart(document.getElementById('chartPromedioPeso').getContext('2d'), {
            type: 'polarArea',
            data: { labels: <%= jsonPromedioPesoLabels %>, datasets: [{ label: 'Promedio Peso (kg)', data: <%= jsonPromedioPesoData %>, backgroundColor: bgColors, borderColor: borderColors, borderWidth: 1 }] },
            options: { responsive: true, maintainAspectRatio: false }
        });

        // Función para actualizar un chart con nuevos datos
        function updateChart(chart, newLabels, newData) {
            chart.data.labels = Object.keys(newLabels);
            chart.data.datasets[0].data = Object.values(newLabels);
            chart.update('active');
        }

        // Animar cambio de KPI
        function animateValue(elementId, newVal) {
            const el = document.getElementById(elementId);
            const current = parseFloat(el.textContent) || 0;
            if (current !== newVal) {
                el.style.transform = 'scale(1.2)';
                el.style.color = '#27ae60';
                setTimeout(() => {
                    el.textContent = newVal;
                    el.style.transform = 'scale(1)';
                    el.style.color = '#2c3e50';
                }, 300);
            }
        }

        // POLLING AJAX cada 5 segundos - Criterio 17
        const POLLING_URL = '${pageContext.request.contextPath}/ControladorEstadistica?accion=datosKpi';

        function refreshDashboard() {
            fetch(POLLING_URL)
                .then(r => r.json())
                .then(data => {
                    // Actualizar KPIs
                    animateValue('kpi-pacientes', data.pacientes);
                    animateValue('kpi-consultas', data.consultasHoy);
                    animateValue('kpi-medicos', data.medicos);
                    animateValue('kpi-calificacion-app', data.calificacionApp);
                    animateValue('kpi-calificacion-medico', data.calificacionMedico);
                    animateValue('kpi-canceladas', data.citasCanceladas);

                    // Actualizar gráficos
                    if (data.usuariosRol) {
                        chart1.data.labels = Object.keys(data.usuariosRol);
                        chart1.data.datasets[0].data = Object.values(data.usuariosRol);
                        chart1.update();
                    }
                    if (data.asignacionPacientes) {
                        chart2.data.labels = Object.keys(data.asignacionPacientes);
                        chart2.data.datasets[0].data = Object.values(data.asignacionPacientes);
                        chart2.update();
                    }
                    if (data.especialidadesMedicas) {
                        chart3.data.labels = Object.keys(data.especialidadesMedicas);
                        chart3.data.datasets[0].data = Object.values(data.especialidadesMedicas);
                        chart3.update();
                    }
                    if (data.consultasPorDia) {
                        chart4.data.labels = Object.keys(data.consultasPorDia);
                        chart4.data.datasets[0].data = Object.values(data.consultasPorDia);
                        chart4.update();
                    }
                    if (data.promedioPesoEspecialidad) {
                        chart5.data.labels = Object.keys(data.promedioPesoEspecialidad);
                        chart5.data.datasets[0].data = Object.values(data.promedioPesoEspecialidad);
                        chart5.update();
                    }

                    // Timestamp
                    const ahora = new Date();
                    document.getElementById('ultimaActualizacion').textContent = ahora.toLocaleTimeString('es-CO');
                })
                .catch(err => console.warn('Error en polling:', err));
        }

        // Primera llamada inmediata y luego cada 5 segundos
        refreshDashboard();
        setInterval(refreshDashboard, 5000);
    </script>
</body>
</html>
