CREATE TABLE [dbo].[trtBssAggregateColumns] (
    [idfsBssAggregateColumn] BIGINT           NOT NULL,
    [idfColumn]              BIGINT           NOT NULL,
    [intRowStatus]           INT              CONSTRAINT [trtBssAggregateColumns_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]                UNIQUEIDENTIFIER CONSTRAINT [trtBssAggregateColumns_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]     NVARCHAR (20)    NULL,
    [strReservedAttribute]   NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]     BIGINT           NULL,
    [SourceSystemKeyValue]   NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtBssAggregateColumns] PRIMARY KEY CLUSTERED ([idfsBssAggregateColumn] ASC),
    CONSTRAINT [FK_trtBssAggregateColumns_tauColumn__idfColumn] FOREIGN KEY ([idfColumn]) REFERENCES [dbo].[tauColumn] ([idfColumn]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtBssAggregateColumns_trtBaseReference__idfsBssAggregateColumn] FOREIGN KEY ([idfsBssAggregateColumn]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtBssAggregateColumns_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtBssAggregateColumns_A_Update] ON [dbo].[trtBssAggregateColumns]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsBssAggregateColumn))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_trtBssAggregateColumns_I_Delete] on [dbo].[trtBssAggregateColumns]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsBssAggregateColumn]) as
		(
			SELECT [idfsBssAggregateColumn] FROM deleted
			EXCEPT
			SELECT [idfsBssAggregateColumn] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtBssAggregateColumns as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBssAggregateColumn = b.idfsBssAggregateColumn;


		WITH cteOnlyDeletedRecords([idfsBssAggregateColumn]) as
		(
			SELECT [idfsBssAggregateColumn] FROM deleted
			EXCEPT
			SELECT [idfsBssAggregateColumn] FROM inserted
		)

		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsBssAggregateColumn;

	END

END
