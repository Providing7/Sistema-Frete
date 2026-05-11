<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="br.com.gestaofretes.motorista.Motorista, java.util.List, java.time.LocalDate" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard &mdash; FretesTMS</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />

  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">Dashboard</span>
        <span class="topbar-breadcrumb">Vis&atilde;o geral</span>
      </div>
      <div class="topbar-right">
        <span style="font-size:13px;color:var(--gray-500);">
          Ol&aacute;, <strong style="color:var(--gray-800);">${sessionScope.usuarioLogado}</strong>
        </span>
      </div>
    </header>

    <main class="page-body">

      <!-- KPIs -->
      <div class="stats-grid">

        <a class="stat-card" href="${pageContext.request.contextPath}/clientes">
          <div class="stat-icon blue"><i class="bi bi-building"></i></div>
          <div class="stat-info">
            <div class="stat-value">
              <%= request.getAttribute("totalClientes") != null ? request.getAttribute("totalClientes") : "&mdash;" %>
            </div>
            <div class="stat-label">Clientes cadastrados</div>
          </div>
        </a>

        <a class="stat-card" href="${pageContext.request.contextPath}/motoristas">
          <div class="stat-icon green"><i class="bi bi-person-badge"></i></div>
          <div class="stat-info">
            <div class="stat-value">
              <%= request.getAttribute("totalMotoristas") != null ? request.getAttribute("totalMotoristas") : "&mdash;" %>
            </div>
            <div class="stat-label">Motoristas ativos</div>
          </div>
        </a>

        <a class="stat-card" href="${pageContext.request.contextPath}/veiculos">
          <div class="stat-icon purple"><i class="bi bi-truck"></i></div>
          <div class="stat-info">
            <div class="stat-value">
              <%= request.getAttribute("totalVeiculos") != null ? request.getAttribute("totalVeiculos") : "&mdash;" %>
            </div>
            <div class="stat-label">Ve&iacute;culos na frota</div>
          </div>
        </a>

        <a class="stat-card" href="${pageContext.request.contextPath}/fretes">
          <div class="stat-icon orange"><i class="bi bi-file-earmark-text"></i></div>
          <div class="stat-info">
            <div class="stat-value">
              <%= request.getAttribute("fretesNoMes") != null ? request.getAttribute("fretesNoMes") : "&mdash;" %>
            </div>
            <div class="stat-label">Fretes este m&ecirc;s</div>
          </div>
        </a>

      </div>

      <!-- Alerta fretes em andamento -->
      <%
        Object emAberto = request.getAttribute("fretesEmAberto");
        if (emAberto != null && (Integer) emAberto > 0) {
      %>
      <div class="alert alert-warning" style="margin-bottom:24px;">
        <i class="bi bi-exclamation-triangle-fill"></i>
        <span>
          <strong><%= emAberto %> frete<%= (Integer)emAberto > 1 ? "s" : "" %></strong>
          em andamento (Emitido / Sa&iacute;da Confirmada / Em Tr&acirc;nsito)
        </span>
        <a href="${pageContext.request.contextPath}/fretes"
           style="margin-left:auto;font-size:12px;font-weight:600;color:inherit;">
          Ver fretes <i class="bi bi-arrow-right"></i>
        </a>
      </div>
      <% } %>
      
      <%
  List<Motorista> alertaCNH =
      (List<Motorista>) request.getAttribute("motoristasAlertaCNH");
  if (alertaCNH != null && !alertaCNH.isEmpty()) {
      LocalDate hoje = LocalDate.now();
      int qtdVencidas = 0;
      for (Motorista mv : alertaCNH) {
          if (mv.getCnhValidade() != null && mv.getCnhValidade().isBefore(hoje)) qtdVencidas++;
      }
%>
      <div class="alert alert-warning alert-cnh-banner">
  <i class="bi bi-exclamation-triangle-fill alert-cnh-icon"></i>
  <div class="alert-cnh-body">
    <strong class="alert-cnh-titulo">
      <%= alertaCNH.size() %> motorista<%= alertaCNH.size() > 1 ? "s" : "" %>
      com CNH vencida ou a vencer em 30 dias
    </strong>
    <% if (qtdVencidas > 0) { %>
    <span class="badge-cnh-vencida">
      <%= qtdVencidas %> JÁ VENCIDA<%= qtdVencidas > 1 ? "S" : "" %>
    </span>
    <% } %>
  </div>
  <a href="${pageContext.request.contextPath}/alertas-cnh" class="btn btn-secondary btn-sm">
    <i class="bi bi-eye"></i> Ver detalhes
  </a>
</div>
<% } %>
      <!-- Módulos -->
      <div class="section-header">
        <h2>M&oacute;dulos do sistema</h2>
      </div>

      <div class="module-grid">
        <a class="module-card" href="${pageContext.request.contextPath}/clientes">
          <div class="module-card-icon"><i class="bi bi-building"></i></div>
          <div class="module-card-body">
            <h3>Clientes</h3>
            <p>Tomadores de servi&ccedil;o, contatos e endere&ccedil;os.</p>
          </div>
          <i class="bi bi-chevron-right module-card-arrow"></i>
        </a>

        <a class="module-card" href="${pageContext.request.contextPath}/motoristas">
          <div class="module-card-icon"><i class="bi bi-person-badge"></i></div>
          <div class="module-card-body">
            <h3>Motoristas</h3>
            <p>CNH, v&iacute;nculo empregat&iacute;cio e status.</p>
          </div>
          <i class="bi bi-chevron-right module-card-arrow"></i>
        </a>

        <a class="module-card" href="${pageContext.request.contextPath}/veiculos">
          <div class="module-card-icon"><i class="bi bi-truck"></i></div>
          <div class="module-card-body">
            <h3>Ve&iacute;culos</h3>
            <p>Frota com capacidade de carga e status.</p>
          </div>
          <i class="bi bi-chevron-right module-card-arrow"></i>
        </a>

        <a class="module-card" href="${pageContext.request.contextPath}/fretes">
          <div class="module-card-icon"><i class="bi bi-file-earmark-text"></i></div>
          <div class="module-card-body">
            <h3>Fretes</h3>
            <p>Emiss&atilde;o, fluxo de status e rastreamento de carga.</p>
          </div>
          <i class="bi bi-chevron-right module-card-arrow"></i>
        </a>
      </div>

    </main>
  </div>
</div>
</body>
</html>