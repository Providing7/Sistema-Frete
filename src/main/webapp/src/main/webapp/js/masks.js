/**
 * masks.js — Máscaras de input reutilizáveis
 * Uso: adicione data-mask="cpf|cnpj|cep|telefone|placa|rntrc|ano" no input
 */
(function () {

  function aplicarMascara(campo, mascara) {
    campo.addEventListener('input', function () {
      var cursor = campo.selectionStart;
      var val    = campo.value.replace(/\D/g, '');
      campo.value = mascara(val);
      // reposiciona cursor aproximadamente
      try { campo.setSelectionRange(cursor, cursor); } catch(e){}
    });
  }

  // CPF: 000.000.000-00
  function mascaraCpf(v) {
    v = v.substring(0, 11);
    return v
      .replace(/(\d{3})(\d)/, '$1.$2')
      .replace(/(\d{3})(\d)/, '$1.$2')
      .replace(/(\d{3})(\d{1,2})$/, '$1-$2');
  }

  // CNPJ: 00.000.000/0001-00
  function mascaraCnpj(v) {
    v = v.substring(0, 14);
    return v
      .replace(/(\d{2})(\d)/, '$1.$2')
      .replace(/(\d{3})(\d)/, '$1.$2')
      .replace(/(\d{3})(\d)/, '$1/$2')
      .replace(/(\d{4})(\d{1,2})$/, '$1-$2');
  }

  // CEP: 00000-000
  function mascaraCep(v) {
    v = v.substring(0, 8);
    return v.replace(/(\d{5})(\d{1,3})$/, '$1-$2');
  }

  // Telefone: (00) 00000-0000 ou (00) 0000-0000
  function mascaraTelefone(v) {
    v = v.substring(0, 11);
    if (v.length <= 10) {
      return v
        .replace(/(\d{2})(\d)/, '($1) $2')
        .replace(/(\d{4})(\d{1,4})$/, '$1-$2');
    }
    return v
      .replace(/(\d{2})(\d)/, '($1) $2')
      .replace(/(\d{5})(\d{1,4})$/, '$1-$2');
  }

  // Placa: aceita Mercosul (ABC1D23) e antigo (ABC1234) — só maiúsculas + alnum
  function mascaraPlaca(campo) {
    campo.addEventListener('input', function () {
      var val = campo.value.toUpperCase().replace(/[^A-Z0-9]/g, '').substring(0, 7);
      campo.value = val;
    });
  }

  // RNTRC: só números, máx 8 dígitos
  function mascaraRntrc(campo) {
    campo.addEventListener('input', function () {
      campo.value = campo.value.replace(/\D/g, '').substring(0, 8);
    });
  }

  // Ano: só números, máx 4 dígitos
  function mascaraAno(campo) {
    campo.addEventListener('input', function () {
      campo.value = campo.value.replace(/\D/g, '').substring(0, 4);
    });
  }

  // Aplica máscara ao carregar a página (para campos já preenchidos no edit)
  function aplicarValorInicial(campo, fn) {
    if (campo.value) campo.value = fn(campo.value.replace(/\D/g, ''));
  }

  // Inicializa todos os campos com data-mask
  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('[data-mask]').forEach(function (campo) {
      var tipo = campo.getAttribute('data-mask');

      if (tipo === 'cpf') {
        aplicarMascara(campo, mascaraCpf);
        aplicarValorInicial(campo, mascaraCpf);
      } else if (tipo === 'cnpj') {
        aplicarMascara(campo, mascaraCnpj);
        aplicarValorInicial(campo, mascaraCnpj);
      } else if (tipo === 'cep') {
        aplicarMascara(campo, mascaraCep);
        aplicarValorInicial(campo, mascaraCep);
      } else if (tipo === 'telefone') {
        aplicarMascara(campo, mascaraTelefone);
        aplicarValorInicial(campo, mascaraTelefone);
      } else if (tipo === 'placa') {
        mascaraPlaca(campo);
      } else if (tipo === 'rntrc') {
        mascaraRntrc(campo);
      } else if (tipo === 'ano') {
        mascaraAno(campo);
      }
    });
  });

})();
