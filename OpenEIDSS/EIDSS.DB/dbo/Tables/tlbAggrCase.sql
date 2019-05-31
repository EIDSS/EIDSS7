CREATE TABLE [dbo].[tlbAggrCase] (
    [idfAggrCase]                   BIGINT           NOT NULL,
    [idfsAggrCaseType]              BIGINT           NOT NULL,
    [idfsAdministrativeUnit]        BIGINT           NOT NULL,
    [idfReceivedByOffice]           BIGINT           NULL,
    [idfReceivedByPerson]           BIGINT           NULL,
    [idfSentByOffice]               BIGINT           NOT NULL,
    [idfSentByPerson]               BIGINT           NOT NULL,
    [idfEnteredByOffice]            BIGINT           NOT NULL,
    [idfEnteredByPerson]            BIGINT           NOT NULL,
    [idfCaseObservation]            BIGINT           NULL,
    [idfDiagnosticObservation]      BIGINT           NULL,
    [idfProphylacticObservation]    BIGINT           NULL,
    [idfSanitaryObservation]        BIGINT           NULL,
    [idfVersion]                    BIGINT           NULL,
    [idfDiagnosticVersion]          BIGINT           NULL,
    [idfProphylacticVersion]        BIGINT           NULL,
    [idfSanitaryVersion]            BIGINT           NULL,
    [datReceivedByDate]             DATETIME         NULL,
    [datSentByDate]                 DATETIME         NULL,
    [datEnteredByDate]              DATETIME         NULL,
    [datStartDate]                  DATETIME         NULL,
    [datFinishDate]                 DATETIME         NULL,
    [strCaseID]                     NVARCHAR (200)   NULL,
    [intRowStatus]                  INT              CONSTRAINT [Def_0_2496] DEFAULT ((0)) NOT NULL,
    [rowguid]                       UNIQUEIDENTIFIER CONSTRAINT [newid__2471] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [datModificationForArchiveDate] DATETIME         CONSTRAINT [tlbAggrCase_datModificationForArchiveDate] DEFAULT (getdate()) NULL,
    [strMaintenanceFlag]            NVARCHAR (20)    NULL,
    [strReservedAttribute]          NVARCHAR (MAX)   NULL,
    [idfsSite]                      BIGINT           CONSTRAINT [DF__tlbAggrCa__idfsS__67836CA4] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [SourceSystemNameID]            BIGINT           NULL,
    [SourceSystemKeyValue]          NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbAggrCase] PRIMARY KEY CLUSTERED ([idfAggrCase] ASC),
    CONSTRAINT [FK_tlbAggrCase_gisBaseReference__idfsAdministrativeUnit_R_1666] FOREIGN KEY ([idfsAdministrativeUnit]) REFERENCES [dbo].[gisBaseReference] ([idfsGISBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrCase_tlbAggrMatrixVersionHeader__idfDiagnosticVersion_R_1686] FOREIGN KEY ([idfDiagnosticVersion]) REFERENCES [dbo].[tlbAggrMatrixVersionHeader] ([idfVersion]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrCase_tlbAggrMatrixVersionHeader__idfProphylacticVersion_R_1687] FOREIGN KEY ([idfProphylacticVersion]) REFERENCES [dbo].[tlbAggrMatrixVersionHeader] ([idfVersion]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrCase_tlbAggrMatrixVersionHeader__idfSanitaryVersion_R_1688] FOREIGN KEY ([idfSanitaryVersion]) REFERENCES [dbo].[tlbAggrMatrixVersionHeader] ([idfVersion]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrCase_tlbAggrMatrixVersionHeader__idfVersion_R_1684] FOREIGN KEY ([idfVersion]) REFERENCES [dbo].[tlbAggrMatrixVersionHeader] ([idfVersion]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrCase_tlbObservation__idfCaseObservation_R_1608] FOREIGN KEY ([idfCaseObservation]) REFERENCES [dbo].[tlbObservation] ([idfObservation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrCase_tlbObservation__idfDiagnosticObservation_R_1609] FOREIGN KEY ([idfDiagnosticObservation]) REFERENCES [dbo].[tlbObservation] ([idfObservation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrCase_tlbObservation__idfProphylacticObservation_R_1610] FOREIGN KEY ([idfProphylacticObservation]) REFERENCES [dbo].[tlbObservation] ([idfObservation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrCase_tlbObservation__idfSanitaryObservation_R_1611] FOREIGN KEY ([idfSanitaryObservation]) REFERENCES [dbo].[tlbObservation] ([idfObservation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrCase_tlbOffice__idfEnteredByOffice_R_1606] FOREIGN KEY ([idfEnteredByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrCase_tlbOffice__idfReceivedByOffice_R_1602] FOREIGN KEY ([idfReceivedByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrCase_tlbOffice__idfSentByOffice_R_1604] FOREIGN KEY ([idfSentByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrCase_tlbPerson__idfEnteredByPerson_R_1607] FOREIGN KEY ([idfEnteredByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrCase_tlbPerson__idfReceivedByPerson_R_1603] FOREIGN KEY ([idfReceivedByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrCase_tlbPerson__idfSentByPerson_R_1605] FOREIGN KEY ([idfSentByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrCase_trtBaseReference__idfsAggrCaseType_R_1601] FOREIGN KEY ([idfsAggrCaseType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAggrCase_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbAggrCase_tstSite__idfsSite] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO


CREATE TRIGGER [dbo].[TR_tlbAggrCase_I_Delete] on [dbo].[tlbAggrCase]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfAggrCase]) as
		(
			SELECT [idfAggrCase] FROM deleted
			EXCEPT
			SELECT [idfAggrCase] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1,
			datModificationForArchiveDate = getdate()
		FROM dbo.tlbAggrCase as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfAggrCase = b.idfAggrCase;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbAggrCase_A_Update] ON [dbo].[tlbAggrCase]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfAggrCase))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
-- =============================================
-- Author:		Romasheva S.
-- Create date: 2014-05-13
-- Description:	Trigger for correct problems 
--              with replication and checkin in the same time
-- =============================================
CREATE TRIGGER [dbo].[trtAggrCaseReplicationUp] 
   ON  [dbo].[tlbAggrCase]
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
		on   ins.idfAggrCase = nID.idfKey1
	where  nID.strTableName = 'tlbAggrCase'

	insert into dbo.tflNewID 
		(
			strTableName, 
			idfKey1, 
			idfKey2
		)
	select  
			'tlbAggrCase', 
			ins.idfAggrCase, 
			sg.idfSiteGroup
	from  inserted as ins
		inner join dbo.tflSiteToSiteGroup as stsg
		on   stsg.idfsSite = ins.idfsSite
		
		inner join dbo.tflSiteGroup sg
		on	sg.idfSiteGroup = stsg.idfSiteGroup
			and sg.idfsRayon is null
			and sg.idfsCentralSite is null
			and sg.intRowStatus = 0
			
		left join dbo.tflAggrCaseFiltered as acf
		on  acf.idfAggrCase = ins.idfAggrCase
			and acf.idfSiteGroup = sg.idfSiteGroup
	where  acf.idfAggrCaseFiltered is null

	insert into dbo.tflAggrCaseFiltered 
		(
			idfAggrCaseFiltered, 
			idfAggrCase, 
			idfSiteGroup
		)
	select 
			nID.NewID, 
			ins.idfAggrCase, 
			nID.idfKey2
	from  inserted as ins
		inner join dbo.tflNewID as nID
		on  nID.strTableName = 'tlbAggrCase'
			and nID.idfKey1 = ins.idfAggrCase
			and nID.idfKey2 is not null
		left join dbo.tflAggrCaseFiltered as acf
		on   acf.idfAggrCaseFiltered = nID.NewID
	where  acf.idfAggrCaseFiltered is null

	delete  nID
	from  dbo.tflNewID as nID
		inner join inserted as ins
		on   ins.idfAggrCase = nID.idfKey1
	where  nID.strTableName = 'tlbAggrCase'

	SET NOCOUNT OFF;
END


