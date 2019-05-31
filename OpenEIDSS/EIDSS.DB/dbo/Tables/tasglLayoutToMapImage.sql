CREATE TABLE [dbo].[tasglLayoutToMapImage] (
    [idfLayoutToMapImage]  BIGINT           NOT NULL,
    [idfsLayout]           BIGINT           NOT NULL,
    [idfMapImage]          BIGINT           NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [tasglLayoutToMapImage__newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasglLayoutToMapImage] PRIMARY KEY CLUSTERED ([idfLayoutToMapImage] ASC),
    CONSTRAINT [FK_tasglLayoutToMapImage_tasglLayout__idfsLayout] FOREIGN KEY ([idfsLayout]) REFERENCES [dbo].[tasglLayout] ([idfsLayout]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayoutToMapImage_tasglMapImage__idfMapImage] FOREIGN KEY ([idfMapImage]) REFERENCES [dbo].[tasglMapImage] ([idfMapImage]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayoutToMapImage_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [UQ_tasglLayoutToMapImage] UNIQUE NONCLUSTERED ([idfsLayout] ASC, [idfMapImage] ASC)
);


GO

CREATE TRIGGER [dbo].[TR_tasglLayoutToMapImage_A_Update] ON [dbo].[tasglLayoutToMapImage]
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
