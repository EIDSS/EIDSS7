CREATE TABLE [dbo].[CampaignToSampleType] (
    [CampaignToSampleTypeUID] BIGINT           NOT NULL,
    [idfCampaign]             BIGINT           NOT NULL,
    [idfsSpeciesType]         BIGINT           NULL,
    [idfsSampleType]          BIGINT           NULL,
    [intOrder]                INT              CONSTRAINT [DF__CampaignT__intOr__6A07746E] DEFAULT ((0)) NOT NULL,
    [intPlannedNumber]        INT              NULL,
    [intRowStatus]            INT              CONSTRAINT [Def_CampaignToSampleType_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [DF__CampaignT__rowgu__6AFB98A7] DEFAULT (newid()) NOT NULL,
    [strMaintenanceFlag]      NVARCHAR (20)    NULL,
    [strReservedAttribute]    NVARCHAR (MAX)   NULL,
    [AuditCreateUser]         VARCHAR (100)    CONSTRAINT [DF__CampaignT__Audit__6BEFBCE0] DEFAULT (user_name()) NOT NULL,
    [AuditCreateDTM]          DATETIME         CONSTRAINT [DF__CampaignT__Audit__6CE3E119] DEFAULT (getdate()) NOT NULL,
    [AuditUpdateUser]         VARCHAR (100)    CONSTRAINT [DF__CampaignT__Audit__6DD80552] DEFAULT (user_name()) NOT NULL,
    [AuditUpdateDTM]          DATETIME         CONSTRAINT [DF__CampaignT__Audit__6ECC298B] DEFAULT (getdate()) NOT NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKCampaignToSpecies] PRIMARY KEY CLUSTERED ([CampaignToSampleTypeUID] ASC),
    CONSTRAINT [FK_ampaignToSampleType_trtSampleType] FOREIGN KEY ([idfsSampleType]) REFERENCES [dbo].[trtSampleType] ([idfsSampleType]),
    CONSTRAINT [FK_ampaignToSampleType_trtSpeciesType] FOREIGN KEY ([idfsSpeciesType]) REFERENCES [dbo].[trtSpeciesType] ([idfsSpeciesType]),
    CONSTRAINT [FK_CampaignToSampleType_tlbCampaign] FOREIGN KEY ([idfCampaign]) REFERENCES [dbo].[tlbCampaign] ([idfCampaign]),
    CONSTRAINT [FK_CampaignToSampleType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_CampaignToSampleType_I_Delete] ON [dbo].[CampaignToSampleType]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([CampaignToSampleTypeUID]) as
		(
			SELECT [CampaignToSampleTypeUID] FROM deleted
			EXCEPT
			SELECT [CampaignToSampleTypeUID] FROM inserted
		)

		UPDATE a
		SET  intRowStatus = 1
		FROM dbo.CampaignToSampleType as a
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.CampaignToSampleTypeUID = b.CampaignToSampleTypeUID;
	END

END


GO

CREATE TRIGGER [dbo].[TR_CampaignToSampleType_A_Update] ON [dbo].[CampaignToSampleType]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF (dbo.FN_GBL_TriggersWork()=1 AND UPDATE(CampaignToSampleTypeUID))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
