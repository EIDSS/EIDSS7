CREATE TABLE [dbo].[tstSecurityAudit] (
    [idfSecurityAudit]      BIGINT           NOT NULL,
    [idfsAction]            BIGINT           NOT NULL,
    [idfsResult]            BIGINT           NOT NULL,
    [idfsProcessType]       BIGINT           NOT NULL,
    [idfAffectedObjectType] BIGINT           NOT NULL,
    [idfObjectID]           BIGINT           NOT NULL,
    [idfUserID]             BIGINT           NULL,
    [idfDataAuditEvent]     BIGINT           NULL,
    [datActionDate]         DATETIME         NULL,
    [strErrorText]          NVARCHAR (200)   NULL,
    [strProcessID]          NVARCHAR (200)   NULL,
    [strDescription]        NVARCHAR (200)   NULL,
    [idfsSite]              BIGINT           CONSTRAINT [DF_tstSecurityAudit_idfsSite] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [newid__2575] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]    BIGINT           NULL,
    [SourceSystemKeyValue]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstSecurityAudit] PRIMARY KEY CLUSTERED ([idfSecurityAudit] ASC),
    CONSTRAINT [FK_tstSecurityAudit_tauDataAuditEvent__idfDataAuditEvent_R_1731] FOREIGN KEY ([idfDataAuditEvent]) REFERENCES [dbo].[tauDataAuditEvent] ([idfDataAuditEvent]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstSecurityAudit_trtBaseReference__idfsAction_R_1727] FOREIGN KEY ([idfsAction]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstSecurityAudit_trtBaseReference__idfsProcessType_R_1729] FOREIGN KEY ([idfsProcessType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstSecurityAudit_trtBaseReference__idfsResult_R_1728] FOREIGN KEY ([idfsResult]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstSecurityAudit_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstSecurityAudit_tstSite] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstSecurityAudit_tstUserTable__idfUserID_R_1726] FOREIGN KEY ([idfUserID]) REFERENCES [dbo].[tstUserTable] ([idfUserID]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tstSecurityAudit_A_Update] ON [dbo].[tstSecurityAudit]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfSecurityAudit]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
