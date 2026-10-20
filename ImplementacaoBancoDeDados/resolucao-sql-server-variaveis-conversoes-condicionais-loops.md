# Resolução dos Exercícios — SQL Server

**Tópicos:** variáveis, conversão de dados, estruturas condicionais, loops e procedimento armazenado
**Ambiente:** SQL Server (T‑SQL) — testado no padrão do SSMS / Azure Data Studio

> **Como usar este documento:** cada exercício traz o script, a explicação do porquê e a saída esperada.
> Onde a saída aparece muda conforme o comando: `PRINT` escreve na aba **Messages** (Mensagens);
> `SELECT` devolve uma grade na aba **Results** (Resultados).

---

## 1. Variáveis

### 1.1. Declaração de Variáveis

```sql
DECLARE @NomeProduto        VARCHAR(50);
DECLARE @QuantidadeEstoque  INT;
DECLARE @PrecoProduto       DECIMAL(10,2);
```

Também é válido declarar tudo em um único `DECLARE`, separando por vírgula:

```sql
DECLARE @NomeProduto        VARCHAR(50),
        @QuantidadeEstoque  INT,
        @PrecoProduto       DECIMAL(10,2);
```

**Explicação**

- `VARCHAR(50)` — texto de tamanho variável, até 50 caracteres.
- `INT` — inteiro, sem casas decimais.
- `DECIMAL(10,2)` — número com **10 dígitos no total**, sendo **2 depois da vírgula**. Ou seja, vai até 99.999.999,99. É o tipo correto para dinheiro (diferente de `FLOAT`, que é aproximado e gera erro de arredondamento em soma de valores monetários).

**Atenção — a pegadinha mais comum:** dentro de um `DECLARE`, se você escrever `VARCHAR` **sem** informar o tamanho, o SQL Server assume `VARCHAR(1)`. `SET @NomeProduto = 'Notebook'` guardaria apenas `N`, silenciosamente, sem erro nenhum. Sempre declare o tamanho.

**Saída esperada:** nenhuma. `DECLARE` apenas reserva a variável na memória; ela nasce com valor `NULL`.

---

### 1.2. Atribuição de Valores

```sql
SET @NomeProduto       = 'Notebook';
SET @QuantidadeEstoque = 15;
SET @PrecoProduto      = 2999.99;
```

Alternativa mais enxuta — declarar e atribuir na mesma linha:

```sql
DECLARE @NomeProduto        VARCHAR(50)    = 'Notebook',
        @QuantidadeEstoque  INT            = 15,
        @PrecoProduto       DECIMAL(10,2)  = 2999.99;
```

**Explicação**

- Texto vai **sempre** entre aspas simples (`'Notebook'`). Aspas duplas, em T‑SQL, servem para nomes de objetos, não para strings.
- O separador decimal no código é **ponto**, nunca vírgula: `2999.99`, não `2999,99`. `SET @PrecoProduto = 2999,99` provoca erro de sintaxe.
- `SET` atribui **uma** variável por comando. Existe também `SELECT @var = valor`, que atribui várias de uma vez — a diferença prática aparece no item 4.3.

**Saída esperada:** nenhuma. Atribuição não exibe nada.

---

### 1.3. Exibição de Valores

```sql
DECLARE @NomeProduto        VARCHAR(50)    = 'Notebook',
        @QuantidadeEstoque  INT            = 15,
        @PrecoProduto       DECIMAL(10,2)  = 2999.99;

-- Forma 1: PRINT (aba Messages)
PRINT 'Nome do Produto......: ' + @NomeProduto;
PRINT 'Quantidade em Estoque: ' + CAST(@QuantidadeEstoque AS VARCHAR(10));
PRINT 'Preço do Produto.....: ' + CAST(@PrecoProduto AS VARCHAR(20));

-- Forma 2: SELECT (aba Results)
SELECT @NomeProduto       AS NomeProduto,
       @QuantidadeEstoque AS QuantidadeEstoque,
       @PrecoProduto      AS PrecoProduto;
```

**Explicação**

O `PRINT` só aceita texto. Ao escrever `'Quantidade: ' + @QuantidadeEstoque`, o SQL Server não junta os dois: como `INT` tem precedência de tipo maior que `VARCHAR`, ele tenta converter a **string** para número e falha com

```
Msg 245 — Conversion failed when converting the varchar value 'Quantidade em Estoque: ' to data type int.
```

Por isso o `CAST(... AS VARCHAR(n))` em volta de tudo que não é texto. A alternativa moderna é `CONCAT`, que converte sozinho:

