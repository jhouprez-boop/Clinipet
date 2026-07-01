<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.clinipet.model.Usuario" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    List<Map<String,Object>> citas = (List<Map<String,Object>>) request.getAttribute("citas");
    List<Map<String,Object>> ventas = (List<Map<String,Object>>) request.getAttribute("ventas");
    List<Map<String,Object>> productos = (List<Map<String,Object>>) request.getAttribute("productos");
    List<Map<String,Object>> veterinarios = (List<Map<String,Object>>) request.getAttribute("veterinarios");
    List<Map<String,Object>> usuarios = (List<Map<String,Object>>) request.getAttribute("usuarios");

    if (citas == null) citas = new ArrayList<>();
    if (ventas == null) ventas = new ArrayList<>();
    if (productos == null) productos = new ArrayList<>();
    if (veterinarios == null) veterinarios = new ArrayList<>();
    if (usuarios == null) usuarios = new ArrayList<>();

    int citasHoy = citas.size();
    int citasPendientes = 0;
    int stockBajo = 0;
    int ventasPendientes = 0;
    double totalVentas = 0;
    double totalCitas = 0;
    double totalIngresos = 0;

    for (Map<String,Object> c : citas) {
        String estado = String.valueOf(c.get("estado"));
        if ("PENDIENTE".equalsIgnoreCase(estado)) citasPendientes++;
        // Sumar ingresos de citas que NO estén canceladas
        if (!"CANCELADA".equalsIgnoreCase(estado) && !"CANCELADO".equalsIgnoreCase(estado)) {
            try {
                Object precioObj = c.get("precio");
                if (precioObj != null) totalCitas += Double.parseDouble(String.valueOf(precioObj));
            } catch(Exception e) {}
        }
    }

    for (Map<String,Object> p : productos) {
        try {
            int stock = Integer.parseInt(String.valueOf(p.get("stock")));
            int minimo = 5;
            if (p.get("stock_minimo") != null) minimo = Integer.parseInt(String.valueOf(p.get("stock_minimo")));
            if (stock <= minimo) stockBajo++;
        } catch(Exception e) {}
    }

    for (Map<String,Object> v : ventas) {
        try {
            String estadoV = String.valueOf(v.get("estado"));
            // Solo sumar ventas que NO estén canceladas
            if (!"CANCELADA".equalsIgnoreCase(estadoV) && !"CANCELADO".equalsIgnoreCase(estadoV)) {
                totalVentas += Double.parseDouble(String.valueOf(v.get("total")));
            }
            if ("PENDIENTE".equalsIgnoreCase(estadoV)) ventasPendientes++;
        } catch(Exception e) {}
    }

    // Total combinado: productos vendidos + citas (sin canceladas)
    totalIngresos = totalVentas + totalCitas;
%>

<!doctype html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Dashboard administrativo | CliniPet</title>

<link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800;900&family=Fredoka:wght@500;600;700&display=swap" rel="stylesheet">

