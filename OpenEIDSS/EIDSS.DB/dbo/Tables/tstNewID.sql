CREATE TABLE [dbo].[tstNewID] (
    [NewID]                BIGINT           IDENTITY (51500000000000, 10000000) NOT NULL,
    [idfTable]             BIGINT           NULL,
    [idfKey1]              BIGINT           NULL,
    [idfKey2]              BIGINT           NULL,
    [strRowGuid]           NVARCHAR (36)    NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [FK_tstNewID_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);

