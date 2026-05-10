<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Faturamento por Período &mdash; FretesTMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />
  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">Faturamento por Período</span>
        <span class="topbar-breadcrumb">Relatórios &rsaquo; Faturamento</span>
      </div>
    </header>
    <main class="page-body">

      <% if (request.getAttribute("erro") != null) { %>
      <div class="alert alert-danger">
        <i class="bi bi-exclamation-triangle-fill"></i>
        <%= request.getAttribute("erro") %>
      </div>
      <% } %>

      <div class="form-card" style="max-width:480px;">
        <div class="form-section">
          <div class="form-section-title">Selecione o Período</div>
          <form method="get"
                action="${pageContext.request.contextPath}/relatorios/faturamento"
                target="_blank">
            <div class="form-grid">

              <div class="form-group">
                <label for="dataInicio">Data Inicial</label>
                <input type="date" id="dataInicio" name="dataInicio" required />
              </div>

              <div class="form-group">
                <label for="dataFim">Data Final</label>
                <input type="date" id="dataFim" name="dataFim" required />
              </div>

            </div>
            <div class="form-actions" style="margin-top:16px;">
              <button class="btn btn-primary" type="submit">
                <i class="bi bi-printer"></i> Gerar PDF
              </button>
              <a href="${pageContext.request.contextPath}/dashboard"
                 class="btn btn-secondary">Voltar</a>
            </div>
          </form>
        </div>
      </div>

      <!-- Dica informativa -->
      <div class="alert alert-info" style="max-width:480px; margin-top:20px;">
        <i class="bi bi-info-circle"></i>
        O relatório lista todos os fretes <strong>não cancelados</strong>
        emitidos no período, com totais de peso transportado e valor faturado.
      </div>

    </main>
  </div>
</div>
</body>
</html>
