CREATE TABLE [dbo].[gisOtherStringNameTranslation] (
    [idfsGISOtherBaseReference] BIGINT           NOT NULL,
    [idfsLanguage]              BIGINT           NOT NULL,
    [strTextString]             NVARCHAR (300)   NULL,
    [rowguid]                   UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]        BIGINT           NULL,
    [SourceSystemKeyValue]      NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKgisOtherStringNameTranslation] PRIMARY KEY CLUSTERED ([idfsGISOtherBaseReference] ASC, [idfsLanguage] ASC),
    CONSTRAINT [FK_gisOtherStringNameTranslation_gisBaseReference__idfsLanguage_R_1680] FOREIGN KEY ([idfsLanguage]) REFERENCES [dbo].[gisBaseReference] ([idfsGISBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisOtherStringNameTranslation_gisOtherBaseReference__idfsGISOtherBaseReference_R_1679] FOREIGN KEY ([idfsGISOtherBaseReference]) REFERENCES [dbo].[gisOtherBaseReference] ([idfsGISOtherBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_gisOtherStringNameTranslation_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_gisOtherStringNameTranslation_A_Update] ON [dbo].[gisOtherStringNameTranslation]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfsgisOtherBaseReference)) OR UPDATE(idfsLanguage))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
