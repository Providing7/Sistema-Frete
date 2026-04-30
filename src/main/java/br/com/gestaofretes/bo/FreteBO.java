package br.com.gestaofretes.bo;

import br.com.gestaofretes.dao.FreteDAO;
import br.com.gestaofretes.dao.VeiculoDAO;
import br.com.gestaofretes.exception.FreteException;
import br.com.gestaofretes.model.*;
import br.com.gestaofretes.util.ConexaoDB;
import br.com.gestaofretes.util.FreteNumeroGerador;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.logging.Logger;

public class FreteBO {

    private static final Logger LOG = Logger.getLogger(FreteBO.class.getName());

    private final FreteDAO freteDAO    = new FreteDAO();
    private final VeiculoDAO veiculoDAO = new VeiculoDAO();

    // ================================================================
    // EMITIR FRETE
    // ================================================================
    public void emitirFrete(Frete frete) throws FreteException {
        validarDadosObrigatorios(frete);
        validarRegrasDeEmissao(frete);

        try (Connection conn = ConexaoDB.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int ano = LocalDate.now().getYear();
                int seq = freteDAO.proximoSequencial(ano);
                frete.setNumero(FreteNumeroGerador.gerar(ano, seq));
                frete.setStatus(StatusFrete.EMITIDO);
                frete.setDataEmissao(LocalDate.now());
                freteDAO.salvar(frete, conn);
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            LOG.severe("Erro ao emitir frete: " + e.getMessage());
            throw new FreteException("Erro inesperado ao emitir o frete. Tente novamente.");
        }
    }

