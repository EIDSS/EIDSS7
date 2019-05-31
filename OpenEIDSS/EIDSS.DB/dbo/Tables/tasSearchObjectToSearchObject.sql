CREATE TABLE [dbo].[tasSearchObjectToSearchObject] (
    [idfsRelatedSearchObject]  BIGINT           NOT NULL,
    [idfsParentSearchObject]   BIGINT           NOT NULL,
    [rowguid]                  UNIQUEIDENTIFIER CONSTRAINT [newid__2494] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strSubQueryJoinCondition] NVARCHAR (2000)  NOT NULL,
    [blnUseForSubQuery]        BIT              CONSTRAINT [DF_tasSearchObjectToSearchObject_blnUseForSubQuery] DEFAULT ((0)) NOT NULL,
    [strReservedAttribute]     NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]       BIGINT           NULL,
    [SourceSystemKeyValue]     NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasSearchObjectToSearchObject] PRIMARY KEY CLUSTERED ([idfsRelatedSearchObject] ASC, [idfsParentSearchObject] ASC),
    CONSTRAINT [FK_tasSearchObjectToSearchObject_tasSearchObject__idfsParentSearchObject_R_1714] FOREIGN KEY ([idfsParentSearchObject]) REFERENCES [dbo].[tasSearchObject] ([idfsSearchObject]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchObjectToSearchObject_tasSearchObject__idfsRelatedSearchObject_R_1713] FOREIGN KEY ([idfsRelatedSearchObject]) REFERENCES [dbo].[tasSearchObject] ([idfsSearchObject]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchObjectToSearchObject_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasSearchObjectToSearchObject_A_Update] ON [dbo].[tasSearchObjectToSearchObject]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfsRelatedSearchObject) OR UPDATE(idfsParentSearchObject)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
