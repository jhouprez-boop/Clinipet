package com.clinipet.controller;

import com.clinipet.dao.DashboardDAO;
import com.clinipet.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "CitaServlet", urlPatterns = {"/citas/nueva", "/citas/guardar"})
public class CitaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login?msg=Debes iniciar sesion para agendar cita");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        DashboardDAO dao = new DashboardDAO();
        String rol = usuario.getRol();

        if ("CLIENTE".equalsIgnoreCase(rol)) {
            // FIX: tambi-n cargar veterinarios disponibles
            request.setAttribute("mascotas", dao.listarMascotasPorUsuario(usuario.getId()));
            request.setAttribute("veterinarios", dao.listarVeterinarios());
            request.getRequestDispatcher("/WEB-INF/views/cliente/agendar_cita_cliente.jsp")
                    .forward(request, response);
            return;
        }

        // ADMIN / RECEPCIONISTA pueden agendar citas desde el panel admin
        if ("ADMIN".equalsIgnoreCase(rol) || "ADMINISTRADOR".equalsIgnoreCase(rol)
                || "RECEPCIONISTA".equalsIgnoreCase(rol)) {
            request.setAttribute("mascotas", dao.listarMascotas());
            request.setAttribute("veterinarios", dao.listarVeterinarios());
            request.getRequestDispatcher("/WEB-INF/views/cita_form.jsp")
                    .forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String rol = usuario.getRol();

        try {
            int idMascota = Integer.parseInt(request.getParameter("id_mascota"));

            String vetParam = request.getParameter("id_veterinario");
            int idVeterinario = 0;
            if (vetParam != null && !vetParam.trim().isEmpty()) {
                idVeterinario = Integer.parseInt(vetParam);
            }

            String fecha  = request.getParameter("fecha");
            String hora   = request.getParameter("hora");
            String motivo = request.getParameter("motivo");

            DashboardDAO dao = new DashboardDAO();

            // ADMIN usa guardarCita (sin validar due-o, con precio)
            if ("ADMIN".equalsIgnoreCase(rol) || "ADMINISTRADOR".equalsIgnoreCase(rol)
                    || "RECEPCIONISTA".equalsIgnoreCase(rol)) {

                String precioParam = request.getParameter("precio");
                double precio = (precioParam != null && !precioParam.trim().isEmpty())
                        ? Double.parseDouble(precioParam) : 30000;

                int resultado = dao.guardarCita(idMascota, idVeterinario, fecha, hora, motivo, precio);

                if (resultado == -4) {
                    response.sendRedirect(request.getContextPath()
                            + "/citas/nueva?error=No puedes agendar en una fecha u hora que ya pasó");
                    return;
                }
                if (resultado == -1) {
                    response.sendRedirect(request.getContextPath()
                            + "/citas/nueva?error=Esta mascota ya tiene una cita pendiente");
                    return;
                }
                if (resultado == -2) {
                    response.sendRedirect(request.getContextPath()
                            + "/citas/nueva?error=El veterinario ya tiene una cita en ese horario");
                    return;
                }
                if (resultado > 0) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?ok=Cita+registrada+correctamente");
                } else {
                    response.sendRedirect(request.getContextPath() + "/citas/nueva?error=No se pudo guardar la cita");
                }
                return;
            }

            // CLIENTE usa guardarCitaCliente (valida due-o)
            int resultado = dao.guardarCitaCliente(
                    usuario.getId(), idMascota, idVeterinario, fecha, hora, motivo);

            if (resultado == -5) {
                response.sendRedirect(request.getContextPath()
                        + "/citas/nueva?error=No puedes agendar en una fecha u hora que ya pasó");
                return;
            }
            if (resultado == -1) {
                response.sendRedirect(request.getContextPath()
                        + "/citas/nueva?error=Esa mascota no pertenece a tu cuenta");
                return;
            }
            if (resultado == -2) {
                response.sendRedirect(request.getContextPath()
                        + "/citas/nueva?error=Esta mascota ya tiene una cita pendiente");
                return;
            }
            if (resultado == -3) {
                response.sendRedirect(request.getContextPath()
                        + "/citas/nueva?error=El veterinario ya tiene una cita en ese horario");
                return;
            }
            if (resultado > 0) {
                response.sendRedirect(request.getContextPath() + "/cliente/dashboard?ok=cita");
            } else {
                response.sendRedirect(request.getContextPath() + "/citas/nueva?error=No se pudo guardar la cita");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/citas/nueva?error=" + e.getMessage());
        }
    }
}
