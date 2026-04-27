<%@ page contentType="text/html;charset=ISO-8859-1" language="java" %>
<%@ page import="java.util.List, br.com.gestaofretes.model.Motorista" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="ISO-8859-1">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Motoristas &#8212; Gestão de Fretes</title>

</head>
<body>
<jsp:include page="/WEB-INF/views/_nav.jsp" />
<div class="main-wrapper">

  <div class="page-header">
    <div>
      <h1>&#128100; Motoristas</h1>
      <div class="breadcrumb">Cadastro &#8594; Motoristas</div>
    </div>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/motoristas?acao=novo">+ Novo Motorista</a>
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
        <h3>Lista de Motoristas</h3>
        <form method="get" action="${pageContext.request.contextPath}/motoristas" style="display:flex;gap:8px;align-items:center;">
          <div class="search-box">
            <span class="search-icon">&#128269;</span>
            <input type="text" name="filtro" placeholder="Buscar por nome..." value="${filtro}" />
          </div>
          <button class="btn btn-secondary" type="submit">Buscar</button>
          <% if (request.getAttribute("filtro") != null && !((String)request.getAttribute("filtro")).isEmpty()) { %>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/motoristas">&#10005; Limpar</a>
          <% } %>
        </form>
      </div>

      <div class="table-responsive">
        <table>
          <thead>
            <tr>
              <th>Nome</th><th>CPF</th><th>CNH Nº</th><th>Categoria</th>
              <th>Validade CNH</th><th>Vínculo</th><th>Status</th><th>Ações</th>
            </tr>
          </thead>
          <tbody>
            <%
              List<Motorista> motoristas = (List<Motorista>) request.getAttribute("motoristas");
              if (motoristas != null && !motoristas.isEmpty()) {
                for (Motorista m : motoristas) {
            %>
            <tr>
              <td><strong><%= m.getNome() %></strong></td>
              <td style="font-family:monospace;font-size:12px;"><%= m.getCpf() %></td>
              <td><%= m.getCnhNumero() %></td>
              <td><%= m.getCnhCategoria() != null ? m.getCnhCategoria().name() : "" %></td>
              <td><%= m.getCnhValidade() != null ? m.getCnhValidade().toString() : "" %></td>
              <td><%= m.getTipoVinculo() != null ? m.getTipoVinculo().name() : "" %></td>
              <td><span class="badge badge-<%= m.getStatus().name() %>"><%= m.getStatus().name() %></span></td>
              <td>
                <div class="td-actions">
                  <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/motoristas?acao=editar&id=<%= m.getId() %>">&#9999; Editar</a>
                  <a class="btn btn-danger btn-sm" href="${pageContext.request.contextPath}/motoristas?acao=excluir&id=<%= m.getId() %>"
                     onclick="return confirm('Confirma a exclusão?')">&#128465; Excluir</a>
                </div>
              </td>
            </tr>
            <%   }
              } else { %>
            <tr><td colspan="8" style="text-align:center;padding:40px;color:#94a3b8;">Nenhum motorista encontrado.</td></tr>
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
          <% if (pagina > 1) { %><a class="btn btn-secondary btn-sm" href="?pagina=<%= pagina-1 %>&filtro=${filtro}">â† Anterior</a><% } %>
          <span class="page-info">Página <%= pagina %> de <%= totalPaginas %></span>
          <% if (pagina < totalPaginas) { %><a class="btn btn-secondary btn-sm" href="?pagina=<%= pagina+1 %>&filtro=${filtro}">Próxima &#8594;</a><% } %>
        </div>
      </div>
      <% } %>
    </div>
  </div>
</div>
</body>
</html>


