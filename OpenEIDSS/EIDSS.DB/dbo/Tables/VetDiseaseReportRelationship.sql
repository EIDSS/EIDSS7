CREATE TABLE [dbo].[VetDiseaseReportRelationship] (
    [VetDiseaseReportRelnUID]     BIGINT           NOT NULL,
    [VetDiseaseReportID]          BIGINT           NOT NULL,
    [RelatedToVetDiseaseReportID] BIGINT           NOT NULL,
    [RelationshipTypeID]          BIGINT           NOT NULL,
    [intRowStatus]                INT              CONSTRAINT [Def_VetDiseaseReportRelationship_intRowStatus] DEFAULT ((0)) NULL,
    [AuditCreateUser]             VARCHAR (100)    CONSTRAINT [DF__VetDiseas__Audit__3E5F54B1] DEFAULT (user_name()) NOT NULL,
    [AuditCreateDTM]              DATETIME         CONSTRAINT [DF__VetDiseas__Audit__3F5378EA] DEFAULT (getdate()) NOT NULL,
    [AuditUpdateUser]             VARCHAR (100)    CONSTRAINT [DF__VetDiseas__Audit__40479D23] DEFAULT (user_name()) NOT NULL,
    [AuditUpdateDTM]              DATETIME         CONSTRAINT [DF__VetDiseas__Audit__413BC15C] DEFAULT (getdate()) NOT NULL,
    [rowguid]                     UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]          BIGINT           NULL,
    [SourceSystemKeyValue]        NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKVetCaseReln] PRIMARY KEY CLUSTERED ([VetDiseaseReportRelnUID] ASC),
    CONSTRAINT [FK_VetDiseaseReportRelationship_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_VetDiseaseReportReln_BaseRef_RelTypeID] FOREIGN KEY ([RelationshipTypeID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_VetDiseaseReportReln_tlbVetCase_RelateToVetDiseaseReportID] FOREIGN KEY ([RelatedToVetDiseaseReportID]) REFERENCES [dbo].[tlbVetCase] ([idfVetCase]),
    CONSTRAINT [FK_VetDiseaseReportReln_tlbVetCase_VetDiseaseReportID] FOREIGN KEY ([VetDiseaseReportID]) REFERENCES [dbo].[tlbVetCase] ([idfVetCase])
);


GO

CREATE TRIGGER [dbo].[TR_VetDiseaseReportRelationship_A_Update] ON [dbo].[VetDiseaseReportRelationship]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([VetDiseaseReportRelnUID]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
