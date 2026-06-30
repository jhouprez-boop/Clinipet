# 📋 Guía CliniPet v17 — Contraseña encriptada + Google Login + Avatar

---

## ✅ Qué se implementó

| Función | Estado |
|---|---|
| Contraseñas encriptadas con BCrypt | ✅ Hecho |
| Migración automática de contraseñas antiguas | ✅ Hecho |
| Login con Google | ✅ Hecho (requiere configurar tu Client ID) |
| Avatar de perfil editable por cada usuario | ✅ Hecho |
| Página "Mi perfil" para todos los roles | ✅ Hecho |

---

## 🔐 1. Contraseñas encriptadas (BCrypt)

No necesitas hacer nada especial. La migración es **transparente y automática**:

- La primera vez que un usuario existente inicia sesión, el sistema detecta que
  su contraseña está en texto plano, la valida y **la convierte a BCrypt en ese
  mismo momento**. El usuario nunca nota nada.
- Los nuevos registros ya se guardan directamente en BCrypt.
- El módulo de recuperación de contraseña también guarda en BCrypt.

---

## 📦 2. Ejecutar la migración de base de datos

Solo una vez, **antes de desplegar v17**. Abre phpMyAdmin o cualquier cliente MySQL:

```sql
-- Abrir clinipet_db y ejecutar:
source migracion_v17.sql
```

O pega el contenido del archivo `migracion_v17.sql` directamente. Esto agrega
tres columnas nuevas a la tabla `usuarios`:

- `foto_perfil` — nombre de archivo del avatar
- `google_id` — ID de cuenta Google vinculada
- `proveedor` — "LOCAL" o "GOOGLE"

---

## 🔑 3. Configurar Google Sign-In (5 minutos)

### Paso a paso para obtener el Client ID:

1. **Ir a Google Cloud Console**
   Abre https://console.cloud.google.com/ — inicia sesión con tu cuenta Google.

2. **Crear (o elegir) un proyecto**
   Menú superior → "Selecciona un proyecto" → "Nuevo proyecto".
   Dale un nombre (ej. `clinipet`) y haz clic en "Crear".

3. **Configurar la pantalla de consentimiento OAuth**
   - Menú izquierdo → "APIs y servicios" → "Pantalla de consentimiento de OAuth"
   - Tipo de usuario: **Externo** → "Crear"
   - Rellena: nombre de la app (`CliniPet`), correo de asistencia, correo del desarrollador.
   - En el paso "Usuarios de prueba" agrega tu correo (para poder probar).
   - Guarda y continúa en todos los pasos.

4. **Crear credenciales OAuth**
   - "APIs y servicios" → "Credenciales" → "Crear credenciales" → "ID de cliente de OAuth 2.0"
   - Tipo de aplicación: **Aplicación web**
   - Nombre: `CliniPet Web`
   - **Orígenes de JavaScript autorizados:**
     ```
     http://localhost:8080
     ```
     (si tu app corre en otro puerto, cámbialo; en producción pon tu dominio real)
   - Haz clic en "Crear"

5. **Copiar el Client ID**
   Verás algo como:
   ```
   XXXXXXXXXX-xxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com
   ```

6. **Pegarlo en DOS lugares:**

   **Archivo A** — `src/main/java/com/clinipet/config/GoogleAuthConfig.java`:
   ```java
   public static final String CLIENT_ID = "TU_CLIENT_ID.apps.googleusercontent.com";
   //  ↑ reemplaza esta línea completa con tu Client ID real
   ```

   **Archivo B** — `src/main/webapp/WEB-INF/views/login.jsp`, línea con `data-client_id`:
   ```html
   data-client_id="TU_CLIENT_ID.apps.googleusercontent.com"
   <!-- ↑ reemplaza también aquí -->
   ```

7. **Recompilar y desplegar** (`mvn package` / `cargo:run`).

---

## 🖼️ 4. Avatar de perfil

- Cada usuario (admin, cliente, veterinario, recepcionista) puede ir a
  **"Mi perfil"** desde la barra lateral.
- Desde ahí puede subir una foto (JPG, PNG, WEBP o GIF, máximo 5 MB).
- La imagen se guarda en `assets/img/avatars/` dentro del servidor.
- Se muestra en la barra lateral de su dashboard con un enlace clicable al perfil.

---

## ⚠️ Notas importantes

- El botón de Google aparece en la pantalla de login. Si no configuraste el
  Client ID, el botón no se mostrará (Google lo oculta automáticamente si el
  ID es inválido). El login tradicional sigue funcionando igual.
- En producción con HTTPS, actualiza el origen autorizado en Google Cloud
  Console para que coincida con tu dominio real (ej. `https://clinipet.com`).
- Los avatares subidos se guardan en el servidor donde corre Tomcat. Si
  redespliegas un WAR, asegúrate de no sobrescribir esa carpeta; o configura
  una ruta externa al WAR para los uploads.
