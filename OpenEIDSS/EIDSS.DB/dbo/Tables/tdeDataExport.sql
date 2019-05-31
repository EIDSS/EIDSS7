CREATE TABLE [dbo].[tdeDataExport] (
    [idfDataExport]        BIGINT           NOT NULL,
    [idfUserID]            BIGINT           NULL,
    [datExportDate]        DATETIME         NULL,
    [strNote]              NVARCHAR (200)   NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtdeDataExport] PRIMARY KEY CLUSTERED ([idfDataExport] ASC),
    CONSTRAINT [FK_tdeDataExport_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tdeDataExport_tstUserTable__idfUserID_R_1004] FOREIGN KEY ([idfUserID]) REFERENCES [dbo].[tstUserTable] ([idfUserID]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tdeDataExport_A_Update] ON [dbo].[tdeDataExport]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfDataExport))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'WHO Module exports performed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExport';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Data export operation identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExport', @level2type = N'COLUMN', @level2name = N'idfDataExport';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'User initiated data export operation identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExport', @level2type = N'COLUMN', @level2name = N'idfUserID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Date/time of data export operation', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExport', @level2type = N'COLUMN', @level2name = N'datExportDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Data export operation notes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExport', @level2type = N'COLUMN', @level2name = N'strNote';

