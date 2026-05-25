package com.consultex.controlador;

import com.consultex.dao.UsuarioDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet encargado de procesar el registro de nuevos usuarios.
 */
@WebServlet(name = "ControladorUsuario", urlPatterns = {"/ControladorUsuario"})
public class ControladorUsuario extends HttpServlet {

    UsuarioDAO udao = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String accion = request.getParameter("accion");

        if (accion.equalsIgnoreCase("Registrar")) {
            String nombre = request.getParameter("nombre");
            String correo = request.getParameter("correo");
            String password = request.getParameter("password");
            String rol = request.getParameter("rol");
            int edad = Integer.parseInt(request.getParameter("edad"));
            String sexo = request.getParameter("sexo");
            String tipoId = request.getParameter("tipoIdentificacion");
            String numeroId = request.getParameter("numeroIdentificacion");

            boolean registrado = udao.registrarUsuarioCompleto(nombre, correo, password, rol, edad, sexo, tipoId, numeroId);

            if (registrado) {
                request.setAttribute("mensaje", "¡Cuenta creada con éxito! Por favor inicie sesión.");
            } else {
                request.setAttribute("error", "Error al registrar. El correo ya existe o los datos son inválidos.");
            }
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}