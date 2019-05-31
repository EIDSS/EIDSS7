CREATE TABLE [dbo].[trtTestTypeToTestResultToCP] (
    [idfsTestName]            BIGINT           NOT NULL,
    [idfsTestResult]          BIGINT           NOT NULL,
    [idfCustomizationPackage] BIGINT           NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [DF_trtTestTypeToTestResultToCP_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]      NVARCHAR (20)    NULL,
    [strReservedAttribute]    NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtTestTypeToTestResultToCP] PRIMARY KEY CLUSTERED ([idfsTestName] ASC, [idfsTestResult] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_trtTestTypeToTestResultToCountry_trtTestTypeToTestResult__idfsTestName_idfsTestResult] FOREIGN KEY ([idfsTestName], [idfsTestResult]) REFERENCES [dbo].[trtTestTypeToTestResult] ([idfsTestName], [idfsTestResult]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtTestTypeToTestResultToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtTestTypeToTestResultToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtTestTypeToTestResultToCP_A_Update] ON [dbo].[trtTestTypeToTestResultToCP]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfsTestName]) OR UPDATE([idfsTestResult]) OR UPDATE([idfCustomizationPackage])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Test type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtTestTypeToTestResultToCP', @level2type = N'COLUMN', @level2name = N'idfsTestName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Test Result identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtTestTypeToTestResultToCP', @level2type = N'COLUMN', @level2name = N'idfsTestResult';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Country identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtTestTypeToTestResultToCP', @level2type = N'COLUMN', @level2name = N'idfCustomizationPackage';

