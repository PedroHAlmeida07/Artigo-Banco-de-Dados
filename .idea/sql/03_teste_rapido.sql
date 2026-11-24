USE biblioteca_universitaria;
START TRANSACTION;

INSERT INTO leitor (Nome, Email, Telefone, Identificador_institucional, Tipo_leitor)
VALUES ('Leitor Teste', 'teste@souunit.com.br', '79999990000', 'T000001', 'DISCENTE');
SET @leitor := LAST_INSERT_ID();

INSERT INTO livro (Titulo, Editora, Ano_publicacao, ISBN)
VALUES ('Livro Teste', 'Editora Teste', 2020, '9780000000001');
SET @livro := LAST_INSERT_ID();

INSERT INTO exemplar (id_Livro) VALUES (@livro);
SET @exemplar := LAST_INSERT_ID();

-- OK: primeiro emprestimo do exemplar
INSERT INTO emprestimo (id_Leitor, id_Exemplar, Data_emprestimo, Data_prevista_devolucao)
VALUES (@leitor, @exemplar, '2026-11-24', '2026-12-08');

-- DEVE FALHAR (erro 1062): exemplar ja emprestado e nao devolvido (RN06)
INSERT INTO emprestimo (id_Leitor, id_Exemplar, Data_emprestimo, Data_prevista_devolucao)
VALUES (@leitor, @exemplar, '2026-11-25', '2026-12-09');

-- DEVE FALHAR (erro 1452): leitor inexistente (RN01)
INSERT INTO emprestimo (id_Leitor, id_Exemplar, Data_emprestimo, Data_prevista_devolucao)
VALUES (999999, @exemplar, '2026-11-25', '2026-12-09');

-- DEVE FALHAR (erro 3819): prazo anterior a retirada (CHECK)
INSERT INTO leitor (Nome, Email, Identificador_institucional, Tipo_leitor)
VALUES ('Outro Leitor', 'outro@souunit.com.br', 'T000002', 'SERVIDOR');
SET @leitor2 := LAST_INSERT_ID();
INSERT INTO exemplar (id_Livro) VALUES (@livro);
SET @exemplar2 := LAST_INSERT_ID();
INSERT INTO emprestimo (id_Leitor, id_Exemplar, Data_emprestimo, Data_prevista_devolucao)
VALUES (@leitor2, @exemplar2, '2026-12-10', '2026-12-01');

-- Devolve o exemplar e empresta de novo (RN07): agora DEVE FUNCIONAR
UPDATE emprestimo SET Data_devolucao = '2026-12-01' WHERE id_Exemplar = @exemplar;
INSERT INTO emprestimo (id_Leitor, id_Exemplar, Data_emprestimo, Data_prevista_devolucao)
VALUES (@leitor, @exemplar, '2026-12-02', '2026-12-16');

ROLLBACK;  -- desfaz tudo
