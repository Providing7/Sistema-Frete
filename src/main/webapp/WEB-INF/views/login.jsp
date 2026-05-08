<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Acesso &mdash; FretesTMS</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="login-page">

  <div class="login-panel-left">
    <div class="login-hero-badge">
      <i class="bi bi-truck-front-fill"></i> FretesTMS
    </div>
    <h1 class="login-hero-title">
      Controle total<br>sobre seus <span>fretes</span>
    </h1>
    <p class="login-hero-sub">
      Plataforma integrada para gest&atilde;o do ciclo de vida do transporte:
      emiss&atilde;o, rastreamento e relat&oacute;rios gerenciais.
    </p>
    <ul class="login-features">
      <li><i class="bi bi-check-circle-fill"></i> Cadastro de clientes, motoristas e frota</li>
      <li><i class="bi bi-check-circle-fill"></i> Emiss&atilde;o e controle de fretes (FRT)</li>
      <li><i class="bi bi-check-circle-fill"></i> Fluxo de status e ocorr&ecirc;ncias</li>
      <li><i class="bi bi-check-circle-fill"></i> Relat&oacute;rios JasperReports</li>
    </ul>
  </div>

  <div class="login-panel-right">
    <div class="login-form-wrapper">

      <div class="login-brand">
        <div class="login-brand-icon"><i class="bi bi-truck-front-fill"></i></div>
        <span class="login-brand-name">FretesTMS</span>
      </div>

      <div class="login-form-header">
        <h2>Entrar no sistema</h2>
        <p>Informe suas credenciais para continuar.</p>
      </div>

      <% if (request.getAttribute("erro") != null) { %>
        <div class="alert alert-error" style="margin-bottom:20px;">
          <i class="bi bi-exclamation-circle-fill"></i> ${erro}
        </div>
      <% } %>
      <% if (request.getParameter("sucesso") != null) { %>
        <div class="alert alert-success" style="margin-bottom:20px;">
          <i class="bi bi-check-circle-fill"></i> ${param.sucesso}
        </div>
      <% } %>

      <form class="login-form" method="post" action="${pageContext.request.contextPath}/login">
        <div class="login-field">
          <label for="email">E-mail</label>
          <input type="email" id="email" name="email" placeholder="seu@email.com" required autofocus />
        </div>
        <div class="login-field">
          <label for="senha">Senha</label>
          <input type="password" id="senha" name="senha" placeholder="Sua senha" required />
        </div>
        <button class="login-submit" type="submit">
          <i class="bi bi-box-arrow-in-right"></i> Entrar
        </button>
      </form>

      <div class="login-footer">
        Sem acesso?
        <a href="${pageContext.request.contextPath}/usuarios?acao=novo">Solicitar cadastro</a>
      </div>

    </div>
  </div>

</div>
</body>
</html>