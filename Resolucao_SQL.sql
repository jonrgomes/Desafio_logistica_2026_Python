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


