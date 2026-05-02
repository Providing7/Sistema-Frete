// util/FreteNumeroGerador.java
package br.com.gestaofretes.frete;

public class FreteNumeroGerador {

    // Chamado pelo FreteBO, recebe o próximo sequencial já calculado
    public static String gerar(int ano, int sequencial) {
        return String.format("FRT-%d-%05d", ano, sequencial);
    }
}
