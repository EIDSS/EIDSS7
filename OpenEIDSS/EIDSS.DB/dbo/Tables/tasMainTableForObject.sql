CREATE TABLE [dbo].[tasMainTableForObject] (
    [idfsSearchObject]        BIGINT           NOT NULL,
    [idfMainSearchTable]      BIGINT           NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [newid__tasMainTableForObject] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfMandatorySearchTable] BIGINT           NOT NULL,
    [strReservedAttribute]    NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasMainTableForObject] PRIMARY KEY CLUSTERED ([idfsSearchObject] ASC, [idfMainSearchTable] ASC),
    CONSTRAINT [FK_tasMainTableForObject_tasSearchObject__idfsSearchObject] FOREIGN KEY ([idfsSearchObject]) REFERENCES [dbo].[tasSearchObject] ([idfsSearchObject]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasMainTableForObject_tasSearchTable__idfMainSearchTable] FOREIGN KEY ([idfMainSearchTable]) REFERENCES [dbo].[tasSearchTable] ([idfSearchTable]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasMainTableForObject_tasSearchTable__idfMandatorySearchTable] FOREIGN KEY ([idfMandatorySearchTable]) REFERENCES [dbo].[tasSearchTable] ([idfSearchTable]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasMainTableForObject_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasMainTableForObject_A_Update] ON [dbo].[tasMainTableForObject]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfsSearchObject) OR UPDATE(idfMainSearchTable)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
