CREATE TABLE [dbo].[trtStatisticDataType] (
    [idfsStatisticDataType]   BIGINT           NOT NULL,
    [idfsReferenceType]       BIGINT           NULL,
    [idfsStatisticAreaType]   BIGINT           NOT NULL,
    [idfsStatisticPeriodType] BIGINT           NOT NULL,
    [intRowStatus]            INT              CONSTRAINT [Def_0_2000] DEFAULT ((0)) NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [newid__2003] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [blnRelatedWithAgeGroup]  BIT              NULL,
    [strMaintenanceFlag]      NVARCHAR (20)    NULL,
    [strReservedAttribute]    NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtStatisticDataType] PRIMARY KEY CLUSTERED ([idfsStatisticDataType] ASC),
    CONSTRAINT [FK_trtStatisticDataType_trtBaseReference__idfsStatisticAreaType_R_1591] FOREIGN KEY ([idfsStatisticAreaType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtStatisticDataType_trtBaseReference__idfsStatisticDataType_R_496] FOREIGN KEY ([idfsStatisticDataType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtStatisticDataType_trtBaseReference__idfsStatisticPeriodType_R_1592] FOREIGN KEY ([idfsStatisticPeriodType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtStatisticDataType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtStatisticDataType_trtReferenceType__idfsReferenceType_R_933] FOREIGN KEY ([idfsReferenceType]) REFERENCES [dbo].[trtReferenceType] ([idfsReferenceType]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtStatisticDataType_A_Update] ON [dbo].[trtStatisticDataType]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsStatisticDataType))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO



CREATE TRIGGER [dbo].[TR_trtStatisticDataType_I_Delete] on [dbo].[trtStatisticDataType]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([idfsStatisticDataType]) as
		(
			SELECT [idfsStatisticDataType] FROM deleted
			EXCEPT
			SELECT [idfsStatisticDataType] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtStatisticDataType as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.idfsStatisticDataType = b.idfsStatisticDataType;


		WITH cteOnlyDeletedRows([idfsStatisticDataType]) as
		(
			SELECT [idfsStatisticDataType] FROM deleted
			EXCEPT
			SELECT [idfsStatisticDataType] FROM inserted
		)

		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.idfsBaseReference = b.idfsStatisticDataType;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Statistic data types', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtStatisticDataType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Statistical data type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtStatisticDataType', @level2type = N'COLUMN', @level2name = N'idfsStatisticDataType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Base reference type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtStatisticDataType', @level2type = N'COLUMN', @level2name = N'idfsReferenceType';

