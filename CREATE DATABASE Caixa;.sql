CREATE DATABASE Caixa;

USE CAIXA;

--CRIAÇÃO TABELA

CREATE TABLE conta(
id int PRIMARY KEY,
Nome VARCHAR(50),
Saldo MONEY
)

-- INSERINDO DADOS

insert into conta
VALUES  (10,'Maria',500),
        (11, 'João', 1500),
        (30,'Paulo', 30000),
        (40,'Maria', 50000);

SELECT * FROM CONTA;

GO
-- PRIMEIRA TRANSAÇÃO

BEGIN TRAN;

DECLARE @erro int = 0;

insert into conta
VALUES  (50,'Pedro',50);
SET @erro = @erro + @@ERROR

INSERT INTO conta
VALUES (10,'Judas',666);
SET @erro = @erro + @@ERROR

SELECT * from conta;
if @erro <> 0
BEGIN
    PRINT 'Transação revertida'
    ROLLBACK TRAN;
END
ELSE
BEGIN
PRINT 'Transação realizada com sucesso!'
COMMIT TRAN;
END
SELECT * FROM conta

GO

BEGIN TRAN;
UPDATE CONTA 
SET Saldo = saldo + 10000
where  nome = 'Maria';
if @@ROWCOUNT <> 1
BEGIN 
    SELECT * FROM conta
    ROLLBACK TRAN;
END
ELSE
    COMMIT TRAN

--TRANSFERIR DINHEIRO DE UMA PESSOA PRA OUTRA

BEGIN TRAN;

DECLARE @saldoconta MONEY;

SELECT @saldoconta = Saldo from conta

UPDATE conta
SET Saldo = Saldo + 500
WHERE id = 10;

UPDATE conta
SET saldo = saldo -500
WHERE id = 30;
BEGIN
if @saldoconta < 0 
    ROLLBACK TRAN;
ELSE 
    COMMIT TRAN;
END

SELECT * FROM conta

GO

CREATE PROCEDURE usp_transferencia
@id_origem int,
@id_destino int,
@valor MONEY
AS
BEGIN
begin tran;

--sacando dinheiro da conta de origem
UPDATE conta
SET SALDO = SALDO - @valor
WHERE ID = @id_origem;

--depositar na oconta destino

UPDATE conta
set saldo =  Saldo + @valor
where id = @id_destino;

--ver possivel estado da tabela conta
SELECT * FROM conta
--CONDIÇÃO PARA ROLLBACK
IF(select saldo from conta where id = @id_origem) < 0
BEGIN
    ROLLBACK TRAN
    print 'Saldo insuficiente'
END
ELSE
BEGIN
--CONDIÇÃO PARA COMMIT
    COMMIT TRAN;
    PRINT 'TRANSFERÊNCIA REALIZADA'
END
END

SELECT * FROM conta

EXEC usp_transferencia 10,50,200;

GO

-- SAVE POINT

BEGIN TRAN;
INSERT INTO conta
VALUES (50,'Pedro', 50);

-- save point

SAVE TRAN pedroOK
INSERT into conta
values(10,'Juca', -200);
if @@error <> 0
BEGIN
    ROLLBACK TRAN pedroOK
    COMMIT tran;
    PRINT 'Voltamos apra o save point'
END
ELSE
    COMMIT tran;
    SELECT * FROM conta


-- TRY CATCH

BEGIN TRY
PRINT 'OLÁ TRY CATCH'
SELECT 1/0 -- ERRO
PRINT 'não cheguei aqui'
END TRY
BEGIN CATCH
PRINT 'DEU ERRO'
PRINT 'NÚMERO:' + CAST(ERROR_NUMBER() AS VARCHAR(10));
PRINT 'MENSAGEM DE ERRO:' + ERROR_MESSAGE();
END CATCH

GO


BEGIN TRY
BEGIN TRAN;
INSERT INTO conta
VALUES (60,'Mateus', 15);
SELECT * FROM CONTA
INSERT into conta
values(10,'Juca', -200);
SELECT * FROM CONTA
END TRY
BEGIN CATCH
ROLLBACK TRAN;
PRINT 'DEU ERRO'
PRINT 'NÚMERO:' + CAST(ERROR_NUMBER() AS VARCHAR(10));
PRINT 'MENSAGEM DE ERRO:' + ERROR_MESSAGE();
END CATCH

DELETE FROM CONTA
WHERE ID = 10;

GO

CREATE or alter PROCEDURE usp_inserirnovousuario

@nome as VARCHAR(50),
@saldoconta as MONEY,
@id as int
AS
BEGIN
BEGIN TRAN
BEGIN TRY
INSERT INTO conta
values(@id,@nome, @saldoconta)
select * from conta;
IF (select count(*) from conta where nome = @nome) >1
BEGIN
ROLLBACK TRAN;
PRINT 'Já existe alguém com o nome' +@nome
END
ELSE
BEGIN
COMMIT TRAN;
PRINT 'Cadastro realizado com sucesso'
END
END TRY
BEGIN CATCH
ROLLBACK TRAN;
PRINT 'DEU ERRO'
PRINT 'NÚMERO:' + CAST(ERROR_NUMBER() AS VARCHAR(10));
PRINT 'MENSAGEM DE ERRO:' + ERROR_MESSAGE();
END CATCH
END

GO

EXEC usp_inserirnovousuario 80,

go
