CREATE TABLE [dbo].[SiteToSiteAccess] (
    [SiteToSiteAccessUID]  BIGINT           NOT NULL,
    [GranteeSite]          BIGINT           NULL,
    [GrantToSite]          BIGINT           NULL,
    [AccessPermissionID]   BIGINT           NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_SiteToSiteAccess_intRowStatus] DEFAULT ((0)) NULL,
    [AuditCreateUser]      VARCHAR (100)    CONSTRAINT [DF__SiteToSit__Audit__21C31603] DEFAULT (user_name()) NOT NULL,
    [AuditCreateDTM]       DATETIME         CONSTRAINT [DF__SiteToSit__Audit__22B73A3C] DEFAULT (getdate()) NOT NULL,
    [AuditUpdateUser]      VARCHAR (100)    CONSTRAINT [DF__SiteToSit__Audit__23AB5E75] DEFAULT (user_name()) NOT NULL,
    [AuditUpdateDTM]       DATETIME         CONSTRAINT [DF__SiteToSit__Audit__249F82AE] DEFAULT (getdate()) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKSitetoSite] PRIMARY KEY CLUSTERED ([SiteToSiteAccessUID] ASC),
    CONSTRAINT [FK_SiteToSiteAccess_BaseReference_AaccessPermissionID] FOREIGN KEY ([AccessPermissionID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_SiteToSiteAccess_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_SiteToSiteAccess_tstSite_GranteeSite] FOREIGN KEY ([GranteeSite]) REFERENCES [dbo].[tstSite] ([idfsSite]),
    CONSTRAINT [FK_SiteToSiteAccess_tstSite_GrantToSite] FOREIGN KEY ([GrantToSite]) REFERENCES [dbo].[tstSite] ([idfsSite]),
    CONSTRAINT [XAK1SitetoSite] UNIQUE NONCLUSTERED ([GranteeSite] ASC, [GrantToSite] ASC, [AccessPermissionID] ASC)
);


GO

CREATE TRIGGER [dbo].[TR_SiteToSiteAccess_A_Update] ON [dbo].[SiteToSiteAccess]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(SiteToSiteAccessUID))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_SiteToSiteAccess_I_Delete] on [dbo].[SiteToSiteAccess]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([SiteToSiteAccessUID]) as
		(
			SELECT [SiteToSiteAccessUID] FROM deleted
			EXCEPT
			SELECT [SiteToSiteAccessUID] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1,
			AuditUpdateUser = SYSTEM_USER,
			AuditUpdateDTM = GETDATE()
		FROM dbo.[SiteToSiteAccess] as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.[SiteToSiteAccessUID] = b.[SiteToSiteAccessUID];

	END

END
