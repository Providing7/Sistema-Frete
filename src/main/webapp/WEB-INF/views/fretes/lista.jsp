<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,br.com.gestaofretes.frete.Frete,br.com.gestaofretes.frete.StatusFrete" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Fretes &mdash; FretesTMS</title>
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
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/fretes?acao=novo">
          <i class="bi bi-plus-lg"></i> Novo Frete
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
          <span class="table-toolbar-title">Controle de Fretes</span>
          <form method="get" action="${pageContext.request.contextPath}/fretes" style="display:flex;gap:8px;align-items:center;">
            <div class="search-box">
              <i class="bi bi-search search-icon"></i>
              <input type="text" name="filtro" placeholder="N&uacute;mero, remetente ou destinat&aacute;rio..." value="${filtro}" />
            </div>
            <button class="btn btn-secondary" type="submit">Buscar</button>
            <% if (request.getAttribute("filtro") != null && !((String)request.getAttribute("filtro")).isEmpty()) { %>
              <a class="btn btn-secondary" href="${pageContext.request.contextPath}/fretes">
                <i class="bi bi-x-lg"></i> Limpar
              </a>
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
                    String labelStatus;
                    switch (f.getStatus()) {
                      case EMITIDO:          badgeClass = "badge-emitido";          labelStatus = "Emitido";           break;
                      case SAIDA_CONFIRMADA: badgeClass = "badge-saida_confirmada"; labelStatus = "Sa&iacute;da Conf."; break;
                      case EM_TRANSITO:      badgeClass = "badge-em_transito";      labelStatus = "Em Tr&acirc;nsito"; break;
                      case ENTREGUE:         badgeClass = "badge-entregue";         labelStatus = "Entregue";          break;
                      case NAO_ENTREGUE:     badgeClass = "badge-nao_entregue";     labelStatus = "N&atilde;o Entregue"; break;
                      case CANCELADO:        badgeClass = "badge-cancelado";        labelStatus = "Cancelado";         break;
                      default:               badgeClass = "badge-cancelado";        labelStatus = f.getStatus().name();
                    }
              %>
              <tr>
                <td><span class="td-mono"><%= f.getNumero() %></span></td>
                <td>
                  <div class="cell-label"><%= f.getRemetente() != null ? f.getRemetente().getRazaoSocial() : "&mdash;" %></div>
                </td>
                <td>
                  <div class="cell-label"><%= f.getDestinatario() != null ? f.getDestinatario().getRazaoSocial() : "&mdash;" %></div>
                </td>
                <td>
                  <span style="font-size:13px;">
                    <%= f.getMunicipioDestino() != null ? f.getMunicipioDestino() : "" %>
                    <%= f.getUfDestino() != null ? " &mdash; " + f.getUfDestino() : "" %>
                  </span>
                </td>
                <td><%= f.getDataPrevisaoEntrega() != null ? f.getDataPrevisaoEntrega().toString() : "&mdash;" %></td>
                <td><span class="badge <%= badgeClass %>"><%= labelStatus %></span></td>
                <td>
                  <div class="td-actions">
                    <a class="btn btn-secondary btn-sm"
                       href="${pageContext.request.contextPath}/fretes?acao=detalhe&id=<%= f.getId() %>">
                      <i class="bi bi-eye"></i> Detalhe
                    </a>
                    <a class="btn btn-danger btn-sm"
                       href="${pageContext.request.contextPath}/fretes?acao=excluir&id=<%= f.getId() %>"
                       onclick="return confirm('Deseja realmente excluir este frete?')">
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
                    <i class="bi bi-file-earmark-text"></i>
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
