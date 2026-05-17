package br.com.gestaofretes.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class ConexaoDB {

    private static final HikariDataSource dataSource;

    static {
        try (InputStream is = ConexaoDB.class
                .getClassLoader().getResourceAsStream("db.properties")) {

            Properties props = new Properties();
            props.load(is);

            HikariConfig config = new HikariConfig();

            // Conexão
            config.setJdbcUrl        (props.getProperty("db.url"));
            config.setUsername       (props.getProperty("db.usuario"));
            config.setPassword       (props.getProperty("db.senha"));
            config.setDriverClassName("org.postgresql.Driver");

            // Nome visível nos logs e no pg_stat_activity do PostgreSQL
            config.setPoolName("GestaoFretes-Pool");

            // Tamanho do pool
            config.setMinimumIdle      (intProp(props, "db.pool.minimumIdle",       3));
            config.setMaximumPoolSize  (intProp(props, "db.pool.maximumPoolSize",   10));

            // Timeouts
            config.setConnectionTimeout(longProp(props, "db.pool.connectionTimeout", 30_000L));
            config.setIdleTimeout      (longProp(props, "db.pool.idleTimeout",      600_000L));
            config.setMaxLifetime      (longProp(props, "db.pool.maxLifetime",    1_800_000L));

            // Validação de conexão
            config.setConnectionTestQuery(
                props.getProperty("db.pool.connectionTestQuery", "SELECT 1"));

            // Otimizações recomendadas para PostgreSQL
            config.addDataSourceProperty("cachePrepStmts",          "true");
            config.addDataSourceProperty("prepStmtCacheSize",        "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit",    "2048");

            dataSource = new HikariDataSource(config);

        } catch (Exception e) {
            throw new RuntimeException("Erro ao inicializar pool de conexões HikariCP.", e);
        }
    }

    /** Empresta uma conexão do pool. Chame sempre em try-with-resources. */
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    /**
     * Fecha todas as conexões do pool graciosamente.
     * Deve ser chamado no shutdown do Tomcat — veja AppLifecycleListener.
     */
    public static void shutdown() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }


    private static int intProp(Properties p, String key, int def) {
        String v = p.getProperty(key);
        return v != null ? Integer.parseInt(v.trim()) : def;
    }

    private static long longProp(Properties p, String key, long def) {
        String v = p.getProperty(key);
        return v != null ? Long.parseLong(v.trim()) : def;
    }
}
