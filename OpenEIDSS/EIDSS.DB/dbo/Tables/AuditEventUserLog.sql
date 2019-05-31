CREATE TABLE [dbo].[AuditEventUserLog] (
    [AuditUserDataPreXML]    XML              NULL,
    [AuditUserDataPostXML]   XML              NOT NULL,
    [AuditObjectTypeID]      BIGINT           NOT NULL,
    [AuditEventTypeID]       BIGINT           NOT NULL,
    [AuditEventSystemLogUID] BIGINT           NULL,
    [AuditEventUserLogUID]   BIGINT           NOT NULL,
    [AppSessionID]           VARCHAR (100)    NOT NULL,
    [idfAppUserID]           BIGINT           NULL,
    [idfSiteID]              BIGINT           NULL,
    [AuditCreateDTM]         DATETIME         NOT NULL,
    [AuditCreateUser]        BIGINT           NOT NULL,
    [AuditUpdateUser]        BIGINT           NULL,
    [AuditUpdateDTM]         DATETIME         NULL,
    [rowguid]                UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]     BIGINT           NULL,
    [SourceSystemKeyValue]   NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKAuditUserEventLog] PRIMARY KEY CLUSTERED ([AuditEventUserLogUID] ASC),
    CONSTRAINT [FK_AuditEventUserLog_AuditEventSystemLog_LogUID] FOREIGN KEY ([AuditEventSystemLogUID]) REFERENCES [dbo].[AuditEventSystemLog] ([AuditEventSystemLogUID]),
    CONSTRAINT [FK_AuditEventUserLog_BaseRef_AuditEventTypeID] FOREIGN KEY ([AuditEventTypeID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_AuditEventUserLog_BaseRef_AuditObjectTypeID] FOREIGN KEY ([AuditObjectTypeID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_AuditEventUserLog_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_AuditEventUserLog_tstSite_idfSiteID] FOREIGN KEY ([idfSiteID]) REFERENCES [dbo].[tstSite] ([idfsSite]),
    CONSTRAINT [FK_AuditEventUserLog_UserTable_idfAppUserID] FOREIGN KEY ([idfAppUserID]) REFERENCES [dbo].[tstUserTable] ([idfUserID])
);


GO

CREATE TRIGGER [dbo].[TR_AuditEventUserLog_A_Update] ON [dbo].[AuditEventUserLog]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE(AuditEventUserLogUID))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
