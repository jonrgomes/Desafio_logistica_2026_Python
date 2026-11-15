# 🚚 Desafio Logística 2026 — Excel + SQL (Beekeeper Studio)

20 desafios práticos, do básico ao avançado, usando uma base **fictícia** de emissões de CT-e (Conhecimento de Transporte Eletrônico) de uma transportadora, referente a **outubro de 2026**.

Cada desafio tem duas partes:

- **Parte A — Excel:** resolver na planilha `logistica_2026.xlsx` (fórmulas e tabelas dinâmicas).
- **Parte B — SQL:** resolver o mesmo problema no **Beekeeper Studio**, consultando `logistica_2026.db`.

No fim de cada desafio, compare os resultados das partes A e B. **Eles precisam ser iguais.**

---

## 📁 Arquivos do projeto

```
Desafio_logistica_2026/
├── README_Excel_SQL.md
├── logistica_2026.xlsx     # base para a Parte A
├── logistica_2026.db       # base para a Parte B (Beekeeper)
├── logistica_2026.json     # mesma base em JSON (opcional)
└── respostas/
    ├── desafio_01.xlsx
    ├── desafio_01.sql
    └── ...
```

> Para cada desafio, salve uma cópia da planilha (`desafio_XX.xlsx`) e um arquivo de consulta (`desafio_XX.sql`).

---

## 🗂️ A base de dados

### Planilha (`logistica_2026.xlsx`)

Possui 7 abas:

| Aba           | Linhas | O que é                                      |
|---------------|--------|----------------------------------------------|
| `emissoes`    | 2.000  | Os CT-e emitidos (tabela principal)          |
| `rotas`       | 101    | Origem, destino, distância, prazo e tarifa   |
| `clientes`    | 60     | Embarcadores (quem contrata o frete)         |
| `filiais`     | 20     | 1 matriz, 4 hubs e 15 filiais                |
| `veiculos`    | 40     | Frota: Carreta, Truck, Toco, VUC e Van       |
| `ocorrencias` | 367    | Problemas registrados nas entregas           |
| `rastreio`    | 11.790 | Eventos de cada emissão (linha do tempo)     |

### Banco (`logistica_2026.db`)

| Tabela                | Chave                | Liga com                                    |
|-----------------------|----------------------|---------------------------------------------|
| `filiais`             | `codigo`             | —                                           |
| `clientes`            | `id_cliente`         | `filiais.codigo` (via `filial_base`)        |
| `veiculos`            | `id_veiculo`         | `filiais.codigo` (via `filial_base`)        |
| `rotas`               | `id_rota`            | `filiais.codigo` (via `origem` e `destino`) |
| `emissoes`            | `id`                 | rotas, clientes, veículos e filiais         |
| `emissao_ocorrencias` | —                    | `emissoes.id` (via `emissao_id`)            |
| `emissao_rastreio`    | —                    | `emissoes.id` (via `emissao_id`)            |

> As abas `ocorrencias` e `rastreio` da planilha correspondem às tabelas `emissao_ocorrencias` e `emissao_rastreio` do banco.

### Campos principais de `emissoes`

| Campo                | Significado                                           |
|----------------------|-------------------------------------------------------|
| `numero_documento`   | Número do CT-e (ex.: `CTE-2026-100871`)               |
| `data_emissao`       | Data de emissão (`AAAA-MM-DD`)                        |
| `filial_origem` / `filial_destino` | Códigos das filiais                     |
| `id_rota`            | Rota (ex.: `BHZ-SPO`)                                 |
| `cliente_id`         | Embarcador                                            |
| `tipo_servico`       | Convencional, Expresso ou Dedicado                    |
| `modalidade_frete`   | CIF (remetente paga) ou FOB (destinatário paga)       |
| `tipo_carga`         | Seca, Frágil, Perecível, Refrigerada ou Controlada    |
| `volumes`, `peso_kg`, `peso_cubado_kg` | Dados da carga                      |
| `valor_mercadoria`   | Valor da nota fiscal da mercadoria                    |
| `frete_peso`, `gris`, `pedagio`, `icms` | Componentes do frete               |
| `frete_total`        | Valor total cobrado                                   |
| `data_prevista`, `data_entrega` | Prazo e entrega real (pode ser vazio)      |
| `dias_atraso`        | Dias de atraso                                        |
| `no_prazo`           | `1` = no prazo, `0` = atrasou                         |
| `status`             | Situação da emissão                                   |

