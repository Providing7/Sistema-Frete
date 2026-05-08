<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,br.com.gestaofretes.veiculo.Veiculo" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Ve&iacute;culos &mdash; Gestão de Fretes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">
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
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/veiculos?acao=novo">
          <i class="bi bi-plus-lg"></i> Novo Ve&iacute;culo
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
          <span class="table-toolbar-title">Frota de Ve&iacute;culos</span>
          <form method="get" action="${pageContext.request.contextPath}/veiculos" style="display:flex;gap:8px;align-items:center;">
            <div class="search-box">
              <i class="bi bi-search search-icon"></i>
              <input type="text" name="filtro" placeholder="Buscar por placa ou RNTRC..." value="${filtro}" />
            </div>
            <button class="btn btn-secondary" type="submit">Buscar</button>
            <% if (request.getAttribute("filtro") != null && !((String)request.getAttribute("filtro")).isEmpty()) { %>
              <a class="btn btn-secondary" href="${pageContext.request.contextPath}/veiculos">
                <i class="bi bi-x-lg"></i> Limpar
              </a>
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
                <td><span class="td-mono" style="font-weight:700;"><%= v.getPlaca() != null ? v.getPlaca() : "" %></span></td>
                <td><span class="td-mono"><%= v.getRntrc() != null ? v.getRntrc() : "&mdash;" %></span></td>
                <td><%= v.getTipo() != null ? v.getTipo().name() : "&mdash;" %></td>
                <td><%= v.getAnoFabricacao() %></td>
                <td>
                  <strong><%= v.getCapacidadeKg() %></strong>
                  <span class="text-muted"> kg</span>
                </td>
                <td>
                  <strong><%= v.getVolumeM3() %></strong>
                  <span class="text-muted"> m&sup3;</span>
                </td>
                <td><span class="badge badge-<%= v.getStatus().name().toLowerCase() %>"><%= v.getStatus().name() %></span></td>
                <td>
                  <div class="td-actions">
                    <a class="btn btn-secondary btn-sm"
                       href="${pageContext.request.contextPath}/veiculos?acao=editar&id=<%= v.getId() %>">
                      <i class="bi bi-pencil"></i> Editar
                    </a>
                    <a class="btn btn-danger btn-sm"
                       href="${pageContext.request.contextPath}/veiculos?acao=excluir&id=<%= v.getId() %>"
                       onclick="return confirm('Confirma a exclus\u00e3o deste ve\u00edculo?')">
                      <i class="bi bi-trash"></i>
                    </a>
                  </div>
                </td>
              </tr>
              <%   }
                } else { %>
              <tr>
                <td colspan="8">
                  <div class="empty-state">
                    <i class="bi bi-truck"></i>
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