package br.com.gestaofretes.dashboard;

import br.com.gestaofretes.motorista.MotoristaDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/alertas-cnh")
public class AlertasCNHController extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(AlertasCNHController.class.getName());
    private final MotoristaDAO motoristaDAO = new MotoristaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getSession(false) == null ||
            req.getSession(false).getAttribute("usuarioLogado") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            // Busca com 90 dias para mostrar panorama mais completo na página dedicada
            req.setAttribute("motoristasAlerta", motoristaDAO.listarComCNHCritica(90));
        } catch (Exception e) {
            LOG.severe("Erro ao carregar alertas de CNH: " + e.getMessage());
            req.setAttribute("motoristasAlerta", java.util.Collections.emptyList());
        }

        req.getRequestDispatcher("/WEB-INF/views/alertasCNH.jsp").forward(req, resp);
    }
}
