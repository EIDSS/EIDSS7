CREATE TABLE [dbo].[trtFFObjectToDiagnosisForCustomReport] (
    [idfFFObjectToDiagnosisForCustomReport] BIGINT           NOT NULL,
    [idfsDiagnosis]                         BIGINT           NOT NULL,
    [idfFFObjectForCustomReport]            BIGINT           NOT NULL,
    [intRowStatus]                          INT              CONSTRAINT [Def_trtFFParameterToDiagnosisForCustomReport_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]                               UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]                    NVARCHAR (20)    NULL,
    [strReservedAttribute]                  NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]                    BIGINT           NULL,
    [SourceSystemKeyValue]                  NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_trtFFObjectToDiagnosisForCustomReport] PRIMARY KEY CLUSTERED ([idfFFObjectToDiagnosisForCustomReport] ASC),
    CONSTRAINT [FK_trtFFObjectToDiagnosisForCustomReport_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtFFObjectToDiagnosisForCustomReport_trtDiagnosis] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtFFParameterToDiagnosisForCustomReport_trtFFParameterForCustomReport] FOREIGN KEY ([idfFFObjectForCustomReport]) REFERENCES [dbo].[trtFFObjectForCustomReport] ([idfFFObjectForCustomReport]) NOT FOR REPLICATION,
    CONSTRAINT [UQ_trtFFObjectToDiagnosisForCustomReport] UNIQUE NONCLUSTERED ([idfsDiagnosis] ASC, [idfFFObjectForCustomReport] ASC)
);


GO


CREATE TRIGGER [dbo].[TR_trtFFObjectToDiagnosisForCustomReport_I_Delete] on [dbo].[trtFFObjectToDiagnosisForCustomReport]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfFFObjectToDiagnosisForCustomReport]) as
		(
			SELECT [idfFFObjectToDiagnosisForCustomReport] FROM deleted
			EXCEPT
			SELECT [idfFFObjectToDiagnosisForCustomReport] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtFFObjectToDiagnosisForCustomReport as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfFFObjectToDiagnosisForCustomReport = b.idfFFObjectToDiagnosisForCustomReport;

	END

END

GO

CREATE TRIGGER [dbo].[TR_trtFFObjectToDiagnosisForCustomReport_A_Update] ON [dbo].[trtFFObjectToDiagnosisForCustomReport]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfFFObjectToDiagnosisForCustomReport))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
