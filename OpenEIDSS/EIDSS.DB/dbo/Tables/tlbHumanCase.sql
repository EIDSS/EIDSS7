CREATE TABLE [dbo].[tlbHumanCase] (
    [idfHumanCase]                          BIGINT           NOT NULL,
    [idfHuman]                              BIGINT           NOT NULL,
    [idfsFinalState]                        BIGINT           NULL,
    [idfsHospitalizationStatus]             BIGINT           NULL,
    [idfsHumanAgeType]                      BIGINT           NULL,
    [idfsYNAntimicrobialTherapy]            BIGINT           NULL,
    [idfsYNHospitalization]                 BIGINT           NULL,
    [idfsYNSpecimenCollected]               BIGINT           NULL,
    [idfsYNRelatedToOutbreak]               BIGINT           NULL,
    [idfsOutcome]                           BIGINT           NULL,
    [idfsTentativeDiagnosis]                BIGINT           NULL,
    [idfsFinalDiagnosis]                    BIGINT           NULL,
    [idfsInitialCaseStatus]                 BIGINT           NULL,
    [idfsFinalCaseStatus]                   BIGINT           NULL,
    [idfSentByOffice]                       BIGINT           NULL,
    [idfReceivedByOffice]                   BIGINT           NULL,
    [idfInvestigatedByOffice]               BIGINT           NULL,
    [idfPointGeoLocation]                   BIGINT           NULL,
    [idfEpiObservation]                     BIGINT           NULL,
    [idfCSObservation]                      BIGINT           NULL,
    [idfDeduplicationResultCase]            BIGINT           NULL,
    [datNotificationDate]                   DATETIME         NULL,
    [datCompletionPaperFormDate]            DATETIME         NULL,
    [datFirstSoughtCareDate]                DATETIME         NULL,
    [datModificationDate]                   DATETIME         NULL,
    [datHospitalizationDate]                DATETIME         NULL,
    [datFacilityLastVisit]                  DATETIME         NULL,
    [datExposureDate]                       DATETIME         NULL,
    [datDischargeDate]                      DATETIME         NULL,
    [datOnSetDate]                          DATETIME         NULL,
    [datInvestigationStartDate]             DATETIME         NULL,
    [datTentativeDiagnosisDate]             DATETIME         NULL,
    [datFinalDiagnosisDate]                 DATETIME         NULL,
    [strNote]                               NVARCHAR (2000)  NULL,
    [strCurrentLocation]                    NVARCHAR (200)   NULL,
    [strHospitalizationPlace]               NVARCHAR (200)   NULL,
    [strLocalIdentifier]                    NVARCHAR (200)   NULL,
    [strSoughtCareFacility]                 NVARCHAR (200)   NULL,
    [strSentByFirstName]                    NVARCHAR (200)   NULL,
    [strSentByPatronymicName]               NVARCHAR (200)   NULL,
    [strSentByLastName]                     NVARCHAR (200)   NULL,
    [strReceivedByFirstName]                NVARCHAR (200)   NULL,
    [strReceivedByPatronymicName]           NVARCHAR (200)   NULL,
    [strReceivedByLastName]                 NVARCHAR (200)   NULL,
    [strEpidemiologistsName]                NVARCHAR (200)   NULL,
    [strNotCollectedReason]                 NVARCHAR (200)   NULL,
    [strClinicalDiagnosis]                  NVARCHAR (200)   NULL,
    [strClinicalNotes]                      NVARCHAR (2000)  NULL,
    [strSummaryNotes]                       NVARCHAR (2000)  NULL,
    [intPatientAge]                         INT              NULL,
    [blnClinicalDiagBasis]                  BIT              CONSTRAINT [Def_0___2716] DEFAULT ((0)) NULL,
    [blnLabDiagBasis]                       BIT              CONSTRAINT [Def_0___2717] DEFAULT ((0)) NULL,
    [blnEpiDiagBasis]                       BIT              CONSTRAINT [Def_0___2718] DEFAULT ((0)) NULL,
    [rowguid]                               UNIQUEIDENTIFIER CONSTRAINT [newid__2472] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfPersonEnteredBy]                    BIGINT           NULL,
    [idfSentByPerson]                       BIGINT           NULL,
    [idfReceivedByPerson]                   BIGINT           NULL,
    [idfInvestigatedByPerson]               BIGINT           NULL,
    [idfsYNTestsConducted]                  BIGINT           NULL,
    [intRowStatus]                          INT              DEFAULT ((0)) NOT NULL,
    [idfSoughtCareFacility]                 BIGINT           NULL,
    [idfsNonNotifiableDiagnosis]            BIGINT           NULL,
    [idfsNotCollectedReason]                BIGINT           NULL,
    [idfOutbreak]                           BIGINT           NULL,
    [datEnteredDate]                        DATETIME         NULL,
    [strCaseID]                             NVARCHAR (200)   NULL,
    [idfsCaseProgressStatus]                BIGINT           NULL,
    [idfsSite]                              BIGINT           CONSTRAINT [Def_fnSiteID_tlbHumanCase] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [strSampleNotes]                        NVARCHAR (1000)  NULL,
    [datModificationForArchiveDate]         DATETIME         CONSTRAINT [tlbHumanCase_datModificationForArchiveDate] DEFAULT (getdate()) NULL,
    [uidOfflineCaseID]                      UNIQUEIDENTIFIER NULL,
    [datFinalCaseClassificationDate]        DATETIME         NULL,
    [idfHospital]                           BIGINT           NULL,
    [strMaintenanceFlag]                    NVARCHAR (20)    NULL,
    [strReservedAttribute]                  NVARCHAR (MAX)   NULL,
    [idfsYNSpecificVaccinationAdministered] BIGINT           NULL,
    [idfsYNPreviouslySoughtCare]            BIGINT           NULL,
    [idfsYNExposureLocationKnown]           BIGINT           NULL,
    [LegacyCaseID]                          NVARCHAR (200)   NULL,
    [DiseaseReportTypeID]                   BIGINT           NULL,
    [idfParentMonitoringSession]            BIGINT           NULL,
    [SourceSystemNameID]                    BIGINT           NULL,
    [SourceSystemKeyValue]                  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbHumanCase] PRIMARY KEY CLUSTERED ([idfHumanCase] ASC),
    CONSTRAINT [FK_HumanCase_BaseRef_ExposureLocationKnown] FOREIGN KEY ([idfsYNExposureLocationKnown]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_HumanCase_BaseRef_PreviouslySoughtCare] FOREIGN KEY ([idfsYNPreviouslySoughtCare]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_HumanCase_BaseRef_SpecificVaccinationAdministered] FOREIGN KEY ([idfsYNSpecificVaccinationAdministered]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbHumaCase_BaseRef_DiseaseReportTypeID] FOREIGN KEY ([DiseaseReportTypeID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbHumanCase_tlbGeoLocation__idfPointGeoLocation_R_1421] FOREIGN KEY ([idfPointGeoLocation]) REFERENCES [dbo].[tlbGeoLocation] ([idfGeoLocation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_tlbHuman] FOREIGN KEY ([idfHuman]) REFERENCES [dbo].[tlbHuman] ([idfHuman]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_tlbHumanCase__idfDeduplicationResultCase_R_1444] FOREIGN KEY ([idfDeduplicationResultCase]) REFERENCES [dbo].[tlbHumanCase] ([idfHumanCase]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_tlbMonitoringSession_ParentMonitoringSession] FOREIGN KEY ([idfParentMonitoringSession]) REFERENCES [dbo].[tlbMonitoringSession] ([idfMonitoringSession]),
    CONSTRAINT [FK_tlbHumanCase_tlbObservation__idfCSObservation_R_1416] FOREIGN KEY ([idfCSObservation]) REFERENCES [dbo].[tlbObservation] ([idfObservation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_tlbObservation__idfEpiObservation_R_1415] FOREIGN KEY ([idfEpiObservation]) REFERENCES [dbo].[tlbObservation] ([idfObservation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_tlbOffice__idfHospital] FOREIGN KEY ([idfHospital]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_tlbOffice__idfInvestigatedByOffice_R_1420] FOREIGN KEY ([idfInvestigatedByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_tlbOffice__idfReceivedByOffice_R_1419] FOREIGN KEY ([idfReceivedByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_tlbOffice__idfSentByOffice_R_1418] FOREIGN KEY ([idfSentByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_tlbOffice_idfSoughtCareFacility] FOREIGN KEY ([idfSoughtCareFacility]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_tlbOutbreak__idfOutbreak] FOREIGN KEY ([idfOutbreak]) REFERENCES [dbo].[tlbOutbreak] ([idfOutbreak]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_tlbPerson__idfInvestigatedByPerson] FOREIGN KEY ([idfInvestigatedByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_tlbPerson__idfReceivedByPerson] FOREIGN KEY ([idfReceivedByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_tlbPerson__idfSentByPerson] FOREIGN KEY ([idfSentByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_tlbPerson_idfPersonEnteredBy] FOREIGN KEY ([idfPersonEnteredBy]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_trtBaseReference__idfsCaseProgressStatus] FOREIGN KEY ([idfsCaseProgressStatus]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_trtBaseReference__idfsFinalCaseStatus_R_1676] FOREIGN KEY ([idfsFinalCaseStatus]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_trtBaseReference__idfsFinalState_R_1292] FOREIGN KEY ([idfsFinalState]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_trtBaseReference__idfsHospitalizationStatus_R_1269] FOREIGN KEY ([idfsHospitalizationStatus]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_trtBaseReference__idfsHumanAgeType_R_1247] FOREIGN KEY ([idfsHumanAgeType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_trtBaseReference__idfsInitialCaseStatus_R_1439] FOREIGN KEY ([idfsInitialCaseStatus]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_trtBaseReference__idfsOutcome_R_1414] FOREIGN KEY ([idfsOutcome]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_trtBaseReference__idfsYNAntimicrobialTherapy_R_1409] FOREIGN KEY ([idfsYNAntimicrobialTherapy]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_trtBaseReference__idfsYNHospitalization_R_1410] FOREIGN KEY ([idfsYNHospitalization]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_trtBaseReference__idfsYNRelatedToOutbreak_R_1413] FOREIGN KEY ([idfsYNRelatedToOutbreak]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_trtBaseReference__idfsYNSpecimenCollected_R_1411] FOREIGN KEY ([idfsYNSpecimenCollected]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_trtBaseReference__idfsYNTestsConducted] FOREIGN KEY ([idfsYNTestsConducted]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_trtBaseReference_idfsNonNotifiableDiagnosis] FOREIGN KEY ([idfsNonNotifiableDiagnosis]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_trtBaseReference_idfsNotCollectedReason] FOREIGN KEY ([idfsNotCollectedReason]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbHumanCase_trtDiagnosis__idfsFinalDiagnosis_R_1427] FOREIGN KEY ([idfsFinalDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_trtDiagnosis__idfsTentativeDiagnosis_R_1428] FOREIGN KEY ([idfsTentativeDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHumanCase_tstSite__idfsSite] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO
CREATE NONCLUSTERED INDEX [IX_tlbHumanCase_idfDeduplicationResultCase]
    ON [dbo].[tlbHumanCase]([idfDeduplicationResultCase] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tlbHumanCase_uidOfflineCaseID]
    ON [dbo].[tlbHumanCase]([uidOfflineCaseID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tlbHumanCase__strCaseID]
    ON [dbo].[tlbHumanCase]([strCaseID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tlbHumanCase_dates]
    ON [dbo].[tlbHumanCase]([datOnSetDate] ASC, [datFinalDiagnosisDate] ASC, [datTentativeDiagnosisDate] ASC, [datNotificationDate] ASC, [datEnteredDate] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tlbHumanCase__idfHuman_intRowStatus]
    ON [dbo].[tlbHumanCase]([idfHuman] ASC, [intRowStatus] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tlbHumanCase__datEnteredDate]
    ON [dbo].[tlbHumanCase]([datEnteredDate] ASC);


GO

CREATE TRIGGER [dbo].[TR_tlbHumanCase_A_Update] ON [dbo].[tlbHumanCase]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfHumanCase))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbHumanCase_I_Delete] on [dbo].[tlbHumanCase]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfHumanCase]) as
		(
			SELECT [idfHumanCase] FROM deleted
			EXCEPT
			SELECT [idfHumanCase] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1, 
			datModificationForArchiveDate = getdate()
		FROM dbo.tlbHumanCase as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfHumanCase = b.idfHumanCase;

	END

END

GO

-- =============================================
-- Author:		Romasheva Svetlana
-- Create date: May 19 2014  2:43PM
-- Description:	Trigger for correct problems 
--              with replication and checkin in the same time
-- =============================================
CREATE TRIGGER [dbo].[trtHumanCaseReplicationUp] 
   ON  [dbo].[tlbHumanCase]
   for INSERT
   NOT FOR REPLICATION
AS 
BEGIN
	SET NOCOUNT ON;
	
	--DECLARE @context VARCHAR(50)
	--SET @context = dbo.fnGetContext()

	delete  nID
	from  dbo.tflNewID as nID
		inner join inserted as ins
		on   ins.idfHumanCase = nID.idfKey1
	where  nID.strTableName = 'tflHumanCaseFiltered'

	insert into dbo.tflNewID 
		(
			strTableName, 
			idfKey1, 
			idfKey2
		)
	select  
			'tflHumanCaseFiltered', 
			ins.idfHumanCase, 
			sg.idfSiteGroup
	from  inserted as ins
		inner join dbo.tflSiteToSiteGroup as stsg
		on   stsg.idfsSite = ins.idfsSite
		
		inner join dbo.tflSiteGroup sg
		on	sg.idfSiteGroup = stsg.idfSiteGroup
			and sg.idfsRayon is null
			and sg.idfsCentralSite is null
			and sg.intRowStatus = 0
			
		left join dbo.tflHumanCaseFiltered as btf
		on  btf.idfHumanCase = ins.idfHumanCase
			and btf.idfSiteGroup = sg.idfSiteGroup
	where  btf.idfHumanCaseFiltered is null

	insert into dbo.tflHumanCaseFiltered
		(
			idfHumanCaseFiltered, 
			idfHumanCase, 
			idfSiteGroup
		)
	select 
			nID.NewID, 
			ins.idfHumanCase, 
			nID.idfKey2
	from  inserted as ins
		inner join dbo.tflNewID as nID
		on  nID.strTableName = 'tflHumanCaseFiltered'
			and nID.idfKey1 = ins.idfHumanCase
			and nID.idfKey2 is not null
		left join dbo.tflHumanCaseFiltered as btf
		on   btf.idfHumanCaseFiltered = nID.NewID
	where  btf.idfHumanCaseFiltered is null

	delete  nID
	from  dbo.tflNewID as nID
		inner join inserted as ins
		on   ins.idfHumanCase = nID.idfKey1
	where  nID.strTableName = 'tflHumanCaseFiltered'

	SET NOCOUNT OFF;
END



GO

CREATE  TRIGGER [dbo].[TR_tlbHumanCase_ChangeArchiveDate] on [dbo].[tlbHumanCase]	
FOR INSERT, UPDATE, DELETE
NOT FOR REPLICATION
AS	

IF (dbo.FN_GBL_TriggersWork ()=1)
BEGIN
	
	DECLARE @dateModify DATETIME
	DECLARE @idfOutbreakOld BIGINT
	DECLARE @idfOutbreakNew BIGINT
	
	SELECT
		@idfOutbreakOld = ISNULL(idfOutbreak, 0)
	FROM DELETED
	
	SELECT
		@idfOutbreakNew = ISNULL(idfOutbreak, 0)
	FROM INSERTED
	
	SET @dateModify = GETDATE()
					
	IF @idfOutbreakOld > 0
		UPDATE tlbOutbreak
		SET datModificationForArchiveDate = @dateModify
		WHERE idfOutbreak = @idfOutbreakOld
		AND ISNULL(CONVERT(nvarchar(8), datModificationForArchiveDate, 112), '') <> ISNULL(CONVERT(nvarchar(8), @dateModify, 112), '')
			
	IF @idfOutbreakNew > 0
		UPDATE tlbOutbreak
		SET datModificationForArchiveDate = @dateModify
		WHERE idfOutbreak = @idfOutbreakNew
		AND ISNULL(CONVERT(nvarchar(8), datModificationForArchiveDate, 112), '') <> ISNULL(CONVERT(nvarchar(8), @dateModify, 112), '')
				
END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Containing Outbreak identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanCase', @level2type = N'COLUMN', @level2name = N'idfOutbreak';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date/time of case creation', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanCase', @level2type = N'COLUMN', @level2name = N'datEnteredDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Case Alphanumeric code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHumanCase', @level2type = N'COLUMN', @level2name = N'strCaseID';

