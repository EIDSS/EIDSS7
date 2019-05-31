CREATE TABLE [dbo].[trtGISObjectForCustomReport] (
    [idfGISObjectForCustomReport] BIGINT           NOT NULL,
    [idfsCustomReportType]        BIGINT           NOT NULL,
    [idfsGISBaseReference]        BIGINT           NOT NULL,
    [strGISObjectAlias]           NVARCHAR (200)   NOT NULL,
    [intRowStatus]                INT              NOT NULL,
    [rowguid]                     UNIQUEIDENTIFIER CONSTRAINT [trtGISObjectForCustomReport__newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]          NVARCHAR (20)    NULL,
    [strReservedAttribute]        NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]          BIGINT           NULL,
    [SourceSystemKeyValue]        NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtGISObjectForCustomReport] PRIMARY KEY CLUSTERED ([idfGISObjectForCustomReport] ASC),
    CONSTRAINT [FK_trtGISObjectForCustomReport_gisBaseReference__idfsGISBaseReference] FOREIGN KEY ([idfsGISBaseReference]) REFERENCES [dbo].[gisBaseReference] ([idfsGISBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtGISObjectForCustomReport_trtBaseReference__idfsCustomReportType] FOREIGN KEY ([idfsCustomReportType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtGISObjectForCustomReport_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtGISObjectForCustomReport_A_Update] ON [dbo].[trtGISObjectForCustomReport]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfGISObjectForCustomReport]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
