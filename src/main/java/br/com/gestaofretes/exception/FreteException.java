package br.com.gestaofretes.exception;

public class FreteException extends NegocioException {
	private static final long serialVersionUID = 1L;

	private final String campo;

	public FreteException(String message) {
		super(message);
		this.campo = null;
	}

	public FreteException(String message, String campo) {
		super(message);
		this.campo = campo;
	}

	public FreteException(String mensagem, Throwable causa) {
		super(mensagem, causa);
		this.campo = null;
	}

	public String getCampo() {
		return campo;
	}
}