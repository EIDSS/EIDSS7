CREATE TABLE [dbo].[tflBasicSyndromicSurveillanceFiltered] (
    [idfBasicSyndromicSurveillanceFiltered] BIGINT           NOT NULL,
    [idfBasicSyndromicSurveillance]         BIGINT           NOT NULL,
    [idfSiteGroup]                          BIGINT           NOT NULL,
    [rowguid]                               UNIQUEIDENTIFIER CONSTRAINT [newid_BasicSyndromicSurveillance_2560] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]                    BIGINT           NULL,
    [SourceSystemKeyValue]                  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtflBasicSyndromicSurveillanceFiltered] PRIMARY KEY CLUSTERED ([idfBasicSyndromicSurveillanceFiltered] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tflBasicSyndromicSurveillanceFiltered_tflSiteGroup__idfSiteGroup] FOREIGN KEY ([idfSiteGroup]) REFERENCES [dbo].[tflSiteGroup] ([idfSiteGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflBasicSyndromicSurveillanceFiltered_tlbBasicSyndromicSurveillance__idfBasicSyndromicSurveillance_R_1831] FOREIGN KEY ([idfBasicSyndromicSurveillance]) REFERENCES [dbo].[tlbBasicSyndromicSurveillance] ([idfBasicSyndromicSurveillance]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflBasicSyndromicSurveillanceFiltered_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [tflBasicSyndromicSurveillanceFiltered_idfBasicSyndromicSurveillance_idfSiteGroup]
    ON [dbo].[tflBasicSyndromicSurveillanceFiltered]([idfBasicSyndromicSurveillance] ASC, [idfSiteGroup] ASC);


GO

CREATE TRIGGER [dbo].[TR_tflBasicSyndromicSurveillanceFiltered_A_Update] ON [dbo].[tflBasicSyndromicSurveillanceFiltered]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfBasicSyndromicSurveillanceFiltered))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
