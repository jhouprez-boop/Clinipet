<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>CliniPet | Recuperar contraseña</title>
  <link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&family=Fredoka:wght@600;700&display=swap" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/assets/css/clinipet.css" rel="stylesheet"/>
  <style>
    *{box-sizing:border-box}
    body{margin:0;font-family:'Nunito',sans-serif;min-height:100vh;display:flex;align-items:center;
         justify-content:center;
         background:radial-gradient(circle at 15% 5%,rgba(0,200,117,.15),transparent 30%),
                    radial-gradient(circle at 85% 90%,rgba(0,200,117,.10),transparent 30%),
                    linear-gradient(135deg,#f8fffb,#eafff4)}

    /* ── CARD ── */
    .recov-card{
      background:white;border-radius:32px;padding:0;max-width:460px;width:90%;
      box-shadow:0 30px 80px rgba(0,80,40,.14);
      animation:fadeUp .55s cubic-bezier(.22,1,.36,1) both;overflow:hidden
    }
    @keyframes fadeUp{from{opacity:0;transform:translateY(32px)}to{opacity:1;transform:translateY(0)}}

    /* ── HEADER verde ── */
    .card-header{
      background:linear-gradient(135deg,#003d25,#006b3c);
      padding:32px 36px;text-align:center
    }
    .header-icon{
      width:72px;height:72px;border-radius:50%;
      background:rgba(255,255,255,.15);border:2px solid rgba(255,255,255,.25);
      display:flex;align-items:center;justify-content:center;
      font-size:2rem;margin:0 auto 14px;
      animation:cpBounceIn .7s .2s both
    }
    @keyframes cpBounceIn{0%{opacity:0;transform:scale(.4)}60%{transform:scale(1.1)}100%{opacity:1;transform:scale(1)}}
    .card-header h2{margin:0 0 5px;color:white;font-family:'Fredoka',sans-serif;font-size:1.8rem}
    .card-header p{margin:0;color:rgba(255,255,255,.72);font-weight:700;font-size:.9rem}

    /* ── BODY ── */
    .card-body{padding:32px 36px}

    /* ── ALERTS ── */
    .alert{display:flex;align-items:flex-start;gap:10px;border-radius:16px;padding:14px 16px;
           font-weight:800;margin-bottom:20px;font-size:.9rem;line-height:1.5}
    .alert-err{background:#fff1f2;border:1px solid #fecdd3;color:#be123c}
    .alert-ok {background:#f0fdf4;border:1px solid #86efac;color:#166534}
    .alert i{font-size:1.1rem;flex-shrink:0;margin-top:1px}

    /* ── FORM ── */
    label{display:block;font-weight:800;color:#064e3b;margin-bottom:7px;font-size:.92rem}
    .inp-wrap{position:relative;margin-bottom:22px}
    .inp-wrap .inp-icon{
      position:absolute;left:16px;top:50%;transform:translateY(-50%);
      color:#00c875;font-size:1.15rem;pointer-events:none
    }
    .inp{
      width:100%;border:1.5px solid #dbeee5;border-radius:16px;
      padding:13px 14px 13px 46px;font-family:inherit;font-size:.97rem;
      font-weight:700;outline:none;transition:border .2s,box-shadow .2s;
      background:#fafffe
    }
    .inp:focus{border-color:#00c875;box-shadow:0 0 0 3px rgba(0,200,117,.14);background:white}

    /* ── BTN ── */
    .btn-submit{
      width:100%;border:0;border-radius:18px;
      background:linear-gradient(135deg,#00c875,#00f5a0);
      color:#003d25;font-weight:900;font-size:1rem;padding:15px;cursor:pointer;
      display:flex;align-items:center;justify-content:center;gap:9px;
      box-shadow:0 14px 36px rgba(0,200,117,.30);
      transition:transform .2s,box-shadow .2s;font-family:inherit
    }
    .btn-submit:hover{transform:translateY(-2px);box-shadow:0 18px 44px rgba(0,200,117,.38)}
    .btn-submit:active{transform:translateY(0)}

    /* ── LOADING ── */
    .btn-submit.loading{pointer-events:none;opacity:.8}
    .spin{width:18px;height:18px;border:2.5px solid rgba(0,61,37,.25);
          border-top-color:#003d25;border-radius:50%;animation:spin .7s linear infinite}
    @keyframes spin{to{transform:rotate(360deg)}}

    /* ── DIVIDER ── */
    .divider{display:flex;align-items:center;gap:12px;margin:22px 0;color:#94a3b8;font-weight:800;font-size:.82rem}
    .divider::before,.divider::after{content:'';flex:1;height:1px;background:#e2e8f0}

    /* ── BACK LINK ── */
    .back-link{
      display:flex;align-items:center;gap:7px;justify-content:center;
      color:#00a85a;font-weight:800;text-decoration:none;font-size:.92rem;
      padding:10px;border-radius:14px;transition:.2s
    }
    .back-link:hover{background:#f0fdf4}

    /* ── STEPS ── */
    .steps{display:flex;gap:0;margin-bottom:26px;border-radius:14px;overflow:hidden;border:1px solid #dbeee5}
    .step{flex:1;padding:10px 6px;text-align:center;background:#f8fffb;font-size:.75rem;font-weight:800;
          color:#64748b;display:flex;flex-direction:column;align-items:center;gap:3px}
    .step.active{background:linear-gradient(135deg,#003d25,#006b3c);color:white}
    .step.active .step-num{background:rgba(255,255,255,.25)}
    .step-num{width:22px;height:22px;border-radius:50%;background:#e2e8f0;font-size:.78rem;
              font-weight:900;display:flex;align-items:center;justify-content:center}
  </style>
</head>
<body>

<div class="recov-card">

  <!-- HEADER -->
  <div class="card-header">
    <div class="header-icon">🔑</div>
    <h2>Recuperar contraseña</h2>
    <p>Te enviaremos un código de 6 dígitos a tu Gmail</p>
  </div>

  <!-- BODY -->
  <div class="card-body">

    <!-- Steps -->
    <div class="steps">
      <div class="step active">
        <div class="step-num">1</div>
        <span>Correo</span>
      </div>
      <div class="step">
        <div class="step-num">2</div>
        <span>Código</span>
      </div>
      <div class="step">
        <div class="step-num">3</div>
        <span>Nueva clave</span>
      </div>
    </div>

    <% if(request.getParameter("error") != null){ %>
    <div class="alert alert-err">
      <i class="ti ti-alert-circle"></i>
      <span><%= request.getParameter("error") %></span>
    </div>
    <% } %>

    <% if(request.getParameter("info") != null){ %>
    <div class="alert alert-ok">
      <i class="ti ti-mail-check"></i>
      <span><%= request.getParameter("info") %></span>
    </div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/recuperar" id="recovForm">
      <label>Correo electrónico registrado</label>
      <div class="inp-wrap">
        <i class="ti ti-mail inp-icon"></i>
        <input type="email" name="correo" class="inp"
               placeholder="tucorreo@gmail.com" required autocomplete="email"/>
      </div>
      <button class="btn-submit" type="submit" id="btnSubmit">
        <i class="ti ti-send"></i> Enviar código al Gmail
      </button>
    </form>

    <div class="divider">o</div>

    <a href="${pageContext.request.contextPath}/login" class="back-link">
      <i class="ti ti-arrow-left"></i> Volver al inicio de sesión
    </a>

  </div><!-- /card-body -->
</div>

<script>
document.getElementById('recovForm').addEventListener('submit', function(){
  var btn = document.getElementById('btnSubmit');
  btn.classList.add('loading');
  btn.innerHTML = '<div class="spin"></div> Enviando código…';
});
</script>
<script src="${pageContext.request.contextPath}/assets/js/animations.js"></script>
</body>
</html>
