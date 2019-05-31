CREATE TABLE [dbo].[trtMaterialForDiseaseToCP] (
    [idfMaterialForDisease]   BIGINT           NOT NULL,
    [idfCustomizationPackage] BIGINT           NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [DF_trtMaterialForDiseaseToCP_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]      NVARCHAR (20)    NULL,
    [strReservedAttribute]    NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtMaterialForDiseaseToCP] PRIMARY KEY CLUSTERED ([idfMaterialForDisease] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_trtMaterialForDiseaseToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtMaterialForDiseaseToCP_trtMaterialForDisease__idfMaterialForDisease_R_1876] FOREIGN KEY ([idfMaterialForDisease]) REFERENCES [dbo].[trtMaterialForDisease] ([idfMaterialForDisease]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtMaterialForDiseaseToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtMaterialForDiseaseToCP_A_Update] ON [dbo].[trtMaterialForDiseaseToCP]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfMaterialForDisease]) OR UPDATE([idfCustomizationPackage])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Country identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtMaterialForDiseaseToCP', @level2type = N'COLUMN', @level2name = N'idfCustomizationPackage';

