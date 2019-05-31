CREATE TABLE [dbo].[AuditEventSystemLog] (
    [AuditEventSystemLogUID]  BIGINT           NOT NULL,
    [AuditObjectTypeID]       BIGINT           NOT NULL,
    [AuditEventTypeID]        BIGINT           NOT NULL,
    [AuditPrimaryTable]       VARCHAR (200)    NOT NULL,
    [AppSessionLogID]         BIGINT           NOT NULL,
    [DBSessionID]             NVARCHAR (100)   NOT NULL,
    [AuditDataPreXML]         XML              NULL,
    [AuditDataPostXML]        XML              NOT NULL,
    [idfAppUserID]            BIGINT           NULL,
    [idfSiteID]               BIGINT           NULL,
    [AuditCreateDBObjectName] VARCHAR (200)    NOT NULL,
    [AuditCreateDTM]          DATETIME         NOT NULL,
    [AuditUpdateDBObjectName] VARCHAR (MAX)    NULL,
    [AuditUpdateDTM]          DATETIME         NULL,
    [rowguid]                 UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKAuditEvent] PRIMARY KEY CLUSTERED ([AuditEventSystemLogUID] ASC),
    CONSTRAINT [FK_AuditEventSystemLog_BaseRef_AuditEventTypeID] FOREIGN KEY ([AuditEventTypeID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_AuditEventSystemLog_BaseRef_AuditObjectTypeID] FOREIGN KEY ([AuditObjectTypeID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_AuditEventSystemLog_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_AuditEventSystemLog_tstSite_idfSiteID] FOREIGN KEY ([idfSiteID]) REFERENCES [dbo].[tstSite] ([idfsSite]),
    CONSTRAINT [FK_AuditEventSystemLog_UserTable_idfAppUserID] FOREIGN KEY ([idfAppUserID]) REFERENCES [dbo].[tstUserTable] ([idfUserID]),
    CONSTRAINT [R_1362] FOREIGN KEY ([AppSessionLogID]) REFERENCES [dbo].[AppSessionLog] ([AppSessionLogUID])
);


GO

CREATE TRIGGER [dbo].[TR_AuditEventSystemLog_A_Update] ON [dbo].[AuditEventSystemLog]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE(AuditEventSystemLogUID))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