    // ================================================================
    // CONFIRMAR SAÍDA — transação: frete + veículo
    // ================================================================
    public void confirmarSaida(Long idFrete, LocalDateTime dataSaida) throws FreteException {
        if (dataSaida == null) {
            throw new FreteException("A data e hora de saída são obrigatórias.");
        }
        Frete frete = buscarOuLancar(idFrete);
        if (frete.getStatus() != StatusFrete.EMITIDO) {
            throw new FreteException("Apenas fretes com status EMITIDO podem ter a saída confirmada.");
        }
        try (Connection conn = ConexaoDB.getConnection()) {
            conn.setAutoCommit(false);
            try {
                freteDAO.atualizarStatus(idFrete, StatusFrete.SAIDA_CONFIRMADA, conn);
                freteDAO.atualizarDataSaida(idFrete, Timestamp.valueOf(dataSaida), conn);
                veiculoDAO.atualizarStatus(frete.getVeiculo().getId(), StatusVeiculo.EM_VIAGEM, conn);
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            LOG.severe("Erro ao confirmar saída do frete " + idFrete + ": " + e.getMessage());
            throw new FreteException("Erro inesperado ao confirmar a saída. Tente novamente.");
        }
    }

    // ================================================================
    // REGISTRAR EM TRÂNSITO
    // ================================================================
    public void registrarEmTransito(Long idFrete) throws FreteException {
        Frete frete = buscarOuLancar(idFrete);
        if (frete.getStatus() != StatusFrete.SAIDA_CONFIRMADA) {
            throw new FreteException("Apenas fretes com saída confirmada podem ser colocados em trânsito.");
        }
        try (Connection conn = ConexaoDB.getConnection()) {
            conn.setAutoCommit(false);
            try {
                freteDAO.atualizarStatus(idFrete, StatusFrete.EM_TRANSITO, conn);
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            LOG.severe("Erro ao registrar trânsito do frete " + idFrete + ": " + e.getMessage());
            throw new FreteException("Erro inesperado ao registrar em trânsito. Tente novamente.");
        }
    }

    // ================================================================
    // REGISTRAR ENTREGA — transação: frete + veículo + ocorrência
    // Chamado diretamente ou via OcorrenciaBO para ENTREGA_REALIZADA
    // ================================================================
    public void registrarEntrega(Long idFrete, LocalDateTime dataEntrega,
                                  String nomeRecebedor, String documentoRecebedor,
                                  String municipio, String uf) throws FreteException {
        if (nomeRecebedor == null || nomeRecebedor.trim().isEmpty()) {
            throw new FreteException("O nome do recebedor é obrigatório para registrar a entrega.");
        }
        if (documentoRecebedor == null || documentoRecebedor.trim().isEmpty()) {
            throw new FreteException("O documento do recebedor é obrigatório para registrar a entrega.");
        }
        Frete frete = buscarOuLancar(idFrete);
        if (frete.getStatus() != StatusFrete.EM_TRANSITO) {
            throw new FreteException("Apenas fretes em trânsito podem ser marcados como entregues.");
        }
        LocalDateTime dataHoraEntrega = dataEntrega != null ? dataEntrega : LocalDateTime.now();

        OcorrenciaFrete oc = new OcorrenciaFrete();
        oc.setIdFrete(idFrete);
        oc.setTipo(TipoOcorrencia.ENTREGA_REALIZADA);
        oc.setDataHora(dataHoraEntrega);
        oc.setMunicipio(municipio);
        oc.setUf(uf);
        oc.setNomeRecebedor(nomeRecebedor.trim());
        oc.setDocumentoRecebedor(documentoRecebedor.trim());

        try (Connection conn = ConexaoDB.getConnection()) {
            conn.setAutoCommit(false);
            try {
                freteDAO.atualizarStatus(idFrete, StatusFrete.ENTREGUE, conn);
                freteDAO.atualizarDataEntrega(idFrete, Timestamp.valueOf(dataHoraEntrega), conn);
                veiculoDAO.atualizarStatus(frete.getVeiculo().getId(), StatusVeiculo.DISPONIVEL, conn);
                new br.com.gestaofretes.dao.OcorrenciaDAO().salvar(oc, conn);
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            LOG.severe("Erro ao registrar entrega do frete " + idFrete + ": " + e.getMessage());
            throw new FreteException("Erro inesperado ao registrar a entrega. Tente novamente.");
        }
    }

    // ================================================================
    // REGISTRAR NÃO ENTREGUE — transação: frete + veículo
    // ================================================================
    public void registrarNaoEntregue(Long idFrete, String motivo) throws FreteException {
        if (motivo == null || motivo.trim().isEmpty()) {
            throw new FreteException("O motivo é obrigatório ao registrar a não entrega.");
        }
        Frete frete = buscarOuLancar(idFrete);
        if (frete.getStatus() != StatusFrete.EM_TRANSITO) {
            throw new FreteException("Apenas fretes em trânsito podem ser marcados como não entregues.");
        }
        try (Connection conn = ConexaoDB.getConnection()) {
            conn.setAutoCommit(false);
            try {
                freteDAO.atualizarStatus(idFrete, StatusFrete.NAO_ENTREGUE, conn);
                veiculoDAO.atualizarStatus(frete.getVeiculo().getId(), StatusVeiculo.DISPONIVEL, conn);
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            LOG.severe("Erro ao registrar não entrega do frete " + idFrete + ": " + e.getMessage());
            throw new FreteException("Erro inesperado ao registrar a não entrega. Tente novamente.");
        }
    }

    // ================================================================
    // CANCELAR
    // ================================================================
    public void cancelar(Long idFrete) throws FreteException {
        Frete frete = buscarOuLancar(idFrete);
        if (frete.getStatus() != StatusFrete.EMITIDO) {
            throw new FreteException("Somente fretes com status EMITIDO podem ser cancelados.");
        }
        try (Connection conn = ConexaoDB.getConnection()) {
            conn.setAutoCommit(false);
            try {
                freteDAO.atualizarStatus(idFrete, StatusFrete.CANCELADO, conn);
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            LOG.severe("Erro ao cancelar frete " + idFrete + ": " + e.getMessage());
            throw new FreteException("Erro inesperado ao cancelar o frete. Tente novamente.");
        }
    }

    // ================================================================
    // LISTAR / BUSCAR
    // ================================================================
    public List<Frete> listar(String filtro, int pagina) throws FreteException {
        try {
            return freteDAO.listar(filtro, pagina);
        } catch (SQLException e) {
            LOG.severe("Erro ao listar fretes: " + e.getMessage());
            throw new FreteException("Erro ao carregar a lista de fretes.");
        }
    }

    public int contarTotal(String filtro) throws FreteException {
        try {
            return freteDAO.contarTotal(filtro);
        } catch (SQLException e) {
            LOG.severe("Erro ao contar fretes: " + e.getMessage());
            throw new FreteException("Erro ao carregar a lista de fretes.");
        }
    }

    public Frete buscarPorId(Long id) throws FreteException {
        try {
            Frete f = freteDAO.buscarPorId(id);
            if (f == null) throw new FreteException("Frete não encontrado.");
            return f;
        } catch (SQLException e) {
            LOG.severe("Erro ao buscar frete: " + e.getMessage());
            throw new FreteException("Erro ao buscar o frete.");
        }
    }

    // ================================================================
    // VALIDAÇÕES PRIVADAS
    // ================================================================
    private void validarDadosObrigatorios(Frete f) throws FreteException {
        if (f.getRemetente() == null || f.getRemetente().getId() == null) {
            throw new FreteException("O remetente é obrigatório.");
        }
        if (f.getDestinatario() == null || f.getDestinatario().getId() == null) {
            throw new FreteException("O destinatário é obrigatório.");
        }
        if (f.getMotorista() == null || f.getMotorista().getId() == null) {
            throw new FreteException("O motorista é obrigatório.");
        }
        if (f.getVeiculo() == null || f.getVeiculo().getId() == null) {
            throw new FreteException("O veículo é obrigatório.");
        }
        if (f.getMunicipioOrigem() == null || f.getMunicipioOrigem().trim().isEmpty()) {
            throw new FreteException("O município de origem é obrigatório.");
        }
        if (f.getUfOrigem() == null || f.getUfOrigem().trim().isEmpty()) {
            throw new FreteException("A UF de origem é obrigatória.");
        }
        if (f.getMunicipioDestino() == null || f.getMunicipioDestino().trim().isEmpty()) {
            throw new FreteException("O município de destino é obrigatório.");
        }
        if (f.getUfDestino() == null || f.getUfDestino().trim().isEmpty()) {
            throw new FreteException("A UF de destino é obrigatória.");
        }
        if (f.getDataPrevisaoEntrega() == null) {
            throw new FreteException("A data prevista de entrega é obrigatória.");
        }
    }

    private void validarRegrasDeEmissao(Frete f) throws FreteException {
        LocalDate hoje = LocalDate.now();

        if (!f.getDataPrevisaoEntrega().isAfter(hoje)) {
            throw new FreteException("A data prevista de entrega deve ser posterior à data de emissão.");
        }
        if (f.getVeiculo().getStatus() != StatusVeiculo.DISPONIVEL) {
            throw new FreteException("O veículo selecionado não está disponível (status: "
                    + f.getVeiculo().getStatus() + ").");
        }
        if (f.getMotorista().getStatus() != StatusMotorista.ATIVO) {
            throw new FreteException("O motorista selecionado não está ativo.");
        }
        try {
            if (freteDAO.motoristaTemFreteAtivo(f.getMotorista().getId())) {
                throw new FreteException("O motorista já está em uma viagem em andamento.");
            }
        } catch (SQLException e) {
            LOG.severe("Erro ao verificar fretes do motorista: " + e.getMessage());
            throw new FreteException("Erro ao verificar disponibilidade do motorista.");
        }
        if (f.getMotorista().getCnhValidade() != null
                && f.getMotorista().getCnhValidade().isBefore(hoje)) {
            throw new FreteException("A CNH do motorista está vencida.");
        }
        if (f.getPesoKg() > f.getVeiculo().getCapacidadeKg()) {
            throw new FreteException("O peso da carga (" + f.getPesoKg() +
                    " kg) excede a capacidade do veículo (" + f.getVeiculo().getCapacidadeKg() + " kg).");
        }
    }

    private Frete buscarOuLancar(Long idFrete) throws FreteException {
        try {
            Frete frete = freteDAO.buscarPorId(idFrete);
            if (frete == null) throw new FreteException("Frete não encontrado.");
            return frete;
        } catch (SQLException e) {
            LOG.severe("Erro ao buscar frete " + idFrete + ": " + e.getMessage());
            throw new FreteException("Erro ao buscar o frete.");
        }
    }
}