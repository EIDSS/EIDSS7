CREATE TABLE [dbo].[tauTable] (
    [idfTable]             BIGINT           NOT NULL,
    [strName]              NVARCHAR (200)   NULL,
    [strDescription]       NVARCHAR (200)   NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1964] DEFAULT (newid()) ROWGUIDCOL NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtauTable] PRIMARY KEY CLUSTERED ([idfTable] ASC),
    CONSTRAINT [FK_tauTable_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Audit Tables', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauTable';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Audited table identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauTable', @level2type = N'COLUMN', @level2name = N'idfTable';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Audited table name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauTable', @level2type = N'COLUMN', @level2name = N'strName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Description', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tauTable', @level2type = N'COLUMN', @level2name = N'strDescription';

