<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="br.com.gestaofretes.cliente.Cliente" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${cliente != null ? 'Editar' : 'Novo'} Cliente &mdash; Gestão de Fretes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <script src="${pageContext.request.contextPath}/js/masks.js"></script>
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />

  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">${cliente != null ? 'Editar Cliente' : 'Novo Cliente'}</span>
        <span class="topbar-breadcrumb">Cadastro &rsaquo; Clientes &rsaquo; ${cliente != null ? 'Editar' : 'Novo'}</span>
      </div>
      <div class="topbar-right">
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/clientes">&larr; Voltar</a>
      </div>
    </header>

    <main class="page-body">

      <% if (request.getAttribute("erro") != null) { %>
        <div class="alert alert-error">&#9888; ${erro}</div>
      <% } %>

      <%
        Cliente c = (Cliente) request.getAttribute("cliente");
        String idVal = c != null && c.getId() != null ? String.valueOf(c.getId()) : "";
      %>

      <form method="post" action="${pageContext.request.contextPath}/clientes">
        <input type="hidden" name="id" value="<%= idVal %>" />

        <div class="form-card">

          <!-- Seção: Dados Principais -->
          <div class="form-section">
            <div class="form-section-title">Dados Principais</div>
            <div class="form-grid">
              <div class="form-group full">
                <label>Raz&atilde;o Social *</label>
                <input type="text" name="razaoSocial" value="${cliente.razaoSocial}" required placeholder="Nome oficial da empresa" />
              </div>
              <div class="form-group">
                <label>Nome Fantasia</label>
                <input type="text" name="nomeFantasia" value="${cliente.nomeFantasia}" placeholder="Nome comercial" />
              </div>
              <div class="form-group">
                <label>CNPJ *</label>
                <input type="text" name="cnpj" data-mask="cnpj"
       				value="${cliente.cnpj}" placeholder="00.000.000/0001-00" required maxlength="18" />
              </div>
              <div class="form-group">
                <label>Inscri&ccedil;&atilde;o Estadual</label>
                <input type="text" name="inscricaoEstadual" value="${cliente.inscricaoEstadual}" />
              </div>
              <div class="form-group">
                <label>Status</label>
                <select name="ativo">
                  <option value="true"  <%= c == null || c.isAtivo()  ? "selected" : "" %>>Ativo</option>
                  <option value="false" <%= c != null && !c.isAtivo() ? "selected" : "" %>>Inativo</option>
                </select>
              </div>
            </div>
          </div>

          <!-- Seção: Endereço -->
          <div class="form-section">
            <div class="form-section-title">Endere&ccedil;o</div>
            <div class="form-grid">
              <div class="form-group full">
                <label>Logradouro</label>
                <input type="text" name="logradouro" value="${cliente.logradouro}" placeholder="Rua, Avenida..." />
              </div>
              <div class="form-group">
                <label>N&uacute;mero</label>
                <input type="text" name="numero" value="${cliente.numero}" />
              </div>
              <div class="form-group">
                <label>Complemento</label>
                <input type="text" name="complemento" value="${cliente.complemento}" />
              </div>
              <div class="form-group">
                <label>Bairro</label>
                <input type="text" name="bairro" value="${cliente.bairro}" />
              </div>
              <div class="form-group">
                <label>Munic&iacute;pio</label>
                <input type="text" name="municipio" value="${cliente.municipio}" />
              </div>
              <div class="form-group">
                <label>UF</label>
                <input type="text" name="uf" value="${cliente.uf}" maxlength="2" placeholder="SP" style="text-transform:uppercase;" />
              </div>
              <div class="form-group">
                <label>CEP</label>
                <input type="text" name="cep" data-mask="cep"
       				value="${cliente.cep}" placeholder="00000-000" maxlength="9" />
              </div>
            </div>
          </div>

          <!-- Seção: Contato -->
          <div class="form-section">
            <div class="form-section-title">Contato</div>
            <div class="form-grid">
              <div class="form-group">
                <label>Telefone</label>
                <input type="text" name="telefone" data-mask="telefone"
       				value="${cliente.telefone}" placeholder="(00) 00000-0000" maxlength="15" />
              </div>
              <div class="form-group">
                <label>E-mail</label>
                <input type="email" name="email" value="${cliente.email}" placeholder="email@empresa.com.br" />
              </div>
            </div>
          </div>

          <!-- Ações -->
          <div class="form-actions">
            <button class="btn btn-primary" type="submit">&#128190; Salvar Cliente</button>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/clientes">Cancelar</a>
          </div>

        </div>
      </form>
    </main>
  </div>
</div>
</body>
</html>