CREATE TYPE [dbo].[tlbMonitoringSessionActionGetListSPType] AS TABLE (
    [idfMonitoringSessionAction]        BIGINT         NOT NULL,
    [idfMonitoringSession]              BIGINT         NULL,
    [idfPersonEnteredBy]                BIGINT         NULL,
    [PersonName]                        NVARCHAR (200) NULL,
    [idfsMonitoringSessionActionType]   BIGINT         NULL,
    [MonitoringSessionActionTypeName]   NVARCHAR (200) NULL,
    [idfsMonitoringSessionActionStatus] BIGINT         NULL,
    [MonitoringSessionActionStatusName] NVARCHAR (200) NULL,
    [datActionDate]                     DATETIME       NULL,
    [strComments]                       NVARCHAR (500) NULL,
    [intRowStatus]                      INT            NOT NULL,
    [strMaintenanceFlag]                NVARCHAR (20)  NULL,
    [RecordAction]                      NCHAR (1)      NULL,
    PRIMARY KEY CLUSTERED ([idfMonitoringSessionAction] ASC));

