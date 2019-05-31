CREATE TABLE [dbo].[ffRuleConstant] (
    [idfRuleConstant]      BIGINT           NOT NULL,
    [idfsRule]             BIGINT           NOT NULL,
    [varConstant]          SQL_VARIANT      NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_2070] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2072] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKffRuleConstant] PRIMARY KEY CLUSTERED ([idfRuleConstant] ASC),
    CONSTRAINT [FK_ffRuleConstant_ffRule__idfsRule_R_1648] FOREIGN KEY ([idfsRule]) REFERENCES [dbo].[ffRule] ([idfsRule]) NOT FOR REPLICATION,
    CONSTRAINT [FK_ffRuleConstant_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_ffRuleConstant_I_Delete] on [dbo].[ffRuleConstant]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfRuleConstant]) as
		(
			SELECT [idfRuleConstant] FROM deleted
			EXCEPT
			SELECT [idfRuleConstant] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.ffRuleConstant as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfRuleConstant = b.idfRuleConstant;

	END

END

GO

CREATE TRIGGER [dbo].[TR_ffRuleConstant_A_Update] ON [dbo].[ffRuleConstant]
FOR UPDATE
NOT FOR REPLICATION
AS

IF (TRIGGER_NESTLEVEL()<2)
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfRuleConstant))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
