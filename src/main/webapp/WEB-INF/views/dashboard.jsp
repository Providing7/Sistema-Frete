<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="br.com.gestaofretes.motorista.Motorista, java.util.List, java.time.LocalDate" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard &mdash; FretesTMS</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
</head>
<body>
<div class="app-layout">
  <jsp:include page="/WEB-INF/views/_nav.jsp" />

  <div class="app-main">
    <header class="topbar">
      <div class="topbar-left">
        <span class="topbar-title">Dashboard</span>
        <span class="topbar-breadcrumb">Vis&atilde;o geral</span>
      </div>
      <div class="topbar-right">
        <span style="font-size:13px;color:var(--gray-500);">
          Ol&aacute;, <strong style="color:var(--gray-800);">${sessionScope.usuarioLogado}</strong>
        </span>
      </div>
    </header>

    <main class="page-body">

      <!-- KPIs -->
      <div class="stats-grid">
        <a class="stat-card" href="${pageContext.request.contextPath}/clientes">
          <div class="stat-icon blue"><i class="bi bi-building"></i></div>
          <div class="stat-info">
            <div class="stat-value"><%= request.getAttribute("totalClientes") != null ? request.getAttribute("totalClientes") : "&mdash;" %></div>
            <div class="stat-label">Clientes cadastrados</div>
          </div>
        </a>
        <a class="stat-card" href="${pageContext.request.contextPath}/motoristas">
          <div class="stat-icon green"><i class="bi bi-person-badge"></i></div>
          <div class="stat-info">
            <div class="stat-value"><%= request.getAttribute("totalMotoristas") != null ? request.getAttribute("totalMotoristas") : "&mdash;" %></div>
            <div class="stat-label">Motoristas ativos</div>
          </div>
        </a>
        <a class="stat-card" href="${pageContext.request.contextPath}/veiculos">
          <div class="stat-icon purple"><i class="bi bi-truck"></i></div>
          <div class="stat-info">
            <div class="stat-value"><%= request.getAttribute("totalVeiculos") != null ? request.getAttribute("totalVeiculos") : "&mdash;" %></div>
            <div class="stat-label">Ve&iacute;culos na frota</div>
          </div>
        </a>
        <a class="stat-card" href="${pageContext.request.contextPath}/fretes">
          <div class="stat-icon orange"><i class="bi bi-file-earmark-text"></i></div>
          <div class="stat-info">
            <div class="stat-value"><%= request.getAttribute("fretesNoMes") != null ? request.getAttribute("fretesNoMes") : "&mdash;" %></div>
            <div class="stat-label">Fretes este m&ecirc;s</div>
          </div>
        </a>
      </div>

      <!-- Alerta fretes em andamento -->
      <%
        Object emAberto = request.getAttribute("fretesEmAberto");
        if (emAberto != null && (Integer) emAberto > 0) {
      %>
      <div class="alert alert-warning" style="margin-bottom:24px;">
        <i class="bi bi-exclamation-triangle-fill"></i>
        <span>
          <strong><%= emAberto %> frete<%= (Integer)emAberto > 1 ? "s" : "" %></strong>
          em andamento (Emitido / Sa&iacute;da Confirmada / Em Tr&acirc;nsito)
        </span>
        <a href="${pageContext.request.contextPath}/fretes"
           style="margin-left:auto;font-size:12px;font-weight:600;color:inherit;">
          Ver fretes <i class="bi bi-arrow-right"></i>
        </a>
      </div>
      <% } %>
      
      <!-- Alerta CNH -->
      <%
        List<Motorista> alertaCNH = (List<Motorista>) request.getAttribute("motoristasAlertaCNH");
        if (alertaCNH != null && !alertaCNH.isEmpty()) {
            LocalDate hoje = LocalDate.now();
            int qtdVencidas    = 0;
            int qtdAVencer     = 0;
            for (Motorista mv : alertaCNH) {
                if (mv.getCnhValidade() == null) continue;
                if (mv.getCnhValidade().isBefore(hoje)) qtdVencidas++;
                else qtdAVencer++;
            }
      %>
      <div class="alert alert-warning alert-cnh-banner">
        <i class="bi bi-exclamation-triangle-fill alert-cnh-icon"></i>
        <div class="alert-cnh-body">
          <strong class="alert-cnh-titulo">
            <%= alertaCNH.size() %> motorista<%= alertaCNH.size() > 1 ? "s" : "" %>
            com CNH vencida ou a vencer em 30 dias
          </strong>
          <div style="display:flex;gap:6px;flex-wrap:wrap;margin-top:4px;">
            <% if (qtdVencidas > 0) { %>
            <span class="badge-cnh-vencida"><%= qtdVencidas %> JÁ VENCIDA<%= qtdVencidas > 1 ? "S" : "" %></span>
            <% } %>
            <% if (qtdAVencer > 0) { %>
            <span class="badge-cnh-atencao"><%= qtdAVencer %> A VENCER</span>
            <% } %>
          </div>
        </div>
        <a href="${pageContext.request.contextPath}/alertas-cnh" class="btn btn-secondary btn-sm">
          <i class="bi bi-eye"></i> Ver detalhes
        </a>
      </div>
      <% } %>

      <!-- ══════════════════════════════════════════════
           SEÇÃO DE GRÁFICOS
           ══════════════════════════════════════════════ -->
      <div class="section-header">
        <h2><i class="bi bi-bar-chart-line"></i> An&aacute;lise Visual</h2>
      </div>

      <div class="charts-grid">

        <!-- Gráfico 1: Donut — Fretes por Status -->
        <div class="chart-card">
          <div class="chart-card-title">Fretes por Status</div>
          <div class="chart-wrapper chart-wrapper-sm">
            <canvas id="chartStatus"></canvas>
          </div>
        </div>

        <!-- Gráfico 2: Barras — Faturamento Mensal -->
        <div class="chart-card chart-card-wide">
          <div class="chart-card-title" style="display:flex;align-items:center;justify-content:space-between;">
            <span>Faturamento Mensal (R$) &mdash; &uacute;ltimos <%= request.getAttribute("mesesFaturamento") %> meses</span>
            <select id="seletorMeses" style="font-size:12px;padding:3px 8px;border-radius:6px;border:1px solid #ddd;cursor:pointer;">
              <option value="3"  <%= "3" .equals(String.valueOf(request.getAttribute("mesesFaturamento"))) ? "selected" : "" %>>3 meses</option>
              <option value="6"  <%= "6" .equals(String.valueOf(request.getAttribute("mesesFaturamento"))) ? "selected" : "" %>>6 meses</option>
              <option value="9"  <%= "9" .equals(String.valueOf(request.getAttribute("mesesFaturamento"))) ? "selected" : "" %>>9 meses</option>
              <option value="12" <%= "12".equals(String.valueOf(request.getAttribute("mesesFaturamento"))) ? "selected" : "" %>>12 meses</option>
              <option value="24" <%= "24".equals(String.valueOf(request.getAttribute("mesesFaturamento"))) ? "selected" : "" %>>24 meses</option>
            </select>
          </div>
          <div class="chart-wrapper">
            <canvas id="chartFaturamento"></canvas>
          </div>
        </div>

      </div>

      <!-- Gráfico 3: Mapa de Rotas -->
      <div class="chart-card" style="margin-top:24px;">
        <div class="chart-card-title"><i class="bi bi-geo-alt"></i> Mapa de Rotas (Top 10 por UF)</div>
        <div id="mapaRotas" class="mapa-rotas"></div>
      </div>

      <!-- Módulos -->
      <div class="section-header" style="margin-top:32px;">
        <h2>M&oacute;dulos do sistema</h2>
      </div>
      <div class="module-grid">
        <a class="module-card" href="${pageContext.request.contextPath}/clientes">
          <div class="module-card-icon"><i class="bi bi-building"></i></div>
          <div class="module-card-body"><h3>Clientes</h3><p>Tomadores de servi&ccedil;o, contatos e endere&ccedil;os.</p></div>
          <i class="bi bi-chevron-right module-card-arrow"></i>
        </a>
        <a class="module-card" href="${pageContext.request.contextPath}/motoristas">
          <div class="module-card-icon"><i class="bi bi-person-badge"></i></div>
          <div class="module-card-body"><h3>Motoristas</h3><p>CNH, v&iacute;nculo empregat&iacute;cio e status.</p></div>
          <i class="bi bi-chevron-right module-card-arrow"></i>
        </a>
        <a class="module-card" href="${pageContext.request.contextPath}/veiculos">
          <div class="module-card-icon"><i class="bi bi-truck"></i></div>
          <div class="module-card-body"><h3>Ve&iacute;culos</h3><p>Frota com capacidade de carga e status.</p></div>
          <i class="bi bi-chevron-right module-card-arrow"></i>
        </a>
        <a class="module-card" href="${pageContext.request.contextPath}/fretes">
          <div class="module-card-icon"><i class="bi bi-file-earmark-text"></i></div>
          <div class="module-card-body"><h3>Fretes</h3><p>Emiss&atilde;o, fluxo de status e rastreamento de carga.</p></div>
          <i class="bi bi-chevron-right module-card-arrow"></i>
        </a>
      </div>

    </main>
  </div>
