package br.com.gestaofretes.mensageria;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class NotificacaoMotorista {

    private Long          id;
    private Long          idMotorista;
    private String        motoristaNome;
    private String        cnhNumero;
    private LocalDate     cnhValidade;
    private int           diasRestantes;
    private String        nivel;
    private LocalDateTime processadoEm;

    public NotificacaoMotorista() {}

    public Long          getId()            { return id; }
    public void          setId(Long id)     { this.id = id; }

    public Long          getIdMotorista()              { return idMotorista; }
    public void          setIdMotorista(Long v)        { this.idMotorista = v; }

    public String        getMotoristaNome()            { return motoristaNome; }
    public void          setMotoristaNome(String v)    { this.motoristaNome = v; }

    public String        getCnhNumero()                { return cnhNumero; }
    public void          setCnhNumero(String v)        { this.cnhNumero = v; }

    public LocalDate     getCnhValidade()              { return cnhValidade; }
    public void          setCnhValidade(LocalDate v)   { this.cnhValidade = v; }

    public int           getDiasRestantes()            { return diasRestantes; }
    public void          setDiasRestantes(int v)       { this.diasRestantes = v; }

    public String        getNivel()                    { return nivel; }
    public void          setNivel(String v)            { this.nivel = v; }

    public LocalDateTime getProcessadoEm()             { return processadoEm; }
    public void          setProcessadoEm(LocalDateTime v) { this.processadoEm = v; }
}
