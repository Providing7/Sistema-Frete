<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,br.com.gestaofretes.motorista.Motorista" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Motoristas &mdash; FretesTMS</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />

  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">Motoristas</span>
        <span class="topbar-breadcrumb">Cadastros &rsaquo; Motoristas</span>
      </div>
      <div class="topbar-right">
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/motoristas?acao=novo">
          <i class="bi bi-plus-lg"></i> Novo Motorista
        </a>
      </div>
    </header>

    <main class="page-body">

      <% if (request.getAttribute("erro") != null) { %>
        <div class="alert alert-error"><i class="bi bi-exclamation-circle-fill"></i> ${erro}</div>
      <% } %>
      <% if (request.getParameter("sucesso") != null) { %>
        <div class="alert alert-success"><i class="bi bi-check-circle-fill"></i> ${param.sucesso}</div>
      <% } %>

      <div class="card">
        <div class="table-toolbar">
          <span class="table-toolbar-title">Quadro de Motoristas</span>
          <form method="get" action="${pageContext.request.contextPath}/motoristas" style="display:flex;gap:8px;align-items:center;">
            <div class="search-box">
              <i class="bi bi-search search-icon"></i>
              <input type="text" name="filtro" placeholder="Buscar por nome ou CPF..." value="${filtro}" />
            </div>
            <button class="btn btn-secondary" type="submit">Buscar</button>
            <% if (request.getAttribute("filtro") != null && !((String)request.getAttribute("filtro")).isEmpty()) { %>
              <a class="btn btn-secondary" href="${pageContext.request.contextPath}/motoristas">
                <i class="bi bi-x-lg"></i> Limpar
              </a>
            <% } %>
          </form>
        </div>

        <div class="table-responsive">
          <table>
            <thead>
              <tr>
                <th>Nome</th>
                <th>CPF</th>
                <th>CNH / Cat.</th>
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
                <td><span class="td-mono"><%= m.getCpf() != null ? m.getCpf() : "&mdash;" %></span></td>
                <td>
                  <span class="td-mono"><%= m.getCnhNumero() != null ? m.getCnhNumero() : "&mdash;" %></span>
                  <% if (m.getCnhCategoria() != null) { %>
                    <span class="badge badge-info" style="margin-left:5px;"><%= m.getCnhCategoria().name() %></span>
                  <% } %>
                </td>
                <td><%= m.getCnhValidade() != null ? m.getCnhValidade().toString() : "&mdash;" %></td>
                <td class="text-muted"><%= m.getTipoVinculo() != null ? m.getTipoVinculo().name() : "&mdash;" %></td>
                <td><span class="badge badge-<%= m.getStatus().name().toLowerCase() %>"><%= m.getStatus().name() %></span></td>
                <td>
                  <div class="td-actions">
                    <a class="btn btn-secondary btn-sm"
                       href="${pageContext.request.contextPath}/motoristas?acao=editar&id=<%= m.getId() %>">
                      <i class="bi bi-pencil"></i> Editar
                    </a>
                    <a class="btn btn-danger btn-sm"
                       href="${pageContext.request.contextPath}/motoristas?acao=excluir&id=<%= m.getId() %>"
                       onclick="return confirm('Confirma a exclus\u00e3o deste motorista?')">
                      <i class="bi bi-trash"></i>
                    </a>
                  </div>
                </td>
              </tr>
              <%   }
                } else { %>
              <tr>
                <td colspan="7">
                  <div class="empty-state">
                    <i class="bi bi-person-badge"></i>
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
          <span>P&aacute;gina <strong><%= pagina %></strong> de <strong><%= totalPaginas %></strong></span>
          <div class="pagination-controls">
            <% if (pagina > 1) { %>
              <a class="btn btn-secondary btn-sm" href="?pagina=<%= pagina-1 %>&filtro=${filtro}">
                <i class="bi bi-chevron-left"></i> Anterior
              </a>
            <% } %>
            <% if (pagina < totalPaginas) { %>
              <a class="btn btn-secondary btn-sm" href="?pagina=<%= pagina+1 %>&filtro=${filtro}">
                Pr&oacute;xima <i class="bi bi-chevron-right"></i>
              </a>
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