CREATE TABLE [dbo].[tflSite] (
    [idfsSite]             BIGINT           NOT NULL,
    [strSiteID]            NVARCHAR (36)    NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [tflSite_Def_0] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [tflSite_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtflSite] PRIMARY KEY CLUSTERED ([idfsSite] ASC),
    CONSTRAINT [FK_tflSite_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tflSite_tstSite__idfsSite] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO


CREATE TRIGGER [dbo].[TR_tflSite_I_Delete] on [dbo].[tflSite]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([idfsSite]) as
		(
			SELECT [idfsSite] FROM deleted
			EXCEPT
			SELECT [idfsSite] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.[tflSite] as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.[idfsSite] = b.[idfsSite];

	END

END

GO

CREATE TRIGGER [dbo].[TR_tflSite_A_Update] ON [dbo].[tflSite]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsSite))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
