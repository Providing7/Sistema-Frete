<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Dashboard — Gestão de Fretes</title>
  <style>
    * { box-sizing:border-box; margin:0; padding:0; }
    body { font-family:Arial,sans-serif; background:#f0f2f5; }
    .content { padding:40px; }
    h2 { color:#1a3a5c; margin-bottom:8px; }
    .subtitulo { color:#64748b; margin-bottom:32px; font-size:14px; }
    .cards { display:flex; gap:24px; flex-wrap:wrap; }
    .card { background:white; border-radius:8px; padding:24px 32px;
            box-shadow:0 1px 4px rgba(0,0,0,.1); flex:1; min-width:180px;
            border-left:4px solid #3b82f6; text-decoration:none; color:inherit;
            transition:box-shadow .2s; }
    .card:hover { box-shadow:0 4px 12px rgba(0,0,0,.15); }
    .card h3 { font-size:14px; color:#64748b; margin-bottom:8px; }
    .card .icone { font-size:28px; margin-bottom:8px; }
  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/_nav.jsp" />
  <div class="content">
    <h2>Bem-vindo, ${sessionScope.usuarioLogado}!</h2>
    <p class="subtitulo">Selecione um módulo para começar.</p>
    <div class="cards">
      <a class="card" href="${pageContext.request.contextPath}/clientes">
        <div class="icone">🏢</div>
        <h3>Clientes</h3>
        <span>Cadastrar e gerenciar tomadores de serviço</span>
      </a>
      <a class="card" href="${pageContext.request.contextPath}/motoristas">
        <div class="icone">🚗</div>
        <h3>Motoristas</h3>
        <span>Cadastrar e gerenciar motoristas</span>
      </a>
      <a class="card" href="${pageContext.request.contextPath}/veiculos">
        <div class="icone">🚚</div>
        <h3>Veículos</h3>
        <span>Cadastrar e gerenciar frota</span>
      </a>
    </div>
  </div>
</body>
</html>
