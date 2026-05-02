<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,br.com.gestaofretes.cliente.Cliente" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Clientes &mdash; Gestão de Fretes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />

  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">Clientes</span>
        <span class="topbar-breadcrumb">Cadastro &rsaquo; Clientes</span>
      </div>
      <div class="topbar-right">
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/clientes?acao=novo">&#43; Novo Cliente</a>
      </div>
    </header>

    <main class="page-body">

      <% if (request.getAttribute("erro") != null) { %>
        <div class="alert alert-error">&#9888; ${erro}</div>
      <% } %>
      <% if (request.getParameter("sucesso") != null) { %>
        <div class="alert alert-success">&#9989; ${param.sucesso}</div>
      <% } %>

      <div class="card">
        <div class="table-toolbar">
          <span style="font-size:13px;font-weight:600;color:var(--gray-700);">Lista de Clientes</span>
          <form method="get" action="${pageContext.request.contextPath}/clientes" style="display:flex;gap:8px;align-items:center;">
            <div class="search-box">
              <span class="search-icon">&#128269;</span>
              <input type="text" name="filtro" placeholder="Buscar por raz&atilde;o social..." value="${filtro}" />
            </div>
            <button class="btn btn-secondary" type="submit">Buscar</button>
            <% if (request.getAttribute("filtro") != null && !((String)request.getAttribute("filtro")).isEmpty()) { %>
              <a class="btn btn-secondary" href="${pageContext.request.contextPath}/clientes">&#10005; Limpar</a>
            <% } %>
          </form>
        </div>

        <div class="table-responsive">
          <table>
            <thead>
              <tr>
                <th>Raz&atilde;o Social</th>
                <th>CNPJ</th>
                <th>Munic&iacute;pio / UF</th>
                <th>Contato</th>
                <th>Status</th>
                <th>A&ccedil;&otilde;es</th>
              </tr>
            </thead>
            <tbody>
              <%
                List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
                if (clientes != null && !clientes.isEmpty()) {
                  for (Cliente c : clientes) {
                    String initials = c.getRazaoSocial() != null && c.getRazaoSocial().length() > 0
                      ? String.valueOf(c.getRazaoSocial().charAt(0)).toUpperCase() : "C";
              %>
              <tr>
                <td>
                  <div class="cell-with-avatar">
                    <div class="cell-avatar"><%= initials %></div>
                    <div>
                      <div class="cell-label"><%= c.getRazaoSocial() %></div>
                      <div class="cell-sub"><%= c.getNomeFantasia() != null ? c.getNomeFantasia() : "" %></div>
                    </div>
                  </div>
                </td>
                <td><span class="td-mono"><%= c.getCnpj() != null ? c.getCnpj() : "" %></span></td>
                <td><%= c.getMunicipio() != null ? c.getMunicipio() : "" %><%= c.getUf() != null ? " / " + c.getUf() : "" %></td>
                <td style="font-size:12px;color:var(--gray-500);"><%= c.getEmail() != null ? c.getEmail() : "" %></td>
                <td>
                  <% if (c.isAtivo()) { %>
                    <span class="badge badge-ativo">Ativo</span>
                  <% } else { %>
                    <span class="badge badge-inativo">Inativo</span>
                  <% } %>
                </td>
                <td>
                  <div class="td-actions">
                    <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/clientes?acao=editar&id=<%= c.getId() %>">&#9999; Editar</a>
                    <a class="btn btn-danger btn-sm" href="${pageContext.request.contextPath}/clientes?acao=excluir&id=<%= c.getId() %>"
                       onclick="return confirm('Deseja excluir?')">Excluir</a>
                  </div>
                </td>
              </tr>
              <%   }
                } else { %>
              <tr>
                <td colspan="6">
                  <div class="empty-state">
                    <div class="empty-state-icon">&#127970;</div>
                    <p>Nenhum cliente encontrado.</p>
                  </div>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>

        <%
          Integer pagina       = (Integer) request.getAttribute("pagina");
          Integer totalPaginas = (Integer) request.getAttribute("totalPaginas");
          if (pagina != null && totalPaginas != null && totalPaginas > 1) {
        %>
        <div class="pagination-bar">
          <span>P&aacute;gina <%= pagina %> de <%= totalPaginas %></span>
          <div class="pagination-controls">
            <% if (pagina > 1) { %>
              <a class="btn btn-secondary btn-sm" href="?pagina=<%= pagina-1 %>&filtro=${filtro}">&larr; Anterior</a>
            <% } %>
            <% if (pagina < totalPaginas) { %>
              <a class="btn btn-secondary btn-sm" href="?pagina=<%= pagina+1 %>&filtro=${filtro}">Pr&oacute;xima &rarr;</a>
            <% } %>
          </div>
        </div>
        <% } %>
      </div>
    </main>
  </div>
</div>
</body>
</html>