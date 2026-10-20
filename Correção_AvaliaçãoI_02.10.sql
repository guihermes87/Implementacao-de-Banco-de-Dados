-- 7
GO
SELECT
		A.Nome AS 'Nome do Aluno',
		H.Nota,
		T.Semestre,
		T.Ano AS 'Ano da Turma',
		D.Nome_disciplina
FROM ALUNO AS A
JOIN HISTORICO_ESCOLAR AS H ON A.Numero_aluno = H.Numero_aluno
JOIN TURMA AS T ON H.Identificacao_turma = T.Identificacao_turma
JOIN DISCIPLINA AS D ON T.Numero_disciplina = D.Numero_disciplina
WHERE D.Nome_disciplina = 'Banco de Dados I';
GO


--- 8
SELECT
		A.Nome,
		D.Nome_disciplina,
		D.Numero_disciplina,
		T.Semestre,
		T.Ano,
		H.Nota,
		H.Frequencia
FROM ALUNO AS A
JOIN HISTORICO_ESCOLAR AS H ON A.Numero_aluno = H.Numero_aluno
JOIN TURMA AS T ON H.Identificacao_turma = T.Identificacao_turma
JOIN DISCIPLINA AS D ON T.Numero_disciplina = D.Numero_disciplina
WHERE H.Frequencia < 75.0;

---9
SELECT T.Identificacao_turma,D.Nome_disciplina,T.Semestre,T.Ano,COUNT(H.Numero_aluno) AS 'Qtde de alunos'
FROM TURMA AS T
LEFT JOIN HISTORICO_ESCOLAR AS H ON T.Identificacao_turma = H.Identificacao_turma
JOIN DISCIPLINA AS D ON D.Numero_disciplina = T.Numero_disciplina
GROUP BY T.Identificacao_turma,D.Nome_disciplina,T.Semestre,T.Ano
GO

---10: PEGUEI A QUESTÃO QUE EU DESENVOLVI E REMOVI O SELECT QUE TINHA COLOCADO ABAIXO DO DECLARE,
-- POIS NÃO É NECESSÁRIO JÁ QUE FAÇO UM SELECT
GO
CREATE OR ALTER FUNCTION fn_SituacaoAluno (@nota DECIMAL(4,2),@frequencia DECIMAL (5,2))
RETURNS VARCHAR(200)
AS 
BEGIN
		DECLARE @situacao VARCHAR(200);
		
	
		
	IF ((@nota >= 7) AND (@frequencia >= 75.0))
		BEGIN
			SET @situacao = 'Aprovado'
		END
	

	ELSE IF ((@frequencia < 75.0) and (@nota >= 7))
		BEGIN
			SET @situacao = 'Reprovado por frequência'
		END

	ELSE IF(@nota IS  NULL OR @frequencia IS NULL)
		BEGIN
			SET @situacao = 'Em Andamento'
		END

	ELSE IF (@frequencia >= 75.0 AND (@nota BETWEEN 5 AND 6.99))
		BEGIN
			SET @situacao = 'Em Recuperação'
		END

	ELSE IF ((@frequencia >= 75.0) AND (@nota < 5))
		BEGIN
			SET @situacao = 'Reprovado por nota'
		END

	RETURN @situacao;
END;
GO
GO
SELECT 
		A.Nome,
		T.Numero_disciplina,
		H.Nota,
		H.Frequencia,
		dbo.fn_SituacaoAluno(H.Nota,H.Frequencia) AS 'Situação'
FROM HISTORICO_ESCOLAR AS H
JOIN ALUNO AS A ON A.Numero_aluno = H.Numero_aluno
JOIN TURMA AS T ON H.Identificacao_turma = T.Identificacao_turma



GO
---11
GO
CREATE OR ALTER FUNCTION fn_ConverterNotaConceito(@nota DECIMAL(4,2))
RETURNS VARCHAR(50)
BEGIN
		DECLARE @conceito AS VARCHAR(50),@numero DECIMAL(4,2);
		SET @numero = @nota;
		
		IF(@nota >= 9)
		BEGIN
		SET @conceito = 'A'
		END
		ELSE IF (@nota >=7)
		BEGIN
		SET @conceito = 'B'
		END
		ELSE IF (@nota>= 5 )
		BEGIN
		SET @conceito = 'C'
		END
		ELSE IF (@nota < 5)
		BEGIN
			SET @conceito = 'D'
		END
		ELSE IF (@nota IS NULL)
		BEGIN
			set @conceito = 'Sem Nota'
		END
	RETURN @conceito;
END;
GO
GO
SELECT dbo.fn_ConverterNotaConceito(4.5) as 'Conceito da Nota';
-- COLOCANDO OS CONCEITOS
SELECT 
		A.Nome,
		D.Nome_disciplina,
		D.Numero_disciplina,
		T.Semestre,
		T.Ano,
		H.Nota,
		dbo.fn_ConverterNotaConceito(h.Nota) as 'Conceito da Nota',
		H.Frequencia
FROM ALUNO AS A
JOIN HISTORICO_ESCOLAR AS H ON A.Numero_aluno = H.Numero_aluno
JOIN TURMA AS T ON H.Identificacao_turma = T.Identificacao_turma
JOIN DISCIPLINA AS D ON T.Numero_disciplina = D.Numero_disciplina;
GO

---

---13
GO
CREATE OR ALTER PROCEDURE usp_CadastrarDisciplina(@numero_disciplina VARCHAR(10),@nome_disciplina VARCHAR(100),@creditos INT, @departamento VARCHAR(10))
AS
BEGIN
		IF EXISTS (
			SELECT 1
			FROM DISCIPLINA 
			WHERE Numero_disciplina = @numero_disciplina
		)
		BEGIN
			PRINT 'Já existe essa disciplina com este código: ' + @numero_disciplina
			RETURN;
		END
		IF EXISTS (
			SELECT 1
			FROM DISCIPLINA 
			WHERE @nome_disciplina = Nome_disciplina
		)
		BEGIN
			PRINT 'Já existe essa disciplina com este nome: ' + @nome_disciplina
			RETURN;
		END
		IF(@creditos <= 0)
		BEGIN
			PRINT 'Quantidade de créditos precisa ser < 0';
			RETURN;
		END

		INSERT INTO DISCIPLINA (Numero_disciplina,Nome_disciplina,Creditos,Departamento)
		VALUES(@numero_disciplina,@nome_disciplina,@creditos,@departamento)
	    PRINT 'Disciplina cadastrada com sucesso!';


END;
GO

EXEC dbo.usp_CadastrarDisciplina 'CC1001','Disciplina do capeta','66','História';
EXEC dbo.usp_CadastrarDisciplina '888','Banco de Dados I','66','História';
EXEC dbo.usp_CadastrarDisciplina '888','Disciplina do capeta','-66','História';
EXEC dbo.usp_CadastrarDisciplina '888T','Disciplina de Historia','66','História';