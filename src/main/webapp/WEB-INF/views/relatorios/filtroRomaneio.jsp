<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, br.com.gestaofretes.motorista.Motorista, br.com.gestaofretes.relatorio.RomaneioDisponivel" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Romaneio de Carga &mdash; FretesTMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .romaneios-table { width:100%; border-collapse:collapse; margin-top:8px; font-size:13px; }
        .romaneios-table th { background:#2C3E50; color:#fff; padding:8px 10px; text-align:left; }
        .romaneios-table td { padding:7px 10px; border-bottom:1px solid #e8ecef; vertical-align:middle; }
        .romaneios-table tr:hover td { background:#f4f7fb; }
        .badge-qtd { background:#2980b9; color:#fff; border-radius:10px; padding:2px 8px; font-size:11px; }
        .badge-status { background:#ecf0f1; color:#555; border-radius:10px; padding:2px 7px; font-size:11px; }
        #filtroTabela { padding:6px 10px; border:1px solid #ccc; border-radius:4px; width:260px; font-size:13px; margin-bottom:10px; }
    </style>
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />
  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">Romaneio de Carga</span>
        <span class="topbar-breadcrumb">Relatórios &rsaquo; Romaneio</span>
      </div>
    </header>
    <main class="page-body">

     <% if (request.getAttribute("erro") != null) { %>
      <div class="alert alert-danger">
        <i class="bi bi-exclamation-triangle-fill"></i>
        <%= request.getAttribute("erro") %>
      </div>
      <% } %>

      <div class="form-card" style="max-width:480px;">
        <div class="form-section">
          <div class="form-section-title">Filtrar Romaneio</div>
          <form method="get"
                action="${pageContext.request.contextPath}/relatorios/romaneio"
                target="_blank">
            <div class="form-grid">

              <div class="form-group full">
                <label for="idMotorista">Motorista</label>
                <select id="idMotorista" name="idMotorista" required>
                  <option value="">Selecione...</option>
                  <%
                    List<Motorista> motoristas =
                        (List<Motorista>) request.getAttribute("motoristas");
                    if (motoristas != null) {
                      for (Motorista m : motoristas) {
                  %>
                  <option value="<%= m.getId() %>"><%= m.getNome() %></option>
                  <%  }
                    } %>
                </select>
              </div>

              <div class="form-group full">
                <label for="data">Data de Emiss&atilde;o</label>
                <input type="date" id="data" name="data" required />
              </div>

            </div>
            <div class="form-actions" style="margin-top:16px;">
              <button class="btn btn-primary" type="submit">
                <i class="bi bi-printer"></i> Gerar PDF
              </button>
            </div>
          </form>
        </div>
      </div>

      <%-- ===== TABELA DE ROMANEIOS DISPONÍVEIS ===== --%>
      <%
        List<RomaneioDisponivel> disponiveis =
            (List<RomaneioDisponivel>) request.getAttribute("romaneiosDisponiveis");
        if (disponiveis != null && !disponiveis.isEmpty()) {
      %>
      <div class="form-card" style="max-width:900px; margin-top:28px;">
        <div class="form-section">
          <div class="form-section-title">
            <i class="bi bi-list-ul"></i> Romaneios Dispon&iacute;veis
            <span style="font-weight:400; font-size:12px; color:#888; margin-left:8px;">
              (<%= disponiveis.size() %> combinação(ões) motorista&nbsp;+&nbsp;data)
            </span>
          </div>

          <input type="text" id="filtroTabela" placeholder="&#128269; Filtrar por motorista ou data..."
                 onkeyup="filtrarTabela()" />

          <table class="romaneios-table" id="tabelaRomaneios">
            <thead>
              <tr>
                <th>Motorista</th>
                <th>Data de Emissão</th>
                <th style="text-align:center;">Fretes</th>
                <th>Status</th>
                <th style="text-align:center;">Ação</th>
              </tr>
            </thead>
            <tbody>
            <%
              for (RomaneioDisponivel r : disponiveis) {
            %>
              <tr>
                <td><%= r.getNomeMotorista() %></td>
                <td><%= r.getDataFormatada() %></td>
                <td style="text-align:center;">
                  <span class="badge-qtd"><%= r.getQtdFretes() %></span>
                </td>
                <td>
                  <span class="badge-status"><%= r.getStatusResumo() != null ? r.getStatusResumo() : "" %></span>
                </td>
                <td style="text-align:center;">
                  <a class="btn btn-primary btn-sm"
                     href="${pageContext.request.contextPath}/relatorios/romaneio?idMotorista=<%= r.getIdMotorista() %>&data=<%= r.getDataEmissao() %>"
                     target="_blank"
                     title="Gerar PDF deste romaneio">
                    <i class="bi bi-file-earmark-pdf"></i> PDF
                  </a>
                </td>
              </tr>
            <%
              }
            %>
            </tbody>
          </table>
        </div>
      </div>

      <script>
        function filtrarTabela() {
          var filtro = document.getElementById("filtroTabela").value.toLowerCase();
          var linhas = document.querySelectorAll("#tabelaRomaneios tbody tr");
          linhas.forEach(function(tr) {
            var texto = tr.innerText.toLowerCase();
            tr.style.display = texto.includes(filtro) ? "" : "none";
          });
        }
      </script>
      <% } else if (disponiveis != null) { %>
      <div class="alert alert-info" style="max-width:900px; margin-top:24px;">
        <i class="bi bi-info-circle"></i>
        Nenhum romaneio cadastrado no sistema ainda.
      </div>
      <% } %>

    </main>
  </div>
</div>
</body>
</html>
