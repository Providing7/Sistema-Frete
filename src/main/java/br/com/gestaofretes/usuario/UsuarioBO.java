package br.com.gestaofretes.usuario;

import br.com.gestaofretes.exception.CadastroException;
import br.com.gestaofretes.util.BCryptUtil;

import java.sql.SQLException;

public class UsuarioBO {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    public void cadastrar(Usuario usuario) throws CadastroException, SQLException {
        if (usuario.getNomeCompleto() == null || usuario.getNomeCompleto().trim().isEmpty()) {
            throw new CadastroException("Nome completo é obrigatório.");
        }
        if (usuario.getEmail() == null || usuario.getEmail().trim().isEmpty()) {
            throw new CadastroException("E-mail é obrigatório.");
        }
        if (!usuario.getEmail().matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            throw new CadastroException("E-mail inválido. Informe um endereço válido.");
        }
        if (usuario.getSenha() == null || usuario.getSenha().length() < 6) {
            throw new CadastroException("A senha deve ter no mínimo 6 caracteres.");
        }
        if (usuarioDAO.emailJaExiste(usuario.getEmail())) {
            throw new CadastroException("Este e-mail já está cadastrado. Faça login ou use outro e-mail.");
        }

        String senhaHash = BCryptUtil.hashSenha(usuario.getSenha());
        usuarioDAO.inserir(usuario.getEmail(), senhaHash, usuario.getNomeCompleto().trim());
    }
}

