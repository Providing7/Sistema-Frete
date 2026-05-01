package br.com.gestaofretes.ocorrencia;

import br.com.gestaofretes.util.ConexaoDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class OcorrenciaDAO {

    // Salvar — recebe Connection de fora (participa de transação)
    public void salvar(OcorrenciaFrete o, Connection conn) throws SQLException {
        String sql = "INSERT INTO ocorrencia_frete " +
                     "(id_frete, tipo, data_hora, municipio, uf, descricao, " +
                     "nome_recebedor, documento_recebedor) " +
                     "VALUES (?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, o.getIdFrete());
            ps.setString(2, o.getTipo().name());
            ps.setTimestamp(3, Timestamp.valueOf(o.getDataHora()));
            ps.setString(4, o.getMunicipio());
            ps.setString(5, o.getUf());
            ps.setString(6, o.getDescricao());
            ps.setString(7, o.getNomeRecebedor());
            ps.setString(8, o.getDocumentoRecebedor());
            ps.executeUpdate();
        }
    }

    public List<OcorrenciaFrete> listarPorFrete(Long idFrete) throws SQLException {
        List<OcorrenciaFrete> lista = new ArrayList<>();
        String sql = "SELECT * FROM ocorrencia_frete WHERE id_frete = ? ORDER BY data_hora ASC";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, idFrete);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        }
        return lista;
    }

    public OcorrenciaFrete buscarUltimaPorFrete(Long idFrete) throws SQLException {
        String sql = "SELECT * FROM ocorrencia_frete WHERE id_frete = ? " +
                     "ORDER BY data_hora DESC LIMIT 1";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, idFrete);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    private OcorrenciaFrete mapear(ResultSet rs) throws SQLException {
        OcorrenciaFrete o = new OcorrenciaFrete();
        o.setId(rs.getLong("id"));
        o.setIdFrete(rs.getLong("id_frete"));
        o.setTipo(TipoOcorrencia.valueOf(rs.getString("tipo")));
        Timestamp ts = rs.getTimestamp("data_hora");
        if (ts != null) o.setDataHora(ts.toLocalDateTime());
        o.setMunicipio(rs.getString("municipio"));
        o.setUf(rs.getString("uf"));
        o.setDescricao(rs.getString("descricao"));
        o.setNomeRecebedor(rs.getString("nome_recebedor"));
        o.setDocumentoRecebedor(rs.getString("documento_recebedor"));
        return o;
    }
}