CREATE TABLE [dbo].[tlbCampaign] (
    [idfCampaign]                   BIGINT           NOT NULL,
    [idfsCampaignType]              BIGINT           NULL,
    [idfsCampaignStatus]            BIGINT           NULL,
    [datCampaignDateStart]          DATETIME         NULL,
    [datCampaignDateEnd]            DATETIME         NULL,
    [strCampaignID]                 NVARCHAR (50)    NULL,
    [strCampaignName]               NVARCHAR (MAX)   NULL,
    [strCampaignAdministrator]      NVARCHAR (200)   NULL,
    [strComments]                   NVARCHAR (500)   NULL,
    [strConclusion]                 NVARCHAR (MAX)   NULL,
    [intRowStatus]                  INT              CONSTRAINT [Def_0_2642] DEFAULT ((0)) NOT NULL,
    [rowguid]                       UNIQUEIDENTIFIER CONSTRAINT [newid__2515] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [datModificationForArchiveDate] DATETIME         CONSTRAINT [tlbCampaign_datModificationForArchiveDate] DEFAULT (getdate()) NULL,
    [idfsSite]                      BIGINT           CONSTRAINT [Def_fnSiteID_tlbCampaign] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [strMaintenanceFlag]            NVARCHAR (20)    NULL,
    [strReservedAttribute]          NVARCHAR (MAX)   NULL,
    [idfsDiagnosis]                 BIGINT           NULL,
    [CampaignCategoryID]            BIGINT           NULL,
    [LegacyCampaignID]              VARCHAR (50)     NULL,
    [SourceSystemNameID]            BIGINT           NULL,
    [SourceSystemKeyValue]          NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbCampaign] PRIMARY KEY CLUSTERED ([idfCampaign] ASC),
    CONSTRAINT [FK_tlbCampaign_trtBaseRef_CampaignCategory] FOREIGN KEY ([CampaignCategoryID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbCampaign_trtBaseReference__idfsCampaignStatus_R_1737] FOREIGN KEY ([idfsCampaignStatus]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbCampaign_trtBaseReference__idfsCampaignType_R_1736] FOREIGN KEY ([idfsCampaignType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbCampaign_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbCampaign_trtDiagnosis_DiagnosisID] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]),
    CONSTRAINT [FK_tlbCampaign_tstSite__idfsSite] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO


CREATE TRIGGER [dbo].[TR_tlbCampaign_I_Delete] on [dbo].[tlbCampaign]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfCampaign]) as
		(
			SELECT [idfCampaign] FROM deleted
			EXCEPT
			SELECT [idfCampaign] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1,
			datModificationForArchiveDate = getdate()
		FROM dbo.tlbCampaign as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfCampaign = b.idfCampaign;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbCampaign_A_Update] ON [dbo].[tlbCampaign]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfCampaign))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
