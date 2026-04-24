<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Erro — Gestão de Fretes</title>
  <style>
    body { font-family: Arial, sans-serif; background:#f0f2f5;
           display:flex; justify-content:center; align-items:center; height:100vh; margin:0; }
    .box { background:white; padding:48px; border-radius:8px;
           box-shadow:0 2px 10px rgba(0,0,0,.1); text-align:center; max-width:480px; }
    h2 { color:#dc2626; }
    p  { color:#555; margin:16px 0 32px; }
    a  { background:#1a3a5c; color:white; padding:10px 24px;
         border-radius:4px; text-decoration:none; font-size:14px; }
  </style>
</head>
<body>
  <div class="box">
    <h2>Ops! Algo deu errado.</h2>
    <p>
      <%
        String msg = (String) session.getAttribute("erroInesperado");
        if (msg != null) { session.removeAttribute("erroInesperado"); out.print(msg); }
        else { out.print("Ocorreu um erro inesperado. Tente novamente."); }
      %>
    </p>
    <a href="${pageContext.request.contextPath}/dashboard">Voltar ao início</a>
  </div>
</body>
</html>
