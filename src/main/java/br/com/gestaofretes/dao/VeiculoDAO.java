package br.com.gestaofretes.dao;

import br.com.gestaofretes.model.*;
import br.com.gestaofretes.util.ConexaoDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VeiculoDAO {

    private static final int TAMANHO_PAGINA = 10;

    public List<Veiculo> listar(String filtro, int pagina) throws SQLException {
        List<Veiculo> lista = new ArrayList<>();
        String sql = "SELECT * FROM veiculo WHERE placa ILIKE ? ORDER BY placa LIMIT ? OFFSET ?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + (filtro == null ? "" : filtro) + "%");
            ps.setInt(2, TAMANHO_PAGINA);
            ps.setInt(3, (pagina - 1) * TAMANHO_PAGINA);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        }
        return lista;
    }

    public int contarTotal(String filtro) throws SQLException {
        String sql = "SELECT COUNT(*) FROM veiculo WHERE placa ILIKE ?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + (filtro == null ? "" : filtro) + "%");
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public Veiculo buscarPorId(Long id) throws SQLException {
        String sql = "SELECT * FROM veiculo WHERE id = ?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    public void salvar(Veiculo v) throws SQLException {
        String sql = "INSERT INTO veiculo (placa, rntrc, ano_fabricacao, tipo, tara_kg, " +
                     "capacidade_kg, volume_m3, status) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            preencherStatement(ps, v);
            ps.executeUpdate();
        }
    }

    public void atualizar(Veiculo v) throws SQLException {
        String sql = "UPDATE veiculo SET placa=?, rntrc=?, ano_fabricacao=?, tipo=?, tara_kg=?, " +
                     "capacidade_kg=?, volume_m3=?, status=? WHERE id=?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            preencherStatement(ps, v);
            ps.setLong(9, v.getId());
            ps.executeUpdate();
        }
    }

    public void excluir(Long id) throws SQLException {
        String sql = "DELETE FROM veiculo WHERE id = ?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }

    public boolean temFretesAtivos(Long id) throws SQLException {
        String sql = "SELECT 1 FROM frete WHERE id_veiculo = ? " +
                     "AND status IN ('EMITIDO','SAIDA_CONFIRMADA','EM_TRANSITO') LIMIT 1";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    // Atualizar status dentro de uma transação (recebe Connection externa)
    public void atualizarStatus(Long id, StatusVeiculo status, Connection conn) throws SQLException {
        String sql = "UPDATE veiculo SET status = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setLong(2, id);
            ps.executeUpdate();
        }
    }

    public boolean placaJaCadastrada(String placa, Long idIgnorar) throws SQLException {
        String sql = "SELECT 1 FROM veiculo WHERE placa = ? AND id != ? LIMIT 1";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, placa);
            ps.setLong(2, idIgnorar == null ? -1L : idIgnorar);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    private void preencherStatement(PreparedStatement ps, Veiculo v) throws SQLException {
        ps.setString(1, v.getPlaca());
        ps.setString(2, v.getRntrc());
        ps.setInt(3, v.getAnoFabricacao());
        ps.setString(4, v.getTipo() != null ? v.getTipo().name() : null);
        ps.setDouble(5, v.getTaraKg());
        ps.setDouble(6, v.getCapacidadeKg());
        ps.setDouble(7, v.getVolumeM3());
        ps.setString(8, v.getStatus() != null ? v.getStatus().name() : "DISPONIVEL");
    }

    private Veiculo mapear(ResultSet rs) throws SQLException {
        Veiculo v = new Veiculo();
        v.setId(rs.getLong("id"));
        v.setPlaca(rs.getString("placa"));
        v.setRntrc(rs.getString("rntrc"));
        v.setAnoFabricacao(rs.getInt("ano_fabricacao"));
        String tipo = rs.getString("tipo");
        if (tipo != null) v.setTipo(TipoVeiculo.valueOf(tipo));
        v.setTaraKg(rs.getDouble("tara_kg"));
        v.setCapacidadeKg(rs.getDouble("capacidade_kg"));
        v.setVolumeM3(rs.getDouble("volume_m3"));
        v.setStatus(StatusVeiculo.valueOf(rs.getString("status")));
        return v;
    }
}
