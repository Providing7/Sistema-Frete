package br.com.gestaofretes.exception;

public class FreteException extends NegocioException {
	private static final long serialVersionUID = 1L;

	public FreteException(String message) {
		super(message);
	}

	public FreteException(String mensagem, Throwable causa) {
		super(mensagem, causa);
	}
}
