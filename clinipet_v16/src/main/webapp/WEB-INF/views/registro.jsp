<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Registro | CliniPet</title>
  <link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800;900&family=Fredoka:wght@500;600;700&display=swap" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/assets/css/clinipet.css" rel="stylesheet"/>
</head>
<body>

<div class="auth-layout">

  <!-- LADO IZQUIERDO -->
  <div class="auth-left">
    <div class="auth-left-photo" style="background-image:linear-gradient(180deg,rgba(0,20,12,.2),rgba(0,10,6,.6)),url('https://images.unsplash.com/photo-1587300003388-59208cc962cb?auto=format&fit=crop&w=1400&q=90');background-size:cover;background-position:center"></div>

    <a class="auth-brand" href="${pageContext.request.contextPath}/">
      <span class="auth-brand-icon"><i class="ti ti-paw"></i></span>
      <span>
        <div class="auth-brand-name">CliniPet</div>
        <div class="auth-brand-sub">Salud y amor para tu mascota</div>
      </span>
    </a>

    <div class="auth-left-content fade-up">
      <h2 class="auth-headline">Únete a la<br><span data-typewriter="familia CliniPet 🐶" data-tw-loop="true" data-tw-pause="3000" data-tw-speed="60"></span></h2>
      <p class="auth-desc">Crea tu cuenta en segundos y empieza a disfrutar de todos los beneficios de nuestra plataforma veterinaria.</p>
      <div class="auth-features">
        <div class="auth-feat"><i class="ti ti-rosette-discount-check"></i> Registro gratuito, sin complicaciones</div>
        <div class="auth-feat"><i class="ti ti-shopping-bag"></i> Acceso completo a la tienda online</div>
        <div class="auth-feat"><i class="ti ti-clock-check"></i> Agendamiento de citas 24/7</div>
      </div>
    </div>
  </div>

  <!-- LADO DERECHO -->
  <div class="auth-right">
    <div class="auth-form-box fade-up">

      <div class="auth-logo-mobile">
        <span style="margin:0 auto 12px;display:grid;place-items:center;width:64px;height:64px;border-radius:20px;background:var(--cp-100);color:var(--cp-500);font-size:2.2rem;">
          <i class="ti ti-paw"></i>
        </span>
        <div style="font-family:'Fredoka',sans-serif;font-size:2rem;color:var(--cp-900);font-weight:700">CliniPet</div>
      </div>

      <h2 class="auth-form-title">Crear cuenta 🐾</h2>
      <p class="auth-form-sub">Completa tus datos para registrarte</p>

      <% if(request.getAttribute("error") != null){ %>
        <div class="alert-cp alert-cp-error">
          <i class="ti ti-alert-circle"></i>
          <%= request.getAttribute("error") %>
        </div>
      <% } %>

      <form method="post" action="${pageContext.request.contextPath}/registro">

        <div class="row g-3 mb-3">
          <div class="col-12">
            <label class="form-label-cp">Nombre completo</label>
            <div class="input-group-cp">
              <i class="ti ti-user"></i>
              <input class="form-control-cp" name="nombre" placeholder="Tu nombre" required/>
            </div>
          </div>
          <div class="col-6">
            <label class="form-label-cp">Documento</label>
            <div class="input-group-cp">
              <i class="ti ti-id-badge-2"></i>
              <input class="form-control-cp" name="documento" placeholder="CC / NIT" required/>
            </div>
          </div>
          <div class="col-6">
            <label class="form-label-cp">Teléfono</label>
            <div class="input-group-cp">
              <i class="ti ti-phone"></i>
              <input class="form-control-cp" name="telefono" placeholder="3XX XXX XXXX" required/>
            </div>
          </div>
          <div class="col-12">
            <label class="form-label-cp">Dirección</label>
            <div class="input-group-cp">
              <i class="ti ti-map-pin"></i>
              <input class="form-control-cp" name="direccion" placeholder="Tu dirección" required/>
            </div>
          </div>
          <div class="col-12">
            <label class="form-label-cp">Correo electrónico</label>
            <div class="input-group-cp">
              <i class="ti ti-mail"></i>
              <input class="form-control-cp" type="email" name="correo" placeholder="correo@ejemplo.com" required/>
            </div>
          </div>
          <div class="col-12">
            <label class="form-label-cp">Contraseña</label>
            <div class="input-group-cp">
              <i class="ti ti-lock"></i>
              <input class="form-control-cp" type="password" name="contrasena" placeholder="Mínimo 6 caracteres" required/>
            </div>
          </div>
        </div>

        <button class="auth-btn-submit" type="submit">
          <i class="ti ti-user-plus"></i> Crear mi cuenta
        </button>

      </form>

      <div class="auth-divider">¿Ya tienes cuenta?</div>

      <a class="auth-btn-register" href="${pageContext.request.contextPath}/login">
        <i class="ti ti-login"></i> Iniciar sesión
      </a>

    </div>
  </div>

</div>

<script src="${pageContext.request.contextPath}/assets/js/animations.js"></script>
</body>
</html>
