# Desplegar CliniPet en Railway

> Nota: Railway da $5 de crédito gratis los primeros 30 días (sin tarjeta). Después
> pasas a un plan "Free" de $1/mes de crédito, que normalmente no alcanza para tener
> la app + MySQL corriendo 24/7. Para uso continuo necesitarás el plan Hobby ($5/mes).
> Aun así, es la forma más simple de tener app + base de datos en un solo sitio.

## 0. Antes de empezar

Asegúrate de tener el proyecto en GitHub (con el `Dockerfile` que ya te dejé) y de
haber revocado/regenerado tu contraseña de aplicación de Gmail (ver advertencia del
mensaje anterior).

## 1. Crea cuenta y proyecto en Railway

1. Ve a https://railway.app → **Login with GitHub**.
2. Clic en **New Project** → **Deploy from GitHub repo** → selecciona tu repo `clinipet`.
3. Railway detecta el `Dockerfile` y empieza a construir la imagen automáticamente.
   (Si te pide permisos para acceder al repo en GitHub, acéptalos.)

## 2. Agrega la base de datos MySQL (en el mismo proyecto)

1. Dentro del proyecto, clic en **+ New** → **Database** → **Add MySQL**.
2. Railway crea el servicio de MySQL y genera automáticamente variables como
   `MYSQLHOST`, `MYSQLPORT`, `MYSQLDATABASE`, `MYSQLUSER`, `MYSQLPASSWORD`.

## 3. Importa tu base de datos

1. Clic en el servicio **MySQL** → pestaña **Data**.
2. Ahí puedes abrir una consola/editor para pegar el contenido de tu archivo
   `clinipet_db.sql` y ejecutarlo, o usar el botón de importar si está disponible.
   - Alternativa por terminal (si tienes `mysql` instalado en tu PC): copia el
     comando de conexión que Railway te muestra en la pestaña **Connect** y haz:
     ```bash
     mysql -h <MYSQLHOST> -P <MYSQLPORT> -u <MYSQLUSER> -p<MYSQLPASSWORD> <MYSQLDATABASE> < clinipet_db.sql
     ```

## 4. Conecta tu app a esa base de datos

1. Clic en tu servicio de la **app** (no el de MySQL) → pestaña **Variables**.
2. Agrega estas variables, usando las "reference variables" de Railway para que
   apunten automáticamente al servicio MySQL (escribe `${{` y Railway te sugiere
   las del servicio MySQL):

   | Variable | Valor |
   |---|---|
   | `DB_HOST` | `${{MySQL.MYSQLHOST}}` |
   | `DB_PORT` | `${{MySQL.MYSQLPORT}}` |
   | `DB_NAME` | `${{MySQL.MYSQLDATABASE}}` |
   | `DB_USER` | `${{MySQL.MYSQLUSER}}` |
   | `DB_PASS` | `${{MySQL.MYSQLPASSWORD}}` |
   | `GMAIL_USER` | tu correo de Gmail |
   | `GMAIL_APP_PASS` | tu nueva contraseña de aplicación |

3. Guarda — Railway vuelve a desplegar la app automáticamente con esas variables.

## 5. Genera la URL pública

1. En tu servicio de la app → pestaña **Settings** → sección **Networking**.
2. Clic en **Generate Domain**. Te da una URL tipo `https://clinipet-production.up.railway.app`.

## 6. Prueba

Abre esa URL. Debe cargar el login de CliniPet ya conectado a la base de datos de Railway.

---

### Si algo falla
- Pestaña **Deployments** → clic en el último deploy → **View Logs**: ahí ves errores
  de build de Maven o de conexión a MySQL.
- Error típico de SSL con MySQL en Railway: si aparece, dime el mensaje exacto y
  ajustamos el parámetro `useSSL` en `Conexion.java`.
- Si el crédito gratis se agota y la app se pausa, solo necesitas activar el plan
  Hobby ($5/mes) para reanudarla — tus datos no se borran de inmediato.
