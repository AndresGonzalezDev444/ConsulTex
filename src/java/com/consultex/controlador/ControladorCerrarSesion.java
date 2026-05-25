package com.consultex.controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet encargado de destruir la sesión del usuario de forma segura.
 */
@WebServlet(name = "ControladorCerrarSesion", urlPatterns = {"/ControladorCerrarSesion"})
public class ControladorCerrarSesion extends HttpServlet {

    // Usamos doGet
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Obtenemos la sesión actual (pasamos "false" para que no cree una nueva si no existe)
        HttpSession session = request.getSession(false);
        
        // Si la sesión existe, la invalidamos (borramos toda la memoria de ese usuario)
        if (session != null) {
            session.invalidate();
        }
        
        // Redirigimos al usuario de vuelta al login
        response.sendRedirect("index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirigimos al GET por si acaso llega una petición POST
        doGet(request, response);
    }
}