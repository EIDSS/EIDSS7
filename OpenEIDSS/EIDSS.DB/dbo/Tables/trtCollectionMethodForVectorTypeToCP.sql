CREATE TABLE [dbo].[trtCollectionMethodForVectorTypeToCP] (
    [idfCollectionMethodForVectorType] BIGINT           NOT NULL,
    [idfCustomizationPackage]          BIGINT           NOT NULL,
    [rowguid]                          UNIQUEIDENTIFIER CONSTRAINT [DF_trtCollectionMethodForVectorTypeToCP_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]               NVARCHAR (20)    NULL,
    [strReservedAttribute]             NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]               BIGINT           NULL,
    [SourceSystemKeyValue]             NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_trtCollectionMethodForVectorTypeToCP] PRIMARY KEY CLUSTERED ([idfCollectionMethodForVectorType] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_trtCollectionMethodForVectorTypeToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtCollectionMethodForVectorTypeToCP_trtCollectionMethodForVectorType_idfCollectionMethodForVectorType] FOREIGN KEY ([idfCollectionMethodForVectorType]) REFERENCES [dbo].[trtCollectionMethodForVectorType] ([idfCollectionMethodForVectorType]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtCollectionMethodForVectorTypeToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtCollectionMethodForVectorTypeToCP_A_Update] ON [dbo].[trtCollectionMethodForVectorTypeToCP]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfCollectionMethodForVectorType) OR UPDATE(idfCollectionMethodForVectorType)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
