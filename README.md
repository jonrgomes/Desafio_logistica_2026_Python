# 🚚 Desafio Python — Logística 2026

20 desafios práticos, do básico ao avançado, usando uma base **fictícia** de emissões de CT-e (Conhecimento de Transporte Eletrônico) de uma transportadora, referente a **outubro de 2026**.

Cada desafio tem duas partes:

- **Parte A — JSON:** resolver lendo o arquivo `logistica_2026.json` com Python puro.
- **Parte B — SQLite:** resolver o mesmo problema consultando `logistica_2026.db` com `sqlite3`.

No fim de cada desafio, compare os resultados das partes A e B. **Eles precisam ser iguais.**

---

## 📁 Estrutura do projeto

```
Desafio_logistica_2026_Python/
├── README.md
├── logistica_2026.json
├── logistica_2026.db
├── logistica_2026.xlsx      # mesma base, para conferência no Excel
├── banco.py                 # função de conexão com o banco
├── modelo.py                # modelo para copiar em cada desafio
├── desafio_01.py
├── desafio_02.py
└── ...
```

> A cada desafio, copie o `modelo.py` e renomeie para `desafio_XX.py`.

---

## 🗂️ A base de dados

### Arquivo JSON (`logistica_2026.json`)

Um dicionário com 7 listas:

| Chave         | Registros | O que é                                      |
|---------------|-----------|----------------------------------------------|
| `emissoes`    | 2.000     | Os CT-e emitidos (tabela principal)          |
| `rotas`       | 101       | Origem, destino, distância, prazo e tarifa   |
| `clientes`    | 60        | Embarcadores (quem contrata o frete)         |
| `filiais`     | 20        | 1 matriz, 4 hubs e 15 filiais                |
| `veiculos`    | 40        | Frota: Carreta, Truck, Toco, VUC e Van       |
| `ocorrencias` | 367       | Problemas registrados nas entregas           |
| `rastreio`    | 11.790    | Eventos de cada emissão (linha do tempo)     |

### Banco SQLite (`logistica_2026.db`)

| Tabela                | Chave                          | Liga com                                   |
|-----------------------|--------------------------------|--------------------------------------------|
| `filiais`             | `codigo`                       | —                                          |
| `clientes`            | `id_cliente`                   | `filiais.codigo` (via `filial_base`)       |
| `veiculos`            | `id_veiculo`                   | `filiais.codigo` (via `filial_base`)       |
| `rotas`               | `id_rota`                      | `filiais.codigo` (via `origem` e `destino`)|
| `emissoes`            | `id`                           | rotas, clientes, veículos e filiais        |
| `emissao_ocorrencias` | —                              | `emissoes.id` (via `emissao_id`)           |
| `emissao_rastreio`    | —                              | `emissoes.id` (via `emissao_id`)           |

> No JSON, as listas `ocorrencias` e `rastreio` correspondem às tabelas `emissao_ocorrencias` e `emissao_rastreio` do banco.

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
| `data_prevista`, `data_entrega` | Prazo e entrega real (pode ser nulo)       |
| `dias_atraso`        | Dias de atraso                                        |
| `no_prazo`           | `1` = no prazo, `0` = atrasou                         |
| `status`             | Situação da emissão                                   |

> ⚠️ **Atenção:** esta base tem **sujeira proposital**. Olhe com cuidado o campo `status` e o campo `data_entrega`. Nem tudo está padronizado, e isso faz parte do aprendizado.

---

## ⚙️ Preparação

### Ler o JSON

```python
import json

with open("logistica_2026.json", encoding="utf-8") as arquivo:
    dados = json.load(arquivo)

emissoes = dados["emissoes"]
print(len(emissoes))
```

### Ler o banco

```python
import sqlite3

conexao = sqlite3.connect("logistica_2026.db")
cursor = conexao.cursor()
cursor.execute("SELECT COUNT(*) FROM emissoes")
print(cursor.fetchone()[0])
conexao.close()
```

---

## 🎯 Os 20 desafios

### 🟢 Nível Básico (1 a 5) — variáveis, listas, `for` e `if`

#### Desafio 01 — Conhecendo a base
**A (JSON):** carregue o arquivo e mostre quantos registros existem em cada uma das 7 listas.
**B (SQL):** mostre a quantidade de linhas de cada tabela.
**Conceitos:** `open`, `json.load`, `len`, `sqlite3`, `COUNT`.

#### Desafio 02 — Primeiros totais
**A:** com um `for`, calcule o **total de peso (kg)**, o **total de volumes** e o **faturamento total** (`frete_total`) do mês.
**B:** faça o mesmo com `SUM`.
**Conceitos:** acumuladores, `sum`.

#### Desafio 03 — Contando por tipo de serviço
**A:** conte quantas emissões existem de cada `tipo_servico` (Convencional, Expresso, Dedicado) usando um dicionário.
**B:** use `GROUP BY`.
**Conceitos:** dicionário como contador, `.get()`.

#### Desafio 04 — CIF ou FOB?
**A:** calcule o percentual de emissões CIF e FOB (arredonde para 1 casa decimal).
**B:** faça o mesmo com SQL.
**Conceitos:** divisão, `round`, formatação com f-string.

