CREATE TABLE [dbo].[tasglViewColumn] (
    [idfViewColumn]            BIGINT           NOT NULL,
    [idfView]                  BIGINT           NOT NULL,
    [idfsLanguage]             BIGINT           NOT NULL,
    [idfViewBand]              BIGINT           NULL,
    [idfLayoutSearchField]     BIGINT           NULL,
    [strOriginalName]          NVARCHAR (2000)  NOT NULL,
    [strDisplayName]           NVARCHAR (2000)  NULL,
    [blnAggregateColumn]       BIT              CONSTRAINT [Def_0_tasglViewColumn__blnAggregateColumn] DEFAULT ((0)) NOT NULL,
    [idfsAggregateFunction]    BIGINT           NULL,
    [intPrecision]             INT              NULL,
    [blnChartSeries]           BIT              CONSTRAINT [Def_0_tasglViewColumn__blnChartSeries] DEFAULT ((0)) NOT NULL,
    [blnMapDiagramSeries]      BIT              CONSTRAINT [Def_0_tasglViewColumn__blnMapDiagramSeries] DEFAULT ((0)) NOT NULL,
    [blnMapGradientSeries]     BIT              CONSTRAINT [Def_0_tasglViewColumn__blnMapGradientSeries] DEFAULT ((0)) NOT NULL,
    [idfSourceViewColumn]      BIGINT           NULL,
    [idfDenominatorViewColumn] BIGINT           NULL,
    [blnVisible]               BIT              CONSTRAINT [Def_0_tasglViewColumn__blnVisible] DEFAULT ((0)) NOT NULL,
    [intSortOrder]             INT              NULL,
    [blnSortAscending]         BIT              CONSTRAINT [Def_0_tasglViewColumn__blnSortAcsending] DEFAULT ((0)) NOT NULL,
    [intOrder]                 INT              NULL,
    [strColumnFilter]          NVARCHAR (MAX)   NULL,
    [intColumnWidth]           INT              NULL,
    [rowguid]                  UNIQUEIDENTIFIER CONSTRAINT [tasglViewColumn__newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [blnFreeze]                BIT              CONSTRAINT [Def_0_tasglViewColumn__blnFreeze] DEFAULT ((0)) NOT NULL,
    [blbChartLocalSeries]      IMAGE            NULL,
    [strMaintenanceFlag]       NVARCHAR (20)    NULL,
    [strReservedAttribute]     NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]       BIGINT           NULL,
    [SourceSystemKeyValue]     NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasglViewColumn] PRIMARY KEY CLUSTERED ([idfViewColumn] ASC),
    CONSTRAINT [FK_tasglViewColumn_tasAggregateFunction__idfsAggregateFunction] FOREIGN KEY ([idfsAggregateFunction]) REFERENCES [dbo].[tasAggregateFunction] ([idfsAggregateFunction]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglViewColumn_tasglLayoutSearchField__idfLayoutSearchField] FOREIGN KEY ([idfLayoutSearchField]) REFERENCES [dbo].[tasglLayoutSearchField] ([idfLayoutSearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglViewColumn_tasglView__idfView_idfsLanguage] FOREIGN KEY ([idfView], [idfsLanguage]) REFERENCES [dbo].[tasglView] ([idfView], [idfsLanguage]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglViewColumn_tasglViewBand__idfViewBand] FOREIGN KEY ([idfViewBand]) REFERENCES [dbo].[tasglViewBand] ([idfViewBand]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglViewColumn_tasglViewColumn__idfDenominatorViewColumn] FOREIGN KEY ([idfDenominatorViewColumn]) REFERENCES [dbo].[tasglViewColumn] ([idfViewColumn]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglViewColumn_tasglViewColumn__idfSourceViewColumn] FOREIGN KEY ([idfSourceViewColumn]) REFERENCES [dbo].[tasglViewColumn] ([idfViewColumn]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglViewColumn_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasglViewColumn_A_Update] ON [dbo].[tasglViewColumn]
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
