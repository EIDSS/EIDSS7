CREATE TABLE [dbo].[tasViewBand] (
    [idfViewBand]          BIGINT           NOT NULL,
    [idfView]              BIGINT           NOT NULL,
    [idfsLanguage]         BIGINT           NOT NULL,
    [strOriginalName]      NVARCHAR (2000)  NOT NULL,
    [strDisplayName]       NVARCHAR (2000)  NULL,
    [blnVisible]           BIT              CONSTRAINT [Def_0_tasViewBand__blnVisible] DEFAULT ((0)) NOT NULL,
    [intOrder]             INT              NULL,
    [idfParentViewBand]    BIGINT           NULL,
    [blnFreeze]            BIT              CONSTRAINT [Def_0_tasViewBand__blnFreeze] DEFAULT ((0)) NOT NULL,
    [idfLayoutSearchField] BIGINT           NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [rowguid]              UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasViewBand] PRIMARY KEY CLUSTERED ([idfViewBand] ASC),
    CONSTRAINT [FK_tasViewBand_tasLayoutSearchField__idfLayoutSearchField] FOREIGN KEY ([idfLayoutSearchField]) REFERENCES [dbo].[tasLayoutSearchField] ([idfLayoutSearchField]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasViewBand_tasView__idfView_idfsLanguage] FOREIGN KEY ([idfView], [idfsLanguage]) REFERENCES [dbo].[tasView] ([idfView], [idfsLanguage]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasViewBand_tasViewBand__idfParentViewBand] FOREIGN KEY ([idfParentViewBand]) REFERENCES [dbo].[tasViewBand] ([idfViewBand]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasViewBand_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasViewBand_A_Update] ON [dbo].[tasViewBand]
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
