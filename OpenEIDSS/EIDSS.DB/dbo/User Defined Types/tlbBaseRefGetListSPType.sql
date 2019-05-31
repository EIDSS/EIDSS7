CREATE TYPE [dbo].[tlbBaseRefGetListSPType] AS TABLE (
    [RecordID]           BIGINT          NOT NULL,
    [idfsBaseReference]  BIGINT          NULL,
    [idfsReferenceType]  BIGINT          NOT NULL,
    [DefaultName]        NVARCHAR (2000) NULL,
    [NationalName]       NVARCHAR (2000) NULL,
    [HACode]             INT             NULL,
    [Order]              INT             NULL,
    [System]             BIT             NULL,
    [strMaINTenanceFlag] NVARCHAR (20)   NULL,
    [RecordAction]       NCHAR (1)       NOT NULL,
    PRIMARY KEY CLUSTERED ([RecordID] ASC));

