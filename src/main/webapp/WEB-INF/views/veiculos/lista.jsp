<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, br.com.gestaofretes.model.Veiculo" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Ve&iacute;culos &mdash; Gestão de Fretes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />

  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">Ve&iacute;culos</span>
        <span class="topbar-breadcrumb">Cadastro &rsaquo; Ve&iacute;culos</span>
      </div>
      <div class="topbar-right">
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/veiculos?acao=novo">&#43; Novo Ve&iacute;culo</a>
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
          <span style="font-size:13px;font-weight:600;color:var(--gray-700);">Frota de Ve&iacute;culos</span>
          <form method="get" action="${pageContext.request.contextPath}/veiculos" style="display:flex;gap:8px;align-items:center;">
            <div class="search-box">
              <span class="search-icon">&#128269;</span>
              <input type="text" name="filtro" placeholder="Buscar por placa..." value="${filtro}" />
            </div>
            <button class="btn btn-secondary" type="submit">Buscar</button>
            <% if (request.getAttribute("filtro") != null && !((String)request.getAttribute("filtro")).isEmpty()) { %>
              <a class="btn btn-secondary" href="${pageContext.request.contextPath}/veiculos">&#10005; Limpar</a>
            <% } %>
          </form>
        </div>

        <div class="table-responsive">
          <table>
            <thead>
              <tr>
                <th>Placa</th>
                <th>RNTRC</th>
                <th>Tipo</th>
                <th>Ano</th>
                <th>Cap. Carga</th>
                <th>Volume</th>
                <th>Status</th>
                <th>A&ccedil;&otilde;es</th>
              </tr>
            </thead>
            <tbody>
              <%
                List<Veiculo> veiculos = (List<Veiculo>) request.getAttribute("veiculos");
                if (veiculos != null && !veiculos.isEmpty()) {
                  for (Veiculo v : veiculos) {
              %>
              <tr>
                <td><span class="td-mono" style="font-weight:700;font-size:13px;"><%= v.getPlaca() != null ? v.getPlaca() : "" %></span></td>
                <td><span class="td-mono"><%= v.getRntrc() != null ? v.getRntrc() : "" %></span></td>
                <td><%= v.getTipo() != null ? v.getTipo().name() : "" %></td>
                <td><%= v.getAnoFabricacao() %></td>
                <td style="font-weight:500;"><%= v.getCapacidadeKg() %> <span style="color:var(--gray-400);font-size:11px;">kg</span></td>
                <td><%= v.getVolumeM3() %> <span style="color:var(--gray-400);font-size:11px;">m&sup3;</span></td>
                <td><span class="badge badge-<%= v.getStatus().name().toLowerCase() %>"><%= v.getStatus().name() %></span></td>
                <td>
                  <div class="td-actions">
                    <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/veiculos?acao=editar&id=<%= v.getId() %>">&#9999; Editar</a>
                    <a class="btn btn-danger btn-sm" href="${pageContext.request.contextPath}/veiculos?acao=excluir&id=<%= v.getId() %>"
                       onclick="return confirm('Confirma a exclus&atilde;o?')">Excluir</a>
                  </div>
                </td>
              </tr>
              <%   }
                } else { %>
              <tr>
                <td colspan="8">
                  <div class="empty-state">
                    <div class="empty-state-icon">&#128666;</div>
                    <p>Nenhum ve&iacute;culo encontrado.</p>
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