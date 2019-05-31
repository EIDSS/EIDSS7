CREATE TABLE [dbo].[tasLayout] (
    [idflLayout]                     BIGINT           NOT NULL,
    [idfsGlobalLayout]               BIGINT           NULL,
    [idflQuery]                      BIGINT           NOT NULL,
    [idflLayoutFolder]               BIGINT           NULL,
    [idflDescription]                BIGINT           CONSTRAINT [Def_0_tasLayout__idflDescription] DEFAULT ((0)) NOT NULL,
    [blnReadOnly]                    BIT              CONSTRAINT [Def_0___2704] DEFAULT ((0)) NOT NULL,
    [idfsDefaultGroupDate]           BIGINT           NOT NULL,
    [blnShowColsTotals]              BIT              CONSTRAINT [Def_0_2611] DEFAULT ((0)) NULL,
    [blnShowRowsTotals]              BIT              CONSTRAINT [Def_0_2612] DEFAULT ((0)) NULL,
    [blnShowColGrandTotals]          BIT              CONSTRAINT [Def_0_2613] DEFAULT ((0)) NULL,
    [blnShowRowGrandTotals]          BIT              CONSTRAINT [Def_0_2614] DEFAULT ((0)) NULL,
    [blnShowForSingleTotals]         BIT              CONSTRAINT [Def_0_2615] DEFAULT ((0)) NULL,
    [blnApplyPivotGridFilter]        BIT              CONSTRAINT [Def_0_2616] DEFAULT ((0)) NOT NULL,
    [blnShareLayout]                 BIT              CONSTRAINT [Def_0_2617] DEFAULT ((0)) NOT NULL,
    [blbPivotGridSettings]           IMAGE            NULL,
    [blbChartGeneralSettings]        IMAGE            NULL,
    [intPivotGridXmlVersion]         INT              CONSTRAINT [Def_0_tasLayout__intPivotGridXmlVersion] DEFAULT ((6)) NOT NULL,
    [blnCompactPivotGrid]            BIT              CONSTRAINT [Def_0_tasLayout__blnCompactPivotGrid] DEFAULT ((0)) NOT NULL,
    [blnFreezeRowHeaders]            BIT              CONSTRAINT [Def_0_tasLayout__blnFreezeRowHeaders] DEFAULT ((0)) NOT NULL,
    [blnUseArchivedData]             BIT              CONSTRAINT [Def_0_tasLayout__blnUseArchivedData] DEFAULT ((0)) NOT NULL,
    [blnShowMissedValuesInPivotGrid] BIT              CONSTRAINT [Def_0_tasLayout__blnShowMissedValuesInPivotGrid] DEFAULT ((0)) NOT NULL,
    [blbGisLayerGeneralSettings]     IMAGE            NULL,
    [blbGisMapGeneralSettings]       IMAGE            NULL,
    [intGisLayerPosition]            INT              NULL,
    [strReservedAttribute]           NVARCHAR (MAX)   NULL,
    [idfPerson]                      BIGINT           NULL,
    [blnShowDataInPivotGrid]         BIT              CONSTRAINT [DF_tasLayout_blnShowDataInPivotGrid] DEFAULT ((0)) NULL,
    [rowguid]                        UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]             BIGINT           NULL,
    [SourceSystemKeyValue]           NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasLayout] PRIMARY KEY CLUSTERED ([idflLayout] ASC),
    CONSTRAINT [FK_tasLayout_locBaseReference__idflDescription_R_1717] FOREIGN KEY ([idflDescription]) REFERENCES [dbo].[locBaseReference] ([idflBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayout_locBaseReference__idflLayout_R_1708] FOREIGN KEY ([idflLayout]) REFERENCES [dbo].[locBaseReference] ([idflBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayout_tasglLayout__idfsGlobalLayout_R_1794] FOREIGN KEY ([idfsGlobalLayout]) REFERENCES [dbo].[tasglLayout] ([idfsLayout]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayout_tasLayoutFolder__idflLayoutFolder_R_1698] FOREIGN KEY ([idflLayoutFolder]) REFERENCES [dbo].[tasLayoutFolder] ([idflLayoutFolder]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayout_tasQuery__idflQuery_R_1326] FOREIGN KEY ([idflQuery]) REFERENCES [dbo].[tasQuery] ([idflQuery]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayout_tlbPerson__idfPerson] FOREIGN KEY ([idfPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayout_trtBaseReference__idfsDefaultGroupDate] FOREIGN KEY ([idfsDefaultGroupDate]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasLayout_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasLayout_A_Update] ON [dbo].[tasLayout]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idflLayout))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
