<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String waUrl   = request.getParameter("waUrl");
    String back    = request.getParameter("back");
    String producto = request.getParameter("producto");
    String total   = request.getParameter("total");
    if (waUrl  == null) waUrl  = "#";
    if (back   == null) back   = "javascript:history.back()";
    if (producto == null) producto = "producto";
    if (total  == null) total  = "0";
%>
<!doctype html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>¡Compra realizada! | CliniPet</title>
<link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;700;800;900&family=Fredoka:wght@600;700&display=swap" rel="stylesheet">
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{min-height:100vh;display:flex;align-items:center;justify-content:center;
     background:radial-gradient(circle at 20% 10%,rgba(0,200,117,.18),transparent 35%),
                linear-gradient(135deg,#f0fff8,#e6ffe8);
     font-family:'Nunito',sans-serif}
.card{background:white;border-radius:32px;box-shadow:0 30px 80px rgba(0,80,40,.14);
      padding:48px 42px;max-width:480px;width:90%;text-align:center}
.icon-big{width:90px;height:90px;border-radius:50%;background:linear-gradient(135deg,#00c875,#00f5a0);
          display:flex;align-items:center;justify-content:center;margin:0 auto 24px;
          font-size:2.6rem;color:white;box-shadow:0 16px 40px rgba(0,200,117,.35)}
h1{font-family:'Fredoka',sans-serif;font-size:2rem;color:#003d25;margin-bottom:8px}
p{color:#64748b;font-weight:700;margin-bottom:6px;line-height:1.5}
.product-box{background:#f0fff8;border-radius:18px;padding:18px 24px;margin:20px 0;
             border:1px solid #bbf7d0}
.product-box strong{font-size:1.15rem;color:#003d25;display:block;margin-bottom:4px}
.product-box .price{font-size:1.4rem;font-weight:900;color:#00a85a}
.btn-wa{display:inline-flex;align-items:center;gap:10px;background:#25D366;color:white;
        border:0;border-radius:18px;padding:16px 32px;font-weight:900;font-size:1rem;
        text-decoration:none;cursor:pointer;margin:8px 4px;
        box-shadow:0 14px 35px rgba(37,211,102,.35);transition:.2s}
.btn-wa:hover{opacity:.9;transform:translateY(-2px)}
.btn-back{display:inline-flex;align-items:center;gap:8px;background:#f0fff8;color:#003d25;
          border:2px solid #bbf7d0;border-radius:18px;padding:14px 28px;font-weight:900;
          font-size:.95rem;text-decoration:none;cursor:pointer;margin:8px 4px;transition:.2s}
.btn-back:hover{background:#dcfff0}
.note{font-size:.8rem;color:#94a3b8;margin-top:18px;font-weight:700}
.progress-bar{height:5px;border-radius:999px;background:#dcfff0;margin-top:24px;overflow:hidden}
.progress-fill{height:100%;width:0%;background:linear-gradient(90deg,#00c875,#00f5a0);
               border-radius:999px;transition:width .1s linear}
</style>
</head>
<body>
<div class="card">
    <div class="icon-big"><i class="ti ti-check"></i></div>
    <h1>¡Compra exitosa!</h1>
    <p>Tu pedido ha sido registrado correctamente.</p>

    <div class="product-box">
        <strong><%= producto %></strong>
        <span class="price">Total: $<%= total %></span>
    </div>

    <p>Notifica al administrador por WhatsApp para que confirme tu pedido:</p>

    <a class="btn-wa" href="<%= waUrl %>" target="_blank" id="btnWa">
        <i class="ti ti-brand-whatsapp"></i> Notificar al admin por WhatsApp
    </a>
    <br>
    <a class="btn-back" href="<%= back %>">
        <i class="ti ti-arrow-left"></i> Volver al panel
    </a>

    <div class="progress-bar"><div class="progress-fill" id="fill"></div></div>
    <p class="note">Redirigiendo automáticamente en <span id="cnt">10</span> segundos...</p>
</div>

<script>
    var sec = 10;
    var fill = document.getElementById('fill');
    var cnt = document.getElementById('cnt');
    var back = '<%= back.replace("'", "\\'") %>';

    var interval = setInterval(function(){
        sec--;
        cnt.textContent = sec;
        fill.style.width = ((10 - sec) * 10) + '%';
        if(sec <= 0){
            clearInterval(interval);
            window.location.href = back;
        }
    }, 1000);

    // Si hace clic en WhatsApp, dejamos que el contador siga
    document.getElementById('btnWa').addEventListener('click', function(){
        // El botón de volver ya está ahí
    });
</script>
<script src="${pageContext.request.contextPath}/assets/js/animations.js"></script>
</body>
</html>
