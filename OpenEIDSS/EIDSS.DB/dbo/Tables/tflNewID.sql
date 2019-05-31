CREATE TABLE [dbo].[tflNewID] (
    [NewID]                BIGINT           IDENTITY (10000000, 10000000) NOT NULL,
    [strTableName]         [sysname]        NULL,
    [idfKey1]              BIGINT           NULL,
    [idfKey2]              BIGINT           NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [FK_tflNewID_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);

