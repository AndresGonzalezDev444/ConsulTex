<%@page import="com.consultex.modelo.Usuario"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ConsulTex - Gestión</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body style="display:block; padding:30px;">
    <div class="form-container" style="max-width: 1000px;">
        <a href="${pageContext.request.contextPath}/vistas/admin/panelAdmin.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Volver al Panel</a>
        
        <div class="page-header" style="margin-top: 10px;">
            <div>
                <h1>Gestión de <%= request.getAttribute("tipo") %></h1>
                <p>Administra los usuarios activos e inactivos del sistema.</p>
            </div>
            <div style="display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
                <div class="form-group" style="margin-bottom: 0; position: relative; width: 250px;">
                    <i class="fas fa-search" style="position: absolute; left: 15px; top: 15px; color: var(--text-muted);"></i>
                    <input type="text" id="searchInput" placeholder="Buscar ID o Correo..." onkeyup="filterTable()" style="padding-left: 40px;">
                </div>
                <a href="${pageContext.request.contextPath}/vistas/admin/agregarUsuario.jsp" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Registrar Usuario
                </a>
            </div>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Correo</th>
                        <th>Rol</th>
                        <th>Registro</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Usuario> lista = (List<Usuario>) request.getAttribute("usuarios");
                        String filtro = request.getAttribute("tipo").toString().equals("Médicos") ? "Medico" : "Paciente";
                        if(lista != null){
                            for(Usuario u : lista){ 
                                if(u.getRol().equalsIgnoreCase(filtro)){
                    %>
                    <tr>
                        <td><strong>#<%= u.getIdUsuario() %></strong></td>
                        <td><%= u.getCorreo() %></td>
                        <td><span class="badge-role" style="color:var(--text);"><%= u.getRol() %></span></td>
                        <td><%= u.getFechaRegistro() %></td>
                        <td>
                            <% if(u.isEstadoActivo()) { %>
                                <span class="status-badge status-active"><i class="fas fa-check-circle"></i> Activo</span>
                            <% } else { %>
                                <span class="status-badge status-inactive"><i class="fas fa-times-circle"></i> Inactivo</span>
                            <% } %>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/ControladorAdmin?accion=cargarUsuario&id=<%= u.getIdUsuario() %>" class="btn btn-outline btn-sm" title="Editar"><i class="fas fa-edit"></i></a>
                            <% if(u.isEstadoActivo()) { %>
                                <a href="${pageContext.request.contextPath}/ControladorAdmin?accion=deshabilitar&id=<%= u.getIdUsuario() %>&tipo=<%= filtro %>" class="btn btn-danger btn-sm" title="Deshabilitar" onclick="return confirm('¿Estás seguro de deshabilitar a este usuario?');"><i class="fas fa-user-times"></i></a>
                            <% } else { %>
                                <a href="${pageContext.request.contextPath}/ControladorAdmin?accion=prepararActivacion&id=<%= u.getIdUsuario() %>&tipo=<%= filtro %>" class="btn btn-secondary btn-sm" title="Activar"><i class="fas fa-user-check"></i></a>
                            <% } %>
                        </td>
                    </tr>
                    <% } } } %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function filterTable() {
            var input, filter, table, tr, tdId, tdCorreo, i, txtValueId, txtValueCorreo;
            input = document.getElementById("searchInput");
            filter = input.value.toUpperCase();
            table = document.querySelector("table");
            tr = table.getElementsByTagName("tr");

            for (i = 1; i < tr.length; i++) {
                tdId = tr[i].getElementsByTagName("td")[0];
                tdCorreo = tr[i].getElementsByTagName("td")[1];
                
                if (tdId || tdCorreo) {
                    txtValueId = tdId.textContent || tdId.innerText;
                    txtValueCorreo = tdCorreo.textContent || tdCorreo.innerText;
                    
                    if (txtValueId.toUpperCase().indexOf(filter) > -1 || txtValueCorreo.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }
    </script>
</body>
</html>