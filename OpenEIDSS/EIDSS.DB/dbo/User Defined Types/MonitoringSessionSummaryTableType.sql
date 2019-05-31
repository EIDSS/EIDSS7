CREATE TYPE [dbo].[MonitoringSessionSummaryTableType] AS TABLE (
    [MonitoringSessionSummaryID] BIGINT        NOT NULL,
    [MonitoringSessionID]        BIGINT        NOT NULL,
    [FarmID]                     BIGINT        NOT NULL,
    [SpeciesID]                  BIGINT        NULL,
    [AnimalGenderTypeID]         BIGINT        NULL,
    [SampledAnimalsQuantity]     INT           NULL,
    [SamplesQuantity]            INT           NULL,
    [CollectionDate]             DATETIME      NULL,
    [PositiveAnimalsQuantity]    INT           NULL,
    [RowStatus]                  INT           NOT NULL,
    [MaintenanceFlag]            NVARCHAR (20) NULL,
    [SampleTypeID]               BIGINT        NULL,
    [SampleCheckedIndicator]     BIT           NULL,
    [DiseaseID]                  BIGINT        NULL,
    [RecordAction]               NCHAR (1)     NULL,
    PRIMARY KEY CLUSTERED ([MonitoringSessionSummaryID] ASC));

