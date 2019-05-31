CREATE TABLE [dbo].[trtDerivativeForSampleType] (
    [idfDerivativeForSampleType] BIGINT           NOT NULL,
    [idfsSampleType]             BIGINT           NOT NULL,
    [idfsDerivativeType]         BIGINT           NOT NULL,
    [intRowStatus]               INT              CONSTRAINT [Def_0_2680] DEFAULT ((0)) NOT NULL,
    [rowguid]                    UNIQUEIDENTIFIER CONSTRAINT [newid__2580] DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]         NVARCHAR (20)    NULL,
    [strReservedAttribute]       NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]         BIGINT           NULL,
    [SourceSystemKeyValue]       NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtDerivativeForSampleType] PRIMARY KEY CLUSTERED ([idfDerivativeForSampleType] ASC),
    CONSTRAINT [FK_trtDerivativeForSampleType_trtBaseReference__idfsDerivativeType_R_1863] FOREIGN KEY ([idfsDerivativeType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtDerivativeForSampleType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtDerivativeForSampleType_trtSampleType__idfsSampleType_R_1862] FOREIGN KEY ([idfsSampleType]) REFERENCES [dbo].[trtSampleType] ([idfsSampleType]) NOT FOR REPLICATION,
    CONSTRAINT [UQ_trtDerivativeForSampleType] UNIQUE NONCLUSTERED ([idfsSampleType] ASC, [idfsDerivativeType] ASC)
);


GO


CREATE TRIGGER [dbo].[TR_trtDerivativeForSampleType_I_Delete] on [dbo].[trtDerivativeForSampleType]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfDerivativeForSampleType]) as
		(
			SELECT [idfDerivativeForSampleType] FROM deleted
			EXCEPT
			SELECT [idfDerivativeForSampleType] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtDerivativeForSampleType as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfDerivativeForSampleType = b.idfDerivativeForSampleType;

	END

END

GO

CREATE TRIGGER [dbo].[TR_trtDerivativeForSampleType_A_Update] ON [dbo].[trtDerivativeForSampleType]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfDerivativeForSampleType))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Derivative for sample identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtDerivativeForSampleType', @level2type = N'COLUMN', @level2name = N'idfDerivativeForSampleType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sample type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtDerivativeForSampleType', @level2type = N'COLUMN', @level2name = N'idfsSampleType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Derivative type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtDerivativeForSampleType', @level2type = N'COLUMN', @level2name = N'idfsDerivativeType';

