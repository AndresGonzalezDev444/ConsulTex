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
    <title>ConsulTex - Estadísticas del Médico</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .chart-wrapper { position: relative; height: 500px; width: 100%; display: flex; justify-content: center; align-items: center;}
        #mensajeVacio { display: none; color: var(--text-muted); font-size: 20px; font-style: italic; }
    </style>
</head>
<body>

        <nav class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <i class="fas fa-heartbeat" style="font-size: 24px;"></i>
            <h3>ConsulTex</h3>
        </div>
        <div style="text-align: center; padding-bottom: 10px;">
            <span class="badge-role">Médico</span>
        </div>
        
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/vistas/medico/panelMedico.jsp"><i class="fas fa-home"></i> Inicio</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=listarDisponibles"><i class="fas fa-user-plus"></i> Vincular Paciente</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=misPacientes"><i class="fas fa-users"></i> Mis Pacientes</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorMedicamento?accion=misMedicamentos"><i class="fas fa-pills"></i> Medicamentos</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/ControladorEstadistica?accion=medico"><i class="fas fa-chart-line"></i> Estadísticas</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorCita?accion=agendaMedico"><i class="fas fa-calendar-alt"></i> Agenda</a></li>
        </ul>

        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/ControladorCerrarSesion" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
            </a>
        </div>
    </nav>

    <main class="main-wrapper">
        <div class="page-header" style="margin-bottom: 30px;">
            <div>
                <h1> Panel de Estadísticas</h1>
                <p>Analiza los datos demográficos y de salud de tus pacientes vinculados.</p>
            </div>
            <div style="display:flex; gap: 10px;">
                <button class="btn btn-primary" style="background-color:#27ae60; border-color:#27ae60;" onclick="exportarGrafica()"><i class="fas fa-download"></i> Exportar Gráfica</button>
            </div>
        </div>

        <div class="card-panel">
            <div style="margin-bottom: 25px; padding-bottom: 15px; border-bottom: 1px solid var(--border-light); display: flex; align-items: center; gap: 15px;">
                <label style="font-weight: 600; color: var(--dark); font-size: 15px;"><i class="fas fa-filter"></i> Seleccione el tipo de gráfica:</label>
                <select id="tipoGrafica" onchange="cargarDatos()" class="form-control" style="width: auto; padding: 8px 15px;">
                    <option value="edad">Pacientes por Edad</option>
                    <option value="sexo">Pacientes por Sexo</option>
                    <option value="imc">Relación Peso/Estatura (IMC)</option>
                </select>
            </div>
            
            <div class="chart-wrapper">
                <h2 id="mensajeVacio"><i class="fas fa-chart-bar" style="display:block; font-size:40px; color:#e0e0e0; margin-bottom:15px;"></i> 0 pacientes vinculados con estos datos.</h2>
                <canvas id="miGrafica"></canvas>
            </div>
        </div>
    </main>

    <script>
        let myChart = null;

        document.addEventListener("DOMContentLoaded", function() {
            cargarDatos();
        });

        function cargarDatos() {
            const tipo = document.getElementById("tipoGrafica").value;
            
            fetch("${pageContext.request.contextPath}/ControladorEstadistica?accion=datosGraficaMedico&tipo=" + tipo)
                .then(response => response.json())
                .then(data => {
                    renderizarGrafica(data, tipo);
                })
                .catch(error => {
                    console.error("Error cargando los datos:", error);
                });
        }

        function renderizarGrafica(datos, tipo) {
            const canvas = document.getElementById('miGrafica');
            const mensajeVacio = document.getElementById('mensajeVacio');
            
            let tieneDatos = false;
            let labels = [];
            let values = [];
            
            for (let key in datos) {
                labels.push(key);
                values.push(datos[key]);
                if (datos[key] > 0) tieneDatos = true;
            }

            if (!tieneDatos) {
                canvas.style.display = 'none';
                mensajeVacio.style.display = 'block';
                if(myChart) myChart.destroy();
                return;
            } else {
                canvas.style.display = 'block';
                mensajeVacio.style.display = 'none';
            }

            if (myChart) {
                myChart.destroy();
            }

            const ctx = canvas.getContext('2d');
            
            let chartType = 'pie';
            let bgColors = ['#ff6384', '#36a2eb', '#cc65fe', '#ffce56', '#4bc0c0'];
            let title = '';

            if (tipo === 'edad') {
                chartType = 'bar';
                title = 'Distribución de Pacientes por Edad';
                bgColors = ['rgba(54, 162, 235, 0.7)'];
            } else if (tipo === 'sexo') {
                chartType = 'pie';
                title = 'Distribución de Pacientes por Sexo';
                bgColors = ['rgba(54, 162, 235, 0.7)', 'rgba(255, 99, 132, 0.7)', 'rgba(204, 101, 254, 0.7)'];
            } else if (tipo === 'imc') {
                chartType = 'doughnut';
                title = 'Estado Nutricional (IMC) de los Pacientes';
            }

            myChart = new Chart(ctx, {
                type: chartType,
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Cantidad de Pacientes',
                        data: values,
                        backgroundColor: bgColors,
                        borderColor: bgColors.map(c => c.replace('0.7', '1')),
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'top' },
                        title: { display: true, text: title, font: { size: 18, family: "'Segoe UI', sans-serif" }, color: '#2c3e50' }
                    },
                    scales: chartType === 'bar' ? {
                        y: { beginAtZero: true, ticks: { stepSize: 1 } }
                    } : {}
                }
            });
        }

        function exportarGrafica() {
            const canvas = document.getElementById('miGrafica');
            if(canvas.style.display === 'none') {
                alert("No hay gráfica para exportar.");
                return;
            }
            const imgData = canvas.toDataURL('image/png');
            const link = document.createElement('a');
            const tipo = document.getElementById("tipoGrafica").options[document.getElementById("tipoGrafica").selectedIndex].text;
            link.download = 'Grafica_' + tipo.replace(/\s+/g, '_') + '.png';
            link.href = imgData;
            link.click();
        }
    </script>
</body>
</html>
