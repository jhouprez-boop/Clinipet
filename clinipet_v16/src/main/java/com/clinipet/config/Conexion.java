package com.clinipet.config;

import java.sql.Connection;
import java.sql.SQLException;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

public class Conexion {

    // En producción (hosting en la nube) estas variables de entorno se leen
    // automáticamente. Si no existen (ej. estás en tu PC con XAMPP), se usan
    // los valores por defecto de localhost.
    private static final String HOST = getEnv("DB_HOST", "localhost");
    private static final String PORT = getEnv("DB_PORT", "3306");
    private static final String DBNAME = getEnv("DB_NAME", "clinipet_db");
    private static final String USER = getEnv("DB_USER", "root");
    private static final String PASS = getEnv("DB_PASS", "");

    private static final String URL =
            "jdbc:mysql://" + HOST + ":" + PORT + "/" + DBNAME
                    + "?serverTimezone=America/Bogota&useSSL=true&allowPublicKeyRetrieval=true";

    // Pool de conexiones: reutiliza conexiones en vez de abrir una nueva por
    // cada consulta. Esto es CLAVE en hosting gratuito, porque los planes
    // gratis de bases de datos en la nube limitan cuántas conexiones
    // simultáneas se pueden tener (ej. Clever Cloud DEV permite solo 5).
    // maximumPoolSize se deja deliberadamente bajo, por debajo de ese límite.
    private static final HikariDataSource dataSource;

    static {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(URL);
        config.setUsername(USER);
        config.setPassword(PASS);
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");
        config.setMaximumPoolSize(4);
        config.setMinimumIdle(1);
        config.setConnectionTimeout(10000);   // 10s esperando una conexión libre
        config.setIdleTimeout(30000);         // cierra conexiones inactivas tras 30s
        config.setMaxLifetime(280000);        // recicla conexiones cada ~4.6 min
        dataSource = new HikariDataSource(config);
        System.out.println("✔ Pool de conexiones MySQL inicializado (" + HOST + ")");
    }

    private static String getEnv(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value == null || value.isBlank()) ? defaultValue : value;
    }

    /**
     * Devuelve una conexión del pool. El código existente que hace
     * con.close() en un try-with-resources sigue funcionando igual:
     * close() ya no cierra la conexión física, solo la devuelve al pool.
     */
    public static Connection getConnection() throws SQLException {
        try {
            return dataSource.getConnection();
        } catch (SQLException e) {
            System.out.println("❌ Error de conexión a la base de datos:");
            System.out.println("Mensaje: " + e.getMessage());
            System.out.println("Código Error: " + e.getErrorCode());
            System.out.println("Estado SQL: " + e.getSQLState());
            throw e;
        }
    }
}
