CREATE TABLE [dbo].[trtDerivativeForSampleTypeToCP] (
    [idfDerivativeForSampleType] BIGINT           NOT NULL,
    [idfCustomizationPackage]    BIGINT           NOT NULL,
    [rowguid]                    UNIQUEIDENTIFIER CONSTRAINT [DF_trtDerivativeForSampleTypeToCP_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]         NVARCHAR (20)    NULL,
    [strReservedAttribute]       NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]         BIGINT           NULL,
    [SourceSystemKeyValue]       NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtDerivativeForSampleTypeToCP] PRIMARY KEY CLUSTERED ([idfDerivativeForSampleType] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_trtDerivativeForSampleTypeToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtDerivativeForSampleTypeToCP_trtDerivativeForSampleType__idfDerivativeForSampleType] FOREIGN KEY ([idfDerivativeForSampleType]) REFERENCES [dbo].[trtDerivativeForSampleType] ([idfDerivativeForSampleType]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtDerivativeForSampleTypeToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtDerivativeForSampleTypeToCP_A_Update] ON [dbo].[trtDerivativeForSampleTypeToCP]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfDerivativeForSampleType]) OR UPDATE([idfCustomizationPackage])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Derivative for sample identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtDerivativeForSampleTypeToCP', @level2type = N'COLUMN', @level2name = N'idfDerivativeForSampleType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Country identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtDerivativeForSampleTypeToCP', @level2type = N'COLUMN', @level2name = N'idfCustomizationPackage';

