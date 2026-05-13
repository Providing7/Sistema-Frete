<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,br.com.gestaofretes.cliente.Cliente,br.com.gestaofretes.motorista.Motorista,br.com.gestaofretes.veiculo.Veiculo" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Novo Frete &mdash; Gestão de Fretes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <script src="${pageContext.request.contextPath}/js/masks.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function () {

      var selRem  = document.getElementById('idRemetente');
      var selDest = document.getElementById('idDestinatario');

      // Impede selecionar o mesmo cliente nos dois selects
      function sincronizarSelects() {
        var remVal  = selRem.value;
        var destVal = selDest.value;

        // Restaura todas as opções
        Array.from(selRem.options).forEach(function(opt)  { opt.hidden = false; });
        Array.from(selDest.options).forEach(function(opt) { opt.hidden = false; });

        // Oculta no destinatário a opção já escolhida como remetente
        if (remVal) {
          var optDest = selDest.querySelector('option[value="' + remVal + '"]');
          if (optDest) optDest.hidden = true;
          // Se o destinatário estava com o mesmo valor, limpa
          if (selDest.value === remVal) selDest.value = '';
        }

        // Oculta no remetente a opção já escolhida como destinatário
        if (destVal) {
          var optRem = selRem.querySelector('option[value="' + destVal + '"]');
          if (optRem) optRem.hidden = true;
          if (selRem.value === destVal) selRem.value = '';
        }
      }

      selRem.addEventListener('change',  sincronizarSelects);
      selDest.addEventListener('change', sincronizarSelects);

      // Data prevista: mínimo = amanhã
      var dataPrevisao = document.getElementById('dataPrevisaoEntrega');
      var amanha = new Date();
      amanha.setDate(amanha.getDate() + 1);
      var pad = function(n) { return n < 10 ? '0' + n : n; };
      dataPrevisao.min = amanha.getFullYear() + '-' + pad(amanha.getMonth()+1) + '-' + pad(amanha.getDate());

      // UF em maiúsculas
      document.querySelectorAll('.campo-uf').forEach(function(el) {
        el.addEventListener('input', function() {
          this.value = this.value.toUpperCase().replace(/[^A-Z]/g, '').substring(0, 2);
        });
      });

      // Calcula ICMS e valor total automaticamente
      var campoValor  = document.getElementById('valorFrete');
      var campoAliq   = document.getElementById('aliquotaIcms');
      var spanIcms    = document.getElementById('previewIcms');
      var spanTotal   = document.getElementById('previewTotal');

      function calcularTotais() {
        var valor = parseFloat(campoValor.value) || 0;
        var aliq  = parseFloat(campoAliq.value)  || 0;
        var icms  = valor * aliq / 100;
        var total = valor + icms;
        spanIcms.textContent  = 'R$ ' + icms.toFixed(2);
        spanTotal.textContent = 'R$ ' + total.toFixed(2);
      }

      campoValor.addEventListener('input', calcularTotais);
      campoAliq.addEventListener('input',  calcularTotais);
    });
  </script>
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />

  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">Emitir Frete</span>
        <span class="topbar-breadcrumb">Operacional &rsaquo; Fretes &rsaquo; Novo</span>
      </div>
      <div class="topbar-right">
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/fretes">&larr; Voltar</a>
      </div>
    </header>

    <main class="page-body">

      <% if (request.getAttribute("erro") != null) { %>
        <div class="alert alert-error">&#9888; ${erro}</div>
      <% } %>

      <%
        List<Cliente>   clientes   = (List<Cliente>)   request.getAttribute("clientes");
        List<Motorista> motoristas = (List<Motorista>) request.getAttribute("motoristas");
        List<Veiculo>   veiculos   = (List<Veiculo>)   request.getAttribute("veiculos");
      %>

      <form method="post" action="${pageContext.request.contextPath}/fretes">
        <input type="hidden" name="acao" value="salvar" />

        <div class="form-card">

          <!-- ===== Partes envolvidas ===== -->
          <div class="form-section">
            <div class="form-section-title">Partes Envolvidas</div>
            <div class="form-grid">
              <div class="form-group">
                <label>Remetente *</label>
                <select id="idRemetente" name="idRemetente" required>
                  <option value="">-- Selecione o remetente --</option>
                  <% String fRem = (String) request.getAttribute("formIdRemetente");
                     if (clientes != null) { for (Cliente c : clientes) { %>
                    <option value="<%= c.getId() %>" <%= String.valueOf(c.getId()).equals(fRem) ? "selected" : "" %>><%= c.getRazaoSocial() %></option>
                  <% } } %>
                </select>
              </div>
              <div class="form-group">
                <label>Destinat&aacute;rio *</label>
                <select id="idDestinatario" name="idDestinatario" required>
                  <option value="">-- Selecione o destinat&aacute;rio --</option>
                  <% String fDest = (String) request.getAttribute("formIdDestinatario");
                     if (clientes != null) { for (Cliente c : clientes) { %>
                    <option value="<%= c.getId() %>" <%= String.valueOf(c.getId()).equals(fDest) ? "selected" : "" %>><%= c.getRazaoSocial() %></option>
                  <% } } %>
                </select>
              </div>
              <div class="form-group">
                <label>Motorista *</label>
                <select id="idMotorista" name="idMotorista" required>
                  <option value="">-- Selecione o motorista --</option>
                  <% String fMot = (String) request.getAttribute("formIdMotorista");
                     if (motoristas != null) { for (Motorista m : motoristas) { %>
                    <option value="<%= m.getId() %>" <%= String.valueOf(m.getId()).equals(fMot) ? "selected" : "" %>><%= m.getNome() %></option>
                  <% } } %>
                </select>
              </div>
              <div class="form-group">
                <label>Ve&iacute;culo *</label>
                <select id="idVeiculo" name="idVeiculo" required>
                  <option value="">-- Selecione o ve&iacute;culo --</option>
                  <% String fVei = (String) request.getAttribute("formIdVeiculo");
                     if (veiculos != null) { for (Veiculo v : veiculos) { %>
                    <option value="<%= v.getId() %>" <%= String.valueOf(v.getId()).equals(fVei) ? "selected" : "" %>><%= v.getPlaca() %> &mdash; <%= v.getTipo() != null ? v.getTipo().name() : "" %></option>
                  <% } } %>
                </select>
              </div>
            </div>
          </div>

          <!-- ===== Rota ===== -->
          <div class="form-section">
            <div class="form-section-title">Rota</div>
            <div class="form-grid">
              <div class="form-group">
                <label>Munic&iacute;pio de Origem *</label>
                <input type="text" id="municipioOrigem" name="municipioOrigem" required
                       placeholder="Ex: São Paulo" maxlength="100"
                       value="<%= request.getAttribute("formMunicipioOrigem") != null ? request.getAttribute("formMunicipioOrigem") : "" %>" />
              </div>
              <div class="form-group">
                <label>UF Origem *</label>
                <input type="text" id="ufOrigem" name="ufOrigem" required
                       class="campo-uf" maxlength="2" placeholder="SP"
                       value="<%= request.getAttribute("formUfOrigem") != null ? request.getAttribute("formUfOrigem") : "" %>" />
              </div>
              <div class="form-group">
                <label>Munic&iacute;pio de Destino *</label>
                <input type="text" id="municipioDestino" name="municipioDestino" required
                       placeholder="Ex: Curitiba" maxlength="100"
                       value="<%= request.getAttribute("formMunicipioDestino") != null ? request.getAttribute("formMunicipioDestino") : "" %>" />
              </div>
              <div class="form-group">
                <label>UF Destino *</label>
                <input type="text" id="ufDestino" name="ufDestino" required
                       class="campo-uf" maxlength="2" placeholder="PR"
                       value="<%= request.getAttribute("formUfDestino") != null ? request.getAttribute("formUfDestino") : "" %>" />
              </div>
            </div>
          </div>

          <!-- ===== Carga ===== -->
          <div class="form-section">
            <div class="form-section-title">Carga</div>
            <div class="form-grid">
              <div class="form-group full">
                <label>Descri&ccedil;&atilde;o da Carga</label>
                <input type="text" id="descricaoCarga" name="descricaoCarga"
                       placeholder="Ex: Eletrodomésticos" maxlength="300"
                       value="<%= request.getAttribute("formDescricaoCarga") != null ? request.getAttribute("formDescricaoCarga") : "" %>" />
              </div>
              <div class="form-group">
                <label>Peso Bruto (kg) *</label>
                <input type="text" id="pesoKg" name="pesoKg" required
                       data-mask="decimal" inputmode="decimal" placeholder="0.00"
                       value="<%= request.getAttribute("formPesoKg") != null ? request.getAttribute("formPesoKg") : "" %>" />
              </div>
              <div class="form-group">
                <label>Volumes *</label>
                <input type="number" id="volumes" name="volumes" required
                       min="1" max="99999" placeholder="Qtd. de volumes"
                       value="<%= request.getAttribute("formVolumes") != null ? request.getAttribute("formVolumes") : "" %>" />
              </div>
            </div>
          </div>

          <!-- ===== Financeiro ===== -->
          <div class="form-section">
            <div class="form-section-title">Financeiro</div>
            <div class="form-grid">
              <div class="form-group">
                <label>Valor do Frete (R$) *</label>
                <input type="text" id="valorFrete" name="valorFrete" required
                       data-mask="decimal" inputmode="decimal" placeholder="0.00"
                       value="<%= request.getAttribute("formValorFrete") != null ? request.getAttribute("formValorFrete") : "" %>" />
              </div>
              <div class="form-group">
                <label>Al&iacute;quota ICMS (%) *</label>
                <input type="text" id="aliquotaIcms" name="aliquotaIcms" required
                       data-mask="decimal" inputmode="decimal" placeholder="12.00"
                       value="<%= request.getAttribute("formAliquotaIcms") != null ? request.getAttribute("formAliquotaIcms") : "12.00" %>" />
              </div>
              <!-- Preview calculado em tempo real (só informativo) -->
              <div class="form-group">
                <label>Valor ICMS (calculado)</label>
                <div style="padding:8px 12px;background:var(--gray-100);border-radius:var(--radius);font-size:14px;font-weight:600;color:var(--gray-700);">
                  <span id="previewIcms">R$ 0.00</span>
                </div>
              </div>
              <div class="form-group">
                <label>Valor Total (calculado)</label>
                <div style="padding:8px 12px;background:var(--primary-light);border-radius:var(--radius);font-size:14px;font-weight:700;color:var(--primary-dark);">
                  <span id="previewTotal">R$ 0.00</span>
                </div>
              </div>
            </div>
          </div>

          <!-- ===== Datas ===== -->
          <div class="form-section">
            <div class="form-section-title">Datas</div>
            <div class="form-grid">
              <div class="form-group">
                <label>Data Prevista de Entrega *</label>
                <input type="date" id="dataPrevisaoEntrega" name="dataPrevisaoEntrega" required
                       value="<%= request.getAttribute("formDataPrevisaoEntrega") != null ? request.getAttribute("formDataPrevisaoEntrega") : "" %>" />
                <span style="font-size:11px;color:var(--gray-500);">Deve ser posterior à data de hoje.</span>
              </div>
            </div>
          </div>

        </div><!-- /form-card -->

        <div style="display:flex;gap:12px;margin-top:8px;">
          <button type="submit" class="btn btn-primary">&#128228; Emitir Frete</button>
          <a href="${pageContext.request.contextPath}/fretes" class="btn btn-secondary">Cancelar</a>
        </div>
      </form>

    </main>
  </div>
</div>

<% String erroCampoVal = (String) request.getAttribute("erroCampo"); %>
<% if (erroCampoVal != null) { %>
<script>
(function () {
  var campo = document.getElementById('<%= erroCampoVal %>');
  if (!campo) return;
  campo.style.outline = '2px solid #e74c3c';
  campo.style.boxShadow = '0 0 0 3px rgba(231,76,60,0.18)';
  campo.scrollIntoView({ behavior: 'smooth', block: 'center' });
  campo.focus();
})();
</script>
<% } %>

</body>
</html>
