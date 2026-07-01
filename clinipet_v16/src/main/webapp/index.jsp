<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.clinipet.dao.ProductoDAO" %>
<%@ page import="com.clinipet.model.Producto" %>
<%@ page import="java.util.List" %>

<%
    ProductoDAO productoDAO = new ProductoDAO();
    List<Producto> productos = productoDAO.listarMasVendidos();
    final String WA_NUMBER = "573204963536";

    boolean logueado = session.getAttribute("usuario") != null;
    String loginUrl = request.getContextPath() + "/login";
%>

<!doctype html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>CliniPet | Salud y amor para tu mascota</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800;900&family=Fredoka:wght@500;600;700&display=swap" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/assets/css/clinipet.css" rel="stylesheet">
  <style>
    .especie-tab {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 8px 18px;
      border-radius: 50px;
      border: 2px solid #c7e5f9;
      background: white;
      color: #1268e3;
      font-weight: 700;
      font-size: .9rem;
      cursor: pointer;
      transition: all .18s;
    }
    .especie-tab:hover {
      background: #eef8ff;
      border-color: #4fa8ef;
    }
    .especie-tab.active {
      background: linear-gradient(135deg, #1268e3, #14b889);
      color: white;
      border-color: transparent;
      box-shadow: 0 4px 14px rgba(18,104,227,.25);
    }
  </style>
</head>
<body>

<!-- ═══════════ NAV ═══════════ -->
<nav class="nav-public">
  <div class="nav-inner">
    <a class="brand" href="#">
      <span class="brand-icon"><i class="ti ti-paw"></i></span>
      <span>
        <h2 class="brand-title">CliniPet</h2>
        <small>Salud y amor para tu mascota</small>
      </span>
    </a>

    <div class="nav-links">
      <a href="#servicios"><i class="ti ti-stethoscope"></i> Veterinaria</a>
      <a href="#productos"><i class="ti ti-shopping-bag"></i> Productos</a>
      <a href="#quienes"><i class="ti ti-users"></i> ¿Quiénes somos?</a>
      <a href="#ubicacion"><i class="ti ti-map-pin"></i> Ubicación</a>
      <a href="#contacto"><i class="ti ti-mail"></i> Contacto</a>
    </div>

    <div class="nav-actions">
      <button class="btn-nav-outline" id="themeToggle" type="button">
        <i class="ti ti-moon-stars"></i> Oscuro
      </button>
      <% if (logueado) {
        Object usuarioSes = session.getAttribute("usuario");
        String rolSes = "", nombreSes = "";
        if (usuarioSes instanceof com.clinipet.model.Usuario) {
          rolSes = ((com.clinipet.model.Usuario) usuarioSes).getRol();
          nombreSes = ((com.clinipet.model.Usuario) usuarioSes).getNombre();
        }
        String panelUrl = request.getContextPath() + "/cliente/dashboard";
        if ("ADMIN".equalsIgnoreCase(rolSes) || "ADMINISTRADOR".equalsIgnoreCase(rolSes))
          panelUrl = request.getContextPath() + "/dashboard";
        else if ("RECEPCIONISTA".equalsIgnoreCase(rolSes))
          panelUrl = request.getContextPath() + "/recepcionista/dashboard";
        else if ("ENFERMERO".equalsIgnoreCase(rolSes) || "VETERINARIO".equalsIgnoreCase(rolSes))
          panelUrl = request.getContextPath() + "/enfermero/dashboard";
      %>
      <a class="btn-nav-outline" href="<%= panelUrl %>">
        <i class="ti ti-layout-dashboard"></i> Mi panel
      </a>
      <a class="btn-nav-outline" href="${pageContext.request.contextPath}/logout"
         style="border-color:rgba(239,68,68,.5);color:#fca5a5">
        <i class="ti ti-logout"></i> Salir
      </a>
      <% } else { %>
      <a class="btn-nav-outline" href="${pageContext.request.contextPath}/registro">
        <i class="ti ti-user-plus"></i> Registrarse
      </a>
      <a class="btn-nav-primary" href="${pageContext.request.contextPath}/login">
        <i class="ti ti-login"></i> Login
      </a>
      <% } %>
    </div>
  </div>
</nav>

<!-- ═══════════ HERO ═══════════ -->
<section class="hero" style="padding-top:var(--nav-h)">
  <div class="hero-orb"></div>
  <span class="hero-paw p1">🐾</span>
  <span class="hero-paw p2">🐾</span>
  <span class="hero-paw p3">🐾</span>

  <div class="hero-inner">
    <div class="hero-text-col">
      <div class="hero-eyebrow fade-up">
        <span class="badge-cp"><i class="ti ti-paw"></i> Bienvenido a CliniPet</span>
      </div>
      <h1 class="hero-title fade-up-2">
        Cuidamos su salud,<br>ellos te llenan de
        <span class="accent" data-typewriter="amor ❤️" data-tw-loop="true" data-tw-pause="2800" data-tw-speed="65"></span>
      </h1>
      <p class="hero-desc fade-up-3">
        Atención veterinaria especializada, productos de calidad, agenda de citas y
        experiencia moderna — todo en un solo lugar para el bienestar de tu mascota.
      </p>
      <div class="hero-actions fade-up-3">
        <a href="#servicios" class="btn-cp"><i class="ti ti-paw"></i> Nuestros servicios</a>
        <a href="#productos" class="btn-cp-outline"><i class="ti ti-shopping-cart"></i> Tienda online</a>
        <a href="${pageContext.request.contextPath}/citas/nueva" class="btn-cp-ghost">
          <i class="ti ti-calendar-plus"></i> Agendar cita
        </a>
      </div>
      <div class="hero-stats fade-up-3 stagger-children">
        <div class="stat-item"><span class="stat-num" data-count="500" data-suffix="+">0</span><span class="stat-label">Mascotas atendidas</span></div>
        <div class="stat-item"><span class="stat-num" data-count="4.9" data-suffix="★" data-float="true">0</span><span class="stat-label">Valoración clientes</span></div>
        <div class="stat-item"><span class="stat-num" data-count="8" data-suffix=" años">0</span><span class="stat-label">De experiencia</span></div>
      </div>
    </div>

    <div class="hero-img-col fade-up">
      <div class="hero-img-frame">
        <div class="hero-photo"></div>
      </div>
      <div class="hero-chip chip-tl">
        <i class="ti ti-shield-check"></i>
        <div><strong>Veterinarios certificados</strong><span>Profesionales de confianza</span></div>
      </div>
      <div class="hero-chip chip-br">
        <i class="ti ti-calendar-check"></i>
        <div><strong>Cita disponible hoy</strong><span>Agenda en 2 minutos</span></div>
      </div>
    </div>
  </div>
</section>

<!-- ═══════════ SERVICIOS ═══════════ -->
<section class="section section-alt" id="servicios">
  <div class="container-cp">
    <div class="section-head-row">
      <div class="section-head" style="margin-bottom:0">
        <span class="badge-cp"><i class="ti ti-photo-heart"></i> Qué hacemos</span>
        <h2 class="section-title">Servicios veterinarios con atención profesional</h2>
        <p class="section-sub">Consulta, vacunación, bienestar y cuidado integral para tu mascota.</p>
      </div>
      <a href="${pageContext.request.contextPath}/citas/nueva" class="btn-cp-outline" style="white-space:nowrap">
        Pedir cita <i class="ti ti-arrow-right"></i>
      </a>
    </div>

    <div style="margin-top:36px" class="services-grid">
      <div class="card-cp service-card">
        <div class="service-img" style="background-image:url('https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?auto=format&fit=crop&w=900&q=80')"></div>
        <div class="service-body">
          <div class="service-icon"><i class="ti ti-stethoscope"></i></div>
          <h3>Consulta médica</h3>
          <p>Revisión, diagnóstico y acompañamiento para perros, gatos y otras mascotas.</p>
        </div>
      </div>
      <div class="card-cp service-card">
        <div class="service-img" style="background-image:url('https://images.unsplash.com/photo-1583337130417-3346a1be7dee?auto=format&fit=crop&w=900&q=80')"></div>
        <div class="service-body">
          <div class="service-icon"><i class="ti ti-vaccine"></i></div>
          <h3>Vacunación y control</h3>
          <p>Programación de vacunas, controles preventivos y seguimiento de salud.</p>
        </div>
      </div>
      <div class="card-cp service-card">
        <div class="service-img" style="background-image:url('https://images.unsplash.com/photo-1601758125946-6ec2ef64daf8?auto=format&fit=crop&w=900&q=80')"></div>
        <div class="service-body">
          <div class="service-icon"><i class="ti ti-bath"></i></div>
          <h3>Bienestar y cuidado</h3>
          <p>Aseo, productos, accesorios y recomendaciones para mejorar su calidad de vida.</p>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ═══════════ PRODUCTOS ═══════════ -->
<section class="section" id="productos">
  <div class="container-cp">
    <div class="section-head-row">
      <div class="section-head" style="margin-bottom:0">
        <span class="badge-cp"><i class="ti ti-trending-up"></i> Los favoritos de nuestros clientes</span>
        <h2 class="section-title">Productos más vendidos</h2>
        <p class="section-sub">Selecciona uno o varios y envíanos tu pedido por WhatsApp.</p>
      </div>
      <% if(logueado){ %>
      <a href="${pageContext.request.contextPath}/cliente/comprar" class="btn-cp-outline" style="white-space:nowrap">
        <i class="ti ti-shopping-cart"></i> Ir a la tienda
      </a>
      <% } else { %>
      <a href="${pageContext.request.contextPath}/registro" class="btn-cp-outline" style="white-space:nowrap">
        Crear cuenta <i class="ti ti-user-plus"></i>
      </a>
      <% } %>
    </div>

    <div style="margin-top:36px">
      <!-- BUSCADOR -->
      <div class="search-wrap">
        <i class="ti ti-search"></i>
        <input type="text" id="searchInput" placeholder="Buscar por nombre, categoría o especie…" autocomplete="off">
        <button class="search-clear" id="searchClear" type="button"><i class="ti ti-x"></i> Limpiar</button>
      </div>

      <!-- FILTROS POR ESPECIE -->
      <div class="especie-tabs" id="especieTabs" style="display:flex;flex-wrap:wrap;gap:10px;margin:18px 0 4px 0;">
        <button class="especie-tab active" data-especie="todos" onclick="setEspecieFilter(this,'todos')">
          <i class="ti ti-paw"></i> Todos
        </button>
        <button class="especie-tab" data-especie="perro" onclick="setEspecieFilter(this,'perro')">
          🐶 Canino
        </button>
        <button class="especie-tab" data-especie="gato" onclick="setEspecieFilter(this,'gato')">
          🐱 Felino
        </button>
        <button class="especie-tab" data-especie="ave" onclick="setEspecieFilter(this,'ave')">
          🐦 Aves
        </button>
        <button class="especie-tab" data-especie="vaca" onclick="setEspecieFilter(this,'vaca')">
          🐄 Bovinos
        </button>
        <button class="especie-tab" data-especie="caballo" onclick="setEspecieFilter(this,'caballo')">
          🐴 Equinos
        </button>
        <button class="especie-tab" data-especie="perro gato" onclick="setEspecieFilter(this,'perro gato')">
          <i class="ti ti-heart"></i> Multiespecie
        </button>
      </div>

      <!-- INFO BANNER -->
      <div class="d-flex align-items-center gap-3 mb-4 flex-wrap">
        <div style="display:flex;align-items:center;gap:9px;background:linear-gradient(135deg,var(--cp-900),var(--cp-700));color:white;border-radius:14px;padding:10px 20px;font-weight:900;font-size:.95rem;letter-spacing:.03em">
          <i class="ti ti-star-filled" style="color:#fcd34d"></i> Más vendidos · Ordenados por popularidad
        </div>
        <span id="search-count" style="color:var(--text-muted);font-weight:900;font-size:.92rem"></span>
      </div>

      <!-- GRID PRODUCTOS -->
      <div class="products-grid" id="productsGrid">

        <% if (productos == null || productos.isEmpty()) { %>
        <div class="card-cp" style="grid-column:1/-1;padding:44px;text-align:center">
          <i class="ti ti-package-off" style="font-size:3rem;color:var(--cp-400)"></i>
          <h3 style="margin-top:14px">No hay productos cargados</h3>
          <p style="color:var(--text-muted);font-weight:700">Agrega productos desde el panel administrativo.</p>
        </div>
        <% } else { int rank = 1; for (Producto p : productos) {
            String img = p.getImagenUrl();
            if (img == null || img.trim().isEmpty())
              img = "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?auto=format&fit=crop&w=900&q=80";
            String desc = (p.getDescripcion() == null || p.getDescripcion().trim().isEmpty())
                    ? "Producto veterinario disponible en CliniPet." : p.getDescripcion();
            String especie   = p.getEspecie()   != null ? p.getEspecie()   : "General";
            String categoria = p.getCategoria() != null ? p.getCategoria() : "";
            String precio    = String.format("%,.0f", p.getPrecio());
        %>
        <div class="card-cp product-card"
             data-nombre="<%= p.getNombre().toLowerCase() %>"
             data-categoria="<%= categoria.toLowerCase() %>"
             data-especie="<%= especie.toLowerCase() %>">

          <% if (rank <= 3) { %>
          <div class="badge-rank">
            <% if(rank==1){%><i class="ti ti-medal"></i> #1 Más vendido
            <%}else if(rank==2){%><i class="ti ti-medal-2"></i> #2 Popular
            <%}else{%><i class="ti ti-award"></i> #3 Favorito<%}%>
          </div>
          <% } %>

          <div class="product-img" style="background-image:url('<%= img %>')"></div>
          <h3><%= p.getNombre() %></h3>
          <p><%= desc %></p>
          <span class="badge-cp" style="font-size:.82rem"><%= especie %> · <%= categoria %></span>

          <div class="buy-row">
            <span class="product-price">$<%= precio %></span>
            <div style="display:flex;align-items:center;gap:8px">
              <div class="qty-control">
                <button class="qty-btn" onclick="changeQty(this,-1)">−</button>
                <span class="qty-val">1</span>
                <button class="qty-btn" onclick="changeQty(this,1)">+</button>
              </div>
              <button class="add-cart-btn"
                  data-id="<%= p.getIdProducto() %>"
                  data-nombre="<%= p.getNombre() %>"
                  data-precio="<%= p.getPrecio() %>"
                  data-img="<%= img %>"
                  onclick="addToCart(this)">
                <i class="ti ti-shopping-cart-plus"></i> Agregar
              </button>
            </div>
          </div>
        </div>
        <% rank++; } } %>

        <div id="no-results">
          <i class="ti ti-search-off"></i>
          <h3 style="margin-top:12px">Sin resultados</h3>
          <p style="color:var(--text-muted);font-weight:700">Intenta con otro nombre o categoría.</p>
        </div>
      </div>

      <!-- CTA ver todos -->
      <% if(logueado){ %>
      <div class="products-cta" style="text-align:center">
        <i class="ti ti-shopping-bag" style="font-size:2.8rem;color:var(--cp-500);display:block;margin-bottom:14px"></i>
        <h3>¡Tienda completa disponible!</h3>
        <p>Como cliente registrado tienes acceso a todos nuestros productos con carrito de compras y pedido por WhatsApp.</p>
        <div class="cta-btns">
          <a href="${pageContext.request.contextPath}/cliente/comprar" class="btn-cp">
            <i class="ti ti-shopping-cart"></i> Ir a la tienda completa
          </a>
          <a href="${pageContext.request.contextPath}/cliente/dashboard" class="btn-cp-outline">
            <i class="ti ti-layout-dashboard"></i> Mi panel
          </a>
        </div>
      </div>
      <% } else { %>
      <div class="products-cta">
        <i class="ti ti-lock" style="font-size:2.8rem;color:var(--cp-500);display:block;margin-bottom:14px"></i>
        <h3>¿Listo para comprar?</h3>
        <p>Puedes explorar y buscar en todo nuestro catálogo libremente. Para completar un pedido necesitas iniciar sesión o crear una cuenta gratis.</p>
        <div class="cta-btns">
          <a href="${pageContext.request.contextPath}/registro" class="btn-cp">
            <i class="ti ti-user-plus"></i> Crear cuenta gratis
          </a>
          <a href="${pageContext.request.contextPath}/login" class="btn-cp-outline">
            <i class="ti ti-login"></i> Ya tengo cuenta
          </a>
        </div>
      </div>
      <% } %>
    </div>
  </div>
</section>

<!-- ═══════════ QUIÉNES SOMOS ═══════════ -->
<section class="section section-alt" id="quienes">
  <div class="container-cp">
    <div class="about-grid">
      <div class="about-img"></div>
      <div class="about-card">
        <span class="badge-cp"><i class="ti ti-users"></i> ¿Quiénes somos?</span>
        <h2 class="section-title" style="margin-top:16px">Somos una veterinaria enfocada en bienestar y confianza</h2>
        <p>CliniPet nace para unir atención veterinaria, productos de calidad y tecnología en una sola experiencia. Nuestro objetivo es que cada dueño pueda cuidar a su mascota de forma fácil, rápida y segura.</p>
        <p>Trabajamos con profesionales comprometidos, productos confiables y un sistema moderno que permite agendar citas, controlar pedidos y ofrecer una mejor atención.</p>
        <a href="${pageContext.request.contextPath}/citas/nueva" class="btn-cp" style="margin-top:8px">
          <i class="ti ti-calendar-plus"></i> Agendar una cita
        </a>
      </div>
    </div>
    <div class="benefits-bar">
      <div class="benefit-item"><i class="ti ti-truck-delivery"></i><div>Envíos rápidos<br><span style="color:var(--text-muted);font-weight:700">A todo el país</span></div></div>
      <div class="benefit-item"><i class="ti ti-shield-check"></i><div>Pagos seguros<br><span style="color:var(--text-muted);font-weight:700">Compra con confianza</span></div></div>
      <div class="benefit-item"><i class="ti ti-headset"></i><div>Soporte 24/7<br><span style="color:var(--text-muted);font-weight:700">Estamos para ayudarte</span></div></div>
      <div class="benefit-item"><i class="ti ti-award"></i><div>Productos originales<br><span style="color:var(--text-muted);font-weight:700">Calidad garantizada</span></div></div>
    </div>
  </div>
</section>

<!-- ═══════════ UBICACIÓN ═══════════ -->
<section class="section" id="ubicacion">
  <div class="container-cp">
    <div class="section-head">
      <span class="badge-cp"><i class="ti ti-map-pin-heart"></i> Ubicación</span>
      <h2 class="section-title" style="margin-top:14px">Visítanos y conoce más de CliniPet</h2>
      <p class="section-sub">Estamos ubicados en Sogamoso, Boyacá.</p>
    </div>
    <div class="location-card">
      <div class="contact-info" id="contacto">
        <h2 style="font-weight:700;margin-bottom:20px">Información de contacto</h2>
        <div class="contact-item"><i class="ti ti-map-pin"></i><div><h3>Dirección</h3><p>SENA CIMM, Sogamoso, Boyacá</p></div></div>
        <div class="contact-item"><i class="ti ti-phone"></i><div><h3>Teléfono / WhatsApp</h3><p>3204963536</p></div></div>
        <div class="contact-item"><i class="ti ti-mail"></i><div><h3>Correo</h3><p>contacto@clinipet.com</p></div></div>
        <div class="contact-item"><i class="ti ti-clock"></i><div><h3>Horario</h3><p>Lunes a viernes · 8:00 a.m. - 5:00 p.m.</p></div></div>
        <div style="display:flex;flex-wrap:wrap;gap:10px;margin-top:26px">
          <a href="tel:3204963536" class="btn-cp-ghost" style="color:white;border-color:rgba(255,255,255,.3)">
            <i class="ti ti-phone-call"></i> Llamar
          </a>
          <a href="https://wa.me/<%= WA_NUMBER %>" target="_blank" rel="noopener noreferrer" class="btn-cp-ghost" style="color:white;border-color:rgba(255,255,255,.3)">
            <i class="ti ti-brand-whatsapp"></i> WhatsApp
          </a>
          <a href="${pageContext.request.contextPath}/login" class="btn-cp-ghost" style="color:white;border-color:rgba(255,255,255,.3)">
            <i class="ti ti-login"></i> Ingresar
          </a>
        </div>
      </div>
      <div class="map">
        <iframe loading="lazy" allowfullscreen referrerpolicy="no-referrer-when-downgrade"
          src="https://www.google.com/maps?q=SENA%20CIMM%20Sogamoso%20Boyac%C3%A1&output=embed"></iframe>
      </div>
    </div>
  </div>
</section>

<!-- ═══════════ CTA FINAL ═══════════ -->
<div class="container-cp" style="padding:0 28px 88px">
  <div class="cta-section">
    <span class="badge-cp" style="background:rgba(255,255,255,.15);border-color:rgba(255,255,255,.25);color:white">
      <i class="ti ti-paw"></i> CliniPet listo para cuidar tu mascota
    </span>
    <h2 style="margin-top:22px">Compra productos o agenda tu cita veterinaria en minutos.</h2>
    <p>Inicia sesión para continuar. Si eres nuevo, crea tu cuenta gratis.</p>
    <div class="cta-actions">
      <a href="${pageContext.request.contextPath}/login" class="btn-cp-ghost" style="color:white;border-color:rgba(255,255,255,.4)">
        <i class="ti ti-login"></i> Iniciar sesión
      </a>
      <a href="${pageContext.request.contextPath}/registro" class="btn-cp">
        <i class="ti ti-user-plus"></i> Registrarme gratis
      </a>
    </div>
  </div>
</div>

<!-- ═══════════ FOOTER ═══════════ -->
<footer>
  <div class="footer-inner">
    <span class="footer-brand"><i class="ti ti-paw"></i> CliniPet</span>
    <span>Sistema de Gestión Integral Veterinaria · SENA CIMM Sogamoso</span>
  </div>
</footer>

<!-- ═══════════ CARRITO FAB ═══════════ -->
<button class="cart-fab" id="cartFab" onclick="openCart()">
  <i class="ti ti-shopping-cart"></i> Mi pedido
  <span class="cart-count" id="cartCount">0</span>
</button>

<!-- ═══════════ MODAL CARRITO ═══════════ -->
<div class="modal-overlay" id="cartModal">
  <div class="modal-box">
    <div class="modal-head">
      <h3><i class="ti ti-shopping-cart" style="color:var(--cp-500)"></i> Mi pedido</h3>
      <button class="modal-close" onclick="closeCart()"><i class="ti ti-x"></i></button>
    </div>
    <div class="modal-body" id="cartBody">
      <div class="cart-empty"><i class="ti ti-basket-off"></i>No hay productos aún.</div>
    </div>
    <div class="modal-footer">
      <div class="cart-total">Total: <span id="cartTotal">$0</span></div>
      <button class="btn-wa" onclick="sendToWhatsApp()">
        <i class="ti ti-brand-whatsapp"></i> Pedir por WhatsApp
      </button>
    </div>
  </div>
</div>

<!-- ═══════════ MODAL LOGIN REQUERIDO ═══════════ -->
<div class="modal-overlay" id="loginModal">
  <div class="modal-login-box">
    <div class="lock-icon"><i class="ti ti-lock"></i></div>
    <h3>Inicia sesión primero</h3>
    <p>Para realizar un pedido necesitas una cuenta activa en CliniPet.</p>
    <div style="display:flex;gap:12px;justify-content:center;flex-wrap:wrap">
      <a href="${pageContext.request.contextPath}/login" class="btn-cp">
        <i class="ti ti-login"></i> Iniciar sesión
      </a>
      <button onclick="closeLoginModal()" style="background:var(--cp-50);border:1.5px solid var(--border);border-radius:14px;padding:13px 22px;font-weight:900;cursor:pointer;color:var(--cp-700);font-family:inherit;font-size:1rem">
        Cancelar
      </button>
    </div>
  </div>
</div>

<%-- Datos del servidor en atributos HTML (JS puro sin scriptlets) --%>
<div id="app-config" hidden
     data-wa="<%= WA_NUMBER %>"
     data-logueado="<%= logueado %>"
     data-login="<%= loginUrl %>"></div>

<script>
// ══════════════════════════════════════════════════════════════
//  ESTADO GLOBAL  (leído desde data-attributes, JS 100% puro)
// ══════════════════════════════════════════════════════════════
const _cfg      = document.getElementById('app-config').dataset;
const WA_NUMBER = _cfg.wa;
const LOGUEADO  = _cfg.logueado === 'true';
const LOGIN_URL  = _cfg.login;
let cart = {};   // { id: { nombre, precio, img, qty } }

// ══════════════════════════════════════════════════════════════
//  BUSCADOR EN TIEMPO REAL
// ══════════════════════════════════════════════════════════════
const searchInput  = document.getElementById('searchInput');
const searchClear  = document.getElementById('searchClear');
const searchCount  = document.getElementById('search-count');
const noResults    = document.getElementById('no-results');
const allCards     = document.querySelectorAll('#productsGrid .product-card');

searchInput.addEventListener('input', filterProducts);
searchClear.addEventListener('click', () => {
    searchInput.value = '';
    filterProducts();
    searchInput.focus();
});

let activeEspecie = 'todos';

function setEspecieFilter(btn, especie) {
    activeEspecie = especie;
    document.querySelectorAll('.especie-tab').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    filterProducts();
}

function filterProducts() {
    const q = searchInput.value.trim().toLowerCase();
    searchClear.classList.toggle('visible', q.length > 0);
    let visible = 0;

    allCards.forEach(card => {
        const especieCard = card.dataset.especie || '';
        const matchEspecie = activeEspecie === 'todos' || especieCard.includes(activeEspecie);
        const matchSearch = !q
                   || card.dataset.nombre.includes(q)
                   || card.dataset.categoria.includes(q)
                   || especieCard.includes(q);
        const match = matchEspecie && matchSearch;
        card.style.display = match ? '' : 'none';
        if (match) visible++;
    });

    noResults.style.display = (visible === 0) ? 'block' : 'none';
    searchCount.textContent = (q || activeEspecie !== 'todos') ? (visible + ' resultado' + (visible != 1 ? 's' : '')) : '';
}

// ══════════════════════════════════════════════════════════════
//  CONTROL DE CANTIDAD POR TARJETA
// ══════════════════════════════════════════════════════════════
function changeQty(btn, delta) {
    const ctrl = btn.closest('.qty-control');
    const span = ctrl.querySelector('.qty-val');
    let val = parseInt(span.textContent) + delta;
    if (val < 1) val = 1;
    if (val > 99) val = 99;
    span.textContent = val;
}

// ══════════════════════════════════════════════════════════════
//  AGREGAR AL CARRITO
// ══════════════════════════════════════════════════════════════
function addToCart(btn) {
    const id      = btn.dataset.id;
    const nombre  = btn.dataset.nombre;
    const precio  = parseFloat(btn.dataset.precio);
    const img     = btn.dataset.img;
    const qtySpan = btn.closest('.buy-row').querySelector('.qty-val');
    const qty     = parseInt(qtySpan.textContent);

    if (cart[id]) {
        cart[id].qty += qty;
    } else {
        cart[id] = { nombre, precio, img, qty };
    }

    btn.classList.add('added');
    btn.innerHTML = '<i class="ti ti-check"></i> Agregado';
    setTimeout(() => {
        btn.classList.remove('added');
        btn.innerHTML = '<i class="ti ti-shopping-cart-plus"></i> Agregar';
    }, 1400);

    updateCartUI();
}

// ══════════════════════════════════════════════════════════════
//  ACTUALIZAR UI DEL CARRITO
// ══════════════════════════════════════════════════════════════
function updateCartUI() {
    const items   = Object.values(cart);
    const total   = items.reduce((s, i) => s + i.precio * i.qty, 0);
    const count   = items.reduce((s, i) => s + i.qty, 0);
    const fab     = document.getElementById('cartFab');
    const counter = document.getElementById('cartCount');
    const body    = document.getElementById('cartBody');
    const totalEl = document.getElementById('cartTotal');

    counter.textContent = count;
    fab.classList.toggle('visible', count > 0);
    totalEl.textContent = '$' + total.toLocaleString('es-CO');

    if (items.length === 0) {
        body.innerHTML = '<div class="cart-empty"><i class="ti ti-basket-off"></i>No hay productos aún.</div>';
        return;
    }

    body.innerHTML = Object.keys(cart).map(function(id) {
        var item = cart[id];
        return '<div class="cart-item">' +
            '<div class="cart-item-img" style="background-image:url(\'' + item.img + '\')"></div>' +
            '<div class="cart-item-info">' +
                '<strong>' + item.nombre + '</strong>' +
                '<span>Cant: ' + item.qty + ' &nbsp;&middot;&nbsp; Unit: $' + item.precio.toLocaleString('es-CO') + '</span>' +
            '</div>' +
            '<div class="cart-item-price">$' + (item.precio * item.qty).toLocaleString('es-CO') + '</div>' +
            '<button class="cart-item-remove" onclick="removeItem(\'' + id + '\')">' +
                '<i class="ti ti-trash"></i>' +
            '</button>' +
        '</div>';
    }).join('');
}

function removeItem(id) {
    delete cart[id];
    updateCartUI();
}

// ══════════════════════════════════════════════════════════════
//  ABRIR / CERRAR CARRITO
// ══════════════════════════════════════════════════════════════
function openCart() {
    document.getElementById('cartModal').classList.add('open');
    document.body.style.overflow = 'hidden';
}
function closeCart() {
    document.getElementById('cartModal').classList.remove('open');
    document.body.style.overflow = '';
}
document.getElementById('cartModal').addEventListener('click', e => {
    if (e.target === document.getElementById('cartModal')) closeCart();
});

// ══════════════════════════════════════════════════════════════
//  ENVIAR A WHATSAPP (verifica login primero)
// ══════════════════════════════════════════════════════════════
function sendToWhatsApp() {
    if (!LOGUEADO) {
        closeCart();
        document.getElementById('loginModal').classList.add('open');
        document.body.style.overflow = 'hidden';
        return;
    }

    const items = Object.values(cart);
    if (items.length === 0) return;

    const total = items.reduce((s, i) => s + i.precio * i.qty, 0);
    var lineas = items.map(function(i) {
        return '\u2022 ' + i.nombre + ' x' + i.qty + ' = $' + (i.precio * i.qty).toLocaleString('es-CO');
    }).join('\n');

    var msg = encodeURIComponent(
        'Hola CliniPet! \uD83D\uDC3E Quiero realizar el siguiente pedido:\n\n' +
        lineas +
        '\n\n\uD83D\uDCB0 *Total: $' + total.toLocaleString('es-CO') + '*\n\n\u00BFC\u00F3mo procedo con el pago?'
    );

    // Registrar compra en BD si el usuario está logueado, luego abrir WhatsApp
    var itemsPayload = Object.keys(cart).map(function(id) {
        return { id: id, nombre: cart[id].nombre, precio: cart[id].precio, qty: cart[id].qty };
    });
    fetch('${pageContext.request.contextPath}/comprar-carrito', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'items=' + encodeURIComponent(JSON.stringify(itemsPayload)) + '&metodo_pago=WhatsApp'
    }).catch(function(){}).finally(function(){
        window.open('https://wa.me/' + WA_NUMBER + '?text=' + msg, '_blank');
    });
}

function closeLoginModal() {
    document.getElementById('loginModal').classList.remove('open');
    document.body.style.overflow = '';
}
document.getElementById('loginModal').addEventListener('click', e => {
    if (e.target === document.getElementById('loginModal')) closeLoginModal();
});

// Tema manejado por animations.js (3 modos: light/dark/neon)
</script>
<script src="${pageContext.request.contextPath}/assets/js/animations.js"></script>
</body>
</html>