</div>

<!-- Chart.js e Leaflet -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
// ─── DADOS DO SERVIDOR ───────────────────────────────────────────────
const statusLabels = <%= request.getAttribute("graficoStatusLabels") != null ? request.getAttribute("graficoStatusLabels") : "[]" %>;
const statusData   = <%= request.getAttribute("graficoStatusData")   != null ? request.getAttribute("graficoStatusData")   : "[]" %>;
const fatLabels    = <%= request.getAttribute("graficoFatLabels")    != null ? request.getAttribute("graficoFatLabels")    : "[]" %>;
const fatData      = <%= request.getAttribute("graficoFatData")      != null ? request.getAttribute("graficoFatData")      : "[]" %>;
const rotas        = <%= request.getAttribute("graficoRotas")        != null ? request.getAttribute("graficoRotas")        : "[]" %>;

// ─── LABELS AMIGÁVEIS DOS STATUS ─────────────────────────────────────
const statusNomes = {
  EMITIDO:          'Emitido',
  SAIDA_CONFIRMADA: 'Saída Confirmada',
  EM_TRANSITO:      'Em Trânsito',
  ENTREGUE:         'Entregue',
  NAO_ENTREGUE:     'Não Entregue',
  CANCELADO:        'Cancelado'
};
const statusCores = {
  EMITIDO:          '#3498DB',
  SAIDA_CONFIRMADA: '#F39C12',
  EM_TRANSITO:      '#8E44AD',
  ENTREGUE:         '#27AE60',
  NAO_ENTREGUE:     '#E74C3C',
  CANCELADO:        '#95A5A6'
};

