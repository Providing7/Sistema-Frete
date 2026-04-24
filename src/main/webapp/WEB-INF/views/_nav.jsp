<%@ page contentType="text/html;charset=UTF-8" %>
<style>
  .nav { background:#1a3a5c; color:white; padding:0 32px;
         display:flex; align-items:center; justify-content:space-between; height:56px; }
  .nav-brand { font-size:17px; font-weight:bold; color:white; text-decoration:none; }
  .nav-links a { color:#cbd5e1; text-decoration:none; margin-left:24px; font-size:14px; }
  .nav-links a:hover { color:white; }
  .nav-links a.active { color:white; font-weight:bold; border-bottom:2px solid #3b82f6; padding-bottom:2px; }
</style>
<div class="nav">
  <a class="nav-brand" href="${pageContext.request.contextPath}/dashboard">Gestão de Fretes</a>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/clientes">Clientes</a>
    <a href="${pageContext.request.contextPath}/motoristas">Motoristas</a>
    <a href="${pageContext.request.contextPath}/veiculos">Veículos</a>
    <a href="${pageContext.request.contextPath}/logout">Sair (${sessionScope.usuarioLogado})</a>
  </div>
</div>
