CREATE TABLE [dbo].[trtDiagnosisAgeGroupToStatisticalAgeGroupToCP] (
    [idfDiagnosisAgeGroupToStatisticalAgeGroup] BIGINT           NOT NULL,
    [idfCustomizationPackage]                   BIGINT           NOT NULL,
    [rowguid]                                   UNIQUEIDENTIFIER CONSTRAINT [DF_trtDiagnosisAgeGroupToStatisticalAgeGroupToCP_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]                        NVARCHAR (20)    NULL,
    [strReservedAttribute]                      NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]                        BIGINT           NULL,
    [SourceSystemKeyValue]                      NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtDiagnosisAgeGroupToStatisticalAgeGroupToCP] PRIMARY KEY CLUSTERED ([idfDiagnosisAgeGroupToStatisticalAgeGroup] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_trtDiagnosisAgeGroupToStatisticalAgeGroupToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtDiagnosisAgeGroupToStatisticalAgeGroupToCP_trtDiagnosisAgeGroupToStatisticalAgeGroup] FOREIGN KEY ([idfDiagnosisAgeGroupToStatisticalAgeGroup]) REFERENCES [dbo].[trtDiagnosisAgeGroupToStatisticalAgeGroup] ([idfDiagnosisAgeGroupToStatisticalAgeGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtDiagnosisAgeGroupToStatisticalAgeGroupToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtDiagnosisAgeGroupToStatisticalAgeGroupToCP_A_Update] ON [dbo].[trtDiagnosisAgeGroupToStatisticalAgeGroupToCP]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfDiagnosisAgeGroupToStatisticalAgeGroup]) OR UPDATE([idfCustomizationPackage])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
