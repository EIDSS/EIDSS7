CREATE TABLE [dbo].[tlbVaccination] (
    [idfVaccination]       BIGINT           NOT NULL,
    [idfVetCase]           BIGINT           NULL,
    [idfSpecies]           BIGINT           NULL,
    [idfsVaccinationType]  BIGINT           NULL,
    [idfsVaccinationRoute] BIGINT           NULL,
    [idfsDiagnosis]        BIGINT           NULL,
    [datVaccinationDate]   DATETIME         NULL,
    [strManufacturer]      NVARCHAR (200)   NULL,
    [strLotNumber]         NVARCHAR (200)   NULL,
    [intNumberVaccinated]  INT              NULL,
    [strNote]              NVARCHAR (2000)  NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_2086] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2087] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbVaccination] PRIMARY KEY CLUSTERED ([idfVaccination] ASC),
    CONSTRAINT [FK_tlbVaccination_tlbSpecies__idfSpecies_R_1654] FOREIGN KEY ([idfSpecies]) REFERENCES [dbo].[tlbSpecies] ([idfSpecies]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVaccination_tlbVetCase__idfVetCase_R_1482] FOREIGN KEY ([idfVetCase]) REFERENCES [dbo].[tlbVetCase] ([idfVetCase]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVaccination_trtBaseReference__idfsVaccinationRoute_R_1302] FOREIGN KEY ([idfsVaccinationRoute]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVaccination_trtBaseReference__idfsVaccinationType_R_1301] FOREIGN KEY ([idfsVaccinationType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVaccination_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbVaccination_trtDiagnosis__idfsDiagnosis_R_983] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tlbVaccination_A_Update] ON [dbo].[tlbVaccination]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfVaccination))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbVaccination_I_Delete] on [dbo].[tlbVaccination]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfVaccination]) as
		(
			SELECT [idfVaccination] FROM deleted
			EXCEPT
			SELECT [idfVaccination] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbVaccination as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfVaccination = b.idfVaccination;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Vaccinations', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVaccination';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Vaccination identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVaccination', @level2type = N'COLUMN', @level2name = N'idfVaccination';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Vaccination type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVaccination', @level2type = N'COLUMN', @level2name = N'idfsVaccinationType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Diagnosis identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVaccination', @level2type = N'COLUMN', @level2name = N'idfsDiagnosis';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Vaccination date', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVaccination', @level2type = N'COLUMN', @level2name = N'datVaccinationDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Vaccine manufacturer', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVaccination', @level2type = N'COLUMN', @level2name = N'strManufacturer';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Quantity', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVaccination', @level2type = N'COLUMN', @level2name = N'strLotNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Number of vaccinations', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbVaccination', @level2type = N'COLUMN', @level2name = N'intNumberVaccinated';

