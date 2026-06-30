<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.clinipet.model.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    String rol = usuario != null ? usuario.getRol() : "";
    String volverUrl = request.getContextPath() + "/dashboard";
    if ("CLIENTE".equalsIgnoreCase(rol)) volverUrl = request.getContextPath() + "/cliente/dashboard";
    else if ("RECEPCIONISTA".equalsIgnoreCase(rol)) volverUrl = request.getContextPath() + "/recepcionista/dashboard";
    else if ("ENFERMERO".equalsIgnoreCase(rol) || "VETERINARIO".equalsIgnoreCase(rol)) volverUrl = request.getContextPath() + "/enfermero/dashboard";

    String avatarUrl = (usuario != null && usuario.getAvatarUrlOrNull() != null)
            ? request.getContextPath() + usuario.getAvatarUrlOrNull()
            : null;
%>
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>CliniPet | Mi perfil</title>
  <link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800;900&family=Fredoka:wght@500;600;700&display=swap" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/assets/css/clinipet.css" rel="stylesheet"/>
  <style>
    .perfil-wrap{max-width:560px;margin:48px auto;padding:0 16px}
    .perfil-card{background:#fff;border-radius:20px;box-shadow:0 10px 30px rgba(0,0,0,.08);padding:32px}
    .perfil-avatar-box{display:flex;flex-direction:column;align-items:center;gap:14px;margin-bottom:24px}
    .perfil-avatar-img{width:120px;height:120px;border-radius:50%;object-fit:cover;border:4px solid var(--cp-100,#e8f5ee);background:#f1f3f5}
    .perfil-avatar-fallback{width:120px;height:120px;border-radius:50%;display:grid;place-items:center;background:var(--cp-100,#e8f5ee);color:var(--cp-500,#16a34a);font-size:3rem;border:4px solid var(--cp-100,#e8f5ee)}
    .perfil-badge{font-size:.75rem;font-weight:700;padding:3px 10px;border-radius:20px;background:#f1f3f5;color:#555}
    .form-label-cp{font-weight:700;font-size:.85rem;margin-bottom:6px;display:block}
    .form-control-cp, .perfil-file{width:100%;padding:10px 14px;border-radius:12px;border:1px solid #e1e5ea;margin-bottom:18px}
    .perfil-actions{display:flex;gap:10px;margin-top:8px}
  </style>
</head>
<body>
<div class="perfil-wrap">
  <a href="<%= volverUrl %>" style="display:inline-flex;align-items:center;gap:6px;font-weight:700;color:var(--cp-500,#16a34a);text-decoration:none;margin-bottom:16px">
    <i class="ti ti-arrow-left"></i> Volver
  </a>

  <div class="perfil-card">
    <h2 style="font-family:'Fredoka',sans-serif;margin-bottom:4px">Mi perfil</h2>
    <p style="color:#777;margin-bottom:24px">Edita tu foto y tu información personal.</p>

    <% if (request.getAttribute("mensaje") != null) { %>
      <div class="alert-cp" style="background:#e8f8ee;color:#157347;padding:12px 16px;border-radius:12px;margin-bottom:18px">
        <i class="ti ti-check"></i> <%= request.getAttribute("mensaje") %>
      </div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert-cp alert-cp-error" style="padding:12px 16px;border-radius:12px;margin-bottom:18px">
        <i class="ti ti-alert-circle"></i> <%= request.getAttribute("error") %>
      </div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/perfil" enctype="multipart/form-data">

      <div class="perfil-avatar-box">
        <% if (avatarUrl != null) { %>
          <img class="perfil-avatar-img" src="<%= avatarUrl %>" alt="Avatar" id="avatarPreview"/>
        <% } else { %>
          <div class="perfil-avatar-fallback" id="avatarFallback"><i class="ti ti-user"></i></div>
          <img class="perfil-avatar-img" id="avatarPreview" style="display:none" alt="Avatar"/>
        <% } %>

        <span class="perfil-badge"><i class="ti ti-shield-check"></i> Rol: <%= usuario != null ? usuario.getRol() : "" %></span>

        <label for="avatarInput" style="cursor:pointer;font-weight:700;color:var(--cp-500,#16a34a);font-size:.9rem">
          <i class="ti ti-camera"></i> Cambiar foto
        </label>
        <input type="file" id="avatarInput" name="avatar" accept="image/*" style="display:none"/>
      </div>

      <label class="form-label-cp">Nombre completo</label>
      <input type="text" class="form-control-cp" name="nombre" value="<%= usuario != null ? usuario.getNombre() : "" %>" required/>

      <label class="form-label-cp">Correo electrónico</label>
      <input type="text" class="form-control-cp" value="<%= usuario != null ? usuario.getCorreo() : "" %>" disabled/>

      <div class="perfil-actions">
        <button type="submit" class="auth-btn-submit" style="flex:1">
          <i class="ti ti-device-floppy"></i> Guardar cambios
        </button>
      </div>
    </form>
  </div>
</div>

<script>
document.getElementById('avatarInput').addEventListener('change', function(e){
  var file = e.target.files[0];
  if(!file) return;
  var url = URL.createObjectURL(file);
  var img = document.getElementById('avatarPreview');
  var fallback = document.getElementById('avatarFallback');
  img.src = url;
  img.style.display = 'block';
  if (fallback) fallback.style.display = 'none';
});
</script>
</body>
</html>
