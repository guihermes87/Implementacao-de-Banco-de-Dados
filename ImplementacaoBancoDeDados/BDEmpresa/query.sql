use EMPRESA;

-- ### SELECT DISTINCT
SELECT DISTINCT F.Pnome, F.Unome, F.Salario 
FROM FUNCIONARIO AS F 
WHERE F.Salario > 5000

-- ### Cláusula WHERE
-- 2. Recupere todas as informações do(s) funcionário(s) com primeiro nome "João".
SELECT * 
FROM FUNCIONARIO AS F
WHERE F.Pnome = 'João' OR F.Pnome = 'Pedro'

-- ### AND
--3. Liste os funcionários do sexo masculino com salário maior ou igual a R$ 30.000,00.
SELECT *
FROM FUNCIONARIO AS F
WHERE f.Sexo = 'M' and f.Salario = 30000

-- ### OR
-- 4. Liste os funcionários que moram em São Paulo ou em Curitiba.

SELECT *
FROM FUNCIONARIO AS F
WHERE F.Endereco LIKE '%São Paulo%' OR F.Endereco LIKE '%Curitiba%'

-- ### NOT
-- 5. Liste os funcionários que não moram em São Paulo.
SELECT * 
FROM FUNCIONARIO AS F 
WHERE NOT F.Endereco LIKE '%São Paulo%'

-- ### ORDER BY
-- 6. Preciso cortar orçamento: liste os funcionários em ordem decrescente de salário.

SELECT * 
FROM FUNCIONARIO AS F 
ORDER BY F.Salario DESC

-- ### IS NULL
-- 7. Encontre os funcionários que não possuem supervisor (`Cpf_supervisor`).

SELECT * 
FROM FUNCIONARIO AS F 
WHERE F.Cpf_supervisor IS NOT NULL

-- ### SELECT TOP / LIMIT
-- 9. Recupere o registro dos 3 funcionários que têm o maior salário.

SELECT TOP 10 F.Salario  
FROM FUNCIONARIO AS F
WHERE F.Salario < 30000

-- ### MIN()
-- 10. Recupere as informações do funcionário com o menor salário.
SELECT * 
FROM FUNCIONARIO AS F
WHERE F.Salario = (SELECT MIN(F.Salario) FROM FUNCIONARIO AS F)


-- ### MAX()
-- 11. Recupere as informações do funcionário com o maior salário.

SELECT *
FROM FUNCIONARIO AS f
WHERE f.salario = (SELECT MAX(F.salario) from funcionario as f)

-- ### COUNT()
-- 12. Quantos funcionários possuímos cadastrados no banco?
SELECT COUNT(f.salario) 
FROM FUNCIONARIO AS f
where F.salario < 100000 

-- ### AVG()
-- 13. Qual é a média salarial dos meus funcionários?
GO

DECLARE @media DECIMAL(10,2);

SELECT @media = AVG(Salario)
FROM FUNCIONARIO;

SELECT *
FROM FUNCIONARIO
WHERE Salario > @media;


GO

-- ### SUM()
-- 14. Qual é o meu custo mensal com folha de pagamento dos funcionários?

SELECT SUM(Salario) AS CustoMensal
FROM FUNCIONARIO;


-- ### LIKE
-- 15. Recupere o(s) funcionário(s) nascido(s) no ano de 72.
USE EMPRESA


SELECT * FROM FUNCIONARIO AS F WHERE F.DataNasc LIKE '%72%'

-- ### IN (lista de valores)
-- 16. Recupere as informações dos funcionários que recebem R$ 25.000 e R$ 30.000.

SELECT *
FROM FUNCIONARIO AS f
WHERE F.Salario IN (25000, 30000)

-- ### IN (subconsulta)
-- 17. Recupere os registros dos funcionários que trabalham (`TRABALHA_EM`) no mesmo projeto e na mesma quantidade de horas do "Fernando" (`Fcpf = '33344555587'`).

SELECT f.Pnome, t.Pnr
 FROM TRABALHA_EM AS T, FUNCIONARIO as F
 WHERE 
 F.Cpf = T.Fcpf and T.Pnr in (SELECT Pnr from TRABALHA_EM  where Fcpf = (SELECT Cpf FROM FUNCIONARIO as f WHERE f.Pnome = 'Fernando')); 


-- ### BETWEEN
-- 18. Recuperar todos os funcionários do departamento 5 cujo salário esteja entre R$ 30.000 e R$ 40.000.


SELECT *
FROM FUNCIONARIO AS f
JOIN DEPARTAMENTO AS D ON D.Dnumero = F.Dnr
WHERE F.Dnr = 5 AND F.Salario BETWEEN 30000 AND 40000

