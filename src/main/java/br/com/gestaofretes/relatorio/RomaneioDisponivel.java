package br.com.gestaofretes.relatorio;

/**
 * DTO que representa um agrupamento motorista + data com fretes disponíveis.
 */
public class RomaneioDisponivel {

    private long   idMotorista;
    private String nomeMotorista;
    private String dataEmissao;      // yyyy-MM-dd (para enviar ao relatório)
    private String dataFormatada;    // dd/MM/yyyy (para exibir na tela)
    private int    qtdFretes;
    private String statusResumo;     // ex: "EMITIDO, EM_TRANSITO"

    public RomaneioDisponivel(long idMotorista, String nomeMotorista,
                               String dataEmissao, String dataFormatada,
                               int qtdFretes, String statusResumo) {
        this.idMotorista   = idMotorista;
        this.nomeMotorista = nomeMotorista;
        this.dataEmissao   = dataEmissao;
        this.dataFormatada = dataFormatada;
        this.qtdFretes     = qtdFretes;
        this.statusResumo  = statusResumo;
    }

    public long   getIdMotorista()   { return idMotorista; }
    public String getNomeMotorista() { return nomeMotorista; }
    public String getDataEmissao()   { return dataEmissao; }
    public String getDataFormatada() { return dataFormatada; }
    public int    getQtdFretes()     { return qtdFretes; }
    public String getStatusResumo()  { return statusResumo; }
}
