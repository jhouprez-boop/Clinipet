<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>CliniPet | Ingresa tu código</title>
  <link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&family=Fredoka:wght@600;700&display=swap" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/assets/css/clinipet.css" rel="stylesheet"/>
  <style>
    *{box-sizing:border-box}
    body{margin:0;font-family:'Nunito',sans-serif;min-height:100vh;display:flex;align-items:center;
         justify-content:center;
         background:radial-gradient(circle at 15% 5%,rgba(0,200,117,.15),transparent 30%),
                    linear-gradient(135deg,#f8fffb,#eafff4)}
    .card{background:white;border-radius:32px;max-width:460px;width:92%;overflow:hidden;
          box-shadow:0 30px 80px rgba(0,80,40,.14);animation:fadeUp .55s cubic-bezier(.22,1,.36,1) both;
          text-align:center}
    @keyframes fadeUp{from{opacity:0;transform:translateY(32px)}to{opacity:1;transform:translateY(0)}}

    /* Header */
    .card-header{background:linear-gradient(135deg,#003d25,#006b3c);padding:28px 32px}
    .icon-wrap{width:72px;height:72px;border-radius:50%;background:rgba(255,255,255,.15);
               border:2px solid rgba(255,255,255,.3);display:flex;align-items:center;
               justify-content:center;font-size:2rem;margin:0 auto 14px;
               animation:cpBounceIn .7s .2s both}
    @keyframes cpBounceIn{0%{opacity:0;transform:scale(.4)}60%{transform:scale(1.1)}100%{opacity:1;transform:scale(1)}}
    .card-header h2{margin:0 0 6px;color:white;font-family:'Fredoka',sans-serif;font-size:1.75rem}
    .card-header p{margin:0;color:rgba(255,255,255,.75);font-weight:700;font-size:.9rem;line-height:1.5}

    /* Body */
    .card-body{padding:28px 32px}

    /* Steps */
    .steps{display:flex;gap:0;margin-bottom:24px;border-radius:14px;overflow:hidden;border:1px solid #dbeee5}
    .step{flex:1;padding:9px 6px;text-align:center;background:#f8fffb;font-size:.74rem;font-weight:800;
          color:#64748b;display:flex;flex-direction:column;align-items:center;gap:3px}
    .step.done{background:#dcfff0;color:#166534}
    .step.active{background:linear-gradient(135deg,#003d25,#006b3c);color:white}
    .step-num{width:22px;height:22px;border-radius:50%;background:#e2e8f0;font-size:.78rem;
              font-weight:900;display:flex;align-items:center;justify-content:center}
    .step.active .step-num{background:rgba(255,255,255,.25)}
    .step.done .step-num{background:#00c875;color:white}

    /* Timer */
    .expires-bar{display:flex;align-items:center;gap:8px;justify-content:center;
      background:#fff7ed;border:1px solid #fed7aa;border-radius:12px;
      padding:9px 16px;color:#c2410c;font-weight:800;font-size:.87rem;margin-bottom:22px}
    .expires-bar.expired{background:#ffe4e6;border-color:#fecdd3;color:#b91c1c}

    /* Código input */
    .code-section{margin-bottom:22px}
    .code-label{font-size:.8rem;color:#64748b;font-weight:800;text-transform:uppercase;
                letter-spacing:.06em;margin-bottom:12px;display:block}
    .code-inputs{display:flex;gap:8px;justify-content:center;margin-bottom:6px}
    .code-inputs input{
      width:46px;height:58px;border-radius:14px;border:2.5px solid #dbeee5;
      text-align:center;font-size:1.6rem;font-weight:900;font-family:'Courier New',monospace;
      color:#003d25;background:#f8fffb;outline:none;
      transition:border-color .2s,box-shadow .2s,transform .15s;
      -moz-appearance:textfield
    }
    .code-inputs input::-webkit-outer-spin-button,
    .code-inputs input::-webkit-inner-spin-button{-webkit-appearance:none;margin:0}
    .code-inputs input:focus{border-color:#00c875;box-shadow:0 0 0 3px rgba(0,200,117,.18);transform:translateY(-2px)}
    .code-inputs input.error{border-color:#ef4444;box-shadow:0 0 0 3px rgba(239,68,68,.15);animation:shake .35s ease}
    .code-inputs input.ok{border-color:#00c875;background:#f0fdf4}
    @keyframes shake{0%,100%{transform:translateX(0)}25%{transform:translateX(-5px)}75%{transform:translateX(5px)}}

    /* Error / success message */
    .msg{border-radius:14px;padding:11px 16px;font-weight:800;font-size:.87rem;
         display:none;align-items:center;gap:9px;margin-bottom:16px;text-align:left}
    .msg.error{background:#ffe4e6;border:1px solid #fecdd3;color:#b91c1c;display:flex}
    .msg.success{background:#dcfff0;border:1px solid #a7f0c9;color:#166534;display:flex}

    /* Submit btn */
    .btn-verify{
      width:100%;border:0;border-radius:18px;
      background:linear-gradient(135deg,#00c875,#00f5a0);
      color:#003d25;font-weight:900;padding:14px;font-size:1rem;
      font-family:inherit;cursor:pointer;
      box-shadow:0 12px 32px rgba(0,200,117,.28);
      display:flex;align-items:center;justify-content:center;gap:10px;
      transition:transform .2s,box-shadow .2s;margin-bottom:16px
    }
    .btn-verify:hover{transform:translateY(-2px);box-shadow:0 16px 40px rgba(0,200,117,.36)}
    .btn-verify:disabled{opacity:.6;cursor:not-allowed;transform:none}

    .note{font-size:.82rem;color:#94a3b8;font-weight:700;line-height:1.7}
  </style>
</head>
<body>

<div class="card">
  <div class="card-header">
    <div class="icon-wrap">
      <% if(Boolean.TRUE.equals(request.getAttribute("emailError"))){ %>⚠️<% } else { %>📬<% } %>
    </div>
    <h2>Ingresa tu código</h2>
    <p>
      <% if(Boolean.TRUE.equals(request.getAttribute("emailError"))){ %>
        No se pudo enviar el correo. Contacta al administrador.
      <% } else { %>
        Revisá tu correo <strong style="color:#00f5a0"><%= request.getAttribute("correo") %></strong><br>
        e ingresa el código de 6 dígitos que te enviamos.
      <% } %>
    </p>
  </div>

  <div class="card-body">

    <!-- Steps -->
    <div class="steps">
      <div class="step done">
        <div class="step-num"><i class="ti ti-check" style="font-size:.75rem"></i></div>
        <span>Correo</span>
      </div>
      <div class="step active">
        <div class="step-num">2</div>
        <span>Código</span>
      </div>
      <div class="step">
        <div class="step-num">3</div>
        <span>Nueva clave</span>
      </div>
    </div>

    <!-- Timer -->
    <div class="expires-bar" id="timerBar">
      <i class="ti ti-clock"></i>
      Código válido por <strong id="timerVal">30:00</strong> minutos
    </div>

    <!-- Mensaje de error/éxito -->
    <div class="msg" id="msgBox">
      <i class="ti ti-alert-circle"></i>
      <span id="msgText">Código incorrecto o expirado. Inténtalo de nuevo.</span>
    </div>

    <!-- Inputs del código -->
    <div class="code-section">
      <span class="code-label"><i class="ti ti-lock" style="color:#00a85a"></i> Tu código de 6 dígitos</span>
      <div class="code-inputs" id="codeInputs">
        <input type="number" maxlength="1" min="0" max="9" id="d0" autocomplete="off" inputmode="numeric">
        <input type="number" maxlength="1" min="0" max="9" id="d1" autocomplete="off" inputmode="numeric">
        <input type="number" maxlength="1" min="0" max="9" id="d2" autocomplete="off" inputmode="numeric">
        <input type="number" maxlength="1" min="0" max="9" id="d3" autocomplete="off" inputmode="numeric">
        <input type="number" maxlength="1" min="0" max="9" id="d4" autocomplete="off" inputmode="numeric">
        <input type="number" maxlength="1" min="0" max="9" id="d5" autocomplete="off" inputmode="numeric">
      </div>
    </div>

    <!-- Botón verificar -->
    <button class="btn-verify" id="btnVerify" onclick="verificar()">
      <i class="ti ti-shield-check"></i> Verificar código
    </button>

    <p class="note">
      ¿No recibiste el correo? Revisa tu carpeta de <strong>spam</strong> o
      <a href="${pageContext.request.contextPath}/recuperar" style="color:#00a85a;font-weight:800">intenta de nuevo</a>.
    </p>
  </div>
</div>

<script>
/* ── Inputs de 6 dígitos con auto-avance ── */
var inputs = document.querySelectorAll('.code-inputs input');

inputs.forEach(function(inp, idx){
  inp.addEventListener('input', function(){
    // Sólo conservar el último dígito escrito
    var v = inp.value.replace(/\D/g,'');
    inp.value = v ? v.slice(-1) : '';
    if(inp.value && idx < 5) inputs[idx + 1].focus();
    clearError();
  });
  inp.addEventListener('keydown', function(e){
    if(e.key === 'Backspace' && !inp.value && idx > 0){
      inputs[idx - 1].focus();
    }
    if(e.key === 'Enter') verificar();
  });
  inp.addEventListener('paste', function(e){
    e.preventDefault();
    var text = (e.clipboardData || window.clipboardData).getData('text').replace(/\D/g,'');
    text.split('').slice(0,6).forEach(function(ch, i){
      if(inputs[idx + i]) inputs[idx + i].value = ch;
    });
    var next = Math.min(idx + text.length, 5);
    inputs[next].focus();
    clearError();
  });
});

/* Enfocar primer campo al cargar */
inputs[0].focus();

/* ── Verificar código ── */
function getCode(){
  var code = '';
  inputs.forEach(function(inp){ code += inp.value; });
  return code;
}

function clearError(){
  inputs.forEach(function(inp){ inp.classList.remove('error','ok'); });
  var msg = document.getElementById('msgBox');
  msg.className = 'msg';
}

function showError(text){
  inputs.forEach(function(inp){ inp.classList.add('error'); });
  var msg = document.getElementById('msgBox');
  msg.className = 'msg error';
  document.getElementById('msgText').textContent = text;
  // Limpiar campos y reenfocarse
  setTimeout(function(){
    inputs.forEach(function(inp){ inp.value = ''; inp.classList.remove('error'); });
    inputs[0].focus();
  }, 1200);
}

function showSuccess(){
  inputs.forEach(function(inp){ inp.classList.add('ok'); });
  var msg = document.getElementById('msgBox');
  msg.className = 'msg success';
  document.getElementById('msgText').textContent = '¡Código correcto! Redirigiendo...';
}

function verificar(){
  var code = getCode();
  if(code.length < 6){
    showError('Ingresa los 6 dígitos del código.');
    return;
  }

  var btn = document.getElementById('btnVerify');
  btn.disabled = true;
  btn.innerHTML = '<i class="ti ti-loader-2" style="animation:spin .8s linear infinite"></i> Verificando...';

  // Verificar via GET al servlet de nueva contraseña
  var contextPath = '${pageContext.request.contextPath}';
  var url = contextPath + '/recuperar/nueva?token=' + encodeURIComponent(code) + '&check=1';

  fetch(url, { method: 'GET', redirect: 'manual' })
    .then(function(resp){
      // 200 = token válido, el servlet nos lo confirma
      // redirect (3xx) o error = inválido
      if(resp.ok || resp.status === 200){
        showSuccess();
        setTimeout(function(){
          window.location.href = contextPath + '/recuperar/nueva?token=' + encodeURIComponent(code);
        }, 900);
      } else {
        btn.disabled = false;
        btn.innerHTML = '<i class="ti ti-shield-check"></i> Verificar código';
        showError('Código incorrecto o expirado. Inténtalo de nuevo.');
      }
    })
    .catch(function(){
      // Si hay error de red, intentamos ir directo — el servidor validará
      showSuccess();
      setTimeout(function(){
        window.location.href = contextPath + '/recuperar/nueva?token=' + encodeURIComponent(code);
      }, 900);
    });
}

/* ── Countdown 30 min ── */
var secs = 30 * 60;
function tick(){
  var m = Math.floor(secs/60).toString().padStart(2,'0');
  var s = (secs%60).toString().padStart(2,'0');
  document.getElementById('timerVal').textContent = m+':'+s;
  if(secs <= 0){
    document.getElementById('timerVal').textContent = 'expirado';
    document.getElementById('timerBar').classList.add('expired');
    return;
  }
  secs--;
  setTimeout(tick, 1000);
}
tick();
</script>
<style>@keyframes spin{from{transform:rotate(0deg)}to{transform:rotate(360deg)}}</style>
<script src="${pageContext.request.contextPath}/assets/js/animations.js"></script>
</body>
</html>
