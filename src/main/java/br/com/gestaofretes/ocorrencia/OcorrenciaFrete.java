package br.com.gestaofretes.ocorrencia;

import java.time.LocalDateTime;

public class OcorrenciaFrete {
    private Long id;
    private Long idFrete;
    private TipoOcorrencia tipo;
    private LocalDateTime dataHora;
    private String municipio;
    private String uf;
    private String descricao;
    private String nomeRecebedor;
    private String documentoRecebedor;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getIdFrete() { return idFrete; }
    public void setIdFrete(Long idFrete) { this.idFrete = idFrete; }

    public TipoOcorrencia getTipo() { return tipo; }
    public void setTipo(TipoOcorrencia tipo) { this.tipo = tipo; }

    public LocalDateTime getDataHora() { return dataHora; }
    public void setDataHora(LocalDateTime dataHora) { this.dataHora = dataHora; }

    public String getMunicipio() { return municipio; }
    public void setMunicipio(String municipio) { this.municipio = municipio; }

    public String getUf() { return uf; }
    public void setUf(String uf) { this.uf = uf; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public String getNomeRecebedor() { return nomeRecebedor; }
    public void setNomeRecebedor(String nomeRecebedor) { this.nomeRecebedor = nomeRecebedor; }

    public String getDocumentoRecebedor() { return documentoRecebedor; }
    public void setDocumentoRecebedor(String documentoRecebedor) { this.documentoRecebedor = documentoRecebedor; }
}
