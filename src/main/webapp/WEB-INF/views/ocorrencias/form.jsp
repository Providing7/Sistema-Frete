<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="br.com.gestaofretes.model.Frete, br.com.gestaofretes.model.TipoOcorrencia" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Nova Ocorr&ecirc;ncia &mdash; Gestão de Fretes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <script src="${pageContext.request.contextPath}/js/masks.js"></script>
  <script>
    function toggleCampos() {
      var tipo = document.getElementById('tipo').value;
      var descDiv   = document.getElementById('div-descricao');
      var recebDiv  = document.getElementById('div-recebedor');
      var recebCamp = document.querySelectorAll('#div-recebedor input');
      var descArea  = document.getElementById('descricao');

      var precisaDesc = (tipo === 'AVARIA' || tipo === 'EXTRAVIO' || tipo === 'OUTROS' || tipo === 'ENTREGA_REALIZADA');
      var precisaRec  = (tipo === 'ENTREGA_REALIZADA');

      descDiv.style.display  = precisaDesc ? 'block' : 'none';
      recebDiv.style.display = precisaRec  ? 'block' : 'none';

      recebCamp.forEach(function(el) { el.required = precisaRec; });
      descArea.required = precisaDesc;
    }

    document.addEventListener('DOMContentLoaded', function () {
      // Limita o campo datetime-local: min = 2 anos atrás, max = agora (sem futuro)
      var agora = new Date();
      var minDate = new Date(agora);
      minDate.setFullYear(agora.getFullYear() - 2);

      function toLocalDateTimeString(d) {
        var pad = function(n) { return n < 10 ? '0' + n : n; };
        return d.getFullYear() + '-' + pad(d.getMonth()+1) + '-' + pad(d.getDate())
             + 'T' + pad(d.getHours()) + ':' + pad(d.getMinutes());
      }

      var campo = document.getElementById('dataHora');
      campo.min = toLocalDateTimeString(minDate);
      campo.max = toLocalDateTimeString(agora);
      campo.value = toLocalDateTimeString(agora); // pré-preenche com a hora atual

      // Validação extra: bloqueia ano fora do intervalo válido ao sair do campo
      campo.addEventListener('blur', function () {
        if (!campo.value) return;
        var val = new Date(campo.value);
        if (val > agora) {
          alert('A data/hora da ocorrência não pode ser no futuro.');
          campo.value = toLocalDateTimeString(agora);
        } else if (val < minDate) {
          alert('A data/hora não pode ser anterior a 2 anos atrás.');
          campo.value = toLocalDateTimeString(minDate);
        }
      });

      // UF em maiúsculas
      document.getElementById('uf').addEventListener('input', function () {
        this.value = this.value.toUpperCase().replace(/[^A-Z]/g, '').substring(0, 2);
      });
    });
  </script>
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />
  <div class="app-main">
    <% Frete frete = (Frete) request.getAttribute("frete"); %>
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">Nova Ocorr&ecirc;ncia</span>
        <span class="topbar-breadcrumb">Fretes &rsaquo; <%= frete != null ? frete.getNumero() : "" %> &rsaquo; Ocorr&ecirc;ncia</span>
      </div>
      <div class="topbar-right">
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/fretes?acao=detalhe&id=<%= frete != null ? frete.getId() : "" %>">&larr; Voltar</a>
      </div>
    </header>
    <main class="page-body">
      <% if (request.getAttribute("erro") != null) { %>
        <div class="alert alert-error">&#9888; ${erro}</div>
      <% } %>
      <form method="post" action="${pageContext.request.contextPath}/ocorrencias">
        <input type="hidden" name="idFrete" value="<%= frete != null ? frete.getId() : "" %>"/>
        <div class="form-card">
          <div class="form-section">
            <div class="form-section-title">Dados da Ocorr&ecirc;ncia</div>
            <div class="form-grid">
              <div class="form-group">
                <label>Tipo *</label>
                <select id="tipo" name="tipo" required onchange="toggleCampos()">
                  <option value="">-- Selecione --</option>
                  <%
                    TipoOcorrencia[] tipos = (TipoOcorrencia[]) request.getAttribute("tiposOcorrencia");
                    if (tipos != null) { for (TipoOcorrencia t : tipos) {
                  %>
                    <option value="<%= t.name() %>"><%= t.name().replace("_", " ") %></option>
                  <% } } %>
                </select>
              </div>
              <div class="form-group">
                <label>Data e Hora *</label>
                <input type="datetime-local" id="dataHora" name="dataHora" required />
                <span style="font-size:11px;color:var(--gray-500);">Não pode ser no futuro nem anterior a 2 anos atrás.</span>
              </div>
              <div class="form-group">
                <label>Munic&iacute;pio</label>
                <input type="text" name="municipio" placeholder="Cidade onde ocorreu" />
              </div>
              <div class="form-group">
                <label>UF</label>
                <input type="text" id="uf" name="uf" maxlength="2" placeholder="SP" />
              </div>
            </div>
          </div>

          <div id="div-descricao" class="form-section" style="display:none;">
            <div class="form-section-title">Descri&ccedil;&atilde;o</div>
            <div class="form-grid">
              <div class="form-group full">
                <label>Descri&ccedil;&atilde;o *</label>
                <textarea id="descricao" name="descricao" rows="3" placeholder="Descreva o que aconteceu..."></textarea>
              </div>
            </div>
          </div>

          <div id="div-recebedor" class="form-section" style="display:none;">
            <div class="form-section-title">Dados do Recebedor</div>
            <div class="form-grid">
              <div class="form-group">
                <label>Nome do Recebedor *</label>
                <input type="text" name="nomeRecebedor" placeholder="Nome completo" />
              </div>
              <div class="form-group">
                <label>Documento (CPF/RG) *</label>
                <input type="text" name="documentoRecebedor" data-mask="cpf" placeholder="000.000.000-00" />
              </div>
            </div>
          </div>

        </div>
        <div style="display:flex;gap:12px;margin-top:8px;">
          <button type="submit" class="btn btn-primary">&#43; Registrar Ocorr&ecirc;ncia</button>
          <a href="${pageContext.request.contextPath}/fretes?acao=detalhe&id=<%= frete != null ? frete.getId() : "" %>" class="btn btn-secondary">Cancelar</a>
        </div>
      </form>
    </main>
  </div>
</div>
</body>
</html>
