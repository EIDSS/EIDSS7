CREATE TABLE [dbo].[tasglViewBand] (
    [idfViewBand]          BIGINT           NOT NULL,
    [idfView]              BIGINT           NOT NULL,
    [idfsLanguage]         BIGINT           NOT NULL,
    [strOriginalName]      NVARCHAR (2000)  NOT NULL,
    [strDisplayName]       NVARCHAR (2000)  NULL,
    [blnVisible]           BIT              CONSTRAINT [Def_0_tasglViewBand__blnVisible] DEFAULT ((0)) NOT NULL,
    [intOrder]             INT              NULL,
    [idfParentViewBand]    BIGINT           NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [tasglViewBand__newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [blnFreeze]            BIT              CONSTRAINT [Def_0_tasglViewBand__blnFreeze] DEFAULT ((0)) NOT NULL,
    [idfLayoutSearchField] BIGINT           NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasglViewBand] PRIMARY KEY CLUSTERED ([idfViewBand] ASC),
    CONSTRAINT [FK_tasglViewBand_tasglLayoutSearchField__idfLayoutSearchField] FOREIGN KEY ([idfLayoutSearchField]) REFERENCES [dbo].[tasglLayoutSearchField] ([idfLayoutSearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglViewBand_tasglView__idfView_idfsLanguage] FOREIGN KEY ([idfView], [idfsLanguage]) REFERENCES [dbo].[tasglView] ([idfView], [idfsLanguage]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglViewBand_tasglViewBand__idfParentViewBand] FOREIGN KEY ([idfParentViewBand]) REFERENCES [dbo].[tasglViewBand] ([idfViewBand]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglViewBand_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasglViewBand_A_Update] ON [dbo].[tasglViewBand]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfViewBand))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
