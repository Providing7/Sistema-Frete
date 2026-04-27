<%@ page contentType="text/html;charset=ISO-8859-1" language="java" %>
<%@ page import="br.com.gestaofretes.model.Veiculo, br.com.gestaofretes.model.TipoVeiculo,
                 br.com.gestaofretes.model.StatusVeiculo" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="ISO-8859-1">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Veículo &#8212; Gestão de Fretes</title>

</head>
<body>
<jsp:include page="/WEB-INF/views/_nav.jsp" />
<div class="main-wrapper">

  <div class="page-header">
    <div>
      <h1>${veiculo != null ? '&#9999; Editar Veículo' : '&#10133; Novo Veículo'}</h1>
      <div class="breadcrumb">Cadastro &#8594; Veículos &#8594; ${veiculo != null ? 'Editar' : 'Novo'}</div>
    </div>
    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/veiculos">â† Voltar</a>
  </div>

  <div class="page-content">
    <% if (request.getAttribute("erro") != null) { %>
      <div class="alert alert-error">&#9888; ${erro}</div>
    <% } %>

    <%
      Veiculo v = (Veiculo) request.getAttribute("veiculo");
      String idVal = v != null && v.getId() != null ? String.valueOf(v.getId()) : "";
    %>

    <div class="card form-card">
      <div class="card-header">
        <h3>Dados do Veículo</h3>
      </div>
      <div class="card-body">
        <form method="post" action="${pageContext.request.contextPath}/veiculos">
          <input type="hidden" name="id" value="<%= idVal %>" />
          <div class="form-grid">

            <div class="form-section-title">Identificação</div>

            <div class="form-group">
              <label>Placa <span class="required">*</span></label>
              <input type="text" name="placa" value="<%= v != null ? v.getPlaca() : "" %>"
                     placeholder="ABC1D23 ou ABC-1234" required style="text-transform:uppercase;" />
            </div>
            <div class="form-group">
              <label>RNTRC</label>
              <input type="text" name="rntrc" value="<%= v != null ? v.getRntrc() : "" %>" placeholder="Número do RNTRC" />
            </div>
            <div class="form-group">
              <label>Tipo <span class="required">*</span></label>
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
              <label>Ano de Fabricação <span class="required">*</span></label>
              <input type="number" name="anoFabricacao" value="<%= v != null ? v.getAnoFabricacao() : "" %>"
                     min="1950" max="2030" required />
            </div>

            <div class="form-section-title">Capacidades</div>

            <div class="form-group">
              <label>Tara (kg)</label>
              <input type="number" name="taraKg" step="0.01" value="<%= v != null ? v.getTaraKg() : "" %>" placeholder="0.00" />
            </div>
            <div class="form-group">
              <label>Capacidade de Carga (kg) <span class="required">*</span></label>
              <input type="number" name="capacidadeKg" step="0.01" value="<%= v != null ? v.getCapacidadeKg() : "" %>" required placeholder="0.00" />
            </div>
            <div class="form-group">
              <label>Volume (m³)</label>
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

          <div class="form-actions">
            <button class="btn btn-primary btn-lg" type="submit">&#128190; Salvar Veículo</button>
            <a class="btn btn-secondary btn-lg" href="${pageContext.request.contextPath}/veiculos">Cancelar</a>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>
</body>
</html>


