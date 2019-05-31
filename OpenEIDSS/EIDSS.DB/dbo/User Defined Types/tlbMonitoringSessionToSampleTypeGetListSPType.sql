CREATE TYPE [dbo].[tlbMonitoringSessionToSampleTypeGetListSPType] AS TABLE (
    [MonitoringSessionToSampleType] BIGINT         NOT NULL,
    [idfMonitoringSession]          BIGINT         NOT NULL,
    [idfsSpeciesType]               BIGINT         NULL,
    [SpeciesTypeName]               NVARCHAR (200) NULL,
    [idfsSampleType]                BIGINT         NULL,
    [SampleTypeName]                NVARCHAR (200) NULL,
    [intOrder]                      INT            NOT NULL,
    [intRowStatus]                  INT            NOT NULL,
    [strMaintenanceFlag]            NVARCHAR (20)  NULL,
    [RecordAction]                  NCHAR (1)      NULL,
    PRIMARY KEY CLUSTERED ([MonitoringSessionToSampleType] ASC));

