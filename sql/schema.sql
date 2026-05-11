CREATE TABLE cliente (
    id               SERIAL PRIMARY KEY,
    razao_social     VARCHAR(150) NOT NULL,
    nome_fantasia    VARCHAR(150),
    cnpj             VARCHAR(18)  NOT NULL UNIQUE,
    inscricao_estadual VARCHAR(30),
    tipo             VARCHAR(20)  NOT NULL, -- REMETENTE, DESTINATARIO, AMBOS
    logradouro       VARCHAR(200),
    numero           VARCHAR(10),
    complemento      VARCHAR(100),
    bairro           VARCHAR(100),
    municipio        VARCHAR(100),
    uf               CHAR(2),
    cep              VARCHAR(10),
    telefone         VARCHAR(20),
    email            VARCHAR(100),
    status           BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE motorista (
    id               SERIAL PRIMARY KEY,
    nome             VARCHAR(150) NOT NULL,
    cpf              VARCHAR(14)  NOT NULL UNIQUE,
    data_nascimento  DATE,
    telefone         VARCHAR(20),
    cnh_numero       VARCHAR(20),
    cnh_categoria    VARCHAR(2),  -- A, B, C, D, E
    cnh_validade     DATE,
    tipo_vinculo     VARCHAR(20), -- FUNCIONARIO, AGREGADO, TERCEIRO
    status           VARCHAR(20)  NOT NULL DEFAULT 'ATIVO'
);

CREATE TABLE veiculo (
    id               SERIAL PRIMARY KEY,
    placa            VARCHAR(10)  NOT NULL UNIQUE,
    rntrc            VARCHAR(20),
    ano_fabricacao   INTEGER,
    tipo             VARCHAR(20), -- TRUCK, CARRETA, VAN, UTILITARIO
    tara_kg          NUMERIC(10,2),
    capacidade_kg    NUMERIC(10,2),
    volume_m3        NUMERIC(10,2),
    status           VARCHAR(20)  NOT NULL DEFAULT 'DISPONIVEL'
);

CREATE TABLE frete (
    id                    SERIAL PRIMARY KEY,
    numero                VARCHAR(20)  NOT NULL UNIQUE, -- FRT-AAAA-NNNNN
    id_remetente          INTEGER      NOT NULL REFERENCES cliente(id),
    id_destinatario       INTEGER      NOT NULL REFERENCES cliente(id),
    id_motorista          INTEGER      NOT NULL REFERENCES motorista(id),
    id_veiculo            INTEGER      NOT NULL REFERENCES veiculo(id),
    municipio_origem      VARCHAR(100),
    uf_origem             CHAR(2),
    municipio_destino     VARCHAR(100),
    uf_destino            CHAR(2),
    descricao_carga       VARCHAR(300),
    peso_kg               NUMERIC(10,2),
    volumes               INTEGER,
    valor_frete           NUMERIC(10,2),
    aliquota_icms         NUMERIC(5,2),
    valor_icms            NUMERIC(10,2),
    valor_total           NUMERIC(10,2),
    status                VARCHAR(25)  NOT NULL DEFAULT 'EMITIDO',
    data_emissao          DATE         NOT NULL,
    data_previsao_entrega DATE,
    data_saida            TIMESTAMP,
    data_entrega          TIMESTAMP
);

CREATE TABLE ocorrencia_frete (
    id                  SERIAL PRIMARY KEY,
    id_frete            INTEGER      NOT NULL REFERENCES frete(id),
    tipo                VARCHAR(30)  NOT NULL,
    data_hora           TIMESTAMP    NOT NULL,
    municipio           VARCHAR(100),
    uf                  CHAR(2),
    descricao           VARCHAR(500),
    nome_recebedor      VARCHAR(150),
    documento_recebedor VARCHAR(20)
);

-- DADOS DE EXEMPLO

INSERT INTO cliente (razao_social, nome_fantasia, cnpj, tipo, municipio, uf, status)
VALUES
  ('Empresa Alpha Ltda',    'Alpha',   '11.222.333/0001-81', 'REMETENTE',    'São Paulo',     'SP', TRUE),
  ('Distribuidora Beta SA', 'Beta',    '22.333.444/0001-60', 'DESTINATARIO', 'Curitiba',      'PR', TRUE),
  ('Comercial Gama ME',     'Gama',    '33.444.555/0001-49', 'AMBOS',        'Belo Horizonte','MG', TRUE);

INSERT INTO motorista (nome, cpf, cnh_numero, cnh_categoria, cnh_validade, tipo_vinculo, status)
VALUES
  ('Carlos Silva',  '529.982.247-25', '12345678901', 'E', '2027-06-30', 'FUNCIONARIO', 'ATIVO'),
  ('José Santos',   '987.654.321-00', '98765432101', 'D', '2026-12-31', 'AGREGADO',    'ATIVO'),
  ('Ana Oliveira',  '111.444.777-35', '11122233301', 'B', '2028-03-15', 'TERCEIRO',    'ATIVO');

INSERT INTO veiculo (placa, rntrc, ano_fabricacao, tipo, tara_kg, capacidade_kg, volume_m3, status)
VALUES
  ('ABC1D23', '12345678', 2020, 'CARRETA',    8000, 25000, 90.0, 'DISPONIVEL'),
  ('XYZ2E34', '87654321', 2019, 'TRUCK',      6000, 14000, 45.0, 'DISPONIVEL'),
  ('DEF3F45', '11223344', 2022, 'VAN',        2000,  3000, 12.0, 'DISPONIVEL');

INSERT INTO frete (numero, id_remetente, id_destinatario, id_motorista, id_veiculo,
                   municipio_origem, uf_origem, municipio_destino, uf_destino,
                   descricao_carga, peso_kg, volumes,
                   valor_frete, aliquota_icms, valor_icms, valor_total,
                   status, data_emissao, data_previsao_entrega)
VALUES
  ('FRT-2026-00001', 1, 2, 1, 1, 'São Paulo','SP','Curitiba','PR',
   'Eletrodomésticos', 5000, 10, 2000.00, 12.00, 240.00, 2240.00,
   'EMITIDO', '2026-04-20', '2026-04-23'),

  ('FRT-2026-00002', 1, 3, 2, 2, 'São Paulo','SP','Belo Horizonte','MG',
   'Móveis', 8000, 20, 3500.00, 12.00, 420.00, 3920.00,
   'EM_TRANSITO', '2026-04-18', '2026-04-22'),

  ('FRT-2026-00003', 3, 2, 3, 3, 'Belo Horizonte','MG','Curitiba','PR',
   'Peças automotivas', 1200, 5, 800.00, 12.00, 96.00, 896.00,
   'ENTREGUE', '2026-04-15', '2026-04-18'),

  ('FRT-2026-00004', 2, 1, 1, 2, 'Curitiba','PR','São Paulo','SP',
   'Alimentos', 10000, 50, 4000.00, 7.00, 280.00, 4280.00,
   'SAIDA_CONFIRMADA', '2026-04-21', '2026-04-24'),

  ('FRT-2026-00005', 3, 1, 2, 1, 'Belo Horizonte','MG','São Paulo','SP',
   'Equipamentos', 3000, 8, 1500.00, 12.00, 180.00, 1680.00,
   'CANCELADO', '2026-04-10', '2026-04-14');

-- TABELA DE USUÁRIOS (autenticação real com senha criptografada)

CREATE TABLE IF NOT EXISTS usuario (
    id             SERIAL PRIMARY KEY,
    login          VARCHAR(100) NOT NULL UNIQUE,  -- armazena o e-mail
    email          VARCHAR(100) NOT NULL UNIQUE,
    senha_hash     VARCHAR(255) NOT NULL,
    nome_completo  VARCHAR(150),
    ativo          BOOLEAN NOT NULL DEFAULT TRUE
);

-- TABELA DE HISTÓRICO DE NOTIFICAÇÕES DE CNH

CREATE TABLE IF NOT EXISTS notificacao_motorista (
    id              SERIAL PRIMARY KEY,
    id_motorista    INTEGER      NOT NULL REFERENCES motorista(id),
    motorista_nome  VARCHAR(150) NOT NULL,
    cnh_numero      VARCHAR(20),
    cnh_validade    DATE         NOT NULL,
    dias_restantes  INTEGER      NOT NULL,
    nivel           VARCHAR(10)  NOT NULL, -- CRITICO, ATENCAO, AVISO
    processado_em   TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_notif_motorista ON notificacao_motorista(id_motorista);
CREATE INDEX IF NOT EXISTS idx_notif_processado ON notificacao_motorista(processado_em DESC);

