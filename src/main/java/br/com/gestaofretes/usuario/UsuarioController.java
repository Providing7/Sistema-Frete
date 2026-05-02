package br.com.gestaofretes.usuario;

import br.com.gestaofretes.exception.CadastroException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/usuarios")
public class UsuarioController extends HttpServlet {

    private final UsuarioBO usuarioBO = new UsuarioBO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String acao = req.getParameter("acao");

        if ("novo".equals(acao)) {
            req.getRequestDispatcher("/WEB-INF/views/usuarios/form.jsp").forward(req, resp);
        } else {
            // Redireciona para o login por padrão se nenhuma ação válida for fornecida
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String acao = req.getParameter("acao");

        if ("cadastrar".equals(acao)) {
            Usuario usuario = new Usuario();
            usuario.setNomeCompleto(req.getParameter("nomeCompleto"));
            usuario.setEmail(req.getParameter("email"));
            usuario.setSenha(req.getParameter("senha"));

            try {
                usuarioBO.cadastrar(usuario);
                String mensagem = URLEncoder.encode("Conta criada com sucesso! Faça seu login.", StandardCharsets.UTF_8.name());
                resp.sendRedirect(req.getContextPath() + "/login?sucesso=" + mensagem);
            } catch (CadastroException e) {
                req.setAttribute("erro", e.getMessage());
                req.setAttribute("nomeCompleto", req.getParameter("nomeCompleto"));
                req.setAttribute("email", req.getParameter("email"));
                req.getRequestDispatcher("/WEB-INF/views/usuarios/form.jsp").forward(req, resp);
            } catch (Exception e) {
                System.err.println("[UsuarioController] Erro inesperado no cadastro: " + e.getMessage());
                req.setAttribute("erro", "Ocorreu um erro inesperado. Tente novamente.");
                req.getRequestDispatcher("/WEB-INF/views/usuarios/form.jsp").forward(req, resp);
            }
        }
    }
}
