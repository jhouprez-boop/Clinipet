<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.clinipet.model.Usuario" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    List<Map<String,Object>> mascotas = (List<Map<String,Object>>) request.getAttribute("mascotas");
    List<Map<String,Object>> citas = (List<Map<String,Object>>) request.getAttribute("citas");
    List<Map<String,Object>> ventas = (List<Map<String,Object>>) request.getAttribute("ventas");
    List<Map<String,Object>> productos = (List<Map<String,Object>>) request.getAttribute("productos");

    if (mascotas == null) mascotas = new ArrayList<>();
    if (citas == null) citas = new ArrayList<>();

    // Citas con historia clínica (incluye diagnóstico, tratamiento, medicación)
    List<Map<String,Object>> citasHistoria = (List<Map<String,Object>>) request.getAttribute("citasHistoria");
    if (citasHistoria == null) citasHistoria = citas; // fallback
    if (ventas == null) ventas = new ArrayList<>();
    if (productos == null) productos = new ArrayList<>();
%>

<!doctype html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Panel cliente | CliniPet</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&family=Fredoka:wght@600;700&display=swap" rel="stylesheet">

<style>
:root{
    --green:#00a85a;
    --green2:#00d978;
    --dark:#003d25;
    --muted:#64748b;
    --shadow:0 22px 70px rgba(0,60,35,.13);
}
*{box-sizing:border-box}
body{
    margin:0;
    font-family:"Nunito",sans-serif;
    background:linear-gradient(135deg,#fbfffd,#eafff4);
    color:#0f172a;
}
h1,h2,h3{font-family:"Fredoka",sans-serif}
.layout{display:flex;min-height:100vh}
.side{
    width:280px;
    position:fixed;
    left:0;
    top:0;
    min-height:100vh;
    background:linear-gradient(180deg,#00452a,#00371f);
    color:white;
    padding:28px 22px;
}
.brand{
    display:flex;
    gap:12px;
    align-items:center;
    margin-bottom:30px;
}
.brand-icon{
    width:58px;
    height:58px;
    border-radius:20px;
    background:white;
    color:#00a85a;
    display:grid;
    place-items:center;
    font-size:2rem;
}
.navx{display:grid;gap:10px}
.navx a{
    color:#eafff4;
    text-decoration:none;
    padding:14px 16px;
    border-radius:15px;
    font-weight:900;
    display:flex;
    gap:10px;
    align-items:center;
}
.navx a:hover,.navx a.active{background:rgba(0,200,117,.28)}
.main{
    margin-left:280px;
    width:calc(100% - 280px);
    padding:32px;
}
.top{
    display:flex;
    justify-content:space-between;
    align-items:center;
    gap:18px;
    margin-bottom:24px;
}
.title{
    font-size:2.5rem;
    color:#063823;
    margin:0;
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
    background:linear-gradient(135deg,var(--green),var(--green2));
    color:white;
}
.btn-green:hover{color:white}
.btn-soft{
    background:white;
    color:#003d25;
    box-shadow:var(--shadow);
}
.btn-soft:hover{color:#003d25}
.btn-red{
    background:#ef4444;
    color:white;
}
.btn-red:hover{color:white}
.stats{
    display:grid;
    grid-template-columns:repeat(3,1fr);
    gap:18px;
    margin-bottom:24px;
}
.stat{
    background:white;
    border-radius:24px;
    padding:24px;
    box-shadow:var(--shadow);
}
.stat i{font-size:2rem;color:#00a85a}
.stat h2{font-size:2.2rem;margin:8px 0}
.stat span{color:#64748b;font-weight:800}
.grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:22px;
}
.panel{
    background:white;
    border-radius:26px;
    box-shadow:var(--shadow);
    overflow:hidden;
    margin-bottom:22px;
}
.panel-head{
    padding:20px 22px;
    border-bottom:1px solid #dbeee5;
    display:flex;
    justify-content:space-between;
    align-items:center;
    gap:12px;
}
.panel-title{
    margin:0;
    color:#063823;
}
.panel-body{padding:22px}
.badge-soft{
    background:#dcfff0;
    color:#007f4f;
    border-radius:999px;
    padding:7px 12px;
    font-weight:900;
}
.table td,.table th{vertical-align:middle}

.modal-mascota{
    display:none;
    position:fixed;
    inset:0;
    background:rgba(0,30,18,.65);
    z-index:9999;
    align-items:center;
    justify-content:center;
    padding:20px;
}
.modal-mascota.show{display:flex}
.modal-card{
    background:white;
    width:min(650px,100%);
    border-radius:24px;
    overflow:hidden;
    box-shadow:0 30px 90px rgba(0,0,0,.25);
}
.modal-head{
    background:linear-gradient(135deg,#003d25,#00a85a);
    color:white;
    padding:22px;
    display:flex;
    justify-content:space-between;
    align-items:center;
}
.modal-head h2{margin:0;color:white}
.modal-close{
    border:0;
    background:rgba(255,255,255,.18);
    color:white;
    border-radius:12px;
    width:40px;
    height:40px;
    font-size:22px;
}
.modal-body{padding:24px}
.form-grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:16px;
}
.form-grid .full{grid-column:1/-1}
.form-control,.form-select{
    border-radius:14px;
    padding:12px 14px;
}
label{font-weight:900;color:#064e3b;margin-bottom:6px}

@media(max-width:1050px){
    .side{position:relative;width:100%;min-height:auto}
    .main{margin-left:0;width:100%}
    .layout{display:block}
    .grid{grid-template-columns:1fr}
    .stats{grid-template-columns:1fr}
}
@media(max-width:620px){
    .top{align-items:flex-start;flex-direction:column}
    .form-grid{grid-template-columns:1fr}
    .form-grid .full{grid-column:auto}
}
.icon-btn{display:inline-flex;align-items:center;justify-content:center;width:30px;height:30px;border-radius:6px;border:none;cursor:pointer;font-size:14px;background:#e2e8f0;color:#64748b;transition:opacity .2s}
.icon-btn:hover{opacity:.8}
.icon-x{background:#ef4444;color:white}
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
        <div class="brand">
            <span class="brand-icon"><i class="ti ti-paw"></i></span>
            <div>
                <h2 class="mb-0 text-white">CliniPet</h2>
                <small>Panel cliente</small>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/perfil" style="text-decoration:none;color:inherit;display:flex;align-items:center;gap:10px;padding:10px 14px;margin:6px 0">
            <% if (usuario != null && usuario.getAvatarUrlOrNull() != null) { %>
                <img src="${pageContext.request.contextPath}<%= usuario.getAvatarUrlOrNull() %>" alt="avatar" style="width:42px;height:42px;border-radius:50%;object-fit:cover"/>
            <% } else { %>
                <i class="ti ti-user-circle" style="font-size:1.8rem"></i>
            <% } %>
            <span><strong><%= usuario != null ? usuario.getNombre() : "Cliente" %></strong><br><span class="opacity-75">Editar perfil</span></span>
        </a>

        <nav class="navx">
            <a class="active" href="${pageContext.request.contextPath}/cliente/dashboard">
                <i class="ti ti-home"></i> Mi panel
            </a>

            <a href="${pageContext.request.contextPath}/citas/nueva">
                <i class="ti ti-calendar-plus"></i> Agendar cita
            </a>

            <a href="${pageContext.request.contextPath}/cliente/comprar">
                <i class="ti ti-shopping-cart"></i> Tienda
            </a>

            <a href="${pageContext.request.contextPath}/perfil">
                <i class="ti ti-user-cog"></i> Mi perfil
            </a>

            <a href="${pageContext.request.contextPath}/">
                <i class="ti ti-world"></i> Ir al inicio
            </a>

            <a href="${pageContext.request.contextPath}/logout" style="margin-top:16px;background:rgba(190,18,60,.25)">
                <i class="ti ti-logout"></i> Cerrar sesión
            </a>
        </nav>
    </aside>

    <main class="main">

        <div class="top">
            <div>
                <h1 class="title">Hola, <%= usuario != null ? usuario.getNombre() : "Cliente" %> 🐾</h1>
                <p class="text-secondary fw-bold">
                    Agenda citas y revisa la información de tus mascotas.
                </p>
            </div>

            <div class="d-flex gap-2 flex-wrap">
                <a href="${pageContext.request.contextPath}/" class="btnx btn-soft">
                    <i class="ti ti-world"></i> Ir al inicio
                </a>

                <a href="${pageContext.request.contextPath}/citas/nueva" class="btnx btn-green">
                    <i class="ti ti-calendar-plus"></i> Agendar cita
                </a>

                <a href="${pageContext.request.contextPath}/logout" class="btnx btn-red">
                    <i class="ti ti-logout"></i> Cerrar sesión
                </a>
            </div>
        </div>

        <% if(request.getParameter("ok") != null){ %>
        <div class="alert alert-success rounded-4 fw-bold">
            <% String okVal = request.getParameter("ok");
               if("cita".equals(okVal)){ %>
                <i class="ti ti-calendar-check"></i> ¡Cita agendada correctamente!
            <% } else if("compra".equals(okVal)){ %>
                <i class="ti ti-shopping-cart"></i> ¡Compra realizada correctamente!
<<<<<<< HEAD
            <% } else if("mascota".equals(okVal)){ %>
                <i class="ti ti-paw"></i> ¡Mascota registrada correctamente!
            <% } else if("mascota_actualizada".equals(okVal)){ %>
                <i class="ti ti-paw"></i> ¡Datos de la mascota actualizados!
            <% } else if("mascota_eliminada".equals(okVal)){ %>
                <i class="ti ti-paw"></i> Mascota eliminada correctamente.
=======
>>>>>>> a8a607ea862f20a42cd772394ac93aca233e77d9
            <% } else { %>
                <i class="ti ti-check"></i> <%= okVal %>
            <% } %>
        </div>
        <% } %>

        <% if(request.getParameter("error") != null){ %>
        <div class="alert alert-danger rounded-4 fw-bold">
            <%= request.getParameter("error") %>
        </div>
        <% } %>

        <section class="stats">
            <div class="stat">
                <i class="ti ti-paw"></i>
                <h2><%= mascotas.size() %></h2>
                <span>Mis mascotas</span>
            </div>

            <div class="stat">
                <i class="ti ti-calendar"></i>
                <h2><%= citas.size() %></h2>
                <span>Mis citas</span>
            </div>

            <div class="stat">
                <i class="ti ti-shopping-bag"></i>
                <h2><%= ventas.size() %></h2>
                <span>Mis compras</span>
            </div>
        </section>

        <section class="grid">

            <div class="panel">
                <div class="panel-head">
                    <h2 class="panel-title">
                        <i class="ti ti-paw"></i> Mis mascotas
                    </h2>

                    <button class="btnx btn-green" type="button" onclick="abrirModalMascota()">
                        <i class="ti ti-plus"></i> Nueva
                    </button>
                </div>

                <div class="panel-body">
                    <% for(Map<String,Object> m : mascotas){ %>
                    <div class="d-flex justify-content-between align-items-center p-3 rounded-4 mb-2"
                         style="background:#f7fffb;border:1px solid #dbeee5">
                        <div>
                            <strong><%= m.get("nombre") %></strong><br>
                            <span class="text-secondary">
                                <%= m.get("especie") %> · <%= m.get("raza") %>
                            </span>
                        </div>
<<<<<<< HEAD
                        <div style="display:flex;align-items:center;gap:8px">
                            <span class="badge-soft"><%= m.get("alerta") %></span>
                            <button class="icon-btn icon-edit" type="button" title="Editar mascota"
                                onclick="abrirEditarMascota(this)"
                                data-id="<%= m.get("id") %>"
                                data-nombre="<%= m.get("nombre") %>"
                                data-especie="<%= m.get("especie") %>"
                                data-raza="<%= m.get("raza") != null ? m.get("raza") : "" %>"
                                data-sexo="<%= m.get("sexo") != null ? m.get("sexo") : "" %>"
                                data-fecha="<%= m.get("fecha_nacimiento") != null ? m.get("fecha_nacimiento") : "" %>">
                                <i class="ti ti-edit"></i>
                            </button>
                            <form method="post" action="${pageContext.request.contextPath}/cliente/mascotas/eliminar"
                                  style="display:inline"
                                  onsubmit="return confirm('¿Eliminar a <%= m.get("nombre") %>? Esta acción no se puede deshacer.')">
                                <input type="hidden" name="id_mascota" value="<%= m.get("id") %>">
                                <button class="icon-btn icon-x" type="submit" title="Eliminar mascota">
                                    <i class="ti ti-trash"></i>
                                </button>
                            </form>
                        </div>
=======

                        <span class="badge-soft"><%= m.get("alerta") %></span>
>>>>>>> a8a607ea862f20a42cd772394ac93aca233e77d9
                    </div>
                    <% } %>

                    <% if(mascotas.isEmpty()){ %>
                    <p class="text-secondary fw-bold">
                        No tienes mascotas vinculadas a tu cuenta.
                    </p>
                    <% } %>
                </div>
            </div>

            <div class="panel">
                <div class="panel-head">
                    <h2 class="panel-title">
                        <i class="ti ti-calendar"></i> Mis citas
                    </h2>

                    <a href="${pageContext.request.contextPath}/citas/nueva" class="btnx btn-green">
                        Nueva
                    </a>
                </div>

                <div class="table-responsive">
                    <table class="table card-table">
                        <thead>
                            <tr>
                                <th>Mascota</th>
                                <th>Fecha</th>
                                <th>Estado</th>
                                <th>Tratamiento</th>
                                <th>Descargar</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(Map<String,Object> c : citasHistoria){ %>
                            <%
                                String estadoCita = c.get("estado") != null ? c.get("estado").toString() : "PENDIENTE";
                                boolean tieneHistoria = c.get("diagnostico") != null && !c.get("diagnostico").toString().isEmpty();
                                String badgeClass = "REALIZADA".equalsIgnoreCase(estadoCita) ? "badge-soft" :
                                                    "CANCELADA".equalsIgnoreCase(estadoCita) ? "badge-soft badge-danger" :
                                                    "CONFIRMADA".equalsIgnoreCase(estadoCita) ? "badge-soft badge-info" : "badge-soft badge-warning";
                            %>
                            <tr>
                                <td>
                                    <strong><%= c.get("mascota") %></strong>
                                    <% if (c.get("especie") != null) { %><br><small class="text-secondary"><%= c.get("especie") %></small><% } %>
                                </td>
                                <td>
                                    <%= c.get("fecha") %><br>
                                    <small class="text-secondary"><%= c.get("hora") != null ? c.get("hora") : "" %></small>
                                </td>
                                <td><span class="<%= badgeClass %>"><%= estadoCita %></span></td>
                                <td style="max-width:220px">
                                    <% if (tieneHistoria) { %>
                                        <div style="font-size:.82rem;color:#047857;font-weight:800">
                                            <i class="ti ti-pill" style="color:#00a85a"></i>
                                            <%= c.get("medicacion").toString().length() > 80
                                                ? c.get("medicacion").toString().substring(0, 80) + "..."
                                                : c.get("medicacion").toString() %>
                                        </div>
                                    <% } else { %>
                                        <span class="text-secondary" style="font-size:.82rem">Sin historia todavía</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (tieneHistoria) { %>
                                    <a href="${pageContext.request.contextPath}/cliente/pdf-tratamiento?id_cita=<%= c.get("id_cita") %>"
                                       target="_blank"
                                       style="background:linear-gradient(135deg,#00a85a,#00d978);color:white;border-radius:12px;padding:8px 14px;font-weight:900;font-size:.82rem;text-decoration:none;display:inline-flex;align-items:center;gap:6px;white-space:nowrap"
                                       title="Descargar PDF del tratamiento">
                                        <i class="ti ti-file-type-pdf"></i> Descargar
                                    </a>
                                    <% } else { %>
                                    <span style="color:#cbd5e1;font-size:.8rem">—</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                            <% if(citasHistoria.isEmpty()){ %>
                            <tr>
                                <td colspan="5" class="text-center text-secondary p-4">
                                    No tienes citas todavía.
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </section>

        <section class="panel">
            <div class="panel-head">
                <h2 class="panel-title">
                    <i class="ti ti-shopping-bag"></i> Mis compras
                </h2>
            </div>

            <div class="table-responsive">
                <table class="table card-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Fecha</th>
                            <th>Total</th>
                            <th>Método</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>

                    <tbody>
                        <% for(Map<String,Object> v : ventas){ %>
                        <tr>
                            <td><%= v.get("id") %></td>
                            <td><%= v.get("fecha") %></td>
                            <td>$<%= v.get("total") %></td>
                            <td><%= v.get("metodo") %></td>
                            <td>
                                <%
                                String ev = String.valueOf(v.get("estado"));
                                String evStyle = "PENDIENTE".equalsIgnoreCase(ev)
                                    ? "background:#fff7ed;color:#c2410c;border:1px solid #fed7aa"
                                    : "CANCELADO".equalsIgnoreCase(ev)
                                    ? "background:#fff1f2;color:#be123c;border:1px solid #fecdd3"
                                    : "background:#dcfff0;color:#007f4f;border:1px solid #bbf7d0";
                                %>
                                <span class="badge-soft" style="<%= evStyle %>">
                                    <% if("PENDIENTE".equalsIgnoreCase(ev)){ %><i class="ti ti-clock"></i> En espera<% }
                                       else if("CONFIRMADO".equalsIgnoreCase(ev)){ %><i class="ti ti-check"></i> Confirmado<% }
                                       else { %><%= ev %><% } %>
                                </span>
                            </td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/cliente/ventas/eliminar" style="display:inline" onsubmit="return confirm('¿Eliminar esta compra?');"><input type="hidden" name="id" value="<%= v.get("id") %>"><button class="icon-btn icon-x" title="Eliminar compra"><i class="ti ti-trash"></i></button></form>
                            </td>
                        </tr>
                        <% } %>

                        <% if(ventas.isEmpty()){ %>
                        <tr>
                            <td colspan="6" class="text-center text-secondary p-4">
                                No tienes compras todavía.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- PRODUCTOS DESTACADOS -->
        <section class="panel" style="margin-top:20px">
            <div class="panel-head">
                <h2 class="panel-title"><i class="ti ti-shopping-bag"></i> Productos disponibles</h2>
                <a href="${pageContext.request.contextPath}/cliente/comprar" class="view-btn" style="text-decoration:none">
                    Ver todos
                </a>
            </div>
            <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:16px;padding:16px">
                <%
                int contProd = 0;
                for(Map<String,Object> p : productos){
                    if(contProd >= 4) break;
                    contProd++;
                    String imgP = p.get("imagen_url") != null && !String.valueOf(p.get("imagen_url")).trim().isEmpty()
                        ? String.valueOf(p.get("imagen_url"))
                        : "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?auto=format&fit=crop&w=400&q=60";
                    int stockP = 0;
                    try { stockP = Integer.parseInt(String.valueOf(p.get("stock"))); } catch(Exception ex){}
                %>
                <div style="background:white;border-radius:18px;box-shadow:0 8px 30px rgba(0,60,35,.10);overflow:hidden">
                    <div style="height:130px;background-image:url('<%= imgP %>');background-size:cover;background-position:center"></div>
                    <div style="padding:14px">
                        <strong style="font-size:.95rem"><%= p.get("nombre") %></strong><br>
                        <span style="color:#64748b;font-size:.82rem"><%= p.get("categoria") %></span><br>
                        <div style="display:flex;justify-content:space-between;align-items:center;margin-top:10px">
                            <span style="color:#00a85a;font-weight:900;font-size:1.05rem">$<%= p.get("precio") %></span>
                            <% if(stockP > 0){ %>
                            <a href="${pageContext.request.contextPath}/cliente/comprar"
                               style="border:0;border-radius:10px;background:linear-gradient(135deg,#00a85a,#00d978);color:white;padding:7px 12px;font-weight:700;cursor:pointer;font-size:.82rem;text-decoration:none;display:inline-flex;align-items:center;gap:5px">
                                <i class="ti ti-shopping-cart-plus"></i> Al carrito
                            </a>
                            <% } else { %>
                            <span style="color:#ef4444;font-size:.78rem;font-weight:700">Sin stock</span>
                            <% } %>
                        </div>
                    </div>
                </div>
                <% } %>
                <% if(productos.isEmpty()){ %>
                <div style="grid-column:1/-1;text-align:center;padding:30px;color:#64748b">
                    No hay productos disponibles.
                </div>
                <% } %>
            </div>
            <% if(productos.size() > 4){ %>
            <div style="text-align:center;padding:0 16px 20px">
                <a href="${pageContext.request.contextPath}/cliente/comprar"
                   style="display:inline-block;border:0;border-radius:14px;background:linear-gradient(135deg,#00a85a,#00d978);color:white;padding:12px 28px;font-weight:900;text-decoration:none">
                    <i class="ti ti-chevron-down"></i> Ver todos los productos (<%= productos.size() %>)
                </a>
            </div>
            <% } %>
        </section>

    </main>
</div>

<div id="modalMascota" class="modal-mascota">
    <div class="modal-card">

        <div class="modal-head">
            <h2>
                <i class="ti ti-paw"></i> Registrar mascota
            </h2>

            <button type="button" class="modal-close" onclick="cerrarModalMascota()">
                ×
            </button>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/cliente/mascotas/guardar" class="modal-body">
            <div class="form-grid">

                <div>
                    <label>Nombre</label>
                    <input class="form-control" name="nombre" required>
                </div>

                <div>
                    <label>Especie</label>
                    <select class="form-select" name="especie" required>
                        <option value="">Selecciona</option>
                        <option value="Perro">Perro</option>
                        <option value="Gato">Gato</option>
                        <option value="Ave">Ave</option>
                        <option value="Conejo">Conejo</option>
                        <option value="Otro">Otro</option>
                    </select>
                </div>

                <div>
                    <label>Raza</label>
                    <input class="form-control" name="raza" required>
                </div>

                <div>
                    <label>Fecha nacimiento</label>
                    <input class="form-control" type="date" name="fecha_nacimiento">
                </div>

                <div>
                    <label>Sexo</label>
                    <select class="form-select" name="sexo" required>
                        <option value="">Selecciona</option>
                        <option value="MACHO">MACHO</option>
                        <option value="HEMBRA">HEMBRA</option>
                    </select>
                </div>

                <div class="full d-flex justify-content-end gap-2 mt-2">
                    <button type="button" class="btnx btn-soft" onclick="cerrarModalMascota()">
                        Cancelar
                    </button>

                    <button class="btnx btn-green">
                        <i class="ti ti-device-floppy"></i> Guardar mascota
                    </button>
                </div>

            </div>
        </form>
    </div>
</div>

<script>
function abrirModalMascota(){
    document.getElementById('modalMascota').classList.add('show');
}

function cerrarModalMascota(){
    document.getElementById('modalMascota').classList.remove('show');
}

document.getElementById('modalMascota').addEventListener('click', function(e){
    if(e.target === this){
        cerrarModalMascota();
    }
});
<<<<<<< HEAD

// ── EDITAR MASCOTA ──────────────────────────────────────
function abrirEditarMascota(btn) {
    document.getElementById('editMascotaId').value     = btn.dataset.id     || '';
    document.getElementById('editMascotaNombre').value = btn.dataset.nombre  || '';
    document.getElementById('editMascotaRaza').value   = btn.dataset.raza    || '';
    document.getElementById('editMascotaFecha').value  = btn.dataset.fecha   || '';
    // Selects
    var selEsp = document.getElementById('editMascotaEspecie');
    var selSex = document.getElementById('editMascotaSexo');
    selEsp.value = btn.dataset.especie || 'Perro';
    selSex.value = btn.dataset.sexo    || 'Macho';
    document.getElementById('modalEditarMascota').classList.add('show');
}
function cerrarEditarMascota() {
    document.getElementById('modalEditarMascota').classList.remove('show');
}
document.getElementById('modalEditarMascota').addEventListener('click', function(e){
    if(e.target === this) cerrarEditarMascota();
});
</script>

<!-- MODAL EDITAR MASCOTA -->
<div id="modalEditarMascota" class="modal-mascota">
    <div class="modal-card" style="max-width:520px">
        <div class="modal-head">
            <div style="display:flex;align-items:center;gap:10px">
                <i class="ti ti-edit" style="font-size:1.4rem"></i>
                <h2>Editar mascota</h2>
            </div>
            <button type="button" class="modal-close" onclick="cerrarEditarMascota()">
                <i class="ti ti-x"></i>
            </button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/cliente/mascotas/actualizar" class="modal-body">
            <input type="hidden" name="id_mascota" id="editMascotaId">
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px">
                <div style="grid-column:1/-1">
                    <label class="form-label-cp">Nombre</label>
                    <input type="text" class="form-control-cp" name="nombre" id="editMascotaNombre" required placeholder="Nombre de la mascota"/>
                </div>
                <div>
                    <label class="form-label-cp">Especie</label>
                    <select class="form-control-cp" name="especie" id="editMascotaEspecie">
                        <option>Perro</option><option>Gato</option><option>Ave</option>
                        <option>Conejo</option><option>Reptil</option><option>Otro</option>
                    </select>
                </div>
                <div>
                    <label class="form-label-cp">Sexo</label>
                    <select class="form-control-cp" name="sexo" id="editMascotaSexo">
                        <option>Macho</option><option>Hembra</option>
                    </select>
                </div>
                <div>
                    <label class="form-label-cp">Raza</label>
                    <input type="text" class="form-control-cp" name="raza" id="editMascotaRaza" placeholder="Ej: Labrador"/>
                </div>
                <div>
                    <label class="form-label-cp">Fecha de nacimiento</label>
                    <input type="date" class="form-control-cp" name="fecha_nacimiento" id="editMascotaFecha"/>
                </div>
            </div>
            <div style="display:flex;gap:10px;margin-top:20px;justify-content:flex-end">
                <button type="button" class="btnx btn-soft" onclick="cerrarEditarMascota()">Cancelar</button>
                <button type="submit" class="btnx btn-green">
                    <i class="ti ti-device-floppy"></i> Guardar cambios
                </button>
            </div>
        </form>
    </div>
</div>

=======
</script>

>>>>>>> a8a607ea862f20a42cd772394ac93aca233e77d9
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