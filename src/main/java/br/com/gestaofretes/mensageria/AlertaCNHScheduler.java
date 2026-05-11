package br.com.gestaofretes.mensageria;

import br.com.gestaofretes.motorista.Motorista;
import br.com.gestaofretes.motorista.MotoristaDAO;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * SCHEDULER / PRODUTOR — inicia automaticamente com o Tomcat.
 * @WebListener faz o Tomcat chamar contextInitialized() ao subir
 * e contextDestroyed() ao desligar — ciclo de vida gerenciado.
 */
@WebListener
public class AlertaCNHScheduler implements ServletContextListener {

    private static final Logger log = Logger.getLogger(AlertaCNHScheduler.class.getName());

    private static final int DIAS_ALERTA = 30;

    private ScheduledExecutorService scheduler;
    private Thread                   consumerThread;
    private AlertaCNHConsumer        consumer;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        log.info("[SCHEDULER] Iniciando sistema de alertas de CNH...");

        consumer       = new AlertaCNHConsumer();
        consumerThread = new Thread(consumer, "alerta-cnh-consumer");
        consumerThread.setDaemon(true); // não impede o Tomcat de desligar
        consumerThread.start();

        scheduler = Executors.newSingleThreadScheduledExecutor(r -> {
            Thread t = new Thread(r, "alerta-cnh-scheduler");
            t.setDaemon(true);
            return t;
        });

        scheduler.scheduleAtFixedRate(
            this::verificarCNHsEPublicar,
            0,   // executa imediatamente
            TimeUnit.DAYS.toSeconds(1), // repete a cada 24h
            TimeUnit.SECONDS
        );

        log.info("[SCHEDULER] Agendado — executando imediatamente e repetindo a cada 24h. " +
                 "Consumer rodando em thread '" + consumerThread.getName() + "'.");
    }

    /**
     * PRODUTOR — consulta o BD e publica uma mensagem por motorista crítico.
     * Não processa nada, só publica.
     */
    private void verificarCNHsEPublicar() {
        log.info("[SCHEDULER] Verificando CNHs próximas do vencimento...");
        try {
            MotoristaDAO dao = new MotoristaDAO();
            List<Motorista> criticos = dao.listarComCNHCritica(DIAS_ALERTA);

            if (criticos.isEmpty()) {
                log.info("[SCHEDULER] Nenhuma CNH crítica encontrada hoje.");
                return;
            }

            log.info("[SCHEDULER] " + criticos.size() + " CNH(s) crítica(s) — publicando na fila...");

            for (Motorista m : criticos) {
                int diasRestantes = (int) ChronoUnit.DAYS.between(
                    LocalDate.now(), m.getCnhValidade()
                );

                AlertaCNHMessage msg = new AlertaCNHMessage(
                    m.getId(),
                    m.getNome(),
                    m.getCnhNumero(),
                    m.getCnhValidade(),
                    diasRestantes
                );

                // PUBLICA na fila — o Consumer vai processar assincronamente
                AlertaCNHQueue.getInstance().publicar(msg);
            }

        } catch (Exception e) {
            log.log(Level.SEVERE, "[SCHEDULER] Erro ao verificar CNHs", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        log.info("[SCHEDULER] Encerrando sistema de alertas...");

        if (scheduler != null) {
            scheduler.shutdownNow();
        }
        if (consumer != null) {
            consumer.parar();
        }
        if (consumerThread != null) {
            consumerThread.interrupt();
        }

        log.info("[SCHEDULER] Sistema de alertas encerrado.");
    }
}