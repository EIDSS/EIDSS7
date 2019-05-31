CREATE TABLE [dbo].[tauColumn] (
    [idfColumn]            BIGINT           NOT NULL,
    [idfTable]             BIGINT           NOT NULL,
    [strName]              NVARCHAR (200)   NULL,
    [strDescription]       NVARCHAR (200)   NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1965] DEFAULT (newid()) ROWGUIDCOL NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtauColumn] PRIMARY KEY CLUSTERED ([idfColumn] ASC),
    CONSTRAINT [FK_tauColumn_tauTable__idfTable_R_1559] FOREIGN KEY ([idfTable]) REFERENCES [dbo].[tauTable] ([idfTable]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tauColumn_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Table fields for audit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauColumn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Column identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauColumn', @level2type = N'COLUMN', @level2name = N'idfColumn';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Containing Table identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauColumn', @level2type = N'COLUMN', @level2name = N'idfTable';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Column name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauColumn', @level2type = N'COLUMN', @level2name = N'strName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Column description', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauColumn', @level2type = N'COLUMN', @level2name = N'strDescription';

