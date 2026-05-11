package br.com.gestaofretes.frete;

import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * Máquina de estados do frete.
 * Cada constante declara quais status podem vir DEPOIS dela,
 */
public enum StatusFrete {

    EMITIDO(         "Emitido",          "SAIDA_CONFIRMADA", "CANCELADO"),
    SAIDA_CONFIRMADA("Saída Confirmada", "EM_TRANSITO"),
    EM_TRANSITO(     "Em Trânsito",      "ENTREGUE", "NAO_ENTREGUE"),
    ENTREGUE(        "Entregue"),
    NAO_ENTREGUE(    "Não Entregue"),
    CANCELADO(       "Cancelado");

    private final String           label;
    private final Set<StatusFrete> proximosPermitidos = new LinkedHashSet<>();
    private final String[]         _nomes;

    StatusFrete(String label, String... proximos) {
        this.label  = label;
        this._nomes = proximos;
    }

    static {
        for (StatusFrete s : values()) {
            for (String nome : s._nomes) {
                s.proximosPermitidos.add(StatusFrete.valueOf(nome));
            }
        }
    }

    public String getLabel() { return label; }

    public Set<StatusFrete> getProximosPermitidos() {
        return Collections.unmodifiableSet(proximosPermitidos);
    }

    public boolean podeTransitarPara(StatusFrete destino) {
        return proximosPermitidos.contains(destino);
    }

    /**
     * Lança IllegalStateException com mensagem descritiva se a transição for inválida.
     */
    public void validarTransicao(StatusFrete destino) {
        if (!podeTransitarPara(destino)) {
            String permitidos = proximosPermitidos.isEmpty()
                ? "nenhum (status final)"
                : proximosPermitidos.stream()
                      .map(StatusFrete::getLabel)
                      .reduce((a, b) -> a + ", " + b).orElse("-");
            throw new IllegalStateException(String.format(
                "Transição inválida: '%s' → '%s'. Permitidos a partir de '%s': %s.",
                this.label, destino.label, this.label, permitidos
            ));
        }
    }
}