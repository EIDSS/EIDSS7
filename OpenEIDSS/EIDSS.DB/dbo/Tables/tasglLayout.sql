CREATE TABLE [dbo].[tasglLayout] (
    [idfsLayout]                     BIGINT           NOT NULL,
    [idfsQuery]                      BIGINT           NOT NULL,
    [idfsLayoutFolder]               BIGINT           NULL,
    [idfsDescription]                BIGINT           CONSTRAINT [Def_0_tasglLayout__idfsDescription] DEFAULT ((0)) NOT NULL,
    [blnReadOnly]                    BIT              CONSTRAINT [Def_0___2697] DEFAULT ((0)) NOT NULL,
    [idfsDefaultGroupDate]           BIGINT           NOT NULL,
    [blnShowColsTotals]              BIT              CONSTRAINT [Def_0_2611_12] DEFAULT ((0)) NULL,
    [blnShowRowsTotals]              BIT              CONSTRAINT [Def_0_2612_12] DEFAULT ((0)) NULL,
    [blnShowColGrandTotals]          BIT              CONSTRAINT [Def_0_2613_12] DEFAULT ((0)) NULL,
    [blnShowRowGrandTotals]          BIT              CONSTRAINT [Def_0_2614_12] DEFAULT ((0)) NULL,
    [blnShowForSingleTotals]         BIT              CONSTRAINT [Def_0_2615_12] DEFAULT ((0)) NULL,
    [blnApplyPivotGridFilter]        BIT              CONSTRAINT [Def_0_2616_12] DEFAULT ((0)) NOT NULL,
    [blnShareLayout]                 BIT              CONSTRAINT [Def_0_2617_12] DEFAULT ((0)) NOT NULL,
    [blbPivotGridSettings]           IMAGE            NULL,
    [rowguid]                        UNIQUEIDENTIFIER CONSTRAINT [newid__2533] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [blbChartGeneralSettings]        IMAGE            NULL,
    [intPivotGridXmlVersion]         INT              CONSTRAINT [Def_0_tasglLayout__intPivotGridXmlVersion] DEFAULT ((6)) NOT NULL,
    [blnCompactPivotGrid]            BIT              CONSTRAINT [Def_0_tasglLayout__blnCompactPivotGrid] DEFAULT ((0)) NOT NULL,
    [blnFreezeRowHeaders]            BIT              CONSTRAINT [Def_0_tasglLayout__blnFreezeRowHeaders] DEFAULT ((0)) NOT NULL,
    [blnUseArchivedData]             BIT              CONSTRAINT [Def_0_tasglLayout__blnUseArchivedData] DEFAULT ((0)) NOT NULL,
    [blnShowMissedValuesInPivotGrid] BIT              CONSTRAINT [Def_0_tasglLayout__blnShowMissedValuesInPivotGrid] DEFAULT ((0)) NOT NULL,
    [blbGisLayerGeneralSettings]     IMAGE            NULL,
    [blbGisMapGeneralSettings]       IMAGE            NULL,
    [intGisLayerPosition]            INT              NULL,
    [strMaintenanceFlag]             NVARCHAR (20)    NULL,
    [strReservedAttribute]           NVARCHAR (MAX)   NULL,
    [idfPerson]                      BIGINT           NULL,
    [SourceSystemNameID]             BIGINT           NULL,
    [SourceSystemKeyValue]           NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtasglLayout] PRIMARY KEY CLUSTERED ([idfsLayout] ASC),
    CONSTRAINT [FK_tasglLayout_tasglLayoutFolder__idfsLayoutFolder_R_1698_1] FOREIGN KEY ([idfsLayoutFolder]) REFERENCES [dbo].[tasglLayoutFolder] ([idfsLayoutFolder]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayout_tasglQuery__idfsQuery_R_1326_1] FOREIGN KEY ([idfsQuery]) REFERENCES [dbo].[tasglQuery] ([idfsQuery]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayout_tlbPerson__idfPerson] FOREIGN KEY ([idfPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayout_trtBaseReference__idfsDefaultGroupDate] FOREIGN KEY ([idfsDefaultGroupDate]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayout_trtBaseReference__idfsDescription_R_1717_1] FOREIGN KEY ([idfsDescription]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayout_trtBaseReference__idfsLayout_R_1708_1] FOREIGN KEY ([idfsLayout]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tasglLayout_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tasglLayout_A_Update] ON [dbo].[tasglLayout]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsLayout))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
