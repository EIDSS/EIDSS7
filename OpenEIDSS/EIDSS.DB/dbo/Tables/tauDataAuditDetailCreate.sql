CREATE TABLE [dbo].[tauDataAuditDetailCreate] (
    [idfDataAuditEvent]        BIGINT           NULL,
    [idfObjectTable]           BIGINT           NULL,
    [idfObject]                BIGINT           NULL,
    [idfObjectDetail]          BIGINT           NULL,
    [idfDataAuditDetailCreate] UNIQUEIDENTIFIER CONSTRAINT [newid__idfDataAuditDetailCreate] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]       NVARCHAR (20)    NULL,
    [SourceSystemNameID]       BIGINT           NULL,
    [SourceSystemKeyValue]     NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtauDataAuditDetailCreate] PRIMARY KEY NONCLUSTERED ([idfDataAuditDetailCreate] ASC),
    CONSTRAINT [FK_tauDataAuditDetailCreate_tauDataAuditEvent__idfDataAuditEvent_R_1024] FOREIGN KEY ([idfDataAuditEvent]) REFERENCES [dbo].[tauDataAuditEvent] ([idfDataAuditEvent]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tauDataAuditDetailCreate_tauTable__idfObjectTable_R_1561] FOREIGN KEY ([idfObjectTable]) REFERENCES [dbo].[tauTable] ([idfTable]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tauDataAuditDetailCreate_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [IX_tauDataAuditDetailCreate_idfObject]
    ON [dbo].[tauDataAuditDetailCreate]([idfObject] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tauDataAuditDetailCreate_idfDataAuditEvent_idfObjectTable]
    ON [dbo].[tauDataAuditDetailCreate]([idfDataAuditEvent] ASC, [idfObjectTable] ASC)
    INCLUDE([idfObject]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Object Creation Audit ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailCreate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Audit event identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailCreate', @level2type = N'COLUMN', @level2name = N'idfDataAuditEvent';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Table identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailCreate', @level2type = N'COLUMN', @level2name = N'idfObjectTable';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Object identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailCreate', @level2type = N'COLUMN', @level2name = N'idfObject';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Corresponding Created object identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauDataAuditDetailCreate', @level2type = N'COLUMN', @level2name = N'idfObjectDetail';

