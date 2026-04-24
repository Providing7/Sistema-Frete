package br.com.gestaofretes.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class ConexaoDB {
    private static String url;
    private static String usuario;
    private static String senha;

    static {
        try (InputStream is = ConexaoDB.class
                .getClassLoader().getResourceAsStream("db.properties")) {
            Properties props = new Properties();
            props.load(is);
            url      = props.getProperty("db.url");
            usuario  = props.getProperty("db.usuario");
            senha    = props.getProperty("db.senha");
            Class.forName("org.postgresql.Driver");
        } catch (Exception e) {
            throw new RuntimeException("Erro ao carregar configurações do banco.", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, usuario, senha);
    }
}
