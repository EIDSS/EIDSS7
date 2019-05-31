CREATE TABLE [dbo].[trtTestForDiseaseToCP] (
    [idfTestForDisease]       BIGINT           NOT NULL,
    [idfCustomizationPackage] BIGINT           NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [DF_trtTestForDiseaseToCP_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]      NVARCHAR (20)    NULL,
    [strReservedAttribute]    NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtTestForDiseaseToCP] PRIMARY KEY CLUSTERED ([idfTestForDisease] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_trtTestForDiseaseToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtTestForDiseaseToCP_trtTestForDisease__idfTestForDisease_R_1884] FOREIGN KEY ([idfTestForDisease]) REFERENCES [dbo].[trtTestForDisease] ([idfTestForDisease]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtTestForDiseaseToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtTestForDiseaseToCP_A_Update] ON [dbo].[trtTestForDiseaseToCP]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfTestForDisease]) OR UPDATE([idfCustomizationPackage])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Test for disease identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtTestForDiseaseToCP', @level2type = N'COLUMN', @level2name = N'idfTestForDisease';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Country identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtTestForDiseaseToCP', @level2type = N'COLUMN', @level2name = N'idfCustomizationPackage';

