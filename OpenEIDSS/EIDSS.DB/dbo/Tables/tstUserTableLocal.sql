CREATE TABLE [dbo].[tstUserTableLocal] (
    [idfUserID]            BIGINT           NOT NULL,
    [datTryDate]           DATETIME         NULL,
    [intTry]               INT              NULL,
    [strOptions]           NVARCHAR (MAX)   NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstUserTableLocal] PRIMARY KEY CLUSTERED ([idfUserID] ASC),
    CONSTRAINT [FK_tstUserTableLocal_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstUserTableLocal_tstUserTable_idfUserID] FOREIGN KEY ([idfUserID]) REFERENCES [dbo].[tstUserTable] ([idfUserID]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tstUserTableLocal_A_Update] ON [dbo].[tstUserTableLocal]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfUserID]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
