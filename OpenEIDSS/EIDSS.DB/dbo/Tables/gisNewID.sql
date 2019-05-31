CREATE TABLE [dbo].[gisNewID] (
    [gisNewID]             BIGINT           IDENTITY (3723970000000, 10000000) NOT NULL,
    [strA]                 NVARCHAR (10)    NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKgisNewID] PRIMARY KEY CLUSTERED ([gisNewID] ASC),
    CONSTRAINT [FK_gisNewID_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_gisNewID_A_Update] ON [dbo].[gisNewID]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(gisNewID))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
