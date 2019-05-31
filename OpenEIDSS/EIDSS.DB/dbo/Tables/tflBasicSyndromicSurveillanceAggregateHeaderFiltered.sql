CREATE TABLE [dbo].[tflBasicSyndromicSurveillanceAggregateHeaderFiltered] (
    [idfBasicSyndromicSurveillanceAggregateHeaderFiltered] BIGINT           NOT NULL,
    [idfAggregateHeader]                                   BIGINT           NOT NULL,
    [idfSiteGroup]                                         BIGINT           NOT NULL,
    [rowguid]                                              UNIQUEIDENTIFIER CONSTRAINT [tflBasicSyndromicSurveillanceAggregateHeaderFiltered_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]                                   BIGINT           NULL,
    [SourceSystemKeyValue]                                 NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtflBasicSyndromicSurveillanceAggregateHeaderFiltered] PRIMARY KEY CLUSTERED ([idfBasicSyndromicSurveillanceAggregateHeaderFiltered] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tflBasicSyndromicSurveillanceAggregateHeaderFiltered_tflSiteGroup__idfSiteGroup] FOREIGN KEY ([idfSiteGroup]) REFERENCES [dbo].[tflSiteGroup] ([idfSiteGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflBasicSyndromicSurveillanceAggregateHeaderFiltered_tlbBasicSyndromicSurveillanceAggregateHeader__idfAggregateHeader] FOREIGN KEY ([idfAggregateHeader]) REFERENCES [dbo].[tlbBasicSyndromicSurveillanceAggregateHeader] ([idfAggregateHeader]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflBasicSyndromicSurveillanceAggregateHeaderFiltered_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [tflBasicSyndromicSurveillanceAggregateHeaderFiltered_idfAggregateHeader_idfSiteGroup]
    ON [dbo].[tflBasicSyndromicSurveillanceAggregateHeaderFiltered]([idfAggregateHeader] ASC, [idfSiteGroup] ASC);


GO

CREATE TRIGGER [dbo].[TR_tflBasicSyndromicSurveillanceAggregateHeaderFiltered_A_Update] ON [dbo].[tflBasicSyndromicSurveillanceAggregateHeaderFiltered]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfBasicSyndromicSurveillanceAggregateHeaderFiltered))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
