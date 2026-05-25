package com.consultex.controlador;

import com.consultex.dao.EspecialidadDAO;
import com.consultex.modelo.Especialidad;
import com.consultex.modelo.Usuario;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 * Controlador para la gestión de Especialidades (CRUD - Criterio 12).
 * Solo accesible por el Administrador.
 */
@WebServlet(name = "ControladorEspecialidad", urlPatterns = {"/ControladorEspecialidad"})
public class ControladorEspecialidad extends HttpServlet {

    EspecialidadDAO dao = new EspecialidadDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario u = (Usuario) session.getAttribute("usuarioActivo");
        if (u == null || (!u.getRol().equalsIgnoreCase("Admin") && !u.getRol().equalsIgnoreCase("Administrador"))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        if ("listar".equalsIgnoreCase(accion)) {
            List<Especialidad> lista = dao.listarActivas();
            request.setAttribute("especialidades", lista);
            request.getRequestDispatcher("vistas/admin/gestionEspecialidades.jsp").forward(request, response);

        } else if ("cargar".equalsIgnoreCase(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Especialidad e = dao.buscarPorId(id);
            request.setAttribute("especialidad", e);
            request.setAttribute("especialidades", dao.listarActivas());
            request.getRequestDispatcher("vistas/admin/gestionEspecialidades.jsp").forward(request, response);

        } else if ("eliminar".equalsIgnoreCase(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.eliminarLogico(id);
            response.sendRedirect(request.getContextPath() + "/ControladorEspecialidad?accion=listar");

        } else {
            response.sendRedirect(request.getContextPath() + "/ControladorEspecialidad?accion=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("guardar".equalsIgnoreCase(accion)) {
            Especialidad e = new Especialidad();
            e.setNombre(request.getParameter("nombre"));
            e.setDescripcion(request.getParameter("descripcion"));
            dao.registrar(e);
            response.sendRedirect(request.getContextPath() + "/ControladorEspecialidad?accion=listar");

        } else if ("actualizar".equalsIgnoreCase(accion)) {
            Especialidad e = new Especialidad();
            e.setIdEspecialidad(Integer.parseInt(request.getParameter("id")));
            e.setNombre(request.getParameter("nombre"));
            e.setDescripcion(request.getParameter("descripcion"));
            dao.actualizar(e);
            response.sendRedirect(request.getContextPath() + "/ControladorEspecialidad?accion=listar");
        }
    }
}
