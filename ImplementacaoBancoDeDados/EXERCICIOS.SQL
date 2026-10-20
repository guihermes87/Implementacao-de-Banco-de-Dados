

DECLARE 
@NomeProduto  VARCHAR(50),
@QuantidadeEstoque  INT,
@PrecoProduto DECIMAL(10,2);

SET @NomeProduto       = 'Notebook';
SET @QuantidadeEstoque = 15;
SET @PrecoProduto      = 2999.99;


PRINT 'Nome do Produto......: ' + @NomeProduto;
PRINT 'Quantidade em Estoque: ' + CAST(@QuantidadeEstoque AS VARCHAR(10));
PRINT 'Preço do Produto.....: ' + CAST(@PrecoProduto AS VARCHAR(20));


SELECT @NomeProduto       AS NomeProduto,
    @QuantidadeEstoque AS QuantidadeEstoque,
    @PrecoProduto      AS PrecoProduto;

     
GO

--- 1.4

DECLARE @SalarioBase  DECIMAL(10,2),
        @Bonus        DECIMAL(10,2),
        @SalarioTotal DECIMAL(10,2);

SET @SalarioBase = 5000.00;
SET @Bonus       = 800.00;

SET @SalarioTotal = @SalarioBase + @Bonus;

PRINT 'Salário Base..: ' + CAST(@SalarioBase  AS VARCHAR(20));
PRINT 'Bônus.........: ' + CAST(@Bonus        AS VARCHAR(20));
PRINT 'Salário Total.: ' + CAST(@SalarioTotal AS VARCHAR(20));

SELECT @SalarioBase  AS SalarioBase,
    @Bonus        AS Bonus,
    @SalarioTotal AS SalarioTotal;

GO


-- 2.1

SELECT CAST(GETDATE() AS VARCHAR(10)) AS DataComoTexto;
SELECT CONVERT(VARCHAR(10), GETDATE(), 103) AS Formato103;

PRINT 'CAST  para VARCHAR(10) : ' + CAST(GETDATE() AS VARCHAR(10));
PRINT 'CONVERT style 103      : ' + CONVERT(VARCHAR(10), GETDATE(), 103);

GO


SELECT CONVERT(INT, 12345.67) AS ValorConvertido;
SELECT CONVERT(INT, ROUND(12345.67, 0)) AS ValorArredondado;
SELECT CONVERT(INT, CONVERT(DECIMAL(10,2), '12345.67')) AS TextoParaInt;

PRINT 'CONVERT p/ INT.: ' + CAST(CONVERT(INT, 12345.67) AS VARCHAR(10));
PRINT 'Com ROUND antes: ' + CAST(CONVERT(INT, ROUND(12345.67, 0)) AS VARCHAR(10));
PRINT 'Texto p/ INT...: ' + CAST(CONVERT(INT, CONVERT(DECIMAL(10,2), '12345.67')) AS VARCHAR(10));

GO


-- 2.4

DECLARE 

@DataNascimento VARCHAR(10) = '15/08/1990';

SELECT CONVERT(DATE, @DataNascimento, 103) AS DataNascimentoConvertida;

PRINT 'CONVERT 103: ' + CAST(CONVERT(DATE, @DataNascimento, 103) AS VARCHAR(10));


-- 3.1
DECLARE 

@Idade INT = 20;

IF @Idade >= 18
    PRINT 'Maior de Idade';
ELSE
    PRINT 'Menor de Idade';

--3.2                                         */

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

GO


DECLARE @NotaFinal DECIMAL(5,2) = 85.00;

IF @NotaFinal >= 90
    PRINT 'Aprovado com Excelência';
ELSE IF @NotaFinal >= 70
    PRINT 'Aprovado';
ELSE IF @NotaFinal >= 50
    PRINT 'Em Recuperação';
ELSE
    PRINT 'Reprovado';


SELECT CASE
           WHEN @NotaFinal >= 90 THEN 'Aprovado com Excelência'
           WHEN @NotaFinal >= 70 THEN 'Aprovado'
           WHEN @NotaFinal >= 50 THEN 'Em Recuperação'
           ELSE 'Reprovado'
       END AS Situacao;

GO


