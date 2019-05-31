CREATE TABLE [dbo].[updUpdateBlock] (
    [strClientID]           NVARCHAR (50)    NOT NULL,
    [strApplication]        NVARCHAR (50)    NOT NULL,
    [blnWithDatabaseUpdate] BIT              NOT NULL,
    [datDateStarted]        DATETIME         NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]    BIGINT           NULL,
    [SourceSystemKeyValue]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_UpdateRegister] PRIMARY KEY CLUSTERED ([strClientID] ASC, [strApplication] ASC),
    CONSTRAINT [FK_updUpdateBlock_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_updUpdateBlock_A_Update] ON [dbo].[updUpdateBlock]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([strClientID]) OR UPDATE([strApplication])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
