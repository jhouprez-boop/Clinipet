<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>CliniPet | Iniciar sesión</title>
  <link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800;900&family=Fredoka:wght@500;600;700&display=swap" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/assets/css/clinipet.css" rel="stylesheet"/>
</head>
<body>

<div class="auth-layout">

  <!-- LADO IZQUIERDO — Foto + copy -->
  <div class="auth-left">
    <div class="auth-left-photo"></div>

    <a class="auth-brand" href="${pageContext.request.contextPath}/">
      <span class="auth-brand-icon"><i class="ti ti-paw"></i></span>
      <span>
        <div class="auth-brand-name">CliniPet</div>
        <div class="auth-brand-sub">Salud y amor para tu mascota</div>
      </span>
    </a>

    <div class="auth-left-content fade-up">
      <h2 class="auth-headline">Tu veterinaria,<br><span data-typewriter="siempre contigo 🐾" data-tw-loop="true" data-tw-pause="3200" data-tw-speed="60"></span></h2>
      <p class="auth-desc">Gestiona citas, compra productos y cuida la salud de tu mascota desde un solo lugar.</p>
      <div class="auth-features">
        <div class="auth-feat"><i class="ti ti-calendar-event"></i> Agenda citas veterinarias al instante</div>
        <div class="auth-feat"><i class="ti ti-shopping-cart"></i> Tienda online de productos pet</div>
        <div class="auth-feat"><i class="ti ti-heart-rate-monitor"></i> Historial clínico digital</div>
      </div>
    </div>
  </div>

  <!-- LADO DERECHO — Formulario -->
  <div class="auth-right">
    <div class="auth-form-box fade-up">

      <!-- Logo visible solo en móvil -->
      <div class="auth-logo-mobile">
        <span class="auth-brand-icon" style="margin:0 auto 12px;display:grid;place-items:center;width:64px;height:64px;border-radius:20px;background:var(--cp-100);color:var(--cp-500);font-size:2.2rem;">
          <i class="ti ti-paw"></i>
        </span>
        <div style="font-family:'Fredoka',sans-serif;font-size:2rem;color:var(--cp-900);font-weight:700">CliniPet</div>
      </div>

      <h2 class="auth-form-title">Bienvenido de nuevo 👋</h2>
      <p class="auth-form-sub">Inicia sesión para acceder a tu cuenta CliniPet</p>

      <% if(request.getAttribute("error") != null){ %>
        <div class="alert-cp alert-cp-error">
          <i class="ti ti-alert-circle"></i>
          <%= request.getAttribute("error") %>
        </div>
      <% } %>

      <form method="post" action="${pageContext.request.contextPath}/login">

        <div class="mb-3">
          <label class="form-label-cp">Correo electrónico</label>
          <div class="input-group-cp">
            <i class="ti ti-mail"></i>
            <input type="email" class="form-control-cp" name="correo"
                   placeholder="correo@clinipet.com" required/>
          </div>
        </div>

        <div class="mb-4">
          <label class="form-label-cp">Contraseña</label>
          <div class="input-group-cp">
            <i class="ti ti-lock"></i>
            <input type="password" class="form-control-cp" name="password"
                   placeholder="••••••••" required/>
          </div>
          <div style="text-align:right;margin-top:6px">
            <a href="${pageContext.request.contextPath}/recuperar"
               style="font-size:.85rem;font-weight:800;color:var(--cp-500);text-decoration:none">
              <i class="ti ti-lock-question"></i> ¿Olvidaste tu contraseña?
            </a>
          </div>
        </div>

        <button class="auth-btn-submit" type="submit">
          <i class="ti ti-login"></i> Ingresar al sistema
        </button>

      </form>

      <div class="auth-divider">o continúa con</div>

      <!-- Google Sign-In -->
      <div id="g_id_onload"
           data-client_id="91130037987-5q8no6ir6krd69scou894bbtc35q83fk.apps.googleusercontent.com"
           data-context="signin"
           data-ux_mode="redirect"
           data-login_uri="${pageContext.request.contextPath}/google-login"
           data-auto_prompt="false">
      </div>
      <div class="g_id_signin"
           data-type="standard"
           data-shape="rectangular"
           data-theme="outline"
           data-text="signin_with"
           data-size="large"
           data-locale="es"
           data-logo_alignment="left"
           style="display:flex;justify-content:center;margin-bottom:8px">
      </div>
      <p style="text-align:center;font-size:.78rem;color:#888;margin-bottom:16px">
        Al iniciar con Google aceptas los términos de uso de CliniPet.
      </p>

      <div class="auth-actions-row">
        <a href="${pageContext.request.contextPath}/" class="auth-btn-back" title="Volver al inicio">
          <i class="ti ti-paw"></i>
        </a>
        <a href="${pageContext.request.contextPath}/registro" class="auth-btn-register flex-fill">
          <i class="ti ti-user-plus"></i> Crear cuenta nueva
        </a>
      </div>

      <div class="auth-demo">
        <strong>Demo:</strong> admin@clinipet.com &nbsp;/&nbsp; 123456
      </div>

    </div>
  </div>

</div>

<script src="${pageContext.request.contextPath}/assets/js/animations.js"></script>
<script src="https://accounts.google.com/gsi/client" async defer></script>
</body>
</html>
