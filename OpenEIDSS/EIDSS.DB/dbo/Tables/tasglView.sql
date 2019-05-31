CREATE TABLE [dbo].[tasglView] (
    [idfView]                   BIGINT           NOT NULL,
    [idfsLanguage]              BIGINT           NOT NULL,
    [idfsLayout]                BIGINT           NOT NULL,
    [idfChartXAxisViewColumn]   BIGINT           NULL,
    [idfMapAdminUnitViewColumn] BIGINT           NULL,
    [blbChartLocalSettings]     IMAGE            NULL,
    [blbGisLayerLocalSettings]  IMAGE            NULL,
    [blbGisMapLocalSettings]    IMAGE            NULL,
    [blbViewSettings]           IMAGE            NULL,
    [rowguid]                   UNIQUEIDENTIFIER CONSTRAINT [tasglView__newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]        NVARCHAR (20)    NULL,
    [strReservedAttribute]      NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]        BIGINT           NULL,
    [SourceSystemKeyValue]      NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasglView] PRIMARY KEY CLUSTERED ([idfView] ASC, [idfsLanguage] ASC),
    CONSTRAINT [FK_tasglView_tasglLayout__idfsLayout] FOREIGN KEY ([idfsLayout]) REFERENCES [dbo].[tasglLayout] ([idfsLayout]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglView_tasglViewColumn__idfChartXAxisViewColumn] FOREIGN KEY ([idfChartXAxisViewColumn]) REFERENCES [dbo].[tasglViewColumn] ([idfViewColumn]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglView_tasglViewColumn__idfMapAdminUnitViewColumn] FOREIGN KEY ([idfMapAdminUnitViewColumn]) REFERENCES [dbo].[tasglViewColumn] ([idfViewColumn]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglView_trtBaseReference__idfsLanguage] FOREIGN KEY ([idfsLanguage]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglView_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasglView_A_Update] ON [dbo].[tasglView]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfView) OR UPDATE(idfsLanguage)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
