CREATE TABLE [dbo].[trtStringNameTranslation] (
    [idfsBaseReference]    BIGINT           NOT NULL,
    [idfsLanguage]         BIGINT           NOT NULL,
    [strTextString]        NVARCHAR (2000)  NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_2019] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2022] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtStringNameTranslation] PRIMARY KEY CLUSTERED ([idfsBaseReference] ASC, [idfsLanguage] ASC),
    CONSTRAINT [FK_trtStringNameTranslation_trtBaseReference__idfsBaseReference_R_385] FOREIGN KEY ([idfsBaseReference]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtStringNameTranslation_trtBaseReference__idfsLanguage_R_1584] FOREIGN KEY ([idfsLanguage]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtStringNameTranslation_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [IX_trtStringNameTranslation_BL]
    ON [dbo].[trtStringNameTranslation]([idfsBaseReference] ASC, [idfsLanguage] ASC)
    INCLUDE([strTextString]);


GO
CREATE NONCLUSTERED INDEX [IX_trtStringNameTranslation_RS1]
    ON [dbo].[trtStringNameTranslation]([idfsLanguage] ASC, [intRowStatus] ASC)
    INCLUDE([strTextString]);


GO

CREATE TRIGGER [dbo].[TR_trtStringNameTranslation_A_Update] ON [dbo].[trtStringNameTranslation]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfsBaseReference) OR UPDATE(idfsLanguage)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO



CREATE TRIGGER [dbo].[TR_trtStringNameTranslation_I_Delete] on [dbo].[trtStringNameTranslation]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([idfsBaseReference], [idfsLanguage]) as
		(
			SELECT [idfsBaseReference], [idfsLanguage] FROM deleted
			EXCEPT
			SELECT [idfsBaseReference], [idfsLanguage] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtStringNameTranslation as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.idfsBaseReference = b.idfsBaseReference
			AND a.idfsLanguage = b.idfsLanguage;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Base reference translated values', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtStringNameTranslation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Base reference value identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtStringNameTranslation', @level2type = N'COLUMN', @level2name = N'idfsBaseReference';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Language identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtStringNameTranslation', @level2type = N'COLUMN', @level2name = N'idfsLanguage';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Translated value in specified language ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtStringNameTranslation', @level2type = N'COLUMN', @level2name = N'strTextString';

