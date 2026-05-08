<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Erro &mdash; Gestão de Fretes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">
</head>
<body>
  <div class="error-page">
    <div class="error-card">
      <div class="error-icon"><i class="bi bi-exclamation-triangle-fill"></i></div>
      <h2>Ops! Algo deu errado.</h2>
      <p>
        <%
          String msg = (String) session.getAttribute("erroInesperado");
          if (msg != null) { session.removeAttribute("erroInesperado"); out.print(msg); }
          else { out.print("Ocorreu um erro inesperado. Por favor, tente novamente ou entre em contato com o suporte."); }
        %>
      </p>
      <a class="btn btn-primary" href="${pageContext.request.contextPath}/dashboard">
        <i class="bi bi-house"></i> Voltar ao in&iacute;cio
      </a>
    </div>
  </div>
</body>
</html>