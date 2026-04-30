package br.com.gestaofretes.bo;

import br.com.gestaofretes.dao.OcorrenciaDAO;
import br.com.gestaofretes.exception.FreteException;
import br.com.gestaofretes.model.*;

import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;

public class OcorrenciaBO {

    private static final Logger LOG = Logger.getLogger(OcorrenciaBO.class.getName());

    private final OcorrenciaDAO ocorrenciaDAO = new OcorrenciaDAO();
    private final FreteBO freteBO = new FreteBO();

    /**
     * Registra uma nova ocorrência para um frete.
     * Valida regras de negócio antes de persistir.
     * Para ENTREGA_REALIZADA, delega ao FreteBO que executa a transação completa.
     */
    public void registrarOcorrencia(OcorrenciaFrete ocorrencia) throws FreteException {
        // 1. Buscar o frete e verificar se aceita novas ocorrências
        Frete frete = freteBO.buscarPorId(ocorrencia.getIdFrete());

        if (frete.getStatus() == StatusFrete.ENTREGUE
                || frete.getStatus() == StatusFrete.NAO_ENTREGUE
                || frete.getStatus() == StatusFrete.CANCELADO) {
            throw new FreteException(
                "Não é possível registrar ocorrências para fretes com status " + frete.getStatus() + ".");
        }

        // 2. Data/hora não pode ser anterior à última ocorrência
        try {
            OcorrenciaFrete ultima = ocorrenciaDAO.buscarUltimaPorFrete(ocorrencia.getIdFrete());
            if (ultima != null && ocorrencia.getDataHora() != null
                    && ocorrencia.getDataHora().isBefore(ultima.getDataHora())) {
                throw new FreteException(
                    "A data/hora da ocorrência não pode ser anterior à última ocorrência registrada ("
                    + ultima.getDataHora() + ").");
            }
        } catch (SQLException e) {
            LOG.severe("Erro ao verificar última ocorrência: " + e.getMessage());
            throw new FreteException("Erro ao validar a data da ocorrência.");
        }

        // 3. Descrição obrigatória para AVARIA, EXTRAVIO e OUTROS
        TipoOcorrencia tipo = ocorrencia.getTipo();
        if ((tipo == TipoOcorrencia.AVARIA
                || tipo == TipoOcorrencia.EXTRAVIO
                || tipo == TipoOcorrencia.OUTROS)
                && (ocorrencia.getDescricao() == null || ocorrencia.getDescricao().trim().isEmpty())) {
            throw new FreteException("A descrição é obrigatória para ocorrências do tipo "
                    + tipo.name() + ".");
        }

        // 4. ENTREGA_REALIZADA — delega ao FreteBO (transação frete + veículo + ocorrência)
        if (tipo == TipoOcorrencia.ENTREGA_REALIZADA) {
            if (ocorrencia.getNomeRecebedor() == null || ocorrencia.getNomeRecebedor().trim().isEmpty()) {
                throw new FreteException("O nome do recebedor é obrigatório para Entrega Realizada.");
            }
            if (ocorrencia.getDocumentoRecebedor() == null
                    || ocorrencia.getDocumentoRecebedor().trim().isEmpty()) {
                throw new FreteException("O documento do recebedor é obrigatório para Entrega Realizada.");
            }
            freteBO.registrarEntrega(
                ocorrencia.getIdFrete(),
                ocorrencia.getDataHora(),
                ocorrencia.getNomeRecebedor(),
                ocorrencia.getDocumentoRecebedor(),
                ocorrencia.getMunicipio(),
                ocorrencia.getUf()
            );
            return; // FreteBO já salvou a ocorrência dentro da transação
        }

        // 5. Demais tipos — salvar ocorrência (conexão própria, sem transação composta)
        try {
            java.sql.Connection conn = br.com.gestaofretes.util.ConexaoDB.getConnection();
            conn.setAutoCommit(false);
            try {
                ocorrenciaDAO.salvar(ocorrencia, conn);
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.close();
            }
        } catch (SQLException e) {
            LOG.severe("Erro ao salvar ocorrência: " + e.getMessage());
            throw new FreteException("Erro inesperado ao registrar a ocorrência. Tente novamente.");
        }
    }

    public List<OcorrenciaFrete> listarPorFrete(Long idFrete) throws FreteException {
        try {
            return ocorrenciaDAO.listarPorFrete(idFrete);
        } catch (SQLException e) {
            LOG.severe("Erro ao listar ocorrências: " + e.getMessage());
            throw new FreteException("Erro ao carregar as ocorrências do frete.");
        }
    }
}
