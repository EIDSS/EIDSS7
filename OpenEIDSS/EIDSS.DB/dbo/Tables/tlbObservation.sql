CREATE TABLE [dbo].[tlbObservation] (
    [idfObservation]       BIGINT           NOT NULL,
    [idfsFormTemplate]     BIGINT           NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_1972] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__1976] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [idfsSite]             BIGINT           CONSTRAINT [DF__tlbObserv__idfsS__59354D4D] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbObservation] PRIMARY KEY CLUSTERED ([idfObservation] ASC),
    CONSTRAINT [FK_tlbObservation_ffFormTemplate__idfsFormTemplate_R_1405] FOREIGN KEY ([idfsFormTemplate]) REFERENCES [dbo].[ffFormTemplate] ([idfsFormTemplate]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbObservation_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbObservation_tstSite__idfsSite] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO

-- =============================================
-- Author:		Romasheva Svetlana
-- Create date: May 19 2014  2:47PM
-- Description:	Trigger for correct problems 
--              with replication and checkin in the same time
-- =============================================
CREATE TRIGGER [dbo].[trtObservationReplicationUp] 
   ON  [dbo].[tlbObservation]
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
			on   ins.idfObservation = nID.idfKey1
		where  nID.strTableName = 'tflObservationFiltered'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select  
				'tflObservationFiltered', 
				ins.idfObservation, 
				sg.idfSiteGroup
		from  inserted as ins
			inner join dbo.tflSiteToSiteGroup as stsg
			on   stsg.idfsSite = ins.idfsSite
			
			inner join dbo.tflSiteGroup sg
			on	sg.idfSiteGroup = stsg.idfSiteGroup
				and sg.idfsRayon is null
				and sg.idfsCentralSite is null
				and sg.intRowStatus = 0
				
			left join dbo.tflObservationFiltered as btf
			on  btf.idfObservation = ins.idfObservation
				and btf.idfSiteGroup = sg.idfSiteGroup
		where  btf.idfObservationFiltered is null

		insert into dbo.tflObservationFiltered
			(
				idfObservationFiltered, 
				idfObservation, 
				idfSiteGroup
			)
		select 
				nID.NewID, 
				ins.idfObservation, 
				nID.idfKey2
		from  inserted as ins
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflObservationFiltered'
				and nID.idfKey1 = ins.idfObservation
				and nID.idfKey2 is not null
			left join dbo.tflObservationFiltered as btf
			on   btf.idfObservationFiltered = nID.NewID
		where  btf.idfObservationFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join inserted as ins
			on   ins.idfObservation = nID.idfKey1
		where  nID.strTableName = 'tflObservationFiltered'
	end
	SET NOCOUNT OFF;
END
				
GO

CREATE TRIGGER [dbo].[TR_tlbObservation_A_Update] ON [dbo].[tlbObservation]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfObservation))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbObservation_I_Delete] on [dbo].[tlbObservation]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfObservation]) as
		(
			SELECT [idfObservation] FROM deleted
			EXCEPT
			SELECT [idfObservation] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbObservation as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfObservation = b.idfObservation;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Flex-form filled out instances', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbObservation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Flex-Form instance identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbObservation', @level2type = N'COLUMN', @level2name = N'idfObservation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Flex-form template identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbObservation', @level2type = N'COLUMN', @level2name = N'idfsFormTemplate';

