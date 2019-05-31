CREATE TABLE [dbo].[tstNotificationShared] (
    [idfNotificationShared]      BIGINT           NOT NULL,
    [idfsNotificationObjectType] BIGINT           NULL,
    [idfsNotificationType]       BIGINT           NULL,
    [idfsTargetSiteType]         BIGINT           NULL,
    [idfUserID]                  BIGINT           NULL,
    [idfNotificationObject]      BIGINT           NULL,
    [idfTargetUserID]            BIGINT           NULL,
    [idfsTargetSite]             BIGINT           NULL,
    [idfsSite]                   BIGINT           CONSTRAINT [Def_fnSiteID_tstNotificationShared] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [datCreationDate]            DATETIME         NOT NULL,
    [datEnteringDate]            DATETIME         NULL,
    [strPayload]                 TEXT             NULL,
    [rowguid]                    UNIQUEIDENTIFIER DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]         NVARCHAR (20)    NULL,
    [SourceSystemNameID]         BIGINT           NULL,
    [SourceSystemKeyValue]       NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstNotificationShared] PRIMARY KEY CLUSTERED ([idfNotificationShared] ASC),
    CONSTRAINT [FK_tstNotificationShared_trtBaseReference__idfsNotificationObjectType] FOREIGN KEY ([idfsNotificationObjectType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstNotificationShared_trtBaseReference__idfsNotificationType] FOREIGN KEY ([idfsNotificationType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstNotificationShared_trtBaseReference__idfsTargetSiteType] FOREIGN KEY ([idfsTargetSiteType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstNotificationShared_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstNotificationShared_tstSite__idfsSite] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstNotificationShared_tstSite__idfsTargetSite] FOREIGN KEY ([idfsTargetSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstNotificationShared_tstUserTable__idfTargetUserID] FOREIGN KEY ([idfTargetUserID]) REFERENCES [dbo].[tstUserTable] ([idfUserID]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstNotificationShared_tstUserTable__idfUserID] FOREIGN KEY ([idfUserID]) REFERENCES [dbo].[tstUserTable] ([idfUserID]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tstNotificationShared_A_Update] ON [dbo].[tstNotificationShared]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfNotificationShared]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
