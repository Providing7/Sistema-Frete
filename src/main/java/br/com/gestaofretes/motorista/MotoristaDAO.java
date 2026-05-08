package br.com.gestaofretes.motorista;

import br.com.gestaofretes.util.ConexaoDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MotoristaDAO {

    private static final int TAMANHO_PAGINA = 10;

    public List<Motorista> listar(String filtro, int pagina) throws SQLException {
        List<Motorista> lista = new ArrayList<>();
        String sql = "SELECT * FROM motorista WHERE nome ILIKE ? ORDER BY nome LIMIT ? OFFSET ?";

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
        String sql = "SELECT COUNT(*) FROM motorista WHERE nome ILIKE ?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + (filtro == null ? "" : filtro) + "%");
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public Motorista buscarPorId(Long id) throws SQLException {
        String sql = "SELECT * FROM motorista WHERE id = ?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    public void salvar(Motorista m) throws SQLException {
        String sql = "INSERT INTO motorista (nome, cpf, data_nascimento, telefone, cnh_numero, " +
                     "cnh_categoria, cnh_validade, tipo_vinculo, status) VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            preencherStatement(ps, m);
            ps.executeUpdate();
        }
    }

    public void atualizar(Motorista m) throws SQLException {
        String sql = "UPDATE motorista SET nome=?, cpf=?, data_nascimento=?, telefone=?, " +
                     "cnh_numero=?, cnh_categoria=?, cnh_validade=?, tipo_vinculo=?, status=? WHERE id=?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            preencherStatement(ps, m);
            ps.setLong(10, m.getId());
            ps.executeUpdate();
        }
    }

    public void excluir(Long id) throws SQLException {
        String sql = "DELETE FROM motorista WHERE id = ?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }

    public boolean temFretesAtivos(Long id) throws SQLException {
        String sql = "SELECT 1 FROM frete WHERE id_motorista = ? " +
                     "AND status IN ('EMITIDO','SAIDA_CONFIRMADA','EM_TRANSITO') LIMIT 1";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    public boolean cpfJaCadastrado(String cpf, Long idIgnorar) throws SQLException {
        String sql = "SELECT 1 FROM motorista WHERE cpf = ? AND id != ? LIMIT 1";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cpf);
            ps.setLong(2, idIgnorar == null ? -1L : idIgnorar);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    private void preencherStatement(PreparedStatement ps, Motorista m) throws SQLException {
        ps.setString(1, m.getNome());
        ps.setString(2, m.getCpf());
        ps.setDate(3, m.getDataNascimento() != null ? Date.valueOf(m.getDataNascimento()) : null);
        ps.setString(4, m.getTelefone());
        ps.setString(5, m.getCnhNumero());
        ps.setString(6, m.getCnhCategoria() != null ? m.getCnhCategoria().name() : null);
        ps.setDate(7, m.getCnhValidade() != null ? Date.valueOf(m.getCnhValidade()) : null);
        ps.setString(8, m.getTipoVinculo() != null ? m.getTipoVinculo().name() : null);
        ps.setString(9, m.getStatus() != null ? m.getStatus().name() : "ATIVO");
    }

    private Motorista mapear(ResultSet rs) throws SQLException {
        Motorista m = new Motorista();
        m.setId(rs.getLong("id"));
        m.setNome(rs.getString("nome"));
        m.setCpf(rs.getString("cpf"));
        Date dn = rs.getDate("data_nascimento");
        if (dn != null) m.setDataNascimento(dn.toLocalDate());
        m.setTelefone(rs.getString("telefone"));
        m.setCnhNumero(rs.getString("cnh_numero"));
        String cat = rs.getString("cnh_categoria");
        if (cat != null) m.setCnhCategoria(CategoriaCNH.valueOf(cat));
        Date val = rs.getDate("cnh_validade");
        if (val != null) m.setCnhValidade(val.toLocalDate());
        String vinculo = rs.getString("tipo_vinculo");
        if (vinculo != null) m.setTipoVinculo(TipoVinculo.valueOf(vinculo));
        m.setStatus(StatusMotorista.valueOf(rs.getString("status")));
        return m;
    }
    
    public List<Motorista> listarAtivos() throws SQLException {
        List<Motorista> lista = new ArrayList<>();
        String sql = "SELECT id, nome FROM motorista WHERE status = 'ATIVO' ORDER BY nome";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Motorista m = new Motorista();
                m.setId(rs.getLong("id"));
                m.setNome(rs.getString("nome"));
                lista.add(m);
            }
        }
        return lista;
    }
}
