CREATE TABLE [dbo].[trtDiagnosisAgeGroupToDiagnosis] (
    [idfDiagnosisAgeGroupToDiagnosis] BIGINT           NOT NULL,
    [idfsDiagnosis]                   BIGINT           NOT NULL,
    [idfsDiagnosisAgeGroup]           BIGINT           NULL,
    [intRowStatus]                    INT              CONSTRAINT [Def_0_trtDiagnosisAgeGroupToDiagnosis] DEFAULT ((0)) NOT NULL,
    [rowguid]                         UNIQUEIDENTIFIER CONSTRAINT [newid_trtDiagnosisAgeGroupToDiagnosis] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]              NVARCHAR (20)    NULL,
    [strReservedAttribute]            NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]              BIGINT           NULL,
    [SourceSystemKeyValue]            NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtDiagnosisAgeGroupToDiagnosis] PRIMARY KEY CLUSTERED ([idfDiagnosisAgeGroupToDiagnosis] ASC),
    CONSTRAINT [FK_trtDiagnosisAgeGroupToDiagnosis_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtDiagnosisAgeGroupToDiagnosis_trtDiagnosis_idfsDiagnosis] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtDiagnosisAgeGroupToDiagnosis_trtDiagnosisAgeGroup_idfsDiagnosisAgeGroup] FOREIGN KEY ([idfsDiagnosisAgeGroup]) REFERENCES [dbo].[trtDiagnosisAgeGroup] ([idfsDiagnosisAgeGroup]) NOT FOR REPLICATION
);


GO


CREATE TRIGGER [dbo].[TR_trtDiagnosisAgeGroupToDiagnosis_I_Delete] on [dbo].[trtDiagnosisAgeGroupToDiagnosis]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfDiagnosisAgeGroupToDiagnosis]) as
		(
			SELECT [idfDiagnosisAgeGroupToDiagnosis] FROM deleted
			EXCEPT
			SELECT [idfDiagnosisAgeGroupToDiagnosis] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtDiagnosisAgeGroupToDiagnosis as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfDiagnosisAgeGroupToDiagnosis = b.idfDiagnosisAgeGroupToDiagnosis;

	END

END

GO

CREATE TRIGGER [dbo].[TR_trtDiagnosisAgeGroupToDiagnosis_A_Update] ON [dbo].[trtDiagnosisAgeGroupToDiagnosis]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfDiagnosisAgeGroupToDiagnosis))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
