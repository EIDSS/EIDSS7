CREATE TABLE [dbo].[tstEventClient] (
    [strClient]                   NVARCHAR (50)    NOT NULL,
    [idfLastEvent]                BIGINT           NULL,
    [idfLastReferenceChangeEvent] BIGINT           NULL,
    [rowguid]                     UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]          BIGINT           NULL,
    [SourceSystemKeyValue]        NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstEventClient] PRIMARY KEY CLUSTERED ([strClient] ASC),
    CONSTRAINT [FK_tstEventClient_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tstEventClient_A_Update] ON [dbo].[tstEventClient]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([strClient]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
