CREATE TABLE [dbo].[ffRuleFunction] (
    [idfsRuleFunction]      BIGINT           NOT NULL,
    [intNumberOfParameters] INT              NULL,
    [strMask]               VARCHAR (20)     NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [newid__2081] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]    NVARCHAR (20)    NULL,
    [SourceSystemNameID]    BIGINT           NULL,
    [SourceSystemKeyValue]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffRuleFunction] PRIMARY KEY CLUSTERED ([idfsRuleFunction] ASC),
    CONSTRAINT [FK_ffRuleFunction_trtBaseReference__idfsRuleFunction_R_1393] FOREIGN KEY ([idfsRuleFunction]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffRuleFunction_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_ffRuleFunction_A_Update] ON [dbo].[ffRuleFunction]
FOR UPDATE
NOT FOR REPLICATION
AS

IF (TRIGGER_NESTLEVEL()<2)
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsRuleFunction))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Rule Functions', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffRuleFunction';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Function identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffRuleFunction', @level2type = N'COLUMN', @level2name = N'idfsRuleFunction';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Number of accepted parameters', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ffRuleFunction', @level2type = N'COLUMN', @level2name = N'intNumberOfParameters';

