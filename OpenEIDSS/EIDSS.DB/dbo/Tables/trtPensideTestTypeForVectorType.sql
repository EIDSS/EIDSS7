CREATE TABLE [dbo].[trtPensideTestTypeForVectorType] (
    [idfPensideTestTypeForVectorType] BIGINT           NOT NULL,
    [idfsPensideTestName]             BIGINT           NOT NULL,
    [idfsVectorType]                  BIGINT           NOT NULL,
    [intRowStatus]                    INT              CONSTRAINT [DF_trtPensideTestTypeForVectorType_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]                         UNIQUEIDENTIFIER CONSTRAINT [DF_trtPensideTestTypeForVectorType_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]              NVARCHAR (20)    NULL,
    [strReservedAttribute]            NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]              BIGINT           NULL,
    [SourceSystemKeyValue]            NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_trtPensideTestTypeForVectorType] PRIMARY KEY CLUSTERED ([idfPensideTestTypeForVectorType] ASC),
    CONSTRAINT [FK_trtPensideTestTypeForVectorType_trtBaseReference_idfsPensideTestName] FOREIGN KEY ([idfsPensideTestName]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtPensideTestTypeForVectorType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtPensideTestTypeForVectorType_trtVectorType_idfsVectorType] FOREIGN KEY ([idfsVectorType]) REFERENCES [dbo].[trtVectorType] ([idfsVectorType]) NOT FOR REPLICATION,
    CONSTRAINT [UQ_trtPensideTestTypeForVectorType] UNIQUE NONCLUSTERED ([idfsPensideTestName] ASC, [idfsVectorType] ASC)
);


GO

CREATE TRIGGER [dbo].[TR_trtPensideTestTypeForVectorType_A_Update] ON [dbo].[trtPensideTestTypeForVectorType]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfPensideTestTypeForVectorType))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO



CREATE TRIGGER [dbo].[TR_trtPensideTestTypeForVectorType_I_Delete] on [dbo].[trtPensideTestTypeForVectorType]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfPensideTestTypeForVectorType]) as
		(
			SELECT [idfPensideTestTypeForVectorType] FROM deleted
			EXCEPT
			SELECT [idfPensideTestTypeForVectorType] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtPensideTestTypeForVectorType as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfPensideTestTypeForVectorType = b.idfPensideTestTypeForVectorType;

	END

END
