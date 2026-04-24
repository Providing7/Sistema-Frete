package br.com.gestaofretes.bo;

import br.com.gestaofretes.dao.VeiculoDAO;
import br.com.gestaofretes.exception.CadastroException;
import br.com.gestaofretes.model.StatusVeiculo;
import br.com.gestaofretes.model.Veiculo;

import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;

public class VeiculoBO {

    private static final Logger LOG = Logger.getLogger(VeiculoBO.class.getName());
    private final VeiculoDAO dao = new VeiculoDAO();

    public void cadastrar(Veiculo v) throws CadastroException {
        validar(v, null);
        try {
            dao.salvar(v);
        } catch (SQLException e) {
            LOG.severe("Erro ao cadastrar veículo: " + e.getMessage());
            throw new CadastroException("Erro inesperado ao salvar o veículo. Tente novamente.");
        }
    }

    public void atualizar(Veiculo v) throws CadastroException {
        if (v.getId() == null) throw new CadastroException("ID do veículo não informado.");
        validar(v, v.getId());
        try {
            // Regra: não pode setar Disponível manualmente se está EM_VIAGEM
            if (v.getStatus() == StatusVeiculo.DISPONIVEL) {
                Veiculo atual = dao.buscarPorId(v.getId());
                if (atual != null && atual.getStatus() == StatusVeiculo.EM_VIAGEM) {
                    throw new CadastroException(
                        "Não é permitido alterar o status para Disponível enquanto o veículo está Em Viagem. " +
                        "O status é atualizado automaticamente ao concluir o frete.");
                }
            }
            dao.atualizar(v);
        } catch (CadastroException e) {
            throw e;
        } catch (SQLException e) {
            LOG.severe("Erro ao atualizar veículo: " + e.getMessage());
            throw new CadastroException("Erro inesperado ao atualizar o veículo. Tente novamente.");
        }
    }

    public void excluir(Long id) throws CadastroException {
        try {
            if (dao.temFretesAtivos(id)) {
                throw new CadastroException(
                    "Não é possível excluir o veículo pois ele possui fretes vinculados.");
            }
            dao.excluir(id);
        } catch (CadastroException e) {
            throw e;
        } catch (SQLException e) {
            LOG.severe("Erro ao excluir veículo: " + e.getMessage());
            throw new CadastroException("Erro inesperado ao excluir o veículo. Tente novamente.");
        }
    }

    public List<Veiculo> listar(String filtro, int pagina) throws CadastroException {
        try {
            return dao.listar(filtro, pagina);
        } catch (SQLException e) {
            LOG.severe("Erro ao listar veículos: " + e.getMessage());
            throw new CadastroException("Erro ao carregar a lista de veículos.");
        }
    }

    public int contarTotal(String filtro) throws CadastroException {
        try {
            return dao.contarTotal(filtro);
        } catch (SQLException e) {
            LOG.severe("Erro ao contar veículos: " + e.getMessage());
            throw new CadastroException("Erro ao carregar a lista de veículos.");
        }
    }

    public Veiculo buscarPorId(Long id) throws CadastroException {
        try {
            Veiculo v = dao.buscarPorId(id);
            if (v == null) throw new CadastroException("Veículo não encontrado.");
            return v;
        } catch (SQLException e) {
            LOG.severe("Erro ao buscar veículo: " + e.getMessage());
            throw new CadastroException("Erro ao buscar o veículo.");
        }
    }

    private void validar(Veiculo v, Long idIgnorar) throws CadastroException {
        if (v.getPlaca() == null || v.getPlaca().trim().isEmpty()) {
            throw new CadastroException("A placa é obrigatória.");
        }
        // Placa Mercosul: AAA1A11 ou formato antigo: AAA1111
        if (!v.getPlaca().matches("[A-Z]{3}[0-9][A-Z0-9][0-9]{2}")) {
            throw new CadastroException("A placa informada não está em formato válido (ex: ABC1D23 ou ABC1234).");
        }
        if (v.getTipo() == null) {
            throw new CadastroException("O tipo do veículo é obrigatório.");
        }
        if (v.getCapacidadeKg() <= 0) {
            throw new CadastroException("A capacidade de carga deve ser maior que zero.");
        }
        try {
            if (dao.placaJaCadastrada(v.getPlaca().toUpperCase(), idIgnorar)) {
                throw new CadastroException("Já existe um veículo cadastrado com esta placa.");
            }
        } catch (SQLException e) {
            LOG.severe("Erro ao verificar placa duplicada: " + e.getMessage());
            throw new CadastroException("Erro ao verificar a placa. Tente novamente.");
        }
        v.setPlaca(v.getPlaca().toUpperCase());
    }
}
