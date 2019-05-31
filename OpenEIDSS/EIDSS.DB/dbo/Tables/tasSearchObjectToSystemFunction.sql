CREATE TABLE [dbo].[tasSearchObjectToSystemFunction] (
    [idfsSearchObject]     BIGINT           NOT NULL,
    [idfsSystemFunction]   BIGINT           NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid_tasSearchObjectToSystemFunction] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasSearchObjectToSystemFunction] PRIMARY KEY CLUSTERED ([idfsSearchObject] ASC, [idfsSystemFunction] ASC),
    CONSTRAINT [FK_tasSearchObjectToSystemFunction_tasSearchObject_idfsSearchObject] FOREIGN KEY ([idfsSearchObject]) REFERENCES [dbo].[tasSearchObject] ([idfsSearchObject]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchObjectToSystemFunction_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tasSearchObjectToSystemFunction_trtSystemFunction_idfsSystemFunction] FOREIGN KEY ([idfsSystemFunction]) REFERENCES [dbo].[trtSystemFunction] ([idfsSystemFunction]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tasSearchObjectToSystemFunction_A_Update] ON [dbo].[tasSearchObjectToSystemFunction]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfsSearchObject) OR UPDATE(idfsSystemFunction)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
