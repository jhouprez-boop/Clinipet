<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.clinipet.model.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    Map<String,Object> d = (Map<String,Object>) request.getAttribute("datos");
    if (d == null) { response.sendRedirect(request.getContextPath() + "/enfermero/dashboard"); return; }

    String mascota    = d.get("mascota")    != null ? d.get("mascota").toString()    : "";
    String especie    = d.get("especie")    != null ? d.get("especie").toString()    : "";
    String raza       = d.get("raza")       != null ? d.get("raza").toString()       : "";
    String sexo       = d.get("sexo")       != null ? d.get("sexo").toString()       : "";
    String duenio     = d.get("duenio")     != null ? d.get("duenio").toString()     : "";
    String telDuenio  = d.get("tel_duenio") != null ? d.get("tel_duenio").toString() : "";
    String fecha      = d.get("fecha")      != null ? d.get("fecha").toString()      : "";
    String hora       = d.get("hora")       != null ? d.get("hora").toString()       : "";
    String motivo     = d.get("motivo")     != null ? d.get("motivo").toString()     : "";
    String idCita     = d.get("id_cita")    != null ? d.get("id_cita").toString()    : "";
    String idMascota  = d.get("id_mascota") != null ? d.get("id_mascota").toString() : "";

    // Pre-llenar si ya existe historia
    String diagnostico   = d.get("diagnostico")  != null ? d.get("diagnostico").toString()  : "";
    String tratamiento   = d.get("tratamiento")  != null ? d.get("tratamiento").toString()  : "";
    String medicacion    = d.get("medicacion")   != null ? d.get("medicacion").toString()   : "";
    String observaciones = d.get("observaciones")!= null ? d.get("observaciones").toString(): "";
