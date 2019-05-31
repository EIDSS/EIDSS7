CREATE TABLE [dbo].[tstLocalSiteOptions] (
    [strName]              NVARCHAR (200)   NOT NULL,
    [strValue]             NVARCHAR (200)   NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstLocalSiteOptions] PRIMARY KEY CLUSTERED ([strName] ASC),
    CONSTRAINT [FK_tstLocalSiteOptions_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [IX_tstLocalSiteOptions_strName]
    ON [dbo].[tstLocalSiteOptions]([strName] ASC);


GO

CREATE TRIGGER [dbo].[TR_tstLocalSiteOptions_A_Update] ON [dbo].[tstLocalSiteOptions]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([strName]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
