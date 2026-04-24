<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="br.com.gestaofretes.model.Motorista, br.com.gestaofretes.model.CategoriaCNH,
                 br.com.gestaofretes.model.TipoVinculo, br.com.gestaofretes.model.StatusMotorista" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>${motorista != null ? 'Editar' : 'Novo'} Motorista</title>
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
  <h2>${motorista != null ? 'Editar Motorista' : 'Novo Motorista'}</h2>

  <% if (request.getAttribute("erro") != null) { %>
    <div class="alerta-erro">${erro}</div>
  <% } %>

  <%
    Motorista m = (Motorista) request.getAttribute("motorista");
    String idVal = m != null && m.getId() != null ? String.valueOf(m.getId()) : "";
  %>

  <form method="post" action="${pageContext.request.contextPath}/motoristas">
    <input type="hidden" name="id" value="<%= idVal %>" />
    <div class="form-grid">

      <div class="secao">Dados Pessoais</div>

      <div class="form-group full">
        <label>Nome *</label>
        <input type="text" name="nome" value="<%= m != null ? m.getNome() : "" %>" required />
      </div>
      <div class="form-group">
        <label>CPF *</label>
        <input type="text" name="cpf" value="<%= m != null ? m.getCpf() : "" %>" placeholder="000.000.000-00" required />
      </div>
      <div class="form-group">
        <label>Data de Nascimento</label>
        <input type="date" name="dataNascimento" value="<%= m != null && m.getDataNascimento() != null ? m.getDataNascimento().toString() : "" %>" />
      </div>
      <div class="form-group">
        <label>Telefone</label>
        <input type="text" name="telefone" value="<%= m != null ? m.getTelefone() : "" %>" />
      </div>

      <div class="secao">CNH</div>

      <div class="form-group">
        <label>Número da CNH *</label>
        <input type="text" name="cnhNumero" value="<%= m != null ? m.getCnhNumero() : "" %>" required />
      </div>
      <div class="form-group">
        <label>Categoria *</label>
        <select name="cnhCategoria" required>
          <option value="">Selecione...</option>
          <%
            CategoriaCNH[] categorias = (CategoriaCNH[]) request.getAttribute("categorias");
            if (categorias != null) for (CategoriaCNH cat : categorias) {
              boolean sel = m != null && cat == m.getCnhCategoria();
          %>
          <option value="<%= cat.name() %>" <%= sel ? "selected" : "" %>><%= cat.name() %></option>
          <% } %>
        </select>
      </div>
      <div class="form-group">
        <label>Validade da CNH *</label>
        <input type="date" name="cnhValidade" value="<%= m != null && m.getCnhValidade() != null ? m.getCnhValidade().toString() : "" %>" required />
      </div>

      <div class="secao">Vínculo e Status</div>

      <div class="form-group">
        <label>Tipo de Vínculo *</label>
        <select name="tipoVinculo" required>
          <option value="">Selecione...</option>
          <%
            TipoVinculo[] vinculos = (TipoVinculo[]) request.getAttribute("vinculos");
            if (vinculos != null) for (TipoVinculo v : vinculos) {
              boolean sel = m != null && v == m.getTipoVinculo();
          %>
          <option value="<%= v.name() %>" <%= sel ? "selected" : "" %>><%= v.name() %></option>
          <% } %>
        </select>
      </div>
      <div class="form-group">
        <label>Status</label>
        <select name="status">
          <%
            StatusMotorista[] statusLista = (StatusMotorista[]) request.getAttribute("statusLista");
            if (statusLista != null) for (StatusMotorista s : statusLista) {
              boolean sel = m != null ? s == m.getStatus() : s.name().equals("ATIVO");
          %>
          <option value="<%= s.name() %>" <%= sel ? "selected" : "" %>><%= s.name() %></option>
          <% } %>
        </select>
      </div>

    </div>
    <div class="acoes">
      <button class="btn btn-primary" type="submit">Salvar</button>
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/motoristas">Cancelar</a>
    </div>
  </form>
</div>
</body>
</html>
