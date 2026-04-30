<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard &mdash; Gestão de Fretes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />

  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">Dashboard</span>
        <span class="topbar-breadcrumb">Vis&atilde;o geral do sistema</span>
      </div>
      <div class="topbar-right">
        <span style="font-size:13px;color:var(--gray-500);">Ol&aacute;, <strong style="color:var(--gray-800);">${sessionScope.usuarioLogado}</strong> &#128075;</span>
      </div>
    </header>

    <main class="page-body">

      <!-- Stats -->
      <div class="stats-grid">
        <a class="stat-card" href="${pageContext.request.contextPath}/clientes">
          <div class="stat-icon blue">&#127970;</div>
          <div class="stat-info">
            <div class="stat-value">&mdash;</div>
            <div class="stat-label">Clientes cadastrados</div>
          </div>
        </a>
        <a class="stat-card" href="${pageContext.request.contextPath}/motoristas">
          <div class="stat-icon green">&#128100;</div>
          <div class="stat-info">
            <div class="stat-value">&mdash;</div>
            <div class="stat-label">Motoristas ativos</div>
          </div>
        </a>
        <a class="stat-card" href="${pageContext.request.contextPath}/veiculos">
          <div class="stat-icon purple">&#128666;</div>
          <div class="stat-info">
            <div class="stat-value">&mdash;</div>
            <div class="stat-label">Ve&iacute;culos na frota</div>
          </div>
        </a>
        <div class="stat-card">
          <div class="stat-icon orange">&#128203;</div>
          <div class="stat-info">
            <div class="stat-value">&mdash;</div>
            <div class="stat-label">Fretes este m&ecirc;s</div>
          </div>
        </div>
      </div>

      <!-- Módulos -->
      <div class="section-header">
        <h2>M&oacute;dulos</h2>
      </div>

      <div class="module-grid">
        <a class="module-card" href="${pageContext.request.contextPath}/clientes">
          <div class="module-card-icon">&#127970;</div>
          <div>
            <h3>Clientes</h3>
            <p>Cadastre e gerencie tomadores de servi&ccedil;o, contatos e endere&ccedil;os.</p>
          </div>
          <span class="module-card-arrow">&#8594;</span>
        </a>

        <a class="module-card" href="${pageContext.request.contextPath}/motoristas">
          <div class="module-card-icon">&#128100;</div>
          <div>
            <h3>Motoristas</h3>
            <p>Controle de CNH, v&iacute;nculo empregat&iacute;cio e status dos motoristas.</p>
          </div>
          <span class="module-card-arrow">&#8594;</span>
        </a>

        <a class="module-card" href="${pageContext.request.contextPath}/veiculos">
          <div class="module-card-icon">&#128666;</div>
          <div>
            <h3>Ve&iacute;culos</h3>
            <p>Frota completa com capacidade de carga, tipo e status de cada ve&iacute;culo.</p>
          </div>
          <span class="module-card-arrow">&#8594;</span>
        </a>
      </div>

    </main>
  </div>
</div>
</body>
</html>