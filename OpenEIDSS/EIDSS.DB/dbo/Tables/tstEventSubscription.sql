CREATE TABLE [dbo].[tstEventSubscription] (
    [idfsEventTypeID]      BIGINT           NOT NULL,
    [strClient]            NVARCHAR (200)   NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstEventSubscription] PRIMARY KEY CLUSTERED ([idfsEventTypeID] ASC, [strClient] ASC),
    CONSTRAINT [FK_tstEventSubscription_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstEventSubscription_trtEventType__idfsEventTypeID_R_676] FOREIGN KEY ([idfsEventTypeID]) REFERENCES [dbo].[trtEventType] ([idfsEventTypeID]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tstEventSubscription_A_Update] ON [dbo].[tstEventSubscription]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfsEventTypeID]) OR UPDATE([strClient])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
