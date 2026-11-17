SELECT
  ROUND(SUM(peso_kg), 2)     AS total_peso_kg,
  SUM(volumes)      AS total_volumes,
  ROUND(SUM(frete_total), 2) AS faturamento_total
FROM emissoes;