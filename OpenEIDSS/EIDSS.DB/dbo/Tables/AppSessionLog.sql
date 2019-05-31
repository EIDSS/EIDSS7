CREATE TABLE [dbo].[AppSessionLog] (
    [AppSessionLogUID]     BIGINT           NOT NULL,
    [AppSessionID]         VARCHAR (100)    NULL,
    [AppModuleGroupID]     BIGINT           NULL,
    [ModuleConstantID]     BIGINT           NULL,
    [SessionBeginDTM]      DATETIME         NULL,
    [SessionEndDTM]        DATETIME         NULL,
    [SessionStatus]        VARCHAR (20)     NULL,
    [SessionDetailDataXML] XML              NULL,
    [idfAppUserID]         BIGINT           NULL,
    [idfSiteID]            BIGINT           NULL,
    [AuditCreateDTM]       DATETIME         NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKSessionLog] PRIMARY KEY CLUSTERED ([AppSessionLogUID] ASC),
    CONSTRAINT [FK_AppSessionLog_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_SesionLog_BaseRef_AppModuleGroupID] FOREIGN KEY ([AppModuleGroupID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_SessionLog_BaseRef_ModuleConstantID] FOREIGN KEY ([ModuleConstantID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_AppSessionLog_A_Update] ON [dbo].[AppSessionLog]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE(AppSessionLogUID))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
