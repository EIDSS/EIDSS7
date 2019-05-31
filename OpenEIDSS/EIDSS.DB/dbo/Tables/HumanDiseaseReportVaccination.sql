CREATE TABLE [dbo].[HumanDiseaseReportVaccination] (
    [HumanDiseaseReportVaccinationUID] BIGINT           NOT NULL,
    [idfHumanCase]                     BIGINT           NOT NULL,
    [VaccinationName]                  NVARCHAR (200)   NULL,
    [VaccinationDate]                  DATETIME         NULL,
    [intRowStatus]                     INT              DEFAULT ((0)) NOT NULL,
    [AuditCreateUser]                  VARCHAR (100)    NOT NULL,
    [AuditCreateDTM]                   DATETIME         DEFAULT (getdate()) NOT NULL,
    [AuditUpdateUser]                  VARCHAR (100)    NULL,
    [AuditUpdateDTM]                   DATETIME         NULL,
    [rowguid]                          UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]               BIGINT           NULL,
    [SourceSystemKeyValue]             NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKHumanDiseaseReportVAccination] PRIMARY KEY CLUSTERED ([HumanDiseaseReportVaccinationUID] ASC),
    CONSTRAINT [FK_HumanDiseaseReportVaccination_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [R_1417] FOREIGN KEY ([idfHumanCase]) REFERENCES [dbo].[tlbHumanCase] ([idfHumanCase])
);


GO


CREATE TRIGGER [dbo].[TR_HumanDiseaseReportVaccination_I_Delete] on [dbo].[HumanDiseaseReportVaccination]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([HumanDiseaseReportVaccinationUID]) as
		(
			SELECT [HumanDiseaseReportVaccinationUID] FROM deleted
			EXCEPT
			SELECT [HumanDiseaseReportVaccinationUID] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1,
			AuditUpdateUser = SYSTEM_USER,
			AuditUpdateDTM = GETDATE()
		FROM dbo.HumanDiseaseReportVaccination as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.[HumanDiseaseReportVaccinationUID] = b.[HumanDiseaseReportVaccinationUID];

	END

END

GO

CREATE TRIGGER [dbo].[TR_HumanDiseaseReportVaccination_A_Update] ON [dbo].[HumanDiseaseReportVaccination]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(HumanDiseaseReportVaccinationUID))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
