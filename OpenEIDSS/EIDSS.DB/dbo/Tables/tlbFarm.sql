CREATE TABLE [dbo].[tlbFarm] (
    [idfFarm]                       BIGINT           NOT NULL,
    [idfFarmActual]                 BIGINT           NULL,
    [idfMonitoringSession]          BIGINT           NULL,
    [idfsAvianFarmType]             BIGINT           NULL,
    [idfsAvianProductionType]       BIGINT           NULL,
    [idfsFarmCategory]              BIGINT           NULL,
    [idfsOwnershipStructure]        BIGINT           NULL,
    [idfsMovementPattern]           BIGINT           NULL,
    [idfsIntendedUse]               BIGINT           NULL,
    [idfsGrazingPattern]            BIGINT           NULL,
    [idfsLivestockProductionType]   BIGINT           NULL,
    [idfHuman]                      BIGINT           NULL,
    [idfFarmAddress]                BIGINT           NULL,
    [idfObservation]                BIGINT           NULL,
    [strInternationalName]          NVARCHAR (200)   NULL,
    [strNationalName]               NVARCHAR (200)   NULL,
    [strFarmCode]                   NVARCHAR (200)   NULL,
    [strFax]                        NVARCHAR (200)   NULL,
    [strEmail]                      NVARCHAR (200)   NULL,
    [strContactPhone]               NVARCHAR (200)   NULL,
    [intLivestockTotalAnimalQty]    INT              NULL,
    [intAvianTotalAnimalQty]        INT              NULL,
    [intLivestockSickAnimalQty]     INT              NULL,
    [intAvianSickAnimalQty]         INT              NULL,
    [intLivestockDeadAnimalQty]     INT              NULL,
    [intAvianDeadAnimalQty]         INT              NULL,
    [intBuidings]                   INT              NULL,
    [intBirdsPerBuilding]           INT              NULL,
    [strNote]                       NVARCHAR (2000)  NULL,
    [rowguid]                       UNIQUEIDENTIFIER CONSTRAINT [newid__2083] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]                  INT              CONSTRAINT [tlbFarm_intRowStatus] DEFAULT ((0)) NOT NULL,
    [intHACode]                     INT              NULL,
    [datModificationDate]           DATETIME         NULL,
    [datModificationForArchiveDate] DATETIME         CONSTRAINT [tlbFarm_datModificationForArchiveDate] DEFAULT (getdate()) NULL,
    [strMaintenanceFlag]            NVARCHAR (20)    NULL,
    [strReservedAttribute]          NVARCHAR (MAX)   NULL,
    [idfsSite]                      BIGINT           CONSTRAINT [DF__tlbFarm__idfsSit__60D66F15] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [SourceSystemNameID]            BIGINT           NULL,
    [SourceSystemKeyValue]          NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbFarm] PRIMARY KEY CLUSTERED ([idfFarm] ASC),
    CONSTRAINT [FK_tlbFarm_tlbFarmActual] FOREIGN KEY ([idfFarmActual]) REFERENCES [dbo].[tlbFarmActual] ([idfFarmActual]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarm_tlbGeoLocation__idfFarmAddress_R_1473] FOREIGN KEY ([idfFarmAddress]) REFERENCES [dbo].[tlbGeoLocation] ([idfGeoLocation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarm_tlbHuman__idfHuman_R_1470] FOREIGN KEY ([idfHuman]) REFERENCES [dbo].[tlbHuman] ([idfHuman]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarm_tlbMonitoringSession] FOREIGN KEY ([idfMonitoringSession]) REFERENCES [dbo].[tlbMonitoringSession] ([idfMonitoringSession]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarm_tlbObservation__idfObservation_R_1471] FOREIGN KEY ([idfObservation]) REFERENCES [dbo].[tlbObservation] ([idfObservation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarm_trtBaseReference__idfsAvianFarmType_R_1295] FOREIGN KEY ([idfsAvianFarmType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarm_trtBaseReference__idfsAvianProductionType_R_1294] FOREIGN KEY ([idfsAvianProductionType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarm_trtBaseReference__idfsFarmCategory_R_1288] FOREIGN KEY ([idfsFarmCategory]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarm_trtBaseReference__idfsGrazingPattern_R_1298] FOREIGN KEY ([idfsGrazingPattern]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarm_trtBaseReference__idfsIntendedUse_R_1299] FOREIGN KEY ([idfsIntendedUse]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarm_trtBaseReference__idfsLivestockProductionType_R_1296] FOREIGN KEY ([idfsLivestockProductionType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarm_trtBaseReference__idfsMovementPattern_R_1300] FOREIGN KEY ([idfsMovementPattern]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarm_trtBaseReference__idfsOwnershipStructure_R_1287] FOREIGN KEY ([idfsOwnershipStructure]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarm_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbFarm_tstSite__idfsSite] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO
CREATE NONCLUSTERED INDEX [IX_tlbFarm_idfMonitoringSession]
    ON [dbo].[tlbFarm]([idfMonitoringSession] ASC)
    INCLUDE([idfFarm]);


GO

-- =============================================
-- Author:		Romasheva Svetlana
-- Create date: May 19 2014  2:42PM
-- Description:	Trigger for correct problems 
--              with replication and checkin in the same time
-- =============================================
CREATE TRIGGER [dbo].[trtFarmReplicationUp] 
   ON  [dbo].[tlbFarm]
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
			on   ins.idfFarm = nID.idfKey1
		where  nID.strTableName = 'tflFarmFiltered'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select  
				'tflFarmFiltered', 
				ins.idfFarm, 
				sg.idfSiteGroup
		from  inserted as ins
			inner join dbo.tflSiteToSiteGroup as stsg
			on   stsg.idfsSite = ins.idfsSite
			
			inner join dbo.tflSiteGroup sg
			on	sg.idfSiteGroup = stsg.idfSiteGroup
				and sg.idfsRayon is null
				and sg.idfsCentralSite is null
				and sg.intRowStatus = 0
				
			left join dbo.tflFarmFiltered as btf
			on  btf.idfFarm = ins.idfFarm
				and btf.idfSiteGroup = sg.idfSiteGroup
		where  btf.idfFarmFiltered is null

		insert into dbo.tflFarmFiltered
			(
				idfFarmFiltered, 
				idfFarm, 
				idfSiteGroup
			)
		select 
				nID.NewID, 
				ins.idfFarm, 
				nID.idfKey2
		from  inserted as ins
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflFarmFiltered'
				and nID.idfKey1 = ins.idfFarm
				and nID.idfKey2 is not null
			left join dbo.tflFarmFiltered as btf
			on   btf.idfFarmFiltered = nID.NewID
		where  btf.idfFarmFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join inserted as ins
			on   ins.idfFarm = nID.idfKey1
		where  nID.strTableName = 'tflFarmFiltered'
	end
	SET NOCOUNT OFF;
END
				
GO


CREATE TRIGGER [dbo].[TR_tlbFarm_I_Delete] on [dbo].[tlbFarm]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfFarm]) as
		(
			SELECT [idfFarm] FROM deleted
			EXCEPT
			SELECT [idfFarm] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1,
			datModificationForArchiveDate = getdate()
		FROM dbo.tlbFarm as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfFarm = b.idfFarm;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbFarm_A_Update] ON [dbo].[tlbFarm]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfFarm))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Farms', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Farm identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'idfFarm';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Avian farm type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'idfsAvianFarmType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Avian production type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'idfsAvianProductionType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Farm category identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'idfsFarmCategory';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Ownership structure identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'idfsOwnershipStructure';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Movement Patter identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'idfsMovementPattern';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Farm Production intended use identifier ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'idfsIntendedUse';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Grazing patter identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'idfsGrazingPattern';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Livestock production type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'idfsLivestockProductionType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Farm owner identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'idfHuman';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Farm address identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'idfFarmAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Farm assocciated flex-form identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'idfObservation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Internation (english) name of the farm', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'strInternationalName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Translated name of the farm', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'strNationalName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Alphanumeric farm code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'strFarmCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Fax number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'strFax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'e-mail address', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'strEmail';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'phone number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarm', @level2type = N'COLUMN', @level2name = N'strContactPhone';