> ⚠️ **Atenção:** esta base tem **sujeira proposital**. Olhe com cuidado o campo `status` (maiúsculas, minúsculas e espaços extras) e o campo `data_entrega` (vazio em algumas emissões). Na planilha, as datas estão como **texto**.

---

## ⚙️ Preparação

### Excel

1. Abra `logistica_2026.xlsx` e salve uma cópia como `desafio_XX.xlsx`.
2. Em cada aba, selecione os dados e transforme em **Tabela** (`Ctrl + T`), com os nomes: `tbEmissoes`, `tbRotas`, `tbClientes`, `tbFiliais`, `tbVeiculos`, `tbOcorrencias`, `tbRastreio`.

### Beekeeper Studio

1. Clique em **New Connection** e escolha **SQLite**.
2. Selecione o arquivo `logistica_2026.db` e clique em **Connect**.
3. Abra uma nova aba de consulta (`Ctrl + T`) e teste:

```sql
SELECT COUNT(*) FROM emissoes;
```

Execute com `Ctrl + Enter`.

---

## 🎯 Os 20 desafios

### 🟢 Nível Básico (1 a 5) — fórmulas simples e `SELECT`

#### Desafio 01 — Conhecendo a base
**A (Excel):** informe quantas linhas existem em cada aba.
**B (SQL):** mostre a quantidade de linhas de cada tabela.
**Conceitos:** `CONT.VALORES`, `LINHAS`, `COUNT(*)`, `UNION ALL`.

#### Desafio 02 — Primeiros totais
**A:** calcule o **total de peso (kg)**, o **total de volumes** e o **faturamento total** (`frete_total`).
**B:** faça o mesmo com `SUM`.
**Conceitos:** `SOMA`, `SUM`.

#### Desafio 03 — Contando por tipo de serviço
**A:** conte as emissões de cada `tipo_servico` (Convencional, Expresso, Dedicado) com `CONT.SE`.
**B:** use `GROUP BY`.
**Conceitos:** `CONT.SE`, `GROUP BY`.

#### Desafio 04 — CIF ou FOB?
**A:** calcule o percentual de emissões CIF e FOB e formate a célula como porcentagem.
**B:** faça o mesmo com SQL, arredondando para 1 casa decimal.
**Conceitos:** divisão de contagens, `ROUND`, `COUNT` com `CASE WHEN`.

#### Desafio 05 — A maior e a menor
**A:** encontre a emissão com **maior `frete_total`** e a de **maior `valor_mercadoria`**. Mostre número do documento, rota e valor.
**B:** use `ORDER BY` e `LIMIT`.
**Conceitos:** `MÁXIMO`, `CORRESP`, `ÍNDICE`, `ORDER BY DESC`, `LIMIT`.

---

### 🟡 Nível Intermediário (6 a 10) — filtros, limpeza e datas

#### Desafio 06 — Filtrando por status
**A:** com `CONT.SES`, conte as emissões **Entregues**. Confira: o número bate com o esperado? Use também o **Filtro** da aba para olhar os valores distintos de `status`.
**B:** conte as emissões com `status = 'Entregue'` e compare com o Excel.
**Conceitos:** `CONT.SES`, filtros, `WHERE`, `DISTINCT`.

#### Desafio 07 — Limpando a sujeira do status
Os valores de `status` estão inconsistentes (maiúsculas, minúsculas e espaços extras).
**A:** crie uma coluna auxiliar `status_limpo` com `ARRUMAR` e `PRI.MAIÚSCULA` (ou `MINÚSCULA`). Depois conte as emissões por status **limpo**.
**B:** faça o mesmo com `TRIM`, `LOWER` e `GROUP BY`.
**Conceitos:** `ARRUMAR`, `MINÚSCULA`, `TRIM`, `LOWER`, limpeza de dados.

#### Desafio 08 — Pontualidade (OTD)
O **OTD (On Time Delivery)** é o principal indicador de uma transportadora.
**A:** calcule o OTD geral considerando apenas emissões **entregues** (status limpo).
**B:** calcule o mesmo no SQL com `SUM(no_prazo) * 100.0 / COUNT(*)`.
**Conceitos:** indicador, filtro combinado, percentual.

#### Desafio 09 — Faturamento por filial de origem
**A:** monte uma **tabela dinâmica** com o faturamento por `filial_origem` e ordene do maior para o menor. Mostre o **top 5**.
**B:** use `GROUP BY` com `ORDER BY ... DESC LIMIT 5`.
**Conceitos:** tabela dinâmica, `SOMASE`, `GROUP BY`.

