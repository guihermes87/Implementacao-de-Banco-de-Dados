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