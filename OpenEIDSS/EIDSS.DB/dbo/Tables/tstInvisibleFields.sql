CREATE TABLE [dbo].[tstInvisibleFields] (
    [idfInvisibleField]    BIGINT           NOT NULL,
    [strFieldAlias]        NVARCHAR (100)   NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstInvisibleFields] PRIMARY KEY CLUSTERED ([idfInvisibleField] ASC),
    CONSTRAINT [FK_tstInvisibleFields_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tstInvisibleFields_A_Update] ON [dbo].[tstInvisibleFields]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfInvisibleField]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
