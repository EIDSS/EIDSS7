CREATE TABLE [dbo].[gisStringNameTranslation] (
    [idfsGISBaseReference] BIGINT           NOT NULL,
    [idfsLanguage]         BIGINT           NOT NULL,
    [strTextString]        NVARCHAR (300)   NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1940] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]         INT              DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKgisStringNameTranslation] PRIMARY KEY CLUSTERED ([idfsGISBaseReference] ASC, [idfsLanguage] ASC),
    CONSTRAINT [FK_gisStringNameTranslation_gisBaseReference__idfsGISBaseReference_R_1639] FOREIGN KEY ([idfsGISBaseReference]) REFERENCES [dbo].[gisBaseReference] ([idfsGISBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisStringNameTranslation_gisBaseReference__idfsLanguage_R_1640] FOREIGN KEY ([idfsLanguage]) REFERENCES [dbo].[gisBaseReference] ([idfsGISBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisStringNameTranslation_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [IX_gisStringNameTranslation_RS1]
    ON [dbo].[gisStringNameTranslation]([idfsLanguage] ASC)
    INCLUDE([strTextString]);


GO


CREATE TRIGGER [dbo].[TR_gisStringNameTranslation_I_Delete] on [dbo].[gisStringNameTranslation]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsGISBaseReference], [idfsLanguage]) as
		(
			SELECT [idfsGISBaseReference], [idfsLanguage] FROM deleted
			EXCEPT
			SELECT [idfsGISBaseReference], [idfsLanguage] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.gisStringNameTranslation as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsGISBaseReference = b.idfsGISBaseReference
			AND a.idfsLanguage = b.idfsLanguage;

	END

END

GO

CREATE TRIGGER [dbo].[TR_gisStringNameTranslation_A_Update] ON [dbo].[gisStringNameTranslation]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfsGISBaseReference) OR UPDATE(idfsLanguage)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Translated values for GIS References', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisStringNameTranslation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'GIS reference value identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisStringNameTranslation', @level2type = N'COLUMN', @level2name = N'idfsGISBaseReference';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Language identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisStringNameTranslation', @level2type = N'COLUMN', @level2name = N'idfsLanguage';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Translated value in specified language ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'gisStringNameTranslation', @level2type = N'COLUMN', @level2name = N'strTextString';

