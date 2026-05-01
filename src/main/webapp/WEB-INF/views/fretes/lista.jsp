<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,br.com.gestaofretes.frete.Frete,br.com.gestaofretes.frete.StatusFrete" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Fretes &mdash; Gestão de Fretes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />

  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">Fretes</span>
        <span class="topbar-breadcrumb">Operacional &rsaquo; Fretes</span>
      </div>
      <div class="topbar-right">
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/fretes?acao=novo">&#43; Novo Frete</a>
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
          <span style="font-size:13px;font-weight:600;color:var(--gray-700);">Lista de Fretes</span>
          <form method="get" action="${pageContext.request.contextPath}/fretes" style="display:flex;gap:8px;align-items:center;">
            <div class="search-box">
              <span class="search-icon">&#128269;</span>
              <input type="text" name="filtro" placeholder="Buscar por número ou cliente..." value="${filtro}" />
            </div>
            <button class="btn btn-secondary" type="submit">Buscar</button>
            <% if (request.getAttribute("filtro") != null && !((String)request.getAttribute("filtro")).isEmpty()) { %>
              <a class="btn btn-secondary" href="${pageContext.request.contextPath}/fretes">&#10005; Limpar</a>
            <% } %>
          </form>
        </div>

        <div class="table-responsive">
          <table>
            <thead>
              <tr>
                <th>N&uacute;mero</th>
                <th>Remetente</th>
                <th>Destinat&aacute;rio</th>
                <th>Destino</th>
                <th>Previs&atilde;o</th>
                <th>Status</th>
                <th>A&ccedil;&otilde;es</th>
              </tr>
            </thead>
            <tbody>
              <%
                List<Frete> fretes = (List<Frete>) request.getAttribute("fretes");
                if (fretes != null && !fretes.isEmpty()) {
                  for (Frete f : fretes) {
                    String badgeClass;
                    switch (f.getStatus()) {
                      case EMITIDO:           badgeClass = "badge-warning"; break;
                      case SAIDA_CONFIRMADA:  badgeClass = "badge-info";    break;
                      case EM_TRANSITO:       badgeClass = "badge-primary"; break;
                      case ENTREGUE:          badgeClass = "badge-ativo";   break;
                      case NAO_ENTREGUE:      badgeClass = "badge-danger";  break;
                      case CANCELADO:         badgeClass = "badge-inativo"; break;
                      default:                badgeClass = "badge-inativo";
                    }
                    String labelStatus = f.getStatus().name().replace("_", " ");
              %>
              <tr>
                <td><span class="td-mono"><%= f.getNumero() %></span></td>
                <td><%= f.getRemetente() != null ? f.getRemetente().getRazaoSocial() : "" %></td>
                <td><%= f.getDestinatario() != null ? f.getDestinatario().getRazaoSocial() : "" %></td>
                <td><%= f.getMunicipioDestino() != null ? f.getMunicipioDestino() : "" %>/<%= f.getUfDestino() != null ? f.getUfDestino() : "" %></td>
                <td><%= f.getDataPrevisaoEntrega() != null ? f.getDataPrevisaoEntrega().toString() : "" %></td>
                <td><span class="badge <%= badgeClass %>"><%= labelStatus %></span></td>
                <td>
                  <div class="td-actions">
                    <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/fretes?acao=detalhe&id=<%= f.getId() %>">&#128269; Detalhe</a>
                  </div>
                </td>
              </tr>
              <%   }
                } else { %>
              <tr>
                <td colspan="7">
                  <div class="empty-state">
                    <div class="empty-state-icon">&#128666;</div>
                    <p>Nenhum frete encontrado.</p>
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
