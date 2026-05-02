<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Criar Conta &mdash; Gestão de Fretes</title>
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
      display: flex; width: 900px; min-height: 580px;
      border-radius: 20px; overflow: hidden;
      box-shadow: 0 20px 60px rgba(0,0,0,.15);
    }
    .auth-left {
      flex: 1;
      background: linear-gradient(145deg, #059669 0%, #065f46 100%);
      color: #fff;
      display: flex; flex-direction: column;
      justify-content: center; align-items: center;
      padding: 48px 40px; text-align: center;
    }
    .auth-left-icon { font-size: 64px; margin-bottom: 20px; }
    .auth-left h1 { font-size: 26px; font-weight: 700; line-height: 1.3; }
    .auth-left h1 span { color: #6ee7b7; }
    .auth-left p { margin-top: 14px; font-size: 14px; color: #a7f3d0; line-height: 1.7; }
    .auth-divider { width: 40px; height: 3px; background: rgba(255,255,255,.3); border-radius: 2px; margin: 24px auto; }
    .auth-features { list-style: none; text-align: left; }
    .auth-features li { font-size: 13px; color: #d1fae5; padding: 5px 0; }
    .auth-features li::before { content: '✓  '; font-weight: 700; color: #6ee7b7; }
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
    .auth-alert-error { background: #fef2f2; color: #b91c1c; border: 1px solid #fecaca; }
    .auth-form { margin-top: 24px; display: flex; flex-direction: column; gap: 16px; }
    .auth-field label { display: block; font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 6px; }
    .auth-field input {
      width: 100%; padding: 10px 14px;
      border: 1.5px solid #d1d5db; border-radius: 8px;
      font-size: 14px; color: #111827; outline: none; transition: border-color .2s;
    }
    .auth-field input:focus { border-color: #059669; box-shadow: 0 0 0 3px rgba(5,150,105,.1); }
    .auth-submit {
      width: 100%; padding: 12px;
      background: #059669; color: #fff;
      font-size: 15px; font-weight: 600;
      border: none; border-radius: 8px; cursor: pointer;
      transition: background .2s; margin-top: 4px;
    }
    .auth-submit:hover { background: #065f46; }
    .auth-footer { margin-top: 20px; text-align: center; font-size: 13px; color: #6b7280; }
    .auth-footer a { color: #059669; font-weight: 600; text-decoration: none; }
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
    <div class="auth-left-icon">&#128101;</div>
    <h1>Crie sua<br><span>conta agora</span></h1>
    <div class="auth-divider"></div>
    <p>Comece a gerenciar seus fretes em poucos segundos.</p>
    <ul class="auth-features">
      <li>Cadastro rápido e gratuito</li>
      <li>Acesso completo ao sistema</li>
      <li>Dados seguros e criptografados</li>
      <li>Suporte a múltiplos usuários</li>
    </ul>
  </div>

  <div class="auth-right">
    <div class="auth-right-header">
      <h2>Criar nova conta</h2>
      <p>Preencha os campos abaixo para começar.</p>
    </div>

    <% if (request.getAttribute("erro") != null) { %>
      <div class="auth-alert auth-alert-error">&#9888; ${erro}</div>
    <% } %>

    <form class="auth-form" method="post"
          action="${pageContext.request.contextPath}/usuarios?acao=cadastrar">

      <div class="auth-field">
        <label for="nomeCompleto">Nome Completo</label>
        <input type="text" id="nomeCompleto" name="nomeCompleto"
               value="${nomeCompleto}"
               placeholder="Seu nome completo" required autofocus />
      </div>

      <div class="auth-field">
        <label for="email">E-mail</label>
        <input type="email" id="email" name="email"
               value="${email}"
               placeholder="seu@email.com" required />
      </div>

      <div class="auth-field">
        <label for="senha">Senha <span style="font-weight:400;color:#9ca3af;">(mínimo 6 caracteres)</span></label>
        <input type="password" id="senha" name="senha"
               placeholder="Crie uma senha segura" required minlength="6" />
      </div>

      <button class="auth-submit" type="submit">Criar minha conta &rarr;</button>
    </form>

    <div class="auth-footer">
      Já tem uma conta?
      <a href="${pageContext.request.contextPath}/login">Fazer login</a>
    </div>
  </div>

</div>
</body>
</html>
