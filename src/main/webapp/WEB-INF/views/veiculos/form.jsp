<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="br.com.gestaofretes.model.Veiculo, br.com.gestaofretes.model.TipoVeiculo,
                 br.com.gestaofretes.model.StatusVeiculo" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>${veiculo != null ? 'Editar' : 'Novo'} Veículo</title>
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
  <h2>${veiculo != null ? 'Editar Veículo' : 'Novo Veículo'}</h2>

  <% if (request.getAttribute("erro") != null) { %>
    <div class="alerta-erro">${erro}</div>
  <% } %>

  <%
    Veiculo v = (Veiculo) request.getAttribute("veiculo");
    String idVal = v != null && v.getId() != null ? String.valueOf(v.getId()) : "";
  %>

  <form method="post" action="${pageContext.request.contextPath}/veiculos">
    <input type="hidden" name="id" value="<%= idVal %>" />
    <div class="form-grid">

      <div class="secao">Identificação</div>

      <div class="form-group">
        <label>Placa *</label>
        <input type="text" name="placa" value="<%= v != null ? v.getPlaca() : "" %>"
               placeholder="ABC1D23 ou ABC-1234" required style="text-transform:uppercase;" />
      </div>
      <div class="form-group">
        <label>RNTRC</label>
        <input type="text" name="rntrc" value="<%= v != null ? v.getRntrc() : "" %>" />
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
        <label>Ano de Fabricação *</label>
        <input type="number" name="anoFabricacao" value="<%= v != null ? v.getAnoFabricacao() : "" %>"
               min="1950" max="2030" required />
      </div>

      <div class="secao">Capacidades</div>

      <div class="form-group">
        <label>Tara (kg)</label>
        <input type="number" name="taraKg" step="0.01" value="<%= v != null ? v.getTaraKg() : "" %>" />
      </div>
      <div class="form-group">
        <label>Capacidade de Carga (kg) *</label>
        <input type="number" name="capacidadeKg" step="0.01" value="<%= v != null ? v.getCapacidadeKg() : "" %>" required />
      </div>
      <div class="form-group">
        <label>Volume (m³)</label>
        <input type="number" name="volumeM3" step="0.01" value="<%= v != null ? v.getVolumeM3() : "" %>" />
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
    <div class="acoes">
      <button class="btn btn-primary" type="submit">Salvar</button>
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/veiculos">Cancelar</a>
    </div>
  </form>
</div>
</body>
</html>
