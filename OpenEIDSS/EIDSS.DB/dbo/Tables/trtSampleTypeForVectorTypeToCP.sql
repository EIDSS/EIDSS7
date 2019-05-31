CREATE TABLE [dbo].[trtSampleTypeForVectorTypeToCP] (
    [idfSampleTypeForVectorType] BIGINT           NOT NULL,
    [idfCustomizationPackage]    BIGINT           NOT NULL,
    [rowguid]                    UNIQUEIDENTIFIER CONSTRAINT [DF_trtSampleTypeForVectorTypeToCP_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]         NVARCHAR (20)    NULL,
    [strReservedAttribute]       NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]         BIGINT           NULL,
    [SourceSystemKeyValue]       NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_trtSampleTypeForVectorTypeToCP] PRIMARY KEY CLUSTERED ([idfSampleTypeForVectorType] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_trtSampleTypeForVectorTypeToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtSampleTypeForVectorTypeToCP_trtSampleTypeForVectorType_idfSampleTypeForVectorType] FOREIGN KEY ([idfSampleTypeForVectorType]) REFERENCES [dbo].[trtSampleTypeForVectorType] ([idfSampleTypeForVectorType]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtSampleTypeForVectorTypeToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtSampleTypeForVectorTypeToCP_A_Update] ON [dbo].[trtSampleTypeForVectorTypeToCP]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfSampleTypeForVectorType]) OR UPDATE([idfCustomizationPackage])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
