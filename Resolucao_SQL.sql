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

-- Desafio 5: Maior ou menor;
-- So o valor
SELECT MAX(frete_total) AS maior_frete
FROM emissoes;

-- A linha inteira com ORDER BAY e LIMIT
SELECT numero_documento, id_rota, frete_total
FROM emissoes
ORDER BY frete_total DESC
LIMIT 1;