#### Desafio 10 — Emissões por dia
**A:** converta `data_emissao` para data real (`DATA.VALOR`) e conte as emissões por dia. Descubra o **dia mais movimentado** e o **menos movimentado**, e mostre o **dia da semana** com `TEXTO(data;"dddd")`.
**B:** `GROUP BY data_emissao` e, para o dia da semana, `strftime('%w', data_emissao)`.
**Conceitos:** `DATA.VALOR`, `TEXTO`, `DIA.DA.SEMANA`, `strftime`.

---

### 🟠 Nível Intermediário Avançado (11 a 15) — cruzamento de dados

#### Desafio 11 — Cruzando emissões com clientes
**A:** traga a `razao_social` para a aba `emissoes` com `PROCV` (ou `PROCX`) e mostre os **10 clientes que mais faturaram**.
**B:** use `JOIN` entre `emissoes` e `clientes`.
**Conceitos:** `PROCV`, `PROCX`, `JOIN`.

#### Desafio 12 — Faturamento por segmento
**A:** traga o `segmento` para `emissoes` e use tabela dinâmica para mostrar o faturamento, a quantidade de emissões e o ticket médio por segmento.
**B:** `JOIN` + `GROUP BY segmento`.
**Conceitos:** tabela dinâmica com média, `AVG`, `JOIN`.

#### Desafio 13 — Atrasos por rota
**A:** para cada `id_rota`, calcule o total de emissões e o OTD. Mostre as **5 piores rotas** (somente rotas com pelo menos 10 emissões).
**B:** use `GROUP BY` e `HAVING COUNT(*) >= 10`.
**Conceitos:** tabela dinâmica, filtro de valor, `HAVING`.

#### Desafio 14 — Peso a cobrar
A regra do frete é cobrar o **maior valor** entre `peso_kg` e `peso_cubado_kg`.
**A:** crie a coluna `peso_tarifado` com `MÁXIMO` e calcule o **total de peso tarifado** do mês.
**B:** calcule com `CASE WHEN` (ou `MAX(peso_kg, peso_cubado_kg)`) e `SUM`.
**Conceitos:** `MÁXIMO`, `SE`, `CASE WHEN`, colunas calculadas.

#### Desafio 15 — Ocorrências
**A:** na aba `ocorrencias`, conte as ocorrências por `tipo` e descubra a **mais frequente**. Calcule o percentual de ocorrências **resolvidas** e **em aberto**.
**B:** use `emissao_ocorrencias` com `GROUP BY` e `SUM(resolvida)`.
**Conceitos:** tabela dinâmica, percentual do total, `GROUP BY`.

---

### 🔴 Nível Avançado (16 a 20) — análise completa e projeto final

#### Desafio 16 — Ocorrências que viram prejuízo
**A:** descubra quais **tipos de ocorrência** mais aparecem em emissões **atrasadas** (`no_prazo = 0`). Traga o `no_prazo` para a aba `ocorrencias` com `PROCV`.
**B:** `JOIN` entre `emissoes` e `emissao_ocorrencias`, filtrando `no_prazo = 0`.
**Conceitos:** cruzamento 1 para N, `JOIN`, `WHERE`.

#### Desafio 17 — Linha do tempo (rastreio)
**A:** em uma célula, digite o `id` de uma emissão e use `FILTRO` (ou filtro manual) para mostrar todos os eventos dela. Depois descubra **quantas emissões nunca chegaram ao evento "Entregue"**.
**B:** consulte `emissao_rastreio` com `ORDER BY data` e use `NOT IN` ou `LEFT JOIN` para encontrar as que faltam.
**Conceitos:** `FILTRO`, `CONT.SES`, `LEFT JOIN`, `NOT IN`.

#### Desafio 18 — Uso da frota
**A:** traga o `tipo` e a `capacidade_kg` do veículo para `emissoes`. Calcule, por tipo de veículo, o peso total e a **taxa de ocupação média** (peso ÷ capacidade).
**B:** `JOIN` entre `emissoes` e `veiculos`, com `GROUP BY tipo`.
**Conceitos:** tabela dinâmica com campo calculado, `JOIN`, indicadores de eficiência.

#### Desafio 19 — Conferência do frete (auditoria)
Será que o `frete_total` está correto? A regra de conferência é:

```
frete_total = frete_peso + gris + pedagio + icms
```

