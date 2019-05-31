CREATE TABLE [dbo].[tstMandatoryFields] (
    [idfMandatoryField]    BIGINT           NOT NULL,
    [strFieldAlias]        NVARCHAR (100)   NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid_tstMandatoryFields] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstMandatoryFields] PRIMARY KEY CLUSTERED ([idfMandatoryField] ASC),
    CONSTRAINT [FK_tstMandatoryFields_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tstMandatoryFields_A_Update] ON [dbo].[tstMandatoryFields]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfMandatoryField]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
