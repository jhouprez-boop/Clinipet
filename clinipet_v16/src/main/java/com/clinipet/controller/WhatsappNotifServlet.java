package com.clinipet.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "WhatsappNotifServlet", urlPatterns = {"/whatsapp-notif"})
public class WhatsappNotifServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/whatsapp_notif.jsp")
               .forward(request, response);
    }
}
