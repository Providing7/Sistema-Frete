package br.com.gestaofretes.mensageria;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * CONSUMIDOR — roda em thread própria, fica escutando a fila 24/7.
 * processa alertas de forma totalmente ASSÍNCRONA.
 * O Scheduler publica e segue em frente; esta thread cuida do resto
 * sem bloquear nenhuma requisição HTTP do usuário.
 */
public class AlertaCNHConsumer implements Runnable {

    private static final Logger log = Logger.getLogger(AlertaCNHConsumer.class.getName());

    private volatile boolean rodando = true;

    @Override
    public void run() {
        log.info("[CONSUMER] Iniciado — aguardando alertas de CNH na fila...");

        while (rodando) {
            try {
                // Bloqueia aqui até chegar uma mensagem (sem gastar CPU)
                AlertaCNHMessage msg = AlertaCNHQueue.getInstance().consumir();

                processarAlerta(msg);

            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                log.info("[CONSUMER] Interrompido — encerrando.");
                break;
            } catch (Exception e) {
                // Não deixa a thread morrer por erro em uma mensagem
                log.log(Level.SEVERE, "[CONSUMER] Erro ao processar mensagem", e);
            }
        }
    }

    /**
     * Lógica de processamento do alerta.
     * Hoje: loga no console.
     * Amanhã: envie e-mail, notificação push, grave em tabela de alertas...
     */
    private void processarAlerta(AlertaCNHMessage msg) {
        String nivel = msg.getDiasRestantes() <= 15 ? "🔴 CRÍTICO" :
                       msg.getDiasRestantes() <= 30 ? "🟡 ATENÇÃO" : "🟢 AVISO";

        log.warning(String.format(
            "[CONSUMER] %s | Motorista: %-30s | CNH: %-15s | Vence: %s | Dias restantes: %d",
            nivel,
            msg.getMotoristaNome(),
            msg.getCnhNumero(),
            msg.getCnhValidade(),
            msg.getDiasRestantes()
        ));

        // ── Aqui você pode adicionar no futuro: ──────────────────────────
        // emailService.enviarAlertaCNH(msg);
        // notificacaoDAO.salvarAlerta(msg);
        // whatsappService.enviarMensagem(msg);
        // ────────────────────────────────────────────────────────────────
    }

    public void parar() {
        rodando = false;
    }
}
