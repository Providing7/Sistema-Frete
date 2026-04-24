<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, br.com.gestaofretes.model.Veiculo" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8"><title>Veículos</title>
  <style>
    body{font-family:Arial,sans-serif;background:#f0f2f5;}
    .content{padding:32px;}
    .toolbar{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;}
    h2{color:#1a3a5c;}
    form.filtro{display:flex;gap:8px;}
    input[type=text]{padding:8px 12px;border:1px solid #cbd5e1;border-radius:4px;font-size:14px;width:280px;}
    .btn{padding:8px 16px;border:none;border-radius:4px;cursor:pointer;font-size:14px;text-decoration:none;display:inline-block;}
    .btn-primary{background:#1a3a5c;color:white;}
    .btn-secondary{background:#e2e8f0;color:#334155;}
    .btn-danger{background:#dc2626;color:white;}
    .btn-sm{padding:4px 10px;font-size:12px;}
    table{width:100%;border-collapse:collapse;background:white;border-radius:8px;overflow:hidden;box-shadow:0 1px 4px rgba(0,0,0,.1);}
    th{background:#1a3a5c;color:white;padding:12px 16px;text-align:left;font-size:13px;}
    td{padding:11px 16px;border-bottom:1px solid #f1f5f9;font-size:13px;}
    tr:last-child td{border-bottom:none;}
    tr:hover td{background:#f8fafc;}
    .badge{padding:3px 10px;border-radius:12px;font-size:11px;font-weight:bold;}
    .badge-DISPONIVEL{background:#dcfce7;color:#166534;}
    .badge-EM_VIAGEM{background:#dbeafe;color:#1e40af;}
    .badge-EM_MANUTENCAO{background:#fef9c3;color:#854d0e;}
    .paginacao{margin-top:16px;display:flex;gap:8px;align-items:center;}
    .alerta{padding:12px 16px;border-radius:4px;margin-bottom:16px;font-size:14px;}
    .alerta-erro{background:#fee2e2;color:#991b1b;border-left:4px solid #dc2626;}
    .alerta-sucesso{background:#dcfce7;color:#166534;border-left:4px solid #16a34a;}
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/_nav.jsp" />
<div class="content">
  <div class="toolbar">
    <h2>Veículos</h2>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/veiculos?acao=novo">+ Novo Veículo</a>
  </div>

  <% if (request.getAttribute("erro") != null) { %>
    <div class="alerta alerta-erro">${erro}</div>
  <% } %>
  <% if (request.getParameter("sucesso") != null) { %>
    <div class="alerta alerta-sucesso">${param.sucesso}</div>
  <% } %>

  <form class="filtro" method="get" action="${pageContext.request.contextPath}/veiculos" style="margin-bottom:16px;">
    <input type="text" name="filtro" placeholder="Filtrar por placa..." value="${filtro}" />
    <button class="btn btn-secondary" type="submit">Buscar</button>
    <% if (request.getAttribute("filtro") != null && !((String)request.getAttribute("filtro")).isEmpty()) { %>
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/veiculos">Limpar</a>
    <% } %>
  </form>

  <table>
    <thead>
      <tr>
        <th>Placa</th><th>RNTRC</th><th>Tipo</th><th>Ano</th>
        <th>Capacidade (kg)</th><th>Volume (m³)</th><th>Status</th><th>Ações</th>
      </tr>
    </thead>
    <tbody>
      <%
        List<Veiculo> veiculos = (List<Veiculo>) request.getAttribute("veiculos");
        if (veiculos != null) {
          for (Veiculo v : veiculos) {
      %>
      <tr>
        <td><%= v.getPlaca() %></td>
        <td><%= v.getRntrc() %></td>
        <td><%= v.getTipo() != null ? v.getTipo().name() : "" %></td>
        <td><%= v.getAnoFabricacao() %></td>
        <td><%= v.getCapacidadeKg() %></td>
        <td><%= v.getVolumeM3() %></td>
        <td>
          <span class="badge badge-<%= v.getStatus().name() %>"><%= v.getStatus().name() %></span>
        </td>
        <td>
          <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/veiculos?acao=editar&id=<%= v.getId() %>">Editar</a>
          <a class="btn btn-danger btn-sm" href="${pageContext.request.contextPath}/veiculos?acao=excluir&id=<%= v.getId() %>"
             onclick="return confirm('Confirma a exclusão?')">Excluir</a>
        </td>
      </tr>
      <%   }
        } %>
    </tbody>
  </table>

  <%
    Integer pagina       = (Integer) request.getAttribute("pagina");
    Integer totalPaginas = (Integer) request.getAttribute("totalPaginas");
    if (pagina != null && totalPaginas != null && totalPaginas > 1) {
  %>
  <div class="paginacao">
    <% if (pagina > 1) { %>
      <a class="btn btn-secondary btn-sm" href="?pagina=<%= pagina-1 %>&filtro=${filtro}">← Anterior</a>
    <% } %>
    <span style="font-size:13px;color:#64748b;">Página <%= pagina %> de <%= totalPaginas %></span>
    <% if (pagina < totalPaginas) { %>
      <a class="btn btn-secondary btn-sm" href="?pagina=<%= pagina+1 %>&filtro=${filtro}">Próxima →</a>
    <% } %>
  </div>
  <% } %>
</div>
</body>
</html>
