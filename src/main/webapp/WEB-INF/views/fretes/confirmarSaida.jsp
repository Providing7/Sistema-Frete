<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="br.com.gestaofretes.frete.Frete" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Confirmar Sa&iacute;da &mdash; Gestão de Fretes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />
  <div class="app-main">
    <% Frete frete = (Frete) request.getAttribute("frete"); %>
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">Confirmar Sa&iacute;da</span>
        <span class="topbar-breadcrumb">Fretes &rsaquo; <%= frete != null ? frete.getNumero() : "" %> &rsaquo; Confirmar Sa&iacute;da</span>
      </div>
      <div class="topbar-right">
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/fretes?acao=detalhe&id=<%= frete != null ? frete.getId() : "" %>">&larr; Voltar</a>
      </div>
    </header>
    <main class="page-body">
      <% if (request.getAttribute("erro") != null) { %>
        <div class="alert alert-error">&#9888; ${erro}</div>
      <% } %>
      <form method="post" action="${pageContext.request.contextPath}/fretes">
        <input type="hidden" name="acao" value="confirmarSaida"/>
        <input type="hidden" name="id" value="<%= frete != null ? frete.getId() : "" %>"/>
        <div class="form-card">
          <div class="form-section">
            <div class="form-section-title">Dados de Sa&iacute;da</div>
            <div class="form-grid">
              <div class="form-group">
                <label>Data e Hora de Sa&iacute;da *</label>
                <input type="datetime-local" name="dataSaida" required />
              </div>
            </div>
          </div>
        </div>
        <div style="display:flex;gap:12px;margin-top:8px;">
          <button type="submit" class="btn btn-primary">&#9654; Confirmar Sa&iacute;da</button>
          <a href="${pageContext.request.contextPath}/fretes?acao=detalhe&id=<%= frete != null ? frete.getId() : "" %>" class="btn btn-secondary">Cancelar</a>
        </div>
      </form>
    </main>
  </div>
</div>
</body>
</html>
