CREATE TYPE [dbo].[tlbVectorDiagnosisGetListSPType] AS TABLE (
    [idfsVSSessionSummaryDiagnosis] BIGINT    NOT NULL,
    [idfsVSSessionSummary]          BIGINT    NULL,
    [idfsDiagnosis]                 BIGINT    NULL,
    [intPositiveQuantity]           BIGINT    NULL,
    [RecordAction]                  NCHAR (1) NOT NULL,
    PRIMARY KEY CLUSTERED ([idfsVSSessionSummaryDiagnosis] ASC));

