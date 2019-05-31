CREATE TABLE [dbo].[tauDataAuditDetailRestore] (
    [idfDataAuditEvent]         BIGINT           NULL,
    [idfObjectTable]            BIGINT           NULL,
    [idfObject]                 BIGINT           NULL,
    [idfObjectDetail]           BIGINT           NULL,
    [idfDataAuditDetailRestore] UNIQUEIDENTIFIER DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]        NVARCHAR (20)    NULL,
    [SourceSystemNameID]        BIGINT           NULL,
    [SourceSystemKeyValue]      NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKidfDataAuditDetailRestore] PRIMARY KEY NONCLUSTERED ([idfDataAuditDetailRestore] ASC),
    CONSTRAINT [FK_tauDataAuditDetailRestore_tauDataAuditEvent__idfDataAuditEvent_R_1558] FOREIGN KEY ([idfDataAuditEvent]) REFERENCES [dbo].[tauDataAuditEvent] ([idfDataAuditEvent]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tauDataAuditDetailRestore_tauTable__idfObjectTable_R_1563] FOREIGN KEY ([idfObjectTable]) REFERENCES [dbo].[tauTable] ([idfTable]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tauDataAuditDetailRestore_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [IX_tauDataAuditDetailRestore_idfObject]
    ON [dbo].[tauDataAuditDetailRestore]([idfObject] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Deleted object resoring audit ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailRestore';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Audit event identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailRestore', @level2type = N'COLUMN', @level2name = N'idfDataAuditEvent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Table identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailRestore', @level2type = N'COLUMN', @level2name = N'idfObjectTable';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Object identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailRestore', @level2type = N'COLUMN', @level2name = N'idfObject';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Corresponding Deleted object identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailRestore', @level2type = N'COLUMN', @level2name = N'idfObjectDetail';

