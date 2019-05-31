CREATE TABLE [dbo].[tlbBasicSyndromicSurveillanceAggregateHeader] (
    [idfAggregateHeader]            BIGINT           NOT NULL,
    [strFormID]                     NVARCHAR (200)   NOT NULL,
    [datDateEntered]                DATETIME         NOT NULL,
    [datDateLastSaved]              DATETIME         NOT NULL,
    [idfEnteredBy]                  BIGINT           NOT NULL,
    [idfsSite]                      BIGINT           CONSTRAINT [Def_fnSiteID_tlbBasicSyndromicSurveillanceAggregateHeader] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [intYear]                       INT              NOT NULL,
    [intWeek]                       INT              NOT NULL,
    [datStartDate]                  DATETIME         NOT NULL,
    [datFinishDate]                 DATETIME         NOT NULL,
    [datModificationForArchiveDate] DATETIME         CONSTRAINT [tlbBasicSyndromicSurveillanceAggregateHeader_datModificationForArchiveDate] DEFAULT (getdate()) NULL,
    [intRowStatus]                  INT              CONSTRAINT [Def_tlbBasicSyndromicSurveillanceAggregateHeader_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]                       UNIQUEIDENTIFIER CONSTRAINT [Def_tlbBasicSyndromicSurveillanceAggregateHeader_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]            NVARCHAR (20)    NULL,
    [strReservedAttribute]          NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]            BIGINT           NULL,
    [SourceSystemKeyValue]          NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbBasicSyndromicSurveillanceAggregateHeader] PRIMARY KEY CLUSTERED ([idfAggregateHeader] ASC),
    CONSTRAINT [FK_tlbBasicSyndromicSurveillanceAggregateHeader_tlbPerson__idfEnteredBy] FOREIGN KEY ([idfEnteredBy]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillanceAggregateHeader_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbBasicSyndromicSurveillanceAggregateHeader_tstSite__idfsSite] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO

-- =============================================
-- Author:		Romasheva Svetlana
-- Create date: 2013-09-24
-- Description:	Trigger for correct problems 
--              with replication and checkin in the same time
-- =============================================
CREATE TRIGGER [dbo].[trtBasicSyndromicSurveillanceAggregateHeaderReplicationUp] 
   ON  [dbo].[tlbBasicSyndromicSurveillanceAggregateHeader]
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
		on   ins.idfAggregateHeader = nID.idfKey1
	where  nID.strTableName = 'tflBasicSyndromicSurveillanceAggregateHeaderFiltered'

	insert into dbo.tflNewID 
		(
			strTableName, 
			idfKey1, 
			idfKey2
		)
	select  
			'tflBasicSyndromicSurveillanceAggregateHeaderFiltered', 
			ins.idfAggregateHeader, 
			sg.idfSiteGroup
	from  inserted as ins
		inner join dbo.tflSiteToSiteGroup as stsg
		on   stsg.idfsSite = ins.idfsSite
		
		inner join dbo.tflSiteGroup sg
		on	sg.idfSiteGroup = stsg.idfSiteGroup
			and sg.idfsRayon is null
			and sg.idfsCentralSite is null
			and sg.intRowStatus = 0
			
		left join dbo.tflBasicSyndromicSurveillanceAggregateHeaderFiltered as bsshf
		on  bsshf.idfAggregateHeader = ins.idfAggregateHeader
			and bsshf.idfSiteGroup = sg.idfSiteGroup
	where  bsshf.idfBasicSyndromicSurveillanceAggregateHeaderFiltered is null

	insert into dbo.tflBasicSyndromicSurveillanceAggregateHeaderFiltered 
		(
			idfBasicSyndromicSurveillanceAggregateHeaderFiltered, 
			idfAggregateHeader, 
			idfSiteGroup
		)
	select 
			nID.NewID, 
			ins.idfAggregateHeader, 
			nID.idfKey2
	from  inserted as ins
		inner join dbo.tflNewID as nID
		on  nID.strTableName = 'tflBasicSyndromicSurveillanceAggregateHeaderFiltered'
			and nID.idfKey1 = ins.idfAggregateHeader
			and nID.idfKey2 is not null
		left join dbo.tflBasicSyndromicSurveillanceAggregateHeaderFiltered as bsshf
		on   bsshf.idfBasicSyndromicSurveillanceAggregateHeaderFiltered = nID.NewID
	where  bsshf.idfBasicSyndromicSurveillanceAggregateHeaderFiltered is null

	delete  nID
	from  dbo.tflNewID as nID
		inner join inserted as ins
		on   ins.idfAggregateHeader = nID.idfKey1
	where  nID.strTableName = 'tflBasicSyndromicSurveillanceAggregateHeaderFiltered'
	

	SET NOCOUNT OFF;
END



GO


CREATE TRIGGER [dbo].[TR_tlbBasicSyndromicSurveillanceAggregateHeader_I_Delete] on [dbo].[tlbBasicSyndromicSurveillanceAggregateHeader]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfAggregateHeader]) as
		(
			SELECT [idfAggregateHeader] FROM deleted
			EXCEPT
			SELECT [idfAggregateHeader] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1,
			datModificationForArchiveDate = getdate()
		FROM dbo.tlbBasicSyndromicSurveillanceAggregateHeader as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfAggregateHeader = b.idfAggregateHeader;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbBasicSyndromicSurveillanceAggregateHeader_A_Update] ON [dbo].[tlbBasicSyndromicSurveillanceAggregateHeader]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfAggregateHeader))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
