USE biblioteca_universitaria;

-- ============================================================================
-- PROJETO: Biblioteca Universitária (MySQL)
-- RESPONSÁVEL: Pessoa 4 (Consultas SQL e Índices)
-- ============================================================================

-- 1. Empréstimos ativos (RF08 e RN08: Data_devolucao IS NULL)
SELECT 
    e.id_Emprestimo,
    l.Nome AS Leitor,
    l.Identificador_institucional,
    l.Tipo_leitor,
    lv.Titulo AS Livro,
    ex.id_Exemplar,
    e.Data_emprestimo,
    e.Data_prevista_devolucao
FROM emprestimo e
INNER JOIN leitor l   ON e.id_Leitor   = l.id_Leitor
INNER JOIN exemplar ex ON e.id_Exemplar = ex.id_Exemplar
INNER JOIN livro lv    ON ex.id_Livro    = lv.id_Livro
WHERE e.Data_devolucao IS NULL
ORDER BY e.Data_prevista_devolucao ASC;

-- 2. Empréstimos em atraso (ativos cuja Data_prevista_devolucao já passou)
SELECT 
    e.id_Emprestimo,
    l.Nome AS Leitor,
    l.Email,
    l.Tipo_leitor,
    lv.Titulo AS Livro,
    ex.id_Exemplar,
    e.Data_emprestimo,
    e.Data_prevista_devolucao,
    DATEDIFF(CURDATE(), e.Data_prevista_devolucao) AS Dias_atraso
FROM emprestimo e
INNER JOIN leitor l   ON e.id_Leitor   = l.id_Leitor
INNER JOIN exemplar ex ON e.id_Exemplar = ex.id_Exemplar
INNER JOIN livro lv    ON ex.id_Livro    = lv.id_Livro
WHERE e.Data_devolucao IS NULL
  AND e.Data_prevista_devolucao < CURDATE()
ORDER BY Dias_atraso DESC;

-- 3. Empréstimos devolvidos (RF09)
SELECT 
    e.id_Emprestimo,
    l.Nome AS Leitor,
    lv.Titulo AS Livro,
    ex.id_Exemplar,
    e.Data_emprestimo,
    e.Data_prevista_devolucao,
    e.Data_devolucao
FROM emprestimo e
INNER JOIN leitor l   ON e.id_Leitor   = l.id_Leitor
INNER JOIN exemplar ex ON e.id_Exemplar = ex.id_Exemplar
INNER JOIN livro lv    ON ex.id_Livro    = lv.id_Livro
WHERE e.Data_devolucao IS NOT NULL
ORDER BY e.Data_devolucao DESC;

-- 4. Histórico completo de empréstimos de um leitor específico (RF10)
SELECT 
    l.id_Leitor,
    l.Nome AS Leitor,
    l.Tipo_leitor,
    lv.Titulo AS Livro,
    ex.id_Exemplar,
    e.Data_emprestimo,
    e.Data_prevista_devolucao,
    e.Data_devolucao,
    CASE 
        WHEN e.Data_devolucao IS NULL AND e.Data_prevista_devolucao < CURDATE() THEN 'Atrasado'
        WHEN e.Data_devolucao IS NULL THEN 'Ativo'
        ELSE 'Devolvido'
    END AS Situacao
FROM emprestimo e
INNER JOIN leitor l   ON e.id_Leitor   = l.id_Leitor
INNER JOIN exemplar ex ON e.id_Exemplar = ex.id_Exemplar
INNER JOIN livro lv    ON ex.id_Livro    = lv.id_Livro
WHERE l.id_Leitor = 1 -- ajustar conforme ID de teste
ORDER BY e.Data_emprestimo DESC;

-- 5. Histórico de empréstimos de um livro específico (RF11)
SELECT 
    lv.id_Livro,
    lv.Titulo,
    ex.id_Exemplar,
    l.Nome AS Leitor,
    l.Tipo_leitor,
    e.Data_emprestimo,
    e.Data_prevista_devolucao,
    e.Data_devolucao
FROM livro lv
INNER JOIN exemplar ex ON lv.id_Livro    = ex.id_Livro
INNER JOIN emprestimo e ON ex.id_Exemplar = e.id_Exemplar
INNER JOIN leitor l    ON e.id_Leitor    = l.id_Leitor
WHERE lv.id_Livro = 1 -- ajustar conforme ID de teste
ORDER BY e.Data_emprestimo DESC;

-- 6. Exemplares disponíveis para empréstimo (RF12, RN06, RN07, RN08)
SELECT 
    lv.id_Livro,
    lv.Titulo,
    lv.Editora,
    lv.Ano_publicacao,
    lv.ISBN,
    ex.id_Exemplar
FROM exemplar ex
INNER JOIN livro lv ON ex.id_Livro = lv.id_Livro
WHERE NOT EXISTS (
    SELECT 1
    FROM emprestimo e
    WHERE e.id_Exemplar = ex.id_Exemplar
      AND e.Data_devolucao IS NULL
)
ORDER BY lv.Titulo ASC, ex.id_Exemplar ASC;

-- 7. Livros mais emprestados (ranking de demanda)
SELECT 
    lv.id_Livro,
    lv.Titulo,
    lv.ISBN,
    COUNT(e.id_Emprestimo) AS Total_emprestimos
FROM livro lv
INNER JOIN exemplar ex ON lv.id_Livro    = ex.id_Livro
INNER JOIN emprestimo e ON ex.id_Exemplar = e.id_Exemplar
GROUP BY lv.id_Livro, lv.Titulo, lv.ISBN
ORDER BY Total_emprestimos DESC, lv.Titulo ASC;

-- 8. Catálogo com autores (N:M), total de exemplares e exemplares disponíveis
SELECT 
    lv.id_Livro,
    lv.Titulo,
    GROUP_CONCAT(DISTINCT a.Nome ORDER BY a.Nome SEPARATOR ', ') AS Autores,
    COUNT(DISTINCT ex.id_Exemplar) AS Total_exemplares,
    COUNT(DISTINCT ex.id_Exemplar) - COUNT(DISTINCT CASE
        WHEN e.Data_devolucao IS NULL THEN e.id_Exemplar
    END) AS Exemplares_disponiveis
FROM livro lv
LEFT JOIN livro_autor la ON lv.id_Livro    = la.id_Livro
LEFT JOIN autor a        ON la.id_Autor    = a.id_Autor
LEFT JOIN exemplar ex    ON lv.id_Livro    = ex.id_Livro
LEFT JOIN emprestimo e   ON ex.id_Exemplar = e.id_Exemplar
GROUP BY lv.id_Livro, lv.Titulo
ORDER BY lv.Titulo ASC;