CREATE TABLE [dbo].[tauDataAuditDetailUpdate] (
    [idfDataAuditEvent]        BIGINT           NULL,
    [idfObjectTable]           BIGINT           NULL,
    [idfColumn]                BIGINT           NULL,
    [idfObject]                BIGINT           NULL,
    [idfObjectDetail]          BIGINT           NULL,
    [strOldValue]              SQL_VARIANT      NULL,
    [strNewValue]              SQL_VARIANT      NULL,
    [idfDataAuditDetailUpdate] UNIQUEIDENTIFIER CONSTRAINT [newid__idfDataAuditDetailUpdate] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]       NVARCHAR (20)    NULL,
    [SourceSystemNameID]       BIGINT           NULL,
    [SourceSystemKeyValue]     NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtauDataAuditDetailUpdate] PRIMARY KEY NONCLUSTERED ([idfDataAuditDetailUpdate] ASC),
    CONSTRAINT [FK_tauDataAuditDetailUpdate_tauColumn__idfColumn_R_1564] FOREIGN KEY ([idfColumn]) REFERENCES [dbo].[tauColumn] ([idfColumn]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tauDataAuditDetailUpdate_tauDataAuditEvent__idfDataAuditEvent_R_1557] FOREIGN KEY ([idfDataAuditEvent]) REFERENCES [dbo].[tauDataAuditEvent] ([idfDataAuditEvent]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tauDataAuditDetailUpdate_tauTable__idfObjectTable_R_1562] FOREIGN KEY ([idfObjectTable]) REFERENCES [dbo].[tauTable] ([idfTable]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tauDataAuditDetailUpdate_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [IX_tauDataAuditDetailUpdate_idfObject]
    ON [dbo].[tauDataAuditDetailUpdate]([idfObject] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tauDataAuditDetailUpdate_idfDataAuditEvent_idfObjectTable_idfColumn]
    ON [dbo].[tauDataAuditDetailUpdate]([idfDataAuditEvent] ASC, [idfObjectTable] ASC, [idfColumn] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Object Change Audit ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailUpdate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Audit event identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailUpdate', @level2type = N'COLUMN', @level2name = N'idfDataAuditEvent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Table identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailUpdate', @level2type = N'COLUMN', @level2name = N'idfObjectTable';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Changed column identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailUpdate', @level2type = N'COLUMN', @level2name = N'idfColumn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Object identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailUpdate', @level2type = N'COLUMN', @level2name = N'idfObject';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Corresponding Changed object identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailUpdate', @level2type = N'COLUMN', @level2name = N'idfObjectDetail';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Old value', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailUpdate', @level2type = N'COLUMN', @level2name = N'strOldValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'New value', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailUpdate', @level2type = N'COLUMN', @level2name = N'strNewValue';

