CREATE TYPE [dbo].[MonitoringSessionActionTableType] AS TABLE (
    [MonitoringSessionActionID]           BIGINT         NOT NULL,
    [MonitoringSessionID]                 BIGINT         NULL,
    [PersonEnteredByID]                   BIGINT         NULL,
    [MonitoringSessionActionTypeID]       BIGINT         NULL,
    [MonitoringSessionActionStatusTypeID] BIGINT         NULL,
    [ActionDate]                          DATETIME       NULL,
    [Comments]                            NVARCHAR (500) NULL,
    [RowStatus]                           INT            NOT NULL,
    [MaintenanceFlag]                     NVARCHAR (20)  NULL,
    [RecordAction]                        NCHAR (1)      NULL,
    PRIMARY KEY CLUSTERED ([MonitoringSessionActionID] ASC));

