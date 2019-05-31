CREATE TYPE [dbo].[VeterinaryDiseaseReportLogTableType] AS TABLE (
    [VeterinaryDiseaseReportLogID] BIGINT          NOT NULL,
    [LogStatusTypeID]              BIGINT          NULL,
    [VeterinaryDiseaseReportID]    BIGINT          NULL,
    [PersonID]                     BIGINT          NULL,
    [LogDate]                      DATETIME        NULL,
    [ActionRequired]               NVARCHAR (200)  NULL,
    [Note]                         NVARCHAR (1000) NULL,
    [RowStatus]                    INT             NOT NULL,
    [MaintenanceFlag]              NVARCHAR (20)   NULL,
    [RecordAction]                 NCHAR (1)       NULL,
    PRIMARY KEY CLUSTERED ([VeterinaryDiseaseReportLogID] ASC));

