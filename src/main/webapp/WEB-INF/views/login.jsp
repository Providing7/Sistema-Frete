<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login &mdash; Gestão de Fretes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="login-page">

  <!-- Painel esquerdo: hero -->
  <div class="login-panel-left">
    <div class="login-hero-icon">&#128666;</div>
    <h1 class="login-hero-title">
      Gestão de<br><span>Fretes</span>
    </h1>
    <p class="login-hero-sub">
      Gerencie clientes, motoristas e frota em um único lugar.
      Simples, r&aacute;pido e eficiente.
    </p>
  </div>

  <!-- Painel direito: formulário -->
  <div class="login-panel-right">
    <div class="login-form-wrapper">
      <div class="login-form-header">
        <h2>Bem-vindo de volta</h2>
        <p>Fa&ccedil;a login para acessar o sistema</p>
      </div>

      <% if (request.getAttribute("erro") != null) { %>
        <div class="alert alert-error">&#9888; ${erro}</div>
      <% } %>

      <form class="login-form" method="post" action="${pageContext.request.contextPath}/login">
        <div class="login-field">
          <label for="usuario">Usu&aacute;rio</label>
          <input type="text" id="usuario" name="usuario" placeholder="Digite seu usu&aacute;rio" required autofocus />
        </div>
        <div class="login-field">
          <label for="senha">Senha</label>
          <input type="password" id="senha" name="senha" placeholder="Digite sua senha" required />
        </div>
        <button class="login-submit" type="submit">Entrar no sistema &rarr;</button>
      </form>
    </div>
  </div>

</div>
</body>
</html>