-- ### Alias de coluna
-- 19. Recupere `Pnome` como **Nome** e `Unome` como **Sobrenome** da tabela `Funcionario`.

SELECT F.Pnome AS Nome, F.Unome AS Sobrenome
FROM FUNCIONARIO AS F;

-- ### Alias de tabela
-- 20. Recupere o nome de todos os funcionários que fazem parte do departamento de "Pesquisa".

SELECT F.Pnome, F.Unome
FROM FUNCIONARIO AS F
JOIN DEPARTAMENTO AS D ON D.Dnumero = F.Dnr
WHERE D.Dnome = 'Pesquisa';

-- ### INNER JOIN
-- 1. Selecionar o primeiro nome, último nome e endereço dos funcionários que trabalham no departamento de "Pesquisa".
-- 2. Liste o nome dos funcionários que estão desenvolvendo o "ProdutoX".
-- 3. Para cada projeto localizado em "Mauá", liste o número do projeto, o número do departamento que o controla e o sobrenome, endereço e data de nascimento do gerente do departamento.

select f.Pnome, f.Unome, f.Endereco, d.Dnome AS 'Departamento'
from funcionario as f join departamento as d on D.Dnumero = F.dnr
where D.dnome = 'Pesquisa' and F.Pnome = 'João'


SELECT *
FROM FUNCIONARIO F
JOIN PROJETO P ON F.Dnr = P.Dnum
WHERE P.Projnome = 'ProdutoX';

-- ### LEFT JOIN
-- 4. Liste o último nome de TODOS os funcionários e os seus respectivos departamentos, caso possuam.
-- 5. Encontre os funcionários que **não** possuem um departamento vinculado.
--    - *Preparação:* inserir 3 novos departamentos e 3 novos funcionários sem departamento.
-- 6. Encontre os departamentos que **não** possuem funcionários vinculados.
--    - *Preparação:* inserir 3 novos departamentos e 3 novos funcionários sem departamento.

select f.Unome, f.Dnr, d.dnome 
from funcionario as f
join departamento as d 
on f.dnr = d.dnumero
where f.dnr is null;

-- ### RIGHT JOIN
-- 7. Encontre os departamentos que não possuem nenhum funcionário.

select d.Dnome, f.Unome
from departamento as d
right join funcionario as f
on d.Dnumero = f.Dnr
where d.Dnumero is null;

-- ### CROSS JOIN
-- 8. Teste o CROSS JOIN entre as relações `Funcionario` e `Departamento`.

select f.Unome, d.Dnome
from funcionario as f
cross join departamento as d;

-- ### SELF JOIN
-- 9. Crie uma consulta que mostra apenas os funcionários que têm um supervisor.

SELECT * FROM FUNCIONARIO AS F WHERE F.Cpf_supervisor IS NOT NULL;


-- ### UNION
-- 10. Listar todos os nomes, sexo e data de nascimento de todas as pessoas do banco.

SELECT f.Pnome, f.Sexo, f.Datanasc
FROM FUNCIONARIO AS f
UNION ALL
SELECT d.Nome_dependente, null, null
FROM DEPENDENTE AS D;

-- 11. A diretoria quer uma lista de todas as cidades onde a empresa possui alguma atividade, seja a localização de um departamento ou a localização de um projeto.

SELECT Dlocal AS Cidade
FROM LOCALIZACAO_DEP
UNION
SELECT Projlocal
FROM PROJETO
ORDER BY Cidade;

-- ### UNION ALL
-- 12. Mesma consulta anterior (cidades com atividade da empresa), agora permitindo valores duplicados.

-- ### EXCEPT
-- 13. Listar os CPFs dos funcionários que não são gerentes de nenhum departamento.

SELECT Cpf
FROM FUNCIONARIO
EXCEPT
SELECT Cpf_gerente
FROM DEPARTAMENTO
ORDER BY Cpf;

SELECT Cpf
FROM FUNCIONARIO
WHERE Cpf NOT IN (
    SELECT Cpf_gerente FROM DEPARTAMENTO WHERE Cpf_gerente IS NOT NULL
);

-- 14. Encontre os funcionários que **NÃO** são supervisores.

SELECT * 
FROM FUNCIONARIO AS F
JOIN FUNCIONARIO AS F1 ON F.Cpf = F.Cpf_supervisor
WHERE f.Cpf= f.Cpf_supervisor

