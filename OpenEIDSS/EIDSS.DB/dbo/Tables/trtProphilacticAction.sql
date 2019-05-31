CREATE TABLE [dbo].[trtProphilacticAction] (
    [idfsProphilacticAction] BIGINT           NOT NULL,
    [strActionCode]          NVARCHAR (200)   NULL,
    [intRowStatus]           INT              CONSTRAINT [Def_0_1983] DEFAULT ((0)) NOT NULL,
    [rowguid]                UNIQUEIDENTIFIER CONSTRAINT [newid__1986] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]     NVARCHAR (20)    NULL,
    [strReservedAttribute]   NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]     BIGINT           NULL,
    [SourceSystemKeyValue]   NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtProphilacticAction] PRIMARY KEY CLUSTERED ([idfsProphilacticAction] ASC),
    CONSTRAINT [FK_trtProphilacticAction_trtBaseReference__idfsProphilacticAction_R_1109] FOREIGN KEY ([idfsProphilacticAction]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtProphilacticAction_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtProphilacticAction_A_Update] ON [dbo].[trtProphilacticAction]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsProphilacticAction))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_trtProphilacticAction_I_Delete] on [dbo].[trtProphilacticAction]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsProphilacticAction]) as
		(
			SELECT [idfsProphilacticAction] FROM deleted
			EXCEPT
			SELECT [idfsProphilacticAction] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtProphilacticAction as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsProphilacticAction = b.idfsProphilacticAction;


		WITH cteOnlyDeletedRecords([idfsProphilacticAction]) as
		(
			SELECT [idfsProphilacticAction] FROM deleted
			EXCEPT
			SELECT [idfsProphilacticAction] FROM inserted
		)

		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsProphilacticAction;

	END

END
