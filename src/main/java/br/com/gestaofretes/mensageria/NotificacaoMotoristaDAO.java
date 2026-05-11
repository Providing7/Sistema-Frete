package br.com.gestaofretes.mensageria;

import br.com.gestaofretes.util.ConexaoDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificacaoMotoristaDAO {

    public void salvar(AlertaCNHMessage msg, String nivel) throws SQLException {
        String sql =
            "INSERT INTO notificacao_motorista " +
            "(id_motorista, motorista_nome, cnh_numero, cnh_validade, dias_restantes, nivel, processado_em) " +
            "VALUES (?, ?, ?, ?, ?, ?, NOW())";

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong  (1, msg.getMotoristaId());
            ps.setString(2, msg.getMotoristaNome());
            ps.setString(3, msg.getCnhNumero());
            ps.setDate  (4, Date.valueOf(msg.getCnhValidade()));
            ps.setInt   (5, msg.getDiasRestantes());
            ps.setString(6, nivel);
            ps.executeUpdate();
        }
    }

    public List<NotificacaoMotorista> listarRecentes(int limite) throws SQLException {
        String sql =
            "SELECT id, id_motorista, motorista_nome, cnh_numero, cnh_validade, " +
            "       dias_restantes, nivel, processado_em " +
            "FROM notificacao_motorista " +
            "ORDER BY processado_em DESC " +
            "LIMIT ?";

        List<NotificacaoMotorista> lista = new ArrayList<>();
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }
        return lista;
    }

    public List<NotificacaoMotorista> listarPorMotorista(Long idMotorista) throws SQLException {
        String sql =
            "SELECT id, id_motorista, motorista_nome, cnh_numero, cnh_validade, " +
            "       dias_restantes, nivel, processado_em " +
            "FROM notificacao_motorista " +
            "WHERE id_motorista = ? " +
            "ORDER BY processado_em DESC";

        List<NotificacaoMotorista> lista = new ArrayList<>();
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, idMotorista);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }
        return lista;
    }

    private NotificacaoMotorista mapear(ResultSet rs) throws SQLException {
        NotificacaoMotorista n = new NotificacaoMotorista();
        n.setId           (rs.getLong     ("id"));
        n.setIdMotorista  (rs.getLong     ("id_motorista"));
        n.setMotoristaNome(rs.getString   ("motorista_nome"));
        n.setCnhNumero    (rs.getString   ("cnh_numero"));
        n.setCnhValidade  (rs.getDate     ("cnh_validade").toLocalDate());
        n.setDiasRestantes(rs.getInt      ("dias_restantes"));
        n.setNivel        (rs.getString   ("nivel"));
        n.setProcessadoEm (rs.getTimestamp("processado_em").toLocalDateTime());
        return n;
    }
}
