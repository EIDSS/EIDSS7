CREATE TYPE [dbo].[UDT_HumanCasesForReport] AS TABLE (
    [idfHumanCase]          BIGINT         NULL,
    [intNotificationMonth]  INT            NULL,
    [intNotificationYear]   INT            NULL,
    [AgeYears]              INT            NULL,
    [AgeMonths]             INT            NULL,
    [idfsRegion]            BIGINT         NULL,
    [idfsDiagnosis]         BIGINT         NULL,
    [strICD10]              NVARCHAR (400) NULL,
    [idfsReportDiagnosisGp] BIGINT         NULL,
    [CurrentDiagICD10]      NVARCHAR (400) NULL);