```sql
PRINT CONCAT('Quantidade em Estoque: ', @QuantidadeEstoque);
```

**Saída esperada — aba Messages:**

```
Nome do Produto......: Notebook
Quantidade em Estoque: 15
Preço do Produto.....: 2999.99
```

**Saída esperada — aba Results:**

| NomeProduto | QuantidadeEstoque | PrecoProduto |
|-------------|-------------------|--------------|
| Notebook    | 15                | 2999.99      |

**Quando usar cada um:** `PRINT` é para acompanhar a execução (depuração, mensagens de loop). `SELECT` devolve um conjunto de resultados de verdade — pode ser ordenado, exportado, consumido por uma aplicação. Além disso, o `PRINT` tem limite de 8.000 caracteres e, em alguns clientes, só aparece ao final do lote.

---

### 1.4. Cálculo utilizando Variáveis

```sql
DECLARE @SalarioBase  DECIMAL(10,2),
        @Bonus        DECIMAL(10,2),
        @SalarioTotal DECIMAL(10,2);

SET @SalarioBase = 5000.00;
SET @Bonus       = 800.00;

SET @SalarioTotal = @SalarioBase + @Bonus;

PRINT 'Salário Base..: ' + CAST(@SalarioBase  AS VARCHAR(20));
PRINT 'Bônus.........: ' + CAST(@Bonus        AS VARCHAR(20));
PRINT 'Salário Total.: ' + CAST(@SalarioTotal AS VARCHAR(20));

SELECT @SalarioBase AS SalarioBase, @Bonus AS Bonus, @SalarioTotal AS SalarioTotal;
```

**Explicação**

A soma de dois `DECIMAL(10,2)` mantém as duas casas decimais, então `@SalarioTotal` recebe `5800.00` sem perda. Se `@SalarioTotal` fosse declarado como `INT`, o resultado seria arredondado para `5800` — e, com valores quebrados como `5800.60`, viraria `5801`.

**Saída esperada — aba Messages:**

```
Salário Base..: 5000.00
Bônus.........: 800.00
Salário Total.: 5800.00
```

**Saída esperada — aba Results:**

| SalarioBase | Bonus  | SalarioTotal |
|-------------|--------|--------------|
| 5000.00     | 800.00 | 5800.00      |

---

## 2. Conversão de Dados

### 2.1. CAST — data atual para `VARCHAR(10)`

```sql
SELECT CAST(GETDATE() AS VARCHAR(10)) AS DataComoTexto;
```

**Saída esperada** (executando em 10/09/2026, servidor em inglês):

| DataComoTexto |
|---------------|
| Sep 10 202    |

**Explicação — e aqui está a lição do exercício**

O `CAST` **não permite escolher o formato**. Ao converter `DATETIME` para texto, o SQL Server usa o estilo padrão (`0`), que produz algo como `Sep 10 2026  4:36PM` — 19 caracteres. Como o destino é `VARCHAR(10)`, o texto é **cortado silenciosamente** nos 10 primeiros caracteres: `Sep 10 202`. Nenhum erro é levantado, o que torna o problema fácil de não perceber.

Ainda por cima, o nome do mês depende do idioma da sessão (`SET LANGUAGE`): em português sairia `Set 10 202`.

**Como obter uma data legível de verdade** — usando `CONVERT` com estilo explícito:

```sql
SELECT CONVERT(VARCHAR(10), GETDATE(), 103) AS Formato_ddMMyyyy,  -- 10/09/2026
       CONVERT(VARCHAR(10), GETDATE(), 23)  AS Formato_ISO,       -- 2026-09-10
       CAST(CAST(GETDATE() AS DATE) AS VARCHAR(10)) AS ViaTipoDate; -- 2026-09-10
```

A terceira forma funciona porque, convertida primeiro para `DATE`, a data já ocupa exatamente 10 caracteres no formato ISO — não sobra nada para truncar.

**Regra prática:** `CAST` é ANSI‑padrão e portável; `CONVERT` é exclusivo do SQL Server, mas é o único que aceita o terceiro argumento (o *style*). Para datas, use `CONVERT`.

---

### 2.2. CONVERT — 12345.67 para `INT`

```sql
SELECT CONVERT(INT, 12345.67) AS ValorConvertido;
```

**Saída esperada:**

| ValorConvertido |
|-----------------|
| 12345           |

**Explicação**

A conversão de um numérico para `INT` **trunca**, não arredonda: a parte decimal é simplesmente descartada. `12345.99` também viraria `12345`. Para números negativos o corte é em direção ao zero: `CONVERT(INT, -12345.67)` resulta em `-12345`.

