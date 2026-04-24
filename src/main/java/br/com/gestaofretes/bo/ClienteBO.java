package br.com.gestaofretes.bo;

import br.com.gestaofretes.dao.ClienteDAO;
import br.com.gestaofretes.exception.CadastroException;
import br.com.gestaofretes.model.Cliente;
import br.com.gestaofretes.util.ValidadorCNPJ;

import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;

public class ClienteBO {

    private static final Logger LOG = Logger.getLogger(ClienteBO.class.getName());
    private final ClienteDAO dao = new ClienteDAO();

    public void cadastrar(Cliente cliente) throws CadastroException {
        validar(cliente, null);
        try {
            dao.salvar(cliente);
        } catch (SQLException e) {
            LOG.severe("Erro ao cadastrar cliente: " + e.getMessage());
            throw new CadastroException("Erro inesperado ao salvar o cliente. Tente novamente.");
        }
    }

    public void atualizar(Cliente cliente) throws CadastroException {
        if (cliente.getId() == null) {
            throw new CadastroException("ID do cliente não informado para atualização.");
        }
        validar(cliente, cliente.getId());
        try {
            dao.atualizar(cliente);
        } catch (SQLException e) {
            LOG.severe("Erro ao atualizar cliente: " + e.getMessage());
            throw new CadastroException("Erro inesperado ao atualizar o cliente. Tente novamente.");
        }
    }

    public void excluir(Long id) throws CadastroException {
        try {
            if (dao.temFretes(id)) {
                throw new CadastroException(
                    "Não é possível excluir o cliente pois ele possui fretes vinculados.");
            }
            dao.excluir(id);
        } catch (SQLException e) {
            LOG.severe("Erro ao excluir cliente: " + e.getMessage());
            throw new CadastroException("Erro inesperado ao excluir o cliente. Tente novamente.");
        }
    }

    public List<Cliente> listar(String filtro, int pagina) throws CadastroException {
        try {
            return dao.listar(filtro, pagina);
        } catch (SQLException e) {
            LOG.severe("Erro ao listar clientes: " + e.getMessage());
            throw new CadastroException("Erro ao carregar a lista de clientes.");
        }
    }

    public int contarTotal(String filtro) throws CadastroException {
        try {
            return dao.contarTotal(filtro);
        } catch (SQLException e) {
            LOG.severe("Erro ao contar clientes: " + e.getMessage());
            throw new CadastroException("Erro ao carregar a lista de clientes.");
        }
    }

    public Cliente buscarPorId(Long id) throws CadastroException {
        try {
            Cliente c = dao.buscarPorId(id);
            if (c == null) throw new CadastroException("Cliente não encontrado.");
            return c;
        } catch (SQLException e) {
            LOG.severe("Erro ao buscar cliente: " + e.getMessage());
            throw new CadastroException("Erro ao buscar o cliente.");
        }
    }

    private void validar(Cliente c, Long idIgnorar) throws CadastroException {
        if (c.getRazaoSocial() == null || c.getRazaoSocial().trim().isEmpty()) {
            throw new CadastroException("A razão social é obrigatória.");
        }
        if (c.getCnpj() == null || c.getCnpj().trim().isEmpty()) {
            throw new CadastroException("O CNPJ é obrigatório.");
        }
        if (!ValidadorCNPJ.isValido(c.getCnpj())) {
            throw new CadastroException("O CNPJ informado é inválido.");
        }
        if (c.getTipo() == null) {
            throw new CadastroException("O tipo do cliente é obrigatório.");
        }
        try {
            if (dao.cnpjJaCadastrado(ValidadorCNPJ.limpar(c.getCnpj()), idIgnorar)) {
                throw new CadastroException("Já existe um cliente cadastrado com este CNPJ.");
            }
        } catch (SQLException e) {
            LOG.severe("Erro ao verificar CNPJ duplicado: " + e.getMessage());
            throw new CadastroException("Erro ao verificar o CNPJ. Tente novamente.");
        }
        // Normaliza: armazena CNPJ sem formatação
        c.setCnpj(ValidadorCNPJ.limpar(c.getCnpj()));
    }
}
