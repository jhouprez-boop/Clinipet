# Cómo publicar CliniPet gratis (con base de datos en la nube)

Tu proyecto es Java + Servlets/JSP (Maven, empaqueta a `.war`, necesita Tomcat 10).
Eso descarta los hostings "gratis" típicos (Hostinger, InfinityFree, etc.), que solo
sirven para PHP/WordPress. La combinación gratuita real para este stack es:

- **App**: Render.com (plan gratuito, despliega con Docker) — ya te dejé el `Dockerfile` listo.
- **Base de datos**: Clever Cloud (addon MySQL "DEV", gratis) o Aiven (prueba gratuita de MySQL).

⚠️ **Importante — seguridad**: tu archivo `RecuperarContrasenaServlet.java` traía tu
contraseña de aplicación de Gmail escrita en texto plano. Ya la moví a una variable de
entorno, pero como esa contraseña ya quedó expuesta en el código que me compartiste,
**revócala y genera una nueva** en https://myaccount.google.com/apppasswords antes de
publicar el proyecto (y nunca la subas a GitHub).

---

## 1. Sube el proyecto a GitHub

```bash
cd clinipet_v16
git init
git add .
git commit -m "Listo para producción"
git branch -M main
git remote add origin https://github.com/TU-USUARIO/clinipet.git
git push -u origin main
```

(Crea antes el repo vacío en github.com — puede ser privado.)

## 2. Crea la base de datos en la nube (Clever Cloud, gratis)

1. Regístrate en https://www.clever-cloud.com
2. Crea una organización → **Create an add-on** → **MySQL** → plan **DEV** (gratis,
   ideal para proyectos pequeños).
3. En el panel del addon verás: host, puerto, nombre de base de datos, usuario y
   contraseña. Guárdalos, los necesitas en el paso 4.
4. Importa tu `clinipet_db.sql`: en el panel del addon hay un botón para abrir
   **phpMyAdmin** (o usa la consola MySQL que te dan). Sube ahí el archivo
   `clinipet_db.sql` que ya tenías.

Alternativa igual de válida y gratis: https://www.alwaysdata.com (1 GB gratis, incluye MySQL).

## 3. Despliega la app en Render.com (gratis, con Docker)

1. Regístrate en https://render.com con tu cuenta de GitHub.
2. **New +** → **Web Service** → selecciona tu repo `clinipet`.
3. Render detectará el `Dockerfile` automáticamente (déjalo en "Docker").
4. Plan: **Free**.
5. En la sección **Environment Variables**, agrega:

   | Variable | Valor |
   |---|---|
   | `DB_HOST` | el host que te dio Clever Cloud |
   | `DB_PORT` | normalmente `3306` |
   | `DB_NAME` | el nombre de tu base de datos |
   | `DB_USER` | el usuario que te dio Clever Cloud |
   | `DB_PASS` | la contraseña que te dio Clever Cloud |
   | `GMAIL_USER` | tu correo de Gmail |
   | `GMAIL_APP_PASS` | la **nueva** contraseña de aplicación (la que generes en el paso de seguridad) |

6. Clic en **Create Web Service**. Render construye la imagen Docker y la publica.
   Te da una URL tipo `https://clinipet.onrender.com`.

⚠️ El plan gratis de Render "duerme" la app tras 15 minutos sin tráfico, y tarda
unos 30-50 segundos en despertar con la siguiente visita. Es normal en el plan free.

## 4. Prueba

Abre la URL que te dio Render. Debería cargar el login de CliniPet conectado ya a
tu base de datos en la nube.

---

### Si algo falla
- Revisa los **Logs** de Render (pestaña "Logs" del servicio) — ahí verás si la
  conexión a MySQL falla (usuario/contraseña/host mal copiados) o si el build de
  Maven tuvo un error.
- Si Clever Cloud exige conexión SSL y da error, prueba agregando
  `?useSSL=true&requireSSL=true` en vez de solo `useSSL=true` (puedo ayudarte a
  ajustarlo si te aparece el error exacto).
