CREATE TABLE [dbo].[tlbTransferOutMaterial] (
    [idfMaterial]          BIGINT           NOT NULL,
    [idfTransferOut]       BIGINT           NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [DF_tlbTransferOutMaterial_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [DF_tlbTransferOutMaterial_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_tlbTransferOutMaterial] PRIMARY KEY CLUSTERED ([idfMaterial] ASC, [idfTransferOut] ASC),
    CONSTRAINT [FK_tlbTransferOutMaterial_tlbMaterial] FOREIGN KEY ([idfMaterial]) REFERENCES [dbo].[tlbMaterial] ([idfMaterial]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTransferOutMaterial_tlbTransferOUT] FOREIGN KEY ([idfTransferOut]) REFERENCES [dbo].[tlbTransferOUT] ([idfTransferOut]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTransferOutMaterial_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tlbTransferOutMaterial_A_Update] ON [dbo].[tlbTransferOutMaterial]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfTransferOut) OR UPDATE(idfMaterial)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbTransferOutMaterial_I_Delete] on [dbo].[tlbTransferOutMaterial]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfMaterial], [idfTransferOut]) as
		(
			SELECT [idfMaterial], [idfTransferOut] FROM deleted
			EXCEPT
			SELECT [idfMaterial], [idfTransferOut] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbTransferOutMaterial as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfMaterial = b.idfMaterial
		and a.idfTransferOut = b.idfTransferOut;

	END

END
