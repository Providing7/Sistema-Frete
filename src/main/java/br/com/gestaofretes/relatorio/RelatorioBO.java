package br.com.gestaofretes.relatorio;

import br.com.gestaofretes.exception.NegocioException;
import br.com.gestaofretes.motorista.Motorista;
import br.com.gestaofretes.motorista.MotoristaDAO;
import br.com.gestaofretes.util.ConexaoDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class RelatorioBO {

    private static final Logger LOG = Logger.getLogger(RelatorioBO.class.getName());
    private final MotoristaDAO motoristaDAO = new MotoristaDAO();

    public List<Motorista> listarMotoristasAtivos() throws NegocioException {
        try {
            return motoristaDAO.listarAtivos();
        } catch (SQLException e) {
            LOG.severe("Erro ao listar motoristas para relatório: " + e.getMessage());
            throw new NegocioException("Erro ao carregar lista de motoristas.");
        }
    }

    /**
     * Retorna todos os agrupamentos motorista+data que possuem fretes,
     * ordenados pela data mais recente e nome do motorista.
     */
    public List<RomaneioDisponivel> listarRomaneiosDisponiveis() throws NegocioException {
        String sql =
            "SELECT m.id                                              AS id_motorista, " +
            "       m.nome                                           AS nome_motorista, " +
            "       TO_CHAR(f.data_emissao, 'YYYY-MM-DD')           AS data_emissao, " +
            "       TO_CHAR(f.data_emissao, 'DD/MM/YYYY')           AS data_formatada, " +
            "       COUNT(*)                                         AS qtd_fretes, " +
            "       STRING_AGG(DISTINCT f.status, ', ' ORDER BY f.status) AS status_resumo " +
            "FROM frete f " +
            "JOIN motorista m ON m.id = f.id_motorista " +
            "GROUP BY m.id, m.nome, f.data_emissao " +
            "ORDER BY f.data_emissao DESC, m.nome";

        List<RomaneioDisponivel> lista = new ArrayList<>();
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(new RomaneioDisponivel(
                    rs.getLong("id_motorista"),
                    rs.getString("nome_motorista"),
                    rs.getString("data_emissao"),
                    rs.getString("data_formatada"),
                    rs.getInt("qtd_fretes"),
                    rs.getString("status_resumo")
                ));
            }
        } catch (SQLException e) {
            LOG.severe("Erro ao listar romaneios disponíveis: " + e.getMessage());
            throw new NegocioException("Erro ao carregar romaneios disponíveis.");
        }
        return lista;
    }
}