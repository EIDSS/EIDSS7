CREATE TYPE [dbo].[tlbVectorFieldTestGetListSPType] AS TABLE (
    [idfTesting]        BIGINT       NOT NULL,
    [strFieldBarCode]   VARCHAR (50) NULL,
    [idfsTestName]      BIGINT       NULL,
    [idfsTestCategory]  BIGINT       NULL,
    [idfTestedByOffice] BIGINT       NULL,
    [idfsTestResult]    BIGINT       NULL,
    [idfTestedByPerson] BIGINT       NULL,
    [idfsDiagnosis]     BIGINT       NULL,
    [RecordAction]      NCHAR (1)    NOT NULL,
    PRIMARY KEY CLUSTERED ([idfTesting] ASC));

