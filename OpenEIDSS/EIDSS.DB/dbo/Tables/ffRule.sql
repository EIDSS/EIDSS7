CREATE TABLE [dbo].[ffRule] (
    [idfsRule]             BIGINT           NOT NULL,
    [idfsFormTemplate]     BIGINT           NOT NULL,
    [idfsCheckPoint]       BIGINT           NULL,
    [idfsRuleMessage]      BIGINT           NULL,
    [idfsRuleFunction]     BIGINT           NOT NULL,
    [blnNot]               BIT              CONSTRAINT [Def_0_2039] DEFAULT ((0)) NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_2040] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2042] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffRule] PRIMARY KEY CLUSTERED ([idfsRule] ASC),
    CONSTRAINT [FK_FFRule_FFormTemplate] FOREIGN KEY ([idfsFormTemplate]) REFERENCES [dbo].[ffFormTemplate] ([idfsFormTemplate]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffRule_ffRuleFunction__idfsRuleFunction_R_1646] FOREIGN KEY ([idfsRuleFunction]) REFERENCES [dbo].[ffRuleFunction] ([idfsRuleFunction]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffRule_trtBaseReference__idfsCheckPoint_R_1390] FOREIGN KEY ([idfsCheckPoint]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffRule_trtBaseReference__idfsRule_R_1394] FOREIGN KEY ([idfsRule]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffRule_trtBaseReference__idfsRuleMessage_R_1391] FOREIGN KEY ([idfsRuleMessage]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffRule_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_ffRule_I_Delete] on [dbo].[ffRule]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsRule]) as
		(
			SELECT [idfsRule] FROM deleted
			EXCEPT
			SELECT [idfsRule] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.ffRule as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsRule = b.idfsRule;


		WITH cteOnlyDeletedRecords([idfsRule]) as
		(
			SELECT [idfsRule] FROM deleted
			EXCEPT
			SELECT [idfsRule] FROM inserted
		)
		
		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsRule;

	END

END

GO

CREATE TRIGGER [dbo].[TR_ffRule_A_Update] ON [dbo].[ffRule]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1) AND (UPDATE(idfsRule))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Rules', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffRule';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Rule identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffRule', @level2type = N'COLUMN', @level2name = N'idfsRule';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Template identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffRule', @level2type = N'COLUMN', @level2name = N'idfsFormTemplate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Message identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffRule', @level2type = N'COLUMN', @level2name = N'idfsRuleMessage';

