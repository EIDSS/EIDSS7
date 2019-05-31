CREATE TABLE [dbo].[tasSearchTableJoinRule] (
    [idfMainSearchTable]   BIGINT           NOT NULL,
    [idfSearchTable]       BIGINT           NOT NULL,
    [idfParentSearchTable] BIGINT           NOT NULL,
    [strJoinCondition]     NVARCHAR (2000)  NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2492] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfUnionSearchTable]  BIGINT           NOT NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasSearchTableJoinRule] PRIMARY KEY CLUSTERED ([idfMainSearchTable] ASC, [idfSearchTable] ASC, [idfUnionSearchTable] ASC),
    CONSTRAINT [FK_tasSearchTableJoinRule_tasSearchTable__idfMainSearchTable_R_1723] FOREIGN KEY ([idfMainSearchTable]) REFERENCES [dbo].[tasSearchTable] ([idfSearchTable]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchTableJoinRule_tasSearchTable__idfParentSearchTable_R_1700] FOREIGN KEY ([idfParentSearchTable]) REFERENCES [dbo].[tasSearchTable] ([idfSearchTable]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchTableJoinRule_tasSearchTable__idfSearchTable_R_1701] FOREIGN KEY ([idfSearchTable]) REFERENCES [dbo].[tasSearchTable] ([idfSearchTable]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchTableJoinRule_tasSearchTable__idfUnionSearchTable] FOREIGN KEY ([idfUnionSearchTable]) REFERENCES [dbo].[tasSearchTable] ([idfSearchTable]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchTableJoinRule_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasSearchTableJoinRule_A_Update] ON [dbo].[tasSearchTableJoinRule]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfMainSearchTable) OR UPDATE(idfSearchTable)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
