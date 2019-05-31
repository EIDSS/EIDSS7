CREATE TABLE [dbo].[tlbStatistic] (
    [idfStatistic]            BIGINT           NOT NULL,
    [idfsStatisticDataType]   BIGINT           NOT NULL,
    [idfsMainBaseReference]   BIGINT           NULL,
    [idfsStatisticAreaType]   BIGINT           NULL,
    [idfsStatisticPeriodType] BIGINT           NULL,
    [idfsArea]                BIGINT           NOT NULL,
    [datStatisticStartDate]   DATETIME         NULL,
    [datStatisticFinishDate]  DATETIME         NULL,
    [varValue]                SQL_VARIANT      NULL,
    [intRowStatus]            INT              CONSTRAINT [Def_0_2001] DEFAULT ((0)) NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [newid__2004] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfsStatisticalAgeGroup] BIGINT           NULL,
    [strMaintenanceFlag]      NVARCHAR (20)    NULL,
    [strReservedAttribute]    NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbStatistic] PRIMARY KEY CLUSTERED ([idfStatistic] ASC),
    CONSTRAINT [FK_tlbStatistic_gisBaseReference__idfsArea_R_1641] FOREIGN KEY ([idfsArea]) REFERENCES [dbo].[gisBaseReference] ([idfsGISBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbStatistic_trtBaseReference__idfsMainBaseReference_R_923] FOREIGN KEY ([idfsMainBaseReference]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbStatistic_trtBaseReference__idfsStatisticAreaType_R_1273] FOREIGN KEY ([idfsStatisticAreaType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbStatistic_trtBaseReference__idfsStatisticPeriodType_R_1272] FOREIGN KEY ([idfsStatisticPeriodType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbStatistic_trtBaseReference_idfsStatisticalAgeGroup] FOREIGN KEY ([idfsStatisticalAgeGroup]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbStatistic_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbStatistic_trtStatisticDataType__idfsStatisticDataType_R_921] FOREIGN KEY ([idfsStatisticDataType]) REFERENCES [dbo].[trtStatisticDataType] ([idfsStatisticDataType]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tlbStatistic_A_Update] ON [dbo].[tlbStatistic]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfStatistic))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO




CREATE TRIGGER [dbo].[TR_tlbStatistic_I_Delete] on [dbo].[tlbStatistic]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfStatistic]) as
		(
			SELECT [idfStatistic] FROM deleted
			EXCEPT
			SELECT [idfStatistic] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbStatistic as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfStatistic = b.idfStatistic;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Statistics', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbStatistic';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Statistic value identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbStatistic', @level2type = N'COLUMN', @level2name = N'idfStatistic';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Statistic data type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbStatistic', @level2type = N'COLUMN', @level2name = N'idfsStatisticDataType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Statistic value related Area type', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbStatistic', @level2type = N'COLUMN', @level2name = N'idfsStatisticAreaType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Statistic value related Period type', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbStatistic', @level2type = N'COLUMN', @level2name = N'idfsStatisticPeriodType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Statistic Value Related Area identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbStatistic', @level2type = N'COLUMN', @level2name = N'idfsArea';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Statistic value related period start date', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbStatistic', @level2type = N'COLUMN', @level2name = N'datStatisticStartDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Statistic value related period end date', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbStatistic', @level2type = N'COLUMN', @level2name = N'datStatisticFinishDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Statistic value ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbStatistic', @level2type = N'COLUMN', @level2name = N'varValue';

