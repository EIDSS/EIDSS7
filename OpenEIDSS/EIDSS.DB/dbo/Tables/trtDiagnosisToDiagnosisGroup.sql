CREATE TABLE [dbo].[trtDiagnosisToDiagnosisGroup] (
    [idfDiagnosisToDiagnosisGroup] BIGINT           NOT NULL,
    [idfsDiagnosisGroup]           BIGINT           NOT NULL,
    [idfsDiagnosis]                BIGINT           NOT NULL,
    [intRowStatus]                 INT              CONSTRAINT [trtDiagnosisToDiagnosisGroup_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]                      UNIQUEIDENTIFIER CONSTRAINT [trtDiagnosisToDiagnosisGroup_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]           NVARCHAR (20)    NULL,
    [strReservedAttribute]         NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]           BIGINT           NULL,
    [SourceSystemKeyValue]         NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtDiagnosisToDiagnosisGroup] PRIMARY KEY CLUSTERED ([idfDiagnosisToDiagnosisGroup] ASC),
    CONSTRAINT [FK_trtDiagnosisToDiagnosisGroup_trtBaseReference__idfsDiagnosisGroup] FOREIGN KEY ([idfsDiagnosisGroup]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtDiagnosisToDiagnosisGroup_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtDiagnosisToDiagnosisGroup_trtDiagnosis__idfsDiagnosis] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtDiagnosisToDiagnosisGroup_A_Update] ON [dbo].[trtDiagnosisToDiagnosisGroup]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfDiagnosisToDiagnosisGroup))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_trtDiagnosisToDiagnosisGroup_I_Delete] on [dbo].[trtDiagnosisToDiagnosisGroup]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfDiagnosisToDiagnosisGroup]) as
		(
			SELECT [idfDiagnosisToDiagnosisGroup] FROM deleted
			EXCEPT
			SELECT [idfDiagnosisToDiagnosisGroup] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtDiagnosisToDiagnosisGroup as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfDiagnosisToDiagnosisGroup = b.idfDiagnosisToDiagnosisGroup;

	END

END
