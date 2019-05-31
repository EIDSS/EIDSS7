CREATE TABLE [dbo].[tauDataAuditDetailDelete] (
    [idfDataAuditEvent]        BIGINT           NULL,
    [idfObjectTable]           BIGINT           NULL,
    [idfObject]                BIGINT           NULL,
    [idfObjectDetail]          BIGINT           NULL,
    [idfDataAuditDetailDelete] UNIQUEIDENTIFIER CONSTRAINT [newid__idfDataAuditDetailDelete] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]       NVARCHAR (20)    NULL,
    [SourceSystemNameID]       BIGINT           NULL,
    [SourceSystemKeyValue]     NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtauDataAuditDetailDelete] PRIMARY KEY NONCLUSTERED ([idfDataAuditDetailDelete] ASC),
    CONSTRAINT [FK_tauDataAuditDetailDelete_tauDataAuditEvent__idfDataAuditEvent_R_1558] FOREIGN KEY ([idfDataAuditEvent]) REFERENCES [dbo].[tauDataAuditEvent] ([idfDataAuditEvent]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tauDataAuditDetailDelete_tauTable__idfObjectTable_R_1563] FOREIGN KEY ([idfObjectTable]) REFERENCES [dbo].[tauTable] ([idfTable]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tauDataAuditDetailDelete_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [IX_tauDataAuditDetailDelete_idfObject]
    ON [dbo].[tauDataAuditDetailDelete]([idfObject] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Object Deletion Audit ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailDelete';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Audit event identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailDelete', @level2type = N'COLUMN', @level2name = N'idfDataAuditEvent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Table identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailDelete', @level2type = N'COLUMN', @level2name = N'idfObjectTable';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Object identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailDelete', @level2type = N'COLUMN', @level2name = N'idfObject';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Corresponding Deleted object identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailDelete', @level2type = N'COLUMN', @level2name = N'idfObjectDetail';

