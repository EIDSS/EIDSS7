CREATE TABLE [dbo].[tlbBasicSyndromicSurveillance] (
    [idfBasicSyndromicSurveillance]          BIGINT           NOT NULL,
    [strFormID]                              NVARCHAR (200)   NOT NULL,
    [datDateEntered]                         DATETIME         NOT NULL,
    [datDateLastSaved]                       DATETIME         NOT NULL,
    [idfEnteredBy]                           BIGINT           NOT NULL,
    [idfsSite]                               BIGINT           CONSTRAINT [Def_fnSiteID_tlbBasicSyndromicSurveillance] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [idfsBasicSyndromicSurveillanceType]     BIGINT           NULL,
    [idfHospital]                            BIGINT           NULL,
    [datReportDate]                          DATETIME         NULL,
    [intAgeYear]                             INT              NULL,
    [intAgeMonth]                            INT              NULL,
    [intAgeFullYear]                         AS               (isnull([intAgeYear],(0))+isnull([intAgeMonth],(0))/(12)) PERSISTED,
    [intAgeFullMonth]                        AS               (isnull([intAgeYear],(0))*(12)+isnull([intAgeMonth],(0))) PERSISTED,
    [strPersonalID]                          NVARCHAR (100)   NULL,
    [idfsYNPregnant]                         BIGINT           NULL,
    [idfsYNPostpartumPeriod]                 BIGINT           NULL,
    [datDateOfSymptomsOnset]                 DATETIME         NULL,
    [idfsYNFever]                            BIGINT           NULL,
    [idfsMethodOfMeasurement]                BIGINT           NULL,
    [strMethod]                              NVARCHAR (500)   NULL,
    [idfsYNCough]                            BIGINT           NULL,
    [idfsYNShortnessOfBreath]                BIGINT           NULL,
    [idfsYNSeasonalFluVaccine]               BIGINT           NULL,
    [datDateOfCare]                          DATETIME         NULL,
    [idfsYNPatientWasHospitalized]           BIGINT           NULL,
    [idfsOutcome]                            BIGINT           NULL,
    [idfsYNPatientWasInER]                   BIGINT           NULL,
    [idfsYNTreatment]                        BIGINT           NULL,
    [idfsYNAdministratedAntiviralMedication] BIGINT           NULL,
    [strNameOfMedication]                    NVARCHAR (200)   NULL,
    [datDateReceivedAntiviralMedication]     DATETIME         NULL,
    [blnRespiratorySystem]                   BIT              CONSTRAINT [tlbBasicSyndromicSurveillance_blnRespiratorySystem] DEFAULT ((0)) NOT NULL,
    [blnAsthma]                              BIT              CONSTRAINT [tlbBasicSyndromicSurveillance_blnAsthma] DEFAULT ((0)) NOT NULL,
    [blnDiabetes]                            BIT              CONSTRAINT [tlbBasicSyndromicSurveillance_blnDiabetes] DEFAULT ((0)) NOT NULL,
    [blnCardiovascular]                      BIT              CONSTRAINT [tlbBasicSyndromicSurveillance_blnCardiovascular] DEFAULT ((0)) NOT NULL,
    [blnObesity]                             BIT              CONSTRAINT [tlbBasicSyndromicSurveillance_blnObesity] DEFAULT ((0)) NOT NULL,
    [blnRenal]                               BIT              CONSTRAINT [tlbBasicSyndromicSurveillance_blnRenal] DEFAULT ((0)) NOT NULL,
    [blnLiver]                               BIT              CONSTRAINT [tlbBasicSyndromicSurveillance_blnLiver] DEFAULT ((0)) NOT NULL,
    [blnNeurological]                        BIT              CONSTRAINT [tlbBasicSyndromicSurveillance_blnNeurological] DEFAULT ((0)) NOT NULL,
    [blnImmunodeficiency]                    BIT              CONSTRAINT [tlbBasicSyndromicSurveillance_blnImmunodeficiency] DEFAULT ((0)) NOT NULL,
    [blnUnknownEtiology]                     BIT              CONSTRAINT [tlbBasicSyndromicSurveillance_blnUnknownEtiology] DEFAULT ((0)) NOT NULL,
    [datSampleCollectionDate]                DATE             NULL,
    [strSampleID]                            NVARCHAR (200)   NULL,
    [idfsTestResult]                         BIGINT           NULL,
    [datTestResultDate]                      DATETIME         NULL,
    [idfHuman]                               BIGINT           NOT NULL,
    [datModificationForArchiveDate]          DATETIME         CONSTRAINT [tlbBasicSyndromicSurveillance_datModificationForArchiveDate] DEFAULT (getdate()) NULL,
    [intRowStatus]                           INT              CONSTRAINT [Def_tlbBasicSyndromicSurveillance_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]                                UNIQUEIDENTIFIER CONSTRAINT [Def_tlbBasicSyndromicSurveillance_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]                     NVARCHAR (20)    NULL,
    [strReservedAttribute]                   NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]                     BIGINT           NULL,
    [SourceSystemKeyValue]                   NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbBasicSyndromicSurveillance] PRIMARY KEY CLUSTERED ([idfBasicSyndromicSurveillance] ASC),
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_tlbHuman__idfHuman] FOREIGN KEY ([idfHuman]) REFERENCES [dbo].[tlbHuman] ([idfHuman]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_tlbOffice__idfHospital] FOREIGN KEY ([idfHospital]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_tlbPerson__idfEnteredBy] FOREIGN KEY ([idfEnteredBy]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_trtBaseReference__idfsBasicSyndromicSurveillanceType] FOREIGN KEY ([idfsBasicSyndromicSurveillanceType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_trtBaseReference__idfsMethodOfMeasurement] FOREIGN KEY ([idfsMethodOfMeasurement]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_trtBaseReference__idfsOutcome] FOREIGN KEY ([idfsOutcome]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_trtBaseReference__idfsTestResult] FOREIGN KEY ([idfsTestResult]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_trtBaseReference__idfsYNAdministratedAntiviralMedication] FOREIGN KEY ([idfsYNAdministratedAntiviralMedication]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_trtBaseReference__idfsYNCough] FOREIGN KEY ([idfsYNCough]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_trtBaseReference__idfsYNFever] FOREIGN KEY ([idfsYNFever]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_trtBaseReference__idfsYNPatientWasHospitalized] FOREIGN KEY ([idfsYNPatientWasHospitalized]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_trtBaseReference__idfsYNPatientWasInER] FOREIGN KEY ([idfsYNPatientWasInER]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_trtBaseReference__idfsYNPostpartumPeriod] FOREIGN KEY ([idfsYNPostpartumPeriod]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_trtBaseReference__idfsYNPregnant] FOREIGN KEY ([idfsYNPregnant]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_trtBaseReference__idfsYNSeasonalFluVaccine] FOREIGN KEY ([idfsYNSeasonalFluVaccine]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_trtBaseReference__idfsYNShortnessOfBreath] FOREIGN KEY ([idfsYNShortnessOfBreath]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_trtBaseReference__idfsYNTreatment] FOREIGN KEY ([idfsYNTreatment]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbBasicSyndromicSurveillance_tstSite__idfsSite] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO

-- =============================================
-- Author:		Romasheva Svetlana
-- Create date: 2013-09-24
-- Description:	Trigger for correct problems 
--              with replication and checkin in the same time
-- =============================================
CREATE TRIGGER [dbo].[trtBasicSyndromicSurveillanceReplicationUp] 
   ON  [dbo].[tlbBasicSyndromicSurveillance]
   for INSERT
   NOT FOR REPLICATION
AS 
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @context VARCHAR(50)
	SET @context = dbo.fnGetContext()

	delete  nID
	from  dbo.tflNewID as nID
		inner join inserted as ins
		on   ins.idfBasicSyndromicSurveillance = nID.idfKey1
	where  nID.strTableName = 'tflBasicSyndromicSurveillanceFiltered'

	insert into dbo.tflNewID 
		(
			strTableName, 
			idfKey1, 
			idfKey2
		)
	select  
			'tflBasicSyndromicSurveillanceFiltered', 
			ins.idfBasicSyndromicSurveillance, 
			sg.idfSiteGroup
	from  inserted as ins
		inner join dbo.tflSiteToSiteGroup as stsg
		on   stsg.idfsSite = ins.idfsSite
		
		inner join dbo.tflSiteGroup sg
		on	sg.idfSiteGroup = stsg.idfSiteGroup
			and sg.idfsRayon is null
			and sg.idfsCentralSite is null
			and sg.intRowStatus = 0
			
		left join dbo.tflBasicSyndromicSurveillanceFiltered as bsshf
		on  bsshf.idfBasicSyndromicSurveillance = ins.idfBasicSyndromicSurveillance
			and bsshf.idfSiteGroup = sg.idfSiteGroup
	where  bsshf.idfBasicSyndromicSurveillanceFiltered is null

	insert into dbo.tflBasicSyndromicSurveillanceFiltered 
		(
			idfBasicSyndromicSurveillanceFiltered, 
			idfBasicSyndromicSurveillance, 
			idfSiteGroup
		)
	select 
			nID.NewID, 
			ins.idfBasicSyndromicSurveillance, 
			nID.idfKey2
	from  inserted as ins
		inner join dbo.tflNewID as nID
		on  nID.strTableName = 'tflBasicSyndromicSurveillanceFiltered'
			and nID.idfKey1 = ins.idfBasicSyndromicSurveillance
			and nID.idfKey2 is not null
		left join dbo.tflBasicSyndromicSurveillanceFiltered as bsshf
		on   bsshf.idfBasicSyndromicSurveillanceFiltered = nID.NewID
	where  bsshf.idfBasicSyndromicSurveillanceFiltered is null

	delete  nID
	from  dbo.tflNewID as nID
		inner join inserted as ins
		on   ins.idfBasicSyndromicSurveillance = nID.idfKey1
	where  nID.strTableName = 'tflBasicSyndromicSurveillanceFiltered'
	

	SET NOCOUNT OFF;
END



GO

CREATE TRIGGER [dbo].[TR_tlbBasicSyndromicSurveillance_A_Update] ON [dbo].[tlbBasicSyndromicSurveillance]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfBasicSyndromicSurveillance))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbBasicSyndromicSurveillance_I_Delete] on [dbo].[tlbBasicSyndromicSurveillance]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfBasicSyndromicSurveillance]) as
		(
			SELECT [idfBasicSyndromicSurveillance] FROM deleted
			EXCEPT
			SELECT [idfBasicSyndromicSurveillance] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1,
			datModificationForArchiveDate = getdate()
		FROM dbo.tlbBasicSyndromicSurveillance as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfBasicSyndromicSurveillance = b.idfBasicSyndromicSurveillance;

	END

END
