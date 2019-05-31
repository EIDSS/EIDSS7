CREATE TABLE [dbo].[trtDiagnosisAgeGroupToDiagnosisToCP] (
    [idfDiagnosisAgeGroupToDiagnosis] BIGINT           NOT NULL,
    [idfCustomizationPackage]         BIGINT           NOT NULL,
    [rowguid]                         UNIQUEIDENTIFIER CONSTRAINT [DF_trtDiagnosisAgeGroupToDiagnosisToCP_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]              NVARCHAR (20)    NULL,
    [strReservedAttribute]            NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]              BIGINT           NULL,
    [SourceSystemKeyValue]            NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtDiagnosisAgeGroupToDiagnosisToCP] PRIMARY KEY CLUSTERED ([idfDiagnosisAgeGroupToDiagnosis] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_trtDiagnosisAgeGroupToDiagnosisToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtDiagnosisAgeGroupToDiagnosisToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtDiagnosisAgeGroupToDiagnosisToCP_tstPersonalDataGroup_idfDiagnosisAgeGroupToDiagnosis] FOREIGN KEY ([idfDiagnosisAgeGroupToDiagnosis]) REFERENCES [dbo].[trtDiagnosisAgeGroupToDiagnosis] ([idfDiagnosisAgeGroupToDiagnosis]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtDiagnosisAgeGroupToDiagnosisToCP_A_Update] ON [dbo].[trtDiagnosisAgeGroupToDiagnosisToCP]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfDiagnosisAgeGroupToDiagnosis]) OR UPDATE([idfCustomizationPackage])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
