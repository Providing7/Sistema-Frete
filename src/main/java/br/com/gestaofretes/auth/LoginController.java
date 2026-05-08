package br.com.gestaofretes.auth;

import br.com.gestaofretes.usuario.UsuarioDAO;
import br.com.gestaofretes.util.BCryptUtil;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("usuarioLogado") != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String login = req.getParameter("email"); // campo email no formulário
        String senha  = req.getParameter("senha");

        try {
            String senhaHash = usuarioDAO.buscarSenhaHash(login);
            if (senhaHash != null && BCryptUtil.verificar(senha, senhaHash)) {
                req.getSession().setAttribute("usuarioLogado", login);
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            } else {
                req.setAttribute("erro", "Usuário ou senha inválidos.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            System.err.println("[LoginController] Erro inesperado no login: " + e.getMessage());
            req.setAttribute("erro", "Erro interno. Tente novamente.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }
}
