CREATE TABLE [dbo].[tasMapImage] (
    [idfMapImage]          BIGINT           NOT NULL,
    [blbMapImage]          IMAGE            NOT NULL,
    [idfGlobalMapImage]    BIGINT           NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasMapImage] PRIMARY KEY CLUSTERED ([idfMapImage] ASC),
    CONSTRAINT [FK_tasMapImage_tasglMapImage__idfGlobalMapImage] FOREIGN KEY ([idfGlobalMapImage]) REFERENCES [dbo].[tasglMapImage] ([idfMapImage]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasMapImage_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasMapImage_A_Update] ON [dbo].[tasMapImage]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfMapImage))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
