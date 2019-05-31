CREATE TABLE [dbo].[tstCheckTables] (
    [idfCheckTable]        BIGINT           NOT NULL,
    [strRootTableName]     NVARCHAR (500)   NOT NULL,
    [strRootObjectType]    NVARCHAR (500)   NULL,
    [strRootTableStrId]    NVARCHAR (500)   NULL,
    [intTypeValidation]    INT              NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstCheckTables] PRIMARY KEY CLUSTERED ([idfCheckTable] ASC),
    CONSTRAINT [FK_tstCheckTables_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tstCheckTables_A_Update] ON [dbo].[tstCheckTables]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfCheckTable]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
