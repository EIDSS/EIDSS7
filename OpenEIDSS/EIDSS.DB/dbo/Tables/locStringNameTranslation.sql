CREATE TABLE [dbo].[locStringNameTranslation] (
    [idflBaseReference]    BIGINT           NOT NULL,
    [idfsLanguage]         BIGINT           NOT NULL,
    [strTextString]        NVARCHAR (2000)  NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKlocStringNameTranslation] PRIMARY KEY CLUSTERED ([idflBaseReference] ASC, [idfsLanguage] ASC),
    CONSTRAINT [FK_locStringNameTranslation_locBaseReference__idflBaseReference_R_1702] FOREIGN KEY ([idflBaseReference]) REFERENCES [dbo].[locBaseReference] ([idflBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_locStringNameTranslation_trtBaseReference__idfsLanguage_R_1692] FOREIGN KEY ([idfsLanguage]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_locStringNameTranslation_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_locStringNameTranslation_A_Update] ON [dbo].[locStringNameTranslation]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idflBaseReference) OR UPDATE(idfsLanguage)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
