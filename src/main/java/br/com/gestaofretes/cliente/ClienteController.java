package br.com.gestaofretes.cliente;

import br.com.gestaofretes.exception.CadastroException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/clientes")
public class ClienteController extends HttpServlet {

    private final ClienteBO bo = new ClienteBO();
    private static final int TAMANHO_PAGINA = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String acao = req.getParameter("acao");

        try {
            if ("novo".equals(acao)) {
                // ← sem tiposCliente
                req.getRequestDispatcher("/WEB-INF/views/clientes/form.jsp").forward(req, resp);

            } else if ("editar".equals(acao)) {
                Long id = Long.parseLong(req.getParameter("id"));
                req.setAttribute("cliente", bo.buscarPorId(id));
                // ← sem tiposCliente
                req.getRequestDispatcher("/WEB-INF/views/clientes/form.jsp").forward(req, resp);

            } else if ("excluir".equals(acao)) {
                Long id = Long.parseLong(req.getParameter("id"));
                bo.excluir(id);
                resp.sendRedirect(req.getContextPath() + "/clientes?sucesso=Cliente+excluído+com+sucesso.");

            } else {
                String filtro = req.getParameter("filtro");
                int pagina = parsePagina(req.getParameter("pagina"));
                int total = bo.contarTotal(filtro);
                int totalPaginas = (int) Math.ceil((double) total / TAMANHO_PAGINA);

                req.setAttribute("clientes", bo.listar(filtro, pagina));
                req.setAttribute("filtro", filtro);
                req.setAttribute("pagina", pagina);
                req.setAttribute("totalPaginas", totalPaginas);
                req.getRequestDispatcher("/WEB-INF/views/clientes/lista.jsp").forward(req, resp);
            }

        } catch (CadastroException e) {
            req.setAttribute("erro", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/clientes/lista.jsp").forward(req, resp);
        } catch (Exception e) {
            req.getSession().setAttribute("erroInesperado", "Ocorreu um erro inesperado. Tente novamente.");
            resp.sendRedirect(req.getContextPath() + "/erro");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Cliente cliente = montarCliente(req);

        try {
            if (cliente.getId() == null) {
                bo.cadastrar(cliente);
                resp.sendRedirect(req.getContextPath() + "/clientes?sucesso=Cliente+cadastrado+com+sucesso.");
            } else {
                bo.atualizar(cliente);
                resp.sendRedirect(req.getContextPath() + "/clientes?sucesso=Cliente+atualizado+com+sucesso.");
            }
        } catch (CadastroException e) {
            req.setAttribute("erro", e.getMessage());
            req.setAttribute("cliente", cliente);
            // ← sem tiposCliente
            req.getRequestDispatcher("/WEB-INF/views/clientes/form.jsp").forward(req, resp);
        } catch (Exception e) {
            req.getSession().setAttribute("erroInesperado", "Ocorreu um erro inesperado. Tente novamente.");
            resp.sendRedirect(req.getContextPath() + "/erro");
        }
    }

    private Cliente montarCliente(HttpServletRequest req) {
        Cliente c = new Cliente();
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) c.setId(Long.parseLong(idStr));

        c.setRazaoSocial(req.getParameter("razaoSocial"));
        c.setNomeFantasia(req.getParameter("nomeFantasia"));
        c.setCnpj(req.getParameter("cnpj"));
        c.setInscricaoEstadual(req.getParameter("inscricaoEstadual"));
        // ← tipo REMOVIDO
        c.setLogradouro(req.getParameter("logradouro"));
        c.setNumero(req.getParameter("numero"));
        c.setComplemento(req.getParameter("complemento"));
        c.setBairro(req.getParameter("bairro"));
        c.setMunicipio(req.getParameter("municipio"));
        c.setUf(req.getParameter("uf"));
        c.setCep(req.getParameter("cep"));
        c.setTelefone(req.getParameter("telefone"));
        c.setEmail(req.getParameter("email"));
        c.setAtivo("true".equals(req.getParameter("ativo")));
        return c;
    }

    private int parsePagina(String param) {
        try { return Math.max(1, Integer.parseInt(param)); }
        catch (Exception e) { return 1; }
    }
}
