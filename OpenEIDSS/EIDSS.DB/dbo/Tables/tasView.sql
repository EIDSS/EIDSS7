CREATE TABLE [dbo].[tasView] (
    [idfView]                   BIGINT           NOT NULL,
    [idfsLanguage]              BIGINT           NOT NULL,
    [idflLayout]                BIGINT           NOT NULL,
    [idfChartXAxisViewColumn]   BIGINT           NULL,
    [idfMapAdminUnitViewColumn] BIGINT           NULL,
    [blbChartLocalSettings]     IMAGE            NULL,
    [blbGisLayerLocalSettings]  IMAGE            NULL,
    [blbGisMapLocalSettings]    IMAGE            NULL,
    [idfGlobalView]             BIGINT           NULL,
    [blbViewSettings]           IMAGE            NULL,
    [strReservedAttribute]      NVARCHAR (MAX)   NULL,
    [rowguid]                   UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]        BIGINT           NULL,
    [SourceSystemKeyValue]      NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasView] PRIMARY KEY CLUSTERED ([idfView] ASC, [idfsLanguage] ASC),
    CONSTRAINT [FK_tasView_tasglView__idfGlobalView_idfsLanguage] FOREIGN KEY ([idfGlobalView], [idfsLanguage]) REFERENCES [dbo].[tasglView] ([idfView], [idfsLanguage]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasView_tasLayout__idflLayout] FOREIGN KEY ([idflLayout]) REFERENCES [dbo].[tasLayout] ([idflLayout]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasView_tasViewColumn__idfChartXAxisViewColumn] FOREIGN KEY ([idfChartXAxisViewColumn]) REFERENCES [dbo].[tasViewColumn] ([idfViewColumn]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasView_tasViewColumn__idfMapAdminUnitViewColumn] FOREIGN KEY ([idfMapAdminUnitViewColumn]) REFERENCES [dbo].[tasViewColumn] ([idfViewColumn]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasView_trtBaseReference__idfsLanguage] FOREIGN KEY ([idfsLanguage]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasView_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasView_A_Update] ON [dbo].[tasView]
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
