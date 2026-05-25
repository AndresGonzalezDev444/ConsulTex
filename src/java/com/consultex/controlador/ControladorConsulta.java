package com.consultex.controlador;

import com.consultex.dao.ConsultaDAO;
import com.consultex.dao.MedicoDAO;
import com.consultex.modelo.Consulta;
import com.consultex.modelo.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "ControladorConsulta", urlPatterns = {"/ControladorConsulta"})
public class ControladorConsulta extends HttpServlet {
    ConsultaDAO cdao = new ConsultaDAO();
    MedicoDAO mdao = new MedicoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if(accion.equals("verFicha")){
            String idPaciente = request.getParameter("idPaciente");
            request.setAttribute("idP", idPaciente);
            request.getRequestDispatcher("vistas/medico/registrarConsulta.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if(accion.equals("GuardarConsulta")){
            HttpSession session = request.getSession();
            Usuario u = (Usuario) session.getAttribute("usuarioActivo");
            int idMed = mdao.obtenerIdMedicoPorUsuario(u.getIdUsuario());
            
            Consulta c = new Consulta();
            c.setIdPaciente(Integer.parseInt(request.getParameter("idPaciente")));
            c.setIdMedico(idMed);
            c.setFecha(request.getParameter("fecha"));
            c.setMotivo(request.getParameter("motivo"));
            c.setDiagnostico(request.getParameter("diagnostico"));
            c.setPresionArterial(request.getParameter("presion"));
            
            String tempStr = request.getParameter("temperatura");
            c.setTemperatura((tempStr != null && !tempStr.trim().isEmpty()) ? Double.parseDouble(tempStr) : 0.0);
            
            String frecStr = request.getParameter("frecuencia");
            c.setFrecuenciaCardiaca((frecStr != null && !frecStr.trim().isEmpty()) ? Integer.parseInt(frecStr) : 0);
            
            String pesoStr = request.getParameter("peso");
            c.setPeso((pesoStr != null && !pesoStr.trim().isEmpty()) ? Double.parseDouble(pesoStr) : 0.0);
            
            String estStr = request.getParameter("estatura");
            c.setEstatura((estStr != null && !estStr.trim().isEmpty()) ? Double.parseDouble(estStr) : 0.0);

            response.setContentType("text/html;charset=UTF-8");
            java.io.PrintWriter out = response.getWriter();
            
            String resultadoBD = cdao.registrarConsultaSegura(c);
            if(resultadoBD.equals("OK")){
                out.println("<script>alert('¡Ficha Médica guardada con éxito! Los datos alimentarán las estadísticas del sistema.'); window.location.href='" + request.getContextPath() + "/ControladorPaciente?accion=misPacientes';</script>");
            } else {
                out.println("<script>alert('SQL Error: " + resultadoBD.replace("'", "") + "'); window.history.back();</script>");
            }
        }
    }
}