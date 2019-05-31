CREATE TABLE [dbo].[tasViewColumn] (
    [idfViewColumn]            BIGINT           NOT NULL,
    [idfView]                  BIGINT           NOT NULL,
    [idfsLanguage]             BIGINT           NOT NULL,
    [idfViewBand]              BIGINT           NULL,
    [idfLayoutSearchField]     BIGINT           NULL,
    [strOriginalName]          NVARCHAR (2000)  NOT NULL,
    [strDisplayName]           NVARCHAR (2000)  NULL,
    [blnAggregateColumn]       BIT              CONSTRAINT [Def_0___blnAggregateColumn] DEFAULT ((0)) NOT NULL,
    [idfsAggregateFunction]    BIGINT           NULL,
    [intPrecision]             INT              NULL,
    [blnChartSeries]           BIT              CONSTRAINT [Def_0_tasViewColumn__blnChartSeries] DEFAULT ((0)) NOT NULL,
    [blnMapDiagramSeries]      BIT              CONSTRAINT [Def_0_tasViewColumn__blnMapDiagramSeries] DEFAULT ((0)) NOT NULL,
    [blnMapGradientSeries]     BIT              CONSTRAINT [Def_0_tasViewColumn__blnMapGradientSeries] DEFAULT ((0)) NOT NULL,
    [idfSourceViewColumn]      BIGINT           NULL,
    [idfDenominatorViewColumn] BIGINT           NULL,
    [blnVisible]               BIT              CONSTRAINT [Def_0_tasViewColumn__blnVisible] DEFAULT ((0)) NOT NULL,
    [intSortOrder]             INT              NULL,
    [blnSortAscending]         BIT              CONSTRAINT [Def_0_tasViewColumn__blnSortAcsending] DEFAULT ((0)) NOT NULL,
    [intOrder]                 INT              NULL,
    [strColumnFilter]          NVARCHAR (MAX)   NULL,
    [intColumnWidth]           INT              NULL,
    [blnFreeze]                BIT              CONSTRAINT [Def_0_tasViewColumn__blnFreeze] DEFAULT ((0)) NOT NULL,
    [blbChartLocalSeries]      IMAGE            NULL,
    [strReservedAttribute]     NVARCHAR (MAX)   NULL,
    [rowguid]                  UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]       BIGINT           NULL,
    [SourceSystemKeyValue]     NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasViewColumn] PRIMARY KEY CLUSTERED ([idfViewColumn] ASC),
    CONSTRAINT [FK_tasViewColumn_tasAggregateFunction__idfsAggregateFunction] FOREIGN KEY ([idfsAggregateFunction]) REFERENCES [dbo].[tasAggregateFunction] ([idfsAggregateFunction]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasViewColumn_tasLayoutSearchField__idfLayoutSearchField] FOREIGN KEY ([idfLayoutSearchField]) REFERENCES [dbo].[tasLayoutSearchField] ([idfLayoutSearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasViewColumn_tasView__idfView_idfsLanguage] FOREIGN KEY ([idfView], [idfsLanguage]) REFERENCES [dbo].[tasView] ([idfView], [idfsLanguage]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasViewColumn_tasViewBand__idfViewBand] FOREIGN KEY ([idfViewBand]) REFERENCES [dbo].[tasViewBand] ([idfViewBand]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasViewColumn_tasViewColumn__idfDenominatorViewColumn] FOREIGN KEY ([idfDenominatorViewColumn]) REFERENCES [dbo].[tasViewColumn] ([idfViewColumn]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasViewColumn_tasViewColumn__idfSourceViewColumn] FOREIGN KEY ([idfSourceViewColumn]) REFERENCES [dbo].[tasViewColumn] ([idfViewColumn]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasViewColumn_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasViewColumn_A_Update] ON [dbo].[tasViewColumn]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfViewColumn))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
