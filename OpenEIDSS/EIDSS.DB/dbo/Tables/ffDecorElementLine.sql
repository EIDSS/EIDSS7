CREATE TABLE [dbo].[ffDecorElementLine] (
    [idfDecorElement]      BIGINT           NOT NULL,
    [intLeft]              INT              CONSTRAINT [Def_0_1903] DEFAULT ((0)) NOT NULL,
    [intTop]               INT              CONSTRAINT [Def_0_1904] DEFAULT ((0)) NOT NULL,
    [intWidth]             INT              NULL,
    [intHeight]            INT              NULL,
    [intColor]             INT              NULL,
    [blnOrientation]       BIT              CONSTRAINT [Def_0___2713] DEFAULT ((0)) NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_1905] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1916] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffDecorElementLine] PRIMARY KEY CLUSTERED ([idfDecorElement] ASC),
    CONSTRAINT [FK_ffDecorElementLine_ffDecorElement__idfDecorElement_R_1401] FOREIGN KEY ([idfDecorElement]) REFERENCES [dbo].[ffDecorElement] ([idfDecorElement]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffDecorElementLine_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_ffDecorElementLine_I_Delete] ON [dbo].[ffDecorElementLine]
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
		FROM dbo.ffDecorElementLine as a 
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


CREATE TRIGGER [dbo].[TR_ffDecorElementLine_A_Update] ON [dbo].[ffDecorElementLine]
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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Line Decoration Elements', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElementLine';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Line decoration element identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElementLine', @level2type = N'COLUMN', @level2name = N'idfDecorElement';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Line color', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElementLine', @level2type = N'COLUMN', @level2name = N'intColor';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Line orientation (IsVertical : true - vertical, false - horizontal)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffDecorElementLine', @level2type = N'COLUMN', @level2name = N'blnOrientation';

