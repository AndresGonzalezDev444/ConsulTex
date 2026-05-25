<%@page import="com.consultex.modelo.Medico"%>
<%@page import="com.consultex.modelo.Paciente"%>
<%@page import="com.consultex.modelo.Usuario"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioActivo");
    if (usuarioLogueado == null || !usuarioLogueado.getRol().equalsIgnoreCase("Medico")) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    List<Medico> medicos = (List<Medico>) request.getAttribute("medicos");
    Paciente paciente = (Paciente) request.getAttribute("paciente");
    String filtroEsp = request.getParameter("filtroEsp");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Remitir Paciente</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>
        <nav class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <i class="fas fa-hospital-symbol" style="font-size: 24px;"></i>
            <h3>ConsulTex</h3>
        </div>
        <div style="text-align: center; padding-bottom: 10px;">
            <span class="badge-role">Médico</span>
        </div>
        
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/vistas/medico/panelMedico.jsp"><i class="fas fa-home"></i> Inicio</a></li>
            <li><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=listarDisponibles"><i class="fas fa-user-plus"></i> Vincular Paciente</a></li>
            <li class="active"><a href="${pageContext.request.contextPath}/ControladorPaciente?accion=misPacientes"><i class="fas fa-users"></i> Mis Pacientes</a></li>
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

    <main class="main-wrapper">
        <div class="page-header" style="margin-bottom: 25px;">
            <div>
                <h1> Remitir / Transferir Paciente</h1>
                <p>Selecciona el médico al que deseas transferir este paciente.</p>
            </div>
        </div>

        <% if (request.getAttribute("mensaje") != null) { %>
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= request.getAttribute("mensaje") %></div>
        <% } %>

        <!-- Info del paciente a remitir -->
        <% if (paciente != null) { %>
        <div class="card-panel" style="background: linear-gradient(135deg, var(--primary), var(--secondary)); color: white; border: none; margin-bottom: 25px; display: flex; align-items: center; gap: 20px;">
            <div style="width: 55px; height: 55px; background: rgba(255,255,255,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px;"><i class="fas fa-user-injured"></i></div>
            <div>
                <h3 style="font-size: 18px; margin-bottom: 3px;"><%= paciente.getNombreCompleto() %></h3>
                <p style="font-size: 13px; opacity: 0.85; margin: 0;">Paciente a remitir &nbsp;|&nbsp; ID: <%= paciente.getIdPaciente() %></p>
            </div>
        </div>
        <% } %>

        <!-- Filtro por especialidad -->
        <div class="card-panel" style="margin-bottom: 25px;">
            <div class="form-group" style="margin-bottom: 0;">
                <label><i class="fas fa-search"></i> Filtrar por Especialidad</label>
                <input type="text" id="filtroEsp" class="form-control" placeholder="Ej: Cardiología, Pediatría..."
                    value="<%= filtroEsp != null ? filtroEsp : "" %>"
                    oninput="filtrarMedicos(this.value)">
            </div>
        </div>

        <!-- Grid de médicos disponibles -->
        <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 18px;" id="medicosGrid">
            <% if (medicos != null && !medicos.isEmpty()) {
                for (Medico m : medicos) { %>
            <div class="card-panel medico-card" data-esp="<%= m.getEspecialidad() != null ? m.getEspecialidad().toLowerCase() : "" %>" style="border-left: 4px solid var(--primary); transition: 0.3s;">
                <div style="font-size: 16px; font-weight: 700; color: var(--dark); margin-bottom: 6px;"><i class="fas fa-user-md" style="color:var(--primary);"></i> Dr. <%= m.getNombreCompleto() %></div>
                <div style="font-size: 13px; color: var(--text-muted); margin-bottom: 10px;"><i class="fas fa-stethoscope" style="color:var(--primary);"></i> <%= m.getEspecialidad() != null ? m.getEspecialidad() : "Sin especialidad asignada" %></div>
                <div style="background: #ebf5fb; color: var(--primary); padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; display: inline-block; margin-bottom: 15px;"><i class="fas fa-users"></i> <%= m.getTotalPacientes() %> paciente(s) actuales</div>
                <form method="get" action="${pageContext.request.contextPath}/ControladorPaciente"
                    onsubmit="return confirm('¿Remitir a <%= paciente != null ? paciente.getNombreCompleto() : "este paciente" %> al Dr. <%= m.getNombreCompleto() %>?');">
                    <input type="hidden" name="accion" value="remitirPaciente">
                    <input type="hidden" name="idPaciente" value="${param.idPaciente}">
                    <input type="hidden" name="idNuevoMedico" value="<%= m.getIdMedico() %>">
                    <button type="submit" class="btn btn-primary" style="width: 100%;"><i class="fas fa-exchange-alt"></i> Remitir a este Médico</button>
                </form>
            </div>
            <% } } else { %>
            <div style="grid-column: 1/-1; text-align: center; padding: 50px; color: var(--text-muted);">
                <i class="fas fa-user-md" style="font-size: 50px; color: #e0e0e0; display: block; margin-bottom: 15px;"></i>
                <h3>No hay otros médicos disponibles</h3>
                <p>No se encontraron médicos activos para realizar la remisión.</p>
            </div>
            <% } %>
        </div>
    </main>

    <script>
        function filtrarMedicos(texto) {
            const cards = document.querySelectorAll('.medico-card');
            const filtro = texto.toLowerCase();
            cards.forEach(card => {
                const esp = card.dataset.esp;
                card.style.display = (filtro === '' || esp.includes(filtro)) ? 'block' : 'none';
            });
        }
    </script>
</body>
</html>