%>
<!doctype html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Atender cita #<%= idCita %> | CliniPet</title>
<link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&family=Fredoka:wght@600;700&display=swap" rel="stylesheet">
<style>
:root{--green:#00c875;--green2:#00f5a0;--dark:#003d25;--muted:#64748b;--shadow:0 20px 60px rgba(0,80,50,.12)}
*{box-sizing:border-box}
body{margin:0;font-family:"Nunito",sans-serif;background:linear-gradient(135deg,#f8fffb,#eafff4);color:#0f172a;min-height:100vh}
h1,h2,h3,h4{font-family:"Fredoka",sans-serif}

.topbar{background:linear-gradient(135deg,#003d25,#007f4f);color:white;padding:18px 32px;display:flex;align-items:center;gap:18px;box-shadow:0 4px 20px rgba(0,61,37,.2)}
.topbar .brand{font-family:"Fredoka",sans-serif;font-size:1.6rem;font-weight:700;color:white;text-decoration:none;display:flex;align-items:center;gap:10px}
.topbar .brand-icon{width:44px;height:44px;border-radius:14px;background:white;color:#00c875;display:grid;place-items:center;font-size:1.4rem}
.topbar .sep{color:rgba(255,255,255,.4);font-size:1.2rem}
.topbar .page-title{font-size:1.1rem;font-weight:700;opacity:.9}
.topbar .back-btn{margin-left:auto;background:rgba(255,255,255,.15);border:1px solid rgba(255,255,255,.25);color:white;border-radius:14px;padding:10px 18px;text-decoration:none;font-weight:800;display:flex;align-items:center;gap:8px;transition:.2s}
.topbar .back-btn:hover{background:rgba(255,255,255,.25);color:white}

.container{max-width:860px;margin:32px auto;padding:0 20px}

.card{background:white;border-radius:28px;box-shadow:var(--shadow);overflow:hidden;margin-bottom:24px}
.card-head{padding:22px 28px;border-bottom:1px solid #dbeee5;display:flex;align-items:center;gap:12px}
.card-head i{font-size:1.5rem;color:var(--green)}
.card-head h3{margin:0;font-size:1.3rem;color:#063823}
.card-head .badge-cita{background:#dcfff0;color:#007f4f;border-radius:999px;padding:5px 14px;font-weight:900;font-size:.85rem;margin-left:auto}
.card-body{padding:24px 28px}

.info-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:14px;margin-bottom:8px}
.info-item{background:#f8fffb;border:1px solid #dbeee5;border-radius:16px;padding:14px 16px}
.info-item label{display:block;font-size:.75rem;font-weight:900;color:var(--muted);text-transform:uppercase;margin-bottom:4px}
.info-item span{font-weight:800;color:#0f172a;font-size:.97rem}

.form-group{margin-bottom:20px}
.form-group label{display:block;font-weight:900;color:#063823;margin-bottom:8px;font-size:.95rem}
.form-group label i{color:var(--green);margin-right:6px}
.form-group textarea{width:100%;border:1.5px solid #dbeee5;border-radius:16px;padding:14px 16px;font-family:"Nunito",sans-serif;font-size:.97rem;font-weight:700;resize:vertical;outline:none;transition:.2s;color:#0f172a;background:#fafffe}
.form-group textarea:focus{border-color:var(--green);box-shadow:0 0 0 3px rgba(0,200,117,.12)}
.form-group .hint{color:var(--muted);font-size:.8rem;font-weight:700;margin-top:5px}

.medicacion-box textarea{background:#f0fff8;border-color:#a7f0c9}
.medicacion-box textarea:focus{border-color:#00c875;box-shadow:0 0 0 3px rgba(0,200,117,.18)}

.btn-primary{background:linear-gradient(135deg,var(--green),var(--green2));color:#003d25;border:0;border-radius:18px;padding:16px 32px;font-weight:900;font-size:1.05rem;cursor:pointer;display:inline-flex;align-items:center;gap:10px;transition:.25s;box-shadow:0 16px 38px rgba(0,200,117,.28)}
.btn-primary:hover{transform:translateY(-2px);box-shadow:0 20px 45px rgba(0,200,117,.35)}
.btn-secondary{background:white;color:#063823;border:1.5px solid #dbeee5;border-radius:18px;padding:14px 24px;font-weight:900;font-size:.97rem;cursor:pointer;display:inline-flex;align-items:center;gap:8px;text-decoration:none;transition:.2s}
.btn-secondary:hover{border-color:var(--green);color:#063823}

.alert-ok{background:#dcfff0;border:1px solid #a7f0c9;color:#047857;border-radius:16px;padding:14px 20px;margin-bottom:20px;font-weight:800;display:flex;align-items:center;gap:10px}

.emoji-title{font-size:1.8rem;margin-right:8px}

@media(max-width:600px){.info-grid{grid-template-columns:1fr 1fr}.container{padding:0 12px}}
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

/* ══════════════════════════════════════════════
   MODO OSCURO — Color azul índigo profundo
══════════════════════════════════════════════ */
body.dark-mode{
  color:#e2f0ff;
  background:
    radial-gradient(circle at 20% 10%,rgba(99,102,241,.18),transparent 28%),
    radial-gradient(circle at 85% 20%,rgba(139,92,246,.14),transparent 30%),
    linear-gradient(135deg,#0a0e1a,#0d1326,#0f172a);
}
body.dark-mode .sidebar{
  background:
    radial-gradient(circle at 10% 0%,rgba(99,102,241,.28),transparent 35%),
    linear-gradient(180deg,#0f1535,#141b3a 52%,#0a0e24);
  box-shadow:18px 0 55px rgba(10,14,36,.55);
}
body.dark-mode .brand-icon{
  background:linear-gradient(135deg,#1e2a5e,#2d3a7c);
  color:#818cf8;
  box-shadow:0 0 30px rgba(99,102,241,.35);
}
body.dark-mode .nav-menu a{color:#c7d2fe}
body.dark-mode .nav-menu a:hover,
body.dark-mode .nav-menu a.active{
  background:linear-gradient(135deg,rgba(99,102,241,.7),rgba(139,92,246,.6))!important;
}
body.dark-mode .role-pill{
  background:linear-gradient(135deg,#4f46e5,#7c3aed);
}
body.dark-mode .user-panel{
  border-color:rgba(99,102,241,.25);
  background:rgba(99,102,241,.1);
}
body.dark-mode .main{
  background:transparent;
}
body.dark-mode .stat-card,
body.dark-mode .panel,
body.dark-mode .modal-cardx{
  background:rgba(15,21,50,.92);
  border-color:rgba(99,102,241,.18);
  color:#e2f0ff;
}
body.dark-mode .stat-card h2,
body.dark-mode .stat-card h3,
body.dark-mode .page-title,
body.dark-mode .panel-title{color:#e2f0ff}
body.dark-mode .stat-card p{color:#94a3b8}
body.dark-mode .table thead th{
  background:rgba(15,21,50,.95);color:#818cf8;
  border-color:rgba(99,102,241,.2);
}
body.dark-mode .table tbody td{color:#cbd5e1}
body.dark-mode .table tbody tr:hover{background:rgba(99,102,241,.08)!important}
body.dark-mode .panel-head{border-color:rgba(99,102,241,.15)}
body.dark-mode .search-box{
  background:rgba(15,21,50,.8);color:#e2f0ff;
  border-color:rgba(99,102,241,.25);
}
body.dark-mode .form-control,
body.dark-mode .form-select{
  background:rgba(15,21,50,.9);color:#e2f0ff;
  border-color:rgba(99,102,241,.25);
}
body.dark-mode .menu-btn{
  background:rgba(15,21,50,.9);color:#e2f0ff;
}
body.dark-mode .top-actions{color:#e2f0ff}
body.dark-mode .modal-headx{
  background:linear-gradient(135deg,#1e1b4b,#4f46e5);
}
body.dark-mode .noti-box{
  background:#0f1535;border-color:rgba(99,102,241,.2);
  box-shadow:0 22px 70px rgba(10,14,36,.5);
}
body.dark-mode .noti-title{color:#818cf8}
body.dark-mode .alert-red{background:#2a0a0a}
body.dark-mode .alert-orange{background:#2a1500}
body.dark-mode .alert-blue{background:#0a1535}
body.dark-mode .toastx{background:linear-gradient(135deg,#1e1b4b,#4f46e5)}
body.dark-mode .quick-btn.dark{background:linear-gradient(135deg,#1e1b4b,#4338ca)}
body.dark-mode .brand-title{
  background:linear-gradient(135deg,#818cf8,#c4b5fd);
  -webkit-background-clip:text;background-clip:text;
  color:transparent;
  animation:cpGlowPulse 3s infinite;
}
body.dark-mode .page-title i{color:#818cf8}
body.dark-mode .stat-icon.green{
  background:linear-gradient(135deg,#4f46e5,#7c3aed)!important;
  animation:cpPulsePurple 2.5s 1.2s infinite;
}
body.dark-mode .spark path[fill]{opacity:.4}
/* Dark mode toggle button */
#darkModeBtn{
  border:0;border-radius:12px;padding:10px 16px;
  font-weight:900;cursor:pointer;
  display:inline-flex;align-items:center;gap:8px;
  background:linear-gradient(135deg,#1e1b4b,#4f46e5);
  color:white;font-size:.9rem;
  box-shadow:0 8px 20px rgba(79,70,229,.28);
  transition:transform .2s,box-shadow .2s;
  font-family:"Nunito",sans-serif;
}
#darkModeBtn:hover{transform:translateY(-2px);box-shadow:0 14px 28px rgba(79,70,229,.38)}
body.dark-mode #darkModeBtn{
  background:linear-gradient(135deg,#fbbf24,#f59e0b);
  box-shadow:0 8px 20px rgba(251,191,36,.28);
  color:#1a1200;
}
</style>


<script>!function(){var t=localStorage.getItem("clinipetTheme")||"light";var m={"dark":["theme-dark","dark-mode"],"neon":["theme-neon","neon-mode"]};if(m[t])m[t].forEach(function(c){document.documentElement.classList.add(c)});}();</script><script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</head>

<body>

<div class="topbar">
    <a class="brand" href="${pageContext.request.contextPath}/enfermero/dashboard">
        <div class="brand-icon"><i class="ti ti-paw"></i></div>
        CliniPet
    </a>
    <span class="sep">/</span>
    <span class="page-title">Atender cita</span>
    <a class="back-btn" href="${pageContext.request.contextPath}/enfermero/dashboard">
        <i class="ti ti-arrow-left"></i> Volver al panel
    </a>
</div>

<div class="container">

    <%-- Mensaje de éxito si volvemos después de guardar --%>
    <% if ("historia".equals(request.getParameter("ok"))) { %>
    <div class="alert-ok"><i class="ti ti-circle-check" style="font-size:1.4rem"></i> Historia clínica guardada correctamente. La cita fue marcada como <strong>REALIZADA</strong>.</div>
    <% } %>

    <%-- ── DATOS DEL PACIENTE ─────────────────────────────────────────── --%>
    <div class="card">
        <div class="card-head">
            <i class="ti ti-stethoscope"></i>
            <h3><span class="emoji-title">🐾</span> Paciente — <%= mascota %> <small style="font-size:.85rem;color:var(--muted)">(Cita #<%= idCita %>)</small></h3>
            <span class="badge-cita"><i class="ti ti-calendar"></i> <%= fecha %> &nbsp;·&nbsp; <%= hora %></span>
        </div>
        <div class="card-body">
            <div class="info-grid">
                <div class="info-item">
                    <label><i class="ti ti-paw"></i> Mascota</label>
                    <span><%= mascota %></span>
                </div>
                <div class="info-item">
                    <label><i class="ti ti-dna"></i> Especie / Raza</label>
                    <span><%= especie %> <%= raza.isEmpty() ? "" : "— " + raza %></span>
                </div>
                <div class="info-item">
                    <label><i class="ti ti-gender-bigender"></i> Sexo</label>
                    <span><%= sexo.isEmpty() ? "No registrado" : sexo %></span>
                </div>
                <div class="info-item">
                    <label><i class="ti ti-user"></i> Dueño</label>
                    <span><%= duenio %></span>
                </div>
                <div class="info-item">
                    <label><i class="ti ti-phone"></i> Teléfono</label>
                    <span><%= telDuenio.isEmpty() ? "No registrado" : telDuenio %></span>
                </div>
                <div class="info-item">
                    <label><i class="ti ti-clipboard-text"></i> Motivo</label>
                    <span><%= motivo %></span>
                </div>
            </div>
        </div>
    </div>

    <%-- ── FORMULARIO HISTORIA CLÍNICA ───────────────────────────────── --%>
    <div class="card">
        <div class="card-head">
            <i class="ti ti-notes-medical"></i>
            <h3>Historia clínica — Tratamiento</h3>
        </div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/veterinario/atender">
                <input type="hidden" name="id_cita"    value="<%= idCita %>">
                <input type="hidden" name="id_mascota" value="<%= idMascota %>">

                <div class="form-group">
                    <label><i class="ti ti-microscope"></i> Diagnóstico</label>
                    <textarea name="diagnostico" rows="3"
                              placeholder="Ej: Otitis externa leve en oído derecho, sin signos sistémicos..."
                    ><%= diagnostico %></textarea>
                </div>

                <div class="form-group">
                    <label><i class="ti ti-heart-rate-monitor"></i> Tratamiento indicado</label>
                    <textarea name="tratamiento" rows="3"
                              placeholder="Ej: Limpieza de oídos diaria, revisión en 10 días..."
                    ><%= tratamiento %></textarea>
                </div>

                <div class="form-group medicacion-box">
                    <label><i class="ti ti-pill"></i> 💊 Medicación y dosis</label>
                    <textarea name="medicacion" rows="4"
                              placeholder="Ej:&#10;• Otomite gotas — 3 gotas en oído derecho cada 12h por 7 días&#10;• Amoxicilina 250mg — 1 tableta cada 8h por 5 días con comida&#10;• Meloxicam 0.5mg — 1 tableta diaria por 3 días"
                    ><%= medicacion %></textarea>
                    <p class="hint">💡 Escribe cada medicamento en una línea separada, incluyendo dosis, frecuencia y duración.</p>
                </div>

                <div class="form-group">
                    <label><i class="ti ti-writing"></i> Observaciones adicionales</label>
                    <textarea name="observaciones" rows="3"
                              placeholder="Ej: Programar control en 2 semanas. Evitar baños durante el tratamiento..."
                    ><%= observaciones %></textarea>
                </div>

                <div style="display:flex;gap:14px;align-items:center;flex-wrap:wrap;margin-top:8px">
                    <button type="submit" class="btn-primary">
                        <i class="ti ti-device-floppy"></i> Guardar historia clínica
                    </button>
                    <a href="${pageContext.request.contextPath}/enfermero/dashboard" class="btn-secondary">
                        <i class="ti ti-x"></i> Cancelar
                    </a>
                </div>

            </form>
        </div>
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
