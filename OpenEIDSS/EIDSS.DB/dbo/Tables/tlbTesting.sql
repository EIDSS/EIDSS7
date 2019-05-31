CREATE TABLE [dbo].[tlbTesting] (
    [idfTesting]               BIGINT           NOT NULL,
    [idfsTestName]             BIGINT           NULL,
    [idfsTestCategory]         BIGINT           NULL,
    [idfsTestResult]           BIGINT           NULL,
    [idfsTestStatus]           BIGINT           NOT NULL,
    [idfsDiagnosis]            BIGINT           NOT NULL,
    [idfMaterial]              BIGINT           NULL,
    [idfBatchTest]             BIGINT           NULL,
    [idfObservation]           BIGINT           NULL,
    [intTestNumber]            INT              NULL,
    [strNote]                  NVARCHAR (500)   NULL,
    [intRowStatus]             INT              CONSTRAINT [Def_0_2643] DEFAULT ((0)) NOT NULL,
    [rowguid]                  UNIQUEIDENTIFIER CONSTRAINT [newid__2517] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [datStartedDate]           DATETIME         NULL,
    [datConcludedDate]         DATETIME         NULL,
    [idfTestedByOffice]        BIGINT           NULL,
    [idfTestedByPerson]        BIGINT           NULL,
    [idfResultEnteredByOffice] BIGINT           NULL,
    [idfResultEnteredByPerson] BIGINT           NULL,
    [idfValidatedByOffice]     BIGINT           NULL,
    [idfValidatedByPerson]     BIGINT           NULL,
    [blnReadOnly]              BIT              DEFAULT ((0)) NOT NULL,
    [blnNonLaboratoryTest]     BIT              DEFAULT ((0)) NOT NULL,
    [blnExternalTest]          BIT              DEFAULT ((0)) NULL,
    [idfPerformedByOffice]     BIGINT           NULL,
    [datReceivedDate]          DATETIME         NULL,
    [strContactPerson]         NVARCHAR (200)   NULL,
    [strMaintenanceFlag]       NVARCHAR (20)    NULL,
    [strReservedAttribute]     NVARCHAR (MAX)   NULL,
    [PreviousTestStatusID]     BIGINT           NULL,
    [SourceSystemNameID]       BIGINT           NULL,
    [SourceSystemKeyValue]     NVARCHAR (MAX)   NULL,
    [AuditCreateUser]          NVARCHAR (200)   NULL,
    [AuditCreateDTM]           DATETIME         CONSTRAINT [DF_tlbTesing_AuditCreateDTM] DEFAULT (getdate()) NULL,
    [AuditUpdateUser]          NVARCHAR (200)   NULL,
    [AuditUpdateDTM]           DATETIME         NULL,
    CONSTRAINT [XPKtlbTesting] PRIMARY KEY CLUSTERED ([idfTesting] ASC),
    CONSTRAINT [FK_tlbTesting_tlbBatchTest__idfBatchTest_R_1534] FOREIGN KEY ([idfBatchTest]) REFERENCES [dbo].[tlbBatchTest] ([idfBatchTest]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTesting_tlbMaterial] FOREIGN KEY ([idfMaterial]) REFERENCES [dbo].[tlbMaterial] ([idfMaterial]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTesting_tlbOffice__idfPerformedByOffice] FOREIGN KEY ([idfPerformedByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTesting_tlbOffice__idfResultEnteredByOffice] FOREIGN KEY ([idfResultEnteredByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTesting_tlbOffice__idfTestedByOffice] FOREIGN KEY ([idfTestedByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTesting_tlbOffice__idfValidatedByOffice] FOREIGN KEY ([idfValidatedByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTesting_tlbPerson__idfResultEnteredByPerson] FOREIGN KEY ([idfResultEnteredByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTesting_tlbPerson__idfTestedByPerson] FOREIGN KEY ([idfTestedByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTesting_tlbPerson__idfValidatedByPerson] FOREIGN KEY ([idfValidatedByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTesting_trtBaseReference__idfsTestCategory] FOREIGN KEY ([idfsTestCategory]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTesting_trtBaseReference__idfsTestName] FOREIGN KEY ([idfsTestName]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTesting_trtBaseReference__idfsTestResult_R_1243] FOREIGN KEY ([idfsTestResult]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTesting_trtBaseReference__idfsTestStatus_R_1754] FOREIGN KEY ([idfsTestStatus]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbTesting_trtBaseReference_PreviousTestStatusID] FOREIGN KEY ([PreviousTestStatusID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbTesting_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbTesting_trtDiagnosis] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION
);


GO
CREATE NONCLUSTERED INDEX [IX_tlbTesting_datConcludedDate]
    ON [dbo].[tlbTesting]([datConcludedDate] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_tlbTesting_idfMaterial]
    ON [dbo].[tlbTesting]([idfMaterial] ASC);


GO

CREATE TRIGGER [dbo].[TR_tlbTesting_ChangeArchiveDate] ON [dbo].[tlbTesting]	
FOR INSERT, UPDATE, DELETE
NOT FOR REPLICATION
AS	

IF (dbo.FN_GBL_TriggersWork ()=1)
BEGIN
	
	DECLARE @idfMaterial BIGINT
	DECLARE @idfBatchTest BIGINT
	DECLARE @dateModify DATETIME
	
	IF (SELECT COUNT(*) FROM INSERTED) > 0	
		
		SELECT
			@idfMaterial = ISNULL(idfMaterial, 0),
			@idfBatchTest = ISNULL(@idfBatchTest, 0)
		FROM INSERTED

	ELSE
	
		SELECT
			@idfMaterial = ISNULL(idfMaterial, 0),
			@idfBatchTest = ISNULL(@idfBatchTest, 0)
		FROM DELETED
	
	DECLARE @idfHumanCase BIGINT
	DECLARE @idfVetCase BIGINT
	DECLARE @idfMonitoringSession BIGINT
	DECLARE @idfVectorSurveillanceSession BIGINT
		
	SELECT
		@idfHumanCase = ISNULL(idfHumanCase, 0),
		@idfVetCase = ISNULL(idfVetCase, 0),
		@idfMonitoringSession = ISNULL(idfMonitoringSession, 0),
		@idfVectorSurveillanceSession = ISNULL(idfVectorSurveillanceSession, 0)
	FROM tlbMaterial
	WHERE idfMaterial = @idfMaterial		
	
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
	
	IF @idfBatchTest > 0
		UPDATE tlbBatchTest
		SET datModificationForArchiveDate = @dateModify
		WHERE idfBatchTest = @idfBatchTest
		AND ISNULL(CONVERT(nvarchar(8), datModificationForArchiveDate, 112), '') <> ISNULL(CONVERT(nvarchar(8), @dateModify, 112), '') 
	
END

GO

CREATE TRIGGER [dbo].[TR_tlbTesting_A_Update] ON [dbo].[tlbTesting]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfTesting))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbTesting_I_Delete] on [dbo].[tlbTesting]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfTesting]) as
		(
			SELECT [idfTesting] FROM deleted
			EXCEPT
			SELECT [idfTesting] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbTesting as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfTesting = b.idfTesting;

	END

END
