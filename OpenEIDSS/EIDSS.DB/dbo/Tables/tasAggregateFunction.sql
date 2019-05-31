CREATE TABLE [dbo].[tasAggregateFunction] (
    [idfsAggregateFunction] BIGINT           NOT NULL,
    [blnPivotGridFunction]  BIT              CONSTRAINT [Def_0_tasAggregateFunction__blnPivotGridFunction] DEFAULT ((0)) NOT NULL,
    [blnViewFunction]       BIT              CONSTRAINT [Def_0_tasAggregateFunction__blnViewFunction] DEFAULT ((0)) NOT NULL,
    [intDefaultPrecision]   INT              CONSTRAINT [Def_0_tasAggregateFunction__intDefaultPrecision] DEFAULT ((0)) NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [tasAggregateFunction__newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strReservedAttribute]  NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]    BIGINT           NULL,
    [SourceSystemKeyValue]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasAggregateFunction] PRIMARY KEY CLUSTERED ([idfsAggregateFunction] ASC),
    CONSTRAINT [FK_tasAggregateFunction_trtBaseReference__idfsAggregateFunction] FOREIGN KEY ([idfsAggregateFunction]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasAggregateFunction_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasAggregateFunction_A_Update] ON [dbo].[tasAggregateFunction]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsAggregateFunction))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
