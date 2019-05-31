CREATE TYPE [dbo].[PensideTestTableType] AS TABLE (
    [PensideTestID]             BIGINT        NOT NULL,
    [SampleID]                  BIGINT        NOT NULL,
    [PensideTestResultTypeID]   BIGINT        NULL,
    [PensideTestNameTypeID]     BIGINT        NULL,
    [RowStatus]                 INT           NOT NULL,
    [TestedByPersonID]          BIGINT        NULL,
    [TestedByOrganizationID]    BIGINT        NULL,
    [DiseaseID]                 BIGINT        NULL,
    [TestDate]                  DATETIME      NULL,
    [PensideTestCategoryTypeID] BIGINT        NULL,
    [MaintenanceFlag]           NVARCHAR (20) NULL,
    [RecordAction]              NCHAR (1)     NULL,
    PRIMARY KEY CLUSTERED ([PensideTestID] ASC));

