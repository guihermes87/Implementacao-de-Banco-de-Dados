CREATE PROCEDURE usp_inserirnovousuario
@nome as VARCHAR(50),
@id as int,
@saldoconta as MONEY
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