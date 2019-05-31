CREATE TABLE [dbo].[HumanDiseaseReportRelationship] (
    [HumanDiseasereportRelnUID]    BIGINT           NOT NULL,
    [HumanDiseaseReportID]         BIGINT           NOT NULL,
    [RelateToHumanDiseaseReportID] BIGINT           NOT NULL,
    [RelationshipTypeID]           BIGINT           NOT NULL,
    [intRowStatus]                 INT              CONSTRAINT [Def_HumanDiseaseReportRelationship_intRowStatus] DEFAULT ((0)) NULL,
    [AuditCreateUser]              VARCHAR (100)    CONSTRAINT [DF__HumanDise__Audit__46F49AB2] DEFAULT (user_name()) NOT NULL,
    [AuditCreateDTM]               DATETIME         CONSTRAINT [DF__HumanDise__Audit__47E8BEEB] DEFAULT (getdate()) NOT NULL,
    [AuditUpdateUser]              VARCHAR (100)    CONSTRAINT [DF__HumanDise__Audit__48DCE324] DEFAULT (user_name()) NOT NULL,
    [AuditUpdateDTM]               DATETIME         CONSTRAINT [DF__HumanDise__Audit__49D1075D] DEFAULT (getdate()) NOT NULL,
    [rowguid]                      UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]           BIGINT           NULL,
    [SourceSystemKeyValue]         NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKHumanDiseaseReportRelationship] PRIMARY KEY CLUSTERED ([HumanDiseasereportRelnUID] ASC),
    CONSTRAINT [FK_HumanDiseaseReportRelationship_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_HumanDiseaseReportReln_BaseRef_RelTypeID] FOREIGN KEY ([RelationshipTypeID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_HumanDiseaseReportReln_tlbHumanCase_HumanDiseaseReportID] FOREIGN KEY ([HumanDiseaseReportID]) REFERENCES [dbo].[tlbHumanCase] ([idfHumanCase]),
    CONSTRAINT [FK_HumanDiseaseReportReln_tlbHumanCase_RelateToHumanDiseaseReportID] FOREIGN KEY ([RelateToHumanDiseaseReportID]) REFERENCES [dbo].[tlbHumanCase] ([idfHumanCase])
);


GO

CREATE TRIGGER [dbo].[TR_HumanDiseaseReportRelationship_A_Update] ON [dbo].[HumanDiseaseReportRelationship]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(HumanDiseasereportRelnUID))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_HumanDiseaseReportRelationship_I_Delete] on [dbo].[HumanDiseaseReportRelationship]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([HumanDiseasereportRelnUID]) as
		(
			SELECT [HumanDiseasereportRelnUID] FROM deleted
			EXCEPT
			SELECT [HumanDiseasereportRelnUID] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1,
			AuditUpdateUser = SYSTEM_USER,
			AuditUpdateDTM = GETDATE()
		FROM dbo.HumanDiseaseReportRelationship as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.[HumanDiseasereportRelnUID] = b.[HumanDiseasereportRelnUID];

	END

END
