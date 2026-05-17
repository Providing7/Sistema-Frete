package br.com.gestaofretes.util;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppLifecycleListener implements ServletContextListener{
	
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		System.out.println("[GestaoFretes] Pool HikariCP iniciado.");
	}
	
	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		ConexaoDB.shutdown();
		System.out.println("[GestaoFretes] Pool HikariCP encerrado com sucesso.");
	}
}
