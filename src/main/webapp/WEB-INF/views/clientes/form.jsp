<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="br.com.gestaofretes.model.Cliente, br.com.gestaofretes.model.TipoCliente" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>${cliente != null ? 'Editar' : 'Novo'} Cliente</title>
  <style>
    body{font-family:Arial,sans-serif;background:#f0f2f5;}
    .content{padding:32px;max-width:800px;}
    h2{color:#1a3a5c;margin-bottom:24px;}
    .form-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px;}
    .form-group{display:flex;flex-direction:column;gap:4px;}
    .form-group.full{grid-column:1/-1;}
    label{font-size:13px;font-weight:bold;color:#374151;}
    input,select{padding:9px 12px;border:1px solid #cbd5e1;border-radius:4px;font-size:14px;}
    .btn{padding:9px 20px;border:none;border-radius:4px;cursor:pointer;font-size:14px;text-decoration:none;display:inline-block;}
    .btn-primary{background:#1a3a5c;color:white;}
    .btn-secondary{background:#e2e8f0;color:#334155;}
    .acoes{margin-top:24px;display:flex;gap:12px;}
    .alerta-erro{padding:12px 16px;border-radius:4px;margin-bottom:16px;font-size:14px;
                 background:#fee2e2;color:#991b1b;border-left:4px solid #dc2626;}
    .secao{grid-column:1/-1;font-size:12px;font-weight:bold;color:#6b7280;
           text-transform:uppercase;letter-spacing:.05em;margin-top:8px;
           border-bottom:1px solid #e5e7eb;padding-bottom:4px;}
  </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/_nav.jsp" />
<div class="content">
  <h2>${cliente != null ? 'Editar Cliente' : 'Novo Cliente'}</h2>

  <% if (request.getAttribute("erro") != null) { %>
    <div class="alerta-erro">${erro}</div>
  <% } %>

  <%
    Cliente c = (Cliente) request.getAttribute("cliente");
    String idVal  = c != null && c.getId() != null ? String.valueOf(c.getId()) : "";
  %>

  <form method="post" action="${pageContext.request.contextPath}/clientes">
    <input type="hidden" name="id" value="<%= idVal %>" />
    <div class="form-grid">

      <div class="secao">Dados principais</div>

      <div class="form-group full">
        <label>Razão Social *</label>
        <input type="text" name="razaoSocial" value="${cliente.razaoSocial}" required />
      </div>
      <div class="form-group">
        <label>Nome Fantasia</label>
        <input type="text" name="nomeFantasia" value="${cliente.nomeFantasia}" />
      </div>
      <div class="form-group">
        <label>CNPJ *</label>
        <input type="text" name="cnpj" value="${cliente.cnpj}" placeholder="00.000.000/0001-00" required />
      </div>
      <div class="form-group">
        <label>Inscrição Estadual</label>
        <input type="text" name="inscricaoEstadual" value="${cliente.inscricaoEstadual}" />
      </div>
      <div class="form-group">
        <label>Tipo *</label>
        <select name="tipo" required>
          <option value="">Selecione...</option>
          <%
            TipoCliente[] tipos = (TipoCliente[]) request.getAttribute("tiposCliente");
            if (tipos != null) for (TipoCliente t : tipos) {
              boolean sel = c != null && t == c.getTipo();
          %>
          <option value="<%= t.name() %>" <%= sel ? "selected" : "" %>><%= t.name() %></option>
          <% } %>
        </select>
      </div>
      <div class="form-group">
        <label>Status</label>
        <select name="ativo">
          <option value="true"  <%= c == null || c.isAtivo()  ? "selected" : "" %>>Ativo</option>
          <option value="false" <%= c != null && !c.isAtivo() ? "selected" : "" %>>Inativo</option>
        </select>
      </div>

      <div class="secao">Endereço</div>

      <div class="form-group full">
        <label>Logradouro</label>
        <input type="text" name="logradouro" value="${cliente.logradouro}" />
      </div>
      <div class="form-group">
        <label>Número</label>
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
        <label>Município</label>
        <input type="text" name="municipio" value="${cliente.municipio}" />
      </div>
      <div class="form-group">
        <label>UF</label>
        <input type="text" name="uf" value="${cliente.uf}" maxlength="2" style="text-transform:uppercase;" />
      </div>
      <div class="form-group">
        <label>CEP</label>
        <input type="text" name="cep" value="${cliente.cep}" />
      </div>

      <div class="secao">Contato</div>

      <div class="form-group">
        <label>Telefone</label>
        <input type="text" name="telefone" value="${cliente.telefone}" />
      </div>
      <div class="form-group">
        <label>E-mail</label>
        <input type="email" name="email" value="${cliente.email}" />
      </div>
    </div>

    <div class="acoes">
      <button class="btn btn-primary" type="submit">Salvar</button>
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/clientes">Cancelar</a>
    </div>
  </form>
</div>
</body>
</html>
