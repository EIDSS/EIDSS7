CREATE TABLE [dbo].[tlbFarmActual] (
    [idfFarmActual]               BIGINT           NOT NULL,
    [idfsAvianFarmType]           BIGINT           NULL,
    [idfsAvianProductionType]     BIGINT           NULL,
    [idfsFarmCategory]            BIGINT           NULL,
    [idfsOwnershipStructure]      BIGINT           NULL,
    [idfsMovementPattern]         BIGINT           NULL,
    [idfsIntendedUse]             BIGINT           NULL,
    [idfsGrazingPattern]          BIGINT           NULL,
    [idfsLivestockProductionType] BIGINT           NULL,
    [idfHumanActual]              BIGINT           NULL,
    [idfFarmAddress]              BIGINT           NULL,
    [strInternationalName]        NVARCHAR (200)   NULL,
    [strNationalName]             NVARCHAR (200)   NULL,
    [strFarmCode]                 NVARCHAR (200)   NULL,
    [strFax]                      NVARCHAR (200)   NULL,
    [strEmail]                    NVARCHAR (200)   NULL,
    [strContactPhone]             NVARCHAR (200)   NULL,
    [intLivestockTotalAnimalQty]  INT              NULL,
    [intAvianTotalAnimalQty]      INT              NULL,
    [intLivestockSickAnimalQty]   INT              NULL,
    [intAvianSickAnimalQty]       INT              NULL,
    [intLivestockDeadAnimalQty]   INT              NULL,
    [intAvianDeadAnimalQty]       INT              NULL,
    [intBuidings]                 INT              NULL,
    [intBirdsPerBuilding]         INT              NULL,
    [strNote]                     NVARCHAR (2000)  NULL,
    [rowguid]                     UNIQUEIDENTIFIER CONSTRAINT [newid__20832] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]                INT              CONSTRAINT [tlbFarmActual_intRowStatus] DEFAULT ((0)) NOT NULL,
    [intHACode]                   INT              NULL,
    [datModificationDate]         DATETIME         NULL,
    [strMaintenanceFlag]          NVARCHAR (20)    NULL,
    [strReservedAttribute]        NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]          BIGINT           NULL,
    [SourceSystemKeyValue]        NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbFarmActual] PRIMARY KEY CLUSTERED ([idfFarmActual] ASC),
    CONSTRAINT [FK_tlbFarmActual_tlbGeoLocationShared__idfFarmAddress_R_1473] FOREIGN KEY ([idfFarmAddress]) REFERENCES [dbo].[tlbGeoLocationShared] ([idfGeoLocationShared]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarmActual_tlbHumanActual__idfHumanActual_R_1470] FOREIGN KEY ([idfHumanActual]) REFERENCES [dbo].[tlbHumanActual] ([idfHumanActual]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarmActual_trtBaseReference__idfsAvianFarmType_R_1295] FOREIGN KEY ([idfsAvianFarmType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarmActual_trtBaseReference__idfsAvianProductionType_R_1294] FOREIGN KEY ([idfsAvianProductionType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarmActual_trtBaseReference__idfsFarmCategory_R_1288] FOREIGN KEY ([idfsFarmCategory]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarmActual_trtBaseReference__idfsGrazingPattern_R_1298] FOREIGN KEY ([idfsGrazingPattern]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarmActual_trtBaseReference__idfsIntendedUse_R_1299] FOREIGN KEY ([idfsIntendedUse]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarmActual_trtBaseReference__idfsLivestockProductionType_R_1296] FOREIGN KEY ([idfsLivestockProductionType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarmActual_trtBaseReference__idfsMovementPattern_R_1300] FOREIGN KEY ([idfsMovementPattern]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarmActual_trtBaseReference__idfsOwnershipStructure_R_1287] FOREIGN KEY ([idfsOwnershipStructure]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbFarmActual_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tlbFarmActual_A_Update] ON [dbo].[tlbFarmActual]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfFarmActual))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbFarmActual_I_Delete] on [dbo].[tlbFarmActual]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfFarmActual]) as
		(
			SELECT [idfFarmActual] FROM deleted
			EXCEPT
			SELECT [idfFarmActual] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbFarmActual as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfFarmActual = b.idfFarmActual;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Actual Farms', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FarmActual identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual', @level2type = N'COLUMN', @level2name = N'idfFarmActual';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Avian farm type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual', @level2type = N'COLUMN', @level2name = N'idfsAvianFarmType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Avian production type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual', @level2type = N'COLUMN', @level2name = N'idfsAvianProductionType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Farm category identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual', @level2type = N'COLUMN', @level2name = N'idfsFarmCategory';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ownership structure identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual', @level2type = N'COLUMN', @level2name = N'idfsOwnershipStructure';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Movement Patter identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual', @level2type = N'COLUMN', @level2name = N'idfsMovementPattern';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Farm Production intended use identifier ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual', @level2type = N'COLUMN', @level2name = N'idfsIntendedUse';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Grazing patter identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual', @level2type = N'COLUMN', @level2name = N'idfsGrazingPattern';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Livestock production type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual', @level2type = N'COLUMN', @level2name = N'idfsLivestockProductionType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Farm owner identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual', @level2type = N'COLUMN', @level2name = N'idfHumanActual';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Farm address identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual', @level2type = N'COLUMN', @level2name = N'idfFarmAddress';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Internation (english) name of the farm', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual', @level2type = N'COLUMN', @level2name = N'strInternationalName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Translated name of the farm', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual', @level2type = N'COLUMN', @level2name = N'strNationalName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Alphanumeric farm code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual', @level2type = N'COLUMN', @level2name = N'strFarmCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Fax number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual', @level2type = N'COLUMN', @level2name = N'strFax';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'e-mail address', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual', @level2type = N'COLUMN', @level2name = N'strEmail';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'phone number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbFarmActual', @level2type = N'COLUMN', @level2name = N'strContactPhone';

