CREATE TABLE [dbo].[tauDataAuditEvent] (
    [idfDataAuditEvent]             BIGINT           NOT NULL,
    [idfsDataAuditObjectType]       BIGINT           NULL,
    [idfsDataAuditEventType]        BIGINT           NULL,
    [idfMainObject]                 BIGINT           NULL,
    [idfMainObjectTable]            BIGINT           NULL,
    [idfUserID]                     BIGINT           NULL,
    [idfsSite]                      BIGINT           CONSTRAINT [Def_fnSiteID_tauDataAuditEvent] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [datEnteringDate]               DATETIME         NULL,
    [strHostname]                   NVARCHAR (200)   NULL,
    [rowguid]                       UNIQUEIDENTIFIER CONSTRAINT [newid__1966] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [datModificationForArchiveDate] DATETIME         CONSTRAINT [tauDataAuditEvent_datModificationForArchiveDate] DEFAULT (getdate()) NULL,
    [strMaintenanceFlag]            NVARCHAR (20)    NULL,
    [SourceSystemNameID]            BIGINT           NULL,
    [SourceSystemKeyValue]          NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtauDataAuditEvent] PRIMARY KEY CLUSTERED ([idfDataAuditEvent] ASC),
    CONSTRAINT [FK_tauDataAuditEvent_tauTable__idfMainObjectTable_R_1560] FOREIGN KEY ([idfMainObjectTable]) REFERENCES [dbo].[tauTable] ([idfTable]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tauDataAuditEvent_trtBaseReference__idfsDataAuditEventType_R_1556] FOREIGN KEY ([idfsDataAuditEventType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tauDataAuditEvent_trtBaseReference__idfsDataAuditObjectType_R_1555] FOREIGN KEY ([idfsDataAuditObjectType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tauDataAuditEvent_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tauDataAuditEvent_tstSite__idfsSite_R_1021] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tauDataAuditEvent_tstUserTable__idfUserID_R_1022] FOREIGN KEY ([idfUserID]) REFERENCES [dbo].[tstUserTable] ([idfUserID]) NOT FOR REPLICATION
);


GO


CREATE TRIGGER [dbo].[TR_tauDataAuditEvent_I_Delete] on [dbo].[tauDataAuditEvent]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfDataAuditEvent]) as
		(
			SELECT [idfDataAuditEvent] FROM deleted
			EXCEPT
			SELECT [idfDataAuditEvent] FROM inserted
		)
		
		UPDATE a
		SET datEnteringDate = getdate(),
			datModificationForArchiveDate = getdate()
		FROM dbo.tauDataAuditEvent as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfDataAuditEvent = b.idfDataAuditEvent;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Audit Events', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditEvent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Audit event identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditEvent', @level2type = N'COLUMN', @level2name = N'idfDataAuditEvent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Audit object type', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditEvent', @level2type = N'COLUMN', @level2name = N'idfsDataAuditObjectType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Audit event type', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditEvent', @level2type = N'COLUMN', @level2name = N'idfsDataAuditEventType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Main audit object identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditEvent', @level2type = N'COLUMN', @level2name = N'idfMainObject';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Main audit object table identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditEvent', @level2type = N'COLUMN', @level2name = N'idfMainObjectTable';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'User caused audit event identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditEvent', @level2type = N'COLUMN', @level2name = N'idfUserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Site event created on identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditEvent', @level2type = N'COLUMN', @level2name = N'idfsSite';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Date/time of event creation', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditEvent', @level2type = N'COLUMN', @level2name = N'datEnteringDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Host name caused event', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditEvent', @level2type = N'COLUMN', @level2name = N'strHostname';

