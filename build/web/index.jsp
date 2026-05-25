<%@page import="com.consultex.modelo.Especialidad"%>
<%@page import="com.consultex.dao.EspecialidadDAO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    EspecialidadDAO espDao = new EspecialidadDAO();
    List<Especialidad> especialidades = espDao.listarActivas();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Acceso al Sistema</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #0056b3 0%, #004494 40%, #002d6e 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            width: 100%;
            max-width: 900px;
            display: flex;
            min-height: 600px;
        }
        /* Panel izquierdo decorativo */
        .left-panel {
            background: linear-gradient(160deg, #0056b3, #27ae60);
            color: white;
            padding: 50px 40px;
            width: 38%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        .left-panel::before {
            content: '';
            position: absolute;
            top: -50px; right: -50px;
            width: 200px; height: 200px;
            border-radius: 50%;
            background: rgba(255,255,255,0.08);
        }
        .left-panel::after {
            content: '';
            position: absolute;
            bottom: -60px; left: -60px;
            width: 250px; height: 250px;
            border-radius: 50%;
            background: rgba(255,255,255,0.06);
        }
        .left-panel img { width: 90px; margin-bottom: 25px; }
        .left-panel h1 { font-size: 28px; font-weight: 700; margin-bottom: 12px; }
        .left-panel p { font-size: 14px; opacity: 0.85; line-height: 1.6; }
        .features { margin-top: 30px; }
        .feature { display: flex; align-items: center; gap: 10px; margin-bottom: 14px; font-size: 13px; opacity: 0.9; }
        .feature i { font-size: 16px; }

        /* Panel derecho con formulario */
        .right-panel { flex: 1; padding: 40px 45px; overflow-y: auto; max-height: 90vh; }
        .form-title { font-size: 22px; font-weight: 700; color: #1a1a2e; margin-bottom: 5px; }
        .form-subtitle { color: #888; font-size: 13px; margin-bottom: 25px; }

        .hidden { display: none !important; }

        /* Tabs */
        .tabs { display: flex; gap: 5px; margin-bottom: 25px; }
        .tab-btn {
            flex: 1; padding: 10px; border: 2px solid #e0e0e0;
            background: white; border-radius: 8px; cursor: pointer;
            font-size: 13px; font-weight: 600; color: #888; transition: 0.3s;
        }
        .tab-btn.active { border-color: #0056b3; color: #0056b3; background: #f0f5ff; }

        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-size: 12px; font-weight: 600; color: #555; margin-bottom: 5px; text-transform: uppercase; letter-spacing: 0.5px; }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%; padding: 11px 14px;
            border: 1.5px solid #e0e0e0; border-radius: 8px;
            font-size: 14px; font-family: 'Inter', sans-serif;
            transition: 0.3s; background: #fafafa;
        }
        .form-group input:focus, .form-group select:focus {
            outline: none; border-color: #0056b3;
            box-shadow: 0 0 0 3px rgba(0,86,179,0.1);
            background: white;
        }
        .form-row { display: grid; grid-template-columns: 1fr 2fr; gap: 10px; }
        .form-row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }

        .btn-submit {
            width: 100%; padding: 13px; background: linear-gradient(135deg, #0056b3, #27ae60);
            color: white; border: none; border-radius: 10px; font-size: 15px;
            font-weight: 600; cursor: pointer; transition: 0.3s; margin-top: 5px;
        }
        .btn-submit:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(0,86,179,0.35); }

        .alert { padding: 12px 16px; border-radius: 8px; font-size: 13px; margin-bottom: 15px; font-weight: 500; }
        .alert-success { background: #e8f8f0; color: #1e7e45; border-left: 4px solid #27ae60; }
        .alert-error { background: #fdf0f0; color: #c0392b; border-left: 4px solid #e74c3c; }
        .alert-pending { background: #fef9e7; color: #b7770d; border-left: 4px solid #f39c12; }

        /* Sección de documentos médico */
        .doc-section {
            background: #f0f5ff; border: 1.5px dashed #0056b3;
            border-radius: 10px; padding: 15px; margin-bottom: 15px;
        }
        .doc-section h4 { font-size: 13px; color: #0056b3; margin-bottom: 12px; }
        .doc-section input[type="file"] { background: white; }

        .toggle-link { color: #0056b3; cursor: pointer; font-size: 13px; text-align: center; display: block; margin-top: 15px; text-decoration: underline; }

        /* Checkbox especial */
        .checkbox-group { display: flex; align-items: center; gap: 10px; margin-bottom: 12px; }
        .checkbox-group input[type="checkbox"] { width: 18px; height: 18px; cursor: pointer; accent-color: #0056b3; }
        .checkbox-group label { font-size: 13px; color: #444; cursor: pointer; text-transform: none; letter-spacing: 0; }

        /* Rol selector */
        .rol-selector { display: flex; gap: 10px; margin-bottom: 15px; }
        .rol-btn {
            flex: 1; padding: 12px; border: 2px solid #e0e0e0;
            border-radius: 10px; cursor: pointer; text-align: center;
            transition: 0.3s; background: white;
        }
        .rol-btn.selected { border-color: #0056b3; background: #f0f5ff; }
        .rol-btn.selected.medico { border-color: #27ae60; background: #e8f8f0; }
        .rol-btn i { font-size: 22px; display: block; margin-bottom: 5px; color: #888; }
        .rol-btn.selected i { color: #0056b3; }
        .rol-btn.selected.medico i { color: #27ae60; }
        .rol-btn span { font-size: 12px; font-weight: 600; color: #888; }
        .rol-btn.selected span { color: #0056b3; }
        .rol-btn.selected.medico span { color: #27ae60; }
    </style>
</head>
<body>
<div class="container">

    <!-- Panel Izquierdo -->
    <div class="left-panel">
        <img src="images/logo.png" alt="ConsulTex" onerror="this.style.display='none'">
        <h1>ConsulTex</h1>
        <p>Plataforma integral de gestión médica y seguimiento de pacientes.</p>
        <div class="features">
            <div class="feature"><i class="fas fa-shield-alt"></i> Datos seguros y confidenciales</div>
            <div class="feature"><i class="fas fa-stethoscope"></i> Historial clínico completo</div>
            <div class="feature"><i class="fas fa-bell"></i> Recordatorios de medicación</div>
            <div class="feature"><i class="fas fa-chart-line"></i> Estadísticas en tiempo real</div>
        </div>
    </div>

    <!-- Panel Derecho -->
    <div class="right-panel">

        <!-- ALERTAS GLOBALES -->
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("mensaje") != null) { %>
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> <%= request.getAttribute("mensaje") %></div>
        <% } %>
        <% if (request.getAttribute("mensajePendiente") != null) { %>
        <div class="alert alert-pending"><i class="fas fa-clock"></i> <%= request.getAttribute("mensajePendiente") %></div>
        <% } %>

        <!-- TABS -->
        <div class="tabs">
            <button class="tab-btn active" id="tabLogin" onclick="showTab('login')">
                <i class="fas fa-sign-in-alt"></i> Ingresar
            </button>
            <button class="tab-btn" id="tabRegister" onclick="showTab('register')">
                <i class="fas fa-user-plus"></i> Registrarme
            </button>
        </div>

        <!-- ======================= LOGIN ======================= -->
        <div id="login-section">
            <p class="form-title">¡Bienvenido de nuevo!</p>
            <p class="form-subtitle">Ingresa tus credenciales para acceder.</p>
            <form action="ControladorValidar" method="POST">
                <div class="form-group">
                    <label><i class="fas fa-envelope"></i> Correo Electrónico</label>
                    <input type="email" name="correo" placeholder="tu@correo.com" required>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-lock"></i> Contraseña</label>
                    <input type="password" name="password" placeholder="••••••••" required>
                </div>
                <button type="submit" name="accion" value="Ingresar" class="btn-submit">
                    <i class="fas fa-arrow-right"></i> Iniciar Sesión
                </button>
            </form>
        </div>

        <!-- ======================= REGISTRO ======================= -->
        <div id="register-section" class="hidden">
            <p class="form-title">Crear cuenta nueva</p>
            <p class="form-subtitle">Selecciona tu rol y completa tus datos.</p>

            <!-- Selector de rol visual -->
            <div class="rol-selector">
                <div class="rol-btn selected" id="btnPaciente" onclick="seleccionarRol('Paciente')">
                    <i class="fas fa-user-injured"></i>
                    <span>Soy Paciente</span>
                </div>
                <div class="rol-btn medico" id="btnMedico" onclick="seleccionarRol('Medico')" style="border-color:#e0e0e0;">
                    <i class="fas fa-user-md"></i>
                    <span>Soy Médico</span>
                </div>
            </div>

            <!-- ---- FORMULARIO PACIENTE ---- -->
            <form id="formPaciente" action="ControladorUsuario" method="POST" onsubmit="return validarPassPaciente()">
                <input type="hidden" name="accion" value="Registrar">
                <input type="hidden" name="rol" value="Paciente">
                <div class="form-group">
                    <label>Nombre Completo *</label>
                    <input type="text" name="nombre" placeholder="Ej: María González López" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Tipo de ID *</label>
                        <select name="tipoIdentificacion" required>
                            <option value="CC">CC</option>
                            <option value="TI">TI</option>
                            <option value="CE">CE</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Número de Identificación *</label>
                        <input type="text" name="numeroIdentificacion" placeholder="Ej: 1098765432" required>
                    </div>
                </div>
                <div class="form-group">
                    <label>Correo Electrónico *</label>
                    <input type="email" name="correo" placeholder="tu@correo.com" required>
                </div>
                <div class="form-row-2">
                    <div class="form-group">
                        <label>Contraseña *</label>
                        <input type="password" name="password" id="passPac" placeholder="••••••••" required>
                    </div>
                    <div class="form-group">
                        <label>Confirmar Contraseña *</label>
                        <input type="password" id="passPacConfirm" placeholder="••••••••" required>
                    </div>
                </div>
                <div class="form-row-2">
                    <div class="form-group">
                        <label>Edad *</label>
                        <input type="number" name="edad" min="0" max="120" placeholder="25" required>
                    </div>
                    <div class="form-group">
                        <label>Sexo *</label>
                        <select name="sexo" required>
                            <option value="" disabled selected>Seleccionar...</option>
                            <option value="Masculino">Masculino</option>
                            <option value="Femenino">Femenino</option>
                            <option value="LGBTIQ+">LGBTIQ+</option>
                        </select>
                    </div>
                </div>
                <button type="submit" class="btn-submit">
                    <i class="fas fa-user-plus"></i> Crear Cuenta de Paciente
                </button>
            </form>

            <!-- ---- FORMULARIO MÉDICO (envía como solicitud) ---- -->
            <form id="formMedico" action="ControladorSolicitudMedico" method="POST"
                  enctype="multipart/form-data" class="hidden" onsubmit="return validarPassMedico()">
                <input type="hidden" name="accion" value="enviarSolicitud">

                <div class="form-group">
                    <label>Nombre Completo *</label>
                    <input type="text" name="nombre" placeholder="Dr. Juan García Pérez" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Tipo de ID *</label>
                        <select name="tipoId" required>
                            <option value="CC">CC</option>
                            <option value="TI">TI</option>
                            <option value="CE">CE</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Número de Identificación *</label>
                        <input type="text" name="numeroId" placeholder="Ej: 1098765432" required>
                    </div>
                </div>
                <div class="form-group">
                    <label>Correo Electrónico *</label>
                    <input type="email" name="correo" placeholder="medico@correo.com" required>
                </div>
                <div class="form-row-2">
                    <div class="form-group">
                        <label>Contraseña *</label>
                        <input type="password" name="password" id="passMed" placeholder="••••••••" required>
                    </div>
                    <div class="form-group">
                        <label>Confirmar Contraseña *</label>
                        <input type="password" id="passMedConfirm" placeholder="••••••••" required>
                    </div>
                </div>
                <div class="form-row-2">
                    <div class="form-group">
                        <label>Edad *</label>
                        <input type="number" name="edad" min="20" max="90" placeholder="35" required>
                    </div>
                    <div class="form-group">
                        <label>Sexo *</label>
                        <select name="sexo" required>
                            <option value="" disabled selected>Seleccionar...</option>
                            <option value="Masculino">Masculino</option>
                            <option value="Femenino">Femenino</option>
                            <option value="LGBTIQ+">LGBTIQ+</option>
                        </select>
                    </div>
                </div>

                <!-- Especialidad (conectada con tabla) -->
                <div class="form-group">
                    <label>Especialidad Principal</label>
                    <select name="idEspecialidad">
                        <option value="">-- Sin especialidad registrada --</option>
                        <% for (Especialidad esp : especialidades) { %>
                        <option value="<%= esp.getIdEspecialidad() %>"><%= esp.getNombre() %></option>
                        <% } %>
                    </select>
                </div>

                <!-- PDF Tarjeta Profesional (Pregrado) - OBLIGATORIO -->
                <div class="doc-section">
                    <h4><i class="fas fa-file-pdf" style="color:#e74c3c;"></i> Tarjeta Profesional (Pregrado) — Obligatorio</h4>
                    <div class="form-group">
                        <label>Subir PDF de tu tarjeta profesional *</label>
                        <input type="file" name="pdfPregrado" accept="application/pdf" required id="pdfPregradoInput">
                    </div>
                </div>

                <!-- Especialización opcional -->
                <div class="checkbox-group">
                    <input type="checkbox" name="tieneEspecializacion" id="chkEsp" onchange="toggleEspecializacion()">
                    <label for="chkEsp">Tengo una especialización médica adicional</label>
                </div>

                <div id="seccionEspecializacion" class="doc-section hidden">
                    <h4><i class="fas fa-graduation-cap" style="color:#0056b3;"></i> Datos de Especialización</h4>
                    <div class="form-group">
                        <label>Nombre de la Especialización *</label>
                        <input type="text" name="nombreEspecializacion" id="nomEsp" placeholder="Ej: Cardiología Intervencionista">
                    </div>
                    <div class="form-group">
                        <label>Subir PDF del certificado de especialización *</label>
                        <input type="file" name="pdfEspecializacion" accept="application/pdf" id="pdfEspInput">
                    </div>
                </div>

                <button type="submit" class="btn-submit" style="background: linear-gradient(135deg, #27ae60, #1e8449);">
                    <i class="fas fa-paper-plane"></i> Enviar Solicitud de Registro
                </button>
                <p style="font-size:11px; color:#999; text-align:center; margin-top:8px;">
                    <i class="fas fa-info-circle"></i> Tu solicitud será revisada por un administrador. Te notificaremos por correo.
                </p>
            </form>
        </div>
    </div>
</div>

<script>
    // Tabs Login/Registro
    function showTab(tab) {
        document.getElementById('login-section').classList.toggle('hidden', tab !== 'login');
        document.getElementById('register-section').classList.toggle('hidden', tab !== 'register');
        document.getElementById('tabLogin').classList.toggle('active', tab === 'login');
        document.getElementById('tabRegister').classList.toggle('active', tab === 'register');
    }

    // Seleccionar Rol
    function seleccionarRol(rol) {
        document.getElementById('formPaciente').classList.toggle('hidden', rol !== 'Paciente');
        document.getElementById('formMedico').classList.toggle('hidden', rol !== 'Medico');
        document.getElementById('btnPaciente').classList.toggle('selected', rol === 'Paciente');
        document.getElementById('btnMedico').classList.toggle('selected', rol === 'Medico');
        document.getElementById('btnPaciente').style.borderColor = rol === 'Paciente' ? '#0056b3' : '#e0e0e0';
        document.getElementById('btnMedico').style.borderColor = rol === 'Medico' ? '#27ae60' : '#e0e0e0';
    }

    // Toggle sección especialización
    function toggleEspecializacion() {
        var chk = document.getElementById('chkEsp').checked;
        document.getElementById('seccionEspecializacion').classList.toggle('hidden', !chk);
        document.getElementById('nomEsp').required = chk;
        document.getElementById('pdfEspInput').required = chk;
    }

    // Validar contraseñas paciente
    function validarPassPaciente() {
        if (document.getElementById('passPac').value !== document.getElementById('passPacConfirm').value) {
            alert('Las contraseñas no coinciden.'); return false;
        }
        return true;
    }

    // Validar contraseñas médico
    function validarPassMedico() {
        if (document.getElementById('passMed').value !== document.getElementById('passMedConfirm').value) {
            alert('Las contraseñas no coinciden.'); return false;
        }
        return true;
    }

    // Si hay mensaje pendiente o error, abrir el tab correcto
    <% if (request.getAttribute("mensajePendiente") != null || 
           (request.getAttribute("error") != null && request.getParameter("fromReg") != null)) { %>
    showTab('register');
    <% } %>
</script>
</body>
</html>