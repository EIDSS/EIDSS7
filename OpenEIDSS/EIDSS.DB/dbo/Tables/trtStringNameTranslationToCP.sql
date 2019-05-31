CREATE TABLE [dbo].[trtStringNameTranslationToCP] (
    [idfsBaseReference]       BIGINT           NOT NULL,
    [idfsLanguage]            BIGINT           NOT NULL,
    [idfCustomizationPackage] BIGINT           NOT NULL,
    [strTextString]           NVARCHAR (2000)  NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [DF_trtStringNameTranslationToCP_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]      NVARCHAR (20)    NULL,
    [strReservedAttribute]    NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtStringNameTranslationToCP] PRIMARY KEY CLUSTERED ([idfsBaseReference] ASC, [idfsLanguage] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_trtStringNameTranslationToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtStringNameTranslationToCP_trtStringNameTranslation__idfsBaseReference_idfsLanguage] FOREIGN KEY ([idfsBaseReference], [idfsLanguage]) REFERENCES [dbo].[trtStringNameTranslation] ([idfsBaseReference], [idfsLanguage]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtStringNameTranslationToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtStringNameTranslationToCP_A_Update] ON [dbo].[trtStringNameTranslationToCP]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfsBaseReference]) OR UPDATE([idfsLanguage]) OR UPDATE([idfCustomizationPackage])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Base Reference identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtStringNameTranslationToCP', @level2type = N'COLUMN', @level2name = N'idfsBaseReference';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Language identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtStringNameTranslationToCP', @level2type = N'COLUMN', @level2name = N'idfsLanguage';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Country identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtStringNameTranslationToCP', @level2type = N'COLUMN', @level2name = N'idfCustomizationPackage';

