CREATE TABLE [dbo].[tasLayoutToMapImage] (
    [idfLayoutToMapImage]  BIGINT           NOT NULL,
    [idflLayout]           BIGINT           NOT NULL,
    [idfMapImage]          BIGINT           NOT NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasLayoutToMapImage] PRIMARY KEY CLUSTERED ([idfLayoutToMapImage] ASC),
    CONSTRAINT [FK_tasLayoutToMapImage_tasLayout__idflLayout] FOREIGN KEY ([idflLayout]) REFERENCES [dbo].[tasLayout] ([idflLayout]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayoutToMapImage_tasMapImage__idfMapImage] FOREIGN KEY ([idfMapImage]) REFERENCES [dbo].[tasMapImage] ([idfMapImage]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayoutToMapImage_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [UQ_tasLayoutToMapImage] UNIQUE NONCLUSTERED ([idflLayout] ASC, [idfMapImage] ASC)
);


GO

CREATE TRIGGER [dbo].[TR_tasLayoutToMapImage_A_Update] ON [dbo].[tasLayoutToMapImage]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfLayoutToMapImage))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
