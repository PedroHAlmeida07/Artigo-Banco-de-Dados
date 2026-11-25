USE biblioteca_universitaria;

-- ============================================================================
-- ÍNDICES SECUNDÁRIOS PARA OTIMIZAÇÃO DE CONSULTAS
-- (Obs.: índices de PK, FK e UNIQUE já são criados automaticamente pelo InnoDB)
-- ============================================================================

-- 1. Acelera consultas de empréstimos ativos e atrasados (RF08, RN08)
CREATE INDEX idx_emprestimo_devolucao_prevista
ON emprestimo (Data_devolucao, Data_prevista_devolucao);

-- 2. Acelera ordenação/consulta por data de empréstimo (históricos RF10 e RF11)
CREATE INDEX idx_emprestimo_data_emprestimo
ON emprestimo (Data_emprestimo);

-- 3. Acelera buscas e ordenações por título do livro no catálogo
CREATE INDEX idx_livro_titulo
ON livro (Titulo);

-- 4. Acelera filtragem de leitores por perfil (DISCENTE / SERVIDOR)
CREATE INDEX idx_leitor_tipo
ON leitor (Tipo_leitor);