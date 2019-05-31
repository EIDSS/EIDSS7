CREATE TABLE [dbo].[updRunningApps] (
    [strClientID]          NVARCHAR (50)    NOT NULL,
    [strApplication]       NVARCHAR (50)    NOT NULL,
    [datDateLastUpdate]    DATETIME         NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_updRunningApps] PRIMARY KEY CLUSTERED ([strClientID] ASC, [strApplication] ASC),
    CONSTRAINT [FK_updRunningApps_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_updRunningApps_A_Update] ON [dbo].[updRunningApps]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND (UPDATE([strClientID]) OR UPDATE([strApplication])))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ns=Notification Service, eidss = EIDSS', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'updRunningApps', @level2type = N'COLUMN', @level2name = N'strApplication';

