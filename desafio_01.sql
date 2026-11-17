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





