/**
 * masks.js — Máscaras de input reutilizáveis
 */
(function () {

    function aplicarMascara(campo, mascaraFn) {
        campo.addEventListener('input', function () {
            var pos = campo.selectionStart;
            campo.value = mascaraFn(campo.value.replace(/\D/g, ''));
            try { campo.setSelectionRange(pos, pos); } catch (e) {}
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

    // Placa: maiúsculas + alfanumérico, máx 7 chars
    function aplicarMascaraPlaca(campo) {
        campo.addEventListener('input', function () {
            campo.value = campo.value.toUpperCase().replace(/[^A-Z0-9]/g, '').substring(0, 7);
        });
    }

    // RNTRC: só dígitos, máx 8
    function aplicarMascaraRntrc(campo) {
        campo.addEventListener('input', function () {
            campo.value = campo.value.replace(/\D/g, '').substring(0, 8);
        });
    }

    // Ano: só dígitos, máx 4
    function aplicarMascaraAno(campo) {
        campo.addEventListener('input', function () {
            campo.value = campo.value.replace(/\D/g, '').substring(0, 4);
        });
    }

    // Decimal: somente dígitos e um ponto, máx 2 casas decimais
    function aplicarMascaraDecimal(campo) {
        campo.addEventListener('input', function () {
            var val = campo.value.replace(/[^0-9.]/g, '');
            var partes = val.split('.');
            if (partes.length > 2) {
                val = partes[0] + '.' + partes.slice(1).join('');
            }
            if (partes.length === 2 && partes[1].length > 2) {
                val = partes[0] + '.' + partes[1].substring(0, 2);
            }
            campo.value = val;
        });

        campo.addEventListener('blur', function () {
            if (campo.value !== '' && !isNaN(parseFloat(campo.value))) {
                campo.value = parseFloat(campo.value).toFixed(2);
            }
        });
    }

    // Aplica formatação no valor já existente (útil ao editar um registro)
    function formatarValorInicial(campo, mascaraFn) {
        if (campo.value) {
            campo.value = mascaraFn(campo.value.replace(/\D/g, ''));
        }
    }

    //Auto-preenchimento de CEP via BrasilAPI
    function configurarBuscaCep(campoCep) {
        campoCep.addEventListener('blur', function () {
            var cep = campoCep.value.replace(/\D/g, '');
            if (cep.length !== 8) return;

            campoCep.disabled = true;

            fetch('https://brasilapi.com.br/api/cep/v1/' + cep)
                .then(function (res) {
                    if (!res.ok) throw new Error('CEP não encontrado');
                    return res.json();
                })
                .then(function (data) {
                    var form = campoCep.closest('form');
                    if (!form) return;

                    var set = function (name, val) {
                        var el = form.querySelector('[name="' + name + '"]');
                        if (el && val) el.value = val;
                    };

                    set('logradouro', data.street);
                    set('bairro',     data.neighborhood);
                    set('municipio',  data.city);
                    set('uf',         data.state);
                })
                .catch(function () { /* CEP inválido — usuário preenche manualmente */ })
                .finally(function () {
                    campoCep.disabled = false;
                });
        });
    }

    // Inicialização
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('[data-mask]').forEach(function (campo) {
            var tipo = campo.getAttribute('data-mask');

            if (tipo === 'cpf') {
                aplicarMascara(campo, mascaraCpf);
                formatarValorInicial(campo, mascaraCpf);
            } else if (tipo === 'cnpj') {
                aplicarMascara(campo, mascaraCnpj);
                formatarValorInicial(campo, mascaraCnpj);
            } else if (tipo === 'cep') {
                aplicarMascara(campo, mascaraCep);
                formatarValorInicial(campo, mascaraCep);
                configurarBuscaCep(campo);
            } else if (tipo === 'telefone') {
                aplicarMascara(campo, mascaraTelefone);
                formatarValorInicial(campo, mascaraTelefone);
            } else if (tipo === 'placa') {
                aplicarMascaraPlaca(campo);
            } else if (tipo === 'rntrc') {
                aplicarMascaraRntrc(campo);
            } else if (tipo === 'ano') {
                aplicarMascaraAno(campo);
            } else if (tipo === 'decimal') {
                aplicarMascaraDecimal(campo);
            }
        });
    });

})();
