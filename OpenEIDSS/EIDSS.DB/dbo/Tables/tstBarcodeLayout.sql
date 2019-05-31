CREATE TABLE [dbo].[tstBarcodeLayout] (
    [idfsNumberName]       BIGINT           NOT NULL,
    [strBarcodeLayout]     NVARCHAR (MAX)   NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstBarcodeLayout] PRIMARY KEY CLUSTERED ([idfsNumberName] ASC),
    CONSTRAINT [FK_tstBarcodeLayout_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstBarcodeLayout_tstNextNumbers__idfsNumberName_R_1677] FOREIGN KEY ([idfsNumberName]) REFERENCES [dbo].[tstNextNumbers] ([idfsNumberName]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tstBarcodeLayout_A_Update] ON [dbo].[tstBarcodeLayout]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfsNumberName]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
