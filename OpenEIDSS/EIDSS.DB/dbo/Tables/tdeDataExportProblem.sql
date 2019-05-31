CREATE TABLE [dbo].[tdeDataExportProblem] (
    [idfDataExportProblem] BIGINT           NOT NULL,
    [idfDataExport]        BIGINT           NOT NULL,
    [idfCase]              BIGINT           NOT NULL,
    [strDetail]            NVARCHAR (2000)  NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtdeDataExportProblem] PRIMARY KEY CLUSTERED ([idfDataExportProblem] ASC),
    CONSTRAINT [FK_tdeDataExportProblem_tdeDataExport__idfDataExport_R_1008] FOREIGN KEY ([idfDataExport]) REFERENCES [dbo].[tdeDataExport] ([idfDataExport]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tdeDataExportProblem_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tdeDataExportProblem_A_Update] ON [dbo].[tdeDataExportProblem]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfDataExportProblem))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'WHO Module export problems', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExportProblem';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Data export problem identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExportProblem', @level2type = N'COLUMN', @level2name = N'idfDataExportProblem';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Export operation identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExportProblem', @level2type = N'COLUMN', @level2name = N'idfDataExport';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Exported case identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExportProblem', @level2type = N'COLUMN', @level2name = N'idfCase';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Text description of the problem', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExportProblem', @level2type = N'COLUMN', @level2name = N'strDetail';

