package com.clinipet.controller;

import com.clinipet.dao.DashboardDAO;
import com.clinipet.dao.HistoriaDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

/**
 * Servlet para que el veterinario/enfermero llene la historia clínica (diagnóstico,
 * tratamiento, medicación) de una cita y la marque como REALIZADA.
 *
 * GET  /veterinario/atender?id_cita=X  → muestra el formulario
 * POST /veterinario/atender            → guarda y redirige al panel
 */
@WebServlet(name = "VeterinarioAtenderServlet", urlPatterns = {"/veterinario/atender"})
public class VeterinarioAtenderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (!esVetOEnfermero(usuario)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idCitaStr = request.getParameter("id_cita");
        if (idCitaStr == null || idCitaStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/enfermero/dashboard");
            return;
        }

        int idCita;
        try {
            idCita = Integer.parseInt(idCitaStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/enfermero/dashboard");
            return;
        }

        HistoriaDAO hDao = new HistoriaDAO();
        Map<String, Object> datos = hDao.getHistoriaByCita(idCita);

        if (datos == null) {
            response.sendRedirect(request.getContextPath() + "/enfermero/dashboard");
            return;
        }

        request.setAttribute("datos", datos);
        request.getRequestDispatcher("/WEB-INF/views/veterinario/atender_cita.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (!esVetOEnfermero(usuario)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        int idCita    = Integer.parseInt(request.getParameter("id_cita"));
        int idMascota = Integer.parseInt(request.getParameter("id_mascota"));
        String diag   = nvl(request.getParameter("diagnostico"));
        String trat   = nvl(request.getParameter("tratamiento"));
        String med    = nvl(request.getParameter("medicacion"));
        String obs    = nvl(request.getParameter("observaciones"));

        try {
            // Guardar historia clínica
            HistoriaDAO hDao = new HistoriaDAO();
            hDao.guardarOActualizar(idMascota, idCita, diag, trat, med, obs);

            // Cambiar estado de la cita a REALIZADA
            DashboardDAO dDao = new DashboardDAO();
            dDao.cambiarEstadoCita(idCita, "REALIZADA");

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Volver al panel con mensaje de éxito
        response.sendRedirect(request.getContextPath() + "/enfermero/dashboard?ok=historia");
    }

    private boolean esVetOEnfermero(Usuario u) {
        if (u == null) return false;
        String rol = u.getRol().toUpperCase();
        return rol.contains("VETERINARIO") || rol.contains("ENFERMERO") || rol.contains("ADMINISTRADOR");
    }

    private String nvl(String s) {
        return (s == null) ? "" : s.trim();
    }
}
