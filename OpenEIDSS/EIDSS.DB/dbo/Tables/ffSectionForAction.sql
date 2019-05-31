CREATE TABLE [dbo].[ffSectionForAction] (
    [idfSectionForAction]  BIGINT           NOT NULL,
    [idfsFormTemplate]     BIGINT           NOT NULL,
    [idfsRuleAction]       BIGINT           NULL,
    [idfsRule]             BIGINT           NULL,
    [idfsSection]          BIGINT           NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_1934] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1933] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffSectionForAction] PRIMARY KEY CLUSTERED ([idfSectionForAction] ASC),
    CONSTRAINT [FK_ffSectionForAction_ffRule__idfsRule_R_1403] FOREIGN KEY ([idfsRule]) REFERENCES [dbo].[ffRule] ([idfsRule]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffSectionForAction_ffSectionForTemplate__idfsFormTemplate_____________________________________________idfsSection_R_1402] FOREIGN KEY ([idfsFormTemplate], [idfsSection]) REFERENCES [dbo].[ffSectionForTemplate] ([idfsFormTemplate], [idfsSection]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffSectionForAction_trtBaseReference__idfsRuleAction_R_1404] FOREIGN KEY ([idfsRuleAction]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffSectionForAction_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_ffSectionForAction_I_Delete] on [dbo].[ffSectionForAction]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfSectionForAction]) as
		(
			SELECT [idfSectionForAction] FROM deleted
			EXCEPT
			SELECT [idfSectionForAction] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.ffSectionForAction as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfSectionForAction = b.idfSectionForAction;

	END

END

GO

CREATE TRIGGER [dbo].[TR_ffSectionForAction_A_Update] ON [dbo].[ffSectionForAction]
FOR UPDATE
NOT FOR REPLICATION
AS

IF (TRIGGER_NESTLEVEL()<2)
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfSectionForAction))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Template identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSectionForAction', @level2type = N'COLUMN', @level2name = N'idfsFormTemplate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Rule identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSectionForAction', @level2type = N'COLUMN', @level2name = N'idfsRule';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Section identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffSectionForAction', @level2type = N'COLUMN', @level2name = N'idfsSection';

