CREATE SCHEMA IF NOT EXISTS nacao_real;

CREATE TABLE IF NOT EXISTS nacao_real.membro (
  mCPF            BIGINT      NOT NULL,
  mID             SERIAL      NOT NULL  UNIQUE,
  mNome           VARCHAR(30) NOT NULL,
  mSnome          VARCHAR(30) NOT NULL,
  mEndereco       VARCHAR(90) NOT NULL,
  mCodPostal      VARCHAR(45) NOT NULL,
  mCidade         VARCHAR(45) NOT NULL,
  mEstado         VARCHAR(2)  NOT NULL,
  mPais           VARCHAR(45) NOT NULL,
  mESpecialidade  VARCHAR(45) NOT NULL,
  mNasc           TIMESTAMP   NOT NULL,
  mPassword       VARCHAR(90) NOT NULL,
  PRIMARY KEY (mID)
);

CREATE TABLE IF NOT EXISTS nacao_real.habilidades (
  membro      INT         NOT NULL,
  habilidade  VARCHAR(45) NOT NULL,
  PRIMARY KEY (membro, habilidade),
  CONSTRAINT membro
    FOREIGN KEY (membro)
    REFERENCES nacao_real.membro (mID)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS nacao_real.telefones (
  CodInternacional  INT         NOT NULL DEFAULT 55,
  Ntelefone         VARCHAR(25) NOT NULL,
  TitularID         INT         NOT NULL,
  Pessoal           BOOLEAN     NOT NULL,
  WhatsApp          BOOLEAN     NOT NULL DEFAULT TRUE,
  PRIMARY KEY (TitularID, CodInternacional, Ntelefone),
  CONSTRAINT TituarID
    FOREIGN KEY (TitularID)
    REFERENCES nacao_real.membro (mID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS nacao_real.email (
  Email       VARCHAR(40) NOT NULL,
  TitularID   INT         NOT NULL,
  PRIMARY KEY (Email, TitularID),
  CONSTRAINT TitularCPF
    FOREIGN KEY (TitularID)
    REFERENCES nacao_real.membro (mID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS nacao_real.celula (
  idcelula    SERIAL  NOT NULL,
  alcance     INT     NOT NULL,
  nucleo      INT     NOT NULL,
  celula_pai  INT,
  PRIMARY KEY (idcelula),
  CONSTRAINT celula_pai
    FOREIGN KEY (celula_pai)
    REFERENCES nacao_real.celula (idcelula)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
-- celula_tipo -- pode ser internacional, nacional, estadual, municipal ou de bairro (combinar código)
-- nucleo -- pode ser estratégico, organização, suporte, etc ... (combinar código)

CREATE TABLE IF NOT EXISTS nacao_real.inscricao (
  participante  INT NOT NULL,
  celula        INT NOT NULL,
  PRIMARY KEY (participante, celula),
  CONSTRAINT participante
    FOREIGN KEY (participante)
    REFERENCES nacao_real.membro (mID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT celula
    FOREIGN KEY (celula)
    REFERENCES nacao_real.celula (idcelula)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS nacao_real.operacoes (
  idoperacoes SERIAL      NOT NULL,
  operacao    VARCHAR(80) NOT NULL,
  PRIMARY KEY (idoperacoes)
);

CREATE TABLE IF NOT EXISTS nacao_real.credenciais (
  membro    INT NOT NULL,
  celula    INT NOT NULL,
  operacao  INT NOT NULL,
  PRIMARY KEY (membro, celula, operacao),
  CONSTRAINT membro
    FOREIGN KEY (membro)
    REFERENCES nacao_real.membro (mID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT celula
    FOREIGN KEY (celula)
    REFERENCES nacao_real.celula (idcelula)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT operacao
    FOREIGN KEY (operacao)
    REFERENCES nacao_real.operacoes (idoperacoes)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS nacao_real.atividades (
  atividadeID     SERIAL  NOT NULL,
  atv_titulo      VARCHAR(90) NOT NULL,
  atv_local       VARCHAR(90) NULL,
  momento         TIMESTAMP NULL,
  descricao       TEXT NULL,
  PRIMARY KEY (atividadeID)
);

CREATE TABLE IF NOT EXISTS nacao_real.responsaveis (
  responsavel   INT NOT NULL,
  atividades    INT NOT NULL,
  PRIMARY KEY (responsavel, atividades),
  CONSTRAINT responsavel
    FOREIGN KEY (responsavel)
    REFERENCES nacao_real.membro (mID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT atividades
    FOREIGN KEY (atividades)
    REFERENCES nacao_real.atividades (atividadeID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS nacao_real.super_credenciais (
  membro INT NOT NULL,
  operacao INT NOT NULL,
  PRIMARY KEY (membro, operacao),
  CONSTRAINT membro
    FOREIGN KEY (membro)
    REFERENCES nacao_real.membro (mID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT operacao
    FOREIGN KEY (operacao)
    REFERENCES nacao_real.operacoes (idoperacoes)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS nacao_real.message (
  id_message  SERIAL NOT NULL,
  autor       INT NOT NULL,
  celula      INT NULL,
  mensagem    TEXT NOT NULL,
  PRIMARY KEY (id_message),
  CONSTRAINT autor
    FOREIGN KEY (autor)
    REFERENCES nacao_real.membro (mID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT celula
    FOREIGN KEY (celula)
    REFERENCES nacao_real.celula (idcelula)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

