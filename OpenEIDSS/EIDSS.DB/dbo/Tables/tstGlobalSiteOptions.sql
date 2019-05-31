CREATE TABLE [dbo].[tstGlobalSiteOptions] (
    [strName]              NVARCHAR (200)   NOT NULL,
    [strValue]             NVARCHAR (200)   NULL,
    [idfsSite]             BIGINT           NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2516] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [tstGlobalSiteOptions_intRowStatus] DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstGlobalSiteOptions] PRIMARY KEY CLUSTERED ([strName] ASC),
    CONSTRAINT [FK_tstGlobalSiteOptions_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstGlobalSiteOptions_tstSite__idfsSite_R_1753] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tstGlobalSiteOptions_A_Update] ON [dbo].[tstGlobalSiteOptions]
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
