CREATE TABLE [dbo].[tlbAggrSanitaryActionMTX] (
    [idfAggrSanitaryActionMTX] BIGINT           NOT NULL,
    [idfVersion]               BIGINT           NOT NULL,
    [idfsSanitaryAction]       BIGINT           NOT NULL,
    [intNumRow]                INT              NULL,
    [intRowStatus]             INT              CONSTRAINT [Def_0_tlbAggrSanitaryActionMTX_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]                  UNIQUEIDENTIFIER CONSTRAINT [newid__tlbAggrSanitaryActionMTX_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]       NVARCHAR (20)    NULL,
    [strReservedAttribute]     NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]       BIGINT           NULL,
    [SourceSystemKeyValue]     NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbAggrSanitaryActionMTX] PRIMARY KEY CLUSTERED ([idfAggrSanitaryActionMTX] ASC),
    CONSTRAINT [FK_tlbAggrSanitaryActionMTX_tlbAggrMatrixVersionHeader__idfVersion] FOREIGN KEY ([idfVersion]) REFERENCES [dbo].[tlbAggrMatrixVersionHeader] ([idfVersion]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrSanitaryActionMTX_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbAggrSanitaryActionMTX_trtSanitaryAction__idfsSanitaryAction] FOREIGN KEY ([idfsSanitaryAction]) REFERENCES [dbo].[trtSanitaryAction] ([idfsSanitaryAction]) NOT FOR REPLICATION
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tlbAggrSanitaryActionMTX]
    ON [dbo].[tlbAggrSanitaryActionMTX]([idfsSanitaryAction] ASC, [idfVersion] ASC);


GO


CREATE TRIGGER [dbo].[TR_tlbAggrSanitaryActionMTX_I_Delete] on [dbo].[tlbAggrSanitaryActionMTX]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfAggrSanitaryActionMTX]) as
		(
			SELECT [idfAggrSanitaryActionMTX] FROM deleted
			EXCEPT
			SELECT [idfAggrSanitaryActionMTX] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbAggrSanitaryActionMTX as a 
		INNER JOIN cteOnlyDelectedRecords as b 
			ON a.idfAggrSanitaryActionMTX = b.idfAggrSanitaryActionMTX;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbAggrSanitaryActionMTX_A_Update] ON [dbo].[tlbAggrSanitaryActionMTX]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfAggrSanitaryActionMTX))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
