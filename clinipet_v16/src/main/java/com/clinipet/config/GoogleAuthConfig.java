package com.clinipet.config;

/**
 * Configuración del Client ID de Google Sign-In.
 *
 * CÓMO OBTENER TU CLIENT ID (gratis, toma ~5 minutos):
 *   1. Entra a https://console.cloud.google.com/
 *   2. Crea un proyecto nuevo (o usa uno existente).
 *   3. Ve a "APIs y servicios" -> "Pantalla de consentimiento de OAuth".
 *      - Tipo de usuario: Externo. Completa nombre de la app, correo, etc.
 *      - Agrega tu correo en "Usuarios de prueba" si la app queda en modo prueba.
 *   4. Ve a "APIs y servicios" -> "Credenciales" -> "Crear credenciales"
 *      -> "ID de cliente de OAuth".
 *      - Tipo de aplicación: "Aplicación web".
 *      - En "Orígenes de JavaScript autorizados" agrega la URL donde corre
 *        tu app, por ejemplo: http://localhost:8080
 *      - En "URI de redireccionamiento autorizados" no es necesario agregar
 *        nada porque usamos Google Identity Services (flujo de un solo paso).
 *   5. Copia el "ID de cliente" generado (termina en .apps.googleusercontent.com)
 *      y pégalo abajo en CLIENT_ID.
 *   6. Cuando subas la app a un dominio real (no localhost), vuelve al paso 4
 *      y agrega ese dominio también en "Orígenes de JavaScript autorizados".
 */
public class GoogleAuthConfig {
    public static final String CLIENT_ID = "91130037987-5q8no6ir6krd69scou894bbtc35q83fk.apps.googleusercontent.com";
}
