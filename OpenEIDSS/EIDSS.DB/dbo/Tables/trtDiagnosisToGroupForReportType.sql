CREATE TABLE [dbo].[trtDiagnosisToGroupForReportType] (
    [idfsCustomReportType]             BIGINT           NOT NULL,
    [idfsReportDiagnosisGroup]         BIGINT           NOT NULL,
    [idfsDiagnosis]                    BIGINT           NOT NULL,
    [rowguid]                          UNIQUEIDENTIFIER CONSTRAINT [newid__2603] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfDiagnosisToGroupForReportType] BIGINT           NOT NULL,
    [strMaintenanceFlag]               NVARCHAR (20)    NULL,
    [strReservedAttribute]             NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]               BIGINT           NULL,
    [SourceSystemKeyValue]             NVARCHAR (MAX)   NULL,
    [intRowStatus]                     INT              CONSTRAINT [DF_trtDiagnosisToGroupForReportType_intRowStatus] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_trtDiagnosisToGroupForReportType] PRIMARY KEY CLUSTERED ([idfDiagnosisToGroupForReportType] ASC),
    CONSTRAINT [FK_trtDiagnosisToGroupForReportType_trtBaseReference__idfsCustomReportType_R_1871] FOREIGN KEY ([idfsCustomReportType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtDiagnosisToGroupForReportType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtDiagnosisToGroupForReportType_trtDiagnosis__idfsDiagnosis_R_1873] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtDiagnosisToGroupForReportType_trtReportDiagnosisGroup__idfsReportDiagnosisGroup] FOREIGN KEY ([idfsReportDiagnosisGroup]) REFERENCES [dbo].[trtReportDiagnosisGroup] ([idfsReportDiagnosisGroup]) NOT FOR REPLICATION,
    CONSTRAINT [UK_trtDiagnosisToGroupForReportType__idfsCustomReportType_idfsReportDiagnosisGroup_idfsDiagnosis] UNIQUE NONCLUSTERED ([idfsCustomReportType] ASC, [idfsReportDiagnosisGroup] ASC, [idfsDiagnosis] ASC)
);


GO

CREATE TRIGGER [dbo].[TR_trtDiagnosisToGroupForReportType_A_Update] ON [dbo].[trtDiagnosisToGroupForReportType]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfDiagnosisToGroupForReportType))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
