package br.com.gestaofretes.motorista;

import br.com.gestaofretes.exception.CadastroException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.nio.charset.StandardCharsets;

@WebServlet("/motoristas")
public class MotoristaController extends HttpServlet {

    private final MotoristaBO bo = new MotoristaBO();
    private static final int TAMANHO_PAGINA = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String acao = req.getParameter("acao");

        try {
            if ("novo".equals(acao)) {
                req.setAttribute("categorias",    CategoriaCNH.values());
                req.setAttribute("vinculos",      TipoVinculo.values());
                req.setAttribute("statusLista",   StatusMotorista.values());
                req.getRequestDispatcher("/WEB-INF/views/motoristas/form.jsp").forward(req, resp);

            } else if ("editar".equals(acao)) {
                Long id = Long.parseLong(req.getParameter("id"));
                req.setAttribute("motorista",   bo.buscarPorId(id));
                req.setAttribute("categorias",  CategoriaCNH.values());
                req.setAttribute("vinculos",    TipoVinculo.values());
                req.setAttribute("statusLista", StatusMotorista.values());
                req.getRequestDispatcher("/WEB-INF/views/motoristas/form.jsp").forward(req, resp);

            } else if ("excluir".equals(acao)) {
                bo.excluir(Long.parseLong(req.getParameter("id")));
                resp.sendRedirect(req.getContextPath() + "/motoristas?sucesso="
                        + URLEncoder.encode("Motorista excluído com sucesso.", StandardCharsets.UTF_8.name()));

            } else {
                String filtro = req.getParameter("filtro");
                int pagina = parsePagina(req.getParameter("pagina"));
                int total = bo.contarTotal(filtro);
                int totalPaginas = (int) Math.ceil((double) total / TAMANHO_PAGINA);

                req.setAttribute("motoristas",   bo.listar(filtro, pagina));
                req.setAttribute("filtro",       filtro);
                req.setAttribute("pagina",       pagina);
                req.setAttribute("totalPaginas", totalPaginas);
                req.getRequestDispatcher("/WEB-INF/views/motoristas/lista.jsp").forward(req, resp);
            }

        } catch (CadastroException e) {
            req.setAttribute("erro", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/motoristas/lista.jsp").forward(req, resp);
        } catch (Exception e) {
            req.getSession().setAttribute("erroInesperado", "Ocorreu um erro inesperado.");
            resp.sendRedirect(req.getContextPath() + "/erro");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Motorista m = montarMotorista(req);

        try {
            if (m.getId() == null) {
                bo.cadastrar(m);
                resp.sendRedirect(req.getContextPath() + "/motoristas?sucesso="
                        + URLEncoder.encode("Motorista cadastrado com sucesso.", StandardCharsets.UTF_8.name()));
            } else {
                bo.atualizar(m);
                resp.sendRedirect(req.getContextPath() + "/motoristas?sucesso="
                        + URLEncoder.encode("Motorista atualizado com sucesso.", StandardCharsets.UTF_8.name()));
            }
        } catch (CadastroException e) {
            req.setAttribute("erro", e.getMessage());
            req.setAttribute("motorista",   m);
            req.setAttribute("categorias",  CategoriaCNH.values());
            req.setAttribute("vinculos",    TipoVinculo.values());
            req.setAttribute("statusLista", StatusMotorista.values());
            req.getRequestDispatcher("/WEB-INF/views/motoristas/form.jsp").forward(req, resp);
        } catch (Exception e) {
            req.getSession().setAttribute("erroInesperado", "Ocorreu um erro inesperado.");
            resp.sendRedirect(req.getContextPath() + "/erro");
        }
    }

    private Motorista montarMotorista(HttpServletRequest req) {
        Motorista m = new Motorista();
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) m.setId(Long.parseLong(idStr));

        m.setNome(req.getParameter("nome"));
        m.setCpf(req.getParameter("cpf"));

        String dn = req.getParameter("dataNascimento");
        if (dn != null && !dn.isEmpty()) m.setDataNascimento(LocalDate.parse(dn));

        m.setTelefone(req.getParameter("telefone"));
        m.setCnhNumero(req.getParameter("cnhNumero"));

        String cat = req.getParameter("cnhCategoria");
        if (cat != null && !cat.isEmpty()) m.setCnhCategoria(CategoriaCNH.valueOf(cat));

        String val = req.getParameter("cnhValidade");
        if (val != null && !val.isEmpty()) m.setCnhValidade(LocalDate.parse(val));

        String vinculo = req.getParameter("tipoVinculo");
        if (vinculo != null && !vinculo.isEmpty()) m.setTipoVinculo(TipoVinculo.valueOf(vinculo));

        String status = req.getParameter("status");
        if (status != null && !status.isEmpty()) m.setStatus(StatusMotorista.valueOf(status));
        else m.setStatus(StatusMotorista.ATIVO);

        return m;
    }

    private int parsePagina(String param) {
        try { return Math.max(1, Integer.parseInt(param)); }
        catch (Exception e) { return 1; }
    }
}