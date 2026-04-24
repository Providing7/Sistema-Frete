package br.com.gestaofretes.exception;

public class CadastroException extends NegocioException {
	private static final long serialVersionUID = 1L;

	public CadastroException(String message) {
		super(message);
	}

	public CadastroException(String mensagem, Throwable causa) {
		super(mensagem, causa);
	}
}
