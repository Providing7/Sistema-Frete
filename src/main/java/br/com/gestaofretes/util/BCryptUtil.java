package br.com.gestaofretes.util;

import java.security.SecureRandom;

/**
 * Utilitário de hash BCrypt (baseado na implementação pública jBCrypt - Damien Miller).
 * Uso: BCryptUtil.hashSenha("minhasenha")  →  hash armazenado no banco
 *      BCryptUtil.verificar("minhasenha", hash)  →  true/false
 */
public final class BCryptUtil {

    private BCryptUtil() {}

    private static final int LOG_ROUNDS = 12;

    // Tabelas BCrypt 
    private static final int BLOWFISH_NUM_ROUNDS = 16;
    private static final long[] P_ORIG = {
        0x243f6a8885a308d3L, 0x13198a2e03707344L, 0xa4093822299f31d0L,
        0x082efa98ec4e6c89L, 0x452821e638d01377L, 0xbe5466cf34e90c6cL,
        0xc0ac29b7c97c50ddL, 0x3f84d5b5b5470917L, 0x9216d5d98979fb1bL,
        0xd1310ba698dfb5acL, 0x2ffd72dbd01adfb7L, 0xb8e1afed6a267e96L,
        0xba7c9045f12c7f99L, 0x24a19947b3916cf7L, 0x0801f2e2858efc16L,
        0x636920d871574e69L, 0xa458fea3f4933d7eL, 0x0d95748f728eb658L
    };

    private static final long[] S_ORIG = {
        0xd1310ba6L,0x98dfb5acL,0x2ffd72dbL,0xd01adfb7L,0xb8e1afedL,0x6a267e96L,0xba7c9045L,0xf12c7f99L,
        0x24a19947L,0xb3916cf7L,0x0801f2e2L,0x858efc16L,0x636920d8L,0x71574e69L,0xa458feaL, 0x3f4933d7L,
        0xe0d95748L,0xf728eb65L,0x8bcd5471L,0x85efa325L,0x6d782065L,0x63aaaaL,  0x9c60a8bbL,0x17d8f8f9L,
        0x9ccea1cdL,0x1ccf6b1bL,0xcfbce988L,0x97ccaL,   0xf1c8bc80L,0x93e3b5c4L,0xa13e24b8L,0x35a6af72L
    };

    // Usamos java.security para a parte de hash real via PBKDF-like com Blowfish
    // Para simplicidade segura, delegamos para a implementação canônica via reflexão ou
    // usamos a abordagem de "senha + salt" com SHA-256 + iterações (PBKDF2).
    // Mas o ideal é ter o jBCrypt. Aqui fornecemos a API pública e usamos PBKDF2WithHmacSHA256
    // como substituto seguro até a JAR ser adicionada.

    private static final java.security.SecureRandom RANDOM = new java.security.SecureRandom();

    /**
     * Gera hash seguro da senha usando PBKDF2WithHmacSHA256 com salt aleatório.
     * Formato armazenado: $pbkdf2$SALT_HEX$HASH_HEX
     */
    public static String hashSenha(String senha) {
        try {
            byte[] salt = new byte[16];
            RANDOM.nextBytes(salt);
            byte[] hash = pbkdf2(senha.toCharArray(), salt, 65536, 32);
            return "$pbkdf2$" + toHex(salt) + "$" + toHex(hash);
        } catch (Exception e) {
            throw new RuntimeException("Erro ao gerar hash de senha.", e);
        }
    }

    /**
     * Verifica senha contra hash armazenado.
     */
    public static boolean verificar(String senha, String hashArmazenado) {
        try {
            if (hashArmazenado == null || !hashArmazenado.startsWith("$pbkdf2$")) return false;
            String[] partes = hashArmazenado.split("\\$");
            // partes[0]="", partes[1]="pbkdf2", partes[2]=salt, partes[3]=hash
            byte[] salt = fromHex(partes[2]);
            byte[] hashEsperado = fromHex(partes[3]);
            byte[] hashTentativa = pbkdf2(senha.toCharArray(), salt, 65536, 32);
            return slowEquals(hashEsperado, hashTentativa);
        } catch (Exception e) {
            return false;
        }
    }

    private static byte[] pbkdf2(char[] password, byte[] salt, int iterations, int keyLen) throws Exception {
        javax.crypto.spec.PBEKeySpec spec =
            new javax.crypto.spec.PBEKeySpec(password, salt, iterations, keyLen * 8);
        javax.crypto.SecretKeyFactory skf =
            javax.crypto.SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        return skf.generateSecret(spec).getEncoded();
    }

    private static boolean slowEquals(byte[] a, byte[] b) {
        int diff = a.length ^ b.length;
        for (int i = 0; i < a.length && i < b.length; i++) diff |= a[i] ^ b[i];
        return diff == 0;
    }

    private static String toHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) sb.append(String.format("%02x", b));
        return sb.toString();
    }

    private static byte[] fromHex(String hex) {
        int len = hex.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2)
            data[i / 2] = (byte) ((Character.digit(hex.charAt(i), 16) << 4)
                                 + Character.digit(hex.charAt(i + 1), 16));
        return data;
    }
}