#### Desafio 05 — A maior e a menor
**A:** encontre a emissão com **maior `frete_total`** e a de **maior `valor_mercadoria`**. Mostre número do documento, rota e valor.
**B:** use `ORDER BY` e `LIMIT`.
**Conceitos:** `max`, `min`, `key=`, `sorted`.

---

### 🟡 Nível Intermediário (6 a 10) — funções, filtros, ordenação e datas

#### Desafio 06 — Primeira função
Crie a função `filtrar_por_status(emissoes: list[dict], status: str) -> list[dict]`.
**A:** use a função para listar as emissões **Entregues**. Atenção: confira quantos registros você encontrou. O número bate com o esperado?
**B:** conte as emissões com `status = 'Entregue'` no SQL e compare.
**Conceitos:** funções, parâmetros, tipagem, retorno.

#### Desafio 07 — Limpando a sujeira do status
Os valores do campo `status` estão inconsistentes (maiúsculas, minúsculas e espaços extras).
**A:** crie a função `normalizar_status(texto: str) -> str` usando `.strip()` e `.lower()` ou `.capitalize()`. Depois conte quantas emissões existem em cada status **limpo**.
**B:** faça o mesmo com `TRIM`, `LOWER` e `GROUP BY`.
**Conceitos:** tratamento de texto, limpeza de dados.

#### Desafio 08 — Pontualidade (OTD)
O **OTD (On Time Delivery)** é o principal indicador de uma transportadora.
**A:** crie a função `calcular_otd(emissoes: list[dict]) -> float` considerando apenas emissões entregues. Calcule o OTD geral.
**B:** calcule o mesmo no SQL com `AVG(no_prazo)` ou `SUM/COUNT`.
**Conceitos:** indicador, filtro combinado, percentual.

#### Desafio 09 — Faturamento por filial de origem
**A:** monte um dicionário `{filial: faturamento}` e mostre o **ranking das 5 maiores** filiais.
**B:** use `GROUP BY` com `ORDER BY ... DESC LIMIT 5`.
**Conceitos:** dicionários, `sorted` com `lambda`, fatiamento.

#### Desafio 10 — Emissões por dia
**A:** conte as emissões por `data_emissao` e descubra o **dia mais movimentado** e o **dia menos movimentado**. Use também o módulo `datetime` para mostrar o **dia da semana** de cada um.
**B:** `GROUP BY data_emissao`.
**Conceitos:** `datetime.strptime`, `.weekday()`, strings de data.

---

### 🟠 Nível Intermediário Avançado (11 a 15) — cruzamento de dados e classes

#### Desafio 11 — Cruzando emissões com clientes
No JSON, os dados do cliente estão em outra lista.
**A:** monte um dicionário `{id_cliente: razao_social}` e mostre os **10 clientes que mais faturaram**, com o nome (e não o código).
**B:** use `JOIN` entre `emissoes` e `clientes`.
**Conceitos:** dicionário de apoio (lookup), `JOIN`.

#### Desafio 12 — Faturamento por segmento
**A:** descubra o faturamento total e o ticket médio (faturamento ÷ emissões) de cada `segmento` de cliente (Agro, E-commerce, Farmacêutico...).
**B:** `JOIN` + `GROUP BY segmento`.
**Conceitos:** cruzamento de duas listas, média por grupo.

#### Desafio 13 — Atrasos por rota
**A:** para cada `id_rota`, calcule o total de emissões e o OTD. Mostre as **5 piores rotas** (considere somente rotas com pelo menos 10 emissões).
**B:** use `GROUP BY` e `HAVING COUNT(*) >= 10`.
**Conceitos:** filtro após agrupamento, ordenação por mais de um critério.

#### Desafio 14 — Criando a classe `Emissao`
Crie uma classe para representar um CT-e.

```python
class Emissao:
    def __init__(self, id: int, numero_documento: str, frete_total: float, ...):
        ...

    def esta_atrasada(self) -> bool:
        ...

    def peso_a_cobrar(self) -> float:
        # regra: maior valor entre peso_kg e peso_cubado_kg
        ...
```

**A:** transforme cada dicionário do JSON em um objeto `Emissao` e calcule, com o método `peso_a_cobrar`, o **total de peso tarifado** do mês.
**B:** calcule o mesmo no SQL usando `CASE WHEN` (ou `MAX(peso_kg, peso_cubado_kg)`).
**Conceitos:** classes, `__init__`, métodos, orientação a objetos.

#### Desafio 15 — Ocorrências
**A:** conte as ocorrências por `tipo` e descubra qual é a **mais frequente**. Depois calcule o percentual de ocorrências **resolvidas** e o percentual **em aberto**.
**B:** use a tabela `emissao_ocorrencias` com `GROUP BY` e `SUM(resolvida)`.
**Conceitos:** trabalhar com outra lista do JSON, percentuais.

---

### 🔴 Nível Avançado (16 a 20) — análise completa e projeto final

