/* ══════════════════════════════════════════════════════════════
   CliniPet v13 — animations.js PREMIUM
   Typewriter · Scroll Reveal · Partículas · Smooth transitions
   3-modo tema: light / dark / neon
══════════════════════════════════════════════════════════════ */

(function () {
  'use strict';

  /* ─────────────────────────────────────────────────────────
     1. PARTÍCULAS DE FONDO (adaptadas al tema)
  ───────────────────────────────────────────────────────── */
  function initParticles() {
    const canvas = document.createElement('canvas');
    canvas.id = 'cp-particles';
    Object.assign(canvas.style, {
      position: 'fixed', inset: '0', width: '100%', height: '100%',
      pointerEvents: 'none', zIndex: '0', opacity: '1'
    });
    document.body.prepend(canvas);

    const ctx = canvas.getContext('2d');
    let W, H, particles = [], raf;

    const EMOJIS_GREEN = ['🐾', '🐶', '🐱', '❤️', '✨', '🌿', '💚'];
    const EMOJIS_NEON  = ['💜', '⚡', '🌟', '✨', '🔮', '💫', '🦋'];
    const EMOJIS_DARK  = ['🐾', '🌙', '⭐', '✨', '🐱', '🌿'];

    function getTheme() {
      const b = document.body;
      if (b.classList.contains('theme-neon') || b.classList.contains('neon-mode')) return 'neon';
      if (b.classList.contains('theme-dark') || b.classList.contains('dark-mode')) return 'dark';
      return 'light';
    }

    function getConfig() {
      const t = getTheme();
      if (t === 'neon') return {
        emojis: EMOJIS_NEON,
        colors: ['rgba(180,0,255,','rgba(124,0,255,','rgba(0,212,255,','rgba(255,0,200,','rgba(130,0,230,']
      };
      if (t === 'dark') return {
        emojis: EMOJIS_DARK,
        colors: ['rgba(0,200,117,','rgba(0,245,160,','rgba(0,108,68,','rgba(120,255,200,','rgba(0,150,80,']
      };
      return {
        emojis: EMOJIS_GREEN,
        colors: ['rgba(0,200,117,','rgba(0,245,160,','rgba(0,108,68,','rgba(120,255,200,','rgba(0,150,80,']
      };
    }

    function resize() {
      W = canvas.width  = window.innerWidth;
      H = canvas.height = window.innerHeight;
    }

    class Particle {
      constructor() { this.reset(true); }
      reset(initial = false) {
        const cfg = getConfig();
        this.x    = Math.random() * W;
        this.y    = initial ? Math.random() * H : H + 40;
        this.size = 6 + Math.random() * 20;
        this.speedY = 0.2 + Math.random() * 0.5;
        this.speedX = (Math.random() - 0.5) * 0.5;
        this.opacity = 0;
        this.targetOpacity = 0.05 + Math.random() * 0.12;
        this.angle  = Math.random() * Math.PI * 2;
        this.spin   = (Math.random() - 0.5) * 0.015;
        this.wobble = Math.random() * Math.PI * 2;
        this.wobbleSpeed = 0.01 + Math.random() * 0.015;
        this.isEmoji = Math.random() < 0.30;
        this.emoji = cfg.emojis[Math.floor(Math.random() * cfg.emojis.length)];
        this.color = cfg.colors[Math.floor(Math.random() * cfg.colors.length)];
        this.radius = this.size / 2;
        // neon gets extra glow
        this.hasGlow = getTheme() === 'neon' && Math.random() < 0.5;
      }
      update() {
        this.wobble += this.wobbleSpeed;
        this.x += this.speedX + Math.sin(this.wobble) * 0.4;
        this.y -= this.speedY;
        this.angle += this.spin;
        if (this.opacity < this.targetOpacity) this.opacity += 0.003;
        if (this.y < -60) this.reset();
      }
      draw() {
        ctx.save();
        ctx.translate(this.x, this.y);
        ctx.rotate(this.angle);
        ctx.globalAlpha = this.opacity;
        if (this.isEmoji) {
          ctx.font = `${this.size * 1.7}px serif`;
          ctx.textAlign = 'center';
          ctx.textBaseline = 'middle';
          if (this.hasGlow) {
            ctx.shadowColor = 'rgba(180,0,255,.8)';
            ctx.shadowBlur = 18;
          }
          ctx.fillText(this.emoji, 0, 0);
        } else {
          if (this.hasGlow) {
            ctx.shadowColor = this.color + '0.9)';
            ctx.shadowBlur = 22;
          }
          ctx.beginPath();
          ctx.arc(0, 0, this.radius, 0, Math.PI * 2);
          ctx.fillStyle = this.color + this.opacity + ')';
          ctx.fill();
          const grad = ctx.createRadialGradient(0, 0, 0, 0, 0, this.radius);
          grad.addColorStop(0, this.color + (this.opacity * 1.6) + ')');
          grad.addColorStop(1, this.color + '0)');
          ctx.fillStyle = grad;
          ctx.fill();
        }
        ctx.restore();
      }
    }

    function spawnParticles() {
      const count = Math.min(Math.floor(W / 16), 80);
      particles = Array.from({ length: count }, () => new Particle());
    }

    window.spawnAll = spawnParticles; // expose for theme toggle

    function loop() {
      ctx.clearRect(0, 0, W, H);
      particles.forEach(p => { p.update(); p.draw(); });
      if (particles.length < 90 && Math.random() < 0.05) {
        particles.push(new Particle());
      }
      raf = requestAnimationFrame(loop);
    }

    resize();
    spawnParticles();
    loop();
    window.addEventListener('resize', () => { resize(); spawnParticles(); });
    document.addEventListener('visibilitychange', () => {
      if (document.hidden) cancelAnimationFrame(raf);
      else loop();
    });
  }

  /* ─────────────────────────────────────────────────────────
     2. TEMA — 3 MODOS (light → dark → neon → light…)
  ───────────────────────────────────────────────────────── */
  function initThemeToggle() {
    const btn = document.getElementById('themeToggle');
    if (!btn) return;

    const THEMES = [
      { key: 'light', label: '<i class="ti ti-leaf"></i> Verde', classes: [] },
      { key: 'dark',  label: '<i class="ti ti-moon-stars"></i> Oscuro', classes: ['theme-dark','dark-mode'] },
      { key: 'neon',  label: '<i class="ti ti-sparkles"></i> Neon', classes: ['theme-neon','neon-mode'] },
    ];
    // All classes to remove on theme switch
    const ALL_THEME_CLASSES = ['theme-dark','theme-neon','dark-mode','neon-mode'];

    function applyTheme(key) {
      ALL_THEME_CLASSES.forEach(c => document.body.classList.remove(c));
      const t = THEMES.find(x => x.key === key) || THEMES[0];
      t.classes.forEach(c => document.body.classList.add(c));
      // next button label = next theme name
      const nextIdx = (THEMES.indexOf(t) + 1) % THEMES.length;
      btn.innerHTML = THEMES[nextIdx].label;
      localStorage.setItem('clinipetTheme', key);
      if (window.spawnAll) window.spawnAll();
    }

    // restore on load
    const saved = localStorage.getItem('clinipetTheme') || 'light';
    applyTheme(saved);

    btn.addEventListener('click', function () {
      let cur = localStorage.getItem('clinipetTheme') || 'light';
      const idx = THEMES.findIndex(t => t.key === cur);
      const next = THEMES[(idx + 1) % THEMES.length];
      applyTheme(next.key);
    });
  }

  /* ─────────────────────────────────────────────────────────
     3. TYPEWRITER
  ───────────────────────────────────────────────────────── */
  function initTypewriter() {
    document.querySelectorAll('[data-typewriter]').forEach(el => {
      const text  = el.dataset.typewriter;
      const speed = parseInt(el.dataset.twSpeed) || 55;
      const loop  = el.dataset.twLoop === 'true';
      const pause = parseInt(el.dataset.twPause) || 2200;
      const cursor = document.createElement('span');
      cursor.className = 'tw-cursor';
      cursor.textContent = '|';
      el.textContent = '';
      el.appendChild(cursor);

      function type(str, cb) {
        let i = 0;
        const iv = setInterval(() => {
          el.insertBefore(document.createTextNode(str[i++]), cursor);
          if (i >= str.length) { clearInterval(iv); cb && cb(); }
        }, speed);
      }
      function erase(cb) {
        const iv = setInterval(() => {
          const nodes = Array.from(el.childNodes).filter(n => n.nodeType === 3);
          if (!nodes.length) { clearInterval(iv); cb && cb(); return; }
          const last = nodes[nodes.length - 1];
          if (last.textContent.length > 1) last.textContent = last.textContent.slice(0, -1);
          else el.removeChild(last);
        }, speed / 2);
      }
      function run() {
        type(text, () => {
          if (loop) setTimeout(() => erase(() => setTimeout(run, 300)), pause);
        });
      }
      const obs = new IntersectionObserver(entries => {
        if (entries[0].isIntersecting) { obs.disconnect(); run(); }
      }, { threshold: 0.5 });
      obs.observe(el);
    });

    if (!document.getElementById('tw-style')) {
      const s = document.createElement('style');
      s.id = 'tw-style';
      s.textContent = `.tw-cursor{display:inline-block;width:2px;background:currentColor;margin-left:2px;animation:twBlink .7s step-end infinite}@keyframes twBlink{0%,100%{opacity:1}50%{opacity:0}}`;
      document.head.appendChild(s);
    }
  }

  /* ─────────────────────────────────────────────────────────
     4. SCROLL REVEAL
  ───────────────────────────────────────────────────────── */
  function initScrollReveal() {
    if (!document.getElementById('sr-style')) {
      const s = document.createElement('style');
      s.id = 'sr-style';
      s.textContent = `
        .reveal,.reveal-left,.reveal-right,.reveal-scale{
          opacity:0;transition:opacity .7s cubic-bezier(.22,1,.36,1),
            transform .7s cubic-bezier(.22,1,.36,1);will-change:transform,opacity}
        .reveal{transform:translateY(40px)}
        .reveal-left{transform:translateX(-50px)}
        .reveal-right{transform:translateX(50px)}
        .reveal-scale{transform:scale(.88)}
        .revealed{opacity:1!important;transform:none!important}
        .stagger-children>*{opacity:0;transform:translateY(32px);
          transition:opacity .6s cubic-bezier(.22,1,.36,1),
            transform .6s cubic-bezier(.22,1,.36,1)}
        .stagger-children.revealed>*{opacity:1;transform:none}
      `;
      document.head.appendChild(s);
    }

    const targets = document.querySelectorAll(
      '.reveal, .reveal-left, .reveal-right, .reveal-scale, .stagger-children'
    );
    const obs = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return;
        const el = entry.target;
        const delay = parseFloat(el.dataset.delay) || 0;
        if (el.classList.contains('stagger-children')) {
          setTimeout(() => {
            el.classList.add('revealed');
            Array.from(el.children).forEach((child, i) => {
              child.style.transitionDelay = (delay + i * 0.1) + 's';
            });
          }, delay * 1000);
        } else {
          el.style.transitionDelay = delay + 's';
          setTimeout(() => el.classList.add('revealed'), 20);
        }
        obs.unobserve(el);
      });
    }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });
    targets.forEach(el => obs.observe(el));
  }

  /* ─────────────────────────────────────────────────────────
     5. SMOOTH SECTIONS / PARALLAX
  ───────────────────────────────────────────────────────── */
  function initSmoothSections() {
    const hero = document.querySelector('.hero, .public-hero');
    if (hero) {
      let ticking = false;
      window.addEventListener('scroll', () => {
        if (!ticking) {
          requestAnimationFrame(() => {
            const y = window.scrollY;
            const orb = hero.querySelector('.hero-orb');
            if (orb) orb.style.transform = `translateY(calc(-50% + ${y * 0.18}px))`;
            hero.querySelectorAll('.hero-chip').forEach((chip, i) => {
              chip.style.transform = `translateY(${y * (i % 2 === 0 ? 0.12 : -0.08)}px)`;
            });
            const textCol = hero.querySelector('.hero-text-col');
            if (textCol) textCol.style.transform = `translateY(${y * 0.06}px)`;
            ticking = false;
          });
          ticking = true;
        }
      }, { passive: true });
    }

    const nav = document.querySelector('.nav-public');
    if (nav) {
      window.addEventListener('scroll', () => {
        if (window.scrollY > 60) {
          nav.style.backdropFilter = 'blur(28px)';
          nav.style.boxShadow = '0 6px 50px rgba(0,10,5,.45), 0 1px 0 rgba(0,245,160,.2)';
        } else {
          nav.style.backdropFilter = '';
          nav.style.boxShadow = '';
        }
      }, { passive: true });
    }

    document.querySelectorAll(
      '.section > .container-cp > *:not(.section-head-row):not(.section-head)'
    ).forEach((el, i) => {
      if (!el.classList.contains('reveal') && !el.classList.contains('reveal-left') &&
          !el.classList.contains('reveal-right') && !el.classList.contains('reveal-scale') &&
          !el.classList.contains('stagger-children')) {
        el.classList.add('reveal');
        el.dataset.delay = (i * 0.06).toFixed(2);
      }
    });
    initScrollReveal();
  }

  /* ─────────────────────────────────────────────────────────
     6. NUMBER COUNTER
  ───────────────────────────────────────────────────────── */
  function initCounters() {
    document.querySelectorAll('[data-count]').forEach(el => {
      const target = parseFloat(el.dataset.count);
      const prefix = el.dataset.prefix || '';
      const suffix = el.dataset.suffix || '';
      const isFloat = el.dataset.float === 'true';
      const duration = 1800;
      let start = null;
      const obs = new IntersectionObserver(entries => {
        if (!entries[0].isIntersecting) return;
        obs.disconnect();
        function step(ts) {
          if (!start) start = ts;
          const prog = Math.min((ts - start) / duration, 1);
          const ease = prog === 1 ? 1 : 1 - Math.pow(2, -10 * prog);
          const val = target * ease;
          el.textContent = prefix + (isFloat ? val.toFixed(1) : Math.floor(val).toLocaleString('es-CO')) + suffix;
          if (prog < 1) requestAnimationFrame(step);
        }
        requestAnimationFrame(step);
      }, { threshold: 0.5 });
      obs.observe(el);
    });
  }

  /* ─────────────────────────────────────────────────────────
     7. HOVER TILT en cards
  ───────────────────────────────────────────────────────── */
  function initTilt() {
    const cards = document.querySelectorAll('.card-cp, .kpi-card, .service-card, .product-card');
    cards.forEach(card => {
      card.addEventListener('mousemove', e => {
        const rect = card.getBoundingClientRect();
        const cx = rect.left + rect.width / 2;
        const cy = rect.top + rect.height / 2;
        const dx = (e.clientX - cx) / (rect.width / 2);
        const dy = (e.clientY - cy) / (rect.height / 2);
        card.style.transform = `perspective(900px) rotateY(${dx * 5}deg) rotateX(${-dy * 5}deg) translateY(-8px) scale(1.02)`;
        card.style.transition = 'transform .08s ease';
      });
      card.addEventListener('mouseleave', () => {
        card.style.transform = '';
        card.style.transition = 'transform .5s cubic-bezier(.22,1,.36,1)';
      });
    });
  }

  /* ─────────────────────────────────────────────────────────
     8. PAGE TRANSITION
  ───────────────────────────────────────────────────────── */
  function initPageTransitions() {
    const overlay = document.createElement('div');
    overlay.id = 'cp-page-overlay';
    Object.assign(overlay.style, {
      position: 'fixed', inset: '0', zIndex: '9999',
      background: 'linear-gradient(135deg, #001a0f, #003d25)',
      opacity: '0', pointerEvents: 'none',
      transition: 'opacity .38s cubic-bezier(.4,0,.2,1)',
      display: 'flex', alignItems: 'center', justifyContent: 'center'
    });
    overlay.innerHTML = `<div style="font-family:'Fredoka',sans-serif;font-size:2.5rem;color:#00f5a0;opacity:0;transition:opacity .25s .1s;display:flex;align-items:center;gap:14px" id="cp-overlay-logo">
      <span style="font-size:3rem">🐾</span> CliniPet
    </div>`;
    document.body.appendChild(overlay);

    // Limpiar flag si venimos de un redirect del servidor (hay ?info= / ?error= / ?msg= en la URL)
    const _qs = window.location.search;
    if (_qs.includes('info=') || _qs.includes('error=') || _qs.includes('msg=')) {
      sessionStorage.removeItem('cp-transitioning');
    }

    window.addEventListener('load', () => {
      if (sessionStorage.getItem('cp-transitioning')) {
        sessionStorage.removeItem('cp-transitioning');
        overlay.style.opacity = '1';
        overlay.style.pointerEvents = 'all';
        document.getElementById('cp-overlay-logo').style.opacity = '1';
        setTimeout(() => {
          overlay.style.opacity = '0';
          overlay.style.pointerEvents = 'none';
          document.getElementById('cp-overlay-logo').style.opacity = '0';
        }, 120);
      } else {
        // Garantizar que el overlay nunca quede pegado en redirects del servidor
        overlay.style.opacity = '0';
        overlay.style.pointerEvents = 'none';
      }
    });

    // Safety: forzar limpieza a los 800ms por si el evento load llegó tarde
    setTimeout(() => {
      overlay.style.opacity = '0';
      overlay.style.pointerEvents = 'none';
      sessionStorage.removeItem('cp-transitioning');
    }, 800);

    document.addEventListener('click', e => {
      const link = e.target.closest('a[href]');
      if (!link) return;
      // No interceptar links dentro de formularios (el form hace POST, no navegación)
      if (link.closest('form')) return;
      if (e.target.closest('form')) return;
      const href = link.getAttribute('href');
      if (!href || href.startsWith('#') || href.startsWith('javascript') ||
          href.startsWith('http') || href.startsWith('mailto') ||
          href.startsWith('tel') || link.target === '_blank') return;
      e.preventDefault();
      sessionStorage.setItem('cp-transitioning', '1');
      overlay.style.opacity = '1';
      overlay.style.pointerEvents = 'all';
      const logo = document.getElementById('cp-overlay-logo');
      if (logo) logo.style.opacity = '1';
      setTimeout(() => { window.location.href = href; }, 380);
    });
  }

  /* ─────────────────────────────────────────────────────────
     9. AUTO-TAG REVEAL
  ───────────────────────────────────────────────────────── */
  function autoTagReveal() {
    document.querySelectorAll('.section-head, .section-head-row').forEach(el => {
      if (!el.classList.contains('reveal')) el.classList.add('reveal');
    });
    const servGrid = document.querySelector('.services-grid');
    if (servGrid && !servGrid.classList.contains('stagger-children'))
      servGrid.classList.add('stagger-children');
    const prodGrid = document.querySelector('.products-grid');
    if (prodGrid && !prodGrid.classList.contains('stagger-children'))
      prodGrid.classList.add('stagger-children');
    const kpiGrid = document.querySelector('.kpi-grid');
    if (kpiGrid && !kpiGrid.classList.contains('stagger-children'))
      kpiGrid.classList.add('stagger-children');
    document.querySelectorAll('.about-img').forEach(el => {
      if (!el.classList.contains('reveal-left')) el.classList.add('reveal-left');
    });
    document.querySelectorAll('.about-card').forEach(el => {
      if (!el.classList.contains('reveal-right')) el.classList.add('reveal-right');
    });
    document.querySelectorAll('.benefits-bar, .benefit-item').forEach((el, i) => {
      if (!el.classList.contains('reveal')) {
        el.classList.add('reveal');
        el.dataset.delay = (i * 0.07).toFixed(2);
      }
    });
    document.querySelectorAll('.location-card, .contact-info').forEach(el => {
      if (!el.classList.contains('reveal')) el.classList.add('reveal');
    });
    document.querySelectorAll('.cta-section').forEach(el => {
      if (!el.classList.contains('reveal-scale')) el.classList.add('reveal-scale');
    });
    document.querySelectorAll('.nav-menu a').forEach((el, i) => {
      el.style.opacity = '0';
      el.style.transform = 'translateX(-20px)';
      el.style.transition = `opacity .5s ${0.05 + i * 0.07}s ease, transform .5s ${0.05 + i * 0.07}s ease`;
      setTimeout(() => { el.style.opacity = ''; el.style.transform = ''; }, 100);
    });
    document.querySelectorAll('.cp-table tbody tr').forEach((tr, i) => {
      tr.style.opacity = '0';
      tr.style.transform = 'translateX(-12px)';
      tr.style.transition = `opacity .4s ${i * 0.04}s ease, transform .4s ${i * 0.04}s ease`;
      setTimeout(() => { tr.style.opacity = ''; tr.style.transform = ''; }, 200);
    });
    document.querySelectorAll('.auth-feat').forEach((el, i) => {
      el.style.opacity = '0';
      el.style.transform = 'translateX(-18px)';
      el.style.transition = `opacity .55s ${0.4 + i * 0.12}s ease, transform .55s ${0.4 + i * 0.12}s ease`;
      setTimeout(() => { el.style.opacity = ''; el.style.transform = ''; }, 100);
    });
  }

  /* ─────────────────────────────────────────────────────────
     10. CHATBOT — activo en todas las páginas
  ───────────────────────────────────────────────────────── */
  function initChatbot() {
    /* Inyectar estilos del chatbot si no existen */
    if (!document.getElementById('cp-chat-styles')) {
      const s = document.createElement('style');
      s.id = 'cp-chat-styles';
      s.textContent = `
        /* ═══════════════════════════════════════════
           PETBOT CLINIPET — Chatbot completo
        ═══════════════════════════════════════════ */
        @import url('https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&display=swap');

        #cp-chatbot{
          position:fixed;bottom:28px;right:28px;z-index:99999;
          font-family:'Nunito',sans-serif
        }

        /* ── Burbuja flotante ── */
        #cp-chat-bubble{
          width:64px;height:64px;border-radius:50%;border:0;cursor:pointer;
          background:linear-gradient(145deg,#00c875,#00f5a0);
          color:#003d25;font-size:1.75rem;
          display:flex;align-items:center;justify-content:center;
          box-shadow:0 8px 24px rgba(0,200,117,.45),0 0 0 0 rgba(0,200,117,.4);
          transition:transform .25s,box-shadow .25s;
          position:relative;
          animation:cpPulse 2.8s ease-in-out infinite
        }
        @keyframes cpPulse{
          0%,100%{box-shadow:0 8px 24px rgba(0,200,117,.45),0 0 0 0 rgba(0,200,117,.4)}
          50%{box-shadow:0 12px 32px rgba(0,200,117,.5),0 0 0 12px rgba(0,200,117,0)}
        }
        #cp-chat-bubble:hover{
          transform:scale(1.12) rotate(-5deg);
          box-shadow:0 18px 44px rgba(0,200,117,.55);
          animation:none
        }
        #cp-chat-bubble:active{transform:scale(.97)}

        /* Notificación roja */
        .chat-notif{
          position:absolute;top:-3px;right:-3px;
          background:linear-gradient(135deg,#ef4444,#f97316);
          color:white;font-size:.68rem;font-weight:900;
          width:22px;height:22px;border-radius:50%;
          display:flex;align-items:center;justify-content:center;
          border:2.5px solid white;
          box-shadow:0 2px 8px rgba(239,68,68,.4);
          animation:cpBadgePop .4s cubic-bezier(.34,1.56,.64,1) both
        }
        @keyframes cpBadgePop{from{transform:scale(0)}to{transform:scale(1)}}

        /* ── Ventana del chat ── */
        #cp-chat-window{
          position:absolute;bottom:80px;right:0;
          width:350px;
          background:white;border-radius:28px;
          box-shadow:0 28px 80px rgba(0,40,20,.22),0 4px 20px rgba(0,0,0,.08);
          display:none;flex-direction:column;overflow:hidden;
          border:1px solid rgba(0,200,117,.15);
          transform:scale(.85) translateY(16px);
          opacity:0;
          transition:transform .3s cubic-bezier(.34,1.56,.64,1),opacity .25s ease
        }
        #cp-chat-window.open{
          display:flex;
          animation:chatOpen .35s cubic-bezier(.34,1.56,.64,1) forwards
        }
        @keyframes chatOpen{
          from{transform:scale(.85) translateY(16px);opacity:0}
          to{transform:scale(1) translateY(0);opacity:1}
        }

        /* ── Header ── */
        #cp-chat-head{
          background:linear-gradient(135deg,#002d1c 0%,#004d2e 50%,#006b3c 100%);
          padding:16px 18px;
          display:flex;align-items:center;gap:12px;
          position:relative;overflow:hidden
        }
        #cp-chat-head::before{
          content:'';position:absolute;top:-30px;right:-30px;
          width:90px;height:90px;border-radius:50%;
          background:rgba(0,200,117,.12)
        }
        #cp-chat-head::after{
          content:'';position:absolute;bottom:-20px;left:40px;
          width:60px;height:60px;border-radius:50%;
          background:rgba(0,200,117,.08)
        }
        .chat-avatar{
          width:44px;height:44px;border-radius:50%;
          background:linear-gradient(135deg,rgba(255,255,255,.2),rgba(255,255,255,.08));
          border:2px solid rgba(255,255,255,.25);
          display:flex;align-items:center;justify-content:center;
          font-size:1.5rem;flex-shrink:0;position:relative;z-index:1
        }
        .chat-head-info{position:relative;z-index:1;flex:1}
        #cp-chat-head h4{margin:0 0 2px;color:white;font-size:1rem;font-weight:800;letter-spacing:-.01em}
        #cp-chat-head p{margin:0;color:rgba(255,255,255,.68);font-size:.76rem;font-weight:700;
                        display:flex;align-items:center;gap:5px}
        .chat-status-dot{
          width:7px;height:7px;border-radius:50%;background:#00f5a0;
          display:inline-block;box-shadow:0 0 0 2px rgba(0,245,160,.3);
          animation:blink 2s ease-in-out infinite
        }
        @keyframes blink{0%,100%{opacity:1}50%{opacity:.4}}
        .chat-close{
          position:relative;z-index:1;
          margin-left:auto;border:0;background:rgba(255,255,255,.12);
          color:white;width:32px;height:32px;border-radius:50%;
          cursor:pointer;display:flex;align-items:center;justify-content:center;
          transition:.2s;font-size:1rem;flex-shrink:0;
          border:1px solid rgba(255,255,255,.15)
        }
        .chat-close:hover{background:rgba(255,255,255,.25);transform:rotate(90deg)}

        /* ── Mensajes ── */
        #cp-chat-messages{
          flex:1;overflow-y:auto;padding:18px 14px;
          display:flex;flex-direction:column;gap:12px;
          max-height:320px;background:#f9fffe
        }
        #cp-chat-messages::-webkit-scrollbar{width:4px}
        #cp-chat-messages::-webkit-scrollbar-thumb{background:#00c875;border-radius:4px}
        #cp-chat-messages::-webkit-scrollbar-track{background:transparent}

        .chat-msg{
          max-width:88%;padding:11px 15px;border-radius:18px;
          font-size:.875rem;font-weight:700;line-height:1.55;
          animation:msgIn .3s cubic-bezier(.34,1.56,.64,1) both
        }
        @keyframes msgIn{from{opacity:0;transform:scale(.8) translateY(8px)}to{opacity:1;transform:scale(1) translateY(0)}}
        .chat-msg.bot{
          background:white;
          border:1.5px solid #e4f5ec;
          color:#1a3a2a;
          border-bottom-left-radius:5px;
          align-self:flex-start;
          box-shadow:0 2px 8px rgba(0,60,35,.07)
        }
        .chat-msg.bot a{color:#00a85a;font-weight:800}
        .chat-msg.user{
          background:linear-gradient(135deg,#003d25,#006b3c);
          color:white;border-bottom-right-radius:5px;
          align-self:flex-end;
          box-shadow:0 4px 14px rgba(0,61,37,.28)
        }
        .chat-msg.typing{
          background:white;border:1.5px solid #e4f5ec;
          align-self:flex-start;padding:14px 18px;
          box-shadow:0 2px 8px rgba(0,60,35,.07)
        }
        .typing-dots{display:flex;gap:5px;align-items:center}
        .typing-dots span{
          width:9px;height:9px;
          background:linear-gradient(135deg,#00c875,#00f5a0);
          border-radius:50%;
          animation:cpTyping 1s infinite ease-in-out
        }
        .typing-dots span:nth-child(2){animation-delay:.2s}
        .typing-dots span:nth-child(3){animation-delay:.4s}
        @keyframes cpTyping{0%,100%{transform:scale(.7);opacity:.4}50%{transform:scale(1.2);opacity:1}}

        /* ── Fecha / timestamp ── */
        .chat-time{font-size:.65rem;color:#94a3b8;font-weight:700;text-align:center;
                   margin:2px 0;letter-spacing:.02em}

        /* ── Quick-reply buttons ── */
        .chat-quick-btns{
          display:flex;flex-wrap:wrap;gap:7px;
          margin-top:4px;align-self:flex-start
        }
        .chat-qbtn{
          border:1.5px solid #00c875;background:white;color:#003d25;
          border-radius:999px;padding:6px 14px;font-size:.78rem;font-weight:800;
          cursor:pointer;transition:all .2s;font-family:inherit;
          box-shadow:0 2px 8px rgba(0,200,117,.12)
        }
        .chat-qbtn:hover{background:linear-gradient(135deg,#00c875,#00f5a0);color:#003d25;
                         transform:translateY(-2px);box-shadow:0 6px 16px rgba(0,200,117,.25)}

        /* ── Input row ── */
        #cp-chat-input-row{
          display:flex;border-top:1.5px solid #e8f5ef;
          background:white;padding:12px 12px;gap:8px;align-items:center
        }
        #cp-chat-input{
          flex:1;border:1.5px solid #dbeee5;border-radius:24px;
          padding:10px 16px;font-size:.875rem;font-family:inherit;
          font-weight:700;outline:none;transition:.2s;background:#f8fffb;
          color:#1a3a2a
        }
        #cp-chat-input::placeholder{color:#94a3b8;font-weight:600}
        #cp-chat-input:focus{
          border-color:#00c875;
          box-shadow:0 0 0 3px rgba(0,200,117,.14);
          background:white
        }
        #cp-chat-send{
          width:42px;height:42px;border:0;border-radius:50%;
          background:linear-gradient(135deg,#003d25,#006b3c);
          color:white;cursor:pointer;font-size:1.05rem;
          display:flex;align-items:center;justify-content:center;
          flex-shrink:0;transition:.2s;
          box-shadow:0 6px 18px rgba(0,61,37,.3)
        }
        #cp-chat-send:hover{transform:scale(1.1) rotate(-10deg);
                             box-shadow:0 10px 24px rgba(0,61,37,.4)}
        #cp-chat-send:active{transform:scale(.93)}

        /* ── Branding footer ── */
        #cp-chat-brand{
          text-align:center;padding:7px 12px;
          font-size:.68rem;font-weight:800;color:#b0c9bb;
          border-top:1px solid #f0f7f3;background:white;letter-spacing:.02em
        }
        #cp-chat-brand span{color:#00c875}

        @media(max-width:420px){
          #cp-chat-window{width:calc(100vw - 36px);right:-4px}
        }
      `;
      document.head.appendChild(s);
    }

    const chatHTML = `
    <div id="cp-chatbot">
      <div id="cp-chat-window">
        <div id="cp-chat-head">
          <div class="chat-avatar">🐾</div>
          <div class="chat-head-info">
            <h4>PetBot CliniPet</h4>
            <p><span class="chat-status-dot"></span> En línea · Responde al instante</p>
          </div>
          <button class="chat-close" id="cp-chat-close" title="Cerrar chat">
            <i class="ti ti-x"></i>
          </button>
        </div>
        <div id="cp-chat-messages"></div>
        <div id="cp-chat-input-row">
          <input type="text" id="cp-chat-input" placeholder="Escribe tu pregunta…" autocomplete="off" maxlength="200">
          <button id="cp-chat-send" title="Enviar"><i class="ti ti-send-2"></i></button>
        </div>
        <div id="cp-chat-brand">Impulsado por <span>CliniPet IA</span> · SENA CIMM</div>
      </div>
      <button id="cp-chat-bubble" title="Chat con PetBot">
        <i class="ti ti-message-circle-heart"></i>
        <span class="chat-notif">1</span>
      </button>
    </div>`;

    document.body.insertAdjacentHTML('beforeend', chatHTML);

    const window_ = document.getElementById('cp-chat-window');
    const bubble  = document.getElementById('cp-chat-bubble');
    const messages = document.getElementById('cp-chat-messages');
    const input   = document.getElementById('cp-chat-input');
    const sendBtn = document.getElementById('cp-chat-send');
    const closeBtn = document.getElementById('cp-chat-close');

    const KB = [
      { keys: ['hola','buenas','hey','saludos'], ans: '¡Hola! 👋 Soy PetBot, el asistente virtual de CliniPet. ¿En qué te puedo ayudar hoy?' },
      { keys: ['horario','hora','abren','cierran'], ans: '⏰ Nuestro horario es <strong>lunes a viernes de 8:00 a.m. a 5:00 p.m.</strong> Cualquier duda fuera de ese horario puedes escribirnos por WhatsApp.' },
      { keys: ['cita','agendar','agenda','consulta'], ans: '📅 Puedes agendar tu cita fácilmente desde el menú <strong>"Pedir cita"</strong> en la navegación, o iniciando sesión en tu panel de cliente.' },
      { keys: ['precio','costo','cuanto','vale'], ans: '💰 Los precios varían según el servicio. Para una cotización exacta te recomendamos <a href="/citas/nueva" style="color:var(--cp-400)">agendar una consulta</a> o escribirnos por WhatsApp.' },
      { keys: ['producto','tienda','comprar','pedido'], ans: '🛍️ Puedes ver nuestros productos en esta misma página en la sección <strong>"Productos más vendidos"</strong>. Para comprar el catálogo completo debes registrarte o iniciar sesión.' },
      { keys: ['whatsapp','contacto','teléfono','llamar'], ans: '📱 Puedes contactarnos por WhatsApp al <strong>320 496 3536</strong>. ¡Te respondemos a la brevedad!' },
      { keys: ['dirección','ubicación','donde','dónde'], ans: '📍 Estamos ubicados en el <strong>SENA CIMM, Sogamoso, Boyacá</strong>. Puedes ver el mapa en la sección "Ubicación" de esta página.' },
      { keys: ['registro','cuenta','registrar'], ans: '👤 Crear tu cuenta es <strong>totalmente gratis</strong>. Solo haz clic en "Registrarse" en la barra de navegación. Con tu cuenta accedes a la tienda completa y puedes agendar citas.' },
      { keys: ['vacuna','vacunación','desparasit'], ans: '💉 Ofrecemos servicios de vacunación y control preventivo. Puedes agendar directamente desde la web. ¡Mantén a tu mascota protegida!' },
      { keys: ['baño','estética','aseo','groomin'], ans: '🛁 Contamos con servicios de bienestar y cuidado para tu mascota. Contáctanos para consultar disponibilidad.' },
      { keys: ['pago','transferencia','efectivo'], ans: '💳 Aceptamos varios métodos de pago. Para más información sobre opciones de pago, comunícate con nosotros por WhatsApp.' },
      { keys: ['gracias','excelente','perfecto','genial'], ans: '¡Con mucho gusto! 🐾 Si necesitas algo más, aquí estaré. ¡Que tu mascota tenga un día excelente! 💚' },
    ];

    const QUICK = ['Horarios', 'Agendar cita', 'Precios', 'Contacto'];

    function addMsg(text, from, showQuick) {
      // Timestamp
      const now = new Date();
      const timeStr = now.getHours().toString().padStart(2,'0') + ':' + now.getMinutes().toString().padStart(2,'0');
      const timeDiv = document.createElement('div');
      timeDiv.className = 'chat-time';
      timeDiv.textContent = timeStr;
      messages.appendChild(timeDiv);

      const div = document.createElement('div');
      div.className = 'chat-msg ' + from;
      div.innerHTML = text;
      messages.appendChild(div);
      if (showQuick) {
        const qDiv = document.createElement('div');
        qDiv.className = 'chat-quick-btns';
        QUICK.forEach(q => {
          const b = document.createElement('button');
          b.className = 'chat-qbtn';
          b.textContent = q;
          b.onclick = () => { b.closest('.chat-quick-btns').remove(); sendMsg(q); };
          qDiv.appendChild(b);
        });
        messages.appendChild(qDiv);
      }
      messages.scrollTop = messages.scrollHeight;
    }

    function showTyping() {
      const div = document.createElement('div');
      div.className = 'chat-msg typing';
      div.id = 'chat-typing';
      div.innerHTML = '<div class="typing-dots"><span></span><span></span><span></span></div>';
      messages.appendChild(div);
      messages.scrollTop = messages.scrollHeight;
    }

    function getAnswer(text) {
      const t = text.toLowerCase();
      for (const entry of KB) {
        if (entry.keys.some(k => t.includes(k))) return entry.ans;
      }
      return '🤔 No encontré esa información exacta. Te recomiendo escribirnos directamente por <strong>WhatsApp al 320 496 3536</strong> o llamarnos. ¡Con gusto te ayudamos!';
    }

    function sendMsg(text) {
      const msg = (text || input.value).trim();
      if (!msg) return;
      input.value = '';
      addMsg(msg, 'user', false);
      showTyping();
      setTimeout(() => {
        const t = document.getElementById('chat-typing');
        if (t) t.remove();
        addMsg(getAnswer(msg), 'bot', false);
      }, 900 + Math.random() * 500);
    }

    sendBtn.addEventListener('click', () => sendMsg());
    input.addEventListener('keydown', e => { if (e.key === 'Enter') sendMsg(); });

    function openChat() {
      window_.classList.add('open');
      bubble.querySelector('.chat-notif').style.display = 'none';
      if (messages.children.length === 0) {
        setTimeout(() => {
          addMsg('¡Hola! 👋 Soy <strong>PetBot</strong>, el asistente de CliniPet. ¿En qué te puedo ayudar?', 'bot', true);
        }, 350);
      }
    }
    function closeChat() { window_.classList.remove('open'); }

    bubble.addEventListener('click', openChat);
    closeBtn.addEventListener('click', closeChat);
  }

  /* ─────────────────────────────────────────────────────────
     11. ACTIVE NAV LINK (highlight al hacer scroll)
  ───────────────────────────────────────────────────────── */
  function initActiveNav() {
    const sections = document.querySelectorAll('section[id]');
    const links = document.querySelectorAll('.nav-links a[href^="#"]');
    if (!sections.length || !links.length) return;

    const obs = new IntersectionObserver(entries => {
      entries.forEach(e => {
        if (e.isIntersecting) {
          links.forEach(l => l.classList.remove('active'));
          const a = document.querySelector(`.nav-links a[href="#${e.target.id}"]`);
          if (a) a.classList.add('active');
        }
      });
    }, { rootMargin: '-40% 0px -55% 0px' });

    sections.forEach(s => obs.observe(s));
  }

  /* ─────────────────────────────────────────────────────────
     12. RIPPLE en botones
  ───────────────────────────────────────────────────────── */
  function initRipple() {
    const style = document.createElement('style');
    style.textContent = `@keyframes cpRippleAnim{to{transform:scale(4);opacity:0}}`;
    document.head.appendChild(style);

    document.querySelectorAll('.btn-cp, .btn-cp-outline, .btn-cp-ghost, .btn-nav-primary, .btn-nav-outline, .add-cart-btn').forEach(btn => {
      btn.style.position = 'relative';
      btn.style.overflow = 'hidden';
      btn.addEventListener('click', function(e) {
        const r = document.createElement('span');
        const rect = btn.getBoundingClientRect();
        Object.assign(r.style, {
          position: 'absolute',
          borderRadius: '50%',
          width: '10px', height: '10px',
          background: 'rgba(255,255,255,.5)',
          top: (e.clientY - rect.top - 5) + 'px',
          left: (e.clientX - rect.left - 5) + 'px',
          pointerEvents: 'none',
          animation: 'cpRippleAnim .55s ease-out forwards',
        });
        btn.appendChild(r);
        setTimeout(() => r.remove(), 600);
      });
    });
  }

  /* ─────────────────────────────────────────────────────────
     13. INIT
  ───────────────────────────────────────────────────────── */
  function init() {
    const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    initParticles();
    initThemeToggle();  // ← 3-modo tema
    autoTagReveal();
    initScrollReveal();
    initPageTransitions();
    initChatbot();
    initActiveNav();

    if (!prefersReduced) {
      initTypewriter();
      initSmoothSections();
      initCounters();
      initTilt();
      initRipple();
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

})();
