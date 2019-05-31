CREATE TABLE [dbo].[tasFieldSourceForTable] (
    [idfsSearchField]      BIGINT           NOT NULL,
    [idfUnionSearchTable]  BIGINT           NOT NULL,
    [idfSearchTable]       BIGINT           NOT NULL,
    [strFieldText]         NVARCHAR (2000)  NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__tasFieldSourceForTable] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_tasFieldSourceForTable] PRIMARY KEY CLUSTERED ([idfsSearchField] ASC, [idfUnionSearchTable] ASC),
    CONSTRAINT [FK_tasFieldSourceForTable_tasSearchField__idfsSearchField] FOREIGN KEY ([idfsSearchField]) REFERENCES [dbo].[tasSearchField] ([idfsSearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasFieldSourceForTable_tasSearchTable__idfSearchTable] FOREIGN KEY ([idfSearchTable]) REFERENCES [dbo].[tasSearchTable] ([idfSearchTable]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasFieldSourceForTable_tasSearchTable__idfUnionSearchTable] FOREIGN KEY ([idfUnionSearchTable]) REFERENCES [dbo].[tasSearchTable] ([idfSearchTable]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasFieldSourceForTable_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasFieldSourceForTable_A_Update] ON [dbo].[tasFieldSourceForTable]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfsSearchField) OR UPDATE(idfUnionSearchTable)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
