<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Erro &mdash; Gestão de Fretes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
  <div class="error-page">
    <div class="error-card">
      <div class="error-icon">&#128679;</div>
      <h2>Ops! Algo deu errado.</h2>
      <p>
        <%
          String msg = (String) session.getAttribute("erroInesperado");
          if (msg != null) { session.removeAttribute("erroInesperado"); out.print(msg); }
          else { out.print("Ocorreu um erro inesperado. Por favor, tente novamente."); }
        %>
      </p>
      <a class="btn btn-primary" href="${pageContext.request.contextPath}/dashboard">&larr; Voltar ao in&iacute;cio</a>
    </div>
  </div>
</body>
</html>