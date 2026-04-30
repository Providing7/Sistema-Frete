package br.com.gestaofretes.controller;

import br.com.gestaofretes.bo.ClienteBO;
import br.com.gestaofretes.bo.FreteBO;
import br.com.gestaofretes.bo.MotoristaBO;
import br.com.gestaofretes.bo.VeiculoBO;
import br.com.gestaofretes.exception.FreteException;
import br.com.gestaofretes.exception.NegocioException;
import br.com.gestaofretes.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/fretes")
public class FreteController extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(FreteController.class.getName());
    private static final int TAMANHO_PAGINA = 10;

    private final FreteBO bo              = new FreteBO();
    private final ClienteBO clienteBO     = new ClienteBO();
    private final MotoristaBO motoristaBO = new MotoristaBO();
    private final VeiculoBO veiculoBO     = new VeiculoBO();
    private final br.com.gestaofretes.bo.OcorrenciaBO ocorrenciaBO =
            new br.com.gestaofretes.bo.OcorrenciaBO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String acao = req.getParameter("acao");

        try {
            if ("novo".equals(acao)) {
                carregarDependencias(req);
                req.getRequestDispatcher("/WEB-INF/views/fretes/form.jsp").forward(req, resp);

            } else if ("detalhe".equals(acao)) {
                Long id = Long.parseLong(req.getParameter("id"));
                req.setAttribute("frete", bo.buscarPorId(id));
                req.setAttribute("ocorrencias", ocorrenciaBO.listarPorFrete(id));
                req.getRequestDispatcher("/WEB-INF/views/fretes/detalhe.jsp").forward(req, resp);

            } else if ("confirmarSaida".equals(acao)) {
                Long id = Long.parseLong(req.getParameter("id"));
                req.setAttribute("frete", bo.buscarPorId(id));
                req.getRequestDispatcher("/WEB-INF/views/fretes/confirmarSaida.jsp").forward(req, resp);

            } else if ("naoEntregue".equals(acao)) {
                Long id = Long.parseLong(req.getParameter("id"));
                req.setAttribute("frete", bo.buscarPorId(id));
                req.getRequestDispatcher("/WEB-INF/views/fretes/naoEntregue.jsp").forward(req, resp);

            } else if ("registrarEntrega".equals(acao)) {
                Long id = Long.parseLong(req.getParameter("id"));
                req.setAttribute("frete", bo.buscarPorId(id));
                req.getRequestDispatcher("/WEB-INF/views/fretes/registrarEntrega.jsp").forward(req, resp);

            } else {
                // Listar (ação padrão)
                String filtro = req.getParameter("filtro");
                int pagina = parsePagina(req.getParameter("pagina"));
                int total = bo.contarTotal(filtro);
                int totalPaginas = (int) Math.ceil((double) total / TAMANHO_PAGINA);
                if (totalPaginas < 1) totalPaginas = 1;

                req.setAttribute("fretes", bo.listar(filtro, pagina));
                req.setAttribute("filtro", filtro != null ? filtro : "");
                req.setAttribute("pagina", pagina);
                req.setAttribute("totalPaginas", totalPaginas);
                req.getRequestDispatcher("/WEB-INF/views/fretes/lista.jsp").forward(req, resp);
            }

        } catch (FreteException e) {
            req.setAttribute("erro", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/fretes/lista.jsp").forward(req, resp);
        } catch (Exception e) {
            LOG.severe("Erro inesperado em FreteController GET: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/erro.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String acao = req.getParameter("acao");

        try {
            if ("salvar".equals(acao)) {
                Frete frete = montarFrete(req);
                bo.emitirFrete(frete);
                resp.sendRedirect(req.getContextPath() + "/fretes?sucesso=Frete+emitido+com+sucesso.");

            } else if ("confirmarSaida".equals(acao)) {
                Long id = Long.parseLong(req.getParameter("id"));
                LocalDateTime dataSaida = parseDataHora(req.getParameter("dataSaida"));
                bo.confirmarSaida(id, dataSaida);
                resp.sendRedirect(req.getContextPath() + "/fretes?acao=detalhe&id=" + id
                        + "&sucesso=Saída+confirmada+com+sucesso.");

            } else if ("emTransito".equals(acao)) {
                Long id = Long.parseLong(req.getParameter("id"));
                bo.registrarEmTransito(id);
                resp.sendRedirect(req.getContextPath() + "/fretes?acao=detalhe&id=" + id
                        + "&sucesso=Frete+registrado+em+trânsito.");

            } else if ("registrarEntrega".equals(acao)) {
                Long id = Long.parseLong(req.getParameter("id"));
                LocalDateTime dataEntrega = parseDataHora(req.getParameter("dataEntrega"));
                bo.registrarEntrega(id, dataEntrega,
                        req.getParameter("nomeRecebedor"),
                        req.getParameter("documentoRecebedor"),
                        req.getParameter("municipio"),
                        req.getParameter("uf"));
                resp.sendRedirect(req.getContextPath() + "/fretes?acao=detalhe&id=" + id
                        + "&sucesso=Entrega+registrada+com+sucesso.");

            } else if ("naoEntregue".equals(acao)) {
                Long id = Long.parseLong(req.getParameter("id"));
                bo.registrarNaoEntregue(id, req.getParameter("motivo"));
                resp.sendRedirect(req.getContextPath() + "/fretes?acao=detalhe&id=" + id
                        + "&sucesso=Não+entrega+registrada.");

            } else if ("cancelar".equals(acao)) {
                Long id = Long.parseLong(req.getParameter("id"));
                bo.cancelar(id);
                resp.sendRedirect(req.getContextPath() + "/fretes?sucesso=Frete+cancelado.");

            } else {
                resp.sendRedirect(req.getContextPath() + "/fretes");
            }

        } catch (FreteException e) {
            // Erro de negócio — volta para o formulário com a mensagem
            req.setAttribute("erro", e.getMessage());
            try {
                if ("salvar".equals(acao)) {
                    carregarDependencias(req);
                    req.getRequestDispatcher("/WEB-INF/views/fretes/form.jsp").forward(req, resp);
                } else {
                    Long id = parseLongOuNulo(req.getParameter("id"));
                    if (id != null) {
                        req.setAttribute("frete", bo.buscarPorId(id));
                        req.setAttribute("ocorrencias", ocorrenciaBO.listarPorFrete(id));
                    }
                    req.getRequestDispatcher("/WEB-INF/views/fretes/detalhe.jsp").forward(req, resp);
                }
            } catch (Exception ex) {
                LOG.severe("Erro ao redirecionar após FreteException: " + ex.getMessage());
                req.getRequestDispatcher("/WEB-INF/views/erro.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            LOG.severe("Erro inesperado em FreteController POST: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/erro.jsp").forward(req, resp);
        }
    }

    // ----------------------------------------------------------------
    // Helpers privados
    // ----------------------------------------------------------------
    private void carregarDependencias(HttpServletRequest req) throws NegocioException {
        req.setAttribute("clientes", clienteBO.listar(null, 1));
        req.setAttribute("motoristas", motoristaBO.listar(null, 1));
        req.setAttribute("veiculos", veiculoBO.listar(null, 1));
    }

    private Frete montarFrete(HttpServletRequest req) {
        Frete f = new Frete();

        Cliente rem = new Cliente();
        rem.setId(Long.parseLong(req.getParameter("idRemetente")));
        f.setRemetente(rem);

        Cliente dest = new Cliente();
        dest.setId(Long.parseLong(req.getParameter("idDestinatario")));
        f.setDestinatario(dest);

        Motorista m = new Motorista();
        m.setId(Long.parseLong(req.getParameter("idMotorista")));
        // Precisamos do status e CNH para validação — buscamos do banco via BO
        try {
            Motorista mCompleto = motoristaBO.buscarPorId(m.getId());
            f.setMotorista(mCompleto);
        } catch (Exception e) {
            f.setMotorista(m);
        }

        Veiculo v = new Veiculo();
        v.setId(Long.parseLong(req.getParameter("idVeiculo")));
        try {
            Veiculo vCompleto = veiculoBO.buscarPorId(v.getId());
            f.setVeiculo(vCompleto);
        } catch (Exception e) {
            f.setVeiculo(v);
        }

        f.setMunicipioOrigem(req.getParameter("municipioOrigem"));
        f.setUfOrigem(req.getParameter("ufOrigem"));
        f.setMunicipioDestino(req.getParameter("municipioDestino"));
        f.setUfDestino(req.getParameter("ufDestino"));
        f.setDescricaoCarga(req.getParameter("descricaoCarga"));

        String pesoStr = req.getParameter("pesoKg");
        if (pesoStr != null && !pesoStr.isEmpty()) {
            f.setPesoKg(Double.parseDouble(pesoStr.replace(",", ".")));
        }
        String volStr = req.getParameter("volumes");
        if (volStr != null && !volStr.isEmpty()) {
            f.setVolumes(Integer.parseInt(volStr));
        }
        String valorStr = req.getParameter("valorFrete");
        if (valorStr != null && !valorStr.isEmpty()) {
            f.setValorFrete(Double.parseDouble(valorStr.replace(",", ".")));
        }
        String aliqStr = req.getParameter("aliquotaIcms");
        if (aliqStr != null && !aliqStr.isEmpty()) {
            double aliq = Double.parseDouble(aliqStr.replace(",", "."));
            f.setAliquotaIcms(aliq);
            f.setValorIcms(f.getValorFrete() * aliq / 100.0);
            f.setValorTotal(f.getValorFrete() + f.getValorIcms());
        }

        String prevStr = req.getParameter("dataPrevisaoEntrega");
        if (prevStr != null && !prevStr.isEmpty()) {
            f.setDataPrevisaoEntrega(LocalDate.parse(prevStr));
        }

        return f;
    }

    private LocalDateTime parseDataHora(String valor) {
        if (valor == null || valor.isEmpty()) return LocalDateTime.now();
        try {
            // Formulário HTML type="datetime-local" envia "yyyy-MM-ddTHH:mm"
            return LocalDateTime.parse(valor);
        } catch (DateTimeParseException e) {
            return LocalDateTime.now();
        }
    }

    private int parsePagina(String valor) {
        try { return Math.max(1, Integer.parseInt(valor)); }
        catch (Exception e) { return 1; }
    }

    private Long parseLongOuNulo(String valor) {
        try { return valor != null ? Long.parseLong(valor) : null; }
        catch (Exception e) { return null; }
    }
}
