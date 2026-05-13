package br.com.gestaofretes.mensageria;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.logging.Logger;

/**
 * FILA DE MENSAGENS — singleton que age como broker interno.
 * o Produtor (Scheduler) e o Consumidor (Consumer) nunca se conhecem diretamente, só falam com a fila.
 * BlockingQueue garante thread-safety sem synchronized manual.
 */
public class AlertaCNHQueue {

    private static final Logger log = Logger.getLogger(AlertaCNHQueue.class.getName());

    // Capacidade máxima de mensagens aguardando processamento
    private static final int CAPACIDADE = 500;

    // Instância única (Singleton)
    private static final AlertaCNHQueue INSTANCE = new AlertaCNHQueue();

    // A fila em si — thread-safe por natureza
    private final BlockingQueue<AlertaCNHMessage> fila =
            new LinkedBlockingQueue<>(CAPACIDADE);

    private AlertaCNHQueue() {}

    public static AlertaCNHQueue getInstance() {
        return INSTANCE;
    }

    /**
     * PRODUTOR chama este método para publicar uma mensagem.
     * Se a fila estiver cheia, loga aviso e descarta (offer não bloqueia).
     */
    public void publicar(AlertaCNHMessage msg) {
        boolean aceita = fila.offer(msg);
        if (aceita) {
            log.info("[FILA] Mensagem publicada: " + msg);
        } else {
            log.warning("[FILA] Fila cheia! Mensagem descartada: " + msg);
        }
    }

    /**
     * CONSUMIDOR chama este método para retirar mensagens.
     * Bloqueia a thread até uma mensagem estar disponível.
     * Isso evita polling (loop infinito verificando a fila).
     */
    public AlertaCNHMessage consumir() throws InterruptedException {
        return fila.take(); // bloqueia se vazia — eficiente!
    }

    public int tamanho() {
        return fila.size();
    }
}
