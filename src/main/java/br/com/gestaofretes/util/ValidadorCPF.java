package br.com.gestaofretes.util;

public class ValidadorCPF {

    private ValidadorCPF() {}

    /**
     * Valida CPF pelo dígito verificador.
     * Aceita com ou sem formatação (xxx.xxx.xxx-xx).
     */
    public static boolean isValido(String cpf) {
        if (cpf == null) return false;

        // Remove tudo que não é dígito
        String c = cpf.replaceAll("\\D", "");

        if (c.length() != 11) return false;

        // Rejeita sequências repetidas (111.111.111-11, etc.)
        if (c.chars().distinct().count() == 1) return false;

        // Cálculo do 1º dígito verificador
        int soma = 0;
        for (int i = 0; i < 9; i++) {
            soma += Character.getNumericValue(c.charAt(i)) * (10 - i);
        }
        int primeiroDigito = 11 - (soma % 11);
        if (primeiroDigito >= 10) primeiroDigito = 0;

        if (primeiroDigito != Character.getNumericValue(c.charAt(9))) return false;

        // Cálculo do 2º dígito verificador
        soma = 0;
        for (int i = 0; i < 10; i++) {
            soma += Character.getNumericValue(c.charAt(i)) * (11 - i);
        }
        int segundoDigito = 11 - (soma % 11);
        if (segundoDigito >= 10) segundoDigito = 0;

        return segundoDigito == Character.getNumericValue(c.charAt(10));
    }

    /** Remove formatação e deixa só os 11 dígitos. */
    public static String limpar(String cpf) {
        return cpf == null ? null : cpf.replaceAll("\\D", "");
    }
}
