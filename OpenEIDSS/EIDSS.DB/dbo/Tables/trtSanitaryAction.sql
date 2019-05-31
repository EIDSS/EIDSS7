CREATE TABLE [dbo].[trtSanitaryAction] (
    [idfsSanitaryAction]   BIGINT           NOT NULL,
    [strActionCode]        NVARCHAR (200)   NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_2016] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2019] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtSanitaryAction] PRIMARY KEY CLUSTERED ([idfsSanitaryAction] ASC),
    CONSTRAINT [FK_trtSanitaryAction_trtBaseReference__idfsSanitaryAction_R_1110] FOREIGN KEY ([idfsSanitaryAction]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtSanitaryAction_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtSanitaryAction_A_Update] on [dbo].[trtSanitaryAction]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsSanitaryAction))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_trtSanitaryAction_I_Delete] on [dbo].[trtSanitaryAction]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsSanitaryAction]) as
		(
			SELECT [idfsSanitaryAction] FROM deleted
			EXCEPT
			SELECT [idfsSanitaryAction] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtSanitaryAction as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsSanitaryAction = b.idfsSanitaryAction;


		WITH cteOnlyDeletedRecords([idfsSanitaryAction]) as
		(
			SELECT [idfsSanitaryAction] FROM deleted
			EXCEPT
			SELECT [idfsSanitaryAction] FROM inserted
		)

		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsSanitaryAction;

	END

END
