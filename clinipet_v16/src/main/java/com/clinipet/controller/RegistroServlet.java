package com.clinipet.controller;
import com.clinipet.dao.UsuarioDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="RegistroServlet", urlPatterns={"/registro"})
public class RegistroServlet extends HttpServlet {
 protected void doGet(HttpServletRequest request,HttpServletResponse response)throws ServletException,IOException{
 request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request,response); }
 protected void doPost(HttpServletRequest request,HttpServletResponse response)throws ServletException,IOException{
 request.setCharacterEncoding("UTF-8");
 boolean ok=new UsuarioDAO().registrarCompleto(
 request.getParameter("nombre"),
 request.getParameter("correo"),
 request.getParameter("contrasena"),
 request.getParameter("telefono"),
 request.getParameter("documento"),
 request.getParameter("direccion")
 );
 if(ok)response.sendRedirect(request.getContextPath()+"/login?msg=Registro exitoso, inicia sesion");
 else{request.setAttribute("error","No se pudo registrar. Revisa que el correo no exista.");request.getRequestDispatcher("/WEB-INF/views/registro.jsp").forward(request,response);}
 }
}
