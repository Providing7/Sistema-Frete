<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login &mdash; Gestão de Fretes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
      background: #f0f4ff;
      min-height: 100vh;
      display: flex; align-items: center; justify-content: center;
    }
    .auth-card {
      display: flex; width: 900px; min-height: 560px;
      border-radius: 20px; overflow: hidden;
      box-shadow: 0 20px 60px rgba(0,0,0,.15);
    }
    .auth-left {
      flex: 1;
      background: linear-gradient(145deg, #1a56db 0%, #1e429f 100%);
      color: #fff;
      display: flex; flex-direction: column;
      justify-content: center; align-items: center;
      padding: 48px 40px; text-align: center;
    }
    .auth-left-icon { font-size: 64px; margin-bottom: 20px; }
    .auth-left h1 { font-size: 28px; font-weight: 700; line-height: 1.3; }
    .auth-left h1 span { color: #93c5fd; }
    .auth-left p { margin-top: 14px; font-size: 14px; color: #bfdbfe; line-height: 1.7; }
    .auth-divider { width: 40px; height: 3px; background: rgba(255,255,255,.3); border-radius: 2px; margin: 24px auto; }
    .auth-features { list-style: none; text-align: left; }
    .auth-features li { font-size: 13px; color: #dbeafe; padding: 5px 0; }
    .auth-features li::before { content: '✓  '; font-weight: 700; color: #93c5fd; }
    .auth-right {
      flex: 1; background: #fff;
      display: flex; flex-direction: column; justify-content: center;
      padding: 48px 44px;
    }
    .auth-right-header h2 { font-size: 22px; font-weight: 700; color: #111827; }
    .auth-right-header p  { margin-top: 6px; font-size: 13px; color: #6b7280; }
    .auth-alert {
      margin-top: 18px; padding: 10px 14px; border-radius: 8px;
      font-size: 13px; display: flex; align-items: center; gap: 8px;
    }
    .auth-alert-error   { background: #fef2f2; color: #b91c1c; border: 1px solid #fecaca; }
    .auth-alert-success { background: #f0fdf4; color: #15803d; border: 1px solid #bbf7d0; }
    .auth-form { margin-top: 28px; display: flex; flex-direction: column; gap: 18px; }
    .auth-field label { display: block; font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 6px; }
    .auth-field input {
      width: 100%; padding: 10px 14px;
      border: 1.5px solid #d1d5db; border-radius: 8px;
      font-size: 14px; color: #111827; outline: none; transition: border-color .2s;
    }
    .auth-field input:focus { border-color: #1a56db; box-shadow: 0 0 0 3px rgba(26,86,219,.1); }
    .auth-submit {
      width: 100%; padding: 12px;
      background: #1a56db; color: #fff;
      font-size: 15px; font-weight: 600;
      border: none; border-radius: 8px; cursor: pointer;
      transition: background .2s; margin-top: 4px;
    }
    .auth-submit:hover { background: #1e429f; }
    .auth-footer { margin-top: 22px; text-align: center; font-size: 13px; color: #6b7280; }
    .auth-footer a { color: #1a56db; font-weight: 600; text-decoration: none; }
    .auth-footer a:hover { text-decoration: underline; }
    @media (max-width: 700px) {
      .auth-card { flex-direction: column; width: 95%; min-height: unset; }
      .auth-left  { padding: 32px 24px; }
      .auth-right { padding: 32px 24px; }
    }
  </style>
</head>
<body>
<div class="auth-card">

  <div class="auth-left">
    <div class="auth-left-icon">&#128666;</div>
    <h1>Gestão de<br><span>Fretes</span></h1>
    <div class="auth-divider"></div>
    <p>Controle total sobre o ciclo de vida dos seus fretes.</p>
    <ul class="auth-features">
      <li>Cadastro de clientes, motoristas e frota</li>
      <li>Emissão e acompanhamento de fretes</li>
      <li>Ocorrências e rastreamento de carga</li>
      <li>Relatórios gerenciais</li>
    </ul>
  </div>

  <div class="auth-right">
    <div class="auth-right-header">
      <h2>Bem-vindo de volta</h2>
      <p>Entre com seu e-mail e senha para acessar o sistema.</p>
    </div>

    <% if (request.getAttribute("erro") != null) { %>
      <div class="auth-alert auth-alert-error">&#9888; ${erro}</div>
    <% } %>
    <% if (request.getParameter("sucesso") != null) { %>
      <div class="auth-alert auth-alert-success">&#9989; ${param.sucesso}</div>
    <% } %>

    <form class="auth-form" method="post" action="${pageContext.request.contextPath}/login">
      <div class="auth-field">
        <label for="email">E-mail</label>
        <input type="email" id="email" name="email"
               placeholder="seu@email.com" required autofocus />
      </div>
      <div class="auth-field">
        <label for="senha">Senha</label>
        <input type="password" id="senha" name="senha"
               placeholder="Sua senha" required />
      </div>
      <button class="auth-submit" type="submit">Entrar no sistema &rarr;</button>
    </form>

    <div class="auth-footer">
      Não tem uma conta?
      <a href="${pageContext.request.contextPath}/usuarios?acao=novo">Criar conta grátis</a>
    </div>
  </div>

</div>
</body>
</html>
