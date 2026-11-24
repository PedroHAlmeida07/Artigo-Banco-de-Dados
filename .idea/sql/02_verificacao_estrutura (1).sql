USE biblioteca_universitaria;

-- E1: as 6 tabelas existem
SHOW TABLES;

-- E2: estrutura (tipos, NOT NULL, chaves) de cada tabela
DESCRIBE leitor;
DESCRIBE livro;
DESCRIBE autor;
DESCRIBE livro_autor;
DESCRIBE exemplar;
DESCRIBE emprestimo;

-- E3: codigo completo da tabela mais importante (mostra FK, UNIQUE e CHECK)
SHOW CREATE TABLE emprestimo;

-- E4: todas as chaves e restricoes do banco
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'biblioteca_universitaria'
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;

-- E5: chaves estrangeiras (quem referencia quem)
SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME,
       REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'biblioteca_universitaria'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME;

-- E6: regras CHECK
SELECT CONSTRAINT_NAME, CHECK_CLAUSE
FROM information_schema.CHECK_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'biblioteca_universitaria';

-- E7: indices criados automaticamente (PK, UNIQUE, FK)
SHOW INDEX FROM emprestimo;
