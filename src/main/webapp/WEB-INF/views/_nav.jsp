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
      <div class="brand-icon"><i class="bi bi-truck-front-fill"></i></div>
      <div class="brand-text">
        <span class="brand-name">FretesTMS</span>
        <span class="brand-tagline">Gestão de Transportes</span>
      </div>
    </a>
  </div>

  <nav class="sidebar-nav">
    <div class="nav-section-title">Principal</div>

    <a href="<%= ctx %>/dashboard" class="<%= uri.contains("/dashboard") ? "active" : "" %>">
      <i class="bi bi-speedometer2 nav-icon"></i> Dashboard
    </a>

    <div class="nav-section-title">Operacional</div>

    <a href="<%= ctx %>/fretes" class="<%= uri.contains("/fretes") || uri.contains("/ocorrencias") ? "active" : "" %>">
      <i class="bi bi-file-earmark-text nav-icon"></i> Fretes
    </a>

    <div class="nav-section-title">Cadastros</div>

    <a href="<%= ctx %>/clientes" class="<%= uri.contains("/clientes") ? "active" : "" %>">
      <i class="bi bi-building nav-icon"></i> Clientes
    </a>
    <a href="<%= ctx %>/motoristas" class="<%= uri.contains("/motoristas") ? "active" : "" %>">
      <i class="bi bi-person-badge nav-icon"></i> Motoristas
    </a>
    <a href="<%= ctx %>/veiculos" class="<%= uri.contains("/veiculos") ? "active" : "" %>">
      <i class="bi bi-truck nav-icon"></i> Ve&iacute;culos
    </a>

    <div class="nav-section-title">Relat&oacute;rios</div>

    <a href="<%= ctx %>/relatorios/fretes-aberto" target="_blank" class="<%= uri.contains("/relatorios") ? "active" : "" %>">
      <i class="bi bi-bar-chart-line nav-icon"></i> Fretes em Aberto
    </a>
    <a href="<%= ctx %>/relatorios/romaneio" class="<%= uri.contains("/relatorios/romaneio") ? "active" : "" %>">
      <i class="bi bi-printer nav-icon"></i> Romaneio de Carga
    </a>
  </nav>

  <div class="sidebar-footer">
    <a href="<%= ctx %>/logout" class="sidebar-user">
      <div class="user-avatar"><%= inicial %></div>
      <div class="user-info">
        <div class="user-name"><%= usuario != null ? usuario : "Usu&aacute;rio" %></div>
        <div class="user-role">Administrador</div>
      </div>
      <i class="bi bi-box-arrow-right logout-icon"></i>
    </a>
  </div>
</aside>