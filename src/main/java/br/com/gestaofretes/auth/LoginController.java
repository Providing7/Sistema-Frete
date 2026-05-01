package br.com.gestaofretes.auth;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Se já está logado, vai direto pro dashboard
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
        String usuario = req.getParameter("usuario");
        String senha   = req.getParameter("senha");

        // Credenciais fixas por enquanto (Semana 1)
        if ("admin".equals(usuario) && "1234".equals(senha)) {
            req.getSession().setAttribute("usuarioLogado", usuario);
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } else {
            req.setAttribute("erro", "Usuário ou senha inválidos.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }
}
