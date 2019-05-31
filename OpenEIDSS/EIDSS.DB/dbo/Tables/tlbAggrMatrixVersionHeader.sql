CREATE TABLE [dbo].[tlbAggrMatrixVersionHeader] (
    [idfVersion]           BIGINT           NOT NULL,
    [idfsMatrixType]       BIGINT           NOT NULL,
    [MatrixName]           NVARCHAR (200)   NULL,
    [datStartDate]         DATETIME         NULL,
    [blnIsActive]          BIT              CONSTRAINT [Def_0_2498] DEFAULT ((0)) NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_2499] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2474] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [blnIsDefault]         BIT              NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbAggrMatrixVersionHeader] PRIMARY KEY CLUSTERED ([idfVersion] ASC),
    CONSTRAINT [FK_tlbAggrMatrixVersionHeader_trtBaseReference__idfsAggrMatrixType_R_1685] FOREIGN KEY ([idfsMatrixType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrMatrixVersionHeader_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_tlbAggrMatrixVersionHeader_I_Delete] on [dbo].[tlbAggrMatrixVersionHeader]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfVersion]) as
		(
			SELECT [idfVersion] FROM deleted
			EXCEPT
			SELECT [idfVersion] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbAggrMatrixVersionHeader as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfVersion = b.idfVersion;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbAggrMatrixVersionHeader_A_Update] ON [dbo].[tlbAggrMatrixVersionHeader]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfVersion))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