Se a intenção for arredondar:

```sql
SELECT CONVERT(INT, ROUND(12345.67, 0)) AS Arredondado;  -- 12346
```

**Cuidado:** isso vale para um valor **numérico**. `CONVERT(INT, '12345.67')` — com o número entre aspas, portanto texto — falha, porque não existe conversão direta de string com casas decimais para inteiro:

```
Msg 245 — Conversion failed when converting the varchar value '12345.67' to data type int.
```

Nesse caso é preciso passar por um tipo decimal antes: `CONVERT(INT, CONVERT(DECIMAL(10,2), '12345.67'))`.

---

### 2.3. Exercício Prático — decimal ↔ inteiro com `CAST` e `CONVERT`

```sql
DECLARE @NumeroDecimal DECIMAL(10,2) = 987.65;
DECLARE @NumeroInteiro INT           = 250;

SELECT
    @NumeroDecimal                            AS Decimal_Original,      -- 987.65
    CAST(@NumeroDecimal AS INT)               AS Decimal_para_Int_CAST,    -- 987
    CONVERT(INT, @NumeroDecimal)              AS Decimal_para_Int_CONVERT, -- 987
    @NumeroInteiro                            AS Inteiro_Original,      -- 250
    CAST(@NumeroInteiro AS DECIMAL(10,2))     AS Int_para_Decimal_CAST,    -- 250.00
    CONVERT(DECIMAL(10,2), @NumeroInteiro)    AS Int_para_Decimal_CONVERT; -- 250.00
```

**Saída esperada:**

| Decimal_Original | Decimal_para_Int_CAST | Decimal_para_Int_CONVERT | Inteiro_Original | Int_para_Decimal_CAST | Int_para_Decimal_CONVERT |
|---|---|---|---|---|---|
| 987.65 | 987 | 987 | 250 | 250.00 | 250.00 |

**Explicação**

- **Decimal → inteiro:** perda de informação. Os `,65` desaparecem e não há como recuperá‑los. `CAST` e `CONVERT` produzem exatamente o mesmo resultado — muda só a sintaxe: `CAST(valor AS tipo)` versus `CONVERT(tipo, valor)`.
- **Inteiro → decimal:** sem perda. O `250` vira `250.00`; as casas decimais são preenchidas com zero por causa do `(10,2)`.

Repare na assimetria: a ida e a volta **não** devolvem o valor original. `CAST(CAST(987.65 AS INT) AS DECIMAL(10,2))` resulta em `987.00`. Conversão que estreita o tipo é sempre um caminho sem volta.

---

### 2.4. Conversão de String para Data

```sql
DECLARE @DataNascimento VARCHAR(10) = '15/08/1990';

SELECT CONVERT(DATE, @DataNascimento, 103) AS DataNascimentoConvertida;
```

**Saída esperada:**

| DataNascimentoConvertida |
|--------------------------|
| 1990-08-15               |

**Explicação**

O `103` é o **style** — o código que informa ao SQL Server como o texto está escrito. `103` significa `dd/mm/yyyy` (padrão britânico/francês, que é o nosso). Sem ele:

```sql
SELECT CONVERT(DATE, @DataNascimento);   -- em servidor us_english → erro
```

```
Msg 241 — Conversion failed when converting date and/or time from character string.
```

O motivo é que, no padrão americano (`101`, `mm/dd/yyyy`), `15/08/1990` seria o mês 15 — que não existe. E aqui mora um risco pior que o erro: a data `05/08/1990` **não** dá erro, ela é lida como **5 de agosto** ou **8 de maio** conforme a configuração do servidor. O bug passa despercebido até alguém conferir o relatório.

Styles úteis para lembrar:

| Style | Formato        | Exemplo      |
|-------|----------------|--------------|
| 103   | dd/mm/yyyy     | 15/08/1990   |
| 101   | mm/dd/yyyy     | 08/15/1990   |
| 112   | yyyymmdd       | 19900815     |
| 23    | yyyy-mm-dd     | 1990-08-15   |

**Versão à prova de falha** — `TRY_CONVERT` devolve `NULL` em vez de derrubar o lote com erro:

```sql
SELECT TRY_CONVERT(DATE, @DataNascimento, 103) AS DataSegura;
```

Útil quando os dados vêm de importação e podem conter lixo.

---

## 3. Estruturas Condicionais

### 3.1. IF / ELSE Básico

```sql
DECLARE @Idade INT = 20;

IF @Idade >= 18
    PRINT 'Maior de Idade';
ELSE
    PRINT 'Menor de Idade';
```

