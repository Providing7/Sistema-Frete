package br.com.gestaofretes.cliente;

import br.com.gestaofretes.util.ConexaoDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    private static final int TAMANHO_PAGINA = 10;

    public List<Cliente> listar(String filtro, int pagina) throws SQLException {
        List<Cliente> lista = new ArrayList<>();
        String sql = "SELECT * FROM cliente WHERE razao_social ILIKE ? " +
                     "ORDER BY razao_social LIMIT ? OFFSET ?";

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + (filtro == null ? "" : filtro) + "%");
            ps.setInt(2, TAMANHO_PAGINA);
            ps.setInt(3, (pagina - 1) * TAMANHO_PAGINA);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }
        return lista;
    }

    public int contarTotal(String filtro) throws SQLException {
        String sql = "SELECT COUNT(*) FROM cliente WHERE razao_social ILIKE ?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + (filtro == null ? "" : filtro) + "%");
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public Cliente buscarPorId(Long id) throws SQLException {
        String sql = "SELECT * FROM cliente WHERE id = ?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapear(rs) : null;
            }
        }
    }

    public void salvar(Cliente c) throws SQLException {   // ← ADICIONAR esta linha
        String sql = "INSERT INTO cliente (razao_social, nome_fantasia, cnpj, inscricao_estadual, " +
                "logradouro, numero, complemento, bairro, municipio, uf, cep, " +
                "telefone, email, status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            preencherStatement(ps, c);
            ps.executeUpdate();
        }
    }

    public void atualizar(Cliente c) throws SQLException {
    	String sql = "UPDATE cliente SET razao_social=?, nome_fantasia=?, cnpj=?, " +
                "inscricao_estadual=?, logradouro=?, numero=?, complemento=?, " +
                "bairro=?, municipio=?, uf=?, cep=?, telefone=?, email=?, status=? " +
                "WHERE id=?";


        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            preencherStatement(ps, c);
            ps.setLong(15, c.getId());
            ps.executeUpdate();
        }
    }

    public void excluir(Long id) throws SQLException {
        String sql = "DELETE FROM cliente WHERE id = ?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.executeUpdate();
        }
    }

    public boolean temFretes(Long id) throws SQLException {
        String sql = "SELECT 1 FROM frete WHERE id_remetente = ? OR id_destinatario = ? LIMIT 1";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ps.setLong(2, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean cnpjJaCadastrado(String cnpj, Long idIgnorar) throws SQLException {
        String sql = "SELECT 1 FROM cliente WHERE cnpj = ? AND id != ? LIMIT 1";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cnpj);
            ps.setLong(2, idIgnorar == null ? -1L : idIgnorar);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // Métodos auxiliares privados

    private void preencherStatement(PreparedStatement ps, Cliente c) throws SQLException {
    	ps.setString(1, c.getRazaoSocial());
    	ps.setString(2, c.getNomeFantasia());
    	ps.setString(3, c.getCnpj());
    	ps.setString(4, c.getInscricaoEstadual());
    	ps.setString(5, c.getLogradouro());   // ← tudo sobe uma posição
    	ps.setString(6, c.getNumero());
    	ps.setString(7, c.getComplemento());
    	ps.setString(8, c.getBairro());
    	ps.setString(9, c.getMunicipio());
    	ps.setString(10, c.getUf());
    	ps.setString(11, c.getCep());
    	ps.setString(12, c.getTelefone());
    	ps.setString(13, c.getEmail());
    	ps.setBoolean(14, c.isAtivo());
    }

    private Cliente mapear(ResultSet rs) throws SQLException {
        Cliente c = new Cliente();
        c.setId(rs.getLong("id"));
        c.setRazaoSocial(rs.getString("razao_social"));
        c.setNomeFantasia(rs.getString("nome_fantasia"));
        c.setCnpj(rs.getString("cnpj"));
        c.setInscricaoEstadual(rs.getString("inscricao_estadual"));
        c.setLogradouro(rs.getString("logradouro"));
        c.setNumero(rs.getString("numero"));
        c.setComplemento(rs.getString("complemento"));
        c.setBairro(rs.getString("bairro"));
        c.setMunicipio(rs.getString("municipio"));
        c.setUf(rs.getString("uf"));
        c.setCep(rs.getString("cep"));
        c.setTelefone(rs.getString("telefone"));
        c.setEmail(rs.getString("email"));
        c.setAtivo(rs.getBoolean("status"));
        return c;
    }
}
