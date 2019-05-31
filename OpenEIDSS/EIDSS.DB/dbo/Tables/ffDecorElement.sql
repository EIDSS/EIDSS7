CREATE TABLE [dbo].[ffDecorElement] (
    [idfDecorElement]      BIGINT           NOT NULL,
    [idfsDecorElementType] BIGINT           NOT NULL,
    [idfsLanguage]         BIGINT           NOT NULL,
    [idfsFormTemplate]     BIGINT           NOT NULL,
    [idfsSection]          BIGINT           NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_1902] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1915] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffDecorElement] PRIMARY KEY CLUSTERED ([idfDecorElement] ASC),
    CONSTRAINT [FK_ffDecorElement_ffFormTemplate__idfsFormTemplate_R_1373] FOREIGN KEY ([idfsFormTemplate]) REFERENCES [dbo].[ffFormTemplate] ([idfsFormTemplate]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffDecorElement_ffSection__idfsSection_R_1379] FOREIGN KEY ([idfsSection]) REFERENCES [dbo].[ffSection] ([idfsSection]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffDecorElement_trtBaseReference__idfsDecorElementType_R_1376] FOREIGN KEY ([idfsDecorElementType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffDecorElement_trtBaseReference__idfsLanguage_R_1375] FOREIGN KEY ([idfsLanguage]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffDecorElement_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE  TRIGGER [dbo].[TR_ffDecorElement_A_Update] ON [dbo].[ffDecorElement]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN

IF (dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfDecorElement) )
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END		

END


GO

CREATE TRIGGER [dbo].[TR_ffDecorElement_I_Delete] ON [dbo].[ffDecorElement]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN
	
	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfDecorElement]) as
		(
			SELECT [idfDecorElement] FROM deleted
			EXCEPT
			SELECT [idfDecorElement] FROM inserted
		)

		UPDATE a
		SET  intRowStatus = 1
		FROM dbo.ffDecorElement AS a 
		INNER JOIN cteOnlyDeletedRecords AS b 
			ON a.idfDecorElement = b.idfDecorElement
	END

END


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Decoration Elements', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElement';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Decoration element identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElement', @level2type = N'COLUMN', @level2name = N'idfDecorElement';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Decoration element type identifier (line or label)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElement', @level2type = N'COLUMN', @level2name = N'idfsDecorElementType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Language identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElement', @level2type = N'COLUMN', @level2name = N'idfsLanguage';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Template identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElement', @level2type = N'COLUMN', @level2name = N'idfsFormTemplate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Section identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElement', @level2type = N'COLUMN', @level2name = N'idfsSection';

