# 🚛 Sistema de Gestão de Fretes

Sistema web para gerenciamento completo de operações de transporte de carga, desenvolvido em Java com arquitetura MVC clássica e deploy em Apache Tomcat.

---

## 📋 Funcionalidades

| Módulo | Descrição |
|---|---|
| **Clientes** | Cadastro de remetentes, destinatários ou ambos, com CNPJ e dados de endereço |
| **Motoristas** | Cadastro com CNH (número, categoria, validade) e tipo de vínculo |
| **Veículos** | Cadastro de frota com tipo, tara, capacidade e volume |
| **Fretes** | Emissão, controle de status, confirmação de saída, registro de entrega e não-entrega |
| **Ocorrências** | Registro de eventos durante o transporte (com localização e recebedor) |
| **Relatórios** | Geração de romaneio e relatório de faturamento em PDF via JasperReports |
| **Dashboard** | Painel com gráficos de fretes por status, faturamento mensal e top rotas |
| **Alertas de CNH** | Sistema automático de notificações para CNHs próximas do vencimento |
| **Usuários** | Autenticação com senha criptografada (BCrypt) e controle de sessão |

---

## 🗂️ Estrutura do Projeto

```
Sis-gestao-fretes/
├── src/
│   └── main/
│       ├── java/br/com/gestaofretes/
│       │   ├── auth/           # Filtro de autenticação e controle de sessão
│       │   ├── cliente/        # CRUD de clientes
│       │   ├── dashboard/      # DAO e Servlet do painel de indicadores
│       │   ├── exception/      # Exceções customizadas
│       │   ├── frete/          # CRUD + regras de negócio de fretes
│       │   ├── mensageria/     # Fila/scheduler de alertas de CNH
│       │   ├── motorista/      # CRUD de motoristas
│       │   ├── ocorrencia/     # Registro de ocorrências por frete
│       │   ├── relatorio/      # Geração de PDF com JasperReports
│       │   ├── usuario/        # Cadastro e autenticação de usuários
│       │   ├── util/           # ConexaoDB e utilitários
│       │   └── veiculo/        # CRUD de veículos
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── views/      # JSPs por módulo
│           │   ├── relatorios/ # Arquivos .jrxml (JasperReports)
│           │   └── lib/        # JARs de dependências
│           └── index.jsp
├── sql/
│   └── schema.sql              # DDL + dados de exemplo
├── build.bat                   # Script de compilação manual
└── db.properties.example       # Exemplo de configuração do banco
```

---

## 🛠️ Tecnologias Utilizadas

- **Java 8** — linguagem principal
- **Jakarta Servlet / JSP** — MVC sem framework adicional
- **Apache Tomcat 9.x** — servidor de aplicação
- **PostgreSQL** — banco de dados relacional
- **JDBC** — acesso a dados (sem ORM)
- **JasperReports 6.21.5** — geração de relatórios PDF
- **OpenPDF 1.3.32** — renderização de PDF
- **SLF4J 1.7** — logging
- **BCrypt** — hash de senhas

---

## ⚙️ Pré-requisitos

- JDK 8 ou superior
- Apache Tomcat 9.x
- PostgreSQL 13+
- Eclipse IDE (opcional, mas recomendado)

---

## 🚀 Configuração e Execução

### 1. Banco de dados

Execute o script SQL para criar as tabelas e inserir dados de exemplo:

```sql
psql -U seu_usuario -d seu_banco -f sql/schema.sql
```

### 2. Configurar conexão

Copie o arquivo de exemplo e preencha com seus dados:

```
cp db.properties.example src/main/java/db.properties
```

Conteúdo do `db.properties`:

```properties
db.url=jdbc:postgresql://localhost:5432/seu_banco
db.user=seu_usuario
db.password=sua_senha
```

### 3. Build

#### Via Eclipse
1. Importe o projeto como *Dynamic Web Project*
2. Adicione o Tomcat 9 como servidor em **Window → Preferences → Server**
3. **Project → Clean...** para compilar
4. Clique direito no projeto → **Run As → Run on Server**

#### Manualmente (sem IDE)
```cmd
build.bat
```
Em seguida, copie o conteúdo da pasta `build/` para o webapps do Tomcat ou configure o deploy via Eclipse.

### 4. Acessar o sistema

```
http://localhost:8080/Sis-gestao-fretes/
```

Crie um usuário diretamente no banco (a senha deve ser gerada com BCrypt, custo 12):

```sql
INSERT INTO usuario (login, email, senha_hash, nome_completo, ativo)
VALUES ('admin@email.com', 'admin@email.com', '$2a$12$...hash...', 'Administrador', true);
```

---

## 📊 Modelo de Dados (resumo)

```
cliente ──────────────────────────────────────────────┐
motorista ────────────────────┐                        │
veiculo ──────────────────────┤                        │
                              ▼                        ▼
                           frete (remetente / destinatário)
                              │
                              └──► ocorrencia_frete
                              └──► notificacao_motorista (alertas CNH)

usuario  (autenticação independente)
```

### Status de Frete
`EMITIDO` → `SAIDA_CONFIRMADA` → `EM_TRANSITO` → `ENTREGUE` / `NAO_ENTREGUE` / `CANCELADO`

---

## 📨 Alertas de CNH

O módulo `mensageria` possui um scheduler que verifica automaticamente os motoristas com CNH próxima do vencimento e registra notificações na tabela `notificacao_motorista` com os níveis:

| Nível | Prazo |
|---|---|
| `AVISO` | ≤ 90 dias |
| `ATENÇÃO` | ≤ 30 dias |
| `CRÍTICO` | ≤ 10 dias |

As notificações são exibidas na tela **Alertas de CNH** dentro do sistema.

---

## 📄 Relatórios Disponíveis

- **Romaneio de Carga** — listagem de fretes disponíveis para despacho
- **Faturamento** — relatório de receita por período, gerado em PDF

---

## 🤝 Contribuindo

1. Faça um *fork* do repositório
2. Crie uma branch para sua feature: `git checkout -b feature/minha-feature`
3. Commit suas alterações: `git commit -m 'feat: adiciona minha feature'`
4. Push para a branch: `git push origin feature/minha-feature`
5. Abra um *Pull Request*

---

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
