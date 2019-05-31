CREATE TABLE [dbo].[tasLayoutSearchField] (
    [idfLayoutSearchField]       BIGINT           NOT NULL,
    [idflLayoutSearchFieldName]  BIGINT           NULL,
    [idflLayout]                 BIGINT           NOT NULL,
    [idfsAggregateFunction]      BIGINT           NULL,
    [idfQuerySearchField]        BIGINT           NOT NULL,
    [idfUnitLayoutSearchField]   BIGINT           NULL,
    [idfDateLayoutSearchField]   BIGINT           NULL,
    [idfsGroupDate]              BIGINT           NULL,
    [blnShowMissedValue]         BIT              CONSTRAINT [Def_0_tasLayoutSearchField__blnShowMissedValue] DEFAULT ((0)) NOT NULL,
    [datDiapasonStartDate]       DATE             NULL,
    [datDiapasonEndDate]         DATE             NULL,
    [intPrecision]               INT              NULL,
    [intFieldCollectionIndex]    INT              CONSTRAINT [Def_0_tasLayoutSearchField__intFieldCollectionIndex] DEFAULT ((0)) NOT NULL,
    [intPivotGridAreaType]       INT              CONSTRAINT [Def_0_tasLayoutSearchField__intPivotGridAreaType] DEFAULT ((0)) NOT NULL,
    [intFieldPivotGridAreaIndex] INT              CONSTRAINT [Def_0_tasLayoutSearchField__intFieldPivotGridAreaIndex] DEFAULT ((0)) NOT NULL,
    [blnVisible]                 BIT              CONSTRAINT [Def_0_tasLayoutSearchField__blnVisible] DEFAULT ((0)) NOT NULL,
    [blnHiddenFilterField]       BIT              CONSTRAINT [Def_0_tasLayoutSearchField__blnHiddenFilterField] DEFAULT ((0)) NOT NULL,
    [intFieldColumnWidth]        INT              CONSTRAINT [Def_100_tasLayoutSearchField__intFieldColumnWidth] DEFAULT ((100)) NOT NULL,
    [blnSortAcsending]           BIT              CONSTRAINT [Def_0_tasLayoutSearchField__blnSortAcsending] DEFAULT ((0)) NOT NULL,
    [strFieldFilterValues]       NVARCHAR (MAX)   NULL,
    [strReservedAttribute]       NVARCHAR (MAX)   NULL,
    [rowguid]                    UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]         BIGINT           NULL,
    [SourceSystemKeyValue]       NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasLayoutSearchField] PRIMARY KEY CLUSTERED ([idfLayoutSearchField] ASC),
    CONSTRAINT [FK_tasLayoutSearchField_locBaseReference_idflLayoutSearchFieldName] FOREIGN KEY ([idflLayoutSearchFieldName]) REFERENCES [dbo].[locBaseReference] ([idflBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayoutSearchField_tasAggregateFunction__idfsAggregateFunction] FOREIGN KEY ([idfsAggregateFunction]) REFERENCES [dbo].[tasAggregateFunction] ([idfsAggregateFunction]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayoutSearchField_tasLayout_idflLayout] FOREIGN KEY ([idflLayout]) REFERENCES [dbo].[tasLayout] ([idflLayout]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayoutSearchField_tasLayoutSearchField__idfDateLayoutSearchField] FOREIGN KEY ([idfDateLayoutSearchField]) REFERENCES [dbo].[tasLayoutSearchField] ([idfLayoutSearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayoutSearchField_tasLayoutSearchField__idfUnitLayoutSearchField] FOREIGN KEY ([idfUnitLayoutSearchField]) REFERENCES [dbo].[tasLayoutSearchField] ([idfLayoutSearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayoutSearchField_tasQuerySearchField__idfQuerySearchField] FOREIGN KEY ([idfQuerySearchField]) REFERENCES [dbo].[tasQuerySearchField] ([idfQuerySearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayoutSearchField_trtBaseReference__idfsGroupDate] FOREIGN KEY ([idfsGroupDate]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayoutSearchField_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasLayoutSearchField_A_Update] ON [dbo].[tasLayoutSearchField]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfLayoutSearchField))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
