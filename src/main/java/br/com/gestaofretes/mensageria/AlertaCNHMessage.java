package br.com.gestaofretes.mensageria;

import java.time.LocalDate;

public class AlertaCNHMessage {

    private final Long   motoristaId;
    private final String motoristaNome;
    private final String cnhNumero;
    private final LocalDate cnhValidade;
    private final int   diasRestantes;
    private final long  criadaEm; // timestamp de criação na fila

    public AlertaCNHMessage(Long motoristaId, String motoristaNome,
                            String cnhNumero, LocalDate cnhValidade,
                            int diasRestantes) {
        this.motoristaId   = motoristaId;
        this.motoristaNome = motoristaNome;
        this.cnhNumero     = cnhNumero;
        this.cnhValidade   = cnhValidade;
        this.diasRestantes = diasRestantes;
        this.criadaEm      = System.currentTimeMillis();
    }

    public Long      getMotoristaId()   { return motoristaId; }
    public String    getMotoristaNome() { return motoristaNome; }
    public String    getCnhNumero()     { return cnhNumero; }
    public LocalDate getCnhValidade()   { return cnhValidade; }
    public int       getDiasRestantes() { return diasRestantes; }
    public long      getCriadaEm()      { return criadaEm; }

    @Override
    public String toString() {
        return String.format("AlertaCNH{motorista='%s', cnh='%s', validade=%s, diasRestantes=%d}",
                motoristaNome, cnhNumero, cnhValidade, diasRestantes);
    }
}