**Saída esperada:** `Maior de Idade` (com `@Idade = 20`). Trocando para `@Idade = 15`, sai `Menor de Idade`.

**Explicação**

O `IF` do T‑SQL controla **um único comando**. Para executar mais de um comando dentro do ramo, é obrigatório envolvê‑los em `BEGIN ... END`:

```sql
IF @Idade >= 18
BEGIN
    PRINT 'Maior de Idade';
    PRINT 'Pode assinar contratos.';
END
ELSE
BEGIN
    PRINT 'Menor de Idade';
    PRINT 'Necessita de representante legal.';
END
```

Sem o `BEGIN/END`, a segunda linha executaria **sempre**, independente da condição — e não há indentação que corrija isso, porque o T‑SQL ignora espaçamento. É um dos erros mais frequentes de quem vem de linguagens com blocos por chave ou por indentação.

Se `@Idade` for `NULL`, nenhuma das duas mensagens é impressa: comparações com `NULL` resultam em *desconhecido*, e o `IF` só executa o ramo verdadeiro quando a condição é verdadeira — o `ELSE` de um `IF` com condição desconhecida também não roda.

---

### 3.2. IF / ELSE com Múltiplas Condições

```sql
DECLARE @NotaFinal DECIMAL(5,2) = 85.00;

IF @NotaFinal >= 90
    PRINT 'Aprovado com Excelência';
ELSE IF @NotaFinal >= 70
    PRINT 'Aprovado';
ELSE IF @NotaFinal >= 50
    PRINT 'Em Recuperação';
ELSE
    PRINT 'Reprovado';
```

**Saída esperada:** `Aprovado` (com `@NotaFinal = 85`).

**Tabela de verificação:**

| @NotaFinal | Mensagem                |
|------------|-------------------------|
| 95         | Aprovado com Excelência |
| 90         | Aprovado com Excelência |
| 85         | Aprovado                |
| 70         | Aprovado                |
| 60         | Em Recuperação          |
| 50         | Em Recuperação          |
| 30         | Reprovado               |

**Explicação**

Repare que **não** foi preciso escrever `@NotaFinal >= 70 AND @NotaFinal < 90`. Como o encadeamento é avaliado de cima para baixo e cada `ELSE IF` só é alcançado quando todas as condições anteriores falharam, a nota já é comprovadamente menor que 90 quando o segundo teste roda. Escrever a condição composta funciona, mas é redundante — e ordenar do maior para o menor é o que torna isso possível. Se a ordem fosse invertida (`>= 50` primeiro), toda nota acima de 50 cairia em "Em Recuperação".

**Alternativa mais elegante com `CASE`** — funciona dentro de um `SELECT`, o que o `IF` não permite:

```sql
SELECT CASE
           WHEN @NotaFinal >= 90 THEN 'Aprovado com Excelência'
           WHEN @NotaFinal >= 70 THEN 'Aprovado'
           WHEN @NotaFinal >= 50 THEN 'Em Recuperação'
           ELSE 'Reprovado'
       END AS Situacao;
```

`IF` é controle de fluxo (decide qual comando roda); `CASE` é uma expressão (devolve um valor). Para classificar todas as linhas de uma tabela de uma só vez, é `CASE` que se usa.

---

### 3.3. IF / ELSE com Operadores Lógicos — Ano Bissexto

```sql
DECLARE @Ano INT = 2024;

IF (@Ano % 4 = 0 AND @Ano % 100 <> 0) OR (@Ano % 400 = 0)
    PRINT CAST(@Ano AS VARCHAR(4)) + ' - Ano Bissexto';
ELSE
    PRINT CAST(@Ano AS VARCHAR(4)) + ' - Ano Comum';
```

**Saída esperada:** `2024 - Ano Bissexto`.

**Tabela de verificação (os casos que realmente importam):**

| @Ano | % 4 = 0 | % 100 ≠ 0 | % 400 = 0 | Resultado    |
|------|---------|-----------|-----------|--------------|
| 2024 | sim     | sim       | não       | Ano Bissexto |
| 2023 | não     | —         | não       | Ano Comum    |
| 1900 | sim     | **não**   | não       | Ano Comum    |
| 2000 | sim     | não       | **sim**   | Ano Bissexto |

**Explicação**

