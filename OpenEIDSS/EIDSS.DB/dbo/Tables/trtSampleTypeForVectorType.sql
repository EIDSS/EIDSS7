CREATE TABLE [dbo].[trtSampleTypeForVectorType] (
    [idfSampleTypeForVectorType] BIGINT           NOT NULL,
    [idfsSampleType]             BIGINT           NOT NULL,
    [idfsVectorType]             BIGINT           NOT NULL,
    [intRowStatus]               INT              CONSTRAINT [DF_trtSampleTypeForVectorType_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]                    UNIQUEIDENTIFIER CONSTRAINT [DF_trtSampleTypeForVectorType_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]         NVARCHAR (20)    NULL,
    [strReservedAttribute]       NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]         BIGINT           NULL,
    [SourceSystemKeyValue]       NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_trtSampleTypeForVectorType] PRIMARY KEY CLUSTERED ([idfSampleTypeForVectorType] ASC),
    CONSTRAINT [FK_trtSampleTypeForVectorType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtSampleTypeForVectorType_trtSampleType_idfsSampleType] FOREIGN KEY ([idfsSampleType]) REFERENCES [dbo].[trtSampleType] ([idfsSampleType]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtSampleTypeForVectorType_trtVectorType_idfsVectorType] FOREIGN KEY ([idfsVectorType]) REFERENCES [dbo].[trtVectorType] ([idfsVectorType]) NOT FOR REPLICATION,
    CONSTRAINT [UQ_trtSampleTypeForVectorType] UNIQUE NONCLUSTERED ([idfsSampleType] ASC, [idfsVectorType] ASC)
);


GO



CREATE TRIGGER [dbo].[TR_trtSampleTypeForVectorType_I_Delete] on [dbo].[trtSampleTypeForVectorType]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfSampleTypeForVectorType]) as
		(
			SELECT [idfSampleTypeForVectorType] FROM deleted
			EXCEPT
			SELECT [idfSampleTypeForVectorType] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtSampleTypeForVectorType as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.idfSampleTypeForVectorType = b.idfSampleTypeForVectorType;

	END

END

GO

CREATE TRIGGER [dbo].[TR_trtSampleTypeForVectorType_A_Update] ON [dbo].[trtSampleTypeForVectorType]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfSampleTypeForVectorType))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
