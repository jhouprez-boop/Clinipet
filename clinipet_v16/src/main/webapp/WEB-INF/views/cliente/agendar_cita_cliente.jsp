<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.clinipet.model.Usuario" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    List<Map<String,Object>> mascotas = (List<Map<String,Object>>) request.getAttribute("mascotas");
    List<Map<String,Object>> veterinarios = (List<Map<String,Object>>) request.getAttribute("veterinarios");

    if (mascotas == null) mascotas = new ArrayList<>();
    if (veterinarios == null) veterinarios = new ArrayList<>();
%>

<!doctype html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Agendar cita | CliniPet</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&family=Fredoka:wght@600;700&display=swap" rel="stylesheet">

<style>
body{
    margin:0;
    font-family:"Nunito",sans-serif;
    background:linear-gradient(135deg,#fbfffd,#eafff4);
}
h1,h2,h3{font-family:"Fredoka",sans-serif}
.page{min-height:100vh;padding:35px 20px}
.wrap{max-width:1100px;margin:auto}
.top{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:25px;
}
.brand{
    display:flex;
    gap:12px;
    align-items:center;
    text-decoration:none;
    color:#003d25;
    font-weight:900;
}
.brand-icon{
    width:58px;
    height:58px;
    border-radius:20px;
    background:linear-gradient(135deg,#00a85a,#00d978);
    color:white;
    display:grid;
    place-items:center;
    font-size:2rem;
}
.btnx{
    border:0;
    border-radius:14px;
    padding:12px 18px;
    font-weight:900;
    text-decoration:none;
    display:inline-flex;
    align-items:center;
    gap:8px;
}
.btn-green{
    background:linear-gradient(135deg,#00a85a,#00d978);
    color:white;
}
.btn-soft{
    background:white;
    color:#003d25;
    box-shadow:0 22px 70px rgba(0,60,35,.13);
}
.grid{
    display:grid;
    grid-template-columns:.8fr 1.2fr;
    gap:24px;
}
.cardx{
    background:white;
    border-radius:28px;
    box-shadow:0 22px 70px rgba(0,60,35,.13);
    overflow:hidden;
}
.card-head{
    padding:24px;
    background:linear-gradient(135deg,#003d25,#00a85a);
    color:white;
}
.card-head h1,.card-head h2{color:white;margin:0}
.card-body{padding:26px}
.pet-card{
    padding:16px;
    border-radius:18px;
    background:#f7fffb;
    border:1px solid #dbeee5;
    margin-bottom:12px;
}
.badge-soft{
    background:#dcfff0;
    color:#007f4f;
    border-radius:999px;
    padding:7px 12px;
    font-weight:900;
    display:inline-flex;
}
.form-grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:16px;
}
.full{grid-column:1/-1}
label{
    font-weight:900;
    color:#064e3b;
    margin-bottom:6px;
}
.form-control,.form-select{
    border-radius:14px;
    padding:12px 14px;
}
@media(max-width:900px){
    .grid{grid-template-columns:1fr}
    .form-grid{grid-template-columns:1fr}
    .full{grid-column:auto}
    .top{flex-direction:column;align-items:flex-start;gap:14px}
}
</style>
</head>

<body>
<div class="page">
    <div class="wrap">

        <div class="top">
            <a class="brand" href="${pageContext.request.contextPath}/cliente/dashboard">
                <span class="brand-icon"><i class="ti ti-paw"></i></span>
                <span>
                    <span class="fs-2">CliniPet</span><br>
                    <small>Agendar cita</small>
                </span>
            </a>

            <div class="d-flex gap-2 flex-wrap">
                <a href="${pageContext.request.contextPath}/cliente/dashboard" class="btnx btn-soft">
                    <i class="ti ti-arrow-left"></i> Volver
                </a>

                <a href="${pageContext.request.contextPath}/logout" class="btnx btn-green">
                    <i class="ti ti-logout"></i> Cerrar sesión
                </a>
            </div>
        </div>

        <% if(request.getParameter("error") != null){ %>
        <div class="alert alert-danger rounded-4 fw-bold">
            <%= request.getParameter("error") %>
        </div>
        <% } %>

        <div class="grid">

            <div class="cardx">
                <div class="card-head">
                    <h2><i class="ti ti-paw"></i> Mis mascotas</h2>
                </div>

                <div class="card-body">
                    <% for(Map<String,Object> m : mascotas){ %>
                    <div class="pet-card">
                        <strong><%= m.get("nombre") %></strong><br>
                        <span class="text-secondary">
                            <%= m.get("especie") %> · <%= m.get("raza") %>
                        </span><br>
                        <span class="badge-soft mt-2"><%= m.get("alerta") %></span>
                        <div style="margin-top:12px;display:flex;gap:10px;flex-wrap:wrap">
                            <a href="${pageContext.request.contextPath}/cliente/mascota/editar?id=<%= m.get("id") %>" class="btnx btn-soft">
                                <i class="ti ti-edit"></i> Editar
                            </a>
                            <a href="${pageContext.request.contextPath}/cliente/mascota/eliminar?id=<%= m.get("id") %>" class="btnx" style="background:#ef4444;color:white">
                                <i class="ti ti-trash"></i> Eliminar
                            </a>
                        </div>
                    </div>
                    <% } %>

                    <% if(mascotas.isEmpty()){ %>
                    <div class="text-center p-3">
                        <i class="ti ti-paw-off fs-1 text-success"></i>
                        <h3>No tienes mascotas registradas</h3>
                        <p class="text-secondary">
                            Tu mascota debe estar vinculada a tu usuario para agendar cita.
                        </p>
                    </div>
                    <% } %>
                </div>
            </div>

            <div class="cardx">
                <div class="card-head">
                    <h1><i class="ti ti-calendar-plus"></i> Formulario de cita</h1>
                    <p class="mb-0 opacity-75">Selecciona una mascota y agenda tu cita.</p>
                </div>

                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/citas/guardar">
                        <div class="form-grid">

                            <div class="full">
                                <label>Mascota</label>
                                <select name="id_mascota" class="form-select" required>
                                    <option value="">Selecciona tu mascota</option>
                                    <% for(Map<String,Object> m : mascotas){ %>
                                    <option value="<%= m.get("id") %>">
                                        <%= m.get("nombre") %> - <%= m.get("especie") %>
                                    </option>
                                    <% } %>
                                </select>

                                <div class="mt-3 p-3" style="background:#f7fffb;border-radius:16px;border:1px solid #dbeee5">
                                    <strong>Veterinarios disponibles:</strong><br><br>
                                    <% for(Map<String,Object> v : veterinarios){ %>
                                        <div class="mb-2">
                                            <i class="ti ti-stethoscope text-success"></i>
                                            <strong><%= v.get("nombre") %></strong>
                                            - Disponible
                                        </div>
                                    <% } %>
                                </div>
                            </div>

                            <div class="full">
                                <label>Veterinario</label>
                                <select name="id_veterinario" class="form-select" required>
                                    <option value="">Selecciona veterinario</option>
                                    <% for(Map<String,Object> v : veterinarios){ %>
                                    <option value="<%= v.get("id") %>">
                                        <%= v.get("nombre") %> - <%= v.get("especialidad") %> (<%= v.get("estado") %>)
                                    </option>
                                    <% } %>
                                </select>
                            </div>

                            <div>
                                <label>Fecha</label>
                                <input type="date" name="fecha" class="form-control" required id="fechaCita">
                            </div>

                            <div>
                                <label>Hora</label>
                                <input type="time" name="hora" class="form-control" required id="horaCita">
                            </div>

                            <div class="full">
                                <label>Motivo</label>
                                <textarea name="motivo" class="form-control" rows="4" required
                                          placeholder="Ej: Consulta general, vacunación, control médico..."></textarea>
                            </div>

                            <div class="full d-flex justify-content-end gap-2">
                                <a href="${pageContext.request.contextPath}/cliente/dashboard" class="btnx btn-soft">
                                    Cancelar
                                </a>

                                <button class="btnx btn-green" <%= mascotas.isEmpty() ? "disabled" : "" %>>
                                    <i class="ti ti-calendar-check"></i> Guardar cita
                                </button>
                            </div>

                        </div>
                    </form>
                </div>
            </div>

        </div>

    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/animations.js"></script>
<script>
(function(){
  var now = new Date();
  var yyyy = now.getFullYear();
  var mm   = String(now.getMonth()+1).padStart(2,'0');
  var dd   = String(now.getDate()).padStart(2,'0');
  var hh   = String(now.getHours()).padStart(2,'0');
  var mi   = String(now.getMinutes()).padStart(2,'0');
  var todayStr = yyyy+'-'+mm+'-'+dd;
  var nowTime  = hh+':'+mi;

  var fechaInput = document.getElementById('fechaCita');
  var horaInput  = document.getElementById('horaCita');
  if(fechaInput) fechaInput.min = todayStr;

  if(fechaInput && horaInput){
    fechaInput.addEventListener('change', function(){
      if(this.value === todayStr){
        horaInput.min = nowTime;
        if(horaInput.value && horaInput.value < nowTime) horaInput.value = '';
      } else {
        horaInput.min = '';
      }
    });
  }
})();
</script>