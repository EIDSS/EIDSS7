CREATE TABLE [dbo].[trtPensideTestForDiseaseToCP] (
    [idfPensideTestForDisease] BIGINT           NOT NULL,
    [idfCustomizationPackage]  BIGINT           NOT NULL,
    [rowguid]                  UNIQUEIDENTIFIER CONSTRAINT [DF_trtPensideTestForDiseaseToCP_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]       NVARCHAR (20)    NULL,
    [strReservedAttribute]     NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]       BIGINT           NULL,
    [SourceSystemKeyValue]     NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtPensideTestForDiseaseToCP] PRIMARY KEY CLUSTERED ([idfPensideTestForDisease] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_trtPensideTestForDiseaseToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtPensideTestForDiseaseToCP_trtPensideTestForDisease__idfPensideTestForDisease] FOREIGN KEY ([idfPensideTestForDisease]) REFERENCES [dbo].[trtPensideTestForDisease] ([idfPensideTestForDisease]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtPensideTestForDiseaseToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtPensideTestForDiseaseToCP_A_Update] ON [dbo].[trtPensideTestForDiseaseToCP]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfPensideTestForDisease]) OR UPDATE([idfCustomizationPackage])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
