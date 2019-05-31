CREATE TABLE [dbo].[trtCollectionMethodForVectorType] (
    [idfCollectionMethodForVectorType] BIGINT           NOT NULL,
    [idfsCollectionMethod]             BIGINT           NOT NULL,
    [idfsVectorType]                   BIGINT           NOT NULL,
    [intRowStatus]                     INT              CONSTRAINT [DF_trtCollectionMethodForVectorType_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]                          UNIQUEIDENTIFIER CONSTRAINT [DF_trtCollectionMethodForVectorType_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]               NVARCHAR (20)    NULL,
    [strReservedAttribute]             NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]               BIGINT           NULL,
    [SourceSystemKeyValue]             NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_trtCollectionMethodForVectorType] PRIMARY KEY CLUSTERED ([idfCollectionMethodForVectorType] ASC),
    CONSTRAINT [FK_trtCollectionMethodForVectorType_trtBaseReference_idfsCollectionMethod] FOREIGN KEY ([idfsCollectionMethod]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtCollectionMethodForVectorType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtCollectionMethodForVectorType_trtVectorType_idfsVectorType] FOREIGN KEY ([idfsVectorType]) REFERENCES [dbo].[trtVectorType] ([idfsVectorType]) NOT FOR REPLICATION,
    CONSTRAINT [UQ_trtCollectionMethodForVectorType] UNIQUE NONCLUSTERED ([idfsCollectionMethod] ASC, [idfsVectorType] ASC)
);


GO



CREATE TRIGGER [dbo].[TR_trtCollectionMethodForVectorType_I_Delete] on [dbo].[trtCollectionMethodForVectorType]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfCollectionMethodForVectorType]) as
		(
			SELECT [idfCollectionMethodForVectorType] FROM deleted
			EXCEPT
			SELECT [idfCollectionMethodForVectorType] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtCollectionMethodForVectorType as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfCollectionMethodForVectorType = b.idfCollectionMethodForVectorType;

	END

END

GO

CREATE TRIGGER [dbo].[TR_trtCollectionMethodForVectorType_A_Update] ON [dbo].[trtCollectionMethodForVectorType]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfCollectionMethodForVectorType))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