- `%` é o operador de módulo (resto da divisão). `2024 % 4 = 0` significa "2024 é divisível por 4".
- `<>` é "diferente de" — o `!=` também é aceito no SQL Server, mas `<>` é o padrão ANSI.
- Os parênteses são o que dá sentido à regra. `AND` tem precedência sobre `OR`, então a expressão até funcionaria sem eles; mantê‑los deixa a intenção explícita e evita erro na hora de alterar.

A regra em português: é bissexto todo ano divisível por 4, **exceto** os divisíveis por 100 — a menos que também sejam divisíveis por 400. Por isso 1900 não foi bissexto e 2000 foi. Os dois casos precisam estar na sua bateria de testes; um código que só testa 2024 e 2023 parece correto e está errado.

**Curiosidade útil:** o próprio SQL Server sabe responder isso sem a fórmula — se 29 de fevereiro existe naquele ano, ele é bissexto:

```sql
SELECT IIF(TRY_CONVERT(DATE, CAST(@Ano AS VARCHAR(4)) + '0229', 112) IS NULL,
           'Ano Comum', 'Ano Bissexto') AS Resultado;
```

---

## 4. Loops

### 4.1. While Simples — números de 1 a 10

```sql
DECLARE @Contador INT = 1;

WHILE @Contador <= 10
BEGIN
    PRINT @Contador;
    SET @Contador = @Contador + 1;   -- ou: SET @Contador += 1;
END
```

**Saída esperada — aba Messages:**

```
1
2
3
4
5
6
7
8
9
10
```

**Explicação**

Todo `WHILE` tem três peças, e esquecer qualquer uma delas quebra o loop:

1. **Inicialização** — `@Contador = 1`, antes do loop. Se a variável ficar `NULL`, a condição nunca é verdadeira e o loop não executa nenhuma vez.
2. **Condição** — `@Contador <= 10`, testada **antes** de cada iteração.
3. **Incremento** — `SET @Contador += 1`, **dentro** do `BEGIN/END`. Esquecer essa linha é o clássico loop infinito: será preciso cancelar a consulta manualmente.

O `PRINT @Contador` funciona sem `CAST` porque `INT` tem conversão implícita para texto quando é o argumento único do `PRINT`. O `CAST` só passa a ser obrigatório ao concatenar com uma string, como visto no item 1.3.

---

### 4.2. While com Condição Complexa — de 100 até abaixo de 50

```sql
DECLARE @Valor INT = 100;

WHILE @Valor >= 50
BEGIN
    PRINT 'Valor atual: ' + CAST(@Valor AS VARCHAR(10));
    SET @Valor = @Valor - 5;
END

PRINT 'Loop encerrado. Valor final: ' + CAST(@Valor AS VARCHAR(10));
```

**Saída esperada:**

```
Valor atual: 100
Valor atual: 95
Valor atual: 90
Valor atual: 85
Valor atual: 80
Valor atual: 75
Valor atual: 70
Valor atual: 65
Valor atual: 60
Valor atual: 55
Valor atual: 50
Loop encerrado. Valor final: 45
```

**Explicação**

A condição é `@Valor >= 50`, e não `@Valor > 50`, porque o enunciado pede que o loop continue **até que o valor seja menor que 50** — ou seja, 50 ainda é um valor válido e deve ser processado. O loop encerra quando `@Valor` chega a 45.

A ordem entre exibir e subtrair muda o resultado. Aqui o `PRINT` vem **antes** da subtração, então a lista começa em 100 (o valor inicial) e termina em 50. Se a subtração viesse primeiro, a saída iria de 95 a 45 — igualmente defensável, mas exibiria um valor já abaixo do limite. Vale conferir qual das duas o enunciado da sua disciplina espera.

---

### 4.3. Exercício Prático — percorrer a tabela `Produtos`

**Preparação da tabela (execute uma vez):**

```sql
DROP TABLE IF EXISTS Produtos;

CREATE TABLE Produtos (
    ProdutoID INT IDENTITY(1,1) PRIMARY KEY,
    Nome      VARCHAR(100)  NOT NULL,
    Preco     DECIMAL(10,2) NOT NULL
);

INSERT INTO Produtos (Nome, Preco) VALUES
    ('Notebook',        2999.99),
    ('Mouse',             89.90),
    ('Teclado Mecânico',  349.00),
    ('Monitor 24"',      1250.00),
    ('Cabo HDMI',          35.50),
    ('Headset',           199.90);
```

**Resolução com `WHILE`, `@Indice` e `@PrecoLimite`:**

