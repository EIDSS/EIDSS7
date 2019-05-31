CREATE TABLE [dbo].[tlbHuman] (
    [idfHuman]                      BIGINT           NOT NULL,
    [idfHumanActual]                BIGINT           NULL,
    [idfsOccupationType]            BIGINT           NULL,
    [idfsNationality]               BIGINT           NULL,
    [idfsHumanGender]               BIGINT           NULL,
    [idfCurrentResidenceAddress]    BIGINT           NULL,
    [idfEmployerAddress]            BIGINT           NULL,
    [idfRegistrationAddress]        BIGINT           NULL,
    [datDateofBirth]                DATETIME         NULL,
    [datDateOfDeath]                DATETIME         NULL,
    [strLastName]                   NVARCHAR (200)   NOT NULL,
    [strSecondName]                 NVARCHAR (200)   NULL,
    [strFirstName]                  NVARCHAR (200)   NULL,
    [strRegistrationPhone]          NVARCHAR (200)   NULL,
    [strEmployerName]               NVARCHAR (200)   NULL,
    [strHomePhone]                  NVARCHAR (200)   NULL,
    [strWorkPhone]                  NVARCHAR (200)   NULL,
    [rowguid]                       UNIQUEIDENTIFIER CONSTRAINT [newid__1989] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]                  INT              CONSTRAINT [tlbHuman_intRowStatus] DEFAULT ((0)) NOT NULL,
    [idfsPersonIDType]              BIGINT           NULL,
    [strPersonID]                   NVARCHAR (100)   NULL,
    [blnPermantentAddressAsCurrent] BIT              NULL,
    [datEnteredDate]                DATETIME         CONSTRAINT [tlbHuman_datEnteredDate] DEFAULT (getdate()) NULL,
    [datModificationDate]           DATETIME         CONSTRAINT [tlbHuman_datModificationDate] DEFAULT (getdate()) NULL,
    [datModificationForArchiveDate] DATETIME         CONSTRAINT [tlbHuman_datModificationForArchiveDate] DEFAULT (getdate()) NULL,
    [strMaintenanceFlag]            NVARCHAR (20)    NULL,
    [strReservedAttribute]          NVARCHAR (MAX)   NULL,
    [idfsSite]                      BIGINT           CONSTRAINT [DF__tlbHuman__idfsSi__5D05DE31] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [idfMonitoringSession]          BIGINT           NULL,
    [SourceSystemNameID]            BIGINT           NULL,
    [SourceSystemKeyValue]          NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbHuman] PRIMARY KEY CLUSTERED ([idfHuman] ASC),
    CONSTRAINT [FK_tlbHuman_tlbGeoLocation__idfCurrentResidenceAddress_R_1424] FOREIGN KEY ([idfCurrentResidenceAddress]) REFERENCES [dbo].[tlbGeoLocation] ([idfGeoLocation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHuman_tlbGeoLocation__idfEmployerAddress_R_1425] FOREIGN KEY ([idfEmployerAddress]) REFERENCES [dbo].[tlbGeoLocation] ([idfGeoLocation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHuman_tlbGeoLocation__idfRegistrationAddress_R_1426] FOREIGN KEY ([idfRegistrationAddress]) REFERENCES [dbo].[tlbGeoLocation] ([idfGeoLocation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHuman_tlbHumanActual] FOREIGN KEY ([idfHumanActual]) REFERENCES [dbo].[tlbHumanActual] ([idfHumanActual]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHuman_tlbMonitoringSession_MontoringSessionID] FOREIGN KEY ([idfMonitoringSession]) REFERENCES [dbo].[tlbMonitoringSession] ([idfMonitoringSession]),
    CONSTRAINT [FK_tlbHuman_trtBaseReference__idfsHumanGender_R_1232] FOREIGN KEY ([idfsHumanGender]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHuman_trtBaseReference__idfsNationality_R_1278] FOREIGN KEY ([idfsNationality]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHuman_trtBaseReference__idfsOccupationType_R_1233] FOREIGN KEY ([idfsOccupationType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHuman_trtBaseReference_idfsPersonIDType] FOREIGN KEY ([idfsPersonIDType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbHuman_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbHuman_tstSite__idfsSite] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO
CREATE NONCLUSTERED INDEX [IX_tlbHuman_H]
    ON [dbo].[tlbHuman]([idfHuman] ASC);


GO

CREATE TRIGGER [dbo].[TR_tlbHuman_A_Update] ON [dbo].[tlbHuman]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1)
	BEGIN

		IF(UPDATE(idfHuman))
		BEGIN
			RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
			ROLLBACK TRANSACTION
		END

		ELSE -- calculate name
		BEGIN
			
			IF  UPDATE(strLastName) or UPDATE(strSecondName) or UPDATE(strFirstName) 
			BEGIN
				  UPDATE a
				  SET strCalculatedHumanName = ISNULL(HumanFromCase.strLastName + ' ', '') + ISNULL(HumanFromCase.strFirstName + ' ', '') + ISNULL(HumanFromCase.strSecondName, '')
				  FROM tlbMaterial a
				  LEFT JOIN tlbAnimal ON tlbAnimal.idfAnimal = a.idfAnimal AND tlbAnimal.intRowStatus = 0
				  LEFT JOIN tlbSpecies ON (tlbSpecies.idfSpecies = a.idfSpecies	OR tlbSpecies.idfSpecies = tlbAnimal.idfSpecies) AND tlbSpecies.intRowStatus = 0
				  LEFT JOIN tlbHerd ON tlbHerd.idfHerd = tlbSpecies.idfHerd AND tlbHerd.intRowStatus = 0
				  LEFT JOIN tlbFarm ON tlbFarm.idfFarm = tlbHerd.idfFarm AND tlbFarm.intRowStatus = 0
				  INNER JOIN inserted HumanFromCase ON  HumanFromCase.idfHuman=tlbFarm.idfHuman OR HumanFromCase.idfHuman=a.idfHuman
					
			END
		END
	END
END

GO


CREATE TRIGGER [dbo].[TR_tlbHuman_I_Delete] on [dbo].[tlbHuman]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfHuman]) as
		(
			SELECT [idfHuman] FROM deleted
			EXCEPT
			SELECT [idfHuman] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1, 
			datModificationForArchiveDate = getdate()
		FROM dbo.tlbHuman as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfHuman = b.idfHuman;

	END

END

GO


-- =============================================
-- Author:		Romasheva Svetlana
-- Create date: May 19 2014  2:44PM
-- Description:	Trigger for correct problems 
--              with replication and checkin in the same time
-- =============================================
CREATE TRIGGER [dbo].[trtHumanReplicationUp] 
   ON  [dbo].[tlbHuman]
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
			on   ins.idfHuman = nID.idfKey1
		where  nID.strTableName = 'tflHumanFiltered'

		insert into dbo.tflNewID 
			(
				strTableName, 
				idfKey1, 
				idfKey2
			)
		select  
				'tflHumanFiltered', 
				ins.idfHuman, 
				sg.idfSiteGroup
		from  inserted as ins
			inner join dbo.tflSiteToSiteGroup as stsg
			on   stsg.idfsSite = ins.idfsSite
			
			inner join dbo.tflSiteGroup sg
			on	sg.idfSiteGroup = stsg.idfSiteGroup
				and sg.idfsRayon is null
				and sg.idfsCentralSite is null
				and sg.intRowStatus = 0
				
			left join dbo.tflHumanFiltered as btf
			on  btf.idfHuman = ins.idfHuman
				and btf.idfSiteGroup = sg.idfSiteGroup
		where  btf.idfHumanFiltered is null

		insert into dbo.tflHumanFiltered
			(
				idfHumanFiltered, 
				idfHuman, 
				idfSiteGroup
			)
		select 
				nID.NewID, 
				ins.idfHuman, 
				nID.idfKey2
		from  inserted as ins
			inner join dbo.tflNewID as nID
			on  nID.strTableName = 'tflHumanFiltered'
				and nID.idfKey1 = ins.idfHuman
				and nID.idfKey2 is not null
			left join dbo.tflHumanFiltered as btf
			on   btf.idfHumanFiltered = nID.NewID
		where  btf.idfHumanFiltered is null

		delete  nID
		from  dbo.tflNewID as nID
			inner join inserted as ins
			on   ins.idfHuman = nID.idfKey1
		where  nID.strTableName = 'tflHumanFiltered'
	end
	SET NOCOUNT OFF;
END
				
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Human/Patient', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHuman';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Human identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHuman', @level2type = N'COLUMN', @level2name = N'idfHuman';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Occupation type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHuman', @level2type = N'COLUMN', @level2name = N'idfsOccupationType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Nationality identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHuman', @level2type = N'COLUMN', @level2name = N'idfsNationality';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Human gender identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHuman', @level2type = N'COLUMN', @level2name = N'idfsHumanGender';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Current residence address identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHuman', @level2type = N'COLUMN', @level2name = N'idfCurrentResidenceAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Employer address identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHuman', @level2type = N'COLUMN', @level2name = N'idfEmployerAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Registration address identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHuman', @level2type = N'COLUMN', @level2name = N'idfRegistrationAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Date of birth', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHuman', @level2type = N'COLUMN', @level2name = N'datDateofBirth';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Date of death', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHuman', @level2type = N'COLUMN', @level2name = N'datDateOfDeath';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Last name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHuman', @level2type = N'COLUMN', @level2name = N'strLastName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Middle name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHuman', @level2type = N'COLUMN', @level2name = N'strSecondName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'First name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHuman', @level2type = N'COLUMN', @level2name = N'strFirstName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Registration phone number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHuman', @level2type = N'COLUMN', @level2name = N'strRegistrationPhone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Employer''s Name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHuman', @level2type = N'COLUMN', @level2name = N'strEmployerName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Home phone number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHuman', @level2type = N'COLUMN', @level2name = N'strHomePhone';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Work phone number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbHuman', @level2type = N'COLUMN', @level2name = N'strWorkPhone';