SELECT F1.Pnome as 'Funcionário', f2.Pnome as 'Supervisor'
IIF(F.Cpf_supervisor IS NULL)
FROM FUNCIONARIO AS F1
JOIN FUNCIONARIO AS F2 ON f1.Cpf_supervisor = f2.Cpf



-- ### INTERSECT
-- 15. Encontre os funcionários que **são** supervisores.
SELECT Cpf
FROM FUNCIONARIO
INTERSECT
SELECT Cpf_gerente
FROM DEPARTAMENTO
ORDER BY Cpf;


-- ### GROUP BY
-- 16. Quantidade de funcionários por sexo.
    SELECT COUNT(Sexo) from FUNCIONARIO 
    GROUP by sexo
-- 17. Contar o número de funcionários por departamento.
SELECT Dnr AS Departamento, COUNT(*) AS Qtd_Funcionarios
FROM FUNCIONARIO
GROUP BY Dnr
ORDER BY Dnr;

SELECT D.Dnome, COUNT(F.Cpf) AS Qtd_Funcionarios
FROM DEPARTAMENTO AS D
JOIN FUNCIONARIO AS F ON F.Dnr = D.Dnumero
GROUP BY D.Dnumero, D.Dnome
ORDER BY D.Dnumero;
-- 18. Somar os salários por departamento.

SELECT D.Dnome, sum(f.salario)
FROM DEPARTAMENTO AS D JOIN FUNCIONARIO AS F ON F.Dnr = D.Dnumero
GROUP BY d.Dnome

-- 19. Média de horas trabalhadas por projeto.


Select P.Projnome , AVG(t.horas) from projeto as p join TRABALHA_EM as T on T.Pnr = P.Projnumero
GROUP BY P.Projnome

-- 20. Maior salário em cada departamento.

SELECT D.Dnome, MAX(F.salario) from DEPARTAMENTO as d join FUNCIONARIO as F on D.Dnumero = f.Dnr
GROUP BY f.Pnome, D.Dnome
-- 21. Número de projetos em cada local.

SELECT P.Projlocal, COUNT(P.Projnome) from projeto as P
GROUP BY P.Projlocal

-- ### HAVING
-- 22. Encontrar departamentos com mais de 3 funcionários.
SELECT D.dnome, COUNT(f.Cpf) from FUNCIONARIO as f join DEPARTAMENTO as D on F.Dnr = D.Dnumero
GROUP BY(D.Dnome)
HAVING count (f.Cpf) > 3

-- 23. Listar projetos que exigem no mínimo 50 horas de trabalho no total.

SELECT p.Projnome, sum(t.horas) from projeto as p join TRABALHA_EM as t on P.Projnumero = t.Pnr
GROUP BY(P.Projnome)
having sum(t.Horas) > 50

-- ### EXISTS
-- 24. Listar funcionários que são gerentes de algum departamento.
USE EMPRESA
SELECT f.*
FROM FUNCIONARIO AS f
WHERE EXISTS (
    SELECT *
    FROM DEPARTAMENTO AS d
    WHERE d.Cpf_gerente = f.Cpf
);

-- 25. Listar departamentos que possuem projetos associados.

-- 25. Listar departamentos que possuem projetos associados.
SELECT d.*
FROM DEPARTAMENTO AS d
WHERE EXISTS (
    SELECT 1
    FROM PROJETO AS p
    WHERE p.Dnum = d.Dnumero
);

-- ### ANY
-- 26. Encontrar funcionários que ganham mais do que qualquer funcionário do departamento de "Administração".

SELECT f.*
FROM FUNCIONARIO AS f
WHERE f.Salario > ANY (
    SELECT f2.Salario
    FROM FUNCIONARIO AS f2
    JOIN DEPARTAMENTO AS d ON f2.Dnr = d.Dnumero
    WHERE d.Dnome = 'Administração'
);

-- ### ALL
-- 27. Encontrar projetos que exigem mais horas do que todos os projetos no local "Itu".

SELECT p.Projnumero, p.Projnome, SUM(t.Horas) AS Total_horas
FROM PROJETO AS p
JOIN TRABALHA_EM AS t ON t.Pnr = p.Projnumero
GROUP BY p.Projnumero, p.Projnome
HAVING SUM(t.Horas) > ALL (
    SELECT SUM(t2.Horas)
    FROM PROJETO AS p2
    JOIN TRABALHA_EM AS t2 ON t2.Pnr = p2.Projnumero
    WHERE p2.Projlocal = 'Itu'
    GROUP BY p2.Projnumero
);

-- ---

-- ## Aula 04 — Variáveis, Conversões, IF/ELSE e WHILE

