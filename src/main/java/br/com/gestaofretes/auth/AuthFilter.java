package br.com.gestaofretes.auth;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig config) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String uri = req.getRequestURI();

        // Recursos que NÃO precisam de login
        boolean isPublic = uri.contains("/login")
                        || uri.contains("/usuarios")
                        || uri.endsWith(".css")
                        || uri.endsWith(".js")
                        || uri.endsWith(".png")
                        || uri.endsWith(".ico");

        if (isPublic) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        boolean logado = (session != null && session.getAttribute("usuarioLogado") != null);

        if (logado) {
            chain.doFilter(request, response);
        } else {
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }

    @Override
    public void destroy() {}
}
