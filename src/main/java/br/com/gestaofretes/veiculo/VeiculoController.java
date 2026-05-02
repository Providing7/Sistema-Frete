package br.com.gestaofretes.veiculo;

import br.com.gestaofretes.exception.CadastroException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/veiculos")
public class VeiculoController extends HttpServlet {

    private final VeiculoBO bo = new VeiculoBO();
    private static final int TAMANHO_PAGINA = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String acao = req.getParameter("acao");

        try {
            if ("novo".equals(acao)) {
                req.setAttribute("tipos",       TipoVeiculo.values());
                req.setAttribute("statusLista", StatusVeiculo.values());
                req.getRequestDispatcher("/WEB-INF/views/veiculos/form.jsp").forward(req, resp);

            } else if ("editar".equals(acao)) {
                Long id = Long.parseLong(req.getParameter("id"));
                req.setAttribute("veiculo",     bo.buscarPorId(id));
                req.setAttribute("tipos",       TipoVeiculo.values());
                req.setAttribute("statusLista", StatusVeiculo.values());
                req.getRequestDispatcher("/WEB-INF/views/veiculos/form.jsp").forward(req, resp);

            } else if ("excluir".equals(acao)) {
                bo.excluir(Long.parseLong(req.getParameter("id")));
                resp.sendRedirect(req.getContextPath() + "/veiculos?sucesso=" + URLEncoder.encode("Veículo excluído com sucesso.", StandardCharsets.UTF_8.name()));

            } else {
                String filtro = req.getParameter("filtro");
                int pagina = parsePagina(req.getParameter("pagina"));
                int total = bo.contarTotal(filtro);
                int totalPaginas = (int) Math.ceil((double) total / TAMANHO_PAGINA);

                req.setAttribute("veiculos",     bo.listar(filtro, pagina));
                req.setAttribute("filtro",       filtro);
                req.setAttribute("pagina",       pagina);
                req.setAttribute("totalPaginas", totalPaginas);
                req.getRequestDispatcher("/WEB-INF/views/veiculos/lista.jsp").forward(req, resp);
            }

        } catch (CadastroException e) {
            req.setAttribute("erro", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/veiculos/lista.jsp").forward(req, resp);
        } catch (Exception e) {
            req.getSession().setAttribute("erroInesperado", "Ocorreu um erro inesperado.");
            resp.sendRedirect(req.getContextPath() + "/erro");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Veiculo v = montarVeiculo(req);

        try {
            if (v.getId() == null) {
                bo.cadastrar(v);
                resp.sendRedirect(req.getContextPath() + "/veiculos?sucesso=" + URLEncoder.encode("Veículo cadastrado com sucesso.", StandardCharsets.UTF_8.name()));
            } else {
                bo.atualizar(v);
                resp.sendRedirect(req.getContextPath() + "/veiculos?sucesso=" + URLEncoder.encode("Veículo atualizado com sucesso.", StandardCharsets.UTF_8.name()));
            }
        } catch (CadastroException e) {
            req.setAttribute("erro", e.getMessage());
            req.setAttribute("veiculo",     v);
            req.setAttribute("tipos",       TipoVeiculo.values());
            req.setAttribute("statusLista", StatusVeiculo.values());
            req.getRequestDispatcher("/WEB-INF/views/veiculos/form.jsp").forward(req, resp);
        } catch (Exception e) {
            req.getSession().setAttribute("erroInesperado", "Ocorreu um erro inesperado.");
            resp.sendRedirect(req.getContextPath() + "/erro");
        }
    }

    private Veiculo montarVeiculo(HttpServletRequest req) {
        Veiculo v = new Veiculo();
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) v.setId(Long.parseLong(idStr));

        v.setPlaca(req.getParameter("placa"));
        v.setRntrc(req.getParameter("rntrc"));

        String ano = req.getParameter("anoFabricacao");
        if (ano != null && !ano.isEmpty()) v.setAnoFabricacao(Integer.parseInt(ano));

        String tipo = req.getParameter("tipo");
        if (tipo != null && !tipo.isEmpty()) v.setTipo(TipoVeiculo.valueOf(tipo));

        String tara = req.getParameter("taraKg");
        if (tara != null && !tara.isEmpty()) v.setTaraKg(Double.parseDouble(tara.replace(",", ".")));

        String cap = req.getParameter("capacidadeKg");
        if (cap != null && !cap.isEmpty()) v.setCapacidadeKg(Double.parseDouble(cap.replace(",", ".")));

        String vol = req.getParameter("volumeM3");
        if (vol != null && !vol.isEmpty()) v.setVolumeM3(Double.parseDouble(vol.replace(",", ".")));

        String status = req.getParameter("status");
        if (status != null && !status.isEmpty()) v.setStatus(StatusVeiculo.valueOf(status));
        else v.setStatus(StatusVeiculo.DISPONIVEL);

        return v;
    }

    private int parsePagina(String param) {
        try { return Math.max(1, Integer.parseInt(param)); }
        catch (Exception e) { return 1; }
    }
}
