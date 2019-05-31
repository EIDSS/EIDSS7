CREATE TABLE [dbo].[tasglLayoutSearchField] (
    [idfLayoutSearchField]       BIGINT           NOT NULL,
    [idfsLayoutSearchFieldName]  BIGINT           NULL,
    [idfsLayout]                 BIGINT           NOT NULL,
    [idfsAggregateFunction]      BIGINT           NULL,
    [idfQuerySearchField]        BIGINT           NOT NULL,
    [idfUnitLayoutSearchField]   BIGINT           NULL,
    [idfDateLayoutSearchField]   BIGINT           NULL,
    [rowguid]                    UNIQUEIDENTIFIER CONSTRAINT [newid__tasglLayoutSearchField] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfsGroupDate]              BIGINT           NULL,
    [blnShowMissedValue]         BIT              CONSTRAINT [Def_0_tasglLayoutSearchField__blnShowMissedValue] DEFAULT ((0)) NOT NULL,
    [datDiapasonStartDate]       DATE             NULL,
    [datDiapasonEndDate]         DATE             NULL,
    [intPrecision]               INT              NULL,
    [intFieldCollectionIndex]    INT              CONSTRAINT [Def_0_tasglLayoutSearchField__intFieldCollectionIndex] DEFAULT ((0)) NOT NULL,
    [intPivotGridAreaType]       INT              CONSTRAINT [Def_0_tasglLayoutSearchField__intPivotGridAreaType] DEFAULT ((0)) NOT NULL,
    [intFieldPivotGridAreaIndex] INT              CONSTRAINT [Def_0_tasglLayoutSearchField__intFieldPivotGridAreaIndex] DEFAULT ((0)) NOT NULL,
    [blnVisible]                 BIT              CONSTRAINT [Def_0_tasglLayoutSearchField__blnVisible] DEFAULT ((0)) NOT NULL,
    [blnHiddenFilterField]       BIT              CONSTRAINT [Def_0_tasglLayoutSearchField__blnHiddenFilterField] DEFAULT ((0)) NOT NULL,
    [intFieldColumnWidth]        INT              CONSTRAINT [Def_100_tasglLayoutSearchField__intFieldColumnWidth] DEFAULT ((100)) NOT NULL,
    [blnSortAcsending]           BIT              CONSTRAINT [Def_0_tasglLayoutSearchField__blnSortAcsending] DEFAULT ((0)) NOT NULL,
    [strFieldFilterValues]       NVARCHAR (MAX)   NULL,
    [strMaintenanceFlag]         NVARCHAR (20)    NULL,
    [strReservedAttribute]       NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]         BIGINT           NULL,
    [SourceSystemKeyValue]       NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasglLayoutSearchField] PRIMARY KEY CLUSTERED ([idfLayoutSearchField] ASC),
    CONSTRAINT [FK_tasglLayoutSearchField_tasAggregateFunction__idfsAggregateFunction] FOREIGN KEY ([idfsAggregateFunction]) REFERENCES [dbo].[tasAggregateFunction] ([idfsAggregateFunction]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayoutSearchField_tasglLayoutSearchField__idfDateLayoutSearchField] FOREIGN KEY ([idfDateLayoutSearchField]) REFERENCES [dbo].[tasglLayoutSearchField] ([idfLayoutSearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayoutSearchField_tasglLayoutSearchField__idfUnitLayoutSearchField] FOREIGN KEY ([idfUnitLayoutSearchField]) REFERENCES [dbo].[tasglLayoutSearchField] ([idfLayoutSearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayoutSearchField_tasglQuerySearchField__idfQuerySearchField] FOREIGN KEY ([idfQuerySearchField]) REFERENCES [dbo].[tasglQuerySearchField] ([idfQuerySearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayoutSearchField_tasLayout_idflLayout] FOREIGN KEY ([idfsLayout]) REFERENCES [dbo].[tasglLayout] ([idfsLayout]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayoutSearchField_trtBaseReference__idfsGroupDate] FOREIGN KEY ([idfsGroupDate]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayoutSearchField_trtBaseReference_idfsLayoutSearchFieldName] FOREIGN KEY ([idfsLayoutSearchFieldName]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayoutSearchField_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasglLayoutSearchField_A_Update] ON [dbo].[tasglLayoutSearchField]
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
