CREATE TABLE [dbo].[ffFormTemplate] (
    [idfsFormTemplate]     BIGINT           NOT NULL,
    [idfsFormType]         BIGINT           NULL,
    [blnUNI]               BIT              CONSTRAINT [Def_0_1900] DEFAULT ((0)) NOT NULL,
    [strNote]              NVARCHAR (200)   NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_1901] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1914] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffFormTemplate] PRIMARY KEY CLUSTERED ([idfsFormTemplate] ASC),
    CONSTRAINT [FK_ffFormTemplate_trtBaseReference__idfsFormTemplate_R_1385] FOREIGN KEY ([idfsFormTemplate]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffFormTemplate_trtBaseReference__idfsFormType_R_1656] FOREIGN KEY ([idfsFormType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffFormTemplate_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_ffFormTemplate_A_Update] ON [dbo].[ffFormTemplate]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF((dbo.FN_GBL_TriggersWork ()=1) AND UPDATE(idfsFormTemplate))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_ffFormTemplate_I_Delete] on [dbo].[ffFormTemplate]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsFormTemplate]) as
		(
			SELECT [idfsFormTemplate] FROM deleted
			EXCEPT
			SELECT [idfsFormTemplate] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.ffFormTemplate as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsFormTemplate = b.idfsFormTemplate;


		WITH cteOnlyDeletedRecords([idfsFormTemplate]) as
		(
			SELECT [idfsFormTemplate] FROM deleted
			EXCEPT
			SELECT [idfsFormTemplate] FROM inserted
		)
		
		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsFormTemplate;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Templates', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffFormTemplate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Template identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffFormTemplate', @level2type = N'COLUMN', @level2name = N'idfsFormTemplate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Template type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffFormTemplate', @level2type = N'COLUMN', @level2name = N'idfsFormType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Flag - template is used by default', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffFormTemplate', @level2type = N'COLUMN', @level2name = N'blnUNI';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Template notes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffFormTemplate', @level2type = N'COLUMN', @level2name = N'strNote';