```sql
DECLARE @Indice      INT           = 1;
DECLARE @TotalLinhas INT;
DECLARE @PrecoLimite DECIMAL(10,2) = 100.00;
DECLARE @Nome        VARCHAR(100);
DECLARE @Preco       DECIMAL(10,2);

-- Numeração contínua de 1..N, independente de falhas na sequência de IDs
SELECT ROW_NUMBER() OVER (ORDER BY ProdutoID) AS Linha, Nome, Preco
INTO   #ProdutosNumerados
FROM   Produtos;

SELECT @TotalLinhas = COUNT(*) FROM #ProdutosNumerados;

PRINT 'Produtos com preço acima de R$ ' + CAST(@PrecoLimite AS VARCHAR(20)) + ':';
PRINT '------------------------------------------';

WHILE @Indice <= @TotalLinhas
BEGIN
    SELECT @Nome  = Nome,
           @Preco = Preco
    FROM   #ProdutosNumerados
    WHERE  Linha = @Indice;

    IF @Preco > @PrecoLimite
        PRINT @Nome + ' - R$ ' + CAST(@Preco AS VARCHAR(20));

    SET @Indice = @Indice + 1;
END

DROP TABLE #ProdutosNumerados;
```

**Saída esperada:**

```
Produtos com preço acima de R$ 100.00:
------------------------------------------
Notebook - R$ 2999.99
Teclado Mecânico - R$ 349.00
Monitor 24" - R$ 1250.00
Headset - R$ 199.90
```

**Explicação**

- **Por que a tabela temporária com `ROW_NUMBER()`?** Usar `WHERE ProdutoID = @Indice` direto na tabela parece mais simples, mas quebra assim que alguém apagar um produto: com os IDs 1, 2, 4, 5, o índice 3 não encontra linha nenhuma, `@Nome` e `@Preco` **mantêm o valor da iteração anterior** (o `SELECT` sem resultado não altera as variáveis) e o produto anterior é impresso duas vezes. `ROW_NUMBER()` garante 1..N sem buracos.
- **`SELECT @var = coluna`** atribui as duas variáveis em uma única leitura da tabela — com `SET` seriam dois comandos e duas leituras.
- **`#ProdutosNumerados`** com `#` é uma tabela temporária local: existe só na sessão atual e some ao fechar a conexão. O `DROP` explícito no fim evita erro se você reexecutar o script na mesma janela.

**A observação honesta sobre este exercício:** o loop aqui é didático. Em SQL de produção, o mesmo resultado sai em uma linha, e o banco resolve isso muito mais rápido:

```sql
DECLARE @PrecoLimite DECIMAL(10,2) = 100.00;

SELECT Nome, Preco
FROM   Produtos
WHERE  Preco > @PrecoLimite
ORDER  BY Preco DESC;
```

SQL é uma linguagem de conjuntos: percorrer linha a linha desperdiça o otimizador. Loops sobre tabelas só se justificam quando cada linha exige uma ação que não é expressável em conjunto — chamar um procedimento por linha, por exemplo, ou processar em lotes para não travar a tabela.

---

### 4.4. Loop While com Incremento Condicional — dobrar até passar de 1000

```sql
DECLARE @Numero INT = 2;

PRINT 'Valor inicial: ' + CAST(@Numero AS VARCHAR(10));

WHILE @Numero <= 1000
BEGIN
    SET @Numero = @Numero * 2;
    PRINT 'Valor dobrado: ' + CAST(@Numero AS VARCHAR(10));
END

PRINT 'Fim — o valor ultrapassou 1000.';
```

**Saída esperada:**

```
Valor inicial: 2
Valor dobrado: 4
Valor dobrado: 8
Valor dobrado: 16
Valor dobrado: 32
Valor dobrado: 64
Valor dobrado: 128
Valor dobrado: 256
Valor dobrado: 512
Valor dobrado: 1024
Fim — o valor ultrapassou 1000.
```

**Explicação**

A condição testada é `@Numero <= 1000`, então a última iteração começa com 512 (que ainda passa no teste), dobra para 1024 e sai. O valor final **1024 é maior que 1000** — exatamente o que o enunciado pede ("até que ele ultrapasse 1000"). Se a condição fosse `@Numero * 2 <= 1000`, o loop pararia em 512 e nunca ultrapassaria o limite.

**Cuidado com estouro de tipo:** progressão geométrica cresce rápido. `INT` vai até 2.147.483.647; se o limite do exercício fosse 10 bilhões, o script quebraria com

```
Msg 8115 — Arithmetic overflow error converting expression to data type int.
```

Nesse caso, declare `@Numero` como `BIGINT`.

---

## 5. Exercício de Integração — DESAFIO

### 5.1. Procedimento Armazenado `CalcularDesconto`

