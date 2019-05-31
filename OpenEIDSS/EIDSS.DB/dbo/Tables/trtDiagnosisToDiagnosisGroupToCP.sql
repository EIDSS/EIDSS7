CREATE TABLE [dbo].[trtDiagnosisToDiagnosisGroupToCP] (
    [idfDiagnosisToDiagnosisGroup] BIGINT           NOT NULL,
    [idfCustomizationPackage]      BIGINT           NOT NULL,
    [rowguid]                      UNIQUEIDENTIFIER CONSTRAINT [trtDiagnosisToDiagnosisGroupToCP_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]           NVARCHAR (20)    NULL,
    [strReservedAttribute]         NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]           BIGINT           NULL,
    [SourceSystemKeyValue]         NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtDiagnosisToDiagnosisGroupToCP] PRIMARY KEY CLUSTERED ([idfDiagnosisToDiagnosisGroup] ASC, [idfCustomizationPackage] ASC),
    CONSTRAINT [FK_trtDiagnosisToDiagnosisGroupToCP_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtDiagnosisToDiagnosisGroupToCP_trtDiagnosisToDiagnosisGroup_idfDiagnosisToDiagnosisGroup] FOREIGN KEY ([idfDiagnosisToDiagnosisGroup]) REFERENCES [dbo].[trtDiagnosisToDiagnosisGroup] ([idfDiagnosisToDiagnosisGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtDiagnosisToDiagnosisGroupToCP_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_trtDiagnosisToDiagnosisGroupToCP_A_Update] ON [dbo].[trtDiagnosisToDiagnosisGroupToCP]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([idfDiagnosisToDiagnosisGroup]) OR UPDATE([idfCustomizationPackage])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
