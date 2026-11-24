-- DROP DATABASE IF EXISTS biblioteca_universitaria;

CREATE DATABASE IF NOT EXISTS biblioteca_universitaria
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE biblioteca_universitaria;

-- ---------------------------------------------------------------------
-- 1) LEITOR: alunos (DISCENTE) e funcionarios (SERVIDOR)   [RF02, RN01]
-- ---------------------------------------------------------------------
CREATE TABLE leitor (
    id_Leitor                   INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Nome                        VARCHAR(120) NOT NULL,
    Email                       VARCHAR(120) NOT NULL,
    Telefone                    VARCHAR(20)  NULL,
    Identificador_institucional VARCHAR(20)  NOT NULL,
    Tipo_leitor                 VARCHAR(10)  NOT NULL,
    CONSTRAINT pk_leitor               PRIMARY KEY (id_Leitor),
    CONSTRAINT uq_leitor_email         UNIQUE (Email),
    CONSTRAINT uq_leitor_identificador UNIQUE (Identificador_institucional),
    CONSTRAINT ck_leitor_tipo          CHECK (Tipo_leitor IN ('DISCENTE', 'SERVIDOR')),
    CONSTRAINT ck_leitor_nome          CHECK (CHAR_LENGTH(TRIM(Nome)) > 0),
    CONSTRAINT ck_leitor_email         CHECK (Email LIKE '%_@_%')
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 2) LIVRO: obra bibliografica (nao e a copia fisica)       [RF01]
-- ---------------------------------------------------------------------
CREATE TABLE livro (
    id_Livro       INT UNSIGNED      NOT NULL AUTO_INCREMENT,
    Titulo         VARCHAR(200)      NOT NULL,
    Editora        VARCHAR(100)      NULL,
    Ano_publicacao SMALLINT UNSIGNED NULL,
    ISBN           VARCHAR(17)       NOT NULL,
    CONSTRAINT pk_livro      PRIMARY KEY (id_Livro),
    CONSTRAINT uq_livro_isbn UNIQUE (ISBN),
    CONSTRAINT ck_livro_ano  CHECK (Ano_publicacao BETWEEN 1000 AND 2100),
    CONSTRAINT ck_livro_isbn CHECK (CHAR_LENGTH(ISBN) >= 10)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 3) AUTOR                                                   [RF03]
-- ---------------------------------------------------------------------
CREATE TABLE autor (
    id_Autor INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Nome     VARCHAR(120) NOT NULL,
    CONSTRAINT pk_autor      PRIMARY KEY (id_Autor),
    CONSTRAINT ck_autor_nome CHECK (CHAR_LENGTH(TRIM(Nome)) > 0)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 4) LIVRO_AUTOR: tabela associativa N:M (PK composta)       [RF04]
-- ---------------------------------------------------------------------
CREATE TABLE livro_autor (
    id_Livro INT UNSIGNED NOT NULL,
    id_Autor INT UNSIGNED NOT NULL,
    CONSTRAINT pk_livro_autor       PRIMARY KEY (id_Livro, id_Autor),
    CONSTRAINT fk_livroautor_livro  FOREIGN KEY (id_Livro)
        REFERENCES livro (id_Livro) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_livroautor_autor  FOREIGN KEY (id_Autor)
        REFERENCES autor (id_Autor) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 5) EXEMPLAR: cada copia fisica de um livro                 [RF05, RN03]
-- ---------------------------------------------------------------------
CREATE TABLE exemplar (
    id_Exemplar INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_Livro    INT UNSIGNED NOT NULL,
    CONSTRAINT pk_exemplar       PRIMARY KEY (id_Exemplar),
    CONSTRAINT fk_exemplar_livro FOREIGN KEY (id_Livro)
        REFERENCES livro (id_Livro) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 6) EMPRESTIMO: retiradas e devolucoes        [RF06-RF07, RN01 a RN08]
--
-- RN06 (um exemplar nao pode ter dois emprestimos ao mesmo tempo):
--   a coluna gerada "exemplar_ativo" vale id_Exemplar enquanto
--   Data_devolucao e NULL (emprestimo em aberto) e NULL quando devolvido.
--   Como o UNIQUE ignora valores NULL, o banco aceita varios emprestimos
--   ANTIGOS do mesmo exemplar, mas apenas UM em aberto por vez.
-- =====================================================================
CREATE TABLE emprestimo (
    id_Emprestimo          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_Leitor              INT UNSIGNED NOT NULL,
    id_Exemplar            INT UNSIGNED NOT NULL,
    Data_emprestimo        DATE NOT NULL,
    Data_prevista_devolucao DATE NOT NULL,
    Data_devolucao         DATE NULL,
    exemplar_ativo         INT UNSIGNED
        GENERATED ALWAYS AS (CASE WHEN Data_devolucao IS NULL
                                  THEN id_Exemplar ELSE NULL END) STORED,
    CONSTRAINT pk_emprestimo PRIMARY KEY (id_Emprestimo),
    CONSTRAINT fk_emprestimo_leitor   FOREIGN KEY (id_Leitor)
        REFERENCES leitor (id_Leitor)     ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_emprestimo_exemplar FOREIGN KEY (id_Exemplar)
        REFERENCES exemplar (id_Exemplar) ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT uq_emprestimo_exemplar_ativo UNIQUE (exemplar_ativo),
    CONSTRAINT ck_emprestimo_prazo
        CHECK (Data_prevista_devolucao >= Data_emprestimo),
    CONSTRAINT ck_emprestimo_devolucao
        CHECK (Data_devolucao IS NULL OR Data_devolucao >= Data_emprestimo)
) ENGINE = InnoDB;

-- Fim do script de criacao.
