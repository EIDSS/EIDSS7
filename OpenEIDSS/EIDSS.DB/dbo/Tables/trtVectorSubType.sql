CREATE TABLE [dbo].[trtVectorSubType] (
    [idfsVectorSubType]    BIGINT           NOT NULL,
    [idfsVectorType]       BIGINT           NOT NULL,
    [strCode]              NVARCHAR (50)    NULL,
    [intRowStatus]         INT              CONSTRAINT [DF_trtVectorSubType_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [DF_trtVectorSubType_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_trtSubSpeciesType] PRIMARY KEY CLUSTERED ([idfsVectorSubType] ASC),
    CONSTRAINT [FK_trtVectorSubType_trtBaseReference_idfsVectorSubType] FOREIGN KEY ([idfsVectorSubType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtVectorSubType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtVectorSubType_trtVectorType_idfsVectorType] FOREIGN KEY ([idfsVectorType]) REFERENCES [dbo].[trtVectorType] ([idfsVectorType]) NOT FOR REPLICATION
);


GO



CREATE TRIGGER [dbo].[TR_trtVectorSubType_I_Delete] on [dbo].[trtVectorSubType]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	begin

		WITH cteOnlyDeletedRecords([idfsVectorSubType]) as
		(
			SELECT [idfsVectorSubType] FROM deleted
			EXCEPT
			SELECT [idfsVectorSubType] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtVectorSubType as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsVectorSubType = b.idfsVectorSubType;


		WITH cteOnlyDeletedRecords([idfsVectorSubType]) as
		(
			SELECT [idfsVectorSubType] FROM deleted
			EXCEPT
			SELECT [idfsVectorSubType] FROM inserted
		)

		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsVectorSubType;

	END

END

GO

CREATE TRIGGER [dbo].[TR_trtVectorSubType_A_Update] ON [dbo].[trtVectorSubType]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsVectorSubType))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
