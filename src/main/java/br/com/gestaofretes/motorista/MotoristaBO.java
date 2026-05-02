package br.com.gestaofretes.motorista;

import br.com.gestaofretes.exception.CadastroException;
import br.com.gestaofretes.util.ValidadorCPF;

import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;

public class MotoristaBO {

    private static final Logger LOG = Logger.getLogger(MotoristaBO.class.getName());
    private final MotoristaDAO dao = new MotoristaDAO();

    public void cadastrar(Motorista m) throws CadastroException {
        validar(m, null);
        try {
            dao.salvar(m);
        } catch (SQLException e) {
            LOG.severe("Erro ao cadastrar motorista: " + e.getMessage());
            throw new CadastroException("Erro inesperado ao salvar o motorista. Tente novamente.");
        }
    }

    public void atualizar(Motorista m) throws CadastroException {
        if (m.getId() == null) throw new CadastroException("ID do motorista não informado.");
        validar(m, m.getId());
        try {
            // Regra: não pode inativar motorista com frete ativo
            if (m.getStatus() != StatusMotorista.ATIVO) {
                if (dao.temFretesAtivos(m.getId())) {
                    throw new CadastroException(
                        "Não é permitido inativar um motorista com fretes em andamento.");
                }
            }
            dao.atualizar(m);
        } catch (CadastroException e) {
            throw e;
        } catch (SQLException e) {
            LOG.severe("Erro ao atualizar motorista: " + e.getMessage());
            throw new CadastroException("Erro inesperado ao atualizar o motorista. Tente novamente.");
        }
    }

    public void excluir(Long id) throws CadastroException {
        try {
            if (dao.temFretesAtivos(id)) {
                throw new CadastroException(
                    "Não é possível excluir o motorista pois ele possui fretes vinculados.");
            }
            dao.excluir(id);
        } catch (CadastroException e) {
            throw e;
        } catch (SQLException e) {
            LOG.severe("Erro ao excluir motorista: " + e.getMessage());
            throw new CadastroException("Erro inesperado ao excluir o motorista. Tente novamente.");
        }
    }

    public List<Motorista> listar(String filtro, int pagina) throws CadastroException {
        try {
            return dao.listar(filtro, pagina);
        } catch (SQLException e) {
            LOG.severe("Erro ao listar motoristas: " + e.getMessage());
            throw new CadastroException("Erro ao carregar a lista de motoristas.");
        }
    }

    public int contarTotal(String filtro) throws CadastroException {
        try {
            return dao.contarTotal(filtro);
        } catch (SQLException e) {
            LOG.severe("Erro ao contar motoristas: " + e.getMessage());
            throw new CadastroException("Erro ao carregar a lista de motoristas.");
        }
    }

    public Motorista buscarPorId(Long id) throws CadastroException {
        try {
            Motorista m = dao.buscarPorId(id);
            if (m == null) throw new CadastroException("Motorista não encontrado.");
            return m;
        } catch (SQLException e) {
            LOG.severe("Erro ao buscar motorista: " + e.getMessage());
            throw new CadastroException("Erro ao buscar o motorista.");
        }
    }

    private void validar(Motorista m, Long idIgnorar) throws CadastroException {
        if (m.getNome() == null || m.getNome().trim().isEmpty()) {
            throw new CadastroException("O nome do motorista é obrigatório.");
        }
        if (m.getCpf() == null || m.getCpf().trim().isEmpty()) {
            throw new CadastroException("O CPF é obrigatório.");
        }
        if (!ValidadorCPF.isValido(m.getCpf())) {
            throw new CadastroException("O CPF informado é inválido.");
        }
        try {
            if (dao.cpfJaCadastrado(ValidadorCPF.limpar(m.getCpf()), idIgnorar)) {
                throw new CadastroException("Já existe um motorista cadastrado com este CPF.");
            }
        } catch (SQLException e) {
            LOG.severe("Erro ao verificar CPF duplicado: " + e.getMessage());
            throw new CadastroException("Erro ao verificar o CPF. Tente novamente.");
        }
        m.setCpf(ValidadorCPF.limpar(m.getCpf()));
    }
}
