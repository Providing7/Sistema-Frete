<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="br.com.gestaofretes.model.Frete" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Registrar Entrega &mdash; Gestão de Fretes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />
  <div class="app-main">
    <% Frete frete = (Frete) request.getAttribute("frete"); %>
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">Registrar Entrega</span>
        <span class="topbar-breadcrumb">Fretes &rsaquo; <%= frete != null ? frete.getNumero() : "" %> &rsaquo; Entrega</span>
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
        <input type="hidden" name="acao" value="registrarEntrega"/>
        <input type="hidden" name="id" value="<%= frete != null ? frete.getId() : "" %>"/>
        <div class="form-card">
          <div class="form-section">
            <div class="form-section-title">Dados da Entrega</div>
            <div class="form-grid">
              <div class="form-group">
                <label>Data e Hora da Entrega *</label>
                <input type="datetime-local" name="dataEntrega" required />
              </div>
              <div class="form-group">
                <label>Nome do Recebedor *</label>
                <input type="text" name="nomeRecebedor" required placeholder="Nome completo de quem recebeu" />
              </div>
              <div class="form-group">
                <label>Documento do Recebedor (CPF/RG) *</label>
                <input type="text" name="documentoRecebedor" required placeholder="Ex: 123.456.789-00" />
              </div>
              <div class="form-group">
                <label>Munic&iacute;pio da Entrega</label>
                <input type="text" name="municipio" placeholder="Município onde foi entregue" />
              </div>
              <div class="form-group">
                <label>UF</label>
                <input type="text" name="uf" maxlength="2" placeholder="SP" />
              </div>
            </div>
          </div>
        </div>
        <div style="display:flex;gap:12px;margin-top:8px;">
          <button type="submit" class="btn btn-primary" style="background:var(--success);">&#10004; Confirmar Entrega</button>
          <a href="${pageContext.request.contextPath}/fretes?acao=detalhe&id=<%= frete != null ? frete.getId() : "" %>" class="btn btn-secondary">Cancelar</a>
        </div>
      </form>
    </main>
  </div>
</div>
</body>
</html>
