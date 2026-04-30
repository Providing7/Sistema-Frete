<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="br.com.gestaofretes.model.Motorista, br.com.gestaofretes.model.CategoriaCNH,
                 br.com.gestaofretes.model.TipoVinculo, br.com.gestaofretes.model.StatusMotorista" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${motorista != null ? 'Editar' : 'Novo'} Motorista &mdash; Gestão de Fretes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />

  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">${motorista != null ? 'Editar Motorista' : 'Novo Motorista'}</span>
        <span class="topbar-breadcrumb">Cadastro &rsaquo; Motoristas &rsaquo; ${motorista != null ? 'Editar' : 'Novo'}</span>
      </div>
      <div class="topbar-right">
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/motoristas">&larr; Voltar</a>
      </div>
    </header>

    <main class="page-body">

      <% if (request.getAttribute("erro") != null) { %>
        <div class="alert alert-error">&#9888; ${erro}</div>
      <% } %>

      <%
        Motorista m = (Motorista) request.getAttribute("motorista");
        String idVal = m != null && m.getId() != null ? String.valueOf(m.getId()) : "";
      %>

      <form method="post" action="${pageContext.request.contextPath}/motoristas">
        <input type="hidden" name="id" value="<%= idVal %>" />

        <div class="form-card">

          <div class="form-section">
            <div class="form-section-title">Dados Pessoais</div>
            <div class="form-grid">
              <div class="form-group full">
                <label>Nome completo *</label>
                <input type="text" name="nome" value="<%= m != null ? m.getNome() : "" %>" required placeholder="Nome do motorista" />
              </div>
              <div class="form-group">
                <label>CPF *</label>
                <input type="text" name="cpf" data-mask="cpf" value="<%= m != null ? m.getCpf() : "" %>" placeholder="000.000.000-00" required maxlength="14" />
              </div>
              <div class="form-group">
                <label>Data de Nascimento</label>
                <input type="date" name="dataNascimento" value="<%= m != null && m.getDataNascimento() != null ? m.getDataNascimento().toString() : "" %>" min="1940-01-01" max="2010-12-31" />
              </div>
              <div class="form-group">
                <label>Telefone</label>
                <input type="text" name="telefone" data-mask="telefone" value="<%= m != null ? m.getTelefone() : "" %>" placeholder="(00) 00000-0000" maxlength="15" />
              </div>
            </div>
          </div>

          <div class="form-section">
            <div class="form-section-title">CNH</div>
            <div class="form-grid">
              <div class="form-group">
                <label>N&uacute;mero da CNH *</label>
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
                <input type="date" name="cnhValidade" value="<%= m != null && m.getCnhValidade() != null ? m.getCnhValidade().toString() : "" %>" required min="2000-01-01" max="2099-12-31" />
              </div>
            </div>
          </div>

          <div class="form-section">
            <div class="form-section-title">V&iacute;nculo e Status</div>
            <div class="form-grid">
              <div class="form-group">
                <label>Tipo de V&iacute;nculo *</label>
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
          </div>

          <div class="form-actions">
            <button class="btn btn-primary" type="submit">&#128190; Salvar Motorista</button>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/motoristas">Cancelar</a>
          </div>

        </div>
      </form>
    </main>
  </div>
<script src="${pageContext.request.contextPath}/js/masks.js"></script>
</body>
</html>
