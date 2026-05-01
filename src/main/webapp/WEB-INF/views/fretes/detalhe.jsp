<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="br.com.gestaofretes.frete.Frete,br.com.gestaofretes.frete.StatusFrete,br.com.gestaofretes.ocorrencia.OcorrenciaFrete,
                 java.util.List" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Detalhe do Frete &mdash; Gestão de Fretes</title>
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
        <span class="topbar-title">Frete <%= num %></span>
        <span class="topbar-breadcrumb">Operacional &rsaquo; Fretes &rsaquo; Detalhe</span>
      </div>
      <div class="topbar-right">
        <a class="btn btn-secondary" href="<%= ctx %>/fretes">&larr; Voltar</a>
      </div>
    </header>

    <main class="page-body">

      <% if (request.getAttribute("erro") != null) { %>
        <div class="alert alert-error">&#9888; ${erro}</div>
      <% } %>
      <% if (request.getParameter("sucesso") != null) { %>
        <div class="alert alert-success">&#9989; ${param.sucesso}</div>
      <% } %>

      <% if (frete != null) {
           String badgeClass;
           switch (frete.getStatus()) {
             case EMITIDO:          badgeClass = "badge-warning"; break;
             case SAIDA_CONFIRMADA: badgeClass = "badge-info";    break;
             case EM_TRANSITO:      badgeClass = "badge-primary"; break;
             case ENTREGUE:         badgeClass = "badge-ativo";   break;
             case NAO_ENTREGUE:     badgeClass = "badge-danger";  break;
             case CANCELADO:        badgeClass = "badge-inativo"; break;
             default:               badgeClass = "badge-inativo";
           }
      %>

      <!-- Cabeçalho do frete -->
      <div class="card" style="margin-bottom:16px;">
        <div style="display:flex;justify-content:space-between;align-items:center;padding:16px 20px;border-bottom:1px solid var(--gray-200);">
          <div>
            <span class="td-mono" style="font-size:18px;font-weight:700;"><%= frete.getNumero() %></span>
          </div>
          <span class="badge <%= badgeClass %>" style="font-size:13px;padding:6px 14px;">
            <%= frete.getStatus().name().replace("_"," ") %>
          </span>
        </div>

        <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:16px;padding:20px;">
          <div><div style="font-size:11px;color:var(--gray-500);text-transform:uppercase;margin-bottom:4px;">Remetente</div>
               <strong><%= frete.getRemetente() != null ? frete.getRemetente().getRazaoSocial() : "—" %></strong></div>
          <div><div style="font-size:11px;color:var(--gray-500);text-transform:uppercase;margin-bottom:4px;">Destinat&aacute;rio</div>
               <strong><%= frete.getDestinatario() != null ? frete.getDestinatario().getRazaoSocial() : "—" %></strong></div>
          <div><div style="font-size:11px;color:var(--gray-500);text-transform:uppercase;margin-bottom:4px;">Motorista</div>
               <strong><%= frete.getMotorista() != null ? frete.getMotorista().getNome() : "—" %></strong></div>
          <div><div style="font-size:11px;color:var(--gray-500);text-transform:uppercase;margin-bottom:4px;">Ve&iacute;culo</div>
               <strong><%= frete.getVeiculo() != null ? frete.getVeiculo().getPlaca() : "—" %></strong></div>
          <div><div style="font-size:11px;color:var(--gray-500);text-transform:uppercase;margin-bottom:4px;">Origem</div>
               <strong><%= frete.getMunicipioOrigem() %> / <%= frete.getUfOrigem() %></strong></div>
          <div><div style="font-size:11px;color:var(--gray-500);text-transform:uppercase;margin-bottom:4px;">Destino</div>
               <strong><%= frete.getMunicipioDestino() %> / <%= frete.getUfDestino() %></strong></div>
          <div><div style="font-size:11px;color:var(--gray-500);text-transform:uppercase;margin-bottom:4px;">Emiss&atilde;o</div>
               <strong><%= frete.getDataEmissao() %></strong></div>
          <div><div style="font-size:11px;color:var(--gray-500);text-transform:uppercase;margin-bottom:4px;">Previs&atilde;o</div>
               <strong><%= frete.getDataPrevisaoEntrega() %></strong></div>
          <div><div style="font-size:11px;color:var(--gray-500);text-transform:uppercase;margin-bottom:4px;">Carga</div>
               <strong><%= frete.getDescricaoCarga() != null ? frete.getDescricaoCarga() : "—" %></strong></div>
          <div><div style="font-size:11px;color:var(--gray-500);text-transform:uppercase;margin-bottom:4px;">Peso (kg)</div>
               <strong><%= frete.getPesoKg() %></strong></div>
          <div><div style="font-size:11px;color:var(--gray-500);text-transform:uppercase;margin-bottom:4px;">Volumes</div>
               <strong><%= frete.getVolumes() %></strong></div>
          <div><div style="font-size:11px;color:var(--gray-500);text-transform:uppercase;margin-bottom:4px;">Valor Total</div>
               <strong>R$ <%= String.format("%.2f", frete.getValorTotal()) %></strong></div>
          <% if (frete.getDataSaida() != null) { %>
          <div><div style="font-size:11px;color:var(--gray-500);text-transform:uppercase;margin-bottom:4px;">Sa&iacute;da</div>
               <strong><%= frete.getDataSaida() %></strong></div>
          <% } %>
          <% if (frete.getDataEntrega() != null) { %>
          <div><div style="font-size:11px;color:var(--gray-500);text-transform:uppercase;margin-bottom:4px;">Entrega</div>
               <strong><%= frete.getDataEntrega() %></strong></div>
          <% } %>
        </div>
      </div>

      <!-- Ações de transição de status -->
      <div class="card" style="margin-bottom:16px;padding:16px 20px;">
        <div style="font-size:13px;font-weight:600;color:var(--gray-700);margin-bottom:12px;">A&ccedil;&otilde;es</div>
        <div style="display:flex;flex-wrap:wrap;gap:10px;">

          <% if (frete.getStatus() == StatusFrete.EMITIDO) { %>
            <a href="<%= ctx %>/fretes?acao=confirmarSaida&id=<%= frete.getId() %>" class="btn btn-primary">&#9654; Confirmar Sa&iacute;da</a>
            <form method="post" action="<%= ctx %>/fretes" style="display:inline;">
              <input type="hidden" name="acao" value="cancelar"/>
              <input type="hidden" name="id" value="<%= frete.getId() %>"/>
              <button type="submit" class="btn btn-danger"
                      onclick="return confirm('Confirma o cancelamento do frete?')">&#10005; Cancelar Frete</button>
            </form>
          <% } %>

          <% if (frete.getStatus() == StatusFrete.SAIDA_CONFIRMADA) { %>
            <form method="post" action="<%= ctx %>/fretes" style="display:inline;">
              <input type="hidden" name="acao" value="emTransito"/>
              <input type="hidden" name="id" value="<%= frete.getId() %>"/>
              <button type="submit" class="btn btn-primary">&#128663; Registrar Em Tr&acirc;nsito</button>
            </form>
          <% } %>

          <% if (frete.getStatus() == StatusFrete.EM_TRANSITO) { %>
            <a href="<%= ctx %>/fretes?acao=registrarEntrega&id=<%= frete.getId() %>" class="btn btn-primary" style="background:var(--success);">&#10004; Registrar Entrega</a>
            <a href="<%= ctx %>/fretes?acao=naoEntregue&id=<%= frete.getId() %>" class="btn btn-secondary">&#9888; N&atilde;o Entregue</a>
          <% } %>

          <%-- Botão de nova ocorrência: disponível enquanto o frete ainda estiver ativo --%>
          <% if (frete.getStatus() != StatusFrete.ENTREGUE
                  && frete.getStatus() != StatusFrete.NAO_ENTREGUE
                  && frete.getStatus() != StatusFrete.CANCELADO) { %>
            <a href="<%= ctx %>/ocorrencias?acao=nova&idFrete=<%= frete.getId() %>" class="btn btn-secondary">&#43; Nova Ocorr&ecirc;ncia</a>
          <% } %>

        </div>
      </div>

      <!-- Histórico de ocorrências -->
      <div class="card">
        <div style="padding:16px 20px;border-bottom:1px solid var(--gray-200);font-size:13px;font-weight:600;color:var(--gray-700);">
          Hist&oacute;rico de Ocorr&ecirc;ncias
        </div>
        <div class="table-responsive">
          <table>
            <thead>
              <tr>
                <th>Data / Hora</th>
                <th>Tipo</th>
                <th>Local</th>
                <th>Descri&ccedil;&atilde;o</th>
                <th>Recebedor</th>
              </tr>
            </thead>
            <tbody>
              <%
                List<OcorrenciaFrete> ocorrencias =
                    (List<OcorrenciaFrete>) request.getAttribute("ocorrencias");
                if (ocorrencias != null && !ocorrencias.isEmpty()) {
                  for (OcorrenciaFrete oc : ocorrencias) {
              %>
              <tr>
                <td><span class="td-mono"><%= oc.getDataHora() != null ? oc.getDataHora().toString().replace("T"," ") : "" %></span></td>
                <td><%= oc.getTipo() != null ? oc.getTipo().name().replace("_"," ") : "" %></td>
                <td><%= oc.getMunicipio() != null ? oc.getMunicipio() : "" %><%= oc.getUf() != null ? " / " + oc.getUf() : "" %></td>
                <td style="max-width:220px;word-break:break-word;"><%= oc.getDescricao() != null ? oc.getDescricao() : "" %></td>
                <td><%= oc.getNomeRecebedor() != null ? oc.getNomeRecebedor() : "" %></td>
              </tr>
              <%   }
                } else { %>
              <tr>
                <td colspan="5" style="text-align:center;color:var(--gray-400);padding:24px;">Nenhuma ocorr&ecirc;ncia registrada.</td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>

      <% } else { %>
        <div class="alert alert-error">Frete não encontrado.</div>
      <% } %>

    </main>
  </div>
</div>
</body>
</html>
