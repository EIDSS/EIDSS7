CREATE TABLE [dbo].[tasglMapImage] (
    [idfMapImage]          BIGINT           NOT NULL,
    [blbMapImage]          IMAGE            NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [tasglMapImage__newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasglMapImage] PRIMARY KEY CLUSTERED ([idfMapImage] ASC),
    CONSTRAINT [FK_tasglMapImage_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasglMapImage_A_Update] ON [dbo].[tasglMapImage]
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
