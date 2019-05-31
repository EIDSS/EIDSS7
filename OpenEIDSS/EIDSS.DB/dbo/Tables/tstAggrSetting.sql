CREATE TABLE [dbo].[tstAggrSetting] (
    [idfsAggrCaseType]        BIGINT           NOT NULL,
    [idfCustomizationPackage] BIGINT           NOT NULL,
    [idfsStatisticAreaType]   BIGINT           NOT NULL,
    [idfsStatisticPeriodType] BIGINT           NOT NULL,
    [strValue]                NVARCHAR (200)   NULL,
    [intRowStatus]            INT              CONSTRAINT [Def_0_2023] DEFAULT ((0)) NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [newid__2026] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstAggrSetting] PRIMARY KEY CLUSTERED ([idfsAggrCaseType] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_tstAggrSetting_trtBaseReference__idfsAggrCaseType_R_941] FOREIGN KEY ([idfsAggrCaseType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstAggrSetting_trtBaseReference__idfsStatisticAreaType_R_1612] FOREIGN KEY ([idfsStatisticAreaType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstAggrSetting_trtBaseReference__idfsStatisticPeriodType_R_1613] FOREIGN KEY ([idfsStatisticPeriodType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstAggrSetting_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstAggrSetting_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tstAggrSetting_A_Update] ON [dbo].[tstAggrSetting]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfsAggrCaseType]) OR UPDATE([idfCustomizationPackage])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END

GO


CREATE TRIGGER [dbo].[TR_tstAggrSetting_I_Delete] on [dbo].[tstAggrSetting]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsAggrCaseType], [idfCustomizationPackage]) as
		(
			SELECT [idfsAggrCaseType], [idfCustomizationPackage] FROM deleted
			EXCEPT
			SELECT [idfsAggrCaseType], [idfCustomizationPackage] FROM inserted
		)

		UPDATE a
		SET  intRowStatus = 1
		FROM dbo.tstAggrSetting as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsAggrCaseType = b.idfsAggrCaseType
			AND a.idfCustomizationPackage = b.idfCustomizationPackage;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Country identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstAggrSetting', @level2type = N'COLUMN', @level2name = N'idfCustomizationPackage';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Value', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstAggrSetting', @level2type = N'COLUMN', @level2name = N'strValue';

