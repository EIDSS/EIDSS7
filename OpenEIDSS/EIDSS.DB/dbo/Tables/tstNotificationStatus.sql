CREATE TABLE [dbo].[tstNotificationStatus] (
    [idfNotification]      BIGINT           NOT NULL,
    [intProcessed]         INT              NULL,
    [intSessionID]         INT              NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstNotificationStatus] PRIMARY KEY CLUSTERED ([idfNotification] ASC),
    CONSTRAINT [FK_tstNotificationStatus_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tstNotificationStatus_A_Update] ON [dbo].[tstNotificationStatus]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfNotification]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Notification status', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNotificationStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Notification identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNotificationStatus', @level2type = N'COLUMN', @level2name = N'idfNotification';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Is Notification processed (0/1)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNotificationStatus', @level2type = N'COLUMN', @level2name = N'intProcessed';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Replication session', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstNotificationStatus', @level2type = N'COLUMN', @level2name = N'intSessionID';

