<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.clinipet.model.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
%>
<!doctype html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Panel recepcionista | CliniPet</title>

<link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800;900&family=Fredoka:wght@500;600;700&display=swap" rel="stylesheet">
<style>
:root{--green:#00c875;--green2:#00f5a0;--dark:#003d25;--text:#0f172a;--muted:#64748b;--line:#dbeee5;--shadow:0 24px 70px rgba(0,80,50,.12)}
*{box-sizing:border-box}body{margin:0;font-family:"Nunito",sans-serif;color:var(--text);background:radial-gradient(circle at 15% 5%,rgba(0,200,117,.13),transparent 28%),linear-gradient(135deg,#f8fffb,#eafff4);overflow-x:hidden}
h1,h2,h3,h4,h5,.brand-title,.title-main{font-family:"Fredoka",sans-serif}
.layout{display:flex;min-height:100vh}.side{width:295px;min-height:100vh;position:fixed;left:0;top:0;color:white;padding:28px 22px;z-index:1000;background:linear-gradient(180deg,#003d25,#007f4f);box-shadow:18px 0 55px rgba(0,61,37,.16)}
.brand{display:flex;align-items:center;gap:12px;margin-bottom:24px}.brand-icon{width:58px;height:58px;border-radius:20px;background:white;color:var(--green);display:grid;place-items:center;font-size:2rem}.brand-title{font-size:2rem;font-weight:700;margin:0;color:white}
.user-card{background:rgba(255,255,255,.13);border:1px solid rgba(255,255,255,.18);border-radius:24px;padding:18px;margin-bottom:22px}
.navx a{display:flex;align-items:center;gap:12px;color:#eafff4;text-decoration:none;padding:15px 18px;border-radius:20px;margin-top:8px;font-weight:900;transition:.25s}.navx a:hover,.navx .active{background:rgba(255,255,255,.17);transform:translateX(4px)}
.main{margin-left:295px;width:calc(100% - 295px);padding:34px}.topbar{display:flex;justify-content:space-between;align-items:center;gap:20px;margin-bottom:26px;flex-wrap:wrap}.title-main{margin:0;color:#063823;font-weight:700;font-size:2.4rem}.subtitle{margin:8px 0 0;color:var(--muted);font-weight:700}
.btn-green,.btn-soft,.btn-danger-soft,.btn-warning-soft,.btn-info-soft{border:0;border-radius:18px;padding:12px 17px;font-weight:900;text-decoration:none;transition:.25s;display:inline-flex;align-items:center;gap:8px}.btn-green{background:linear-gradient(135deg,var(--green),var(--green2));color:#003d25;box-shadow:0 16px 38px rgba(0,200,117,.24)}.btn-soft{background:white;color:#063823;box-shadow:0 12px 28px rgba(0,80,50,.08)}.btn-danger-soft{background:#fff1f2;color:#be123c}.btn-warning-soft{background:#fff7ed;color:#c2410c}.btn-info-soft{background:#ecfeff;color:#0369a1}
.stats{display:grid;grid-template-columns:repeat(4,1fr);gap:18px;margin-bottom:24px}.stat-card{background:rgba(255,255,255,.92);border-radius:30px;padding:24px;box-shadow:var(--shadow);min-height:145px}.stat-card i{font-size:2rem;color:var(--green)}.stat-card h2{margin:10px 0 4px;font-size:2.05rem;font-weight:800;color:#0f172a}.stat-card span{color:var(--muted);font-weight:800}
.grid-2{display:grid;grid-template-columns:1.15fr .85fr;gap:24px;margin-bottom:24px}.panel{background:rgba(255,255,255,.94);border-radius:30px;box-shadow:var(--shadow);overflow:hidden;margin-bottom:24px}.panel-head{padding:22px 24px;border-bottom:1px solid var(--line);display:flex;align-items:center;justify-content:space-between;gap:14px;flex-wrap:wrap}.panel-title{display:flex;align-items:center;gap:10px;margin:0;font-weight:700}.panel-title i{color:var(--green)}.panel-body{padding:24px}
.search-input{width:100%;border:1px solid var(--line);border-radius:18px;padding:14px 17px;font-weight:800;outline:none}.table-card{overflow:hidden;border-radius:26px;border:1px solid var(--line);background:white}.table{margin:0}.table thead th{color:#047857;font-size:.8rem;text-transform:uppercase;background:#f8fffb}.table tbody td{vertical-align:middle;font-weight:750}
.badge-soft{background:#dcfff0;color:#007f4f;border-radius:999px;padding:7px 13px;font-weight:900;display:inline-flex;align-items:center;gap:5px}.badge-danger{background:#ffe4e6;color:#be123c}.badge-warning{background:#ffedd5;color:#c2410c}.badge-info{background:#e0f2fe;color:#0369a1}
.actions{display:flex;gap:8px;align-items:center;flex-wrap:wrap}.icon-btn{width:39px;height:39px;border-radius:13px;border:0;display:grid;place-items:center;color:#064e3b;background:#eafff4;transition:.2s;text-decoration:none}.icon-btn.delete{background:#fff1f2;color:#be123c}.icon-btn.edit{background:#ecfeff;color:#0369a1}.icon-btn.ok{background:#dcfff0;color:#007f4f}
.sales-chart{height:250px;display:flex;align-items:end;gap:16px;padding-top:24px}.bar-wrap{flex:1;display:flex;flex-direction:column;align-items:center;gap:10px}.bar{width:100%;min-height:22px;border-radius:999px 999px 12px 12px;background:linear-gradient(180deg,var(--green2),var(--green));box-shadow:0 12px 24px rgba(0,200,117,.22)}.bar-label{color:var(--muted);font-weight:900;font-size:.82rem}
.alert-card{border-radius:24px;padding:18px;border:1px solid var(--line);background:#fff}.alert-card.warning{background:#fff7ed;border-color:#fed7aa}.alert-card.danger{background:#fff1f2;border-color:#fecdd3}.alert-card.ok{background:#f0fdf4;border-color:#bbf7d0}
@media(max-width:1250px){.stats{grid-template-columns:repeat(2,1fr)}.grid-2{grid-template-columns:1fr}}@media(max-width:900px){.layout{display:block}.side{position:relative;width:100%;min-height:auto}.main{margin-left:0;width:100%;padding:22px}}@media(max-width:620px){.stats{grid-template-columns:1fr}}
</style>

<style>
/* ══════════════════════════════════════════════════
   CLINIPET ANIMATIONS v3 — Modo Oscuro + Efectos WOW
══════════════════════════════════════════════════ */

/* ── CANVAS PARTÍCULAS ── */
#cp-anim-canvas{
  position:fixed;inset:0;width:100%;height:100%;
  pointer-events:none;z-index:0;
}

/* ── KEYFRAMES ── */
@keyframes cpSlideUp{from{opacity:0;transform:translateY(40px)}to{opacity:1;transform:translateY(0)}}
@keyframes cpSlideLeft{from{opacity:0;transform:translateX(-40px)}to{opacity:1;transform:translateX(0)}}
@keyframes cpSlideRight{from{opacity:0;transform:translateX(40px)}to{opacity:1;transform:translateX(0)}}
@keyframes cpZoomBounce{from{opacity:0;transform:scale(.6)}to{opacity:1;transform:scale(1)}}
@keyframes cpFadeIn{from{opacity:0}to{opacity:1}}
@keyframes cpPulseGreen{0%,100%{box-shadow:0 0 0 0 rgba(0,200,117,.4)}70%{box-shadow:0 0 0 18px rgba(0,200,117,0)}}
@keyframes cpPulsePurple{0%,100%{box-shadow:0 0 0 0 rgba(124,92,255,.4)}70%{box-shadow:0 0 0 18px rgba(124,92,255,0)}}
@keyframes cpSparkDraw{from{stroke-dashoffset:700}to{stroke-dashoffset:0}}
@keyframes cpModalIn{from{opacity:0;transform:scale(.85) translateY(30px)}to{opacity:1;transform:scale(1) translateY(0)}}
@keyframes cpShimmerSlide{0%{background-position:-400px 0}100%{background-position:400px 0}}
@keyframes cpFloatUp{0%,100%{transform:translateY(0)}50%{transform:translateY(-8px)}}
@keyframes cpRotateSlow{from{transform:rotate(0deg)}to{transform:rotate(360deg)}}
@keyframes cpGlowPulse{0%,100%{text-shadow:0 0 8px rgba(0,200,117,.0)}50%{text-shadow:0 0 22px rgba(0,200,117,.7),0 0 40px rgba(0,200,117,.3)}}
@keyframes cpRipple{0%{transform:scale(0);opacity:.7}100%{transform:scale(4);opacity:0}}
@keyframes cpBounceIn{0%{opacity:0;transform:scale(.3)}50%{transform:scale(1.08)}70%{transform:scale(.95)}100%{opacity:1;transform:scale(1)}}
@keyframes cpWobble{0%,100%{transform:rotate(0deg)}15%{transform:rotate(-8deg)}30%{transform:rotate(6deg)}45%{transform:rotate(-5deg)}60%{transform:rotate(3deg)}75%{transform:rotate(-2deg)}}
@keyframes cpTypewriter{from{width:0}to{width:100%}}
@keyframes cpBlinkCursor{0%,100%{border-right-color:var(--green)}50%{border-right-color:transparent}}
@keyframes cpCounterFlip{0%{transform:rotateX(90deg);opacity:0}100%{transform:rotateX(0deg);opacity:1}}
@keyframes cpNeonFlicker{0%,19%,21%,23%,25%,54%,56%,100%{opacity:1}20%,24%,55%{opacity:.4}}
@keyframes cpSlideInFromBottom{from{opacity:0;transform:translateY(60px) scale(.95)}to{opacity:1;transform:translateY(0) scale(1)}}
@keyframes cpPawPrint{0%{opacity:0;transform:scale(0) rotate(-20deg)}50%{opacity:1;transform:scale(1.2) rotate(5deg)}100%{opacity:.9;transform:scale(1) rotate(0)}}

/* ── SIDEBAR ENTRANCE ── */
.sidebar{animation:cpSlideLeft .6s cubic-bezier(.22,1,.36,1) both}
.brand{animation:cpSlideLeft .55s .1s cubic-bezier(.22,1,.36,1) both}
.brand-icon{
  transition:transform .35s cubic-bezier(.34,1.56,.64,1),box-shadow .35s!important;
  animation:cpBounceIn .7s .2s both;
}
.brand:hover .brand-icon{
  transform:rotate(-12deg) scale(1.12)!important;
  box-shadow:0 0 40px rgba(0,217,120,.55),0 20px 40px rgba(0,0,0,.25)!important;
  animation:cpWobble .6s ease!important;
}

/* Nav links stagger + shimmer */
.nav-menu a{
  opacity:0;
  animation:cpSlideLeft .45s cubic-bezier(.22,1,.36,1) both;
  position:relative;overflow:hidden;
}
.nav-menu a:nth-child(1){animation-delay:.18s}
.nav-menu a:nth-child(2){animation-delay:.24s}
.nav-menu a:nth-child(3){animation-delay:.30s}
.nav-menu a:nth-child(4){animation-delay:.36s}
.nav-menu a:nth-child(5){animation-delay:.42s}
.nav-menu a:nth-child(6){animation-delay:.48s}
.nav-menu a::before{
  content:'';position:absolute;inset:0;
  background:linear-gradient(90deg,transparent 0%,rgba(255,255,255,.18) 50%,transparent 100%);
  transform:translateX(-100%);transition:transform .55s;
}
.nav-menu a:hover::before{transform:translateX(100%)}

/* ── TOPBAR ── */
.topbar{animation:cpFadeIn .5s .05s ease both}
.page-title{
  animation:cpSlideLeft .55s .1s cubic-bezier(.22,1,.36,1) both;
}
.page-title i{animation:cpGlowPulse 2.5s 1.5s ease-in-out infinite}

/* ── QUICK BUTTONS ── */
.quick-btn{
  opacity:0;
  animation:cpBounceIn .5s cubic-bezier(.34,1.56,.64,1) both;
  position:relative;overflow:hidden;
}
.quick-btn:nth-child(1){animation-delay:.3s}
.quick-btn:nth-child(2){animation-delay:.38s}
.quick-btn:nth-child(3){animation-delay:.46s}
.quick-btn:nth-child(4){animation-delay:.54s}
.quick-btn:nth-child(5){animation-delay:.62s}
.quick-btn::after{
  content:'';position:absolute;
  width:10px;height:10px;border-radius:50%;
  background:rgba(255,255,255,.5);
  top:50%;left:50%;transform:translate(-50%,-50%) scale(0);
  pointer-events:none;
}
.quick-btn:active::after{animation:cpRipple .5s ease-out}
.quick-btn:hover{
  transform:translateY(-5px) scale(1.05)!important;
  box-shadow:0 22px 40px rgba(0,0,0,.22)!important;
}

/* ── STAT CARDS ── */
.stat-card{
  opacity:0;
  animation:cpSlideInFromBottom .6s cubic-bezier(.22,1,.36,1) both;
  position:relative;overflow:hidden;
}
.stats .stat-card:nth-child(1){animation-delay:.28s}
.stats .stat-card:nth-child(2){animation-delay:.38s}
.stats .stat-card:nth-child(3){animation-delay:.48s}
.stats .stat-card:nth-child(4){animation-delay:.58s}
/* shimmer overlay on load */
.stat-card::before{
  content:'';position:absolute;inset:0;
  background:linear-gradient(105deg,transparent 40%,rgba(255,255,255,.55) 50%,transparent 60%);
  background-size:200% 100%;
  animation:cpShimmerSlide .9s ease-in-out forwards;
  pointer-events:none;z-index:2;
}
.stat-card h2{animation:cpCounterFlip .5s .6s both}
.stat-card:hover{
  transform:translateY(-8px) scale(1.015)!important;
  box-shadow:0 32px 70px rgba(0,60,35,.18)!important;
}
.stat-icon.green{animation:cpPulseGreen 2.5s 1.2s infinite}
.stat-icon.purple{animation:cpPulsePurple 2.5s 1.4s infinite}
.stat-icon{
  transition:transform .3s cubic-bezier(.34,1.56,.64,1)!important;
}
.stat-card:hover .stat-icon{transform:scale(1.15) rotate(-8deg)!important}

/* ── SPARK SVG ── */
.spark path[stroke]{
  stroke-dasharray:700;stroke-dashoffset:700;
  animation:cpSparkDraw 1.4s .8s cubic-bezier(.22,1,.36,1) forwards;
}

/* ── PANELS ── */
.panel{
  opacity:0;
  animation:cpSlideUp .6s cubic-bezier(.22,1,.36,1) both;
  transition:transform .3s,box-shadow .3s;
}
.grid-2 .panel:nth-child(1){animation-delay:.5s}
.grid-2 .panel:nth-child(2){animation-delay:.62s}
.grid-2.bottom .panel:nth-child(1){animation-delay:.68s}
.grid-2.bottom .panel:nth-child(2){animation-delay:.76s}
.panel:hover{
  transform:translateY(-4px)!important;
  box-shadow:0 30px 72px rgba(0,60,35,.16)!important;
}

/* ── TABLA ROWS ── */
.table tbody tr{
  opacity:0;
  animation:cpSlideLeft .4s cubic-bezier(.22,1,.36,1) both;
  transition:background .25s,transform .2s;
}
.table tbody tr:hover{
  background:rgba(0,200,117,.06)!important;
  transform:translateX(4px);
}

/* ── ALERT ITEMS ── */
.alert-item{
  opacity:0;
  animation:cpSlideRight .45s cubic-bezier(.22,1,.36,1) both;
  transition:transform .22s,box-shadow .22s!important;
  position:relative;overflow:hidden;
}
.alert-item:nth-child(1){animation-delay:.55s}
.alert-item:nth-child(2){animation-delay:.65s}
.alert-item:nth-child(3){animation-delay:.75s}
.alert-item:hover{
  transform:translateX(8px) scale(1.01)!important;
  box-shadow:0 14px 36px rgba(0,0,0,.12)!important;
}
.alert-icon{transition:transform .3s cubic-bezier(.34,1.56,.64,1)!important}
.alert-item:hover .alert-icon{transform:scale(1.2) rotate(-10deg)!important}

/* ── BADGES ── */
.badge-pendiente{animation:cpPulseGreen 2s 1s infinite}
.badge-bajo{animation:cpPulsePurple 2s 1s infinite}

/* ── MODAL ── */
.modalx.show .modal-cardx{animation:cpModalIn .38s cubic-bezier(.34,1.15,.64,1) both}
.modal-close{transition:transform .2s,background .2s!important}
.modal-close:hover{transform:rotate(90deg) scale(1.1)!important;background:rgba(255,255,255,.25)!important}

/* ── ICON BUTTONS ── */
.icon-btn{
  transition:transform .22s cubic-bezier(.34,1.56,.64,1),box-shadow .22s!important;
  position:relative;overflow:hidden;
}
.icon-btn:hover{
  transform:scale(1.22) rotate(-6deg)!important;
  box-shadow:0 10px 24px rgba(0,0,0,.22)!important;
}
.icon-btn::after{
  content:'';position:absolute;inset:0;border-radius:inherit;
  background:rgba(255,255,255,.3);transform:scale(0);
  transition:transform .3s;
}
.icon-btn:active::after{transform:scale(2);opacity:0;transition:transform .4s,opacity .4s}

/* ── INPUTS ── */
.form-control,.form-select,.search-box{
  transition:border-color .25s,box-shadow .25s,transform .2s!important;
}
.form-control:focus,.form-select:focus,.search-box:focus{
  border-color:#00a85a!important;
  box-shadow:0 0 0 4px rgba(0,200,117,.18),0 4px 12px rgba(0,0,0,.08)!important;
  transform:translateY(-1px);
}

/* ── BUTTONS ── */
.view-btn{transition:transform .2s,box-shadow .2s!important}
.view-btn:hover{transform:translateY(-3px)!important;box-shadow:0 12px 28px rgba(0,168,90,.28)!important}
.logout-top{transition:transform .2s,box-shadow .2s!important}
.logout-top:hover{transform:translateY(-3px)!important;box-shadow:0 16px 32px rgba(239,68,68,.32)!important}
.btn-save{transition:transform .2s,box-shadow .2s!important}
.btn-save:hover{transform:translateY(-2px)!important;box-shadow:0 12px 26px rgba(0,168,90,.28)!important}

/* ── TOAST ── */
.toastx.show{animation:cpBounceIn .4s cubic-bezier(.34,1.56,.64,1) both}

/* ── NOTIFICATION BADGE ── */
.notification>span{animation:cpPulseGreen 1.6s infinite}
</style>


<script>!function(){var t=localStorage.getItem("clinipetTheme")||"light";var m={"dark":["theme-dark","dark-mode"],"neon":["theme-neon","neon-mode"]};if(m[t])m[t].forEach(function(c){document.documentElement.classList.add(c)});}();</script><script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</head>

<body>
<div class="layout">
    <aside class="side">
        <div class="brand"><div class="brand-icon"><i class="ti ti-paw"></i></div><div><h2 class="brand-title">CliniPet</h2><small>Recepcionista</small></div></div>
        <a href="${pageContext.request.contextPath}/perfil" class="user-card" style="text-decoration:none;color:inherit;display:flex;align-items:center;gap:10px">
            <% if (usuario != null && usuario.getAvatarUrlOrNull() != null) { %>
                <img src="${pageContext.request.contextPath}<%= usuario.getAvatarUrlOrNull() %>" alt="avatar" style="width:42px;height:42px;border-radius:50%;object-fit:cover"/>
            <% } else { %>
                <i class="ti ti-user-circle" style="font-size:1.8rem"></i>
            <% } %>
            <span><strong><%= usuario != null ? usuario.getNombre() : "Recepcionista" %></strong><br><span class="opacity-75"><%= usuario != null ? usuario.getRol() : "Recepcionista" %></span></span>
        </a>
        <nav class="navx">
            <a class="" href="${pageContext.request.contextPath}/dashboard"><i class="ti ti-layout-dashboard"></i> Admin</a>
            <a class="active" href="${pageContext.request.contextPath}/recepcionista/dashboard"><i class="ti ti-calendar-heart"></i> Recepción</a>
            <a href="${pageContext.request.contextPath}/perfil"><i class="ti ti-user-cog"></i> Mi perfil</a>
            <a href="${pageContext.request.contextPath}/"><i class="ti ti-home"></i> Inicio</a>
            <a href="${pageContext.request.contextPath}/logout"><i class="ti ti-logout"></i> Cerrar sesión</a>
        </nav>
    </aside>
    <main class="main">

<%
    List<Map<String,Object>> citasPendientes = (List<Map<String,Object>>) request.getAttribute("citasPendientes");
    List<Map<String,Object>> todasCitas = (List<Map<String,Object>>) request.getAttribute("todasCitas");
    List<Map<String,Object>> doctores = (List<Map<String,Object>>) request.getAttribute("doctores");
    if(citasPendientes==null)citasPendientes=new ArrayList<>();
    if(todasCitas==null)todasCitas=new ArrayList<>();
    if(doctores==null)doctores=new ArrayList<>();
%>
<div class="topbar"><div><h1 class="title-main">Panel de recepcionista</h1><p class="subtitle">Solo citas pendientes, alertas de mascotas con cita y disponibilidad de doctores.</p></div><div style="display:flex;gap:10px;flex-wrap:wrap"><a href="${pageContext.request.contextPath}/recepcionista/dashboard" class="btn-soft"><i class="ti ti-layout-dashboard"></i> Mi panel</a><a href="${pageContext.request.contextPath}/citas/nueva" class="btn-green"><i class="ti ti-calendar-plus"></i> Agendar cita</a><a href="${pageContext.request.contextPath}/logout" style="border:0;border-radius:18px;padding:12px 17px;font-weight:900;background:#fff1f2;color:#be123c;text-decoration:none;display:inline-flex;align-items:center;gap:8px"><i class="ti ti-logout"></i> Cerrar sesión</a></div></div>
<div class="stats"><div class="stat-card"><i class="ti ti-calendar-heart"></i><h2><%= citasPendientes.size() %></h2><span>Citas pendientes</span></div><div class="stat-card"><i class="ti ti-stethoscope"></i><h2><%= doctores.size() %></h2><span>Doctores</span></div><div class="stat-card"><i class="ti ti-alert-triangle"></i><h2>!</h2><span>Validar mascota con cita</span></div><div class="stat-card"><i class="ti ti-cash"></i><h2>$</h2><span>Asignar precio</span></div></div>
<div class="grid-2">
<section class="panel"><div class="panel-head"><h3 class="panel-title"><i class="ti ti-calendar-exclamation"></i> Citas pendientes</h3><input class="search-input table-search" data-target="tablaPendientes" placeholder="Buscar cita..." style="width:330px;max-width:100%"></div><div class="table-card table-responsive"><table class="table card-table" id="tablaPendientes"><thead><tr><th>Dueño</th><th>Mascota</th><th>Fecha</th><th>Motivo</th><th>Doctor</th><th>Precio</th><th>Acción</th></tr></thead><tbody>
<%
    for(Map<String,Object> c : citasPendientes){
        String cId     = String.valueOf(c.get("id"));
        String cDuenio = String.valueOf(c.get("duenio"));
        String cMasc   = String.valueOf(c.get("mascota"));
        String cFecha  = String.valueOf(c.get("fecha"));
        String cHora   = c.get("hora") != null ? String.valueOf(c.get("hora")) : "";
        String cMotivo = c.get("motivo") != null ? String.valueOf(c.get("motivo")) : "";
        String cDoctor = c.get("doctor") != null ? String.valueOf(c.get("doctor")) : "Sin asignar";
        String cPrecio = c.get("precio") != null ? String.valueOf(c.get("precio")) : "0";
        // Escapar comillas simples en motivo para el onclick
        String cMotivoJs = cMotivo.replace("'", "\\'");
%>
<tr>
  <td><%= cDuenio %></td>
  <td><strong><%= cMasc %></strong></td>
  <td><%= cFecha %> <span class="text-secondary"><%= cHora %></span></td>
  <td><%= cMotivo %></td>
  <td><%= cDoctor %></td>
  <td>$<%= cPrecio %></td>
  <td>
    <div class="actions">
      <form method="post" action="${pageContext.request.contextPath}/recepcionista/dashboard" style="display:inline">
        <input type="hidden" name="id" value="<%= cId %>">
        <input type="hidden" name="accion" value="CONFIRMAR">
        <button type="submit" class="icon-btn ok" title="Confirmar cita"><i class="ti ti-check"></i></button>
      </form>
      <form method="post" action="${pageContext.request.contextPath}/recepcionista/dashboard" style="display:inline">
        <input type="hidden" name="id" value="<%= cId %>">
        <input type="hidden" name="accion" value="CANCELAR">
        <button type="submit" class="icon-btn delete" title="Cancelar cita" onclick="return confirm('¿Cancelar esta cita?')"><i class="ti ti-x"></i></button>
      </form>
      <button class="icon-btn edit" title="Editar cita"
        onclick="abrirEditar('<%= cId %>','<%= cFecha %>','<%= cHora %>','<%= cMotivoJs %>','<%= cPrecio %>')">
        <i class="ti ti-edit"></i>
      </button>
    </div>
  </td>
</tr>
<% } if(citasPendientes.isEmpty()){ %><tr><td colspan="8" class="text-center text-secondary p-4">No hay citas pendientes.</td></tr><% } %>
</tbody></table></div></section>
<section class="panel"><div class="panel-head"><h3 class="panel-title"><i class="ti ti-user-check"></i> Doctores disponibles/ocupados</h3></div><div class="panel-body d-grid gap-3">
<% for(Map<String,Object> d:doctores){ %><div class="alert-card <%= "DISPONIBLE".equalsIgnoreCase(String.valueOf(d.get("estado"))) ? "ok" : "warning" %>"><strong><%= d.get("nombre") %></strong><br><span class="text-secondary"><%= d.get("especialidad") %> · <%= d.get("estado") %></span></div><% } if(doctores.isEmpty()){ %><div class="text-secondary fw-bold">No hay doctores cargados.</div><% } %>
</div></section></div>

<!-- ══════════════════════════════════════
     TODAS LAS CITAS — con acciones
══════════════════════════════════════ -->
<section class="panel" style="margin-top:8px">
  <div class="panel-head">
    <h3 class="panel-title"><i class="ti ti-list-check"></i> Todas las citas</h3>
    <input class="search-input table-search" data-target="tablaTodasCitas" placeholder="Buscar..." style="width:280px;max-width:100%">
  </div>
  <div class="table-card table-responsive">
    <table class="table card-table" id="tablaTodasCitas">
      <thead>
        <tr>
          <th>#</th><th>Dueño</th><th>Mascota</th><th>Fecha / Hora</th>
          <th>Doctor</th><th>Precio</th><th>Estado</th><th>Acciones</th>
        </tr>
      </thead>
      <tbody>
<%
  for(Map<String,Object> c : todasCitas){
    String tId     = String.valueOf(c.get("id"));
    String tDuenio = String.valueOf(c.get("duenio"));
    String tMasc   = String.valueOf(c.get("mascota"));
    String tFecha  = String.valueOf(c.get("fecha"));
    String tHora   = c.get("hora") != null ? String.valueOf(c.get("hora")) : "";
    String tDoc    = c.get("doctor") != null ? String.valueOf(c.get("doctor")) : "Sin asignar";
    String tPrecio = c.get("precio") != null ? String.valueOf(c.get("precio")) : "0";
    String tEst    = c.get("estado") != null ? String.valueOf(c.get("estado")).toUpperCase() : "PENDIENTE";
    String badgeClass = "PENDIENTE".equals(tEst) ? "badge-warning"
                      : "CONFIRMADA".equals(tEst) ? "badge-info"
                      : "COMPLETADA".equals(tEst) ? "badge-soft"
                      : "CANCELADA".equals(tEst) ? "badge-danger" : "badge-soft";
%>
        <tr>
          <td><%= tId %></td>
          <td><%= tDuenio %></td>
          <td><strong><%= tMasc %></strong></td>
          <td><%= tFecha %> <span class="text-secondary"><%= tHora %></span></td>
          <td><%= tDoc %></td>
          <td>$<%= tPrecio %></td>
          <td><span class="badge-soft <%= badgeClass %>"><%= tEst %></span></td>
          <td>
            <div class="actions">
              <% if(!"CONFIRMADA".equals(tEst) && !"COMPLETADA".equals(tEst) && !"CANCELADA".equals(tEst)){ %>
              <form method="post" action="${pageContext.request.contextPath}/recepcionista/dashboard" style="display:inline">
                <input type="hidden" name="id" value="<%= tId %>">
                <input type="hidden" name="accion" value="CONFIRMAR">
                <button type="submit" class="icon-btn ok" title="Confirmar"><i class="ti ti-check"></i></button>
              </form>
              <% } %>
              <% if(!"COMPLETADA".equals(tEst) && !"CANCELADA".equals(tEst)){ %>
              <form method="post" action="${pageContext.request.contextPath}/recepcionista/dashboard" style="display:inline">
                <input type="hidden" name="id" value="<%= tId %>">
                <input type="hidden" name="accion" value="COMPLETAR">
                <button type="submit" class="icon-btn" title="Marcar completada" style="background:#ecfeff;color:#0369a1"><i class="ti ti-calendar-check"></i></button>
              </form>
              <form method="post" action="${pageContext.request.contextPath}/recepcionista/dashboard" style="display:inline">
                <input type="hidden" name="id" value="<%= tId %>">
                <input type="hidden" name="accion" value="CANCELAR">
                <button type="submit" class="icon-btn delete" title="Cancelar" onclick="return confirm('¿Cancelar esta cita?')"><i class="ti ti-x"></i></button>
              </form>
              <% } %>
              <button class="icon-btn edit" title="Editar"
                onclick="abrirEditar('<%= tId %>','<%= tFecha %>','<%= tHora %>','','<%= tPrecio %>')">
                <i class="ti ti-edit"></i>
              </button>
            </div>
          </td>
        </tr>
<% } if(todasCitas.isEmpty()){ %>
        <tr><td colspan="8" class="text-center text-secondary p-4">No hay citas registradas.</td></tr>
<% } %>
      </tbody>
    </table>
  </div>
</section>

    </main>
</div>

<script>
document.querySelectorAll('.table-search').forEach(function(input){
    input.addEventListener('input', function(){
        const value = input.value.toLowerCase().trim();
        const table = document.getElementById(input.dataset.target);
        if(!table) return;
        table.querySelectorAll('tbody tr').forEach(function(row){
            row.style.display = row.innerText.toLowerCase().includes(value) ? '' : 'none';
        });
    });
});

function abrirEditar(id, fecha, hora, motivo, precio){
    document.getElementById('editId').value = id;
    document.getElementById('editFecha').value = fecha;
    document.getElementById('editHora').value = hora;
    document.getElementById('editMotivo').value = motivo;
    document.getElementById('editPrecio').value = precio;
    document.getElementById('editModal').style.display='flex';
}
function cerrarEditar(){
    document.getElementById('editModal').style.display='none';
}
</script>

<!-- MODAL EDITAR CITA -->
<div id="editModal" style="display:none;position:fixed;inset:0;background:rgba(0,40,20,.5);z-index:9999;align-items:center;justify-content:center">
    <div style="background:white;border-radius:28px;padding:34px;max-width:520px;width:90%;box-shadow:0 30px 80px rgba(0,60,35,.2)">
        <h2 style="font-family:'Fredoka',sans-serif;color:#003d25;margin:0 0 20px;display:flex;align-items:center;gap:10px">
            <i class="ti ti-edit" style="color:#0369a1"></i> Editar cita
        </h2>
        <form method="post" action="${pageContext.request.contextPath}/citas/editar">
            <input type="hidden" name="id" id="editId">
            <div style="display:grid;gap:14px">
                <div>
                    <label style="font-weight:800;display:block;margin-bottom:6px">Fecha</label>
                    <input type="date" name="fecha" id="editFecha" class="form-control" required
                           style="border-radius:14px;padding:12px;border:1px solid #dbeee5;width:100%">
                </div>
                <div>
                    <label style="font-weight:800;display:block;margin-bottom:6px">Hora</label>
                    <input type="time" name="hora" id="editHora" class="form-control"
                           style="border-radius:14px;padding:12px;border:1px solid #dbeee5;width:100%">
                </div>
                <div>
                    <label style="font-weight:800;display:block;margin-bottom:6px">Precio ($)</label>
                    <input type="number" name="precio" id="editPrecio" class="form-control" min="0"
                           style="border-radius:14px;padding:12px;border:1px solid #dbeee5;width:100%">
                </div>
                <div>
                    <label style="font-weight:800;display:block;margin-bottom:6px">Motivo</label>
                    <textarea name="motivo" id="editMotivo" rows="3"
                              style="border-radius:14px;padding:12px;border:1px solid #dbeee5;width:100%;font-family:inherit;resize:vertical"></textarea>
                </div>
                <div style="display:flex;gap:12px;margin-top:8px">
                    <button type="submit" style="flex:1;border:0;border-radius:16px;background:linear-gradient(135deg,#00c875,#00f5a0);color:#003d25;padding:13px;font-weight:900;cursor:pointer;font-size:1rem">
                        <i class="ti ti-check"></i> Guardar cambios
                    </button>
                    <button type="button" onclick="cerrarEditar()" style="flex:1;border:1px solid #ddd;border-radius:16px;background:white;color:#003d25;padding:13px;font-weight:900;cursor:pointer;font-size:1rem">
                        <i class="ti ti-x"></i> Cancelar
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
/* ══════════════════════════════════════════════════════
   CLINIPET DASHBOARD ANIMATIONS v3
   Partículas 3D · Counters · Tilt · Dark Mode Índigo
══════════════════════════════════════════════════════ */
(function(){

/* ── 1. CANVAS PARTICLES (3D depth layers) ── */
var canvas = document.createElement('canvas');
canvas.id = 'cp-anim-canvas';
document.body.insertBefore(canvas, document.body.firstChild);
var ctx = canvas.getContext('2d');
var W, H, layers = [], raf;
var EMOJIS = ['🐾','🐶','🐱','❤️','✨','🌿','🩺','💊','🐕','🐈'];
var COLORS_LIGHT = ['rgba(0,200,117,','rgba(0,245,160,','rgba(0,108,68,','rgba(160,255,210,'];
var COLORS_DARK  = ['rgba(99,102,241,','rgba(139,92,246,','rgba(167,139,250,','rgba(196,181,253,'];

function getColors(){ return document.body.classList.contains('dark-mode') ? COLORS_DARK : COLORS_LIGHT; }

function resize(){ W = canvas.width = window.innerWidth; H = canvas.height = window.innerHeight; }

function Particle(layer){ this.layer = layer; this.reset(true); }
Particle.prototype.reset = function(init){
  var depth = this.layer / 3;
  this.x = Math.random() * W;
  this.y = init ? Math.random() * H : H + 40;
  this.size = (4 + Math.random() * 14) * (0.5 + depth * 0.8);
  this.vy = (0.15 + Math.random() * 0.4) * (0.4 + depth * 0.8);
  this.vx = (Math.random() - .5) * 0.3;
  this.opacity = 0;
  this.maxOpacity = (0.03 + Math.random() * 0.07) * (0.3 + depth * 0.9);
  this.angle = Math.random() * Math.PI * 2;
  this.spin = (Math.random() - .5) * 0.012 * (1 + depth);
  this.wobble = Math.random() * Math.PI * 2;
  this.ws = 0.008 + Math.random() * 0.01;
  this.isEmoji = Math.random() < 0.2;
  this.emoji = EMOJIS[Math.floor(Math.random() * EMOJIS.length)];
  this.colorIdx = Math.floor(Math.random() * 4);
};
Particle.prototype.update = function(){
  this.wobble += this.ws;
  this.x += this.vx + Math.sin(this.wobble) * 0.28;
  this.y -= this.vy;
  this.angle += this.spin;
  if(this.opacity < this.maxOpacity) this.opacity += 0.0015;
  if(this.y < -50) this.reset();
};
Particle.prototype.draw = function(){
  var colors = getColors();
  ctx.save();
  ctx.translate(this.x, this.y);
  ctx.rotate(this.angle);
  ctx.globalAlpha = this.opacity;
  if(this.isEmoji){
    ctx.font = (this.size * 1.4) + 'px serif';
    ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
    ctx.fillText(this.emoji, 0, 0);
  } else {
    ctx.beginPath();
    ctx.arc(0, 0, this.size / 2, 0, Math.PI * 2);
    ctx.fillStyle = colors[this.colorIdx] + this.opacity + ')';
    ctx.fill();
    /* glow */
    ctx.shadowColor = colors[this.colorIdx] + '0.6)';
    ctx.shadowBlur = this.size * 1.5;
    ctx.fill();
    ctx.shadowBlur = 0;
  }
  ctx.restore();
};

function spawnAll(){
  layers = [];
  var n = Math.min(Math.floor(W / 18), 65);
  for(var i = 0; i < n; i++) layers.push(new Particle(Math.floor(Math.random() * 3) + 1));
}
function loop(){
  ctx.clearRect(0, 0, W, H);
  /* sort by layer for depth effect */
  layers.sort(function(a,b){return a.layer - b.layer});
  for(var i = 0; i < layers.length; i++){ layers[i].update(); layers[i].draw(); }
  if(layers.length < 70 && Math.random() < 0.04) layers.push(new Particle(Math.floor(Math.random()*3)+1));
  raf = requestAnimationFrame(loop);
}
resize(); spawnAll(); loop();
window.addEventListener('resize', function(){ resize(); spawnAll(); });
document.addEventListener('visibilitychange', function(){
  if(document.hidden) cancelAnimationFrame(raf); else loop();
});

/* ── 2. NUMBER COUNTER with flip effect ── */
function animateCounter(el){
  var raw = el.textContent.trim();
  var prefix = raw.charAt(0) === '$' ? '$' : '';
  var numStr = prefix ? raw.slice(1) : raw;
  var clean = numStr.replace(/[.,\s]/g,'');
  var target = parseFloat(clean);
  if(isNaN(target) || target === 0) return;
  var dur = 1400, start = null;
  function step(ts){
    if(!start) start = ts;
    var prog = Math.min((ts - start) / dur, 1);
    var ease = 1 - Math.pow(1 - prog, 4); /* easeOutQuart */
    var val = Math.floor(target * ease);
    el.textContent = prefix + val.toLocaleString('es-CO');
    if(prog < 1) requestAnimationFrame(step);
    else el.textContent = raw;
  }
  requestAnimationFrame(step);
}
document.querySelectorAll('.stat-card h2').forEach(function(el){
  var obs = new IntersectionObserver(function(e){
    if(!e[0].isIntersecting) return; obs.disconnect(); animateCounter(el);
  },{threshold:.5});
  obs.observe(el);
});

/* ── 3. 3D TILT on stat-cards ── */
document.querySelectorAll('.stat-card').forEach(function(card){
  card.addEventListener('mousemove', function(e){
    var r = card.getBoundingClientRect();
    var dx = (e.clientX - (r.left + r.width/2)) / (r.width/2);
    var dy = (e.clientY - (r.top  + r.height/2)) / (r.height/2);
    card.style.transform = 'perspective(700px) rotateY(' + (dx*7) + 'deg) rotateX(' + (-dy*7) + 'deg) translateY(-8px) scale(1.01)';
    card.style.transition = 'transform .06s ease';
    /* dynamic glow */
    card.style.boxShadow = '0 30px 70px rgba(0,60,35,' + (0.1 + Math.abs(dx)*0.12) + ')';
  });
  card.addEventListener('mouseleave', function(){
    card.style.transform = ''; card.style.boxShadow = '';
    card.style.transition = 'transform .45s cubic-bezier(.22,1,.36,1),box-shadow .45s';
  });
});

/* ── 4. TABLE ROW STAGGER (initial + on tab switch) ── */
function staggerRows(scope){
  var rows = (scope || document).querySelectorAll('.table tbody tr');
  rows.forEach(function(tr, i){
    tr.style.opacity = '';
    tr.style.animationDelay = (0.05 + i * 0.042) + 's';
  });
}
staggerRows();

var _origShowTab = window.showTab;
if(typeof _origShowTab === 'function'){
  window.showTab = function(tab){
    _origShowTab(tab);
    setTimeout(function(){
      var sec = document.getElementById('tab-' + tab);
      if(!sec) return;
      sec.querySelectorAll('.table tbody tr').forEach(function(tr, i){
        tr.style.animation = 'none';
        void tr.offsetHeight;
        tr.style.animation = '';
        tr.style.animationDelay = (0.04 + i * 0.038) + 's';
      });
    }, 40);
  };
}

/* ── 5. PANEL hover lift ── */
document.querySelectorAll('.panel').forEach(function(p){
  p.addEventListener('mouseenter', function(){
    p.style.transform = 'translateY(-5px)';
    p.style.boxShadow = '0 32px 75px rgba(0,60,35,.17)';
  });
  p.addEventListener('mouseleave', function(){
    p.style.transform = ''; p.style.boxShadow = '';
  });
});

/* ── 6. SEARCH — highlight rows + smooth filter ── */
document.querySelectorAll('.table-search').forEach(function(input){
  input.addEventListener('input', function(){
    var q = input.value.toLowerCase().trim();
    var tbl = document.getElementById(input.dataset.target);
    if(!tbl) return;
    tbl.querySelectorAll('tbody tr').forEach(function(row){
      var match = !q || row.innerText.toLowerCase().includes(q);
      row.style.display = match ? '' : 'none';
      row.style.background = (match && q) ? 'rgba(0,200,117,.07)' : '';
    });
  });
});

/* theme handled by dashboard.js */

/* ── 8. RIPPLE on quick-btns ── */
document.querySelectorAll('.quick-btn').forEach(function(btn){
  btn.addEventListener('click', function(e){
    var ripple = document.createElement('span');
    Object.assign(ripple.style, {
      position:'absolute', borderRadius:'50%',
      width:'10px', height:'10px',
      background:'rgba(255,255,255,.5)',
      top: (e.offsetY - 5) + 'px', left: (e.offsetX - 5) + 'px',
      pointerEvents:'none',
      animation:'cpRipple .55s ease-out forwards'
    });
    btn.appendChild(ripple);
    setTimeout(function(){ btn.removeChild(ripple); }, 600);
  });
});

/* ── 9. PAGE TRANSITION OVERLAY ── */
var overlay = document.createElement('div');
Object.assign(overlay.style, {
  position:'fixed', inset:'0', zIndex:'9999',
  opacity:'0', pointerEvents:'none',
  transition:'opacity .38s cubic-bezier(.4,0,.2,1)',
  display:'flex', alignItems:'center', justifyContent:'center',
  background:'linear-gradient(135deg,#0a0e1a,#1e1b4b)'
});
overlay.innerHTML = '<div style="display:flex;flex-direction:column;align-items:center;gap:12px;opacity:0;transition:opacity .25s .1s" id="cpOvContent">' +
  '<span style="font-size:3.5rem;animation:cpFloatUp 1s ease-in-out infinite">🐾</span>' +
  '<span style="font-family:\'Fredoka\',sans-serif;font-size:2.2rem;color:white;letter-spacing:.05em">CliniPet</span>' +
  '<div style="width:48px;height:3px;background:linear-gradient(90deg,#4f46e5,#818cf8);border-radius:3px;animation:cpShimmerSlide 1s linear infinite"></div>' +
  '</div>';
document.body.appendChild(overlay);

if(sessionStorage.getItem('cp-dash-t')){
  sessionStorage.removeItem('cp-dash-t');
  overlay.style.opacity = '1'; overlay.style.pointerEvents = 'all';
  document.getElementById('cpOvContent').style.opacity = '1';
  setTimeout(function(){ overlay.style.opacity = '0'; overlay.style.pointerEvents = 'none'; }, 100);
}
document.addEventListener('click', function(e){
  var link = e.target.closest('a[href]');
  if(!link) return;
  var href = link.getAttribute('href');
  if(!href || href.startsWith('#') || href.startsWith('javascript') ||
     href.startsWith('http') || link.target === '_blank') return;
  e.preventDefault();
  sessionStorage.setItem('cp-dash-t','1');
  overlay.style.opacity = '1'; overlay.style.pointerEvents = 'all';
  document.getElementById('cpOvContent').style.opacity = '1';
  setTimeout(function(){ window.location.href = href; }, 380);
});

/* ── 10. CHART LINE ANIMATION (draw on visible) ── */
document.querySelectorAll('.chart-svg path[stroke]').forEach(function(path){
  var len = path.getTotalLength ? path.getTotalLength() : 700;
  path.style.strokeDasharray = len;
  path.style.strokeDashoffset = len;
  var obs = new IntersectionObserver(function(e){
    if(!e[0].isIntersecting) return; obs.disconnect();
    path.style.transition = 'stroke-dashoffset 1.4s cubic-bezier(.22,1,.36,1)';
    path.style.strokeDashoffset = '0';
  },{threshold:.3});
  obs.observe(path);
});

/* ── 11. TOOLTIP on action icons ── */
document.querySelectorAll('.icon-btn[title]').forEach(function(btn){
  btn.addEventListener('mouseenter', function(){
    var tip = document.createElement('div');
    tip.className = 'cp-tooltip';
    tip.textContent = btn.getAttribute('title');
    Object.assign(tip.style, {
      position:'absolute', background:'#0f172a', color:'white',
      padding:'4px 10px', borderRadius:'8px', fontSize:'.78rem',
      fontWeight:'900', whiteSpace:'nowrap', pointerEvents:'none',
      zIndex:'5000', top:'-34px', left:'50%',
      transform:'translateX(-50%)', animation:'cpSlideUp .2s ease both',
      boxShadow:'0 4px 12px rgba(0,0,0,.25)'
    });
    btn.style.position = 'relative';
    btn.appendChild(tip);
  });
  btn.addEventListener('mouseleave', function(){
    var tip = btn.querySelector('.cp-tooltip');
    if(tip) btn.removeChild(tip);
  });
});

})();
</script>


</body>
</html>