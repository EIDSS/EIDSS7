CREATE TABLE [dbo].[gisLegendSymbol] (
    [idfLegendSymbol]      BIGINT           NOT NULL,
    [binLegendSymbol]      VARBINARY (MAX)  NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__gisLegendSymbol] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_gisLegendSymbol] PRIMARY KEY CLUSTERED ([idfLegendSymbol] ASC),
    CONSTRAINT [FK_gisLegendSymbol_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_gisLegendSymbol_A_Update] ON [dbo].[gisLegendSymbol]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfLegendSymbol))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
