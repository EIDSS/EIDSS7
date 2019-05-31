CREATE TYPE [dbo].[MonitoringSessionToSampleTypeTableType] AS TABLE (
    [MonitoringSessionToSampleTypeID] BIGINT        NOT NULL,
    [MonitoringSessionID]             BIGINT        NOT NULL,
    [SpeciesTypeID]                   BIGINT        NULL,
    [SampleTypeID]                    BIGINT        NULL,
    [OrderNumber]                     INT           NOT NULL,
    [RowStatus]                       INT           NOT NULL,
    [MaintenanceFlag]                 NVARCHAR (20) NULL,
    [RecordAction]                    NCHAR (1)     NULL,
    PRIMARY KEY CLUSTERED ([MonitoringSessionToSampleTypeID] ASC));

