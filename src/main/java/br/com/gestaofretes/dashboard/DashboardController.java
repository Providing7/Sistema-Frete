package br.com.gestaofretes.dashboard;

import br.com.gestaofretes.cliente.ClienteDAO;
import br.com.gestaofretes.frete.FreteDAO;
import br.com.gestaofretes.motorista.MotoristaDAO;
import br.com.gestaofretes.veiculo.VeiculoDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.logging.Logger;

@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(DashboardController.class.getName());

    private final ClienteDAO    clienteDAO    = new ClienteDAO();
    private final MotoristaDAO  motoristaDAO  = new MotoristaDAO();
    private final VeiculoDAO    veiculoDAO    = new VeiculoDAO();
    private final FreteDAO      freteDAO      = new FreteDAO();
    private final DashboardDAO  dashboardDAO  = new DashboardDAO();

    private static final String MAPBOX_TOKEN;

    static {
        String token = "";
        try (InputStream is = DashboardController.class
                .getClassLoader().getResourceAsStream("db.properties")) {
            Properties props = new Properties();
            props.load(is);
            token = props.getProperty("mapbox.token", "");
        } catch (Exception e) {
            Logger.getLogger(DashboardController.class.getName())
                  .warning("mapbox.token nao encontrado em db.properties");
        }
        MAPBOX_TOKEN = token;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession(false) == null ||
            req.getSession(false).getAttribute("usuarioLogado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            // KPIs existentes
            req.setAttribute("totalClientes",    clienteDAO.contarTotal(null));
            req.setAttribute("totalMotoristas",  motoristaDAO.contarTotal(null));
            req.setAttribute("totalVeiculos",    veiculoDAO.contarTotal(null));
            req.setAttribute("fretesNoMes",      freteDAO.contarFretesNoMes());
            req.setAttribute("fretesEmAberto",   freteDAO.contarFretesEmAberto());
            req.setAttribute("motoristasAlertaCNH", motoristaDAO.listarComCNHCritica(30));

            // Gráfico 1 — Fretes por Status
            Map<String, Integer> porStatus = dashboardDAO.contarFretesPorStatus();
            req.setAttribute("graficoStatusLabels", toJsonArray(porStatus.keySet().toArray()));
            req.setAttribute("graficoStatusData",   toJsonArray(porStatus.values().toArray()));

            String mesesParam = req.getParameter("meses");
            int mesesFaturamento = 6;
            if (mesesParam != null && mesesParam.matches("\\d+")) {
                int parsed = Integer.parseInt(mesesParam);
                if (parsed >= 1 && parsed <= 24) mesesFaturamento = parsed;
            }
            req.setAttribute("mesesFaturamento", mesesFaturamento);

            List<Object[]> faturamento = dashboardDAO.faturamentoPorMes(mesesFaturamento);
            String[] mesesLabel = new String[faturamento.size()];
            Double[]  mesesValor = new Double[faturamento.size()];
            for (int i = 0; i < faturamento.size(); i++) {
                mesesLabel[i] = (String) faturamento.get(i)[0];
                mesesValor[i] = (Double)  faturamento.get(i)[1];
            }
            req.setAttribute("graficoFatLabels", toJsonArray(mesesLabel));
            req.setAttribute("graficoFatData",   toJsonArray(mesesValor));

            // Gráfico 3 — Top rotas (para o mapa)
            List<Object[]> rotas = dashboardDAO.listarTopRotas(10);
            req.setAttribute("graficoRotas", toJsonRotas(rotas));

            req.setAttribute("mapboxToken", MAPBOX_TOKEN);

        } catch (Exception e) {
            LOG.severe("Erro ao carregar dados do dashboard: " + e.getMessage());
        }

        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
    }

    /** Converte array de valores para JSON array string: ["a","b"] ou [1,2] */
    private String toJsonArray(Object[] values) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < values.length; i++) {
            if (i > 0) sb.append(",");
            Object v = values[i];
            if (v instanceof Number) {
                sb.append(v);
            } else {
                sb.append("\"").append(v).append("\"");
            }
        }
        sb.append("]");
        return sb.toString();
    }

    /** Converte lista de rotas para JSON array: [{uf_o, uf_d, total}, ...] */
    private String toJsonRotas(List<Object[]> rotas) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < rotas.size(); i++) {
            if (i > 0) sb.append(",");
            Object[] r = rotas.get(i);
            sb.append("{\"origem\":\"").append(r[0])
              .append("\",\"destino\":\"").append(r[1])
              .append("\",\"total\":").append(r[2])
              .append("}");
        }
        sb.append("]");
        return sb.toString();
    }
}