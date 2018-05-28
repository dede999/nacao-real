CREATE TABLE IF NOT EXISTS membro (
  mCPF            INT         NOT NULL,
  mID             SERIAL      NOT NULL  UNIQUE,
  mEndereco       VARCHAR(90) NOT NULL,
  mCodPostal      VARCHAR(45) NOT NULL,
  mCidade         VARCHAR(45) NOT NULL,
  mEstado         VARCHAR(2)  NOT NULL,
  mPais           VARCHAR(45) NOT NULL,
  mESpecialidade  VARCHAR(45) NOT NULL,
  mNasc           TIMESTAMP NOT NULL,
  PRIMARY KEY (mCPF)
);

CREATE TABLE IF NOT EXISTS telefones (
  CodInternacional  INT         NOT NULL DEFAULT 55,
  Ntelefone         VARCHAR(20) NOT NULL,
  TitularCPF        INT         NOT NULL,
  TipoContato       VARCHAR(45) NOT NULL,
  WhatsApp          BOOLEAN     NOT NULL DEFAULT TRUE,
  PRIMARY KEY (TitularCPF, CodInternacional, Ntelefone),
  CONSTRAINT TituarCPF
    FOREIGN KEY (TitularCPF)
    REFERENCES membro (mCPF)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
CREATE INDEX TituarCPF_idx ON telefones (TitularCPF ASC);

CREATE TABLE IF NOT EXISTS email (
  Email       INT NOT NULL,
  TitularCPF  INT NOT NULL,
  PRIMARY KEY (Email, TitularCPF),
  CONSTRAINT TitulaCPF
    FOREIGN KEY (TitularCPF)
    REFERENCES membro (mCPF)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
CREATE INDEX TitulaCPF_idx ON email (TitularCPF ASC);

CREATE TABLE IF NOT EXISTS celula (
  idcelula    SERIAL  NOT NULL,
  celula_tipo INT     NOT NULL,
  -- pode ser internacional, nacional, estadual, municipal ou de bairro (combinar código)
  nucleo      INT     NOT NULL,
  -- pode ser estratégico, organização, suporte, etc ... (combinar código)
  celula_pai  INT,
  PRIMARY KEY (idcelula),
  CONSTRAINT celula_pai
    FOREIGN KEY (celula_pai)
    REFERENCES celula (idcelula)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS inscricao (
  participante  INT NOT NULL,
  celula        INT NOT NULL,
  PRIMARY KEY (participante, celula),
  CONSTRAINT participante
    FOREIGN KEY (participante)
    REFERENCES membro (mCPF)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT celula
    FOREIGN KEY (celula)
    REFERENCES celula (idcelula)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS operacoes (
  idoperacoes SERIAL      NOT NULL,
  operacao    VARCHAR(80) NOT NULL,
  PRIMARY KEY (idoperacoes)
);

CREATE TABLE IF NOT EXISTS credenciais (
  membro    INT NOT NULL,
  celula    INT NOT NULL,
  operacao  INT NOT NULL,
  PRIMARY KEY (membro, celula, operacao),
  CONSTRAINT membro
    FOREIGN KEY (membro)
    REFERENCES membro (mCPF)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT celula
    FOREIGN KEY (celula)
    REFERENCES celula (idcelula)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT operacao
    FOREIGN KEY (operacao)
    REFERENCES operacoes (idoperacoes)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS atividades (
  atividadeID     SERIAL  NOT NULL,
  atv_titulo      VARCHAR(90) NOT NULL,
  atv_local       VARCHAR(90) NULL,
  momento         TIMESTAMP NULL,
  descricao       TEXT NULL,
  PRIMARY KEY (atividadeID)
);

CREATE TABLE IF NOT EXISTS responsaveis (
  responsavel   INT NOT NULL,
  atividades    INT NOT NULL,
  PRIMARY KEY (responsavel, atividades),
  CONSTRAINT responsavel
    FOREIGN KEY (responsavel)
    REFERENCES membro (mCPF)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT atividades
    FOREIGN KEY (atividades)
    REFERENCES atividades (atividadeID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS super_credenciais (
  membro INT NOT NULL,
  operacao INT NOT NULL,
  PRIMARY KEY (membro, operacao),
  CONSTRAINT membro
    FOREIGN KEY (membro)
    REFERENCES membro (mCPF)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT operacao
    FOREIGN KEY (operacao)
    REFERENCES operacoes (idoperacoes)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS message (
  id_message  SERIAL NOT NULL,
  autor       INT NOT NULL,
  celula      INT NULL,
  mensagem    TEXT NOT NULL,
  PRIMARY KEY (id_message),
  CONSTRAINT autor
    FOREIGN KEY (autor)
    REFERENCES membro (mCPF)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT celula
    FOREIGN KEY (celula)
    REFERENCES celula (idcelula)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

