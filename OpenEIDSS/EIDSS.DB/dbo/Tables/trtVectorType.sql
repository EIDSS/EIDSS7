CREATE TABLE [dbo].[trtVectorType] (
    [idfsVectorType]       BIGINT           NOT NULL,
    [strCode]              NVARCHAR (50)    NULL,
    [bitCollectionByPool]  BIT              CONSTRAINT [DF_trtVectorType_bitCollectionByPool] DEFAULT ((0)) NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [DF_trtVectorType_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [DF_trtVectorType_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_trtVectorType] PRIMARY KEY CLUSTERED ([idfsVectorType] ASC),
    CONSTRAINT [FK_trtVectorType_trtBaseReference__idfsVectorType] FOREIGN KEY ([idfsVectorType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtVectorType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtVectorType_A_Update] ON [dbo].[trtVectorType]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsVectorType))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO



CREATE TRIGGER [dbo].[TR_trtVectorType_I_Delete] on [dbo].[trtVectorType]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsVectorType]) as
		(
			SELECT [idfsVectorType] FROM deleted
			EXCEPT
			SELECT [idfsVectorType] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtVectorType as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsVectorType = b.idfsVectorType;

		
		WITH cteOnlyDeletedRecords([idfsVectorType]) as
		(
			SELECT [idfsVectorType] FROM deleted
			EXCEPT
			SELECT [idfsVectorType] FROM inserted
		)

		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsVectorType;

	END

END