-- ### Atribuição de valor com SELECT
-- 1. Recupere o nome do departamento com `Dnumero = 4` (armazenando em variável).

DECLARE 
@nome as VARCHAR(30);

SELECT @nome = Dnome
from DEPARTAMENTO as d where D.Dnumero = 4
PRINT @nome

-- ### Exemplos com cálculo
-- 2. Calcular o novo salário da Jennifer com um aumento de 10%.
GO
DECLARE

@nome VARCHAR(50),
@salario decimal(10,2),
@novosalario decimal(10,2)

set @nome = 'Jennifer'
SELECT @salario = f.salario from funcionario as F
where (f.Pnome = @nome)

set @novosalario = @salario *1.10

PRINT 'Salário de ' + @nome + ' atualizado = ' + cast(@novosalario as VARCHAR(20))
GO

-- 3. Calcular a idade da Jennifer.
--    - *Dica:* usar `YEAR(GETDATE())` ou `DATEDIFF(intervalo, data_inicial, data_final)`.

DECLARE @Pnome as varchar(100),
        @datanascimento date,
        @ano_atual int,
        @ano_nascimento int,
        @idade int;

SET @Pnome = 'Jennnifer'
        set @ano_atual = year(getdate()) - year(@datanascimento);
        SELECT @ano_nascimento = YEAR(Datanasc) from FUNCIONARIO as f where @Pnome = F.Pnome;

       SET @idade = DATEDIFF(YEAR,@datanascimento,GETDATE());

       PRINT cast(@idade as varchar(20))

GO

    DECLARE @Pnome as varchar(100),
        @salario as DECIMAL(10,2),
        @datanascimento date,
        @salariomedio as decimal(10,2);

        SET @Pnome = 'Ana';
       
        SET @salario = avg(F.salario) from FUNCIONARIO as F
        
        SElect @salario = Salario from funcionario as f where @Pnome = Pnome;

        IF(@salario<@salariomedio)
        PRINT 'O funcionário(a) ' + @pnome + ' recebe abaixo da média';
        ELSE
        PRINT 
        'O funcionário ' + @pnome +' recebe acima da média';


-- ### CAST
-- 4. Usando `CAST`, converter o salário decimal em string, resultando em:
--    `O funcionário(a) Jennifer tem um salário de : R$ 43000.`

-- ### CONVERT
-- 5. Usando `CONVERT`, converter o salário decimal em string, resultando em:
--    `O funcionário(a) Jennifer tem um salário de : R$ 43000.`
-- 6. Converter a data de nascimento da Jennifer para o padrão brasileiro: `dd/mm/aaaa`.

-- ### IF / ELSE
-- 7. Verificar se um funcionário recebe abaixo da média salarial.
-- 8. Verificar se um funcionário está próximo da aposentadoria (considerar 60 anos como idade de aposentadoria).
-- 9. Verificar se um funcionário já recebeu bônus este ano.
select f.Pnome, f.unome, f.Salario,
CASE 
WHEN f.salario <= 10000  AND F.SALARIO > 0 THEN 'Baixo'
WHEN F.salario > 10000 and f.salario <=30000 then 'Médio'
WHEN F.Salario > 20000 THEN 'Alto'
ELSE 'Erro'
END as 'Categoria'
from funcionario as f
-- 10. Verificar se o funcionário é um novo contratado (últimos 6 meses).
--     - *Dica:* `DATEDIFF(intervalo, data_inicial, data_final)` — intervalo: `DAY`, `MONTH`, `YEAR`.
-- 11. Verificar o tamanho de um departamento: até 1 funcionário → "pequeno"; de 2 a 3 → "médio"; mais de 3 → "grande".
-- 11. Verificar o tamanho de um departamento: até 1 funcionário → "pequeno"; de 2 a 3 → "médio"; mais de 3 → "grande".
SELECT d.Dnumero,
       d.Dnome,
       COUNT(f.Cpf) AS Qtd_funcionarios,
       CASE
           WHEN COUNT(f.Cpf) <= 1 THEN 'pequeno'
           WHEN COUNT(f.Cpf) <= 3 THEN 'médio'
           ELSE 'grande'
       END AS Tamanho
FROM DEPARTAMENTO AS d
LEFT JOIN FUNCIONARIO AS f ON f.Dnr = d.Dnumero
GROUP BY d.Dnumero, d.Dnome;

