CREATE TABLE [dbo].[tstCustomizationPackage] (
    [idfCustomizationPackage]     BIGINT           NOT NULL,
    [idfsCountry]                 BIGINT           NOT NULL,
    [strCustomizationPackageName] NVARCHAR (200)   NULL,
    [rowguid]                     UNIQUEIDENTIFIER CONSTRAINT [tstCustomizationPackage_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]          BIGINT           NULL,
    [SourceSystemKeyValue]        NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstCustomizationPackage] PRIMARY KEY CLUSTERED ([idfCustomizationPackage] ASC),
    CONSTRAINT [FK_tstCustomizationPackage_gisCountry_idfsCountry] FOREIGN KEY ([idfsCountry]) REFERENCES [dbo].[gisCountry] ([idfsCountry]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstCustomizationPackage_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [UK_tstCustomizationPackage__idfsCountry_strCustomizationPackageName] UNIQUE NONCLUSTERED ([idfsCountry] ASC, [strCustomizationPackageName] ASC)
);


GO

CREATE TRIGGER [dbo].[TR_tstCustomizationPackage_A_Update] ON [dbo].[tstCustomizationPackage]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfCustomizationPackage]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
