<%@page import="com.consultex.modelo.Usuario"%>
<%@page import="com.consultex.modelo.Especialidad"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioLogueado = (Usuario) session.getAttribute("usuarioActivo");
    if (usuarioLogueado == null || (!usuarioLogueado.getRol().equalsIgnoreCase("Admin") && !usuarioLogueado.getRol().equalsIgnoreCase("Administrador"))) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    List<Especialidad> especialidades = (List<Especialidad>) request.getAttribute("especialidades");
    Especialidad editando = (Especialidad) request.getAttribute("especialidad");
    String msgParam = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Gestión de Especialidades</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body style="display:block; padding:30px;">
    <div class="form-container" style="max-width: 1100px;">
        <a href="${pageContext.request.contextPath}/vistas/admin/panelAdmin.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Volver al Panel</a>
        
        <div class="page-header" style="margin-top: 10px;">
            <div>
                <h1> Gestión de Especialidades</h1>
                <p>Administra las especialidades médicas del sistema.</p>
            </div>
        </div>

        <% if ("ok".equals(msgParam)) { %>
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> Operación realizada con éxito.</div>
        <% } %>

        <!-- FORMULARIO CREAR / EDITAR -->
        <div class="card-panel" style="margin-bottom: 30px;">
            <h3 style="margin-bottom:20px; color:var(--dark); display: flex; align-items: center; gap: 10px;">
                <div class="avatar" style="width:35px;height:35px;font-size:16px;"><i class="fas fa-<%= editando != null ? "edit" : "plus-circle" %>"></i></div>
                <%= editando != null ? "Editar Especialidad" : "Nueva Especialidad" %>
            </h3>
            <form method="post" action="${pageContext.request.contextPath}/ControladorEspecialidad">
                <input type="hidden" name="accion" value="<%= editando != null ? "actualizar" : "guardar" %>">
                <% if (editando != null) { %>
                <input type="hidden" name="id" value="<%= editando.getIdEspecialidad() %>">
                <% } %>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group">
                        <label for="nombre">Nombre de la Especialidad *</label>
                        <div style="position: relative;">
                            <i class="fas fa-tag" style="position: absolute; left: 15px; top: 15px; color: var(--text-muted);"></i>
                            <input type="text" id="nombre" name="nombre" required placeholder="Ej: Cardiología, Pediatría..." value="<%= editando != null ? editando.getNombre() : "" %>" style="padding-left: 45px;">
                        </div>
                    </div>
                    <div class="form-group" style="display: flex; align-items: flex-end;">
                        <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px;">
                            <i class="fas fa-save"></i> <%= editando != null ? "Actualizar Especialidad" : "Guardar Especialidad" %>
                        </button>
                    </div>
                    <div class="form-group" style="grid-column: span 2;">
                        <label for="descripcion">Descripción</label>
                        <textarea id="descripcion" name="descripcion" placeholder="Descripción breve de la especialidad..." style="min-height: 80px;"><%= editando != null ? editando.getDescripcion() : "" %></textarea>
                    </div>
                </div>
            </form>
        </div>

        <!-- TABLA LISTADO -->
        <div class="card-panel">
            <h3 style="margin-bottom:20px; color:var(--dark);"><i class="fas fa-list"></i> Especialidades Registradas</h3>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>#ID</th>
                            <th>Nombre</th>
                            <th>Descripción</th>
                            <th>Registro</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (especialidades != null && !especialidades.isEmpty()) {
                            for (Especialidad e : especialidades) { %>
                        <tr>
                            <td><strong><%= e.getIdEspecialidad() %></strong></td>
                            <td><strong><%= e.getNombre() %></strong></td>
                            <td><span style="color:var(--text-muted);"><%= e.getDescripcion() != null ? e.getDescripcion() : "-" %></span></td>
                            <td style="font-size:13px; color:var(--text-muted);"><%= e.getFechaCreacion() %></td>
                            <td><span class="status-badge status-active"><i class="fas fa-check-circle"></i> Activa</span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/ControladorEspecialidad?accion=cargar&id=<%= e.getIdEspecialidad() %>" class="btn btn-outline btn-sm" title="Editar"><i class="fas fa-edit"></i></a>
                                &nbsp;
                                <form method="get" action="${pageContext.request.contextPath}/ControladorEspecialidad" style="display:inline;"
                                    onsubmit="return confirm('¿Desactivar la especialidad <%= e.getNombre() %>?');">
                                    <input type="hidden" name="accion" value="eliminar">
                                    <input type="hidden" name="id" value="<%= e.getIdEspecialidad() %>">
                                    <button type="submit" class="btn btn-danger btn-sm" title="Desactivar"><i class="fas fa-ban"></i></button>
                                </form>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="6" style="text-align:center; color:var(--text-muted); padding:40px;">
                            <i class="fas fa-box-open" style="font-size: 32px; color: #e0e0e0; margin-bottom: 10px; display:block;"></i>
                            No hay especialidades registradas aún.
                        </td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
