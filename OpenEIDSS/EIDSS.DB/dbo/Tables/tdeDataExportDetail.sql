CREATE TABLE [dbo].[tdeDataExportDetail] (
    [idfDataExportDetail]        BIGINT           NOT NULL,
    [idfsDataExportDetailStatus] BIGINT           NULL,
    [idfsDiagnosis]              BIGINT           NULL,
    [idfDataExport]              BIGINT           NOT NULL,
    [idfCase]                    BIGINT           NOT NULL,
    [datActivityDate]            DATETIME         NULL,
    [strXMLActivityHash]         NVARCHAR (200)   NULL,
    [rowguid]                    UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]         BIGINT           NULL,
    [SourceSystemKeyValue]       NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtdeDataExportDetail] PRIMARY KEY CLUSTERED ([idfDataExportDetail] ASC),
    CONSTRAINT [FK_tdeDataExportDetail_tdeDataExport__idfDataExport_R_1001] FOREIGN KEY ([idfDataExport]) REFERENCES [dbo].[tdeDataExport] ([idfDataExport]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tdeDataExportDetail_trtBaseReference__idfsDataExportDetailStatus_R_1582] FOREIGN KEY ([idfsDataExportDetailStatus]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tdeDataExportDetail_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tdeDataExportDetail_trtDiagnosis__idfsDiagnosis_R_1003] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tdeDataExportDetail_A_Update] ON [dbo].[tdeDataExportDetail]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfDataExportDetail))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'WHO Module export details', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExportDetail';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Detailed information identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExportDetail', @level2type = N'COLUMN', @level2name = N'idfDataExportDetail';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Data export operation type (deletion/addition/change)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExportDetail', @level2type = N'COLUMN', @level2name = N'idfsDataExportDetailStatus';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Exported case Diagnosis identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExportDetail', @level2type = N'COLUMN', @level2name = N'idfsDiagnosis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Data export operation identifier ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExportDetail', @level2type = N'COLUMN', @level2name = N'idfDataExport';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Case exported identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExportDetail', @level2type = N'COLUMN', @level2name = N'idfCase';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Date/time of export performed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExportDetail', @level2type = N'COLUMN', @level2name = N'datActivityDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Hash-stamp of the case exported data', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tdeDataExportDetail', @level2type = N'COLUMN', @level2name = N'strXMLActivityHash';

