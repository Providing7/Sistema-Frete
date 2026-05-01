package br.com.gestaofretes.frete;

import br.com.gestaofretes.cliente.Cliente;
import br.com.gestaofretes.motorista.Motorista;
import br.com.gestaofretes.motorista.StatusMotorista;
import br.com.gestaofretes.util.ConexaoDB;
import br.com.gestaofretes.veiculo.StatusVeiculo;
import br.com.gestaofretes.veiculo.TipoVeiculo;
import br.com.gestaofretes.veiculo.Veiculo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FreteDAO {

    private static final int TAMANHO_PAGINA = 10;

    // ----------------------------------------------------------------
    // Salvar — recebe Connection de fora (participa de transação)
    // ----------------------------------------------------------------
    public void salvar(Frete f, Connection conn) throws SQLException {
        String sql = "INSERT INTO frete (numero, id_remetente, id_destinatario, " +
                     "id_motorista, id_veiculo, municipio_origem, uf_origem, " +
                     "municipio_destino, uf_destino, descricao_carga, peso_kg, volumes, " +
                     "valor_frete, aliquota_icms, valor_icms, valor_total, status, " +
                     "data_emissao, data_previsao_entrega) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, f.getNumero());
            ps.setLong(2, f.getRemetente().getId());
            ps.setLong(3, f.getDestinatario().getId());
            ps.setLong(4, f.getMotorista().getId());
            ps.setLong(5, f.getVeiculo().getId());
            ps.setString(6, f.getMunicipioOrigem());
            ps.setString(7, f.getUfOrigem());
            ps.setString(8, f.getMunicipioDestino());
            ps.setString(9, f.getUfDestino());
            ps.setString(10, f.getDescricaoCarga());
            ps.setDouble(11, f.getPesoKg());
            ps.setInt(12, f.getVolumes());
            ps.setDouble(13, f.getValorFrete());
            ps.setDouble(14, f.getAliquotaIcms());
            ps.setDouble(15, f.getValorIcms());
            ps.setDouble(16, f.getValorTotal());
            ps.setString(17, f.getStatus().name());
            ps.setDate(18, Date.valueOf(f.getDataEmissao()));
            ps.setDate(19, f.getDataPrevisaoEntrega() != null
                    ? Date.valueOf(f.getDataPrevisaoEntrega()) : null);
            ps.executeUpdate();
        }
    }

    // ----------------------------------------------------------------
    // Buscar por ID com JOIN (evita N+1)
    // ----------------------------------------------------------------
    public Frete buscarPorId(Long id) throws SQLException {
        String sql =
            "SELECT f.*, " +
            "r.id AS rem_id, r.razao_social AS rem_razao, r.nome_fantasia AS rem_fantasia, " +
            "d.id AS dest_id, d.razao_social AS dest_razao, d.nome_fantasia AS dest_fantasia, " +
            "m.id AS mot_id, m.nome AS mot_nome, m.cnh_validade AS mot_cnh_validade, " +
            "m.status AS mot_status, " +
            "v.id AS veic_id, v.placa AS veic_placa, v.tipo AS veic_tipo, " +
            "v.capacidade_kg AS veic_capacidade, v.status AS veic_status " +
            "FROM frete f " +
            "JOIN cliente r ON r.id = f.id_remetente " +
            "JOIN cliente d ON d.id = f.id_destinatario " +
            "JOIN motorista m ON m.id = f.id_motorista " +
            "JOIN veiculo v ON v.id = f.id_veiculo " +
            "WHERE f.id = ?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapearComJoin(rs) : null;
            }
        }
    }

    // ----------------------------------------------------------------
    // Listar com paginação e filtro (número ou destino)
    // ----------------------------------------------------------------
    public List<Frete> listar(String filtro, int pagina) throws SQLException {
        List<Frete> lista = new ArrayList<>();
        String sql =
            "SELECT f.*, " +
            "r.id AS rem_id, r.razao_social AS rem_razao, r.nome_fantasia AS rem_fantasia, " +
            "d.id AS dest_id, d.razao_social AS dest_razao, d.nome_fantasia AS dest_fantasia, " +
            "m.id AS mot_id, m.nome AS mot_nome, m.cnh_validade AS mot_cnh_validade, " +
            "m.status AS mot_status, " +
            "v.id AS veic_id, v.placa AS veic_placa, v.tipo AS veic_tipo, " +
            "v.capacidade_kg AS veic_capacidade, v.status AS veic_status " +
            "FROM frete f " +
            "JOIN cliente r ON r.id = f.id_remetente " +
            "JOIN cliente d ON d.id = f.id_destinatario " +
            "JOIN motorista m ON m.id = f.id_motorista " +
            "JOIN veiculo v ON v.id = f.id_veiculo " +
            "WHERE f.numero ILIKE ? OR r.razao_social ILIKE ? OR d.razao_social ILIKE ? " +
            "ORDER BY f.data_emissao DESC, f.id DESC " +
            "LIMIT ? OFFSET ?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String like = "%" + (filtro == null ? "" : filtro) + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            ps.setInt(4, TAMANHO_PAGINA);
            ps.setInt(5, (pagina - 1) * TAMANHO_PAGINA);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapearComJoin(rs));
            }
        }
        return lista;
    }

    public int contarTotal(String filtro) throws SQLException {
        String sql =
            "SELECT COUNT(*) FROM frete f " +
            "JOIN cliente r ON r.id = f.id_remetente " +
            "JOIN cliente d ON d.id = f.id_destinatario " +
            "WHERE f.numero ILIKE ? OR r.razao_social ILIKE ? OR d.razao_social ILIKE ?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String like = "%" + (filtro == null ? "" : filtro) + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // ----------------------------------------------------------------
    // Atualizar status — recebe Connection (transação)
    // ----------------------------------------------------------------
    public void atualizarStatus(Long id, StatusFrete status, Connection conn) throws SQLException {
        String sql = "UPDATE frete SET status = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setLong(2, id);
            ps.executeUpdate();
        }
    }

    public void atualizarDataSaida(Long id, Timestamp dataSaida, Connection conn) throws SQLException {
        String sql = "UPDATE frete SET data_saida = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, dataSaida);
            ps.setLong(2, id);
            ps.executeUpdate();
        }
    }

    public void atualizarDataEntrega(Long id, Timestamp dataEntrega, Connection conn) throws SQLException {
        String sql = "UPDATE frete SET data_entrega = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, dataEntrega);
            ps.setLong(2, id);
            ps.executeUpdate();
        }
    }

    // ----------------------------------------------------------------
    // Contagens para o dashboard
    // ----------------------------------------------------------------
    public int contarFretesNoMes() throws SQLException {
        String sql = "SELECT COUNT(*) FROM frete " +
                     "WHERE EXTRACT(MONTH FROM data_emissao) = EXTRACT(MONTH FROM CURRENT_DATE) " +
                     "AND EXTRACT(YEAR FROM data_emissao) = EXTRACT(YEAR FROM CURRENT_DATE)";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int contarFretesEmAberto() throws SQLException {
        String sql = "SELECT COUNT(*) FROM frete " +
                     "WHERE status IN ('EMITIDO','SAIDA_CONFIRMADA','EM_TRANSITO')";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ----------------------------------------------------------------
    // Próximo sequencial para geração do número no BO
    // ----------------------------------------------------------------
    public int proximoSequencial(int ano) throws SQLException {
        String sql = "SELECT COALESCE(MAX(CAST(SPLIT_PART(numero,'-',3) AS INTEGER)), 0) + 1 " +
                     "FROM frete WHERE numero LIKE ?";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "FRT-" + ano + "-%");
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 1;
            }
        }
    }

    // ----------------------------------------------------------------
    // Verifica se motorista já tem frete em SAIDA_CONFIRMADA ou EM_TRANSITO
    // ----------------------------------------------------------------
    public boolean motoristaTemFreteAtivo(Long idMotorista) throws SQLException {
        String sql = "SELECT 1 FROM frete WHERE id_motorista = ? " +
                     "AND status IN ('SAIDA_CONFIRMADA','EM_TRANSITO') LIMIT 1";
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, idMotorista);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    // ----------------------------------------------------------------
    // Mapear ResultSet com JOIN já resolvido
    // ----------------------------------------------------------------
    private Frete mapearComJoin(ResultSet rs) throws SQLException {
        Frete f = new Frete();
        f.setId(rs.getLong("id"));
        f.setNumero(rs.getString("numero"));
        f.setStatus(StatusFrete.valueOf(rs.getString("status")));
        f.setMunicipioOrigem(rs.getString("municipio_origem"));
        f.setUfOrigem(rs.getString("uf_origem"));
        f.setMunicipioDestino(rs.getString("municipio_destino"));
        f.setUfDestino(rs.getString("uf_destino"));
        f.setDescricaoCarga(rs.getString("descricao_carga"));
        f.setPesoKg(rs.getDouble("peso_kg"));
        f.setVolumes(rs.getInt("volumes"));
        f.setValorFrete(rs.getDouble("valor_frete"));
        f.setAliquotaIcms(rs.getDouble("aliquota_icms"));
        f.setValorIcms(rs.getDouble("valor_icms"));
        f.setValorTotal(rs.getDouble("valor_total"));

        Date de = rs.getDate("data_emissao");
        if (de != null) f.setDataEmissao(de.toLocalDate());
        Date dp = rs.getDate("data_previsao_entrega");
        if (dp != null) f.setDataPrevisaoEntrega(dp.toLocalDate());
        Timestamp ts = rs.getTimestamp("data_saida");
        if (ts != null) f.setDataSaida(ts.toLocalDateTime());
        Timestamp te = rs.getTimestamp("data_entrega");
        if (te != null) f.setDataEntrega(te.toLocalDateTime());

        Cliente rem = new Cliente();
        rem.setId(rs.getLong("rem_id"));
        rem.setRazaoSocial(rs.getString("rem_razao"));
        rem.setNomeFantasia(rs.getString("rem_fantasia"));
        f.setRemetente(rem);

        Cliente dest = new Cliente();
        dest.setId(rs.getLong("dest_id"));
        dest.setRazaoSocial(rs.getString("dest_razao"));
        dest.setNomeFantasia(rs.getString("dest_fantasia"));
        f.setDestinatario(dest);

        Motorista m = new Motorista();
        m.setId(rs.getLong("mot_id"));
        m.setNome(rs.getString("mot_nome"));
        Date cnhVal = rs.getDate("mot_cnh_validade");
        if (cnhVal != null) m.setCnhValidade(cnhVal.toLocalDate());
        String motStatus = rs.getString("mot_status");
        if (motStatus != null) m.setStatus(StatusMotorista.valueOf(motStatus));
        f.setMotorista(m);

        Veiculo v = new Veiculo();
        v.setId(rs.getLong("veic_id"));
        v.setPlaca(rs.getString("veic_placa"));
        String veicTipo = rs.getString("veic_tipo");
        if (veicTipo != null) v.setTipo(TipoVeiculo.valueOf(veicTipo));
        v.setCapacidadeKg(rs.getDouble("veic_capacidade"));
        String veicStatus = rs.getString("veic_status");
        if (veicStatus != null) v.setStatus(StatusVeiculo.valueOf(veicStatus));
        f.setVeiculo(v);

        return f;
    }
}