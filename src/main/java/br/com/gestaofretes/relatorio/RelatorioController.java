package br.com.gestaofretes.relatorio;

import br.com.gestaofretes.exception.NegocioException;
import br.com.gestaofretes.util.ConexaoDB;
import net.sf.jasperreports.engine.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet("/relatorios/*")
public class RelatorioController extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(RelatorioController.class.getName());
    private final RelatorioBO bo = new RelatorioBO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo(); // /fretes-aberto  ou  /romaneio

        try {
        	if ("/fretes-aberto".equals(pathInfo)) {
        	    gerarFretesAberto(req, resp);

        	} else if ("/romaneio".equals(pathInfo)) {
        	    String idMotorista = req.getParameter("idMotorista");
        	    String dataInicio  = req.getParameter("dataInicio");
        	    String dataFim     = req.getParameter("dataFim");

        	    if (idMotorista == null || idMotorista.isEmpty()
        	            || dataInicio == null || dataInicio.isEmpty()
        	            || dataFim == null || dataFim.isEmpty()) {
        	        req.setAttribute("motoristas", bo.listarMotoristasAtivos());
        	        req.getRequestDispatcher(
        	            "/WEB-INF/views/relatorios/filtroRomaneio.jsp").forward(req, resp);
        	        return;
        	    }
        	    gerarRomaneio(req, resp, idMotorista, dataInicio, dataFim);

        	} else if ("/faturamento".equals(pathInfo)) {
        	    String dataInicio = req.getParameter("dataInicio");
        	    String dataFim    = req.getParameter("dataFim");

        	    if (dataInicio == null || dataInicio.isEmpty()
        	            || dataFim == null || dataFim.isEmpty()) {
        	        req.getRequestDispatcher(
        	            "/WEB-INF/views/relatorios/filtroFaturamento.jsp").forward(req, resp);
        	        return;
        	    }
        	    gerarFaturamento(req, resp, dataInicio, dataFim);

        	} else {
        	    resp.sendRedirect(req.getContextPath() + "/dashboard");
        	}

        } catch (NegocioException e) {
            req.setAttribute("erro", e.getMessage());
            try {
                req.setAttribute("motoristas", bo.listarMotoristasAtivos());
            } catch (Exception ignored) { }
            req.getRequestDispatcher(
                "/WEB-INF/views/relatorios/filtroRomaneio.jsp").forward(req, resp);
        } catch (Exception e) {
            LOG.severe("Erro ao gerar relatório: " + e.getMessage());
            req.getSession().setAttribute("erroInesperado",
                "Não foi possível gerar o relatório. Tente novamente.");
            resp.sendRedirect(req.getContextPath() + "/erro");
        }
    }

    // Relatório 1 — Fretes em Aberto
    private void gerarFretesAberto(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        try (Connection conn = ConexaoDB.getConnection()) {
            gerarPdf(req, resp, conn, "fretes_aberto.jrxml",
                     new HashMap<>(), "fretes_em_aberto.pdf");
        }
    }

        // Relatório 2 — Romaneio de Carga
    private void gerarRomaneio(HttpServletRequest req, HttpServletResponse resp,
             String idMotorista, String dataInicio, String dataFim) throws Exception {

        Map<String, Object> params = new HashMap<>();
        params.put("ID_MOTORISTA", Long.parseLong(idMotorista));
        params.put("DATA_INICIO", dataInicio);
        params.put("DATA_FIM",    dataFim);

        try (Connection conn = ConexaoDB.getConnection()) {
            gerarPdf(req, resp, conn, "romaneio.jrxml", params, "romaneio.pdf");
        }
    }
    
 // Relatório 3 — Faturamento por Período
    private void gerarFaturamento(HttpServletRequest req, HttpServletResponse resp,
                                   String dataInicio, String dataFim) throws Exception {
        Map<String, Object> params = new HashMap<>();
        params.put("DATA_INICIO", dataInicio);
        params.put("DATA_FIM",    dataFim);

        try (Connection conn = ConexaoDB.getConnection()) {
            gerarPdf(req, resp, conn, "faturamento.jrxml", params,
                     "faturamento_" + dataInicio + "_" + dataFim + ".pdf");
    	}
    }

    // Método genérico de geração de PDF
    private void gerarPdf(HttpServletRequest req, HttpServletResponse resp,
                           Connection conn, String nomeJrxml,
                           Map<String, Object> params, String nomeArquivo)
            throws Exception {

        String caminho = req.getServletContext()
                .getRealPath("/WEB-INF/relatorios/" + nomeJrxml);

        JasperReport jasperReport  = JasperCompileManager.compileReport(caminho);
        JasperPrint  jasperPrint   = JasperFillManager.fillReport(jasperReport, params, conn);

        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition",
                "inline; filename=\"" + nomeArquivo + "\"");

        JasperExportManager.exportReportToPdfStream(jasperPrint, resp.getOutputStream());
    }
}