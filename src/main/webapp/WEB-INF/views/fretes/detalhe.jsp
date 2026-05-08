<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="br.com.gestaofretes.frete.Frete,br.com.gestaofretes.frete.StatusFrete,br.com.gestaofretes.ocorrencia.OcorrenciaFrete,
                 java.util.List" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Detalhe do Frete &mdash; FretesTMS</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />

  <div class="app-main">
    <%
      Frete frete = (Frete) request.getAttribute("frete");
      String ctx  = request.getContextPath();
      String num  = frete != null ? frete.getNumero() : "—";
    %>
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">Frete</span>
        <span class="topbar-breadcrumb">Operacional &rsaquo; Fretes &rsaquo; <%= num %></span>
      </div>
      <div class="topbar-right">
        <a class="btn btn-secondary" href="<%= ctx %>/fretes">
          <i class="bi bi-arrow-left"></i> Voltar
        </a>
      </div>
    </header>

    <main class="page-body">

      <% if (request.getAttribute("erro") != null) { %>
        <div class="alert alert-error"><i class="bi bi-exclamation-circle-fill"></i> ${erro}</div>
      <% } %>
      <% if (request.getParameter("sucesso") != null) { %>
        <div class="alert alert-success"><i class="bi bi-check-circle-fill"></i> ${param.sucesso}</div>
      <% } %>

      <% if (frete != null) {
           String badgeClass;
           String labelStatus;
           switch (frete.getStatus()) {
             case EMITIDO:          badgeClass = "badge-emitido";          labelStatus = "Emitido";           break;
             case SAIDA_CONFIRMADA: badgeClass = "badge-saida_confirmada"; labelStatus = "Sa&iacute;da Confirmada"; break;
             case EM_TRANSITO:      badgeClass = "badge-em_transito";      labelStatus = "Em Tr&acirc;nsito"; break;
             case ENTREGUE:         badgeClass = "badge-entregue";         labelStatus = "Entregue";          break;
             case NAO_ENTREGUE:     badgeClass = "badge-nao_entregue";     labelStatus = "N&atilde;o Entregue"; break;
             case CANCELADO:        badgeClass = "badge-cancelado";        labelStatus = "Cancelado";         break;
             default:               badgeClass = "badge-cancelado";        labelStatus = frete.getStatus().name();
           }
      %>

      <!-- Cabeçalho do frete -->
      <div class="card" style="margin-bottom:16px;">
        <div class="frete-header">
          <span class="frete-numero"><%= frete.getNumero() %></span>
          <span class="badge <%= badgeClass %>" style="font-size:12px;padding:4px 12px;"><%= labelStatus %></span>
        </div>

        <div class="detail-grid">
          <div class="detail-item">
            <div class="detail-label">Remetente</div>
            <div class="detail-value"><%= frete.getRemetente() != null ? frete.getRemetente().getRazaoSocial() : "&mdash;" %></div>
          </div>
          <div class="detail-item">
            <div class="detail-label">Destinat&aacute;rio</div>
            <div class="detail-value"><%= frete.getDestinatario() != null ? frete.getDestinatario().getRazaoSocial() : "&mdash;" %></div>
          </div>
          <div class="detail-item">
            <div class="detail-label">Motorista</div>
            <div class="detail-value"><%= frete.getMotorista() != null ? frete.getMotorista().getNome() : "&mdash;" %></div>
          </div>
          <div class="detail-item">
            <div class="detail-label">Ve&iacute;culo</div>
            <div class="detail-value"><%= frete.getVeiculo() != null ? frete.getVeiculo().getPlaca() : "&mdash;" %></div>
          </div>
          <div class="detail-item">
            <div class="detail-label">Origem</div>
            <div class="detail-value"><%= frete.getMunicipioOrigem() %> &mdash; <%= frete.getUfOrigem() %></div>
          </div>
          <div class="detail-item">
            <div class="detail-label">Destino</div>
            <div class="detail-value"><%= frete.getMunicipioDestino() %> &mdash; <%= frete.getUfDestino() %></div>
          </div>
          <div class="detail-item">
            <div class="detail-label">Data de Emiss&atilde;o</div>
            <div class="detail-value"><%= frete.getDataEmissao() %></div>
          </div>
          <div class="detail-item">
            <div class="detail-label">Previs&atilde;o de Entrega</div>
            <div class="detail-value"><%= frete.getDataPrevisaoEntrega() %></div>
          </div>
          <div class="detail-item">
            <div class="detail-label">Descri&ccedil;&atilde;o da Carga</div>
            <div class="detail-value"><%= frete.getDescricaoCarga() != null ? frete.getDescricaoCarga() : "&mdash;" %></div>
          </div>
          <div class="detail-item">
            <div class="detail-label">Peso Bruto</div>
            <div class="detail-value"><%= frete.getPesoKg() %> kg</div>
          </div>
          <div class="detail-item">
            <div class="detail-label">Volumes</div>
            <div class="detail-value"><%= frete.getVolumes() %></div>
          </div>
          <div class="detail-item">
            <div class="detail-label">Valor Total</div>
            <div class="detail-value" style="color:var(--success-dark);font-size:16px;">
              R$ <%= String.format("%.2f", frete.getValorTotal()) %>
            </div>
          </div>
          <% if (frete.getDataSaida() != null) { %>
          <div class="detail-item">
            <div class="detail-label">Data de Sa&iacute;da</div>
            <div class="detail-value"><%= frete.getDataSaida() %></div>
          </div>
          <% } %>
          <% if (frete.getDataEntrega() != null) { %>
          <div class="detail-item">
            <div class="detail-label">Data de Entrega</div>
            <div class="detail-value"><%= frete.getDataEntrega() %></div>
          </div>
          <% } %>
        </div>
      </div>

      <!-- Ações de transição de status -->
      <div class="card" style="margin-bottom:16px;">
        <div class="actions-panel">
          <div class="actions-panel-title">A&ccedil;&otilde;es dispon&iacute;veis</div>
          <div style="display:flex;flex-wrap:wrap;gap:8px;">

            <% if (frete.getStatus() == StatusFrete.EMITIDO) { %>
              <a href="<%= ctx %>/fretes?acao=confirmarSaida&id=<%= frete.getId() %>" class="btn btn-primary">
                <i class="bi bi-play-fill"></i> Confirmar Sa&iacute;da
              </a>
              <form method="post" action="<%= ctx %>/fretes" style="display:inline;">
                <input type="hidden" name="acao" value="cancelar"/>
                <input type="hidden" name="id" value="<%= frete.getId() %>"/>
                <button type="submit" class="btn btn-danger"
                        onclick="return confirm('Confirma o cancelamento do frete?')">
                  <i class="bi bi-x-circle"></i> Cancelar Frete
                </button>
              </form>
            <% } %>

            <% if (frete.getStatus() == StatusFrete.SAIDA_CONFIRMADA) { %>
              <form method="post" action="<%= ctx %>/fretes" style="display:inline;">
                <input type="hidden" name="acao" value="emTransito"/>
                <input type="hidden" name="id" value="<%= frete.getId() %>"/>
                <button type="submit" class="btn btn-primary">
                  <i class="bi bi-truck"></i> Registrar Em Tr&acirc;nsito
                </button>
              </form>
            <% } %>

            <% if (frete.getStatus() == StatusFrete.EM_TRANSITO) { %>
              <a href="<%= ctx %>/fretes?acao=registrarEntrega&id=<%= frete.getId() %>" class="btn btn-success">
                <i class="bi bi-check-circle"></i> Confirmar Entrega
              </a>
              <a href="<%= ctx %>/fretes?acao=naoEntregue&id=<%= frete.getId() %>" class="btn btn-secondary">
                <i class="bi bi-exclamation-circle"></i> N&atilde;o Entregue
              </a>
            <% } %>

            <% if (frete.getStatus() != StatusFrete.ENTREGUE
                    && frete.getStatus() != StatusFrete.NAO_ENTREGUE
                    && frete.getStatus() != StatusFrete.CANCELADO) { %>
              <a href="<%= ctx %>/ocorrencias?acao=nova&idFrete=<%= frete.getId() %>" class="btn btn-secondary">
                <i class="bi bi-plus-circle"></i> Nova Ocorr&ecirc;ncia
              </a>
            <% } %>

          </div>
        </div>
      </div>

      <!-- Histórico de ocorrências -->
      <div class="card">
        <div style="padding:14px 20px;border-bottom:1px solid var(--gray-200);">
          <span style="font-size:13px;font-weight:600;color:var(--gray-800);">
            <i class="bi bi-clock-history" style="margin-right:6px;color:var(--gray-500);"></i>
            Hist&oacute;rico de Ocorr&ecirc;ncias
          </span>
        </div>
        <%
          List<OcorrenciaFrete> ocorrencias =
              (List<OcorrenciaFrete>) request.getAttribute("ocorrencias");
          if (ocorrencias != null && !ocorrencias.isEmpty()) {
        %>
        <div class="timeline">
          <%
            for (OcorrenciaFrete oc : ocorrencias) {
          %>
          <div class="timeline-item">
            <div class="timeline-dot"><i class="bi bi-geo-alt"></i></div>
            <div class="timeline-content">
              <div class="timeline-time">
                <%= oc.getDataHora() != null ? oc.getDataHora().toString().replace("T"," ") : "" %>
                <% if (oc.getMunicipio() != null) { %>
                  &mdash; <%= oc.getMunicipio() %><%= oc.getUf() != null ? " / " + oc.getUf() : "" %>
                <% } %>
              </div>
              <div class="timeline-type"><%= oc.getTipo() != null ? oc.getTipo().name().replace("_"," ") : "" %></div>
              <% if (oc.getDescricao() != null && !oc.getDescricao().isEmpty()) { %>
                <div class="timeline-desc"><%= oc.getDescricao() %></div>
              <% } %>
              <% if (oc.getNomeRecebedor() != null && !oc.getNomeRecebedor().isEmpty()) { %>
                <div class="timeline-desc">
                  <i class="bi bi-person-check" style="margin-right:4px;"></i>
                  <%= oc.getNomeRecebedor() %>
                  <% if (oc.getDocumentoRecebedor() != null) { %> &mdash; <%= oc.getDocumentoRecebedor() %><% } %>
                </div>
              <% } %>
            </div>
          </div>
          <% } %>
        </div>
        <% } else { %>
        <div class="empty-state">
          <i class="bi bi-clock-history"></i>
          <p>Nenhuma ocorr&ecirc;ncia registrada.</p>
        </div>
        <% } %>
      </div>

      <% } else { %>
        <div class="alert alert-error"><i class="bi bi-exclamation-circle-fill"></i> Frete n&atilde;o encontrado.</div>
      <% } %>

    </main>
  </div>
</div>
</body>
</html>
