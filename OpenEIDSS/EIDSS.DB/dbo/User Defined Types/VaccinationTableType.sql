CREATE TYPE [dbo].[VaccinationTableType] AS TABLE (
    [VaccinationID]             BIGINT          NOT NULL,
    [VeterinaryDiseaseReportID] BIGINT          NULL,
    [SpeciesID]                 BIGINT          NULL,
    [VaccinationTypeID]         BIGINT          NULL,
    [VaccinationRouteTypeID]    BIGINT          NULL,
    [DiseaseID]                 BIGINT          NULL,
    [VaccinationDate]           DATETIME        NULL,
    [Manufacturer]              NVARCHAR (200)  NULL,
    [LotNumber]                 NVARCHAR (200)  NULL,
    [NumberVaccinated]          INT             NULL,
    [Note]                      NVARCHAR (2000) NULL,
    [RowStatus]                 INT             NOT NULL,
    [MaintenanceFlag]           NVARCHAR (20)   NULL,
    [RecordAction]              NCHAR (1)       NULL,
    PRIMARY KEY CLUSTERED ([VaccinationID] ASC));

