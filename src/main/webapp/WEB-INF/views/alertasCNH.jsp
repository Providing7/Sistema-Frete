<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="br.com.gestaofretes.motorista.Motorista, java.util.List, java.time.LocalDate, java.time.temporal.ChronoUnit, java.time.format.DateTimeFormatter" %>
<%
    List<Motorista> alertas = (List<Motorista>) request.getAttribute("motoristasAlerta");
    LocalDate hoje = LocalDate.now();
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    int qtdVencidas  = 0;
    int qtd30        = 0;
    int qtd60        = 0;
    int qtd90        = 0;
    if (alertas != null) {
        for (Motorista m : alertas) {
            if (m.getCnhValidade() == null) continue;
            long dias = ChronoUnit.DAYS.between(hoje, m.getCnhValidade());
            if (dias < 0)       qtdVencidas++;
            else if (dias <= 30) qtd30++;
            else if (dias <= 60) qtd60++;
            else                 qtd90++;
        }
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Alertas de CNH &mdash; FretesTMS</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />

  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">Alertas de CNH</span>
        <span class="topbar-breadcrumb">Motoristas com CNH vencida ou a vencer</span>
      </div>
      <div class="topbar-right">
        <a href="${pageContext.request.contextPath}/dashboard"
           class="btn btn-secondary btn-sm">
          <i class="bi bi-arrow-left"></i> Voltar ao Dashboard
        </a>
      </div>
    </header>

    <main class="page-body">

      <!-- Cards de resumo -->
      <div class="alerta-cnh-cards">
        <div class="alerta-cnh-card card-vencida">
          <span class="card-num"><%= qtdVencidas %></span>
          <span class="card-leg"><i class="bi bi-x-circle-fill"></i> CNH Vencida</span>
        </div>
        <div class="alerta-cnh-card card-30">
          <span class="card-num"><%= qtd30 %></span>
          <span class="card-leg"><i class="bi bi-exclamation-triangle-fill"></i> Vence em até 30 dias</span>
        </div>
        <div class="alerta-cnh-card card-60">
          <span class="card-num"><%= qtd60 %></span>
          <span class="card-leg"><i class="bi bi-clock-fill"></i> Vence entre 31 e 60 dias</span>
        </div>
        <div class="alerta-cnh-card card-90">
          <span class="card-num"><%= qtd90 %></span>
          <span class="card-leg"><i class="bi bi-info-circle-fill"></i> Vence entre 61 e 90 dias</span>
        </div>
      </div>

      <!-- Filtros rápidos -->
      <div class="filtro-tabs">
        <button class="ativo" onclick="filtrar('todos', this)">
          Todos (<%= alertas != null ? alertas.size() : 0 %>)
        </button>
        <button onclick="filtrar('vencida', this)">
          Vencidas (<%= qtdVencidas %>)
        </button>
        <button onclick="filtrar('critico', this)">
          Crítico — até 30d (<%= qtd30 %>)
        </button>
        <button onclick="filtrar('atencao', this)">
          Atenção — 31 a 60d (<%= qtd60 %>)
        </button>
        <button onclick="filtrar('aviso', this)">
          Aviso — 61 a 90d (<%= qtd90 %>)
        </button>
      </div>

      <!-- Tabela -->
      <div class="card">
        <% if (alertas == null || alertas.isEmpty()) { %>
          <div class="empty-cnh">
            <i class="bi bi-check-circle"></i>
            <p>Nenhum motorista com CNH vencida ou a vencer nos próximos 90 dias.</p>
          </div>
        <% } else { %>
        <table class="data-table">
          <thead>
            <tr>
              <th>Motorista</th>
              <th>CNH Nº</th>
              <th>Categoria</th>
              <th>Validade</th>
              <th>Situação</th>
              <th>Dias</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <% for (Motorista m : alertas) {
                 if (m.getCnhValidade() == null) continue;
                 long dias     = ChronoUnit.DAYS.between(hoje, m.getCnhValidade());
                 boolean venc  = dias < 0;
                 String grupo  = venc ? "vencida" : dias <= 30 ? "critico" : dias <= 60 ? "atencao" : "aviso";
                 String badgeC = venc ? "badge-cnh-vencida" : dias <= 30 ? "badge-cnh-critico" : dias <= 60 ? "badge-cnh-atencao" : "badge-cnh-aviso";
                 String sitLbl = venc ? "VENCIDA" : dias <= 30 ? "CRÍTICO" : dias <= 60 ? "ATENÇÃO" : "AVISO";
                 String diasCls = venc ? "dias-vencido" : dias <= 30 ? "dias-critico" : dias <= 60 ? "dias-atencao" : "dias-aviso";
            %>
            <tr data-grupo="<%= grupo %>">
              <td><strong><%= m.getNome() %></strong></td>
              <td><%= m.getCnhNumero() != null ? m.getCnhNumero() : "&mdash;" %></td>
              <td><%= m.getCnhCategoria() != null ? m.getCnhCategoria().name() : "&mdash;" %></td>
              <td><%= m.getCnhValidade().format(fmt) %></td>
              <td><span class="<%= badgeC %>"><%= sitLbl %></span></td>
              <td class="td-center">
                <span class="<%= diasCls %>">
                  <% if (venc) { %>
                    <%= Math.abs(dias) %> dia<%= Math.abs(dias) != 1 ? "s" : "" %> atrás
                  <% } else { %>
                    <%= dias %> dia<%= dias != 1 ? "s" : "" %>
                  <% } %>
                </span>
              </td>
              <td>
                <a href="${pageContext.request.contextPath}/motoristas?acao=editar&id=<%= m.getId() %>"
                   class="btn btn-secondary btn-sm">
                  <i class="bi bi-pencil"></i> Atualizar CNH
                </a>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
        <% } %>
      </div>

    </main>
  </div>
</div>

<script>
  function filtrar(grupo, btn) {
    document.querySelectorAll('.filtro-tabs button').forEach(b => b.classList.remove('ativo'));
    btn.classList.add('ativo');

    document.querySelectorAll('tbody tr').forEach(tr => {
      if (grupo === 'todos' || tr.dataset.grupo === grupo) {
        tr.classList.remove('hide');
      } else {
        tr.classList.add('hide');
      }
    });
  }
</script>
</body>
</html>
