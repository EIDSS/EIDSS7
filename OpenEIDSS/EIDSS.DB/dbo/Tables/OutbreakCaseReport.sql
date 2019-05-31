CREATE TABLE [dbo].[OutbreakCaseReport] (
    [OutBreakCaseReportUID]        BIGINT           NOT NULL,
    [idfOutbreak]                  BIGINT           NULL,
    [strOutbreakCaseID]            NVARCHAR (200)   NULL,
    [idfHumanCase]                 BIGINT           NULL,
    [idfVetCase]                   BIGINT           NULL,
    [OutbreakCaseObservationID]    BIGINT           NULL,
    [CaseMonitoringObservationID]  BIGINT           NULL,
    [OutbreakCaseStatusID]         BIGINT           NULL,
    [OutbreakCaseClassificationID] BIGINT           NULL,
    [IsPrimaryCaseFlag]            VARCHAR (1)      NULL,
    [intRowStatus]                 INT              CONSTRAINT [Def_OutbreakCaseReport_intRowStatus] DEFAULT ((0)) NOT NULL,
    [AuditCreateUser]              VARCHAR (100)    NOT NULL,
    [AuditCreateDTM]               DATETIME         CONSTRAINT [DF__OutbreakC__Audit__17507488] DEFAULT (getdate()) NOT NULL,
    [AuditUpdateUser]              VARCHAR (100)    NULL,
    [AuditUpdateDTM]               DATETIME         NULL,
    [rowguid]                      UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]           BIGINT           NULL,
    [SourceSystemKeyValue]         NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKOutBreakCase] PRIMARY KEY CLUSTERED ([OutBreakCaseReportUID] ASC),
    CONSTRAINT [FK_OutbreakCase_tlbHUmanCase_idfHumanCaseID] FOREIGN KEY ([idfHumanCase]) REFERENCES [dbo].[tlbHumanCase] ([idfHumanCase]),
    CONSTRAINT [FK_OutbreakCase_tlbObservation_CaseMonitoringObservationID] FOREIGN KEY ([CaseMonitoringObservationID]) REFERENCES [dbo].[tlbObservation] ([idfObservation]),
    CONSTRAINT [FK_OutbreakCase_tlbOutbreak_idfOutbreakID] FOREIGN KEY ([idfOutbreak]) REFERENCES [dbo].[tlbOutbreak] ([idfOutbreak]),
    CONSTRAINT [FK_OutbreakCase_tlbVetCase_idfVetCaseID] FOREIGN KEY ([idfVetCase]) REFERENCES [dbo].[tlbVetCase] ([idfVetCase]),
    CONSTRAINT [FK_OutbreakCaseReport_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_OutbreatkCase_Observation_OutbreakCaseObservationID] FOREIGN KEY ([OutbreakCaseObservationID]) REFERENCES [dbo].[tlbObservation] ([idfObservation])
);


GO

CREATE TRIGGER [dbo].[TR_OutbreakCaseReport_A_Update] ON [dbo].[OutbreakCaseReport]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(OutbreakCaseReportUID)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_OutbreakCaseReport_I_Delete] on [dbo].[OutbreakCaseReport]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([OutBreakCaseReportUID]) as
		(
			SELECT [OutBreakCaseReportUID] FROM deleted
			EXCEPT
			SELECT [OutBreakCaseReportUID] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1,
			AuditUpdateUser = SYSTEM_USER,
			AuditUpdateDTM = GETDATE()
		FROM dbo.[OutbreakCaseReport] as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.[OutBreakCaseReportUID] = b.[OutBreakCaseReportUID];

	END

END
