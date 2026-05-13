<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, br.com.gestaofretes.motorista.Motorista" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Romaneio de Carga &mdash; FretesTMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />
  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">Romaneio de Carga</span>
        <span class="topbar-breadcrumb">Relatórios &rsaquo; Romaneio</span>
      </div>
    </header>
    <main class="page-body">

      <% if (request.getAttribute("erro") != null) { %>
      <div class="alert alert-error">
        <i class="bi bi-exclamation-triangle-fill"></i>
        <%= request.getAttribute("erro") %>
      </div>
      <% } %>

      <div class="form-card" style="max-width:520px;">
        <div class="form-section">
          <div class="form-section-title">Filtrar Romaneio</div>
          <form method="get"
                action="${pageContext.request.contextPath}/relatorios/romaneio"
                target="_blank">
            <div class="form-grid">

              <div class="form-group full">
                <label for="idMotorista">Motorista</label>
                <select id="idMotorista" name="idMotorista" required>
                  <option value="">Selecione...</option>
                  <%
                    List<Motorista> motoristas =
                        (List<Motorista>) request.getAttribute("motoristas");
                    if (motoristas != null) {
                      for (Motorista m : motoristas) {
                  %>
                  <option value="<%= m.getId() %>"><%= m.getNome() %></option>
                  <%  }
                    } %>
                </select>
              </div>

              <div class="form-group">
                <label for="dataInicio">De</label>
                <input type="date" id="dataInicio" name="dataInicio" required />
              </div>

              <div class="form-group">
                <label for="dataFim">Até</label>
                <input type="date" id="dataFim" name="dataFim" required
                       value="<%= java.time.LocalDate.now() %>" />
              </div>

            </div>
            <div class="form-actions" style="margin-top:16px;">
              <button class="btn btn-primary" type="submit">
                <i class="bi bi-printer"></i> Gerar PDF
              </button>
            </div>
          </form>
        </div>
      </div>

    </main>
  </div>
</div>
</body>
</html>