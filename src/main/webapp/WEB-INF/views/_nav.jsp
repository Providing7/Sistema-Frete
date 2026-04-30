<%@ page contentType="text/html;charset=UTF-8" %>
<%
  String uri = request.getRequestURI();
  String ctx = request.getContextPath();
  String usuario = (String) session.getAttribute("usuarioLogado");
  String inicial = (usuario != null && !usuario.isEmpty()) ? String.valueOf(Character.toUpperCase(usuario.charAt(0))) : "U";
%>
<aside class="sidebar">
  <div class="sidebar-brand">
    <a href="<%= ctx %>/dashboard">
      <div class="brand-icon">&#128666;</div>
      <div class="brand-text">
        <span class="brand-name">GestãoFretes</span>
        <span class="brand-tagline">Sistema de Gestão</span>
      </div>
    </a>
  </div>

  <nav class="sidebar-nav">
    <div class="nav-section-title">Principal</div>

    <a href="<%= ctx %>/dashboard" class="<%= uri.contains("/dashboard") ? "active" : "" %>">
      <span class="nav-icon">&#127968;</span> Dashboard
    </a>

    <div class="nav-section-title">Operacional</div>

    <a href="<%= ctx %>/fretes" class="<%= uri.contains("/fretes") || uri.contains("/ocorrencias") ? "active" : "" %>">
      <span class="nav-icon">&#128230;</span> Fretes
    </a>

    <div class="nav-section-title">Cadastros</div>

    <a href="<%= ctx %>/clientes" class="<%= uri.contains("/clientes") ? "active" : "" %>">
      <span class="nav-icon">&#127970;</span> Clientes
    </a>
    <a href="<%= ctx %>/motoristas" class="<%= uri.contains("/motoristas") ? "active" : "" %>">
      <span class="nav-icon">&#128100;</span> Motoristas
    </a>
    <a href="<%= ctx %>/veiculos" class="<%= uri.contains("/veiculos") ? "active" : "" %>">
      <span class="nav-icon">&#128666;</span> Ve&iacute;culos
    </a>
  </nav>

  <div class="sidebar-footer">
    <a href="<%= ctx %>/logout" class="sidebar-user">
      <div class="user-avatar"><%= inicial %></div>
      <div class="user-info">
        <div class="user-name"><%= usuario != null ? usuario : "Usuário" %></div>
        <div class="user-role">Administrador</div>
      </div>
      <span class="logout-icon">&#8594;</span>
    </a>
  </div>
</aside>