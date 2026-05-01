package br.com.gestaofretes.ocorrencia;

import br.com.gestaofretes.exception.FreteException;
import br.com.gestaofretes.frete.FreteBO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.logging.Logger;

@WebServlet("/ocorrencias")
public class OcorrenciaController extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(OcorrenciaController.class.getName());

    private final OcorrenciaBO bo = new OcorrenciaBO();
    private final FreteBO freteBO = new FreteBO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String acao = req.getParameter("acao");

        try {
            if ("nova".equals(acao)) {
                Long idFrete = Long.parseLong(req.getParameter("idFrete"));
                req.setAttribute("frete", freteBO.buscarPorId(idFrete));
                req.setAttribute("tiposOcorrencia", TipoOcorrencia.values());
                req.getRequestDispatcher("/WEB-INF/views/ocorrencias/form.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/fretes");
            }
        } catch (FreteException e) {
            req.setAttribute("erro", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/erro.jsp").forward(req, resp);
        } catch (Exception e) {
            LOG.severe("Erro inesperado em OcorrenciaController GET: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/erro.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Long idFrete = null;
        try {
            idFrete = Long.parseLong(req.getParameter("idFrete"));

            OcorrenciaFrete oc = new OcorrenciaFrete();
            oc.setIdFrete(idFrete);
            oc.setTipo(TipoOcorrencia.valueOf(req.getParameter("tipo")));
            oc.setDataHora(parseDataHora(req.getParameter("dataHora")));
            oc.setMunicipio(req.getParameter("municipio"));
            oc.setUf(req.getParameter("uf"));
            oc.setDescricao(req.getParameter("descricao"));
            oc.setNomeRecebedor(req.getParameter("nomeRecebedor"));
            oc.setDocumentoRecebedor(req.getParameter("documentoRecebedor"));

            bo.registrarOcorrencia(oc);
            resp.sendRedirect(req.getContextPath() + "/fretes?acao=detalhe&id=" + idFrete
                    + "&sucesso=Ocorrência+registrada+com+sucesso.");

        } catch (FreteException e) {
            req.setAttribute("erro", e.getMessage());
            try {
                if (idFrete != null) {
                    req.setAttribute("frete", freteBO.buscarPorId(idFrete));
                }
                req.setAttribute("tiposOcorrencia", TipoOcorrencia.values());
                req.getRequestDispatcher("/WEB-INF/views/ocorrencias/form.jsp").forward(req, resp);
            } catch (Exception ex) {
                LOG.severe("Erro ao redirecionar após FreteException: " + ex.getMessage());
                req.getRequestDispatcher("/WEB-INF/views/erro.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            LOG.severe("Erro inesperado em OcorrenciaController POST: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/erro.jsp").forward(req, resp);
        }
    }

    private LocalDateTime parseDataHora(String valor) {
        if (valor == null || valor.isEmpty()) return LocalDateTime.now();
        try {
            return LocalDateTime.parse(valor);
        } catch (DateTimeParseException e) {
            return LocalDateTime.now();
        }
    }
}
