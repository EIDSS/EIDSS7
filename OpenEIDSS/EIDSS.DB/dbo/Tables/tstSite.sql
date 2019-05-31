CREATE TABLE [dbo].[tstSite] (
    [idfsSite]                BIGINT           NOT NULL,
    [idfsSiteType]            BIGINT           NULL,
    [idfCustomizationPackage] BIGINT           NOT NULL,
    [idfOffice]               BIGINT           NULL,
    [strSiteName]             NVARCHAR (200)   NULL,
    [strServerName]           NVARCHAR (200)   NULL,
    [strHASCsiteID]           NVARCHAR (50)    NULL,
    [strSiteID]               NVARCHAR (36)    NOT NULL,
    [intRowStatus]            INT              CONSTRAINT [Def_0_2053] DEFAULT ((0)) NOT NULL,
    [rowguid]                 UNIQUEIDENTIFIER CONSTRAINT [newid__2055] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intFlags]                INT              NULL,
    [blnIsWEB]                BIT              DEFAULT ((0)) NOT NULL,
    [idfsParentSite]          BIGINT           NULL,
    [strMaintenanceFlag]      NVARCHAR (20)    NULL,
    [SourceSystemNameID]      BIGINT           NULL,
    [SourceSystemKeyValue]    NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstSite] PRIMARY KEY CLUSTERED ([idfsSite] ASC),
    CONSTRAINT [FK_tstSite_tlbOffice__idfOffice_R_386] FOREIGN KEY ([idfOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstSite_trtBaseReference__idfsSiteType_R_1305] FOREIGN KEY ([idfsSiteType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstSite_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstSite_tstCustomizationPackage__idfCustomizationPackage] FOREIGN KEY ([idfCustomizationPackage]) REFERENCES [dbo].[tstCustomizationPackage] ([idfCustomizationPackage]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstSite_tstSite__idfsParentSite] FOREIGN KEY ([idfsParentSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO
CREATE NONCLUSTERED INDEX [IX_tstSite_strSiteID]
    ON [dbo].[tstSite]([strSiteID] ASC)
    INCLUDE([idfsSite]);


GO

CREATE  TRIGGER [dbo].[trtstSite_DeleteFromTfl] on [dbo].[tstSite]	
INSTEAD OF DELETE
NOT FOR REPLICATION
AS

IF ((TRIGGER_NESTLEVEL()<2) AND (dbo.fnTriggersWork ()=1))
BEGIN
	DELETE ts
	FROM tflSite ts
	JOIN DELETED AS del ON
		del.idfsSite = ts.idfsSite
		
	DELETE FROM ts
	FROM tstSite ts
	JOIN DELETED AS del ON
		del.idfsSite = ts.idfsSite
END
GO

CREATE TRIGGER [dbo].[TR_tstSite_A_Update] ON [dbo].[tstSite]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfsSite]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END

GO

CREATE  TRIGGER [dbo].[trtstSite_CopyToTfl] on [dbo].[tstSite]	
FOR INSERT, UPDATE
NOT FOR REPLICATION
AS

IF ((TRIGGER_NESTLEVEL()<2) AND (dbo.fnTriggersWork ()=1))
BEGIN
	IF (SELECT COUNT(*) FROM INSERTED) > 0 AND (SELECT COUNT(*) FROM DELETED) = 0
		INSERT INTO tflSite (idfsSite, strSiteID, intRowStatus)
		SELECT 
			idfsSite, strSiteID, intRowStatus
		FROM INSERTED
	ELSE	
		IF (SELECT COUNT(*) FROM INSERTED) > 0 AND (SELECT COUNT(*) FROM DELETED) > 0
			UPDATE ts
			SET ts.strSiteID = ins.strSiteID,
				ts.intRowStatus = ins.intRowStatus
			FROM tflSite ts
			JOIN INSERTED AS ins ON
				ins.idfsSite = ts.idfsSite
END




SET ANSI_NULLS ON

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Sites', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstSite';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Site identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstSite', @level2type = N'COLUMN', @level2name = N'idfsSite';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Site type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstSite', @level2type = N'COLUMN', @level2name = N'idfsSiteType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Country identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstSite', @level2type = N'COLUMN', @level2name = N'idfCustomizationPackage';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Office identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstSite', @level2type = N'COLUMN', @level2name = N'idfOffice';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Site name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstSite', @level2type = N'COLUMN', @level2name = N'strSiteName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Server name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstSite', @level2type = N'COLUMN', @level2name = N'strServerName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Site HASC code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tstSite', @level2type = N'COLUMN', @level2name = N'strHASCsiteID';

