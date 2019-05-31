CREATE TABLE [dbo].[tlbMaterial] (
    [idfMaterial]                     BIGINT           NOT NULL,
    [idfsSampleType]                  BIGINT           NOT NULL,
    [idfRootMaterial]                 BIGINT           NULL,
    [idfParentMaterial]               BIGINT           NULL,
    [idfHuman]                        BIGINT           NULL,
    [idfSpecies]                      BIGINT           NULL,
    [idfAnimal]                       BIGINT           NULL,
    [idfMonitoringSession]            BIGINT           NULL,
    [idfFieldCollectedByPerson]       BIGINT           NULL,
    [idfFieldCollectedByOffice]       BIGINT           NULL,
    [idfMainTest]                     BIGINT           NULL,
    [datFieldCollectionDate]          DATETIME         NULL,
    [datFieldSentDate]                DATETIME         NULL,
    [strFieldBarcode]                 NVARCHAR (200)   NULL,
    [strCalculatedCaseID]             NVARCHAR (200)   NULL,
    [strCalculatedHumanName]          NVARCHAR (700)   NULL,
    [idfVectorSurveillanceSession]    BIGINT           NULL,
    [idfVector]                       BIGINT           NULL,
    [idfSubdivision]                  BIGINT           NULL,
    [idfsSampleStatus]                BIGINT           NULL,
    [idfInDepartment]                 BIGINT           NULL,
    [idfDestroyedByPerson]            BIGINT           NULL,
    [datEnteringDate]                 DATETIME         NULL,
    [datDestructionDate]              DATETIME         NULL,
    [strBarcode]                      NVARCHAR (200)   NULL,
    [strNote]                         NVARCHAR (500)   NULL,
    [idfsSite]                        BIGINT           CONSTRAINT [Def_fnSiteID_tlbMaterial] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [intRowStatus]                    INT              CONSTRAINT [Def_0_2054] DEFAULT ((0)) NOT NULL,
    [rowguid]                         UNIQUEIDENTIFIER CONSTRAINT [newid__2056] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfSendToOffice]                 BIGINT           NULL,
    [blnReadOnly]                     BIT              DEFAULT ((0)) NOT NULL,
    [idfsBirdStatus]                  BIGINT           NULL,
    [idfHumanCase]                    BIGINT           NULL,
    [idfVetCase]                      BIGINT           NULL,
    [datAccession]                    DATETIME         NULL,
    [idfsAccessionCondition]          BIGINT           NULL,
    [strCondition]                    NVARCHAR (200)   NULL,
    [idfAccesionByPerson]             BIGINT           NULL,
    [idfsDestructionMethod]           BIGINT           NULL,
    [idfsCurrentSite]                 BIGINT           NULL,
    [idfsSampleKind]                  BIGINT           NULL,
    [blnAccessioned]                  AS               (case when [idfsCurrentSite] IS NOT NULL AND [idfsSampleType]<>(10320001) then (1) else (0) end) PERSISTED NOT NULL,
    [blnShowInCaseOrSession]          AS               (case when [intRowStatus]=(0) AND ([idfParentMaterial] IS NULL OR isnull([idfsSampleKind],(0))=(12675420000000.)) then (1) else (0) end) PERSISTED NOT NULL,
    [blnShowInLabList]                AS               (case when [intRowStatus]=(0) AND [idfsSampleType]<>(10320001) AND isnull([blnReadOnly],(0))<>(1) AND isnull([idfsAccessionCondition],(0))<>(10108003) then (1) else (0) end) PERSISTED NOT NULL,
    [blnShowInDispositionList]        AS               (case when [idfsSampleStatus]=(10015002) OR [idfsSampleStatus]=(10015003) then (1) else (0) end) PERSISTED NOT NULL,
    [blnShowInAccessionInForm]        AS               (case when [intRowStatus]=(0) AND [idfParentMaterial] IS NULL AND [idfsSampleType]<>(10320001) AND isnull([blnReadOnly],(0))<>(1) then (1) else (0) end) PERSISTED NOT NULL,
    [idfMarkedForDispositionByPerson] BIGINT           NULL,
    [datOutOfRepositoryDate]          DATETIME         NULL,
    [datSampleStatusDate]             AS               (case when [idfsSampleStatus] IS NULL then isnull([datFieldCollectionDate],[datEnteringDate]) when [idfsSampleStatus]=(10015007) then [datAccession] when [idfsSampleStatus]=(10015009) then [datDestructionDate] when [idfsSampleStatus]=(10015010) then [datOutOfRepositoryDate] when [idfsSampleStatus]=(10015003) then [datDestructionDate] when [idfsSampleStatus]=(10015002) OR [idfsSampleStatus]=(10015008) then NULL  end) PERSISTED,
    [strMaintenanceFlag]              NVARCHAR (20)    NULL,
    [strReservedAttribute]            NVARCHAR (MAX)   NULL,
    [StorageBoxPlace]                 NVARCHAR (200)   NULL,
    [PreviousSampleStatusID]          BIGINT           NULL,
    [SourceSystemNameID]              BIGINT           NULL,
    [SourceSystemKeyValue]            NVARCHAR (MAX)   NULL,
    [DiseaseID]                       BIGINT           NULL,
    CONSTRAINT [XPKtlbMaterial] PRIMARY KEY CLUSTERED ([idfMaterial] ASC),
    CONSTRAINT [FK_tlbMaterial_tlbAnimal] FOREIGN KEY ([idfAnimal]) REFERENCES [dbo].[tlbAnimal] ([idfAnimal]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbDepartment_idfInDepartment] FOREIGN KEY ([idfInDepartment]) REFERENCES [dbo].[tlbDepartment] ([idfDepartment]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbFreezerSubdivision] FOREIGN KEY ([idfSubdivision]) REFERENCES [dbo].[tlbFreezerSubdivision] ([idfSubdivision]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbHuman] FOREIGN KEY ([idfHuman]) REFERENCES [dbo].[tlbHuman] ([idfHuman]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbHumanCase] FOREIGN KEY ([idfHumanCase]) REFERENCES [dbo].[tlbHumanCase] ([idfHumanCase]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbMaterial__idfParentMaterial_R_1222] FOREIGN KEY ([idfParentMaterial]) REFERENCES [dbo].[tlbMaterial] ([idfMaterial]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbMaterial__idfRootMaterial] FOREIGN KEY ([idfRootMaterial]) REFERENCES [dbo].[tlbMaterial] ([idfMaterial]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbMonitoringSession] FOREIGN KEY ([idfMonitoringSession]) REFERENCES [dbo].[tlbMonitoringSession] ([idfMonitoringSession]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbOffice__idfFieldCollectedByOffice_R_1530] FOREIGN KEY ([idfFieldCollectedByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbOffice__idfSendToOffice] FOREIGN KEY ([idfSendToOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbPerson] FOREIGN KEY ([idfDestroyedByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbPerson__idfAccesionByPerson] FOREIGN KEY ([idfAccesionByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbPerson__idfFieldCollectedByPerson_R_1529] FOREIGN KEY ([idfFieldCollectedByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbPerson__idfMarkedForDispositionByPerson] FOREIGN KEY ([idfMarkedForDispositionByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbSpecies] FOREIGN KEY ([idfSpecies]) REFERENCES [dbo].[tlbSpecies] ([idfSpecies]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbTesting__idfMainTest] FOREIGN KEY ([idfMainTest]) REFERENCES [dbo].[tlbTesting] ([idfTesting]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbVector_idfVector] FOREIGN KEY ([idfVector]) REFERENCES [dbo].[tlbVector] ([idfVector]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbVectorSurveillanceSession_idfVectorSurveillanceSession] FOREIGN KEY ([idfVectorSurveillanceSession]) REFERENCES [dbo].[tlbVectorSurveillanceSession] ([idfVectorSurveillanceSession]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tlbVetCase] FOREIGN KEY ([idfVetCase]) REFERENCES [dbo].[tlbVetCase] ([idfVetCase]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_trtBaseReference__idfsAccessionCondition] FOREIGN KEY ([idfsAccessionCondition]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_trtBaseReference_DiseaseID] FOREIGN KEY ([DiseaseID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbMaterial_trtBaseReference_idfsBirdStatus] FOREIGN KEY ([idfsBirdStatus]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_trtBaseReference_idfsDestructionMethod] FOREIGN KEY ([idfsDestructionMethod]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_trtBaseReference_idfsSampleKind] FOREIGN KEY ([idfsSampleKind]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_trtBaseReference_idfsSampleStatus] FOREIGN KEY ([idfsSampleStatus]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_trtBaseReference_PreviousSampleStatusID] FOREIGN KEY ([PreviousSampleStatusID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbMaterial_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbMaterial_trtSampleType__idfsSampleType] FOREIGN KEY ([idfsSampleType]) REFERENCES [dbo].[trtSampleType] ([idfsSampleType]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tstSite__idfsCurrentSite] FOREIGN KEY ([idfsCurrentSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbMaterial_tstSite__idfsSite_R_1066] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO
CREATE NONCLUSTERED INDEX [IX_tlbMaterial_idfMonitoringSession]
    ON [dbo].[tlbMaterial]([idfMonitoringSession] ASC)
    INCLUDE([idfSendToOffice]);


GO
CREATE NONCLUSTERED INDEX [IX_tlbMaterial_datSampleStatusDate]
    ON [dbo].[tlbMaterial]([datSampleStatusDate] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tlbMaterial__idfMaterial_datAccession]
    ON [dbo].[tlbMaterial]([idfMaterial] ASC, [datAccession] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tlbMaterial_idfAnimal]
    ON [dbo].[tlbMaterial]([idfAnimal] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tlbMaterial_idfSpecies]
    ON [dbo].[tlbMaterial]([idfSpecies] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tlbMaterial__intRowStatus_idfsSampleType]
    ON [dbo].[tlbMaterial]([intRowStatus] ASC, [idfsSampleType] ASC)
    INCLUDE([idfMaterial], [idfRootMaterial], [idfVetCase]);


GO
CREATE NONCLUSTERED INDEX [IX_tlbMaterial__intRowStatus_idfVetCase]
    ON [dbo].[tlbMaterial]([intRowStatus] ASC, [idfVetCase] ASC)
    INCLUDE([idfMaterial], [idfsSampleType], [idfRootMaterial]);


GO

CREATE TRIGGER [dbo].[TR_tlbMaterial_Calculate] ON [dbo].[tlbMaterial] 
FOR INSERT, UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfHumanCase) OR UPDATE(idfVetCase) OR UPDATE(idfMonitoringSession) OR UPDATE(idfVectorSurveillanceSession))
	BEGIN
	  UPDATE a
	  SET strCalculatedCaseID = COALESCE(tlbHumanCase.strCaseID,tlbVetCase.strCaseID,tlbMonitoringSession.strMonitoringSessionID,tlbVectorSurveillanceSession.strSessionID)
	  FROM tlbMaterial a
	  INNER JOIN inserted ON inserted.idfMaterial=a.idfMaterial 
	  LEFT JOIN tlbHumanCase ON tlbHumanCase.idfHumanCase=a.idfHumanCase AND tlbHumanCase.intRowStatus = 0
	  LEFT JOIN tlbVetCase ON tlbVetCase.idfVetCase=a.idfVetCase AND tlbVetCase.intRowStatus = 0
	  LEFT JOIN tlbMonitoringSession ON tlbMonitoringSession.idfMonitoringSession=a.idfMonitoringSession AND tlbMonitoringSession.intRowStatus = 0
	  LEFT JOIN tlbVectorSurveillanceSession ON tlbVectorSurveillanceSession.idfVectorSurveillanceSession=a.idfVectorSurveillanceSession AND tlbVectorSurveillanceSession.intRowStatus = 0

	  UPDATE a
	  SET strCalculatedHumanName = ISNULL(HumanFromCase.strLastName + ' ', '')+ISNULL(HumanFromCase.strFirstName + ' ', '') + ISNULL(HumanFromCase.strSecondName, '')
	  FROM tlbMaterial a
	  INNER JOIN inserted ON inserted.idfMaterial=a.idfMaterial
	  LEFT JOIN tlbAnimal ON tlbAnimal.idfAnimal = a.idfAnimal AND tlbAnimal.intRowStatus = 0
	  LEFT JOIN tlbSpecies ON (tlbSpecies.idfSpecies = a.idfSpecies OR tlbSpecies.idfSpecies = tlbAnimal.idfSpecies) AND tlbSpecies.intRowStatus = 0
	  LEFT JOIN tlbHerd ON tlbHerd.idfHerd = tlbSpecies.idfHerd AND tlbHerd.intRowStatus = 0
	  LEFT JOIN tlbFarm ON tlbFarm.idfFarm = tlbHerd.idfFarm AND tlbFarm.intRowStatus = 0
	  LEFT JOIN tlbHuman HumanFromCase ON HumanFromCase.idfHuman=tlbFarm.idfHuman OR HumanFromCase.idfHuman=a.idfHuman
	END

END


GO

CREATE TRIGGER [dbo].[TR_tlbMaterial_A_Update] ON [dbo].[tlbMaterial]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfMaterial))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbMaterial_I_Delete] on [dbo].[tlbMaterial]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfMaterial]) as
		(
			SELECT [idfMaterial] FROM deleted
			EXCEPT
			SELECT [idfMaterial] FROM inserted
		)
		
		UPDATE a
		SET datEnteringDate = getdate(), 
			intRowStatus = 1
		FROM dbo.tlbMaterial as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfMaterial = b.idfMaterial;

	END

END

GO

CREATE  TRIGGER [dbo].[TR_tlbMaterial_ChangeArchiveDate] on [dbo].[tlbMaterial]	
FOR INSERT, UPDATE, DELETE
NOT FOR REPLICATION
AS	

DECLARE @context VARCHAR(50)
SET @context = dbo.fnGetContext()

IF (dbo.FN_GBL_TriggersWork() =1)
BEGIN
	
	DECLARE @dateModify DATETIME
	DECLARE @idfHumanCase BIGINT
	DECLARE @idfVetCase BIGINT
	DECLARE @idfMonitoringSession BIGINT
	DECLARE @idfVectorSurveillanceSession BIGINT
	
	IF (SELECT COUNT(*) FROM INSERTED) > 0	
		
		SELECT
			@idfHumanCase = ISNULL(idfHumanCase, 0),
			@idfVetCase = ISNULL(idfVetCase, 0),
			@idfMonitoringSession = ISNULL(idfMonitoringSession, 0),
			@idfVectorSurveillanceSession = ISNULL(idfVectorSurveillanceSession, 0)
		FROM INSERTED

	ELSE
	
		SELECT
			@idfHumanCase = ISNULL(idfHumanCase, 0),
			@idfVetCase = ISNULL(idfVetCase, 0),
			@idfMonitoringSession = ISNULL(idfMonitoringSession, 0),
			@idfVectorSurveillanceSession = ISNULL(idfVectorSurveillanceSession, 0)
		FROM DELETED
	
	SET @dateModify = GETDATE()
			
	IF @idfHumanCase > 0
		UPDATE tlbHumanCase 
		SET datModificationForArchiveDate = @dateModify
		WHERE idfHumanCase = @idfHumanCase
		AND ISNULL(CONVERT(nvarchar(8), datModificationForArchiveDate, 112), '') <> ISNULL(CONVERT(nvarchar(8), @dateModify, 112), '')
				
	IF @idfVetCase > 0
		UPDATE tlbVetCase 
		SET datModificationForArchiveDate = @dateModify
		WHERE idfVetCase = @idfVetCase
		AND ISNULL(CONVERT(nvarchar(8), datModificationForArchiveDate, 112), '') <> ISNULL(CONVERT(nvarchar(8), @dateModify, 112), '')
				
	IF @idfMonitoringSession > 0
		UPDATE tlbMonitoringSession 
		SET datModificationForArchiveDate = @dateModify
		WHERE idfMonitoringSession = @idfMonitoringSession
		AND ISNULL(CONVERT(nvarchar(8), datModificationForArchiveDate, 112), '') <> ISNULL(CONVERT(nvarchar(8), @dateModify, 112), '')
					
	IF @idfVectorSurveillanceSession > 0
		UPDATE tlbVectorSurveillanceSession 
		SET datModificationForArchiveDate = @dateModify
		WHERE idfVectorSurveillanceSession = @idfVectorSurveillanceSession
		AND ISNULL(CONVERT(nvarchar(8), datModificationForArchiveDate, 112), '') <> ISNULL(CONVERT(nvarchar(8), @dateModify, 112), '')

	
END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Samples collected from human/animal patient', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbMaterial';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Material identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbMaterial', @level2type = N'COLUMN', @level2name = N'idfMaterial';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Specimen type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbMaterial', @level2type = N'COLUMN', @level2name = N'idfsSampleType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'First Source of the material identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbMaterial', @level2type = N'COLUMN', @level2name = N'idfRootMaterial';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Immediate source of the material identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbMaterial', @level2type = N'COLUMN', @level2name = N'idfParentMaterial';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Material collected by Officer identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbMaterial', @level2type = N'COLUMN', @level2name = N'idfFieldCollectedByPerson';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Material collected by Institution identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbMaterial', @level2type = N'COLUMN', @level2name = N'idfFieldCollectedByOffice';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Test for material identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbMaterial', @level2type = N'COLUMN', @level2name = N'idfMainTest';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Date of collection', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbMaterial', @level2type = N'COLUMN', @level2name = N'datFieldCollectionDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Date of sending', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbMaterial', @level2type = N'COLUMN', @level2name = N'datFieldSentDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Field barcode assigned to material', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbMaterial', @level2type = N'COLUMN', @level2name = N'strFieldBarcode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Site identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbMaterial', @level2type = N'COLUMN', @level2name = N'idfsSite';

