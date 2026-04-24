package br.com.gestaofretes.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Frete {
    private Long id;
    private String numero; // formato FRT-AAAA-NNNNN
    private Cliente remetente;
    private Cliente destinatario;
    private Motorista motorista;
    private Veiculo veiculo;
    private String municipioOrigem;
    private String ufOrigem;
    private String municipioDestino;
    private String ufDestino;
    private String descricaoCarga;
    private double pesoKg;
    private int volumes;
    private double valorFrete;
    private double aliquotaIcms;
    private double valorIcms;
    private double valorTotal;
    private StatusFrete status;
    private LocalDate dataEmissao;
    private LocalDate dataPrevisaoEntrega;
    private LocalDateTime dataSaida;
    private LocalDateTime dataEntrega;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNumero() { return numero; }
    public void setNumero(String numero) { this.numero = numero; }

    public Cliente getRemetente() { return remetente; }
    public void setRemetente(Cliente remetente) { this.remetente = remetente; }

    public Cliente getDestinatario() { return destinatario; }
    public void setDestinatario(Cliente destinatario) { this.destinatario = destinatario; }

    public Motorista getMotorista() { return motorista; }
    public void setMotorista(Motorista motorista) { this.motorista = motorista; }

    public Veiculo getVeiculo() { return veiculo; }
    public void setVeiculo(Veiculo veiculo) { this.veiculo = veiculo; }

    public String getMunicipioOrigem() { return municipioOrigem; }
    public void setMunicipioOrigem(String municipioOrigem) { this.municipioOrigem = municipioOrigem; }

    public String getUfOrigem() { return ufOrigem; }
    public void setUfOrigem(String ufOrigem) { this.ufOrigem = ufOrigem; }

    public String getMunicipioDestino() { return municipioDestino; }
    public void setMunicipioDestino(String municipioDestino) { this.municipioDestino = municipioDestino; }

    public String getUfDestino() { return ufDestino; }
    public void setUfDestino(String ufDestino) { this.ufDestino = ufDestino; }

    public String getDescricaoCarga() { return descricaoCarga; }
    public void setDescricaoCarga(String descricaoCarga) { this.descricaoCarga = descricaoCarga; }

    public double getPesoKg() { return pesoKg; }
    public void setPesoKg(double pesoKg) { this.pesoKg = pesoKg; }

    public int getVolumes() { return volumes; }
    public void setVolumes(int volumes) { this.volumes = volumes; }

    public double getValorFrete() { return valorFrete; }
    public void setValorFrete(double valorFrete) { this.valorFrete = valorFrete; }

    public double getAliquotaIcms() { return aliquotaIcms; }
    public void setAliquotaIcms(double aliquotaIcms) { this.aliquotaIcms = aliquotaIcms; }

    public double getValorIcms() { return valorIcms; }
    public void setValorIcms(double valorIcms) { this.valorIcms = valorIcms; }

    public double getValorTotal() { return valorTotal; }
    public void setValorTotal(double valorTotal) { this.valorTotal = valorTotal; }

    public StatusFrete getStatus() { return status; }
    public void setStatus(StatusFrete status) { this.status = status; }

    public LocalDate getDataEmissao() { return dataEmissao; }
    public void setDataEmissao(LocalDate dataEmissao) { this.dataEmissao = dataEmissao; }

    public LocalDate getDataPrevisaoEntrega() { return dataPrevisaoEntrega; }
    public void setDataPrevisaoEntrega(LocalDate dataPrevisaoEntrega) { this.dataPrevisaoEntrega = dataPrevisaoEntrega; }

    public LocalDateTime getDataSaida() { return dataSaida; }
    public void setDataSaida(LocalDateTime dataSaida) { this.dataSaida = dataSaida; }

    public LocalDateTime getDataEntrega() { return dataEntrega; }
    public void setDataEntrega(LocalDateTime dataEntrega) { this.dataEntrega = dataEntrega; }
}