<style>
:root{
    --green:#00a85a;
    --green2:#00d978;
    --dark:#003d25;
    --dark2:#005f3c;
    --text:#0f172a;
    --muted:#64748b;
    --line:#dbeee5;
    --bg:#f7fffb;
    --shadow:0 18px 55px rgba(0,60,35,.10);
    --blue:#2f80ed;
    --orange:#ff9f2d;
    --purple:#7c5cff;
    --red:#ef4444;
}
*{box-sizing:border-box}
html{scroll-behavior:smooth}
body{
    margin:0;
    font-family:"Nunito",sans-serif;
    color:var(--text);
    background:
        radial-gradient(circle at 24% 8%,rgba(0,200,117,.10),transparent 28%),
        radial-gradient(circle at 90% 15%,rgba(0,217,120,.10),transparent 30%),
        linear-gradient(135deg,#fbfffd,#eefbf5);
    overflow-x:hidden;
}
h1,h2,h3,h4,h5,.brand-title,.page-title{font-family:"Fredoka",sans-serif;letter-spacing:.1px}
.layout{display:flex;min-height:100vh}

.sidebar{
    width:292px;
    min-height:100vh;
    position:fixed;
    top:0;
    left:0;
    color:white;
    padding:28px 22px;
    display:flex;
    flex-direction:column;
    background:
        radial-gradient(circle at 10% 0%,rgba(0,217,120,.22),transparent 35%),
        linear-gradient(180deg,#00452a,#005934 52%,#00371f);
    box-shadow:18px 0 55px rgba(0,61,37,.24);
    z-index:1000;
}
.brand{
    display:flex;
    align-items:center;
    gap:15px;
    margin-bottom:32px;
}
.brand-icon{
    width:66px;
    height:66px;
    border-radius:22px;
    display:grid;
    place-items:center;
    background:white;
    color:var(--green);
    font-size:2.5rem;
    box-shadow:0 16px 35px rgba(0,0,0,.22);
}
.brand-title{margin:0;color:white;font-size:2.05rem;font-weight:700}
.brand small{color:#c9f7df;font-weight:800;font-size:1rem}
.nav-menu{display:grid;gap:12px}
.nav-menu a{
    display:flex;
    align-items:center;
    gap:13px;
    padding:16px 18px;
    color:#eafff4;
    text-decoration:none;
    font-weight:900;
    border-radius:16px;
    transition:.25s;
}
.nav-menu a i{font-size:1.45rem}
.nav-menu a:hover,.nav-menu a.active{
    background:linear-gradient(135deg,rgba(0,200,117,.85),rgba(0,150,85,.78));
    box-shadow:0 14px 28px rgba(0,0,0,.12);
    transform:translateX(4px);
}
.side-separator{height:1px;background:rgba(255,255,255,.14);margin:26px 0}
.user-panel{
    margin-top:auto;
    border:1px solid rgba(255,255,255,.18);
    background:rgba(255,255,255,.08);
    border-radius:22px;
    padding:18px;
}
.user-row{display:flex;align-items:center;gap:12px}
.avatar{
    width:56px;
    height:56px;
    border-radius:50%;
    background:#fff;
    color:#005934;
    display:grid;
    place-items:center;
    font-size:1.7rem;
}
.user-panel strong{color:white}
.role-pill{
    display:block;
    margin-top:14px;
    border-radius:10px;
    padding:10px;
    text-align:center;
    background:linear-gradient(135deg,#00a85a,#00d978);
    color:white;
    font-weight:900;
}
.side-footer{margin-top:26px;color:#c9f7df;font-size:.82rem}

.main{
    margin-left:292px;
    width:calc(100% - 292px);
    padding:28px 28px 38px;
}
.topbar{
    display:flex;
    justify-content:space-between;
    align-items:center;
    gap:18px;
    margin-bottom:28px;
}
.top-left{display:flex;align-items:center;gap:18px}
.menu-btn{
    width:46px;
    height:46px;
    border:0;
    border-radius:14px;
    background:white;
    display:grid;
    place-items:center;
    box-shadow:var(--shadow);
    font-size:1.45rem;
    color:#0f172a;
}
.page-title{
    margin:0;
    display:flex;
    align-items:center;
    gap:14px;
    color:#0f172a;
    font-size:2.25rem;
    font-weight:700;
}
.page-title i{color:var(--green);font-size:2.5rem}
.top-actions{display:flex;align-items:center;gap:22px;color:#0f172a;font-weight:800}
.top-actions i{font-size:1.35rem}
.notification{position:relative}
.notification span{
    position:absolute;
    top:-9px;
    right:-11px;
    width:21px;
    height:21px;
    border-radius:50%;
    display:grid;
    place-items:center;
    background:#ef4444;
    color:white;
    font-size:.72rem;
    font-weight:900;
}

.quick-actions{
    display:flex;
    gap:10px;
    flex-wrap:wrap;
    margin-bottom:22px;
}
.quick-btn{
    border:0;
    border-radius:12px;
    padding:12px 16px;
    font-weight:900;
    color:white;
    text-decoration:none;
    display:inline-flex;
    align-items:center;
    gap:8px;
    background:linear-gradient(135deg,#00a85a,#00d978);
    box-shadow:0 12px 26px rgba(0,168,90,.18);
}
.quick-btn.blue{background:linear-gradient(135deg,#2f80ed,#56a3ff)}
.quick-btn.orange{background:linear-gradient(135deg,#ff9f2d,#ffb45b)}
.quick-btn.purple{background:linear-gradient(135deg,#7c5cff,#9b7bff)}
.quick-btn.dark{background:linear-gradient(135deg,#003d25,#006b44)}

.stats{
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:18px;
    margin-bottom:22px;
}
.stat-card{
    background:rgba(255,255,255,.94);
    border:1px solid rgba(15,23,42,.08);
    border-radius:12px;
    min-height:184px;
    padding:24px;
    position:relative;
    overflow:hidden;
    box-shadow:var(--shadow);
}
.stat-top{display:flex;gap:18px;align-items:flex-start}
.stat-icon{
    width:64px;
    height:64px;
    border-radius:15px;
    display:grid;
    place-items:center;
    color:white;
    font-size:2.25rem;
    box-shadow:0 16px 28px rgba(0,0,0,.13);
}
.stat-icon.green{background:linear-gradient(135deg,#00a85a,#00d978)}
.stat-icon.blue{background:linear-gradient(135deg,#2f80ed,#56a3ff)}
.stat-icon.orange{background:linear-gradient(135deg,#ff9f2d,#ffb45b)}
.stat-icon.purple{background:linear-gradient(135deg,#7c5cff,#9b7bff)}
.stat-card h3{margin:0;font-size:1.05rem;font-weight:800}
.stat-card h2{margin:9px 0 2px;font-family:"Nunito",sans-serif;font-size:2.2rem;font-weight:900;color:#0f172a}
.stat-card p{color:var(--muted);margin:0;font-weight:700}
.spark{position:absolute;left:18px;right:18px;bottom:0;height:54px;opacity:.78}
.spark svg{width:100%;height:100%}

.grid-2{
    display:grid;
    grid-template-columns:1.15fr .85fr;
    gap:20px;
    margin-bottom:20px;
}
.grid-2.bottom{grid-template-columns:1fr 1fr}
.panel{
    background:rgba(255,255,255,.96);
    border:1px solid rgba(15,23,42,.08);
    border-radius:12px;
    box-shadow:var(--shadow);
    overflow:hidden;
    margin-bottom:20px;
}
.panel-head{
    padding:18px 20px;
    border-bottom:1px solid rgba(15,23,42,.08);
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:14px;
    flex-wrap:wrap;
}
.panel-title{margin:0;display:flex;align-items:center;gap:10px;font-size:1.2rem;font-weight:800}
.panel-title i{color:var(--green)}
.panel-body{padding:20px}
.view-btn{
    border:0;
    background:linear-gradient(135deg,#00a85a,#00d978);
    color:white;
    font-weight:900;
    border-radius:8px;
    padding:8px 13px;
    text-decoration:none;
}
.search-box{
    width:100%;
    max-width:360px;
    border:1px solid rgba(15,23,42,.10);
    border-radius:12px;
    padding:11px 14px;
    font-weight:800;
    outline:none;
}
.search-box:focus{border-color:#00a85a;box-shadow:0 0 0 .2rem rgba(0,168,90,.12)}

.line-chart{height:250px;position:relative;padding:12px 12px 0 58px}
.chart-grid{
    position:absolute;
    inset:12px 18px 38px 58px;
    background:
        linear-gradient(to bottom, transparent calc(25% - 1px), rgba(15,23,42,.08) 25%, transparent calc(25% + 1px)),
        linear-gradient(to bottom, transparent calc(50% - 1px), rgba(15,23,42,.08) 50%, transparent calc(50% + 1px)),
        linear-gradient(to bottom, transparent calc(75% - 1px), rgba(15,23,42,.08) 75%, transparent calc(75% + 1px));
}
.y-labels{
    position:absolute;
    left:10px;
    top:11px;
    bottom:38px;
    display:flex;
    flex-direction:column;
    justify-content:space-between;
    color:#334155;
    font-size:.85rem;
    font-weight:700;
}
.chart-svg{position:absolute;inset:12px 18px 38px 58px}
.x-labels{
    position:absolute;
    left:58px;
    right:18px;
    bottom:13px;
    display:grid;
    grid-template-columns:repeat(7,1fr);
    text-align:center;
    color:#334155;
    font-weight:700;
    font-size:.85rem;
}

.alert-list{display:grid;gap:14px}
.alert-item{
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:16px;
    padding:18px;
    border-radius:10px;
    cursor:pointer;
    border:0;
    text-align:left;
}
.alert-left{display:flex;align-items:center;gap:15px}
.alert-icon{
    width:45px;
    height:45px;
    border-radius:50%;
    display:grid;
    place-items:center;
    color:white;
    font-size:1.35rem;
}
.alert-item h4{margin:0 0 4px;font-family:"Nunito",sans-serif;font-weight:900;font-size:1rem}
.alert-item p{margin:0;color:#334155}
.alert-red{background:#fff0f0}
.alert-red .alert-icon{background:#ef4444}
.alert-orange{background:#fff7e8}
.alert-orange .alert-icon{background:#ff9f2d}
.alert-blue{background:#eff6ff}
.alert-blue .alert-icon{background:#2f80ed}

.table{margin:0}
.table thead th{
    color:#00824b;
    font-size:.78rem;
    text-transform:uppercase;
    letter-spacing:.04em;
    font-weight:900;
    background:#fbfffd;
    border-bottom:1px solid rgba(15,23,42,.08);
}
.table tbody td{vertical-align:middle;font-weight:700}
.badge-status{
    border-radius:10px;
    padding:7px 12px;
    font-weight:900;
    display:inline-flex;
    align-items:center;
    gap:5px;
}
.badge-pendiente{background:#fff2d9;color:#e07800}
.badge-confirmada{background:#dfffe9;color:#00824b}
.badge-cancelada{background:#ffe0e0;color:#e11d48}
.badge-realizada{background:#e0f2fe;color:#0369a1}
.badge-bajo{background:#ffe0e0;color:#e11d48}
.badge-ok{background:#dfffe9;color:#00824b}
.icon-btn{
    width:34px;
    height:34px;
    border:0;
    border-radius:8px;
    display:grid;
    place-items:center;
    color:white;
    font-size:1.15rem;
    box-shadow:0 8px 18px rgba(0,0,0,.10);
}
.icon-ok{background:#00a85a}
.icon-x{background:#ef4444}
.icon-edit{background:#2f80ed}
.action-row{display:flex;gap:8px}
.product-mini{display:flex;align-items:center;gap:10px}
.product-img{
    width:36px;
    height:36px;
    border-radius:8px;
    background-size:cover;
    background-position:center;
    background-color:#f1f5f9;
}
.tab-content{display:none}
.tab-content.active{display:block}

.modalx{
    position:fixed;
    inset:0;
    background:rgba(0,30,18,.62);
    z-index:2000;
    display:none;
    align-items:center;
    justify-content:center;
    padding:20px;
}
.modalx.show{display:flex}
.modal-cardx{
    width:min(760px,100%);
    background:white;
    border-radius:20px;
    box-shadow:0 35px 100px rgba(0,0,0,.30);
    overflow:hidden;
}
.modal-headx{
    padding:20px 22px;
    background:linear-gradient(135deg,#003d25,#00a85a);
    color:white;
    display:flex;
    justify-content:space-between;
    align-items:center;
}
.modal-headx h3{color:white;margin:0}
.modal-close{
    border:0;
    width:38px;
    height:38px;
    border-radius:12px;
    background:rgba(255,255,255,.15);
    color:white;
    font-size:1.5rem;
}
.modal-bodyx{padding:22px}
.form-grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:14px;
}
.form-grid .full{grid-column:1/-1}
.form-label{font-weight:900;color:#064e3b}
.form-control,.form-select{
    border-radius:12px;
    padding:12px 13px;
    border:1px solid rgba(15,23,42,.12);
}
.btn-save{
    border:0;
    border-radius:12px;
    padding:12px 18px;
    background:linear-gradient(135deg,#00a85a,#00d978);
    color:white;
    font-weight:900;
}
.btn-cancel{
    border:0;
    border-radius:12px;
    padding:12px 18px;
    background:#f1f5f9;
    color:#0f172a;
    font-weight:900;
}

@media(max-width:1250px){
    .stats{grid-template-columns:repeat(2,1fr)}
    .grid-2,.grid-2.bottom{grid-template-columns:1fr}
}
@media(max-width:900px){
    .layout{display:block}
    .sidebar{position:relative;width:100%;min-height:auto}
    .main{margin-left:0;width:100%;padding:20px}
    .topbar{align-items:flex-start;flex-direction:column}
}
@media(max-width:620px){
    .stats{grid-template-columns:1fr}
    .page-title{font-size:1.7rem}
    .form-grid{grid-template-columns:1fr}
    .form-grid .full{grid-column:auto}
}

.logout-top{
    background:#ef4444;
    color:white;
    padding:9px 14px;
    border-radius:12px;
    text-decoration:none;
    font-weight:900;
    display:inline-flex;
    align-items:center;
    gap:7px;
    box-shadow:0 12px 25px rgba(239,68,68,.18);
}
.logout-top:hover{color:white;transform:translateY(-2px)}
.notification{cursor:pointer;position:relative}
.noti-box{
    display:none;
    position:fixed !important;
    right:20px;
    top:72px;
    width:360px;
    max-height:80vh;
    overflow-y:auto;
    background:white;
    border:1.5px solid rgba(0,168,90,.22);
    border-radius:22px;
    box-shadow:0 32px 90px rgba(0,30,18,.38), 0 0 0 1px rgba(0,168,90,.1),
               inset 0 1px 0 rgba(255,255,255,.8);
    padding:18px;
    z-index:2147483647 !important;
    transform:none !important;
}
.noti-box.show{display:block}
.noti-title{
    font-weight:900;
    color:#003d25;
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:10px;
}
.noti-item{
    display:flex;
    gap:10px;
    align-items:flex-start;
    padding:12px;
    border-radius:12px;
    margin-top:8px;
    background:#f8fffb;
}
.noti-item.warning{background:#fff7e8;color:#9a4b00}
.noti-item.danger{background:#fff0f0;color:#b91c1c}
.noti-item.ok{background:#eafff4;color:#007f4f}
.noti-item i{font-size:1.35rem}
.toastx{
    position:fixed;
    right:24px;
    bottom:24px;
    background:#003d25;
    color:white;
    border-radius:16px;
    padding:14px 18px;
    box-shadow:0 22px 70px rgba(0,30,18,.30);
    display:none;
    z-index:4000;
    font-weight:900;
}
.toastx.show{display:flex;align-items:center;gap:9px}

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
</style>


<script>!function(){var t=localStorage.getItem("clinipetTheme")||"light";var m={"dark":["theme-dark","dark-mode"],"neon":["theme-neon","neon-mode"]};if(m[t])m[t].forEach(function(c){document.documentElement.classList.add(c)});}();</script><script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</head>


<body>
<div class="layout">

    <aside class="sidebar">
        <div class="brand">
            <div class="brand-icon"><i class="ti ti-paw"></i></div>
            <div>
                <h2 class="brand-title">CliniPet</h2>
                <small>Administración</small>
            </div>
        </div>

        <nav class="nav-menu">
            <a class="active nav-tab" href="#" data-tab="resumen"><i class="ti ti-home"></i> Dashboard</a>
            <a class="nav-tab" href="#" data-tab="usuarios"><i class="ti ti-users"></i> Usuarios</a>
            <a class="nav-tab" href="#" data-tab="veterinarios"><i class="ti ti-stethoscope"></i> Veterinarios</a>
            <a class="nav-tab" href="#" data-tab="stock"><i class="ti ti-package"></i> Stock</a>
            <a class="nav-tab" href="#" data-tab="ventas"><i class="ti ti-shopping-cart"></i> Ventas</a>
        </nav>

        <div class="side-separator"></div>

        <nav class="nav-menu">
            <a href="${pageContext.request.contextPath}/perfil"><i class="ti ti-user-cog"></i> Mi perfil</a>
            <a href="${pageContext.request.contextPath}/logout"><i class="ti ti-logout"></i> Cerrar sesión</a>
        </nav>

        <div class="user-panel">
            <a href="${pageContext.request.contextPath}/perfil" class="user-row" style="text-decoration:none;color:inherit">
                <% if (usuario != null && usuario.getAvatarUrlOrNull() != null) { %>
                    <div class="avatar" style="padding:0;overflow:hidden"><img src="${pageContext.request.contextPath}<%= usuario.getAvatarUrlOrNull() %>" alt="avatar" style="width:100%;height:100%;object-fit:cover;border-radius:inherit"/></div>
                <% } else { %>
                    <div class="avatar"><i class="ti ti-user"></i></div>
                <% } %>
                <div>
                    <strong><%= usuario != null ? usuario.getNombre() : "Administrador" %></strong><br>
                    <span class="opacity-75">Editar perfil</span>
                </div>
            </a>
            <span class="role-pill">Rol: <%= usuario != null ? usuario.getRol() : "Administrador" %></span>
        </div>

        <div class="side-footer">
            <h3 class="text-white mb-1"><i class="ti ti-paw"></i> CliniPet</h3>
            <span>Clínica Veterinaria</span><br><br>
            <small>© 2026 CliniPet.</small>
        </div>
    </aside>

    <main class="main">
        <div class="topbar">
            <div class="top-left">
                <button class="menu-btn" type="button"><i class="ti ti-menu-2"></i></button>
                <h1 class="page-title"><i class="ti ti-paw"></i> Dashboard administrativo</h1>
            </div>

            <div class="top-actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-top">
                    <i class="ti ti-logout"></i> Cerrar sesión
                </a>

                <span><i class="ti ti-clock"></i> 29/04/2026 16:35</span>

                <div class="notification" id="bellBtn" onclick="toggleNoti(event)">
                    <i class="ti ti-bell"></i>
                    <span><%= (stockBajo + citasPendientes + ventasPendientes) %></span>
                </div>
            </div>
        </div>

        <div class="quick-actions">
            <button class="quick-btn" type="button" onclick="openModal('modalProducto')"><i class="ti ti-plus"></i> Nuevo producto</button>
            <button class="quick-btn blue" type="button" onclick="openModal('modalUsuario')"><i class="ti ti-user-plus"></i> Nuevo usuario</button>
            <button class="quick-btn orange" type="button" onclick="openModal('modalVeterinario')"><i class="ti ti-stethoscope"></i> Nuevo veterinario</button>
            <a class="quick-btn purple" href="${pageContext.request.contextPath}/citas/nueva"><i class="ti ti-calendar-plus"></i> Nueva cita</a>
            <button class="quick-btn dark" type="button" onclick="generarPDF()"><i class="ti ti-file-type-pdf"></i> Exportar PDF</button>
        </div>

        <!-- RESUMEN -->
        <section id="tab-resumen" class="tab-content active">
            <section class="stats">
                <div class="stat-card">
                    <div class="stat-top">
                        <div class="stat-icon green"><i class="ti ti-calendar"></i></div>
                        <div>
                            <h3>Citas de hoy</h3>
                            <h2><%= citasHoy %></h2>
                            <p>Total citas programadas</p>
                        </div>
                    </div>
                    <div class="spark"><svg viewBox="0 0 300 60" preserveAspectRatio="none"><path d="M0 45 C30 43,40 50,65 35 C90 20,110 43,135 36 C155 30,165 44,185 33 C205 18,220 15,240 28 C260 40,275 8,300 16 L300 60 L0 60 Z" fill="rgba(0,200,117,.15)"></path><path d="M0 45 C30 43,40 50,65 35 C90 20,110 43,135 36 C155 30,165 44,185 33 C205 18,220 15,240 28 C260 40,275 8,300 16" fill="none" stroke="#00a85a" stroke-width="3"></path></svg></div>
                </div>

                <div class="stat-card">
                    <div class="stat-top">
                        <div class="stat-icon blue"><i class="ti ti-cash"></i></div>
                        <div>
                            <h3>Ingresos totales</h3>
                            <h2>$<%= String.format("%,.0f", totalIngresos) %></h2>
                            <p>Ventas: $<%= String.format("%,.0f", totalVentas) %> &nbsp;|&nbsp; Citas: $<%= String.format("%,.0f", totalCitas) %></p>
                        </div>
                    </div>
                    <div class="spark"><svg viewBox="0 0 300 60" preserveAspectRatio="none"><path d="M0 45 C30 38,45 52,75 28 C105 10,125 44,150 35 C175 20,185 18,210 31 C235 45,245 8,270 15 C285 20,292 10,300 12 L300 60 L0 60 Z" fill="rgba(47,128,237,.14)"></path><path d="M0 45 C30 38,45 52,75 28 C105 10,125 44,150 35 C175 20,185 18,210 31 C235 45,245 8,270 15 C285 20,292 10,300 12" fill="none" stroke="#2f80ed" stroke-width="3"></path></svg></div>
                </div>

                <div class="stat-card">
                    <div class="stat-top">
                        <div class="stat-icon orange"><i class="ti ti-package"></i></div>
                        <div>
                            <h3>Stock bajo</h3>
                            <h2><%= stockBajo %></h2>
                            <p>Productos bajos</p>
                        </div>
                    </div>
                    <div class="spark"><svg viewBox="0 0 300 60" preserveAspectRatio="none"><path d="M0 35 C25 40,45 55,70 42 C95 28,115 54,140 42 C160 30,175 50,195 35 C215 18,235 22,250 35 C270 48,285 20,300 25 L300 60 L0 60 Z" fill="rgba(255,159,45,.15)"></path><path d="M0 35 C25 40,45 55,70 42 C95 28,115 54,140 42 C160 30,175 50,195 35 C215 18,235 22,250 35 C270 48,285 20,300 25" fill="none" stroke="#ff9f2d" stroke-width="3"></path></svg></div>
                </div>

                <div class="stat-card">
                    <div class="stat-top">
                        <div class="stat-icon purple"><i class="ti ti-file-description"></i></div>
                        <div>
                            <h3>Doctores</h3>
                            <h2><%= veterinarios.size() %></h2>
                            <p>Total doctores</p>
                        </div>
                    </div>
                    <div class="spark"><svg viewBox="0 0 300 60" preserveAspectRatio="none"><path d="M0 43 C25 38,45 50,70 24 C95 0,115 42,140 37 C160 34,175 48,195 33 C215 18,235 25,250 17 C270 5,285 8,300 13 L300 60 L0 60 Z" fill="rgba(124,92,255,.13)"></path><path d="M0 43 C25 38,45 50,70 24 C95 0,115 42,140 37 C160 34,175 48,195 33 C215 18,235 25,250 17 C270 5,285 8,300 13" fill="none" stroke="#7c5cff" stroke-width="3"></path></svg></div>
                </div>
            </section>

            <section class="grid-2">
                <div class="panel">
                    <div class="panel-head"><h3 class="panel-title"><i class="ti ti-chart-bar"></i> Ventas - Últimos 7 días</h3></div>
                    <div class="panel-body">
                        <div class="line-chart">
                            <div class="chart-grid"></div>
                            <div class="y-labels"><span>$1.500.000</span><span>$1.200.000</span><span>$900.000</span><span>$600.000</span><span>$300.000</span><span>$0</span></div>
                            <svg class="chart-svg" viewBox="0 0 700 230" preserveAspectRatio="none">
                                <defs><linearGradient id="areaGreen" x1="0" x2="0" y1="0" y2="1"><stop offset="0%" stop-color="#00a85a" stop-opacity=".26"/><stop offset="100%" stop-color="#00a85a" stop-opacity=".02"/></linearGradient></defs>
                                <path d="M0 170 L116 135 L232 165 L348 95 L464 148 L580 118 L700 105 L700 230 L0 230 Z" fill="url(#areaGreen)"></path>
                                <path d="M0 170 L116 135 L232 165 L348 95 L464 148 L580 118 L700 105" fill="none" stroke="#009b56" stroke-width="4"></path>
                                <circle cx="0" cy="170" r="7" fill="#009b56"></circle><circle cx="116" cy="135" r="7" fill="#009b56"></circle><circle cx="232" cy="165" r="7" fill="#009b56"></circle><circle cx="348" cy="95" r="7" fill="#009b56"></circle><circle cx="464" cy="148" r="7" fill="#009b56"></circle><circle cx="580" cy="118" r="7" fill="#009b56"></circle><circle cx="700" cy="105" r="7" fill="#009b56"></circle>
                            </svg>
                            <div class="x-labels"><span>23 Abr</span><span>24 Abr</span><span>25 Abr</span><span>26 Abr</span><span>27 Abr</span><span>28 Abr</span><span>29 Abr</span></div>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-head"><h3 class="panel-title"><i class="ti ti-alert-triangle text-warning"></i> Alertas importantes</h3></div>
                    <div class="panel-body">
                        <div class="alert-list">
                            <button class="alert-item alert-red" type="button" onclick="showTab('citas')">
                                <div class="alert-left"><div class="alert-icon"><i class="ti ti-exclamation-mark"></i></div><div><h4><%= citasPendientes %> citas pendientes por confirmar</h4><p>Hay citas que necesitan confirmación</p></div></div>
                                <i class="ti ti-chevron-right"></i>
                            </button>

                            <button class="alert-item alert-orange" type="button" onclick="showTab('stock')">
                                <div class="alert-left"><div class="alert-icon"><i class="ti ti-alert-triangle"></i></div><div><h4><%= stockBajo %> productos con stock bajo</h4><p>Productos que necesitan reposición</p></div></div>
                                <i class="ti ti-chevron-right"></i>
                            </button>

                            <button class="alert-item alert-blue" type="button" onclick="showTab('veterinarios')">
                                <div class="alert-left"><div class="alert-icon"><i class="ti ti-info-circle"></i></div><div><h4>Revisar doctores disponibles</h4><p>Antes de asignar una nueva cita</p></div></div>
                                <i class="ti ti-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </section>

            <section class="grid-2 bottom">
                <div class="panel">
                    <div class="panel-head">
                        <h3 class="panel-title"><i class="ti ti-calendar"></i> Citas de hoy</h3>
                        <button class="view-btn" type="button" onclick="showTab('citas')">Ver todas</button>
                    </div>
                    <div class="table-responsive">
                        <table class="table card-table">
                            <thead><tr><th>Hora</th><th>Paciente</th><th>Mascota</th><th>Servicio</th><th>Estado</th><th>Acciones</th></tr></thead>
                            <tbody>
                                <% for(Map<String,Object> c : citas){ 
                                    String estado = String.valueOf(c.get("estado"));
                                    String claseEstado = "badge-pendiente";
                                    if ("CONFIRMADA".equalsIgnoreCase(estado)) claseEstado = "badge-confirmada";
                                    if ("CANCELADA".equalsIgnoreCase(estado)) claseEstado = "badge-cancelada";
                                    if ("REALIZADA".equalsIgnoreCase(estado)) claseEstado = "badge-realizada";
                                %>
                                <tr>
                                    <td><%= c.get("hora") %></td>
                                    <td><%= c.get("duenio") %></td>
                                    <td><i class="ti ti-paw"></i> <%= c.get("mascota") %></td>
                                    <td><%= c.get("motivo") %></td>
                                    <td><span class="badge-status <%= claseEstado %>"><%= estado %></span></td>
                                    <td>
                                        <div class="action-row">
                                            <form method="post" action="${pageContext.request.contextPath}/citas/realizada">
                                                <input type="hidden" name="id" value="<%= c.get("id") != null ? c.get("id") : c.get("id_cita") %>">
                                                <button class="icon-btn icon-ok" title="Realizada"><i class="ti ti-check"></i></button>
                                            </form>
                                            <form method="post" action="${pageContext.request.contextPath}/citas/cancelar">
                                                <input type="hidden" name="id" value="<%= c.get("id") != null ? c.get("id") : c.get("id_cita") %>">
                                                <button class="icon-btn icon-x" title="Cancelar"><i class="ti ti-x"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                                <% if(citas.isEmpty()){ %><tr><td colspan="6" class="text-center text-secondary p-4">No hay citas registradas.</td></tr><% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-head">
                        <h3 class="panel-title"><i class="ti ti-package"></i> Productos en inventario</h3>
                        <button class="view-btn" type="button" onclick="showTab('stock')">Ver todos</button>
                    </div>
                    <div class="table-responsive">
                        <table class="table card-table">
                            <thead><tr><th>Producto</th><th>Categoría</th><th>Precio</th><th>Stock</th><th>Estado</th></tr></thead>
                            <tbody>
                                <%
                                int contadorProductos = 0;
                                for(Map<String,Object> p : productos){
                                    if(contadorProductos >= 5) break;
                                    contadorProductos++;
                                    int stock = 0;
                                    int stockMinimo = 5;
                                    try { stock = Integer.parseInt(String.valueOf(p.get("stock"))); } catch(Exception e) {}
                                    try { stockMinimo = Integer.parseInt(String.valueOf(p.get("stock_minimo"))); } catch(Exception e) {}
                                    boolean bajo = stock <= stockMinimo;
                                %>
                                <tr>
                                    <td><div class="product-mini"><div class="product-img" style="background-image:url('<%= p.get("imagen_url") != null ? p.get("imagen_url") : "" %>')"></div><strong><%= p.get("nombre") %></strong></div></td>
                                    <td><%= p.get("categoria") %></td>
                                    <td>$<%= p.get("precio") %></td>
                                    <td class="<%= bajo ? "text-danger fw-bold" : "text-success fw-bold" %>"><%= stock %></td>
                                    <td><span class="badge-status <%= bajo ? "badge-bajo" : "badge-ok" %>"><%= bajo ? "Stock bajo" : "Disponible" %></span></td>
                                </tr>
                                <% } %>
                                <% if(productos.isEmpty()){ %><tr><td colspan="5" class="text-center text-secondary p-4">No hay productos cargados.</td></tr><% } %>
                                <% if(productos.size() > 5){ %>
                                <tr>
                                    <td colspan="5" class="text-center p-3">
                                        <button class="view-btn" type="button" onclick="showTab('stock')" style="width:100%">
                                            <i class="ti ti-chevron-down"></i> Ver todos los productos (<%= productos.size() %>)
                                        </button>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </section>

        <!-- CITAS COMPLETAS -->
        <section id="tab-citas" class="tab-content">
            <div class="panel">
                <div class="panel-head">
                    <h3 class="panel-title"><i class="ti ti-calendar"></i> Todas las citas</h3>
                    <input type="text" class="search-box table-search" data-target="tablaTodasCitas" placeholder="Buscar cita...">
                </div>
                <div class="table-responsive">
                    <table class="table card-table" id="tablaTodasCitas">
                        <thead><tr><th>ID</th><th>Dueño</th><th>Mascota</th><th>Doctor</th><th>Fecha</th><th>Hora</th><th>Motivo</th><th>Precio</th><th>Estado</th><th>Acciones</th></tr></thead>
                        <tbody>
                        <% for(Map<String,Object> c : citas){ %>
                            <tr>
                                <td><%= c.get("id") != null ? c.get("id") : c.get("id_cita") %></td>
                                <td><%= c.get("duenio") %></td>
                                <td><%= c.get("mascota") %></td>
                                <td><%= c.get("doctor") != null ? c.get("doctor") : c.get("veterinario") %></td>
                                <td><%= c.get("fecha") %></td>
                                <td><%= c.get("hora") %></td>
                                <td><%= c.get("motivo") %></td>
                                <td>$<%= c.get("precio") != null ? c.get("precio") : "0" %></td>
                                <td><span class="badge-status badge-pendiente"><%= c.get("estado") %></span></td>
                                <td>
                                    <div class="action-row">
                                        <button class="icon-btn icon-edit" type="button" onclick="openEditCita(this)" data-id="<%= c.get("id") != null ? c.get("id") : c.get("id_cita") %>" data-duenio="<%= c.get("duenio") %>" data-mascota="<%= c.get("mascota") %>" data-doctor="<%= c.get("doctor") != null ? c.get("doctor") : c.get("veterinario") %>" data-fecha="<%= c.get("fecha") %>" data-hora="<%= c.get("hora") %>" data-motivo="<%= c.get("motivo") %>" data-precio="<%= c.get("precio") != null ? c.get("precio") : "0" %>" data-estado="<%= c.get("estado") %>"><i class="ti ti-edit"></i></button>
                                        <form method="post" action="${pageContext.request.contextPath}/citas/realizada"><input type="hidden" name="id" value="<%= c.get("id") != null ? c.get("id") : c.get("id_cita") %>"><button class="icon-btn icon-ok"><i class="ti ti-check"></i></button></form>
                                        <form method="post" action="${pageContext.request.contextPath}/citas/cancelar"><input type="hidden" name="id" value="<%= c.get("id") != null ? c.get("id") : c.get("id_cita") %>"><button class="icon-btn icon-x"><i class="ti ti-x"></i></button></form>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                        <% if(citas.isEmpty()){ %><tr><td colspan="10" class="text-center text-secondary p-4">No hay citas.</td></tr><% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <!-- USUARIOS -->
        <section id="tab-usuarios" class="tab-content">
            <div class="panel">
                <div class="panel-head">
                    <h3 class="panel-title"><i class="ti ti-users"></i> Usuarios registrados</h3>
                    <div class="d-flex gap-2 flex-wrap">
                        <input type="text" class="search-box table-search" data-target="tablaUsuarios" placeholder="Buscar usuario...">
                        <button class="view-btn" type="button" onclick="openModal('modalUsuario')">Agregar usuario</button>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table card-table" id="tablaUsuarios">
                        <thead><tr><th>ID</th><th>Nombre</th><th>Correo</th><th>Rol</th><th>Estado</th><th>Acciones</th></tr></thead>
                        <tbody>
                        <% for(Map<String,Object> u : usuarios){ %>
                            <tr>
                                <td><%= u.get("id") != null ? u.get("id") : u.get("id_usuario") %></td>
                                <td><strong><%= u.get("nombre") %></strong></td>
                                <td><%= u.get("correo") %></td>
                                <td><span class="badge-status badge-ok"><%= u.get("rol") %></span></td>
                                <td><%= u.get("estado") != null ? u.get("estado") : "ACTIVO" %></td>
                                <td>
                                    <div class="action-row">
                                        <button class="icon-btn icon-edit" type="button" onclick="openEditUsuario(this)" data-id="<%= u.get("id") != null ? u.get("id") : u.get("id_usuario") %>" data-nombre="<%= u.get("nombre") %>" data-correo="<%= u.get("correo") %>" data-rol="<%= u.get("rol") %>" data-estado="<%= u.get("estado") != null ? u.get("estado") : "ACTIVO" %>"><i class="ti ti-edit"></i></button>
                                        <form method="post" action="${pageContext.request.contextPath}/usuarios/eliminar" onsubmit="return confirm('¿Eliminar usuario?');"><input type="hidden" name="id" value="<%= u.get("id") != null ? u.get("id") : u.get("id_usuario") %>"><button class="icon-btn icon-x"><i class="ti ti-trash"></i></button></form>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                        <% if(usuarios.isEmpty()){ %><tr><td colspan="6" class="text-center text-secondary p-4">No hay usuarios cargados desde el servlet.</td></tr><% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <!-- VETERINARIOS -->
        <section id="tab-veterinarios" class="tab-content">
            <div class="panel">
                <div class="panel-head">
                    <h3 class="panel-title"><i class="ti ti-stethoscope"></i> Veterinarios</h3>
                    <div class="d-flex gap-2 flex-wrap">
                        <input type="text" class="search-box table-search" data-target="tablaVeterinarios" placeholder="Buscar veterinario...">
                        <button class="view-btn" type="button" onclick="openModal('modalVeterinario')">Agregar veterinario</button>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table card-table" id="tablaVeterinarios">
                        <thead><tr><th>ID</th><th>Nombre</th><th>Correo</th><th>Teléfono</th><th>Especialidad</th><th>Estado</th><th>Acceso</th><th>Acciones</th></tr></thead>
                        <tbody>
                        <% for(Map<String,Object> v : veterinarios){ 
                            boolean tieneAcceso = v.get("id_usuario") != null && !String.valueOf(v.get("id_usuario")).equals("null") && !String.valueOf(v.get("id_usuario")).equals("0");
                        %>
                            <tr>
                                <td><%= v.get("id") != null ? v.get("id") : v.get("id_veterinario") %></td>
                                <td><strong><%= v.get("nombre") %></strong></td>
                                <td><%= v.get("correo") %></td>
                                <td><%= v.get("telefono") %></td>
                                <td><%= v.get("especialidad") %></td>
                                <td><span class="badge-status badge-ok"><%= v.get("estado") %></span></td>
                                <td>
                                    <% if(tieneAcceso){ %>
                                    <span class="badge-status badge-ok" title="Puede iniciar sesión en el panel"><i class="ti ti-lock-open"></i> Activo</span>
                                    <% } else { %>
                                    <span class="badge-status" style="background:#fff7ed;color:#c2410c" title="Sin contraseña asignada — usa el botón editar para asignarla"><i class="ti ti-lock"></i> Sin acceso</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="action-row">
                                        <button class="icon-btn icon-edit" type="button" onclick="openEditVeterinario(this)" data-id="<%= v.get("id") != null ? v.get("id") : v.get("id_veterinario") %>" data-nombre="<%= v.get("nombre") %>" data-correo="<%= v.get("correo") %>" data-telefono="<%= v.get("telefono") %>" data-especialidad="<%= v.get("especialidad") %>" data-estado="<%= v.get("estado") %>"><i class="ti ti-edit"></i></button>
                                        <form method="post" action="${pageContext.request.contextPath}/veterinarios/eliminar" onsubmit="return confirm('¿Eliminar veterinario?');"><input type="hidden" name="id" value="<%= v.get("id") != null ? v.get("id") : v.get("id_veterinario") %>"><button class="icon-btn icon-x"><i class="ti ti-trash"></i></button></form>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                        <% if(veterinarios.isEmpty()){ %><tr><td colspan="8" class="text-center text-secondary p-4">No hay veterinarios.</td></tr><% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <!-- STOCK COMPLETO -->
        <section id="tab-stock" class="tab-content">
            <div class="panel">
                <div class="panel-head">
                    <h3 class="panel-title"><i class="ti ti-package"></i> Todo el stock de productos</h3>
                    <div class="d-flex gap-2 flex-wrap">
                        <input type="text" class="search-box table-search" data-target="tablaStockCompleto" placeholder="Buscar producto...">
                        <button class="view-btn" type="button" onclick="openModal('modalProducto')">Agregar producto</button>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table card-table" id="tablaStockCompleto">
                        <thead><tr><th>ID</th><th>Producto</th><th>Código</th><th>Categoría</th><th>Especie</th><th>Precio</th><th>Stock</th><th>Stock mínimo</th><th>Estado</th><th>Acciones</th></tr></thead>
                        <tbody>
                        <% for(Map<String,Object> p : productos){
                            int stock = 0;
                            int minimo = 5;
                            try { stock = Integer.parseInt(String.valueOf(p.get("stock"))); } catch(Exception e) {}
                            try { minimo = Integer.parseInt(String.valueOf(p.get("stock_minimo"))); } catch(Exception e) {}
                        %>
                            <tr>
                                <td><%= p.get("id") != null ? p.get("id") : p.get("id_producto") %></td>
                                <td><div class="product-mini"><div class="product-img" style="background-image:url('<%= p.get("imagen_url") != null ? p.get("imagen_url") : "" %>')"></div><strong><%= p.get("nombre") %></strong></div></td>
                                <td><%= p.get("codigo") %></td>
                                <td><%= p.get("categoria") %></td>
                                <td><%= p.get("especie") %></td>
                                <td>$<%= p.get("precio") %></td>
                                <td class="<%= stock <= minimo ? "text-danger fw-bold" : "text-success fw-bold" %>"><%= stock %></td>
                                <td><%= minimo %></td>
                                <td><span class="badge-status <%= stock <= minimo ? "badge-bajo" : "badge-ok" %>"><%= stock <= minimo ? "Bajo" : "Disponible" %></span></td>
                                <td>
                                    <div class="action-row">
                                        <button class="icon-btn icon-edit" type="button" onclick="openEditProducto(this)" data-id="<%= p.get("id") != null ? p.get("id") : p.get("id_producto") %>" data-codigo="<%= p.get("codigo") %>" data-nombre="<%= p.get("nombre") %>" data-categoria="<%= p.get("categoria") %>" data-especie="<%= p.get("especie") %>" data-precio="<%= p.get("precio") %>" data-stock="<%= p.get("stock") %>" data-stockminimo="<%= p.get("stock_minimo") %>" data-imagen="<%= p.get("imagen_url") %>"><i class="ti ti-edit"></i></button>
                                        <form method="post" action="${pageContext.request.contextPath}/productos/eliminar" onsubmit="return confirm('¿Eliminar producto?');"><input type="hidden" name="id" value="<%= p.get("id") != null ? p.get("id") : p.get("id_producto") %>"><button class="icon-btn icon-x"><i class="ti ti-trash"></i></button></form>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                        <% if(productos.isEmpty()){ %><tr><td colspan="10" class="text-center text-secondary p-4">No hay productos cargados.</td></tr><% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <!-- VENTAS -->
        <section id="tab-ventas" class="tab-content">
            <div class="panel">
                <div class="panel-head">
                    <h3 class="panel-title"><i class="ti ti-shopping-cart"></i> Ventas y pedidos</h3>
                    <input type="text" class="search-box table-search" data-target="tablaVentas" placeholder="Buscar venta...">
                </div>
                <div class="table-responsive">
                    <table class="table card-table" id="tablaVentas">
                        <thead><tr><th>ID</th><th>Cliente</th><th>Fecha</th><th>Total</th><th>Método</th><th>Estado</th><th>Acciones</th></tr></thead>
                        <tbody>
                        <% for(Map<String,Object> v : ventas){ %>
                            <tr>
                                <td><%= v.get("id") != null ? v.get("id") : v.get("id_venta") %></td>
                                <td><strong><%= v.get("cliente") %></strong></td>
                                <td><%= v.get("fecha") %></td>
                                <td>$<%= v.get("total") %></td>
                                <td><%= v.get("metodo") != null ? v.get("metodo") : v.get("metodo_pago") %></td>
                                <td><span class="badge-status badge-ok"><%= v.get("estado") != null ? v.get("estado") : "RECIBIDO" %></span></td>
                                <td>
<button class="icon-btn icon-edit" type="button" title="Editar" onclick="openEditVenta(this)" data-id="<%= v.get("id") != null ? v.get("id") : v.get("id_venta") %>" data-total="<%= v.get("total") %>" data-metodo="<%= v.get("metodo") != null ? v.get("metodo") : "EFECTIVO" %>" data-estado="<%= v.get("estado") != null ? v.get("estado") : "CONFIRMADO" %>"><i class="ti ti-edit"></i></button>
<form method="post" action="${pageContext.request.contextPath}/ventas/confirmar" style="display:inline" onsubmit="return confirm('¿Confirmar esta venta?');"><input type="hidden" name="id" value="<%= v.get("id") != null ? v.get("id") : v.get("id_venta") %>"><button class="icon-btn" style="background:#00a85a;color:white" title="Confirmar"><i class="ti ti-check"></i></button></form>
<form method="post" action="${pageContext.request.contextPath}/ventas/eliminar" style="display:inline" onsubmit="return confirm('¿Eliminar esta venta?');"><input type="hidden" name="id" value="<%= v.get("id") != null ? v.get("id") : v.get("id_venta") %>"><button class="icon-btn icon-x" title="Eliminar"><i class="ti ti-trash"></i></button></form>
</td>
                            </tr>
                        <% } %>
                        <% if(ventas.isEmpty()){ %><tr><td colspan="7" class="text-center text-secondary p-4">No hay ventas registradas.</td></tr><% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

    </main>
</div>

<!-- MODAL PRODUCTO -->
<div class="modalx" id="modalProducto">
    <div class="modal-cardx">
        <div class="modal-headx">
            <h3><i class="ti ti-package"></i> Nuevo producto</h3>
            <button class="modal-close" type="button" onclick="closeModal('modalProducto')"><i class="ti ti-x"></i></button>
        </div>
        <div class="modal-bodyx">
            <form method="post" action="${pageContext.request.contextPath}/productos/guardar">
                <div class="form-grid">
                    <div><label class="form-label">Código</label><input class="form-control" name="codigo" required></div>
                    <div><label class="form-label">Nombre</label><input class="form-control" name="nombre" required></div>
                    <div><label class="form-label">Categoría</label><input class="form-control" name="categoria" required></div>
                    <div><label class="form-label">Especie</label><input class="form-control" name="especie" required></div>
                    <div><label class="form-label">Precio</label><input class="form-control" name="precio" type="number" step="0.01" required></div>
                    <div><label class="form-label">Stock</label><input class="form-control" name="stock" type="number" required></div>
                    <div><label class="form-label">Stock mínimo</label><input class="form-control" name="stock_minimo" type="number" value="5" required></div>
                    <div><label class="form-label">Fecha vencimiento</label><input class="form-control" name="fecha_vencimiento" type="date"></div>
                    <div class="full"><label class="form-label">Imagen URL</label><input class="form-control" name="imagen_url"></div>
                    <div class="full"><label class="form-label">Descripción</label><textarea class="form-control" name="descripcion" rows="3"></textarea></div>
                    <div class="full d-flex justify-content-end gap-2 mt-2">
                        <button class="btn-cancel" type="button" onclick="closeModal('modalProducto')">Cancelar</button>
                        <button class="btn-save">Guardar producto</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL USUARIO -->
<div class="modalx" id="modalUsuario">
    <div class="modal-cardx">
        <div class="modal-headx">
            <h3><i class="ti ti-user-plus"></i> Nuevo usuario</h3>
            <button class="modal-close" type="button" onclick="closeModal('modalUsuario')"><i class="ti ti-x"></i></button>
        </div>
        <div class="modal-bodyx">
            <form method="post" action="${pageContext.request.contextPath}/usuarios/guardar">
                <div class="form-grid">
                    <div><label class="form-label">Nombre</label><input class="form-control" name="nombre" required></div>
                    <div><label class="form-label">Correo</label><input class="form-control" name="correo" type="email" required></div>
                    <div><label class="form-label">Contraseña</label><input class="form-control" name="password" type="password" required></div>
                    <div><label class="form-label">Rol</label><select class="form-select" name="rol"><option>ADMIN</option><option>RECEPCIONISTA</option><option>ENFERMERO</option><option>CLIENTE</option></select></div>
                    <div class="full d-flex justify-content-end gap-2 mt-2">
                        <button class="btn-cancel" type="button" onclick="closeModal('modalUsuario')">Cancelar</button>
                        <button class="btn-save">Guardar usuario</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL VETERINARIO -->
<div class="modalx" id="modalVeterinario">
    <div class="modal-cardx">
        <div class="modal-headx">
            <h3><i class="ti ti-stethoscope"></i> Nuevo veterinario</h3>
            <button class="modal-close" type="button" onclick="closeModal('modalVeterinario')"><i class="ti ti-x"></i></button>
        </div>
        <div class="modal-bodyx">
            <form method="post" action="${pageContext.request.contextPath}/veterinarios/guardar">
                <div class="form-grid">
                    <div><label class="form-label">Nombre</label><input class="form-control" name="nombre" required></div>
                    <div><label class="form-label">Especialidad</label><input class="form-control" name="especialidad" required></div>
                    <div><label class="form-label">Correo</label><input class="form-control" name="correo" type="email" required></div>
                    <div><label class="form-label">Teléfono</label><input class="form-control" name="telefono" required></div>
                    <div><label class="form-label">Estado</label><select class="form-select" name="estado"><option>DISPONIBLE</option><option>OCUPADO</option></select></div>
                    <div><label class="form-label">Contraseña de acceso</label><input class="form-control" name="contrasena" type="password" placeholder="Para que el veterinario pueda iniciar sesión" required></div>
                    <div class="full d-flex justify-content-end gap-2 mt-2">
                        <button class="btn-cancel" type="button" onclick="closeModal('modalVeterinario')">Cancelar</button>
                        <button class="btn-save">Guardar veterinario</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>



<!-- MODAL EDITAR CITA -->
<div class="modalx" id="modalEditCita">
    <div class="modal-cardx">
        <div class="modal-headx">
            <h3><i class="ti ti-edit"></i> Editar cita</h3>
            <button class="modal-close" type="button" onclick="closeModal('modalEditCita')"><i class="ti ti-x"></i></button>
        </div>
        <div class="modal-bodyx">
            <form method="post" action="${pageContext.request.contextPath}/citas/actualizar">
                <input type="hidden" name="id" id="editCitaId">
                <div class="form-grid">
                    <div><label class="form-label">Dueño</label><input class="form-control" name="duenio" id="editCitaDuenio" readonly></div>
                    <div><label class="form-label">Mascota</label><input class="form-control" name="mascota" id="editCitaMascota" readonly></div>
                    <div><label class="form-label">Doctor</label><input class="form-control" name="doctor" id="editCitaDoctor"></div>
                    <div><label class="form-label">Fecha</label><input class="form-control" name="fecha" id="editCitaFecha" type="date"></div>
                    <div><label class="form-label">Hora</label><input class="form-control" name="hora" id="editCitaHora" type="time"></div>
                    <div><label class="form-label">Precio</label><input class="form-control" name="precio" id="editCitaPrecio" type="number" step="0.01"></div>
                    <div class="full"><label class="form-label">Motivo</label><input class="form-control" name="motivo" id="editCitaMotivo"></div>
                    <div><label class="form-label">Estado</label><select class="form-select" name="estado" id="editCitaEstado"><option>PENDIENTE</option><option>CONFIRMADA</option><option>REALIZADA</option><option>CANCELADA</option></select></div>
                    <div class="full d-flex justify-content-end gap-2 mt-2">
                        <button class="btn-cancel" type="button" onclick="closeModal('modalEditCita')">Cancelar</button>
                        <button class="btn-save">Actualizar cita</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDITAR PRODUCTO -->
<div class="modalx" id="modalEditProducto">
    <div class="modal-cardx">
        <div class="modal-headx">
            <h3><i class="ti ti-edit"></i> Editar producto</h3>
            <button class="modal-close" type="button" onclick="closeModal('modalEditProducto')"><i class="ti ti-x"></i></button>
        </div>
        <div class="modal-bodyx">
            <form method="post" action="${pageContext.request.contextPath}/productos/actualizar">
                <input type="hidden" name="id" id="editProductoId">
                <div class="form-grid">
                    <div><label class="form-label">Código</label><input class="form-control" name="codigo" id="editProductoCodigo" required></div>
                    <div><label class="form-label">Nombre</label><input class="form-control" name="nombre" id="editProductoNombre" required></div>
                    <div><label class="form-label">Categoría</label><input class="form-control" name="categoria" id="editProductoCategoria" required></div>
                    <div><label class="form-label">Especie</label><input class="form-control" name="especie" id="editProductoEspecie" required></div>
                    <div><label class="form-label">Precio</label><input class="form-control" name="precio" id="editProductoPrecio" type="number" step="0.01" required></div>
                    <div><label class="form-label">Stock</label><input class="form-control" name="stock" id="editProductoStock" type="number" required></div>
                    <div><label class="form-label">Stock mínimo</label><input class="form-control" name="stock_minimo" id="editProductoStockMinimo" type="number" required></div>
                    <div class="full"><label class="form-label">Imagen URL</label><input class="form-control" name="imagen_url" id="editProductoImagen"></div>
                    <div class="full d-flex justify-content-end gap-2 mt-2">
                        <button class="btn-cancel" type="button" onclick="closeModal('modalEditProducto')">Cancelar</button>
                        <button class="btn-save">Actualizar producto</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDITAR USUARIO -->
<div class="modalx" id="modalEditUsuario">
    <div class="modal-cardx">
        <div class="modal-headx">
            <h3><i class="ti ti-edit"></i> Editar usuario</h3>
            <button class="modal-close" type="button" onclick="closeModal('modalEditUsuario')"><i class="ti ti-x"></i></button>
        </div>
        <div class="modal-bodyx">
            <form method="post" action="${pageContext.request.contextPath}/usuarios/actualizar">
                <input type="hidden" name="id" id="editUsuarioId">
                <div class="form-grid">
                    <div><label class="form-label">Nombre</label><input class="form-control" name="nombre" id="editUsuarioNombre" required></div>
                    <div><label class="form-label">Correo</label><input class="form-control" name="correo" id="editUsuarioCorreo" type="email" required></div>
                    <div><label class="form-label">Rol</label>
                        <select class="form-select" name="rol" id="editUsuarioRol">
                            <option value="ADMIN">ADMIN</option>
                            <option value="ADMINISTRADOR">ADMINISTRADOR</option>
                            <option value="RECEPCIONISTA">RECEPCIONISTA</option>
                            <option value="ENFERMERO">ENFERMERO</option>
                            <option value="VETERINARIO">VETERINARIO</option>
                            <option value="CLIENTE">CLIENTE</option>
                        </select>
                    </div>
                    <div><label class="form-label">Estado</label>
                        <select class="form-select" name="estado" id="editUsuarioEstado">
                            <option value="ACTIVO">ACTIVO</option>
                            <option value="INACTIVO">INACTIVO</option>
                        </select>
                    </div>
                    <div class="full">
                        <label class="form-label">Nueva contraseña <span style="color:#94a3b8;font-weight:400">(dejar vacío para no cambiar)</span></label>
                        <input class="form-control" name="nueva_contrasena" id="editUsuarioPass" type="password" placeholder="Nueva contraseña (opcional)">
                    </div>
                    <div class="full d-flex justify-content-end gap-2 mt-2">
                        <button class="btn-cancel" type="button" onclick="closeModal('modalEditUsuario')">Cancelar</button>
                        <button class="btn-save">Actualizar usuario</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDITAR VETERINARIO -->
<div class="modalx" id="modalEditVeterinario">
    <div class="modal-cardx">
        <div class="modal-headx">
            <h3><i class="ti ti-edit"></i> Editar veterinario</h3>
            <button class="modal-close" type="button" onclick="closeModal('modalEditVeterinario')"><i class="ti ti-x"></i></button>
        </div>
        <div class="modal-bodyx">
            <form method="post" action="${pageContext.request.contextPath}/veterinarios/actualizar">
                <input type="hidden" name="id" id="editVetId">
                <div class="form-grid">
                    <div><label class="form-label">Nombre</label><input class="form-control" name="nombre" id="editVetNombre" required></div>
                    <div><label class="form-label">Especialidad</label><input class="form-control" name="especialidad" id="editVetEspecialidad" required></div>
                    <div><label class="form-label">Correo</label><input class="form-control" name="correo" id="editVetCorreo" type="email" required></div>
                    <div><label class="form-label">Teléfono</label><input class="form-control" name="telefono" id="editVetTelefono" required></div>
                    <div><label class="form-label">Estado</label><select class="form-select" name="estado" id="editVetEstado"><option>DISPONIBLE</option><option>OCUPADO</option></select></div>
                    <div>
                        <label class="form-label">Nueva contraseña <span style="color:#94a3b8;font-weight:400">(dejar vacío para no cambiar)</span></label>
                        <input class="form-control" name="contrasena" id="editVetContrasena" type="password" placeholder="Nueva contraseña de acceso">
                    </div>
                    <div class="full d-flex justify-content-end gap-2 mt-2">
                        <button class="btn-cancel" type="button" onclick="closeModal('modalEditVeterinario')">Cancelar</button>
                        <button class="btn-save">Actualizar veterinario</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="toastx" id="toastx"><i class="ti ti-check"></i><span id="toastText">Listo</span></div>

<!-- MODAL EDITAR VENTA -->
<div class="modalx" id="modalEditVenta">
    <div class="modal-cardx">
        <div class="modal-headx">
            <h3><i class="ti ti-edit"></i> Editar venta</h3>
            <button class="modal-close" type="button" onclick="closeModal('modalEditVenta')"><i class="ti ti-x"></i></button>
        </div>
        <div class="modal-bodyx">
            <form method="post" action="${pageContext.request.contextPath}/ventas/actualizar">
                <input type="hidden" name="id" id="editVentaId">
                <div class="form-grid">
                    <div><label class="form-label">Total ($)</label><input class="form-control" name="total" id="editVentaTotal" type="number" step="0.01" required></div>
                    <div><label class="form-label">Método de pago</label>
                        <select class="form-select" name="metodo_pago" id="editVentaMetodo">
                            <option value="EFECTIVO">EFECTIVO</option>
                            <option value="TARJETA">TARJETA</option>
                            <option value="TRANSFERENCIA">TRANSFERENCIA</option>
                            <option value="PENDIENTE">PENDIENTE</option>
                        </select>
                    </div>
                    <div><label class="form-label">Estado</label>
                        <select class="form-select" name="estado" id="editVentaEstado">
                            <option value="CONFIRMADO">CONFIRMADO</option>
                            <option value="PENDIENTE">PENDIENTE</option>
                            <option value="CANCELADO">CANCELADO</option>
                        </select>
                    </div>
                    <div class="full d-flex justify-content-end gap-2 mt-2">
                        <button class="btn-cancel" type="button" onclick="closeModal('modalEditVenta')">Cancelar</button>
                        <button class="btn-save">Actualizar venta</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script>

function toggleNoti(event){
    event.stopPropagation();
    const box = document.getElementById('notiBox');
    const bell = document.getElementById('bellBtn');
    if(!box) return;
    
    if(!box.classList.contains('show')){
        // Position the box relative to the bell button
        if(bell){
            const rect = bell.getBoundingClientRect();
            const boxWidth = 360;
            let left = rect.right - boxWidth;
            if(left < 10) left = 10;
            box.style.top = (rect.bottom + 10) + 'px';
            box.style.left = left + 'px';
            box.style.right = 'auto';
        }
        box.classList.add('show');
    } else {
        box.classList.remove('show');
    }
}

document.addEventListener('click', function(e){
    const box = document.getElementById('notiBox');
    const bell = document.getElementById('bellBtn');
    if(box && !box.contains(e.target) && (!bell || !bell.contains(e.target))){
        box.classList.remove('show');
    }
});

function toast(msg){
    const t = document.getElementById('toastx');
    const txt = document.getElementById('toastText');
    if(!t || !txt) return;
    txt.textContent = msg;
    t.classList.add('show');
    setTimeout(function(){ t.classList.remove('show'); }, 2500);
}


function openEditVenta(btn){
    document.getElementById('editVentaId').value = btn.dataset.id || '';
    document.getElementById('editVentaTotal').value = btn.dataset.total || '';
    document.getElementById('editVentaMetodo').value = btn.dataset.metodo || 'EFECTIVO';
    document.getElementById('editVentaEstado').value = btn.dataset.estado || 'CONFIRMADO';
    openModal('modalEditVenta');
}

function openEditCita(btn){
    document.getElementById('editCitaId').value = btn.dataset.id || '';
    document.getElementById('editCitaDuenio').value = btn.dataset.duenio || '';
    document.getElementById('editCitaMascota').value = btn.dataset.mascota || '';
    document.getElementById('editCitaDoctor').value = btn.dataset.doctor || '';
    document.getElementById('editCitaFecha').value = btn.dataset.fecha || '';
    document.getElementById('editCitaHora').value = (btn.dataset.hora || '').substring(0,5);
    document.getElementById('editCitaMotivo').value = btn.dataset.motivo || '';
    document.getElementById('editCitaPrecio').value = btn.dataset.precio || '0';
    document.getElementById('editCitaEstado').value = btn.dataset.estado || 'PENDIENTE';
    openModal('modalEditCita');
}

function openEditProducto(btn){
    document.getElementById('editProductoId').value = btn.dataset.id || '';
    document.getElementById('editProductoCodigo').value = btn.dataset.codigo || '';
    document.getElementById('editProductoNombre').value = btn.dataset.nombre || '';
    document.getElementById('editProductoCategoria').value = btn.dataset.categoria || '';
    document.getElementById('editProductoEspecie').value = btn.dataset.especie || '';
    document.getElementById('editProductoPrecio').value = btn.dataset.precio || '';
    document.getElementById('editProductoStock').value = btn.dataset.stock || '';
    document.getElementById('editProductoStockMinimo').value = btn.dataset.stockminimo || '5';
    document.getElementById('editProductoImagen').value = btn.dataset.imagen || '';
    openModal('modalEditProducto');
}

function openEditUsuario(btn){
    document.getElementById('editUsuarioId').value = btn.dataset.id || '';
    document.getElementById('editUsuarioNombre').value = btn.dataset.nombre || '';
    document.getElementById('editUsuarioCorreo').value = btn.dataset.correo || '';
    document.getElementById('editUsuarioPass').value = '';
    // Normalizar a mayúsculas para que el select lo encuentre
    var rol = (btn.dataset.rol || 'CLIENTE').toUpperCase().trim();
    var estado = (btn.dataset.estado || 'ACTIVO').toUpperCase().trim();
    document.getElementById('editUsuarioRol').value = rol;
    document.getElementById('editUsuarioEstado').value = estado;
    openModal('modalEditUsuario');
}

function openEditVeterinario(btn){
    document.getElementById('editVetId').value = btn.dataset.id || '';
    document.getElementById('editVetNombre').value = btn.dataset.nombre || '';
    document.getElementById('editVetCorreo').value = btn.dataset.correo || '';
    document.getElementById('editVetTelefono').value = btn.dataset.telefono || '';
    document.getElementById('editVetEspecialidad').value = btn.dataset.especialidad || '';
    document.getElementById('editVetEstado').value = btn.dataset.estado || 'DISPONIBLE';
    openModal('modalEditVeterinario');
}

function showTab(tab){
    document.querySelectorAll('.tab-content').forEach(function(section){
        section.classList.remove('active');
    });
    document.querySelectorAll('.nav-tab').forEach(function(link){
        link.classList.remove('active');
    });

    const target = document.getElementById('tab-' + tab);
    if(target){
        target.classList.add('active');
    }

    document.querySelectorAll('.nav-tab').forEach(function(link){
        if(link.dataset.tab === tab){
            link.classList.add('active');
        }
    });

    window.scrollTo({top:0, behavior:'smooth'});
}

document.querySelectorAll('.nav-tab').forEach(function(link){
    link.addEventListener('click', function(e){
        e.preventDefault();
        showTab(link.dataset.tab);
    });
});

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

function openModal(id){
    document.getElementById(id).classList.add('show');
}
function closeModal(id){
    document.getElementById(id).classList.remove('show');
}

document.querySelectorAll('.modalx').forEach(function(modal){
    modal.addEventListener('click', function(e){
        if(e.target === modal){
            modal.classList.remove('show');
        }
    });
});

(function(){
    const params = new URLSearchParams(window.location.search);
    const ok = params.get('ok');
    if(ok){
        const msgs = {
            'Cita+registrada+correctamente': 'Cita registrada correctamente',
            'Cita+actualizada+correctamente': 'Cita actualizada correctamente',
            'Venta+eliminada+correctamente': 'Venta eliminada correctamente',
            'Venta+actualizada+correctamente': 'Venta actualizada correctamente',
            'Venta+confirmada+correctamente': 'Venta confirmada correctamente'
        };
        toast(msgs[ok] || decodeURIComponent(ok.replace(/\+/g,' ')));
    }
    if(params.get('error')) toast('Error: ' + decodeURIComponent(params.get('error').replace(/\+/g,' ')));
})();

</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.8.2/jspdf.plugin.autotable.min.js"></script>
<script>
function generarPDF() {
    const { jsPDF } = window.jspdf;
    const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });

    const GREEN = [0, 168, 90];
    const DARK  = [0, 61, 37];
    const GRAY  = [100, 116, 139];
    const W = doc.internal.pageSize.getWidth();
    const now = new Date();
    const fecha = now.toLocaleDateString('es-CO', {year:'numeric',month:'long',day:'numeric',hour:'2-digit',minute:'2-digit'});

    // ─── ENCABEZADO ───
    doc.setFillColor(...GREEN);
    doc.roundedRect(0, 0, W, 32, 0, 0, 'F');
    doc.setTextColor(255,255,255);
    doc.setFontSize(22);
    doc.setFont('helvetica','bold');
    doc.text('CliniPet', 14, 14);
    doc.setFontSize(10);
    doc.setFont('helvetica','normal');
    doc.text('Clínica Veterinaria — Reporte General', 14, 22);
    doc.text(fecha, W - 14, 22, { align: 'right' });

    let y = 40;

    function sectionTitle(title, icon) {
        doc.setFillColor(...DARK);
        doc.roundedRect(10, y, W - 20, 9, 2, 2, 'F');
        doc.setTextColor(255,255,255);
        doc.setFontSize(11);
        doc.setFont('helvetica','bold');
        doc.text(title, 14, y + 6.2);
        y += 13;
    }

    function checkPage(needed) {
        if (y + needed > 275) { doc.addPage(); y = 16; }
    }

    // ─── VENTAS ───
    sectionTitle('Ventas registradas');
    const ventasTable = document.getElementById('tablaVentas');
    if (ventasTable) {
        const rows = [];
        ventasTable.querySelectorAll('tbody tr').forEach(tr => {
            const cells = tr.querySelectorAll('td');
            if (cells.length >= 5) {
                rows.push([
                    cells[0]?.innerText?.trim() || '',
                    cells[1]?.innerText?.trim() || '',
                    cells[2]?.innerText?.trim() || '',
                    cells[3]?.innerText?.trim() || '',
                    cells[4]?.innerText?.trim() || ''
                ]);
            }
        });
        if (rows.length > 0) {
            doc.autoTable({
                startY: y,
                head: [['ID', 'Cliente', 'Fecha', 'Total', 'Estado']],
                body: rows,
                styles: { fontSize: 8.5, cellPadding: 3 },
                headStyles: { fillColor: GREEN, textColor: 255, fontStyle: 'bold' },
                alternateRowStyles: { fillColor: [240, 255, 248] },
                margin: { left: 10, right: 10 }
            });
            y = doc.lastAutoTable.finalY + 10;
        }
    }

    // ─── CITAS ───
    checkPage(30);
    sectionTitle('Citas médicas');
    const citasTable = document.getElementById('tablaTodasCitas');
    if (citasTable) {
        const rows = [];
        citasTable.querySelectorAll('tbody tr').forEach(tr => {
            const cells = tr.querySelectorAll('td');
            if (cells.length >= 5) {
                rows.push([
                    cells[0]?.innerText?.trim() || '',
                    cells[1]?.innerText?.trim() || '',
                    cells[2]?.innerText?.trim() || '',
                    cells[3]?.innerText?.trim() || '',
                    cells[4]?.innerText?.trim() || ''
                ]);
            }
        });
        if (rows.length > 0) {
            doc.autoTable({
                startY: y,
                head: [['Mascota', 'Dueño', 'Fecha', 'Motivo', 'Estado']],
                body: rows,
                styles: { fontSize: 8.5, cellPadding: 3 },
                headStyles: { fillColor: [47, 128, 237], textColor: 255, fontStyle: 'bold' },
                alternateRowStyles: { fillColor: [240, 248, 255] },
                margin: { left: 10, right: 10 }
            });
            y = doc.lastAutoTable.finalY + 10;
        }
    }

    // ─── STOCK DE PRODUCTOS ───
    checkPage(30);
    sectionTitle('Inventario de productos');
    const stockTable = document.getElementById('tablaStockCompleto');
    if (stockTable) {
        const rows = [];
        stockTable.querySelectorAll('tbody tr').forEach(tr => {
            const cells = tr.querySelectorAll('td');
            if (cells.length >= 4) {
                rows.push([
                    cells[0]?.innerText?.trim() || '',
                    cells[1]?.innerText?.trim() || '',
                    cells[2]?.innerText?.trim() || '',
                    cells[3]?.innerText?.trim() || ''
                ]);
            }
        });
        if (rows.length > 0) {
            doc.autoTable({
                startY: y,
                head: [['Producto', 'Categoría', 'Precio', 'Stock']],
                body: rows,
                styles: { fontSize: 8.5, cellPadding: 3 },
                headStyles: { fillColor: [255, 159, 45], textColor: 255, fontStyle: 'bold' },
                alternateRowStyles: { fillColor: [255, 251, 240] },
                margin: { left: 10, right: 10 }
            });
            y = doc.lastAutoTable.finalY + 10;
        }
    }

    // ─── VETERINARIOS ───
    checkPage(30);
    sectionTitle('Veterinarios');
    const vetTable = document.getElementById('tablaVeterinarios');
    if (vetTable) {
        const rows = [];
        vetTable.querySelectorAll('tbody tr').forEach(tr => {
            const cells = tr.querySelectorAll('td');
            if (cells.length >= 5) {
                rows.push([
                    cells[0]?.innerText?.trim() || '',
                    cells[1]?.innerText?.trim() || '',
                    cells[2]?.innerText?.trim() || '',
                    cells[3]?.innerText?.trim() || '',
                    cells[4]?.innerText?.trim() || ''
                ]);
            }
        });
        if (rows.length > 0) {
            doc.autoTable({
                startY: y,
                head: [['ID', 'Nombre', 'Correo', 'Teléfono', 'Especialidad']],
                body: rows,
                styles: { fontSize: 8.5, cellPadding: 3 },
                headStyles: { fillColor: [124, 92, 255], textColor: 255, fontStyle: 'bold' },
                alternateRowStyles: { fillColor: [248, 245, 255] },
                margin: { left: 10, right: 10 }
            });
            y = doc.lastAutoTable.finalY + 10;
        }
    }

    // ─── PIE ───
    const pages = doc.internal.getNumberOfPages();
    for (let i = 1; i <= pages; i++) {
        doc.setPage(i);
        doc.setFontSize(8);
        doc.setTextColor(...GRAY);
        doc.text('CliniPet © ' + now.getFullYear() + ' — Generado el ' + fecha, 14, 291);
        doc.text('Pág. ' + i + ' de ' + pages, W - 14, 291, { align: 'right' });
    }

    doc.save('CliniPet_Reporte_' + now.toISOString().slice(0,10) + '.pdf');
    toast('PDF generado correctamente');
}
</script>

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
var COLORS_NEON  = ['rgba(180,0,255,','rgba(124,0,255,','rgba(0,212,255,','rgba(212,0,255,'];
var EMOJIS_NEON  = ['💜','⚡','🌟','✨','🔮','💫','🦋','🐾'];

function getColors(){
  if(document.body.classList.contains('neon-mode')) return COLORS_NEON;
  if(document.body.classList.contains('dark-mode')) return COLORS_DARK;
  return COLORS_LIGHT;
}
function getEmojis(){
  if(document.body.classList.contains('neon-mode')) return EMOJIS_NEON;
  return EMOJIS;
}

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
  var _emojis = typeof getEmojis === 'function' ? getEmojis() : EMOJIS;
  this.emoji = _emojis[Math.floor(Math.random() * _emojis.length)];
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
  applyTheme(THEMES[(idx+1) % THEMES.length].key);
});

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

/* ── 12. LIVE CLOCK ── */
(function(){
  var clocks = document.querySelectorAll('.top-actions span');
  clocks.forEach(function(span){
    if(span.textContent.includes(':') && span.textContent.includes('/')){
      function tick(){
        var now = new Date();
        var d = now.getDate().toString().padStart(2,'0');
        var m = (now.getMonth()+1).toString().padStart(2,'0');
        var y = now.getFullYear();
        var h = now.getHours().toString().padStart(2,'0');
        var mi = now.getMinutes().toString().padStart(2,'0');
        var s = now.getSeconds().toString().padStart(2,'0');
        span.innerHTML = '<i class="ti ti-clock"></i> '+d+'/'+m+'/'+y+' '+h+':'+mi+':'+s;
      }
      tick(); setInterval(tick, 1000);
    }
  });
})();

/* ── 13. SCROLL-LINKED HEADER SHRINK ── */
(function(){
  var topbar = document.querySelector('.topbar');
  if(!topbar) return;
  var main = document.querySelector('.main');
  if(!main) return;
  main.addEventListener('scroll', function(){
    if(main.scrollTop > 30){
      topbar.style.background = 'rgba(255,255,255,.92)';
      topbar.style.backdropFilter = 'blur(20px)';
      topbar.style.boxShadow = '0 4px 30px rgba(0,60,35,.1)';
      topbar.style.transition = 'all .3s';
    } else {
      topbar.style.background = '';
      topbar.style.backdropFilter = '';
      topbar.style.boxShadow = '';
    }
  }, {passive:true});
})();

/* ── 14. MAGNETIC BUTTONS ── */
document.querySelectorAll('.quick-btn,.btn-save,.view-btn').forEach(function(btn){
  btn.addEventListener('mousemove', function(e){
    var rect = btn.getBoundingClientRect();
    var dx = (e.clientX - (rect.left + rect.width/2)) * .18;
    var dy = (e.clientY - (rect.top + rect.height/2)) * .18;
    btn.style.transform = 'translate('+dx+'px,'+dy+'px) translateY(-5px) scale(1.05)';
  });
  btn.addEventListener('mouseleave', function(){
    btn.style.transform = '';
  });
});

/* ── 15. CONFETTI on save ── */
document.querySelectorAll('.btn-save').forEach(function(btn){
  btn.addEventListener('click', function(){
    if(!btn.form || !btn.form.checkValidity()) return;
    for(var i = 0; i < 18; i++){
      var dot = document.createElement('div');
      var colors = ['#00a85a','#00d978','#2f80ed','#7c5cff','#ff9f2d','#ef4444'];
      Object.assign(dot.style,{
        position:'fixed',
        left:(Math.random()*100)+'vw',
        top:(Math.random()*40+30)+'vh',
        width:(6+Math.random()*8)+'px',
        height:(6+Math.random()*8)+'px',
        background: colors[Math.floor(Math.random()*colors.length)],
        borderRadius:'50%',
        pointerEvents:'none',
        zIndex:'9999',
        animation:'cpBounceIn .6s '+(Math.random()*.3)+'s cubic-bezier(.34,1.56,.64,1) both',
        transition:'all .8s ease',
        opacity:'0.85'
      });
      document.body.appendChild(dot);
      setTimeout(function(d){ d.style.opacity='0'; d.style.transform='translateY(60px) scale(0)'; setTimeout(function(){ d.remove(); }, 800); }.bind(null,dot), 600 + Math.random()*400);
    }
  });
});

/* ── 16. NAV LINK ACTIVE INDICATOR SLIDE ── */
(function(){
  var indicator = document.createElement('div');
  Object.assign(indicator.style,{
    position:'absolute', left:'12px', right:'12px',
    height:'100%', borderRadius:'16px', top:'0',
    background:'linear-gradient(135deg,rgba(0,200,117,.85),rgba(0,150,85,.78))',
    transition:'transform .38s cubic-bezier(.22,1,.36,1)',
    pointerEvents:'none', zIndex:'0', opacity:'0'
  });
  var navMenu = document.querySelector('.nav-menu');
  if(navMenu){ navMenu.style.position = 'relative'; navMenu.prepend(indicator); }
  document.querySelectorAll('.nav-tab').forEach(function(link){
    link.style.position = 'relative';
    link.style.zIndex = '1';
  });
})();
</script>




<!-- NOTIBOX at body root for correct z-index -->
<div class="noti-box" id="notiBox" onclick="event.stopPropagation()">
                        <div class="noti-title">
                            <span><i class="ti ti-bell"></i> Notificaciones</span>
                            <small><%= (stockBajo + citasPendientes + ventasPendientes) %> alertas</small>
                        </div>

                        <% if(ventasPendientes > 0){ %>
                        <div class="noti-item" style="background:#fff7ed;border-left:4px solid #f97316;padding:14px 16px;border-radius:14px;margin-bottom:8px">
                            <i class="ti ti-shopping-bag" style="color:#f97316;font-size:1.4rem;flex-shrink:0"></i>
                            <div style="flex:1">
                                <strong style="color:#9a3412"><%= ventasPendientes %> pedido<%= ventasPendientes > 1 ? "s" : "" %> pendiente<%= ventasPendientes > 1 ? "s" : "" %> de confirmar</strong><br>
                                <small style="color:#c2410c">Clientes esperan confirmación de su compra.</small><br>
                                <div style="margin-top:8px;display:flex;flex-direction:column;gap:6px">
                                <% for(Map<String,Object> v : ventas) {
                                    String ev = String.valueOf(v.get("estado"));
                                    if("PENDIENTE".equalsIgnoreCase(ev)) {
                                        Object idV = v.get("id") != null ? v.get("id") : v.get("id_venta");
                                %>
                                <form method="post" action="${pageContext.request.contextPath}/ventas/confirmar" style="display:flex;align-items:center;gap:8px">
                                    <input type="hidden" name="id" value="<%= idV %>">
                                    <span style="font-size:.82rem;color:#64748b;flex:1">
                                        Pedido #<%= idV %> — <%= v.get("cliente") %> — $<%= v.get("total") %>
                                    </span>
                                    <button type="submit" style="border:0;border-radius:10px;background:#00a85a;color:white;padding:5px 12px;font-weight:900;font-size:.78rem;cursor:pointer;white-space:nowrap">
                                        <i class="ti ti-check"></i> Confirmar
                                    </button>
                                </form>
                                <% }} %>
                                </div>
                            </div>
                        </div>
                        <% } %>

                        <% if(stockBajo > 0){ %>
                        <button class="noti-item warning w-100 border-0 text-start" type="button" onclick="showTab('stock')">
                            <i class="ti ti-package-off"></i>
                            <div>
                                <strong><%= stockBajo %> productos con stock bajo</strong><br>
                                <small>Haz clic para revisar el inventario completo.</small>
                            </div>
                        </button>
                        <% } %>

                        <% if(citasPendientes > 0){ %>
                        <button class="noti-item danger w-100 border-0 text-start" type="button" onclick="showTab('citas')">
                            <i class="ti ti-calendar-exclamation"></i>
                            <div>
                                <strong><%= citasPendientes %> citas pendientes</strong><br>
                                <small>Necesitan confirmación o seguimiento.</small>
                            </div>
                        </button>
                        <% } %>

                        <% if(stockBajo == 0 && citasPendientes == 0 && ventasPendientes == 0){ %>
                        <div class="noti-item ok">
                            <i class="ti ti-check"></i>
                            <div>
                                <strong>Todo está bien</strong><br>
                                <small>No tienes alertas pendientes.</small>
                            </div>
                        </div>
                        <% } %>
                    </div>
</body>
</html>
