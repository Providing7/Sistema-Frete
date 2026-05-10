package br.com.gestaofretes.dashboard;

import br.com.gestaofretes.cliente.ClienteDAO;
import br.com.gestaofretes.frete.FreteDAO;
import br.com.gestaofretes.motorista.MotoristaDAO;
import br.com.gestaofretes.veiculo.VeiculoDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(DashboardController.class.getName());

    private final ClienteDAO   clienteDAO   = new ClienteDAO();
    private final MotoristaDAO motoristaDAO = new MotoristaDAO();
    private final VeiculoDAO   veiculoDAO   = new VeiculoDAO();
    private final FreteDAO     freteDAO     = new FreteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession(false) == null ||
            req.getSession(false).getAttribute("usuarioLogado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            req.setAttribute("totalClientes",  clienteDAO.contarTotal(null));
            req.setAttribute("totalMotoristas", motoristaDAO.contarTotal(null));
            req.setAttribute("totalVeiculos",   veiculoDAO.contarTotal(null));
            req.setAttribute("fretesNoMes",     freteDAO.contarFretesNoMes());
            req.setAttribute("fretesEmAberto",  freteDAO.contarFretesEmAberto());
            req.setAttribute("motoristasAlertaCNH", motoristaDAO.listarComCNHCritica(30));
        } catch (Exception e) {
            LOG.severe("Erro ao carregar dados do dashboard: " + e.getMessage());
        }

        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
    }
}