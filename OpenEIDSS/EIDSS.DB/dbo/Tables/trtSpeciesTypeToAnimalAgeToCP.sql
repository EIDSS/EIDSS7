CREATE TABLE [dbo].[trtSpeciesTypeToAnimalAgeToCP] (
    [idfSpeciesTypeToAnimalAge] BIGINT           NOT NULL,
    [idfCustomizationPackage]   BIGINT           NOT NULL,
    [rowguid]                   UNIQUEIDENTIFIER CONSTRAINT [DF_trtSpeciesTypeToAnimalAgeToCP_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]        NVARCHAR (20)    NULL,
    [strReservedAttribute]      NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]        BIGINT           NULL,
    [SourceSystemKeyValue]      NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtSpeciesTypeToAnimalAgeToCP] PRIMARY KEY CLUSTERED ([idfSpeciesTypeToAnimalAge] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_trtSpeciesTypeToAnimalAgeToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtSpeciesTypeToAnimalAgeToCP_trtSpeciesTypeToAnimalAge__idfSpeciesTypeToAnimalAge_R_1882] FOREIGN KEY ([idfSpeciesTypeToAnimalAge]) REFERENCES [dbo].[trtSpeciesTypeToAnimalAge] ([idfSpeciesTypeToAnimalAge]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtSpeciesTypeToAnimalAgeToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtSpeciesTypeToAnimalAgeToCP_A_Update] ON [dbo].[trtSpeciesTypeToAnimalAgeToCP]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfSpeciesTypeToAnimalAge]) OR UPDATE([idfCustomizationPackage])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Country identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtSpeciesTypeToAnimalAgeToCP', @level2type = N'COLUMN', @level2name = N'idfCustomizationPackage';

