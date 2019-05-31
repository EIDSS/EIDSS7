CREATE TYPE [dbo].[tlbVetCaseLogGetListSPType] AS TABLE (
    [idfVetCaseLog]         BIGINT          NOT NULL,
    [idfsCaseLogStatus]     BIGINT          NULL,
    [CaseLogStatusTypeName] NVARCHAR (200)  NULL,
    [idfVetCase]            BIGINT          NULL,
    [idfPerson]             BIGINT          NULL,
    [PersonName]            NVARCHAR (200)  NULL,
    [datCaseLogDate]        DATETIME        NULL,
    [strActionRequired]     NVARCHAR (200)  NULL,
    [strNote]               NVARCHAR (1000) NULL,
    [intRowStatus]          INT             NOT NULL,
    [strMaintenanceFlag]    NVARCHAR (20)   NULL,
    [RecordAction]          NCHAR (1)       NULL,
    PRIMARY KEY CLUSTERED ([idfVetCaseLog] ASC));

