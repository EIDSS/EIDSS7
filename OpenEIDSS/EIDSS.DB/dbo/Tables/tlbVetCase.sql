CREATE TABLE [dbo].[tlbVetCase] (
    [idfVetCase]                    BIGINT           NOT NULL,
    [idfFarm]                       BIGINT           NOT NULL,
    [idfsTentativeDiagnosis]        BIGINT           NULL,
    [idfsTentativeDiagnosis1]       BIGINT           NULL,
    [idfsTentativeDiagnosis2]       BIGINT           NULL,
    [idfsFinalDiagnosis]            BIGINT           NULL,
    [idfPersonEnteredBy]            BIGINT           NULL,
    [idfPersonReportedBy]           BIGINT           NULL,
    [idfPersonInvestigatedBy]       BIGINT           NULL,
    [idfObservation]                BIGINT           NULL,
    [idfsSite]                      BIGINT           CONSTRAINT [Def_fnSiteID_tlbVetCase] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [datReportDate]                 DATETIME         NULL,
    [datAssignedDate]               DATETIME         NULL,
    [datInvestigationDate]          DATETIME         NULL,
    [datTentativeDiagnosisDate]     DATETIME         NULL,
    [datTentativeDiagnosis1Date]    DATETIME         NULL,
    [datTentativeDiagnosis2Date]    DATETIME         NULL,
    [datFinalDiagnosisDate]         DATETIME         NULL,
    [strTestNotes]                  NVARCHAR (1000)  NULL,
    [strSummaryNotes]               NVARCHAR (1000)  NULL,
    [strClinicalNotes]              NVARCHAR (1000)  NULL,
    [strFieldAccessionID]           NVARCHAR (200)   NULL,
    [rowguid]                       UNIQUEIDENTIFIER CONSTRAINT [newid__2088] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfsYNTestsConducted]          BIGINT           NULL,
    [intRowStatus]                  INT              DEFAULT ((0)) NOT NULL,
    [idfReportedByOffice]           BIGINT           NULL,
    [idfInvestigatedByOffice]       BIGINT           NULL,
    [idfsCaseReportType]            BIGINT           NULL,
    [strDefaultDisplayDiagnosis]    NVARCHAR (500)   NULL,
    [idfsCaseClassification]        BIGINT           NULL,
    [idfsShowDiagnosis]             AS               (case when [idfsFinalDiagnosis] IS NOT NULL then [idfsFinalDiagnosis] when [idfsFinalDiagnosis] IS NULL AND [datTentativeDiagnosisDate] IS NOT NULL AND [idfsTentativeDiagnosis] IS NOT NULL AND [datTentativeDiagnosisDate]>=isnull([datTentativeDiagnosis1Date],(0)) AND [datTentativeDiagnosisDate]>=isnull([datTentativeDiagnosis2Date],(0)) then [idfsTentativeDiagnosis] when [idfsFinalDiagnosis] IS NULL AND [datTentativeDiagnosis1Date] IS NOT NULL AND [idfsTentativeDiagnosis1] IS NOT NULL AND [datTentativeDiagnosis1Date]>=isnull([datTentativeDiagnosisDate],(0)) AND [datTentativeDiagnosis1Date]>=isnull([datTentativeDiagnosis2Date],(0)) then [idfsTentativeDiagnosis1] when [idfsFinalDiagnosis] IS NULL AND [datTentativeDiagnosis2Date] IS NOT NULL AND [idfsTentativeDiagnosis2] IS NOT NULL AND [datTentativeDiagnosis2Date]>=isnull([datTentativeDiagnosisDate],(0)) AND [datTentativeDiagnosis2Date]>=isnull([datTentativeDiagnosis1Date],(0)) then [idfsTentativeDiagnosis2] when [idfsFinalDiagnosis] IS NULL AND [datTentativeDiagnosisDate] IS NULL AND [datTentativeDiagnosis1Date] IS NULL AND [datTentativeDiagnosis2Date] IS NULL then coalesce([idfsTentativeDiagnosis2],[idfsTentativeDiagnosis1],[idfsTentativeDiagnosis])  end) PERSISTED,
    [idfOutbreak]                   BIGINT           NULL,
    [datEnteredDate]                DATETIME         NULL,
    [strCaseID]                     NVARCHAR (200)   NULL,
    [idfsCaseProgressStatus]        BIGINT           NULL,
    [strSampleNotes]                NVARCHAR (1000)  NULL,
    [datModificationForArchiveDate] DATETIME         CONSTRAINT [tlbVetCase_datModificationForArchiveDate] DEFAULT (getdate()) NULL,
    [idfParentMonitoringSession]    BIGINT           NULL,
    [uidOfflineCaseID]              UNIQUEIDENTIFIER NULL,
    [idfsCaseType]                  BIGINT           NOT NULL,
    [strMaintenanceFlag]            NVARCHAR (20)    NULL,
    [strReservedAttribute]          NVARCHAR (MAX)   NULL,
    [LegacyCaseID]                  NVARCHAR (200)   NULL,
    [SourceSystemNameID]            BIGINT           NULL,
    [SourceSystemKeyValue]          NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbVetCase] PRIMARY KEY CLUSTERED ([idfVetCase] ASC),
    CONSTRAINT [FK_tlbVetCase_tlbFarm] FOREIGN KEY ([idfFarm]) REFERENCES [dbo].[tlbFarm] ([idfFarm]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_tlbMonitoringSession__idfParentMonitoringSession] FOREIGN KEY ([idfParentMonitoringSession]) REFERENCES [dbo].[tlbMonitoringSession] ([idfMonitoringSession]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_tlbObservation__idfObservation_R_1447] FOREIGN KEY ([idfObservation]) REFERENCES [dbo].[tlbObservation] ([idfObservation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_tlbOffice__idfInvestigatedByOffice] FOREIGN KEY ([idfInvestigatedByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_tlbOffice__idfReportedByOffice] FOREIGN KEY ([idfReportedByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_tlbOutbreak__idfOutbreak] FOREIGN KEY ([idfOutbreak]) REFERENCES [dbo].[tlbOutbreak] ([idfOutbreak]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_tlbPerson__idfPersonEnteredBy_R_1507] FOREIGN KEY ([idfPersonEnteredBy]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_tlbPerson__idfPersonInvestigatedBy_R_1506] FOREIGN KEY ([idfPersonInvestigatedBy]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_tlbPerson__idfPersonReportedBy_R_1508] FOREIGN KEY ([idfPersonReportedBy]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_trtBaseReference__idfsCaseClassification] FOREIGN KEY ([idfsCaseClassification]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_trtBaseReference__idfsCaseProgressStatus] FOREIGN KEY ([idfsCaseProgressStatus]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_trtBaseReference__idfsCaseReportType] FOREIGN KEY ([idfsCaseReportType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_trtBaseReference__idfsCaseType] FOREIGN KEY ([idfsCaseType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_trtBaseReference__idfsYNTestsConducted] FOREIGN KEY ([idfsYNTestsConducted]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbVetCase_trtDiagnosis__idfsFinalDiagnosis_R_1438] FOREIGN KEY ([idfsFinalDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_trtDiagnosis__idfsShowDiagnosis] FOREIGN KEY ([idfsShowDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_trtDiagnosis__idfsTentativeDiagnosis_R_1435] FOREIGN KEY ([idfsTentativeDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_trtDiagnosis__idfsTentativeDiagnosis1_R_1436] FOREIGN KEY ([idfsTentativeDiagnosis1]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_trtDiagnosis__idfsTentativeDiagnosis2_R_1437] FOREIGN KEY ([idfsTentativeDiagnosis2]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVetCase_tstSite__idfsSite_R_1588] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO
CREATE NONCLUSTERED INDEX [IX_tlbVetCase_idfParentMonitoringSession]
    ON [dbo].[tlbVetCase]([idfParentMonitoringSession] ASC)
    INCLUDE([idfVetCase]);


GO
CREATE NONCLUSTERED INDEX [IX_tlbVetCase_uidOfflineCaseID]
    ON [dbo].[tlbVetCase]([uidOfflineCaseID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tlbVetCase__idfFarm]
    ON [dbo].[tlbVetCase]([idfFarm] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tlbVetCase__strCaseID]
    ON [dbo].[tlbVetCase]([strCaseID] ASC);


GO

CREATE TRIGGER [dbo].[TR_tlbVetCase_A_Update] ON [dbo].[tlbVetCase]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1)
	BEGIN
		IF UPDATE(idfVetCase)
		BEGIN
			RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
			ROLLBACK TRANSACTION
		END

		ELSE
		BEGIN

			UPDATE a
			SET datModificationForArchiveDate = GETDATE()
			FROM dbo.tlbVetCase AS a 
			INNER JOIN INSERTED AS b ON a.idfVetCase = b.idfVetCase

			UPDATE tvc
			SET strDefaultDisplayDiagnosis = dbo.fnDiagnosisString('xx', i.idfVetCase)
			FROM dbo.tlbVetCase AS tvc 
			JOIN inserted AS i ON 
				tvc.idfVetCase = i.idfVetCase
			WHERE ISNULL(tvc.strDefaultDisplayDiagnosis, '') <> ISNULL(dbo.fnDiagnosisString('xx', i.idfVetCase), '')
	
	
			MERGE dbo.tlbVetCaseDisplayDiagnosis AS [target]
			USING (				
					SELECT
						tvc.idfVetCase,
						tltc.idfsLanguage,
						dbo.fnDiagnosisString(tbr.strBaseReferenceCode, tvc.idfVetCase) as DisplayDiagnosis
					FROM dbo.tlbVetCase AS tvc 
					JOIN inserted AS i ON tvc.idfVetCase = i.idfVetCase
					CROSS JOIN trtLanguageToCP tltc	JOIN tstLocalSiteOptions tlso ON tlso.strName = 'SiteID'
					JOIN tstSite ts ON ts.idfsSite = tlso.strValue AND ts.idfCustomizationPackage = tltc.idfCustomizationPackage AND ts.intRowStatus = 0
					JOIN trtBaseReference tbr ON tbr.idfsBaseReference = tltc.idfsLanguage AND tbr.intRowStatus = 0
				 ) AS [source]
			ON ([target].idfVetCase = [source].idfVetCase AND [target].idfsLanguage = [source].idfsLanguage)
			WHEN MATCHED AND (ISNULL([target].strDisplayDiagnosis, '') <> ISNULL([source].DisplayDiagnosis, ''))
			THEN UPDATE	SET strDisplayDiagnosis = [source].DisplayDiagnosis;

		END
	
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbVetCase_I_Delete] on [dbo].[tlbVetCase]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfVetCase]) as
		(
			SELECT [idfVetCase] FROM deleted
			EXCEPT
			SELECT [idfVetCase] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1,
			datModificationForArchiveDate = getdate()
		FROM dbo.tlbVetCase as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfVetCase = b.idfVetCase;

	END

END

GO

-- =============================================
-- Author:		Romasheva Svetlana
-- Create date: May 19 2014  3:07PM
-- Description:	Trigger for correct problems 
--              with replication and checkin in the same time
-- =============================================
CREATE TRIGGER [dbo].[trtVetCaseReplicationUp] 
   ON  [dbo].[tlbVetCase]
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
		on   ins.idfVetCase = nID.idfKey1
	where  nID.strTableName = 'tflVetCaseFiltered'

	insert into dbo.tflNewID 
		(
			strTableName, 
			idfKey1, 
			idfKey2
		)
	select  
			'tflVetCaseFiltered', 
			ins.idfVetCase, 
			sg.idfSiteGroup
	from  inserted as ins
		inner join dbo.tflSiteToSiteGroup as stsg
		on   stsg.idfsSite = ins.idfsSite
		
		inner join dbo.tflSiteGroup sg
		on	sg.idfSiteGroup = stsg.idfSiteGroup
			and sg.idfsRayon is null
			and sg.idfsCentralSite is null
			and sg.intRowStatus = 0
			
		left join dbo.tflVetCaseFiltered as btf
		on  btf.idfVetCase = ins.idfVetCase
			and btf.idfSiteGroup = sg.idfSiteGroup
	where  btf.idfVetCaseFiltered is null

	insert into dbo.tflVetCaseFiltered
		(
			idfVetCaseFiltered, 
			idfVetCase, 
			idfSiteGroup
		)
	select 
			nID.NewID, 
			ins.idfVetCase, 
			nID.idfKey2
	from  inserted as ins
		inner join dbo.tflNewID as nID
		on  nID.strTableName = 'tflVetCaseFiltered'
			and nID.idfKey1 = ins.idfVetCase
			and nID.idfKey2 is not null
		left join dbo.tflVetCaseFiltered as btf
		on   btf.idfVetCaseFiltered = nID.NewID
	where  btf.idfVetCaseFiltered is null

	delete  nID
	from  dbo.tflNewID as nID
		inner join inserted as ins
		on   ins.idfVetCase = nID.idfKey1
	where  nID.strTableName = 'tflVetCaseFiltered'

	SET NOCOUNT OFF;
END



GO

CREATE  TRIGGER [dbo].[TR_tlbVetCase_ChangeArchiveDate] on [dbo].[tlbVetCase]	
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
			
	IF @idfOutbreakNew > 0
		UPDATE tlbOutbreak
		SET datModificationForArchiveDate = @dateModify
		WHERE idfOutbreak = @idfOutbreakNew
				
END

GO

CREATE  TRIGGER [dbo].[TR_tlbVetCase_A_Insert] on [dbo].[tlbVetCase]	
FOR INSERT
AS

IF ((TRIGGER_NESTLEVEL()<2) AND (dbo.fnTriggersWork ()=1))
BEGIN
	
	UPDATE tvc
	SET strDefaultDisplayDiagnosis = dbo.fnDiagnosisString('xx', i.idfVetCase)
	FROM dbo.tlbVetCase AS tvc 
	JOIN inserted AS i ON tvc.idfVetCase = i.idfVetCase
	
	INSERT INTO tlbVetCaseDisplayDiagnosis
	(idfVetCase, idfsLanguage, strDisplayDiagnosis)		
	SELECT
		tvc.idfVetCase,
		tltc.idfsLanguage,
		dbo.fnDiagnosisString(tbr.strBaseReferenceCode, i.idfVetCase) as DisplayDiagnosis
	FROM dbo.tlbVetCase AS tvc 
	JOIN inserted AS i ON tvc.idfVetCase = i.idfVetCase
	CROSS JOIN trtLanguageToCP tltc	JOIN tstLocalSiteOptions tlso ON tlso.strName = 'SiteID'
		JOIN tstSite ts ON ts.idfsSite = tlso.strValue AND ts.idfCustomizationPackage = tltc.idfCustomizationPackage AND ts.intRowStatus = 0
	JOIN trtBaseReference tbr ON tbr.idfsBaseReference = tltc.idfsLanguage AND tbr.intRowStatus = 0
END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Veterinary Cases', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Veterinary case identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'idfVetCase';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Tentative diagnosis identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'idfsTentativeDiagnosis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Tentative diagnosis 1 identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'idfsTentativeDiagnosis1';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Tentative diagnosis 2 identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'idfsTentativeDiagnosis2';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Final diagnosis identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'idfsFinalDiagnosis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Case created by person identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'idfPersonEnteredBy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Case reported by person identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'idfPersonReportedBy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Investigated by person identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'idfPersonInvestigatedBy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Site identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'idfsSite';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Reporting date', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'datReportDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Assignment date', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'datAssignedDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Tentative diagnosis date', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'datTentativeDiagnosisDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Tentative diagnosis 1 date', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'datTentativeDiagnosis1Date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Tentative diagnosis 2 date', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'datTentativeDiagnosis2Date';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Final diagnosis date', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'datFinalDiagnosisDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Test notes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'strTestNotes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Summary notes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'strSummaryNotes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Clinical notes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'strClinicalNotes';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Case status identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'idfsCaseClassification';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Case diagnosis identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'idfsShowDiagnosis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Containing Outbreak identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'idfOutbreak';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date/time of case creation', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'datEnteredDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Case Alphanumeric code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'strCaseID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Case type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVetCase', @level2type = N'COLUMN', @level2name = N'idfsCaseType';

