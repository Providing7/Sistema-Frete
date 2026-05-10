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

    private static final int DIAS_ALERTA    = 30; // avisa com 30 dias de antecedência
    private static final int HORA_EXECUCAO  = 8;  // roda às 08h00 todo dia

    private ScheduledExecutorService scheduler;
    private Thread                   consumerThread;
    private AlertaCNHConsumer        consumer;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        log.info("[SCHEDULER] Iniciando sistema de alertas de CNH...");

        // 1. Sobe o Consumer em thread dedicada
        consumer       = new AlertaCNHConsumer();
        consumerThread = new Thread(consumer, "alerta-cnh-consumer");
        consumerThread.setDaemon(true); // não impede o Tomcat de desligar
        consumerThread.start();

        // 2. Calcula delay até a próxima execução às 08h
        long delaySegundos = calcularDelayAte(HORA_EXECUCAO);

        // 3. Agenda execução diária
        scheduler = Executors.newSingleThreadScheduledExecutor(r -> {
            Thread t = new Thread(r, "alerta-cnh-scheduler");
            t.setDaemon(true);
            return t;
        });

        scheduler.scheduleAtFixedRate(
            this::verificarCNHsEPublicar,
            delaySegundos,   // espera até às 08h da primeira vez
            TimeUnit.DAYS.toSeconds(1), // repete a cada 24h
            TimeUnit.SECONDS
        );

        log.info(String.format(
            "[SCHEDULER] Agendado — primeira execução em %d minutos (às %dh00). " +
            "Consumer rodando em thread '%s'.",
            delaySegundos / 60, HORA_EXECUCAO, consumerThread.getName()
        ));
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

    /**
     * Calcula quantos segundos faltam para a próxima ocorrência do horário alvo.
     */
    private long calcularDelayAte(int horaAlvo) {
        LocalDate hoje = LocalDate.now();
        java.time.LocalDateTime agora  = java.time.LocalDateTime.now();
        java.time.LocalDateTime alvo   = hoje.atTime(horaAlvo, 0);

        if (agora.isAfter(alvo)) {
            alvo = alvo.plusDays(1); // se já passou das 08h, agenda para amanhã
        }

        return ChronoUnit.SECONDS.between(agora, alvo);
    }
}
