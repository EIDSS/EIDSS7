CREATE TABLE [dbo].[tlbAggrHumanCaseMTX] (
    [idfAggrHumanCaseMTX]  BIGINT           NOT NULL,
    [idfVersion]           BIGINT           NOT NULL,
    [idfsDiagnosis]        BIGINT           NOT NULL,
    [intNumRow]            INT              NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_tlbAggrHumanCaseMTX_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__tlbAggrHumanCaseMTX_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbAggrHumanCaseMTX] PRIMARY KEY CLUSTERED ([idfAggrHumanCaseMTX] ASC),
    CONSTRAINT [FK_tlbAggrHumanCaseMTX_tlbAggrMatrixVersionHeader__idfVersion] FOREIGN KEY ([idfVersion]) REFERENCES [dbo].[tlbAggrMatrixVersionHeader] ([idfVersion]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrHumanCaseMTX_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbAggrHumanCaseMTX_trtDiagnosis__idfsDiagnosis] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tlbAggrHumanCaseMTX]
    ON [dbo].[tlbAggrHumanCaseMTX]([idfsDiagnosis] ASC, [idfVersion] ASC);


GO

CREATE TRIGGER [dbo].[TR_tlbAggrHumanCaseMTX_A_Update] ON [dbo].[tlbAggrHumanCaseMTX]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfAggrHumanCaseMTX))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbAggrHumanCaseMTX_I_Delete] on [dbo].[tlbAggrHumanCaseMTX]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfAggrHumanCaseMTX]) as
		(
			SELECT [idfAggrHumanCaseMTX] FROM deleted
			EXCEPT
			SELECT [idfAggrHumanCaseMTX] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbAggrHumanCaseMTX as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfAggrHumanCaseMTX = b.idfAggrHumanCaseMTX;

	END

END
