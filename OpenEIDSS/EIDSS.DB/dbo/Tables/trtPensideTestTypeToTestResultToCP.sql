CREATE TABLE [dbo].[trtPensideTestTypeToTestResultToCP] (
    [idfsPensideTestName]     BIGINT           NOT NULL,
    [idfsPensideTestResult]   BIGINT           NOT NULL,
    [idfCustomizationPackage] BIGINT           NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [DF_trtPensideTestTypeToTestResultToCP_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]      NVARCHAR (20)    NULL,
    [strReservedAttribute]    NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtPensideTestTypeToTestResultToCP] PRIMARY KEY CLUSTERED ([idfsPensideTestName] ASC, [idfsPensideTestResult] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_trtPensideTestTypeToTestResultToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtPensideTestTypeToTestResultToCP_trtPensideTestTypeToTestResult__idfsPensideTestName_idfsPensideTestResult] FOREIGN KEY ([idfsPensideTestName], [idfsPensideTestResult]) REFERENCES [dbo].[trtPensideTestTypeToTestResult] ([idfsPensideTestName], [idfsPensideTestResult]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtPensideTestTypeToTestResultToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtPensideTestTypeToTestResultToCP_A_Update] ON [dbo].[trtPensideTestTypeToTestResultToCP]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfsPensideTestName]) OR UPDATE([idfsPensideTestResult]) OR UPDATE([idfCustomizationPackage])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Country identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtPensideTestTypeToTestResultToCP', @level2type = N'COLUMN', @level2name = N'idfCustomizationPackage';

