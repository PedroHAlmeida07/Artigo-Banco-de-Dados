USE biblioteca_universitaria;

-- inserts de dados validos
INSERT INTO leitor (Nome, Email, Telefone, Identificador_institucional, Tipo_leitor) VALUES
('Ana Paula Souza', 'ana.souza@unit.br', '79999990001', '2024001', 'DISCENTE'),
('Carlos Eduardo Lima', 'carlos.lima@unit.br', '79999990002', '2023045', 'DISCENTE'),
('Prof. Marcos Andrade', 'marcos.andrade@unit.br', NULL, 'SRV102', 'SERVIDOR');

INSERT INTO livro (Titulo, Editora, Ano_publicacao, ISBN) VALUES
('Sistemas de Banco de Dados', 'Pearson', 2019, '9788543024576'),
('Engenharia de Software', 'McGraw-Hill', 2016, '9788580555349'),
('Estruturas de Dados com Java', 'Novatec', 2021, '9786586057423');

INSERT INTO autor (Nome) VALUES
('Ramez Elmasri'),
('Shamkant B. Navathe'),
('Ian Sommerville'),
('Michael T. Goodrich');

INSERT INTO livro_autor (id_Livro, id_Autor) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4);

INSERT INTO exemplar (id_Livro) VALUES
(1),
(1),
(2),
(3);

INSERT INTO emprestimo (id_Leitor, id_Exemplar, Data_emprestimo, Data_prevista_devolucao, Data_devolucao) VALUES
(1, 1, '2026-10-01', '2026-10-15', '2026-10-12'),
(2, 2, '2026-11-10', '2026-11-24', NULL);

SELECT * FROM leitor;
SELECT * FROM livro;
SELECT * FROM autor;
SELECT * FROM livro_autor;
SELECT * FROM exemplar;
SELECT * FROM emprestimo;

-- testes de restricoes (devem dar erro)

-- email duplicado
INSERT INTO leitor (Nome, Email, Telefone, Identificador_institucional, Tipo_leitor)
VALUES ('Outro Aluno', 'ana.souza@unit.br', NULL, '2025999', 'DISCENTE');

-- tipo de leitor invalido
INSERT INTO leitor (Nome, Email, Telefone, Identificador_institucional, Tipo_leitor)
VALUES ('Visitante', 'visitante@unit.br', NULL, 'VIS001', 'VISITANTE');

-- exemplar ja emprestado em aberto
INSERT INTO emprestimo (id_Leitor, id_Exemplar, Data_emprestimo, Data_prevista_devolucao, Data_devolucao)
VALUES (3, 2, '2026-11-20', '2026-12-04', NULL);

-- data prevista antes da data do emprestimo
INSERT INTO emprestimo (id_Leitor, id_Exemplar, Data_emprestimo, Data_prevista_devolucao, Data_devolucao)
VALUES (3, 3, '2026-11-20', '2026-11-10', NULL);