**A:** crie a coluna `diferenca` e a coluna `confere` (`SE(ABS(diferenca) <= 0,05; "OK"; "ERRO")`). Mostre quantas emissões não conferem e a soma da divergência.
**B:** faça o mesmo no SQL com `ABS(...) > 0.05`.
**Conceitos:** auditoria de dados, tolerância, `ABS`.

#### Desafio 20 — Relatório gerencial final 🏆
Monte uma aba **Dashboard** no Excel e uma consulta final no Beekeeper com:

1. Total de emissões, faturamento e peso
2. OTD geral e OTD por `tipo_servico`
3. Top 5 clientes e top 5 filiais de origem
4. 5 piores rotas em pontualidade
5. Ocorrência mais frequente e % em aberto
6. Emissões **Extraviadas** ou **Devolvidas** (quantidade e valor de mercadoria envolvido)

**Regras:**
- No Excel: use tabelas dinâmicas, **segmentação de dados** e pelo menos **2 gráficos**.
- No SQL: salve as consultas em `desafio_20.sql` e, se quiser, crie uma **VIEW** com o resultado.
- Compare todos os números entre Excel e SQL.

**Conceitos:** dashboard, gráficos, `CREATE VIEW`, organização de consultas.

---

## ✅ Regras do desafio

1. Digite as fórmulas e consultas você mesmo. Não copie e cole.
2. Resolva a **Parte A** primeiro e só depois a **Parte B**.
3. Sempre compare os resultados de A e B.
4. Um desafio por vez. Só avance quando o anterior estiver correto.
5. Salve a planilha e o arquivo `.sql` de cada desafio.

---

## 📊 Acompanhamento

| #  | Desafio                          | Nível          | Excel | SQL |
|----|----------------------------------|----------------|:-----:|:---:|
| 01 | Conhecendo a base                | Básico         |  ⬜   | ⬜  |
| 02 | Primeiros totais                 | Básico         |  ⬜   | ⬜  |
| 03 | Contando por tipo de serviço     | Básico         |  ⬜   | ⬜  |
| 04 | CIF ou FOB?                      | Básico         |  ⬜   | ⬜  |
| 05 | A maior e a menor                | Básico         |  ⬜   | ⬜  |
| 06 | Filtrando por status             | Intermediário  |  ⬜   | ⬜  |
| 07 | Limpando a sujeira do status     | Intermediário  |  ⬜   | ⬜  |
| 08 | Pontualidade (OTD)               | Intermediário  |  ⬜   | ⬜  |
| 09 | Faturamento por filial           | Intermediário  |  ⬜   | ⬜  |
| 10 | Emissões por dia                 | Intermediário  |  ⬜   | ⬜  |
| 11 | Cruzando com clientes            | Int. Avançado  |  ⬜   | ⬜  |
| 12 | Faturamento por segmento         | Int. Avançado  |  ⬜   | ⬜  |
| 13 | Atrasos por rota                 | Int. Avançado  |  ⬜   | ⬜  |
| 14 | Peso a cobrar                    | Int. Avançado  |  ⬜   | ⬜  |
| 15 | Ocorrências                      | Int. Avançado  |  ⬜   | ⬜  |
| 16 | Ocorrências que viram prejuízo   | Avançado       |  ⬜   | ⬜  |
| 17 | Linha do tempo (rastreio)        | Avançado       |  ⬜   | ⬜  |
| 18 | Uso da frota                     | Avançado       |  ⬜   | ⬜  |
| 19 | Conferência do frete             | Avançado       |  ⬜   | ⬜  |
| 20 | Relatório gerencial final        | Avançado       |  ⬜   | ⬜  |

---

## 📚 Glossário rápido de logística

| Termo     | Significado                                                        |
|-----------|--------------------------------------------------------------------|
| **CT-e**  | Conhecimento de Transporte Eletrônico (o documento do frete)       |
| **CIF**   | O remetente paga o frete                                           |
| **FOB**   | O destinatário paga o frete                                        |
| **GRIS**  | Gerenciamento de Risco: taxa cobrada sobre o valor da mercadoria   |
| **ICMS**  | Imposto estadual embutido no frete                                 |
| **Peso cubado** | Peso calculado pelo volume ocupado; cobra-se o maior entre peso real e cubado |
| **OTD**   | On Time Delivery: percentual de entregas feitas no prazo           |
| **Hub**   | Unidade de transbordo e distribuição entre filiais                 |

---

Bons estudos! 🚀
