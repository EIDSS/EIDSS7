CREATE TABLE [dbo].[tasSearchField] (
    [idfsSearchField]               BIGINT           NOT NULL,
    [idfsSearchFieldType]           BIGINT           NULL,
    [idfsSearchObject]              BIGINT           NOT NULL,
    [idfsReferenceType]             BIGINT           NULL,
    [idfsGISReferenceType]          BIGINT           NULL,
    [strSearchFieldAlias]           VARCHAR (50)     NOT NULL,
    [strLookupTable]                NVARCHAR (200)   NULL,
    [intMapDisplayOrder]            INT              NULL,
    [intIncidenceDisplayOrder]      INT              NULL,
    [blnGeoLocationString]          BIT              CONSTRAINT [DF_0_blnGeoLocationString] DEFAULT ((0)) NULL,
    [strCalculatedFieldText]        NVARCHAR (4000)  NULL,
    [rowguid]                       UNIQUEIDENTIFIER CONSTRAINT [newid__2079] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]                  INT              CONSTRAINT [DF__tasSearch__intRo__4E3F9032] DEFAULT ((0)) NOT NULL,
    [idfsDefaultAggregateFunction]  BIGINT           NOT NULL,
    [blnShortAddressString]         BIT              CONSTRAINT [Def_0_blnShortAddressString] DEFAULT ((0)) NOT NULL,
    [strLookupFunction]             VARCHAR (200)    NULL,
    [strLookupFunctionIdField]      VARCHAR (200)    NULL,
    [strLookupFunctionNameField]    VARCHAR (200)    NULL,
    [strLookupAttribute]            NVARCHAR (200)   NULL,
    [blnAllowMissedReferenceValues] BIT              CONSTRAINT [Def_0_blnAllowMissedReferenceValues] DEFAULT ((0)) NOT NULL,
    [strReservedAttribute]          NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]            BIGINT           NULL,
    [SourceSystemKeyValue]          NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasSearchFieldList] PRIMARY KEY CLUSTERED ([idfsSearchField] ASC),
    CONSTRAINT [FK_tasSearchField_gisReferenceType__idfsGISReferenceType_R_1720] FOREIGN KEY ([idfsGISReferenceType]) REFERENCES [dbo].[gisReferenceType] ([idfsGISReferenceType]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchField_tasAggregateFunction__idfsDefaultAggregateFunction] FOREIGN KEY ([idfsDefaultAggregateFunction]) REFERENCES [dbo].[tasAggregateFunction] ([idfsAggregateFunction]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchField_tasSearchObject__idfsSearchObject_R_1346] FOREIGN KEY ([idfsSearchObject]) REFERENCES [dbo].[tasSearchObject] ([idfsSearchObject]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchField_trtBaseReference__idfsSearchField_R_1355] FOREIGN KEY ([idfsSearchField]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchField_trtBaseReference__idfsSearchFieldType_R_1587] FOREIGN KEY ([idfsSearchFieldType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasSearchField_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tasSearchFieldList_trtReferenceType__idfsReferenceType_R_1349] FOREIGN KEY ([idfsReferenceType]) REFERENCES [dbo].[trtReferenceType] ([idfsReferenceType]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tasSearchField_A_Update] ON [dbo].[tasSearchField]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsSearchField))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tasSearchField_I_Delete] on [dbo].[tasSearchField]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsSearchField]) as
		(
			SELECT [idfsSearchField] FROM deleted
			EXCEPT
			SELECT [idfsSearchField] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tasSearchField as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsSearchField = b.idfsSearchField;


		WITH cteOnlyDeletedRecords([idfsSearchField]) as
		(
			SELECT [idfsSearchField] FROM deleted
			EXCEPT
			SELECT [idfsSearchField] FROM inserted
		)
		
		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsBaseReference = b.idfsSearchField;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Search Fields', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tasSearchField';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Field identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tasSearchField', @level2type = N'COLUMN', @level2name = N'idfsSearchField';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Field type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tasSearchField', @level2type = N'COLUMN', @level2name = N'idfsSearchFieldType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Reference type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tasSearchField', @level2type = N'COLUMN', @level2name = N'idfsReferenceType';

