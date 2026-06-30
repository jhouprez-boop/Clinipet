<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>CliniPet | Nueva contraseña</title>
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
    .card{background:white;border-radius:32px;max-width:460px;width:90%;overflow:hidden;
          box-shadow:0 30px 80px rgba(0,80,40,.14);animation:fadeUp .55s cubic-bezier(.22,1,.36,1) both}
    @keyframes fadeUp{from{opacity:0;transform:translateY(32px)}to{opacity:1;transform:translateY(0)}}
    .card-header{background:linear-gradient(135deg,#003d25,#006b3c);padding:32px 36px;text-align:center}
    .header-icon{width:72px;height:72px;border-radius:50%;background:rgba(255,255,255,.15);
                 border:2px solid rgba(255,255,255,.25);display:flex;align-items:center;
                 justify-content:center;font-size:2rem;margin:0 auto 14px;
                 animation:cpBounceIn .7s .2s both}
    @keyframes cpBounceIn{0%{opacity:0;transform:scale(.4)}60%{transform:scale(1.1)}100%{opacity:1;transform:scale(1)}}
    .card-header h2{margin:0 0 5px;color:white;font-family:'Fredoka',sans-serif;font-size:1.8rem}
    .card-header p{margin:0;color:rgba(255,255,255,.72);font-weight:700;font-size:.9rem}
    .card-body{padding:32px 36px}
    .steps{display:flex;gap:0;margin-bottom:26px;border-radius:14px;overflow:hidden;border:1px solid #dbeee5}
    .step{flex:1;padding:10px 6px;text-align:center;background:#f8fffb;font-size:.75rem;font-weight:800;
          color:#64748b;display:flex;flex-direction:column;align-items:center;gap:3px}
    .step.done{background:#dcfff0;color:#166534}
    .step.active{background:linear-gradient(135deg,#003d25,#006b3c);color:white}
    .step.active .step-num{background:rgba(255,255,255,.25)}
    .step.done .step-num{background:#00c875;color:white}
    .step-num{width:22px;height:22px;border-radius:50%;background:#e2e8f0;font-size:.78rem;
              font-weight:900;display:flex;align-items:center;justify-content:center}
    label{display:block;font-weight:800;color:#064e3b;margin-bottom:7px;font-size:.92rem}
    .inp-wrap{position:relative;margin-bottom:18px}
    .inp-wrap .inp-icon{position:absolute;left:16px;top:50%;transform:translateY(-50%);
                        color:#00c875;font-size:1.15rem;pointer-events:none}
    .inp-wrap .eye-btn{position:absolute;right:14px;top:50%;transform:translateY(-50%);
                       border:0;background:none;cursor:pointer;color:#64748b;font-size:1.1rem;padding:4px}
    .inp{width:100%;border:1.5px solid #dbeee5;border-radius:16px;padding:13px 44px 13px 46px;
         font-family:inherit;font-size:.97rem;font-weight:700;outline:none;
         transition:border .2s,box-shadow .2s;background:#fafffe}
    .inp:focus{border-color:#00c875;box-shadow:0 0 0 3px rgba(0,200,117,.14);background:white}
    /* strength bar */
    .strength-wrap{margin:-10px 0 18px}
    .strength-bar-bg{height:6px;border-radius:999px;background:#e2e8f0;overflow:hidden}
    .strength-bar-fill{height:100%;width:0%;border-radius:999px;transition:width .35s,background .35s}
    .strength-label{font-size:.78rem;font-weight:800;color:#64748b;margin-top:5px}
    /* match indicator */
    .match-hint{font-size:.78rem;font-weight:800;margin-top:-10px;margin-bottom:16px;
                display:flex;align-items:center;gap:5px}
    .match-hint.ok{color:#166534} .match-hint.no{color:#be123c}
    .btn-submit{width:100%;border:0;border-radius:18px;
                background:linear-gradient(135deg,#00c875,#00f5a0);
                color:#003d25;font-weight:900;font-size:1rem;padding:15px;cursor:pointer;
                display:flex;align-items:center;justify-content:center;gap:9px;
                box-shadow:0 14px 36px rgba(0,200,117,.30);
                transition:transform .2s,box-shadow .2s;font-family:inherit;margin-top:6px}
    .btn-submit:hover{transform:translateY(-2px);box-shadow:0 18px 44px rgba(0,200,117,.38)}
    .alert-err{display:flex;align-items:flex-start;gap:10px;border-radius:16px;padding:14px 16px;
               font-weight:800;margin-bottom:20px;font-size:.9rem;
               background:#fff1f2;border:1px solid #fecdd3;color:#be123c}
  </style>
</head>
<body>

<div class="card">
  <div class="card-header">
    <div class="header-icon">🛡️</div>
    <h2>Nueva contraseña</h2>
    <p>Elige una clave segura para tu cuenta</p>
  </div>

  <div class="card-body">
    <!-- Steps -->
    <div class="steps">
      <div class="step done">
        <div class="step-num"><i class="ti ti-check" style="font-size:.75rem"></i></div>
        <span>Correo</span>
      </div>
      <div class="step done">
        <div class="step-num"><i class="ti ti-check" style="font-size:.75rem"></i></div>
        <span>Código</span>
      </div>
      <div class="step active">
        <div class="step-num">3</div>
        <span>Nueva clave</span>
      </div>
    </div>

    <% if(request.getParameter("error") != null){ %>
    <div class="alert-err">
      <i class="ti ti-alert-circle" style="font-size:1.1rem;flex-shrink:0;margin-top:1px"></i>
      <span><%= request.getParameter("error") %></span>
    </div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/recuperar/nueva"
          id="newPassForm" onsubmit="return validar()">
      <input type="hidden" name="token" value="<%= request.getAttribute("token") %>"/>

      <label>Nueva contraseña</label>
      <div class="inp-wrap">
        <i class="ti ti-lock inp-icon"></i>
        <input type="password" name="nueva" id="nueva" class="inp"
               placeholder="Mínimo 6 caracteres" required oninput="calcStrength(this.value)"/>
        <button type="button" class="eye-btn" onclick="toggleEye('nueva',this)">
          <i class="ti ti-eye"></i>
        </button>
      </div>
      <div class="strength-wrap">
        <div class="strength-bar-bg"><div class="strength-bar-fill" id="sbar"></div></div>
        <div class="strength-label" id="slabel"></div>
      </div>

      <label>Confirmar contraseña</label>
      <div class="inp-wrap">
        <i class="ti ti-lock-check inp-icon"></i>
        <input type="password" name="confirmar" id="confirmar" class="inp"
               placeholder="Repite la contraseña" required oninput="checkMatch()"/>
        <button type="button" class="eye-btn" onclick="toggleEye('confirmar',this)">
          <i class="ti ti-eye"></i>
        </button>
      </div>
      <div class="match-hint" id="matchHint" style="display:none"></div>

      <button class="btn-submit" type="submit">
        <i class="ti ti-shield-check"></i> Cambiar contraseña
      </button>
    </form>
  </div>
</div>

<script>
var lvls = ['','Muy débil','Débil','Regular','Buena','Excelente'];
var colors = ['','#ef4444','#f97316','#eab308','#22c55e','#00c875'];
function calcStrength(v){
  var s=0;
  if(v.length>=6)s++;if(v.length>=10)s++;
  if(/[A-Z]/.test(v))s++;if(/[0-9]/.test(v))s++;if(/[^A-Za-z0-9]/.test(v))s++;
  var pct=(s/5)*100;
  document.getElementById('sbar').style.cssText='width:'+pct+'%;background:'+(colors[s]||'#e2e8f0');
  document.getElementById('slabel').textContent=s>0?lvls[s]:'';
  document.getElementById('slabel').style.color=colors[s]||'#64748b';
  checkMatch();
}
function checkMatch(){
  var n=document.getElementById('nueva').value;
  var c=document.getElementById('confirmar').value;
  var h=document.getElementById('matchHint');
  if(!c){h.style.display='none';return;}
  h.style.display='flex';
  if(n===c){h.className='match-hint ok';h.innerHTML='<i class="ti ti-check-circle"></i> Las contraseñas coinciden';}
  else{h.className='match-hint no';h.innerHTML='<i class="ti ti-x"></i> No coinciden';}
}
function toggleEye(id,btn){
  var inp=document.getElementById(id);
  var show=inp.type==='password';
  inp.type=show?'text':'password';
  btn.innerHTML=show?'<i class="ti ti-eye-off"></i>':'<i class="ti ti-eye"></i>';
}
function validar(){
  var n=document.getElementById('nueva').value;
  var c=document.getElementById('confirmar').value;
  if(n.length<6){alert('Mínimo 6 caracteres');return false;}
  if(n!==c){alert('Las contraseñas no coinciden');return false;}
  return true;
}
</script>
<script src="${pageContext.request.contextPath}/assets/js/animations.js"></script>
</body>
</html>
