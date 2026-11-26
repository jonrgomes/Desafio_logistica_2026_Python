-- Desafio 1: Contar a quatidade de registro / conhecendo a base:
SELECT COUNT(*) AS registros FROM emissoes;

SELECT 'emissoes' AS tabela, COUNT(*) AS registros FROM emissoes
UNION ALL
SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL
SELECT 'emissao_ocorrencias', COUNT(*) FROM emissao_ocorrencias
UNION ALL
SELECT 'emissao_rastreio', COUNT(*) FROM emissao_rastreio
UNION ALL
SELECT 'filiais', COUNT(*) FROM filiais
UNION ALL
SELECT 'rotas', COUNT(*) FROM rotas
UNION ALL
SELECT 'veiculos', COUNT(*) FROM veiculos;

-- Desafio 2: Primeiros totais / Somando registros:

SELECT
  ROUND(SUM(peso_kg), 2)     AS total_peso_kg,
  SUM(volumes)      AS total_volumes,
  ROUND(SUM(frete_total), 2) AS faturamento_total
FROM emissoes;

-- Desafio 3: Contando por tipo de seviço:

-- contado de forma específica:
SELECT COUNT(*) AS convencional
FROM emissoes
WHERE tipo_servico = 'Convencional';

-- Contado todos de uma vez:
SELECT
  tipo_servico,
  COUNT(*) AS emissoes
FROM emissoes
GROUP BY tipo_servico
ORDER BY emissoes DESC;

-- Desafio 4:  Percentual por modalidade: 
-- calculo sem percentual
SELECT 
  COUNT(*) AS total,
  SUM(CASE WHEN modalidade_frete = 'CIF' THEN 1 ELSE 0 END) AS cif,
  SUM(CASE WHEN modalidade_frete = 'FOB' THEN 1 ELSE 0 END) AS fob
FROM emissoes;

-- calculo com percentual
SELECT
    modalidade_frete,
    COUNT(*) AS emissoes,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM emissoes), 1) AS percentual
FROM emissoes
GROUP BY modalidade_frete;

-- Desafio 5: Maior ou menor:
-- Somente o valor
SELECT MAX(frete_total) As maior_frete
FROM emissoes; 

-- Maior frete:
SELECT numero_documento, id_rota, valor_mercadoria
FROM emissoes 
ORDER BY frete_total DESC
LIMIT 1;

-- Menor frete:
SELECT numero_documento, id_rota, valor_mercadoria
FROM emissoes 
ORDER BY frete_total ASC
LIMIT 1;

-- Maior valor de mercadoria
SELECT numero_documento, id_rota, valor_mercadoria
FROM emissoes
ORDER BY valor_mercadoria DESC
LIMIT 1;

-- Os dois resultados juntos:
SELECT 'Maior frete' AS indicador, numero_documento, id_rota, frete_total AS valor 
FROM (SELECT * FROM emissoes ORDER BY frete_total DESC LIMIT 1)
UNION ALL
SELECT 'Valor mercadoria', numero_documento, id_rota, valor_mercadoria
FROM (SELECT * FROM emissoes ORDER BY valor_mercadoria DESC LIMIT 1);

-- Desafio 6 - Filtrando por status
-- Filtrando as entregues:
SELECT COUNT(*) AS entregues
FROM emissoes
WHERE status = 'Entregue';

-- Descobrir a Sujeira
SELECT
  '[' || status || ']' AS status_visivel,
  COUNT(*)            AS emissoes
FROM emissoes
GROUP BY status
ORDER BY emissoes DESC; 