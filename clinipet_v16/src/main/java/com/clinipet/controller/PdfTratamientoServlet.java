package com.clinipet.controller;

import com.clinipet.dao.HistoriaDAO;
import com.clinipet.model.Usuario;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.awt.Color;
import java.io.IOException;
import java.util.Map;

/**
 * Genera y descarga el PDF de tratamiento de una cita.
 * Acceso: solo el cliente dueño de la cita.
 *
 * GET /cliente/pdf-tratamiento?id_cita=X
 */
@WebServlet(name = "PdfTratamientoServlet", urlPatterns = {"/cliente/pdf-tratamiento"})
public class PdfTratamientoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idCitaStr = request.getParameter("id_cita");
        if (idCitaStr == null || idCitaStr.isEmpty()) {
            response.sendError(400, "Falta id_cita");
            return;
        }

        int idCita;
        try {
            idCita = Integer.parseInt(idCitaStr);
        } catch (NumberFormatException e) {
            response.sendError(400, "id_cita inválido");
            return;
        }

        HistoriaDAO hDao = new HistoriaDAO();
        Map<String, Object> datos;

        // Admin y veterinario pueden ver cualquier cita; cliente solo la suya
        String rol = usuario.getRol().toUpperCase();
        if (rol.contains("ADMINISTRADOR") || rol.contains("VETERINARIO") || rol.contains("ENFERMERO")) {
            datos = hDao.getHistoriaByCita(idCita);
        } else {
            datos = hDao.getDatosPDF(idCita, usuario.getId());
        }

        if (datos == null) {
            response.sendError(403, "No tienes permiso para ver este tratamiento");
            return;
        }

        // Configurar respuesta como descarga PDF
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"tratamiento_cita_" + idCita + ".pdf\"");

        try {
            generarPDF(response, datos, idCita);
        } catch (DocumentException de) {
            throw new IOException("Error generando PDF: " + de.getMessage(), de);
        }
    }

    private void generarPDF(HttpServletResponse response, Map<String, Object> d, int idCita)
            throws DocumentException, IOException {

        Document doc = new Document(PageSize.A4, 50, 50, 60, 50);
        PdfWriter writer = PdfWriter.getInstance(doc, response.getOutputStream());
        doc.open();

        // ── Colores de CliniPet ───────────────────────────────────────────
        Color verde      = new Color(0, 168, 90);
        Color verdeOscuro = new Color(0, 61, 37);
        Color grisClaro  = new Color(240, 255, 247);
        Color grisTexto  = new Color(100, 116, 139);

        // ── Fuentes ───────────────────────────────────────────────────────
        Font fuenteTitulo  = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 22, verdeOscuro);
        Font fuenteSubtit  = FontFactory.getFont(FontFactory.HELVETICA, 11, grisTexto);
        Font fuenteSeccion = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, verde);
        Font fuenteLabel   = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, verdeOscuro);
        Font fuenteValor   = FontFactory.getFont(FontFactory.HELVETICA, 10, Color.BLACK);
        Font fuentePie     = FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 9, grisTexto);

        // ════════════════════════════════════════════════
        //  CABECERA
        // ════════════════════════════════════════════════
        PdfContentByte canvas = writer.getDirectContent();

        // Rectángulo verde de cabecera
        canvas.setColorFill(verde);
        canvas.rectangle(0, PageSize.A4.getHeight() - 100, PageSize.A4.getWidth(), 100);
        canvas.fill();

        // Título en la cabecera
        Font fTitBlanco = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 24, Color.WHITE);
        Font fSubBlanco  = FontFactory.getFont(FontFactory.HELVETICA, 11, new Color(200, 255, 230));
        Paragraph titulo = new Paragraph("🐾 CliniPet — Historia Clínica", fTitBlanco);
        titulo.setAlignment(Element.ALIGN_CENTER);
        titulo.setSpacingBefore(18);
        doc.add(titulo);

        Paragraph subtit = new Paragraph("Tratamiento y medicación de tu mascota", fSubBlanco);
        subtit.setAlignment(Element.ALIGN_CENTER);
        doc.add(subtit);

        doc.add(new Paragraph(" "));
        doc.add(new Paragraph(" "));

        // ════════════════════════════════════════════════
        //  DATOS DE LA CITA
        // ════════════════════════════════════════════════
        doc.add(seccionTitulo("📋 Datos de la cita", fuenteSeccion, verde));

        PdfPTable tablaCita = new PdfPTable(4);
        tablaCita.setWidthPercentage(100);
        tablaCita.setSpacingBefore(6);
        tablaCita.setSpacingAfter(12);

        addCeldaDato(tablaCita, "N° Cita",   "#" + idCita, fuenteLabel, fuenteValor, grisClaro);
        addCeldaDato(tablaCita, "Fecha",      str(d, "fecha"), fuenteLabel, fuenteValor, grisClaro);
        addCeldaDato(tablaCita, "Hora",       str(d, "hora"), fuenteLabel, fuenteValor, grisClaro);
        addCeldaDato(tablaCita, "Motivo",     str(d, "motivo"), fuenteLabel, fuenteValor, grisClaro);
        doc.add(tablaCita);

        // ════════════════════════════════════════════════
        //  DATOS DE LA MASCOTA
        // ════════════════════════════════════════════════
        doc.add(seccionTitulo("🐶 Datos de la mascota", fuenteSeccion, verde));

        PdfPTable tablaMascota = new PdfPTable(4);
        tablaMascota.setWidthPercentage(100);
        tablaMascota.setSpacingBefore(6);
        tablaMascota.setSpacingAfter(12);

        addCeldaDato(tablaMascota, "Nombre",    str(d, "mascota"),  fuenteLabel, fuenteValor, Color.WHITE);
        addCeldaDato(tablaMascota, "Especie",   str(d, "especie"),  fuenteLabel, fuenteValor, Color.WHITE);
        addCeldaDato(tablaMascota, "Raza",      str(d, "raza"),     fuenteLabel, fuenteValor, Color.WHITE);
        addCeldaDato(tablaMascota, "Sexo",      str(d, "sexo"),     fuenteLabel, fuenteValor, Color.WHITE);
        doc.add(tablaMascota);

        // Dueño y Veterinario
        PdfPTable tablaDuenio = new PdfPTable(2);
        tablaDuenio.setWidthPercentage(100);
        tablaDuenio.setSpacingBefore(4);
        tablaDuenio.setSpacingAfter(12);

        addCeldaDato(tablaDuenio, "Dueño",        str(d, "duenio"),      fuenteLabel, fuenteValor, grisClaro);
        addCeldaDato(tablaDuenio, "Veterinario",  str(d, "veterinario"), fuenteLabel, fuenteValor, grisClaro);
        doc.add(tablaDuenio);

        // ════════════════════════════════════════════════
        //  HISTORIA CLÍNICA
        // ════════════════════════════════════════════════
        doc.add(seccionTitulo("🩺 Historia clínica", fuenteSeccion, verde));

        doc.add(cajaDiagnostico("Diagnóstico", str(d, "diagnostico"), fuenteLabel, fuenteValor, grisClaro));
        doc.add(cajaDiagnostico("Tratamiento indicado", str(d, "tratamiento"), fuenteLabel, fuenteValor, Color.WHITE));

        // Medicación — resaltada en verde claro
        Color verdePastel = new Color(212, 255, 235);
        doc.add(cajaDiagnostico("💊 Medicación / Dosis", str(d, "medicacion"), fuenteLabel, fuenteValor, verdePastel));
        doc.add(cajaDiagnostico("Observaciones", str(d, "observaciones"), fuenteLabel, fuenteValor, Color.WHITE));

        // ════════════════════════════════════════════════
        //  PIE DE PÁGINA
        // ════════════════════════════════════════════════
        doc.add(new Paragraph(" "));
        doc.add(new Paragraph(" "));

        // Línea separadora
        canvas.setColorStroke(verde);
        canvas.setLineWidth(1f);
        float y = writer.getVerticalPosition(true);
        canvas.moveTo(50, y);
        canvas.lineTo(PageSize.A4.getWidth() - 50, y);
        canvas.stroke();

        doc.add(new Paragraph(" "));
        Paragraph pie = new Paragraph(
            "Documento generado por CliniPet  •  Cita #" + idCita +
            "  •  Este documento no reemplaza una consulta veterinaria presencial.",
            fuentePie);
        pie.setAlignment(Element.ALIGN_CENTER);
        doc.add(pie);

        doc.close();
    }

    // ── Helpers de formato ───────────────────────────────────────────────

    private Paragraph seccionTitulo(String texto, Font fuente, Color colorLinea) {
        Paragraph p = new Paragraph(texto, fuente);
        p.setSpacingBefore(14);
        p.setSpacingAfter(4);
        return p;
    }

    private void addCeldaDato(PdfPTable tabla, String label, String valor,
                               Font fLabel, Font fValor, Color bgColor) {
        PdfPCell celda = new PdfPCell();
        celda.setBackgroundColor(bgColor);
        celda.setPadding(8);
        celda.setBorderColor(new Color(200, 240, 220));
        Phrase contenido = new Phrase();
        contenido.add(new Chunk(label + "\n", fLabel));
        contenido.add(new Chunk(valor.isEmpty() ? "—" : valor, fValor));
        celda.setPhrase(contenido);
        tabla.addCell(celda);
    }

    private PdfPTable cajaDiagnostico(String titulo, String contenido,
                                       Font fLabel, Font fValor, Color bg) throws DocumentException {
        PdfPTable t = new PdfPTable(1);
        t.setWidthPercentage(100);
        t.setSpacingBefore(6);
        t.setSpacingAfter(6);

        PdfPCell c = new PdfPCell();
        c.setBackgroundColor(bg);
        c.setPadding(10);
        c.setBorderColor(new Color(180, 230, 205));

        Phrase p = new Phrase();
        p.add(new Chunk(titulo + "\n", fLabel));
        p.add(new Chunk(contenido.isEmpty() ? "Sin información registrada" : contenido, fValor));
        c.setPhrase(p);
        t.addCell(c);
        return t;
    }

    private String str(Map<String, Object> m, String key) {
        Object v = m.get(key);
        return (v == null) ? "" : v.toString();
    }
}
