CREATE TABLE [dbo].[tlbChangeDiagnosisHistory] (
    [idfChangeDiagnosisHistory] BIGINT           NOT NULL,
    [idfHumanCase]              BIGINT           NOT NULL,
    [idfsPreviousDiagnosis]     BIGINT           NULL,
    [idfsCurrentDiagnosis]      BIGINT           NULL,
    [datChangedDate]            DATETIME         NOT NULL,
    [strReason]                 NVARCHAR (2000)  NOT NULL,
    [intRowStatus]              INT              CONSTRAINT [Def_0_2664] DEFAULT ((0)) NOT NULL,
    [rowguid]                   UNIQUEIDENTIFIER CONSTRAINT [newid__2539] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfsChangeDiagnosisReason] BIGINT           NULL,
    [strMaintenanceFlag]        NVARCHAR (20)    NULL,
    [strReservedAttribute]      NVARCHAR (MAX)   NULL,
    [idfPerson]                 BIGINT           NOT NULL,
    [SourceSystemNameID]        BIGINT           NULL,
    [SourceSystemKeyValue]      NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbChangeDiagnosisHistory] PRIMARY KEY CLUSTERED ([idfChangeDiagnosisHistory] ASC),
    CONSTRAINT [FK_tlbChangeDiagnosisHistory_tlbHumanCase__idfHumanCase_R_1797] FOREIGN KEY ([idfHumanCase]) REFERENCES [dbo].[tlbHumanCase] ([idfHumanCase]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbChangeDiagnosisHistory_tlbPerson__idfPerson] FOREIGN KEY ([idfPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbChangeDiagnosisHistory_trtBaseReference_idfsChangeDiagnosisReason] FOREIGN KEY ([idfsChangeDiagnosisReason]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbChangeDiagnosisHistory_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbChangeDiagnosisHistory_trtDiagnosis__idfsCurrentDiagnosis_R_1799] FOREIGN KEY ([idfsCurrentDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbChangeDiagnosisHistory_trtDiagnosis__idfsPreviousDiagnosis_R_1798] FOREIGN KEY ([idfsPreviousDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tlbChangeDiagnosisHistory_A_Update] ON [dbo].[tlbChangeDiagnosisHistory]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfChangeDiagnosisHistory))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbChangeDiagnosisHistory_I_Delete] on [dbo].[tlbChangeDiagnosisHistory]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfChangeDiagnosisHistory]) as
		(
			SELECT [idfChangeDiagnosisHistory] FROM deleted
			EXCEPT
			SELECT [idfChangeDiagnosisHistory] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbChangeDiagnosisHistory as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfChangeDiagnosisHistory = b.idfChangeDiagnosisHistory;

	END

END
