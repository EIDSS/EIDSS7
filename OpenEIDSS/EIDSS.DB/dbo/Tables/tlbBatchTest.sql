CREATE TABLE [dbo].[tlbBatchTest] (
    [idfBatchTest]                  BIGINT           NOT NULL,
    [idfsTestName]                  BIGINT           NULL,
    [idfsBatchStatus]               BIGINT           NULL,
    [idfPerformedByOffice]          BIGINT           NULL,
    [idfPerformedByPerson]          BIGINT           NULL,
    [idfValidatedByOffice]          BIGINT           NULL,
    [idfValidatedByPerson]          BIGINT           NULL,
    [idfObservation]                BIGINT           NOT NULL,
    [idfsSite]                      BIGINT           CONSTRAINT [Def_fnSiteID_tlbBatchTest] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [datPerformedDate]              DATETIME         NULL,
    [datValidatedDate]              DATETIME         NULL,
    [strBarcode]                    NVARCHAR (200)   NULL,
    [intRowStatus]                  INT              CONSTRAINT [Def_0_2046] DEFAULT ((0)) NOT NULL,
    [rowguid]                       UNIQUEIDENTIFIER CONSTRAINT [newid__2048] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfResultEnteredByPerson]      BIGINT           NULL,
    [idfResultEnteredByOffice]      BIGINT           NULL,
    [datModificationForArchiveDate] DATETIME         CONSTRAINT [tlbBatchTest_datModificationForArchiveDate] DEFAULT (getdate()) NULL,
    [strMaintenanceFlag]            NVARCHAR (20)    NULL,
    [strReservedAttribute]          NVARCHAR (MAX)   NULL,
    [TestRequested]                 NVARCHAR (200)   NULL,
    [SourceSystemNameID]            BIGINT           NULL,
    [SourceSystemKeyValue]          NVARCHAR (MAX)   NULL,
    [AuditCreateUser]               NVARCHAR (200)   NULL,
    [AuditCreateDTM]                DATETIME         CONSTRAINT [DF_tlbBatchTest_CreateDTM] DEFAULT (getdate()) NULL,
    [AuditUpdateUser]               NVARCHAR (200)   NULL,
    [AuditUpdateDTM]                DATETIME         NULL,
    CONSTRAINT [XPKtlbBatchTest] PRIMARY KEY CLUSTERED ([idfBatchTest] ASC),
    CONSTRAINT [FK_tlbBatchTest_tlbObservation__idfObservation_R_1541] FOREIGN KEY ([idfObservation]) REFERENCES [dbo].[tlbObservation] ([idfObservation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBatchTest_tlbOffice__idfPerformedByOffice_R_1539] FOREIGN KEY ([idfPerformedByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBatchTest_tlbOffice__idfResultEnteredByOffice] FOREIGN KEY ([idfResultEnteredByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBatchTest_tlbOffice__idfValidatedByOffice_R_1542] FOREIGN KEY ([idfValidatedByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBatchTest_tlbPerson__idfPerformedByPerson_R_1540] FOREIGN KEY ([idfPerformedByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBatchTest_tlbPerson__idfResultEnteredByPerson] FOREIGN KEY ([idfResultEnteredByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBatchTest_tlbPerson__idfValidatedByPerson_R_1543] FOREIGN KEY ([idfValidatedByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBatchTest_trtBaseReference__idfsBatchStatus_R_1544] FOREIGN KEY ([idfsBatchStatus]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBatchTest_trtBaseReference__idfsTestName] FOREIGN KEY ([idfsTestName]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBatchTest_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbBatchTest_tstSite__idfsSite_R_1653] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO
CREATE NONCLUSTERED INDEX [IX_tlbBatchTest_B]
    ON [dbo].[tlbBatchTest]([idfBatchTest] ASC)
    INCLUDE([datPerformedDate]);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_tlbBatchTest_strBarcode_Unique]
    ON [dbo].[tlbBatchTest]([strBarcode] ASC);


GO

CREATE TRIGGER [dbo].[TR_tlbBatchTest_A_Update] ON [dbo].[tlbBatchTest]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfBatchTest))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


-- =============================================
-- Author:		Romasheva Svetlana
-- Create date: 2013-09-24
-- Description:	Trigger for correct problems 
--              with replication and checkin in the same time
-- =============================================
CREATE TRIGGER [dbo].[trtBatchTestReplicationUp] 
   ON  [dbo].[tlbBatchTest]
   for INSERT
   NOT FOR REPLICATION
AS 
BEGIN
	SET NOCOUNT ON;
	declare @FilterListedRecordsOnly bit = 0
	-- get value of global option FilterListedRecordsOnly 
	if exists (select * from tstGlobalSiteOptions tgso where tgso.strName = 'FilterListedRecordsOnly' and tgso.strValue = '1')
		set @FilterListedRecordsOnly = 1 
	else 
		set @FilterListedRecordsOnly = 0
	
	if @FilterListedRecordsOnly = 0 
	begin
	
		--DECLARE @context VARCHAR(50)
		--SET @context = dbo.fnGetContext()

		delete  nID
		from  dbo.tflNewID as nID
			inner join inserted as ins
			on   ins.idfBatchTest = nID.idfKey1
		where  nID.strTableName = 'tflBatchTestFiltered'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select  
				'tflBatchTestFiltered', 
				ins.idfBatchTest, 
				sg.idfSiteGroup
		from  inserted as ins
			inner join dbo.tflSiteToSiteGroup as stsg
			on   stsg.idfsSite = ins.idfsSite
			
			inner join dbo.tflSiteGroup sg
			on	sg.idfSiteGroup = stsg.idfSiteGroup
				and sg.idfsRayon is null
				and sg.idfsCentralSite is null
				and sg.intRowStatus = 0
				
			left join dbo.tflBatchTestFiltered as btf
			on  btf.idfBatchTest = ins.idfBatchTest
				and btf.idfSiteGroup = sg.idfSiteGroup
		where  btf.idfBatchTestFiltered is null

		insert into dbo.tflBatchTestFiltered
			(
				idfBatchTestFiltered, 
				idfBatchTest, 
				idfSiteGroup
			)
		select 
				nID.NewID, 
				ins.idfBatchTest, 
				nID.idfKey2
		from  inserted as ins
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflBatchTestFiltered'
				and nID.idfKey1 = ins.idfBatchTest
				and nID.idfKey2 is not null
			left join dbo.tflBatchTestFiltered as btf
			on   btf.idfBatchTestFiltered = nID.NewID
		where  btf.idfBatchTestFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join inserted as ins
			on   ins.idfBatchTest = nID.idfKey1
		where  nID.strTableName = 'tflBatchTestFiltered'
	end

	SET NOCOUNT OFF;
END
				
GO


CREATE TRIGGER [dbo].[TR_tlbBatchTest_I_Delete] on [dbo].[tlbBatchTest]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfBatchTest]) as
		(
			SELECT [idfBatchTest] FROM deleted
			EXCEPT
			SELECT [idfBatchTest] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1,
			datModificationForArchiveDate = getdate()
		FROM dbo.tlbBatchTest as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfBatchTest = b.idfBatchTest;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Batch test parameters', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbBatchTest';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Batch test identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbBatchTest', @level2type = N'COLUMN', @level2name = N'idfBatchTest';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Batch Test type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbBatchTest', @level2type = N'COLUMN', @level2name = N'idfsTestName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Institution validated test results identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbBatchTest', @level2type = N'COLUMN', @level2name = N'idfValidatedByOffice';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Officer validated test results identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbBatchTest', @level2type = N'COLUMN', @level2name = N'idfValidatedByPerson';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Flex-form assocciated with batch identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbBatchTest', @level2type = N'COLUMN', @level2name = N'idfObservation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Date/time of the Batch test results validation', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbBatchTest', @level2type = N'COLUMN', @level2name = N'datValidatedDate';

