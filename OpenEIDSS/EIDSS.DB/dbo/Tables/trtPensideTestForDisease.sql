CREATE TABLE [dbo].[trtPensideTestForDisease] (
    [idfPensideTestForDisease] BIGINT           NOT NULL,
    [idfsPensideTestName]      BIGINT           NOT NULL,
    [idfsDiagnosis]            BIGINT           NOT NULL,
    [intRowStatus]             INT              CONSTRAINT [Def_0_trtPensideTestForDisease_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]                  UNIQUEIDENTIFIER CONSTRAINT [newid__trtPensideTestForDisease_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]       NVARCHAR (20)    NULL,
    [strReservedAttribute]     NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]       BIGINT           NULL,
    [SourceSystemKeyValue]     NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtPensideTestForDisease] PRIMARY KEY CLUSTERED ([idfPensideTestForDisease] ASC),
    CONSTRAINT [FK_trtPensideTestForDisease_trtBaseReference__idfsPensideTestName] FOREIGN KEY ([idfsPensideTestName]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtPensideTestForDisease_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtPensideTestForDisease_trtDiagnosis__idfsDiagnosis] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION
);


GO


CREATE TRIGGER [dbo].[TR_trtPensideTestForDisease_I_Delete] on [dbo].[trtPensideTestForDisease]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfPensideTestForDisease]) as
		(
			SELECT [idfPensideTestForDisease] FROM deleted
			EXCEPT
			SELECT [idfPensideTestForDisease] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtPensideTestForDisease as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfPensideTestForDisease = b.idfPensideTestForDisease;

	END

END

GO

CREATE TRIGGER [dbo].[TR_trtPensideTestForDisease_A_Update] ON [dbo].[trtPensideTestForDisease]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfPensideTestForDisease))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
