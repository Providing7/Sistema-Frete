<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, br.com.gestaofretes.model.Motorista" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Motoristas &mdash; Gestão de Fretes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />

  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">Motoristas</span>
        <span class="topbar-breadcrumb">Cadastro &rsaquo; Motoristas</span>
      </div>
      <div class="topbar-right">
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/motoristas?acao=novo">&#43; Novo Motorista</a>
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
          <span style="font-size:13px;font-weight:600;color:var(--gray-700);">Lista de Motoristas</span>
          <form method="get" action="${pageContext.request.contextPath}/motoristas" style="display:flex;gap:8px;align-items:center;">
            <div class="search-box">
              <span class="search-icon">&#128269;</span>
              <input type="text" name="filtro" placeholder="Buscar por nome..." value="${filtro}" />
            </div>
            <button class="btn btn-secondary" type="submit">Buscar</button>
            <% if (request.getAttribute("filtro") != null && !((String)request.getAttribute("filtro")).isEmpty()) { %>
              <a class="btn btn-secondary" href="${pageContext.request.contextPath}/motoristas">&#10005; Limpar</a>
            <% } %>
          </form>
        </div>

        <div class="table-responsive">
          <table>
            <thead>
              <tr>
                <th>Nome</th>
                <th>CPF</th>
                <th>CNH / Categoria</th>
                <th>Validade CNH</th>
                <th>V&iacute;nculo</th>
                <th>Status</th>
                <th>A&ccedil;&otilde;es</th>
              </tr>
            </thead>
            <tbody>
              <%
                List<Motorista> motoristas = (List<Motorista>) request.getAttribute("motoristas");
                if (motoristas != null && !motoristas.isEmpty()) {
                  for (Motorista m : motoristas) {
                    String ini = m.getNome() != null && m.getNome().length() > 0
                      ? String.valueOf(m.getNome().charAt(0)).toUpperCase() : "M";
              %>
              <tr>
                <td>
                  <div class="cell-with-avatar">
                    <div class="cell-avatar"><%= ini %></div>
                    <div>
                      <div class="cell-label"><%= m.getNome() %></div>
                      <div class="cell-sub"><%= m.getTelefone() != null ? m.getTelefone() : "" %></div>
                    </div>
                  </div>
                </td>
                <td><span class="td-mono"><%= m.getCpf() != null ? m.getCpf() : "" %></span></td>
                <td>
                  <span class="td-mono"><%= m.getCnhNumero() != null ? m.getCnhNumero() : "" %></span>
                  <% if (m.getCnhCategoria() != null) { %>
                    <span class="badge badge-info" style="margin-left:4px;background:var(--info-bg);color:var(--info-dark)"><%= m.getCnhCategoria().name() %></span>
                  <% } %>
                </td>
                <td style="font-size:13px;"><%= m.getCnhValidade() != null ? m.getCnhValidade().toString() : "" %></td>
                <td><%= m.getTipoVinculo() != null ? m.getTipoVinculo().name() : "" %></td>
                <td><span class="badge badge-<%= m.getStatus().name().toLowerCase() %>"><%= m.getStatus().name() %></span></td>
                <td>
                  <div class="td-actions">
                    <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/motoristas?acao=editar&id=<%= m.getId() %>">&#9999; Editar</a>
                    <a class="btn btn-danger btn-sm" href="${pageContext.request.contextPath}/motoristas?acao=excluir&id=<%= m.getId() %>"
                       onclick="return confirm('Confirma a exclus&atilde;o?')">Excluir</a>
                  </div>
                </td>
              </tr>
              <%   }
                } else { %>
              <tr>
                <td colspan="7">
                  <div class="empty-state">
                    <div class="empty-state-icon">&#128100;</div>
                    <p>Nenhum motorista encontrado.</p>
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