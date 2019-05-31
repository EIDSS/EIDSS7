CREATE TYPE [dbo].[tlbVectorSampleGetListSPType] AS TABLE (
    [idfMaterial]                  BIGINT         NOT NULL,
    [strFieldBarcode]              NVARCHAR (200) NULL,
    [idfsSampleType]               BIGINT         NULL,
    [idfVectorSurveillanceSession] BIGINT         NULL,
    [idfVector]                    BIGINT         NULL,
    [idfSendToOffice]              BIGINT         NULL,
    [idfFieldCollectedByOffice]    BIGINT         NULL,
    [RecordAction]                 NCHAR (1)      NOT NULL,
    PRIMARY KEY CLUSTERED ([idfMaterial] ASC));

