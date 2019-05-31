CREATE TABLE [dbo].[tflSiteGroup] (
    [idfSiteGroup]         BIGINT           NOT NULL,
    [idfsRayon]            BIGINT           NULL,
    [strSiteGroupName]     NVARCHAR (36)    NOT NULL,
    [idfsCentralSite]      BIGINT           NULL,
    [intRowStatus]         INT              DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [tflSiteGroup_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    PRIMARY KEY CLUSTERED ([idfSiteGroup] ASC),
    CONSTRAINT [FK_tflSiteGroup_gisRayon_idfsRayon] FOREIGN KEY ([idfsRayon]) REFERENCES [dbo].[gisRayon] ([idfsRayon]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflSiteGroup_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tflSiteGroup_tstSite_idfsSite] FOREIGN KEY ([idfsCentralSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tflSiteGroup_A_Update] ON [dbo].[tflSiteGroup]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfSiteGroup))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tflSiteGroup_I_Delete] on [dbo].[tflSiteGroup]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([idfSiteGroup]) as
		(
			SELECT [idfSiteGroup] FROM deleted
			EXCEPT
			SELECT [idfSiteGroup] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.[tflSiteGroup] as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.[idfSiteGroup] = b.[idfSiteGroup];

	END

END