-- ### WHILE
-- 12. Aumentar o salário da "Joice Leite" em 5% repetidamente até que ele chegue em R$ 30.000.
GO
DECLARE
@nome varchar(50),
@salario DECIMAL(10,2)
set @nome = 'Joice Leite'
SELECT @salario = f.Salario FROM FUNCIONARIO AS F WHERE @nome = F.Pnome
WHILE @salario <=3000
BEGIN
 SET @salario* 1.5;
 PRINT CAST(@salario as VARCHAR(30))
 END

GO
DECLARE @salario DECIMAL(10,2);

SELECT @salario = Salario
FROM FUNCIONARIO
WHERE Pnome = 'Joice' AND Unome = 'Leite';

WHILE @salario < 30000
BEGIN
    SET @salario = @salario * 1.05;
    PRINT 'Novo salário: ' + CAST(@salario AS VARCHAR(30));
END

UPDATE FUNCIONARIO
SET Salario = @salario
WHERE Pnome = 'Joice' AND Unome = 'Leite';

x-- Crie uma função fn_ProjetosPorFuncionario que receba o Cpf de um funcionário e retorne os nomes dos 
-- projetos nos quais ele trabalha (usando a tabela TRABALHA_EM). 

CREATE FUNCTION fn_ProjetosPorFuncionario(@cpf varchar(11))
RETURNS TABLE
AS
RETURN (
SELECT P.* 
FROM PROJETO P
JOIN TRABALHA_EM T ON P.Projnumero = T.Pnr
WHERE T.Fcpf = @cpf
)

GO

SELECT *
FROM dbo.fn_ProjetosPorFuncionario('12345678966');

GO


-- Crie uma função fn_ListarDependentes que receba o Cpf de um funcionário e retorne 
-- uma tabela com os nomes e parentescos de todos os seus dependentes. 

CREATE FUNCTION fn_ListarDependentes(@cpf varchar(11))
RETURNS TABLE
AS
RETURN (
SELECT f.Cpf, F.Pnome, F.Unome, D.Nome_dependente, D.Parentesco 
FROM DEPENDENTE D
JOIN FUNCIONARIO F ON F.Cpf = D.Fcpf
WHERE D.Fcpf = @cpf
)

GO

SELECT *
FROM dbo.fn_ListarDependentes('12345678966')

GO

SELECT *
FROM dbo.fn_ProjetosPorFuncionario('12345678966');


GO

-- Crie uma função fn_NomeSupervisor que receba o Cpf de um funcionário e 
--retorne o nome completo do seu supervisor (usando a coluna Cpf_supervisor da tabela FUNCIONARIO). 

CREATE FUNCTION dbo.fn_NomeSupervisor (@cpf CHAR(11))
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @nome VARCHAR(100);
    SELECT @nome = CONCAT(S.Pnome, ' ', S.Unome)
    FROM   FUNCIONARIO AS F
    JOIN   FUNCIONARIO AS S ON S.Cpf = F.Cpf_supervisor
    WHERE  F.Cpf = @cpf;
    RETURN @nome;
END
GO

SELECT dbo.fn_NomeSupervisor('12345678966') as 'Supervisor';

GO

-- Crie uma função fn_GanhaMaisQueSupervisor que receba o Cpf de um funcionário e retorne 1 (verdadeiro) 
--se o salário dele for maior que o salário de seu supervisor, ou 0 (falso) caso contrário. 

CREATE FUNCTION dbo.fn_GanhaMaisQueSupervisor (@cpf VARCHAR(11))
RETURNS INT
AS
BEGIN
    DECLARE @salFuncionario DECIMAL(10,2),
            @salSuperior  DECIMAL(10,2);

    SELECT @salFuncionario = F.Salario,
           @salSuperior  = S.Salario
    FROM FUNCIONARIO AS F
    JOIN FUNCIONARIO AS S ON S.Cpf = F.Cpf_supervisor
    WHERE F.Cpf = @cpf;

    IF @salFuncionario > @salSuperior
      
        RETURN 1;

    RETURN 0;
END;

GO

SELECT dbo.fn_GanhaMaisQueSupervisor('12345678966') as 'Salário é maior que supervisor?'

GO

-- Crie uma função fn_AnoAposentadoria que receba a data de nascimento de um funcionário e retorne o ano 
-- em que ele poderá se aposentar, considerando 65 anos como idade de aposentadoria.

CREATE FUNCTION dbo.fn_AnoAposentadoria (@datanasc DATE)
RETURNS INT
AS
BEGIN
    DECLARE @anoAposentadoria INT;  
    SET @anoAposentadoria = YEAR(@datanasc) + 65;
    RETURN @anoAposentadoria;
END

GO

SELECT dbo.fn_AnoAposentadoria('1980-01-01') AS 'Ano de Aposentadoria';

