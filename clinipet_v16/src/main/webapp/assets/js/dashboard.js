/* ══════════════════════════════════════════════════════════════════
   CliniPet — Theme Sync Universal (dashboard.js)
   Sincroniza el tema entre TODAS las vistas (públicas + paneles)
   Clave compartida: 'clinipetTheme'  Valores: light | dark | neon
══════════════════════════════════════════════════════════════════ */
(function(){

  /* ── Mapa de clases por vista ── */
  var THEME_MAP = {
    light: { body: [],                        sidebar: '',      bg: '' },
    dark:  { body: ['theme-dark','dark-mode'], sidebar: 'dark',  bg: '' },
    neon:  { body: ['theme-neon','neon-mode'], sidebar: 'neon',  bg: '' }
  };

  /* ── Fondos por modo para paneles ── */
  var BG = {
    light: 'radial-gradient(circle at 24% 8%,rgba(0,200,117,.10),transparent 28%),radial-gradient(circle at 90% 15%,rgba(0,217,120,.10),transparent 30%),linear-gradient(135deg,#fbfffd,#eefbf5)',
    dark:  'radial-gradient(circle at 20% 10%,rgba(99,102,241,.18),transparent 28%),radial-gradient(circle at 85% 20%,rgba(139,92,246,.14),transparent 30%),linear-gradient(135deg,#0a0e1a,#0d1326,#0f172a)',
    neon:  'radial-gradient(circle at 15% 10%,rgba(180,0,255,.2),transparent 28%),radial-gradient(circle at 85% 20%,rgba(0,212,255,.15),transparent 30%),linear-gradient(135deg,#0d0013,#13001f,#060010)'
  };

  /* ── Colores de texto por modo para panel ── */
  var TEXT_COLOR = { light: '', dark: '#e2f0ff', neon: '#f0e6ff' };

  /* ── Leer tema guardado (clave unificada) ── */
  function getTheme(){ return localStorage.getItem('clinipetTheme') || 'light'; }
  function setTheme(t){ localStorage.setItem('clinipetTheme', t); }

  /* ── Aplicar tema al body ── */
  function applyToDom(key){
    var body = document.body;
    /* quitar todas las clases de tema */
    ['theme-dark','theme-neon','dark-mode','neon-mode'].forEach(function(c){ body.classList.remove(c); });
    /* aplicar las del nuevo tema */
    var t = THEME_MAP[key] || THEME_MAP.light;
    t.body.forEach(function(c){ body.classList.add(c); });
    /* fondo del body */
    if(BG[key]) body.style.background = BG[key];
    /* color de texto */
    if(TEXT_COLOR[key]) body.style.color = TEXT_COLOR[key];
    else body.style.color = '';
  }

  /* ── Actualizar botón ── */
  function updateBtn(btn, key){
    var next = key === 'light' ? 'dark' : key === 'dark' ? 'neon' : 'light';
    var labels = {
      light: '<i class="ti ti-moon-stars"></i> Oscuro',
      dark:  '<i class="ti ti-sparkles"></i> Neon',
      neon:  '<i class="ti ti-sun"></i> Verde'
    };
    if(btn) btn.innerHTML = labels[next];
  }

  /* ── Init al cargar ── */
  var current = getTheme();
  applyToDom(current);

  /* ── Crear o reutilizar el botón de tema en paneles ── */
  document.addEventListener('DOMContentLoaded', function(){
    /* Restaurar tema (ya aplicado arriba, reforzar) */
    current = getTheme();
    applyToDom(current);

    /* Buscar botón existente o crear uno nuevo en .top-actions o .topbar */
    var btn = document.getElementById('darkModeBtn') || document.getElementById('themeToggle');

    if(!btn){
      /* Crear botón y añadirlo donde corresponda */
      btn = document.createElement('button');
      btn.id = 'darkModeBtn';
      btn.style.cssText = 'border:0;border-radius:12px;padding:10px 16px;font-weight:900;cursor:pointer;display:inline-flex;align-items:center;gap:8px;font-size:.9rem;transition:transform .2s,box-shadow .2s;font-family:"Nunito",sans-serif;background:linear-gradient(135deg,#1e1b4b,#4f46e5);color:white;box-shadow:0 8px 20px rgba(79,70,229,.28);';

      var target = document.querySelector('.top-actions') ||
                   document.querySelector('.topbar') ||
                   document.querySelector('.navx') ||
                   document.querySelector('.nav-actions');
      if(target) target.insertBefore(btn, target.firstChild);
    }

    updateBtn(btn, current);

    btn.addEventListener('click', function(){
      current = getTheme();
      var next = current === 'light' ? 'dark' : current === 'dark' ? 'neon' : 'light';
      setTheme(next);
      applyToDom(next);
      updateBtn(btn, next);
      /* Refrescar partículas si existen */
      if(window.spawnAll) window.spawnAll();
    });
  });

  /* Exportar para uso externo */
  window.cpApplyTheme = applyToDom;
  window.cpGetTheme   = getTheme;

})();
