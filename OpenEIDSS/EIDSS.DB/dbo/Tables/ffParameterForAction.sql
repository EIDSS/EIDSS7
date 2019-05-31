CREATE TABLE [dbo].[ffParameterForAction] (
    [idfParameterForAction] BIGINT           NOT NULL,
    [idfsParameter]         BIGINT           NOT NULL,
    [idfsFormTemplate]      BIGINT           NOT NULL,
    [idfsRuleAction]        BIGINT           NULL,
    [idfsRule]              BIGINT           NOT NULL,
    [intRowStatus]          INT              CONSTRAINT [Def_0_1924] DEFAULT ((0)) NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [newid__1927] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]    NVARCHAR (20)    NULL,
    [SourceSystemNameID]    BIGINT           NULL,
    [SourceSystemKeyValue]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffParameterForAction] PRIMARY KEY CLUSTERED ([idfParameterForAction] ASC),
    CONSTRAINT [FK_ffParameterForAction_ffParameterForTemplate__idfsParameter_idfsFormTemplate_R] FOREIGN KEY ([idfsParameter], [idfsFormTemplate]) REFERENCES [dbo].[ffParameterForTemplate] ([idfsParameter], [idfsFormTemplate]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameterForAction_ffRule__idfsRule_R_820] FOREIGN KEY ([idfsRule]) REFERENCES [dbo].[ffRule] ([idfsRule]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameterForAction_trtBaseReference__idfsRuleAction_R_1392] FOREIGN KEY ([idfsRuleAction]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffParameterForAction_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_ffParameterForAction_A_Update] ON [dbo].[ffParameterForAction]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN

	IF(dbo.FN_GBL_TriggersWork ()=1) AND (UPDATE(idfParameterForAction))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_ffParameterForAction_I_Delete] on [dbo].[ffParameterForAction]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfParameterForAction]) as
		(
			SELECT [idfParameterForAction] FROM deleted
			EXCEPT
			SELECT [idfParameterForAction] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.ffParameterForAction as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfParameterForAction = b.idfParameterForAction;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Parameter identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterForAction', @level2type = N'COLUMN', @level2name = N'idfsParameter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Template identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffParameterForAction', @level2type = N'COLUMN', @level2name = N'idfsFormTemplate';

