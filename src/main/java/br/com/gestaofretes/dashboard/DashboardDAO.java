package br.com.gestaofretes.dashboard;

import br.com.gestaofretes.util.ConexaoDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class DashboardDAO {

    /**
     * Contagem de fretes agrupada por status.
     * Retorna mapa ordenado: status → quantidade.
     */
    public Map<String, Integer> contarFretesPorStatus() throws SQLException {
        String sql = "SELECT status, COUNT(*) AS total FROM frete GROUP BY status ORDER BY status";
        Map<String, Integer> resultado = new LinkedHashMap<>();
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                resultado.put(rs.getString("status"), rs.getInt("total"));
            }
        }
        return resultado;
    }

    /**
     * Faturamento mensal dos últimos N meses (fretes não cancelados).
     * Retorna lista de [label (MM/YYYY), valorTotal].
     */
    public List<Object[]> faturamentoPorMes(int meses) throws SQLException {
        String sql =
            "SELECT TO_CHAR(data_emissao, 'MM/YYYY') AS mes, " +
            "       EXTRACT(YEAR  FROM data_emissao)::INT AS ano, " +
            "       EXTRACT(MONTH FROM data_emissao)::INT AS num_mes, " +
            "       COALESCE(SUM(valor_total), 0) AS total " +
            "FROM frete " +
            "WHERE data_emissao >= (CURRENT_DATE - (? || ' months')::INTERVAL) " +
            "  AND status NOT IN ('CANCELADO') " +
            "GROUP BY mes, ano, num_mes " +
            "ORDER BY ano ASC, num_mes ASC";

        List<Object[]> lista = new ArrayList<>();
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, meses);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(new Object[]{
                        rs.getString("mes"),
                        rs.getDouble("total")
                    });
                }
            }
        }
        return lista;
    }

    /**
     * Top N rotas mais frequentes (por UF de origem → UF de destino).
     * Retorna lista de [uf_origem, uf_destino, quantidade].
     */
    public List<Object[]> listarTopRotas(int limite) throws SQLException {
        String sql =
            "SELECT uf_origem, uf_destino, COUNT(*) AS total " +
            "FROM frete " +
            "WHERE status NOT IN ('CANCELADO') " +
            "GROUP BY uf_origem, uf_destino " +
            "ORDER BY total DESC " +
            "LIMIT ?";

        List<Object[]> lista = new ArrayList<>();
        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(new Object[]{
                        rs.getString("uf_origem"),
                        rs.getString("uf_destino"),
                        rs.getInt("total")
                    });
                }
            }
        }
        return lista;
    }
}
