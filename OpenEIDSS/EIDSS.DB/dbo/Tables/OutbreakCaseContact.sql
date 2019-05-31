CREATE TABLE [dbo].[OutbreakCaseContact] (
    [OutbreakCaseContactUID]      BIGINT           NOT NULL,
    [OutBreakCaseReportUID]       BIGINT           NULL,
    [ContactTypeID]               BIGINT           NULL,
    [ContactedHumanCasePersonID]  BIGINT           NULL,
    [idfHuman]                    BIGINT           NULL,
    [ContactRelationshipTypeID]   BIGINT           NULL,
    [DateOfLastContact]           DATETIME         NULL,
    [PlaceOfLastContact]          NVARCHAR (200)   NULL,
    [CommentText]                 NVARCHAR (500)   NULL,
    [ContactStatusID]             BIGINT           NULL,
    [ContactTracingObservationID] BIGINT           NULL,
    [intRowStatus]                INT              CONSTRAINT [Def_OutbreakCaseContact_intRowStatus] DEFAULT ((0)) NOT NULL,
    [AuditCreateUser]             VARCHAR (100)    NOT NULL,
    [AuditCreateDTM]              DATETIME         CONSTRAINT [DF__OutbreakC__Audit__58F2C25C] DEFAULT (getdate()) NOT NULL,
    [AuditUpdateUser]             VARCHAR (100)    NULL,
    [AuditUpdateDTM]              DATETIME         NULL,
    [rowguid]                     UNIQUEIDENTIFIER CONSTRAINT [DF_OutbreakCaseContact_rowguid] DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]          BIGINT           NULL,
    [SourceSystemKeyValue]        NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKOutbreakContact] PRIMARY KEY CLUSTERED ([OutbreakCaseContactUID] ASC),
    CONSTRAINT [FK_OutbreakCaseContact_OutbreakCase_OutbreakCaseReportUID] FOREIGN KEY ([OutBreakCaseReportUID]) REFERENCES [dbo].[OutbreakCaseReport] ([OutBreakCaseReportUID]),
    CONSTRAINT [FK_OutbreakCaseContact_tlbContactedCasePerson_idfContactedCasePersonID] FOREIGN KEY ([ContactedHumanCasePersonID]) REFERENCES [dbo].[tlbContactedCasePerson] ([idfContactedCasePerson]),
    CONSTRAINT [FK_OutbreakCaseContact_tlbHuman_idfHuman] FOREIGN KEY ([idfHuman]) REFERENCES [dbo].[tlbHuman] ([idfHuman]),
    CONSTRAINT [FK_OutbreakCaseContact_tlbObservation_ContactTracingObservationID] FOREIGN KEY ([ContactTracingObservationID]) REFERENCES [dbo].[tlbObservation] ([idfObservation]),
    CONSTRAINT [FK_OutbreakCaseContact_trtBaseReference_ContactRelationshipTypeID] FOREIGN KEY ([ContactRelationshipTypeID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_OutbreakCaseContact_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_OutbreakCaseContact_A_Update] ON [dbo].[OutbreakCaseContact]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(OutbreakCaseContactUID)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO



CREATE TRIGGER [dbo].[TR_OutbreakCaseContact_I_Delete] ON [dbo].[OutbreakCaseContact]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([OutbreakCaseContactUID]) AS
		(
			SELECT [OutbreakCaseContactUID] FROM deleted
			EXCEPT
			SELECT [OutbreakCaseContactUID] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1,
			AuditUpdateUser = SYSTEM_USER,
			AuditUpdateDTM = GETDATE()
		FROM dbo.[OutbreakCaseContact] AS a 
		INNER JOIN cteOnlyDeletedRows AS b 
			ON a.[OutbreakCaseContactUID] = b.[OutbreakCaseContactUID];

	END

END