// ─── GRÁFICO 1: DONUT — FRETES POR STATUS ────────────────────────────
if (statusLabels.length > 0) {
  new Chart(document.getElementById('chartStatus'), {
    type: 'doughnut',
    data: {
      labels: statusLabels.map(l => statusNomes[l] || l),
      datasets: [{
        data: statusData,
        backgroundColor: statusLabels.map(l => statusCores[l] || '#BDC3C7'),
        borderWidth: 2,
        borderColor: '#fff'
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      plugins: {
        legend: { position: 'right', labels: { font: { size: 12 }, padding: 12 } },
        tooltip: {
          callbacks: {
            label: ctx => ' ' + (statusNomes[statusLabels[ctx.dataIndex]] || statusLabels[ctx.dataIndex]) + ': ' + ctx.raw
          }
        }
      }
    }
  });
}

// ─── GRÁFICO 2: BARRAS — FATURAMENTO MENSAL ──────────────────────────
if (fatLabels.length > 0) {
  new Chart(document.getElementById('chartFaturamento'), {
    type: 'bar',
    data: {
      labels: fatLabels,
      datasets: [{
        label: 'Faturamento (R$)',
        data: fatData,
        backgroundColor: 'rgba(39, 174, 96, 0.75)',
        borderColor: '#27AE60',
        borderWidth: 1.5,
        borderRadius: 6,
        hoverBackgroundColor: 'rgba(39, 174, 96, 0.95)'
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      plugins: {
        legend: { display: false },
        tooltip: {
          callbacks: {
            label: ctx => ' R$ ' + ctx.raw.toLocaleString('pt-BR', { minimumFractionDigits: 2 })
          }
        }
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            callback: v => 'R$ ' + v.toLocaleString('pt-BR')
          },
          grid: { color: '#f0f0f0' }
        },
        x: { grid: { display: false } }
      }
    }
  });
}

document.getElementById('seletorMeses').addEventListener('change', function () {
  const url = new URL(window.location.href);
  url.searchParams.set('meses', this.value);
  window.location.href = url.toString();
});


// Coordenadas das capitais de cada UF brasileira
const ufCoords = {
  AC:[-9.975,-67.825], AL:[-9.665,-35.735], AM:[-3.119,-60.021], AP:[0.034,-51.066],
  BA:[-12.971,-38.501], CE:[-3.717,-38.543], DF:[-15.779,-47.930], ES:[-20.319,-40.338],
  GO:[-16.686,-49.264], MA:[-2.529,-44.302], MG:[-19.912,-43.940], MS:[-20.469,-54.620],
  MT:[-15.601,-56.097], PA:[-1.455,-48.503], PB:[-7.115,-34.861], PE:[-8.054,-34.881],
  PI:[-5.089,-42.802], PR:[-25.428,-49.273], RJ:[-22.908,-43.173], RN:[-5.794,-35.211],
  RO:[-8.761,-63.900], RR:[2.820,-60.673], RS:[-30.034,-51.217], SC:[-27.596,-48.549],
  SE:[-10.909,-37.048], SP:[-23.550,-46.633], TO:[-10.240,-48.359]
};

const mapaEl = document.getElementById('mapaRotas');
if (rotas.length > 0) {
  const MAPBOX_TOKEN = '<% request.getAttribute("mapboxToken") %>';

  const mapa = L.map('mapaRotas').setView([-15.0, -50.0], 4);
  L.tileLayer(
    'https://api.mapbox.com/styles/v1/mapbox/light-v11/tiles/{z}/{x}/{y}?access_token=' + MAPBOX_TOKEN,
    {
      attribution: '© <a href="https://www.mapbox.com/">Mapbox</a> © <a href="https://www.openstreetmap.org/">OpenStreetMap</a>',
      tileSize: 512,
      zoomOffset: -1
    }
  ).addTo(mapa);

  const maxTotal = Math.max(...rotas.map(r => r.total));

  rotas.forEach(rota => {
    const orig = ufCoords[rota.origem];
    const dest = ufCoords[rota.destino];
    if (!orig || !dest) return;

    // Espessura proporcional à frequência
    const peso = Math.max(1, Math.round((rota.total / maxTotal) * 6));

    // Linha com curva leve
    const linha = L.polyline([orig, dest], {
      color: '#2980B9',
      weight: peso,
      opacity: 0.7
    }).addTo(mapa);

    linha.bindTooltip(
      rota.origem + ' → ' + rota.destino + ': ' + rota.total + ' frete(s)',
      { sticky: true }
    );

    // Marcadores nas capitais
    [orig, dest].forEach(coord => {
      L.circleMarker(coord, {
        radius: 5, fillColor: '#E74C3C', color: '#fff',
        weight: 1.5, opacity: 1, fillOpacity: 0.9
      }).addTo(mapa);
    });
  });
} else {
  mapaEl.innerHTML = '<div style="display:flex;align-items:center;justify-content:center;height:100%;color:var(--gray-400);font-size:14px;">Nenhuma rota cadastrada ainda.</div>';
}
</script>
</body>
</html>