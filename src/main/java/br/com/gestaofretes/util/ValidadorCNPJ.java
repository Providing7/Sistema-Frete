package br.com.gestaofretes.util;

public class ValidadorCNPJ {

    private ValidadorCNPJ() {}

    public static boolean isValido(String cnpj) {
        if (cnpj == null) return false;

        String c = cnpj.replaceAll("\\D", "");

        if (c.length() != 14) return false;

        if (c.chars().distinct().count() == 1) return false;

        // Pesos para o 1º dígito
        int[] pesosPrimeiro = {5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
        int soma = 0;
        for (int i = 0; i < 12; i++) {
            soma += Character.getNumericValue(c.charAt(i)) * pesosPrimeiro[i];
        }
        int primeiroDigito = soma % 11 < 2 ? 0 : 11 - (soma % 11);

        if (primeiroDigito != Character.getNumericValue(c.charAt(12))) return false;

        // Pesos para o 2º dígito
        int[] pesosSegundo = {6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
        soma = 0;
        for (int i = 0; i < 13; i++) {
            soma += Character.getNumericValue(c.charAt(i)) * pesosSegundo[i];
        }
        int segundoDigito = soma % 11 < 2 ? 0 : 11 - (soma % 11);

        return segundoDigito == Character.getNumericValue(c.charAt(13));
    }

    public static String limpar(String cnpj) {
        return cnpj == null ? null : cnpj.replaceAll("\\D", "");
    }
}
