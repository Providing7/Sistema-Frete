<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="br.com.gestaofretes.model.Veiculo, br.com.gestaofretes.model.TipoVeiculo,
                 br.com.gestaofretes.model.StatusVeiculo" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${veiculo != null ? 'Editar' : 'Novo'} Ve&iacute;culo &mdash; Gestão de Fretes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />

  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">${veiculo != null ? 'Editar Ve&iacute;culo' : 'Novo Ve&iacute;culo'}</span>
        <span class="topbar-breadcrumb">Cadastro &rsaquo; Ve&iacute;culos &rsaquo; ${veiculo != null ? 'Editar' : 'Novo'}</span>
      </div>
      <div class="topbar-right">
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/veiculos">&larr; Voltar</a>
      </div>
    </header>

    <main class="page-body">

      <% if (request.getAttribute("erro") != null) { %>
        <div class="alert alert-error">&#9888; ${erro}</div>
      <% } %>

      <%
        Veiculo v = (Veiculo) request.getAttribute("veiculo");
        String idVal = v != null && v.getId() != null ? String.valueOf(v.getId()) : "";
      %>

      <form method="post" action="${pageContext.request.contextPath}/veiculos">
        <input type="hidden" name="id" value="<%= idVal %>" />

        <div class="form-card">

          <div class="form-section">
            <div class="form-section-title">Identifica&ccedil;&atilde;o</div>
            <div class="form-grid">
              <div class="form-group">
                <label>Placa *</label>
                <input type="text" name="placa" value="<%= v != null && v.getPlaca() != null ? v.getPlaca() : "" %>"
                       placeholder="ABC1D23" required style="text-transform:uppercase;font-family:monospace;" />
              </div>
              <div class="form-group">
                <label>RNTRC</label>
                <input type="text" name="rntrc" value="<%= v != null && v.getRntrc() != null ? v.getRntrc() : "" %>" placeholder="N&uacute;mero RNTRC" />
              </div>
              <div class="form-group">
                <label>Tipo *</label>
                <select name="tipo" required>
                  <option value="">Selecione...</option>
                  <%
                    TipoVeiculo[] tipos = (TipoVeiculo[]) request.getAttribute("tipos");
                    if (tipos != null) for (TipoVeiculo t : tipos) {
                      boolean sel = v != null && t == v.getTipo();
                  %>
                  <option value="<%= t.name() %>" <%= sel ? "selected" : "" %>><%= t.name() %></option>
                  <% } %>
                </select>
              </div>
              <div class="form-group">
                <label>Ano de Fabrica&ccedil;&atilde;o *</label>
                <input type="number" name="anoFabricacao" value="<%= v != null ? v.getAnoFabricacao() : "" %>"
                       min="1950" max="2030" required />
              </div>
            </div>
          </div>

          <div class="form-section">
            <div class="form-section-title">Capacidades</div>
            <div class="form-grid">
              <div class="form-group">
                <label>Tara (kg)</label>
                <input type="number" name="taraKg" step="0.01" value="<%= v != null ? v.getTaraKg() : "" %>" placeholder="0.00" />
              </div>
              <div class="form-group">
                <label>Capacidade de Carga (kg) *</label>
                <input type="number" name="capacidadeKg" step="0.01" value="<%= v != null ? v.getCapacidadeKg() : "" %>" required placeholder="0.00" />
              </div>
              <div class="form-group">
                <label>Volume (m&sup3;)</label>
                <input type="number" name="volumeM3" step="0.01" value="<%= v != null ? v.getVolumeM3() : "" %>" placeholder="0.00" />
              </div>
              <div class="form-group">
                <label>Status</label>
                <select name="status">
                  <%
                    StatusVeiculo[] statusLista = (StatusVeiculo[]) request.getAttribute("statusLista");
                    if (statusLista != null) for (StatusVeiculo s : statusLista) {
                      boolean sel = v != null ? s == v.getStatus() : s.name().equals("DISPONIVEL");
                  %>
                  <option value="<%= s.name() %>" <%= sel ? "selected" : "" %>><%= s.name() %></option>
                  <% } %>
                </select>
              </div>
            </div>
          </div>

          <div class="form-actions">
            <button class="btn btn-primary" type="submit">&#128190; Salvar Ve&iacute;culo</button>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/veiculos">Cancelar</a>
          </div>

        </div>
      </form>
    </main>
  </div>
</div>
</body>
</html>