#### Desafio 16 — Ocorrências que viram prejuízo
**A:** descubra quais **tipos de ocorrência** mais aparecem em emissões **atrasadas**. Cruze `ocorrencias` com `emissoes` pelo `emissao_id`.
**B:** `JOIN` entre `emissoes` e `emissao_ocorrencias`, filtrando `no_prazo = 0`.
**Conceitos:** cruzamento de listas, relação 1 para N.

#### Desafio 17 — Linha do tempo (rastreio)
**A:** para uma emissão informada pelo usuário (`input`), mostre todos os eventos em ordem cronológica. Depois, descubra **quantas emissões nunca chegaram ao evento "Entregue"**.
**B:** consulte `emissao_rastreio` com `ORDER BY data` e use `NOT IN` ou `LEFT JOIN` para encontrar as que faltam.
**Conceitos:** `input`, listas dentro de dicionários, `set`, `LEFT JOIN`.

#### Desafio 18 — Uso da frota
**A:** para cada veículo, calcule quantas emissões transportou, o peso total e a **taxa de ocupação média** (peso total ÷ capacidade). Mostre o ranking por tipo de veículo.
**B:** `JOIN` entre `emissoes` e `veiculos`, com `GROUP BY tipo`.
**Conceitos:** cruzamento, indicadores de eficiência.

#### Desafio 19 — Conferência do frete (auditoria)
Será que o `frete_total` está correto? A regra de conferência é:

```
frete_total = frete_peso + gris + pedagio + icms
```

**A:** crie a função `frete_confere(emissao: dict, tolerancia: float = 0.05) -> bool`. Liste as emissões que **não conferem**, com a diferença encontrada, e some o valor total da divergência.
**B:** faça o mesmo no SQL com `ABS(...) > 0.05`.
**Conceitos:** auditoria de dados, tolerância em `float`, `ABS`.

#### Desafio 20 — Relatório gerencial final 🏆
Monte um programa completo (`desafio_20.py`) que gere um relatório com:

1. Total de emissões, faturamento e peso
2. OTD geral e OTD por `tipo_servico`
3. Top 5 clientes e top 5 filiais de origem
4. 5 piores rotas em pontualidade
5. Ocorrência mais frequente e % em aberto
6. Emissões com status **Extraviada** ou **Devolvida** (quantidade e valor de mercadoria envolvido)
7. Ao final, **salve o relatório** em `relatorio_final.txt` (ou em `relatorio_final.csv`)

**Regras:**
- Use **funções** com tipagem para cada item.
- Use pelo menos **uma classe**.
- Compare o resultado com o SQL e com a planilha `logistica_2026.xlsx`.

**Conceitos:** projeto completo, escrita de arquivo (`open(..., "w")`), organização do código.

---

## ✅ Regras do desafio

1. Digite o código você mesmo. Não copie e cole.
2. Resolva a **Parte A** primeiro e só depois a **Parte B**.
3. Sempre compare os resultados de A, B e do Excel.
4. Use **funções** e **tipagem** sempre que possível.
5. Um desafio por vez. Só avance quando o anterior estiver correto.
6. Faça um `commit` no GitHub ao concluir cada desafio.

---

## 📊 Acompanhamento

| #  | Desafio                          | Nível          | Parte A | Parte B |
|----|----------------------------------|----------------|:-------:|:-------:|
| 01 | Conhecendo a base                | Básico         |   ⬜    |   ⬜    |
| 02 | Primeiros totais                 | Básico         |   ⬜    |   ⬜    |
| 03 | Contando por tipo de serviço     | Básico         |   ⬜    |   ⬜    |
| 04 | CIF ou FOB?                      | Básico         |   ⬜    |   ⬜    |
| 05 | A maior e a menor                | Básico         |   ⬜    |   ⬜    |
| 06 | Primeira função                  | Intermediário  |   ⬜    |   ⬜    |
| 07 | Limpando a sujeira do status     | Intermediário  |   ⬜    |   ⬜    |
| 08 | Pontualidade (OTD)               | Intermediário  |   ⬜    |   ⬜    |
| 09 | Faturamento por filial           | Intermediário  |   ⬜    |   ⬜    |
| 10 | Emissões por dia                 | Intermediário  |   ⬜    |   ⬜    |
| 11 | Cruzando com clientes            | Int. Avançado  |   ⬜    |   ⬜    |
| 12 | Faturamento por segmento         | Int. Avançado  |   ⬜    |   ⬜    |
| 13 | Atrasos por rota                 | Int. Avançado  |   ⬜    |   ⬜    |
| 14 | Classe `Emissao`                 | Int. Avançado  |   ⬜    |   ⬜    |
| 15 | Ocorrências                      | Int. Avançado  |   ⬜    |   ⬜    |
| 16 | Ocorrências que viram prejuízo   | Avançado       |   ⬜    |   ⬜    |
| 17 | Linha do tempo (rastreio)        | Avançado       |   ⬜    |   ⬜    |
| 18 | Uso da frota                     | Avançado       |   ⬜    |   ⬜    |
| 19 | Conferência do frete             | Avançado       |   ⬜    |   ⬜    |
| 20 | Relatório gerencial final        | Avançado       |   ⬜    |   ⬜    |

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
# Desafio_logistica_2026_Python
