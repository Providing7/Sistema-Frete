package br.com.gestaofretes.mensageria;

import java.util.logging.Level;
import java.util.logging.Logger;

public class AlertaCNHConsumer implements Runnable {

    private static final Logger log = Logger.getLogger(AlertaCNHConsumer.class.getName());

    private final NotificacaoMotoristaDAO notificacaoDAO = new NotificacaoMotoristaDAO();

    private volatile boolean rodando = true;

    @Override
    public void run() {
        log.info("[CONSUMER] Iniciado — aguardando alertas de CNH na fila...");

        while (rodando) {
            try {
                AlertaCNHMessage msg = AlertaCNHQueue.getInstance().consumir();
                processarAlerta(msg);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                log.info("[CONSUMER] Interrompido — encerrando.");
                break;
            } catch (Exception e) {
                log.log(Level.SEVERE, "[CONSUMER] Erro ao processar mensagem", e);
            }
        }
    }

    private void processarAlerta(AlertaCNHMessage msg) {
        String nivel = msg.getDiasRestantes() <= 15 ? "CRITICO" :
                       msg.getDiasRestantes() <= 30 ? "ATENCAO" : "AVISO";

        String icone = "CRITICO".equals(nivel) ? "🔴 CRÍTICO" :
                       "ATENCAO".equals(nivel) ? "🟡 ATENÇÃO" : "🟢 AVISO";

        log.warning(String.format(
            "[CONSUMER] %s | Motorista: %-30s | CNH: %-15s | Vence: %s | Dias restantes: %d",
            icone,
            msg.getMotoristaNome(),
            msg.getCnhNumero(),
            msg.getCnhValidade(),
            msg.getDiasRestantes()
        ));

        try {
            notificacaoDAO.salvar(msg, nivel);
            log.info("[CONSUMER] Notificação persistida para motorista: " + msg.getMotoristaNome());
        } catch (Exception e) {
            log.log(Level.SEVERE, "[CONSUMER] Falha ao persistir notificação para "
                    + msg.getMotoristaNome(), e);
        }
    }

    public void parar() {
        rodando = false;
    }
}

