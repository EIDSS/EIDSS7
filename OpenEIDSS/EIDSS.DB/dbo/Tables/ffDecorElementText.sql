CREATE TABLE [dbo].[ffDecorElementText] (
    [idfDecorElement]      BIGINT           NOT NULL,
    [idfsBaseReference]    BIGINT           NULL,
    [intFontSize]          INT              NULL,
    [intFontStyle]         INT              NULL,
    [intColor]             INT              NULL,
    [intLeft]              INT              CONSTRAINT [Def_0_1906] DEFAULT ((0)) NOT NULL,
    [intTop]               INT              CONSTRAINT [Def_0_1907] DEFAULT ((0)) NOT NULL,
    [intWidth]             INT              NULL,
    [intHeight]            INT              NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_1908] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1917] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffDecorElementText] PRIMARY KEY CLUSTERED ([idfDecorElement] ASC),
    CONSTRAINT [FK_ffDecorElementText_ffDecorElement__idfDecorElement_R_1374] FOREIGN KEY ([idfDecorElement]) REFERENCES [dbo].[ffDecorElement] ([idfDecorElement]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffDecorElementText_trtBaseReference__idfsBaseReference_R_1389] FOREIGN KEY ([idfsBaseReference]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffDecorElementText_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_ffDecorElementText_A_Update] ON [dbo].[ffDecorElementText]
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


CREATE TRIGGER [dbo].[TR_ffDecorElementText_I_Delete] on [dbo].[ffDecorElementText]
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
		SET intRowStatus = 1
		FROM dbo.ffDecorElementText as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfDecorElement = b.idfDecorElement;

		WITH cteOnlyDeletedRecords([idfDecorElement]) as
		(
			SELECT [idfDecorElement] FROM deleted
			EXCEPT
			SELECT [idfDecorElement] FROM inserted
		)
		
		DELETE a
		FROM dbo.ffDecorElement as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfDecorElement = b.idfDecorElement;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Label Decoration Elements', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElementText';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Label decoration element identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElementText', @level2type = N'COLUMN', @level2name = N'idfDecorElement';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Label translation identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElementText', @level2type = N'COLUMN', @level2name = N'idfsBaseReference';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Font size', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElementText', @level2type = N'COLUMN', @level2name = N'intFontSize';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Font style', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElementText', @level2type = N'COLUMN', @level2name = N'intFontStyle';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Font color', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElementText', @level2type = N'COLUMN', @level2name = N'intColor';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Label text placeholder width', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElementText', @level2type = N'COLUMN', @level2name = N'intWidth';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Label text placeholder height', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElementText', @level2type = N'COLUMN', @level2name = N'intHeight';

