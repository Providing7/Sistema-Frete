package br.com.gestaofretes.usuario;

import br.com.gestaofretes.util.ConexaoDB;

import java.sql.*;

/**
 * Acesso a dados da tabela usuario.
 */
public class UsuarioDAO {

    /**
     * Busca o hash de senha do usuário pelo e-mail (usado no login).
     * Retorna null se o usuário não existir.
     */
    public String buscarSenhaHash(String email) throws SQLException {
        String sql = "SELECT senha_hash FROM usuario WHERE email = ? AND ativo = TRUE";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString("senha_hash");
            }
        }
        return null;
    }

    /**
     * Verifica se um e-mail já está cadastrado.
     */
    public boolean emailJaExiste(String email) throws SQLException {
        String sql = "SELECT 1 FROM usuario WHERE email = ?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean loginJaExiste(String login) throws SQLException {
        String sql = "SELECT 1 FROM usuario WHERE login = ?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, login);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Insere um novo usuário com e-mail e senha criptografada.
     */
    public void inserir(String email, String senhaHash, String nomeCompleto) throws SQLException {
        String sql = "INSERT INTO usuario (login, email, senha_hash, nome_completo) VALUES (?, ?, ?, ?)";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email); // login = email
            ps.setString(2, email);
            ps.setString(3, senhaHash);
            ps.setString(4, nomeCompleto);
            ps.executeUpdate();
        }
    }
}