```sql
DROP PROCEDURE IF EXISTS CalcularDesconto;
GO

CREATE PROCEDURE CalcularDesconto
    @PrecoOriginal DECIMAL(10,2),          -- preço unitário do produto
    @Quantidade    INT,                    -- quantidade comprada
    @PrecoFinal    DECIMAL(10,2) OUTPUT    -- valor total já com desconto
AS
BEGIN
    SET NOCOUNT ON;

    -- Variáveis de trabalho
    DECLARE @PercentualDesconto DECIMAL(5,4) = 0;   -- 0.10 = 10%
    DECLARE @ValorBruto         DECIMAL(12,2);
    DECLARE @ValorDesconto      DECIMAL(12,2);
    DECLARE @UnidadeAtual       INT;

    SET @ValorBruto = @PrecoOriginal * @Quantidade;

    -- Regra de desconto
    IF @Quantidade > 10
    BEGIN
        -- Compra em volume: 10% fixos
        SET @PercentualDesconto = 0.10;
    END
    ELSE IF @Quantidade < 5
    BEGIN
        -- Desconto progressivo: 1% por unidade acima da primeira
        SET @UnidadeAtual = 2;

        WHILE @UnidadeAtual <= @Quantidade
        BEGIN
            SET @PercentualDesconto = @PercentualDesconto + 0.01;
            SET @UnidadeAtual = @UnidadeAtual + 1;
        END
    END
    ELSE
    BEGIN
        -- Entre 5 e 10 unidades: sem desconto
        SET @PercentualDesconto = 0;
    END

    SET @ValorDesconto = @ValorBruto * @PercentualDesconto;
    SET @PrecoFinal    = @ValorBruto - @ValorDesconto;

    -- Relatório da operação
    PRINT '--------------------------------------------';
    PRINT 'Preço unitário..: R$ ' + CAST(@PrecoOriginal AS VARCHAR(20));
    PRINT 'Quantidade......: '    + CAST(@Quantidade AS VARCHAR(10));
    PRINT 'Valor bruto.....: R$ ' + CAST(@ValorBruto AS VARCHAR(20));
    PRINT 'Desconto........: '    + CAST(@PercentualDesconto * 100 AS VARCHAR(10)) + '%';
    PRINT 'Valor desconto..: R$ ' + CAST(@ValorDesconto AS VARCHAR(20));
    PRINT 'PREÇO FINAL.....: R$ ' + CAST(@PrecoFinal AS VARCHAR(20));
    PRINT '--------------------------------------------';
END
GO
```

**Como executar:**

```sql
DECLARE @Resultado DECIMAL(10,2);

-- Caso 1: quantidade > 10 → 10% de desconto
EXEC CalcularDesconto @PrecoOriginal = 200.00, @Quantidade = 12, @PrecoFinal = @Resultado OUTPUT;
SELECT @Resultado AS PrecoFinal_12unidades;

-- Caso 2: quantidade < 5 → desconto progressivo pelo loop
EXEC CalcularDesconto @PrecoOriginal = 200.00, @Quantidade = 3,  @PrecoFinal = @Resultado OUTPUT;
SELECT @Resultado AS PrecoFinal_3unidades;

-- Caso 3: entre 5 e 10 → sem desconto
EXEC CalcularDesconto @PrecoOriginal = 200.00, @Quantidade = 7,  @PrecoFinal = @Resultado OUTPUT;
SELECT @Resultado AS PrecoFinal_7unidades;

-- Caso 4: unidade única → loop não executa
EXEC CalcularDesconto @PrecoOriginal = 200.00, @Quantidade = 1,  @PrecoFinal = @Resultado OUTPUT;
SELECT @Resultado AS PrecoFinal_1unidade;
```

**Tabela de conferência dos resultados:**

| Quantidade | Regra aplicada          | Valor bruto | Desconto | Preço final |
|------------|-------------------------|-------------|----------|-------------|
| 12         | > 10 → 10% fixos        | 2400.00     | 10%      | **2160.00** |
| 3          | < 5 → loop: 2 unidades acima da 1ª → 2% | 600.00 | 2% | **588.00** |
| 7          | entre 5 e 10 → sem desconto | 1400.00 | 0%       | **1400.00** |
| 1          | < 5, mas loop não roda  | 200.00      | 0%       | **200.00**  |

**Saída esperada — aba Messages (caso 2):**

```
--------------------------------------------
Preço unitário..: R$ 200.00
Quantidade......: 3
Valor bruto.....: R$ 600.00
Desconto........: 2.0000%
Valor desconto..: R$ 12.00
PREÇO FINAL.....: R$ 588.00
--------------------------------------------
```

