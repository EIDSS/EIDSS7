CREATE TABLE [dbo].[tasSearchObject] (
    [idfsSearchObject]     BIGINT           NOT NULL,
    [idfsFormType]         BIGINT           NULL,
    [blnPrimary]           BIT              CONSTRAINT [Def_0___2711] DEFAULT ((0)) NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2483] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]         INT              DEFAULT ((0)) NOT NULL,
    [blnShowReportType]    BIT              CONSTRAINT [Def_0_tasSearchObject__blnShowReportType] DEFAULT ((0)) NOT NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasSearchObject] PRIMARY KEY CLUSTERED ([idfsSearchObject] ASC),
    CONSTRAINT [FK_tasSearchObject_trtBaseReference__idfsFormType_R_1657] FOREIGN KEY ([idfsFormType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchObject_trtBaseReference__idfsSearchObject_R_1357] FOREIGN KEY ([idfsSearchObject]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchObject_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasSearchObject_A_Update] ON [dbo].[tasSearchObject]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsSearchObject))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tasSearchObject_I_Delete] on [dbo].[tasSearchObject]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsSearchObject]) as
		(
			SELECT [idfsSearchObject] FROM deleted
			EXCEPT
			SELECT [idfsSearchObject] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tasSearchObject as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsSearchObject = b.idfsSearchObject;


		WITH cteOnlyDeletedRecords([idfsSearchObject]) as
		(
			SELECT [idfsSearchObject] FROM deleted
			EXCEPT
			SELECT [idfsSearchObject] FROM inserted
		)
		
		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsSearchObject;

	END

END
