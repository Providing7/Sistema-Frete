<%@ page contentType="text/html;charset=ISO-8859-1" language="java" %>
<%@ page import="java.util.List, br.com.gestaofretes.model.Cliente" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="ISO-8859-1">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Clientes &#8212; Gestão de Fretes</title>

</head>
<body>
<jsp:include page="/WEB-INF/views/_nav.jsp" />
<div class="main-wrapper">

  <div class="page-header">
    <div>
      <h1>&#127970; Clientes</h1>
      <div class="breadcrumb">Cadastro &#8594; Clientes</div>
    </div>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/clientes?acao=novo">+ Novo Cliente</a>
  </div>

  <div class="page-content">

    <% if (request.getAttribute("erro") != null) { %>
      <div class="alert alert-error">&#9888; ${erro}</div>
    <% } %>
    <% if (request.getParameter("sucesso") != null) { %>
      <div class="alert alert-success">&#9989; ${param.sucesso}</div>
    <% } %>

    <div class="card">
      <div class="card-header">
        <h3>Lista de Clientes</h3>
        <form method="get" action="${pageContext.request.contextPath}/clientes" style="display:flex;gap:8px;align-items:center;">
          <div class="search-box">
            <span class="search-icon">&#128269;</span>
            <input type="text" name="filtro" placeholder="Buscar por razão social..." value="${filtro}" />
          </div>
          <button class="btn btn-secondary" type="submit">Buscar</button>
          <% if (request.getAttribute("filtro") != null && !((String)request.getAttribute("filtro")).isEmpty()) { %>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/clientes">&#10005; Limpar</a>
          <% } %>
        </form>
      </div>

      <div class="table-responsive">
        <table>
          <thead>
            <tr>
              <th>Razão Social</th><th>Nome Fantasia</th><th>CNPJ</th>
              <th>Tipo</th><th>Município / UF</th><th>Status</th><th>Ações</th>
            </tr>
          </thead>
          <tbody>
            <%
              List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
              if (clientes != null && !clientes.isEmpty()) {
                for (Cliente c : clientes) {
            %>
            <tr>
              <td><strong><%= c.getRazaoSocial() %></strong></td>
              <td style="color:#64748b;"><%= c.getNomeFantasia() != null ? c.getNomeFantasia() : "" %></td>
              <td style="font-family:monospace;font-size:12px;"><%= c.getCnpj() %></td>
              <td><%= c.getTipo() != null ? c.getTipo().name() : "" %></td>
              <td><%= c.getMunicipio() != null ? c.getMunicipio() : "" %> / <%= c.getUf() != null ? c.getUf() : "" %></td>
              <td>
                <% if (c.isAtivo()) { %><span class="badge badge-ativo">Ativo</span>
                <% } else { %><span class="badge badge-inativo">Inativo</span><% } %>
              </td>
              <td>
                <div class="td-actions">
                  <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/clientes?acao=editar&id=<%= c.getId() %>">&#9999; Editar</a>
                  <a class="btn btn-danger btn-sm" href="${pageContext.request.contextPath}/clientes?acao=excluir&id=<%= c.getId() %>"
                     onclick="return confirm('Confirma a exclusão do cliente?')">&#128465; Excluir</a>
                </div>
              </td>
            </tr>
            <%   }
              } else { %>
            <tr><td colspan="7" style="text-align:center;padding:40px;color:#94a3b8;">Nenhum cliente encontrado.</td></tr>
            <% } %>
          </tbody>
        </table>
      </div>

      <%
        Integer pagina       = (Integer) request.getAttribute("pagina");
        Integer totalPaginas = (Integer) request.getAttribute("totalPaginas");
        if (pagina != null && totalPaginas != null && totalPaginas > 1) {
      %>
      <div style="padding:12px 24px;border-top:1px solid #f1f5f9;">
        <div class="pagination">
          <% if (pagina > 1) { %>
            <a class="btn btn-secondary btn-sm" href="?pagina=<%= pagina-1 %>&filtro=${filtro}">â† Anterior</a>
          <% } %>
          <span class="page-info">Página <%= pagina %> de <%= totalPaginas %></span>
          <% if (pagina < totalPaginas) { %>
            <a class="btn btn-secondary btn-sm" href="?pagina=<%= pagina+1 %>&filtro=${filtro}">Próxima &#8594;</a>
          <% } %>
        </div>
      </div>
      <% } %>
    </div>
  </div>
</div>
</body>
</html>