**Explicação das decisões de projeto**

**Por que `OUTPUT` e não `RETURN`.** O `RETURN` de um procedimento armazenado só devolve `INT` — é feito para códigos de status (0 = sucesso), não para valores de negócio. Um preço com centavos precisa sair por um parâmetro `OUTPUT` (ou por um `SELECT` final, se você preferir devolver uma grade de resultados). Tentar `RETURN @PrecoFinal` truncaria 588.00 para 588.

**Por que o loop começa em 2.** O enunciado pede 1% "por unidade **acima de 1**". Com `@UnidadeAtual = 2` e a condição `<= @Quantidade`, o loop roda para as unidades 2 e 3 quando a quantidade é 3 — duas iterações, 2%. Para quantidade 1, a condição `2 <= 1` já falha na entrada e o desconto fica em zero, sem nenhuma iteração. É exatamente o comportamento correto, e é o caso de borda que costuma ser esquecido.

**Por que o `ELSE` explícito com zero.** `@PercentualDesconto` já nasce zerado no `DECLARE`, então o ramo `ELSE` é tecnicamente redundante. Ele está ali porque torna a regra de negócio legível: quem lê o código vê os três cenários enunciados, sem precisar deduzir o terceiro por ausência.

**Por que `DECIMAL(5,4)` no percentual.** Precisa comportar valores como `0.1000` e `0.0400` — quatro casas decimais. Um `DECIMAL(5,2)` arredondaria `0.01` de forma grosseira, e um `INT` não guardaria fração nenhuma.

**Por que `DECIMAL(12,2)` no valor bruto.** `@PrecoOriginal * @Quantidade` pode ultrapassar a faixa do `DECIMAL(10,2)` em compras grandes. Dar folga nas variáveis intermediárias evita o erro de estouro aritmético que só apareceria em produção, com o pedido de um cliente grande.

**A ordem do `IF` importa.** `IF @Quantidade > 10` vem primeiro; só depois `ELSE IF @Quantidade < 5`. Como as faixas não se sobrepõem, a ordem entre essas duas é indiferente neste caso — mas manter o encadeamento `IF / ELSE IF / ELSE` garante que **exatamente um** ramo execute. Se fossem três `IF` independentes, uma futura alteração nas faixas poderia fazer dois descontos se acumularem.

**Uma variante a considerar.** Este procedimento devolve o **valor total** da compra (preço × quantidade, com desconto). Se a sua disciplina esperar o **preço unitário** com desconto, a única mudança é a última atribuição:

```sql
SET @PrecoFinal = @PrecoOriginal - (@PrecoOriginal * @PercentualDesconto);
```

Confira o enunciado antes de entregar — "retorne o preço final após o desconto" comporta as duas leituras.

---

## Resumo dos conceitos

| Conceito | Ponto‑chave para não errar |
|---|---|
| `DECLARE VARCHAR` | Sem tamanho explícito, o padrão é `VARCHAR(1)` — trunca em silêncio |
| `DECIMAL(p,s)` | `p` = total de dígitos, `s` = casas decimais. É o tipo para dinheiro; `FLOAT` não é |
| `PRINT` + número | Exige `CAST(... AS VARCHAR)` ao concatenar, ou use `CONCAT` |
| `PRINT` vs `SELECT` | `PRINT` → aba Messages, para depurar. `SELECT` → aba Results, é um resultado de verdade |
| `CAST` vs `CONVERT` | `CAST` é ANSI‑padrão; `CONVERT` aceita *style* e é obrigatório para formatar datas |
| Conversão para `INT` | **Trunca**, não arredonda. Use `ROUND` antes se quiser arredondar |
| String → data | Sempre com *style* (`103` = dd/mm/yyyy). Sem ele, o resultado depende do idioma do servidor |
| `IF` com vários comandos | Obrigatório `BEGIN ... END`; indentação não delimita bloco |
| `IF` encadeado | Ordene do caso mais restritivo ao mais amplo e as condições ficam simples |
| Ano bissexto | Teste sempre 1900 (comum) e 2000 (bissexto), não só 2024 e 2023 |
| `WHILE` | Inicializar, testar, **incrementar dentro do bloco** — a terceira é a que causa loop infinito |
| Loop sobre tabela | Didático; em produção prefira `WHERE`. SQL trabalha com conjuntos |
| Procedimento com valor | `RETURN` só devolve `INT`; para decimais use parâmetro `OUTPUT` |
