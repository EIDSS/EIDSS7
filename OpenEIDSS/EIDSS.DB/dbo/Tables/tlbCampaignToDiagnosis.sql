CREATE TABLE [dbo].[tlbCampaignToDiagnosis] (
    [idfCampaignToDiagnosis] BIGINT           NOT NULL,
    [idfCampaign]            BIGINT           NOT NULL,
    [idfsDiagnosis]          BIGINT           NOT NULL,
    [intOrder]               INT              CONSTRAINT [Def_0_2637] DEFAULT ((0)) NOT NULL,
    [intRowStatus]           INT              CONSTRAINT [Def_0_2638] DEFAULT ((0)) NOT NULL,
    [rowguid]                UNIQUEIDENTIFIER CONSTRAINT [newid__2511] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intPlannedNumber]       INT              NULL,
    [idfsSpeciesType]        BIGINT           NULL,
    [strMaintenanceFlag]     NVARCHAR (20)    NULL,
    [strReservedAttribute]   NVARCHAR (MAX)   NULL,
    [idfsSampleType]         BIGINT           NULL,
    [SourceSystemNameID]     BIGINT           NULL,
    [SourceSystemKeyValue]   NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_tlbCampaignToDiagnosis] PRIMARY KEY CLUSTERED ([idfCampaignToDiagnosis] ASC),
    CONSTRAINT [FK_tlbCampaignToDiagnosis_tlbCampaign__idfCampaign_R_1738] FOREIGN KEY ([idfCampaign]) REFERENCES [dbo].[tlbCampaign] ([idfCampaign]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbCampaignToDiagnosis_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbCampaignToDiagnosis_trtDiagnosis__idfsDiagnosis_R_1739] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbCampaignToDiagnosis_trtSampleType__idfsSampleType] FOREIGN KEY ([idfsSampleType]) REFERENCES [dbo].[trtSampleType] ([idfsSampleType]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbCampaignToDiagnosis_trtSpeciesType__idfsSpeciesType] FOREIGN KEY ([idfsSpeciesType]) REFERENCES [dbo].[trtSpeciesType] ([idfsSpeciesType]) NOT FOR REPLICATION
);


GO


CREATE TRIGGER [dbo].[TR_tlbCampaignToDiagnosis_I_Delete] on [dbo].[tlbCampaignToDiagnosis]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfCampaignToDiagnosis]) as
		(
			SELECT [idfCampaignToDiagnosis] FROM deleted
			EXCEPT
			SELECT [idfCampaignToDiagnosis] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbCampaignToDiagnosis as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfCampaignToDiagnosis = b.idfCampaignToDiagnosis;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbCampaignToDiagnosis_A_Update] ON [dbo].[tlbCampaignToDiagnosis]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfCampaignToDiagnosis))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
