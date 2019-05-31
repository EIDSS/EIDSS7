CREATE TABLE [dbo].[tlbBasicSyndromicSurveillanceAggregateDetail] (
    [idfAggregateDetail]   BIGINT           NOT NULL,
    [idfAggregateHeader]   BIGINT           NOT NULL,
    [idfHospital]          BIGINT           NOT NULL,
    [intAge0_4]            INT              NULL,
    [intAge5_14]           INT              NULL,
    [intAge15_29]          INT              NULL,
    [intAge30_64]          INT              NULL,
    [intAge65]             INT              NULL,
    [inTotalILI]           INT              NULL,
    [intTotalAdmissions]   INT              NULL,
    [intILISamples]        INT              NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_tlbBasicSyndromicSurveillanceAggregateDetail_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [Def_tlbBasicSyndromicSurveillanceAggregateDetail_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbBasicSyndromicSurveillanceAggregateDetail] PRIMARY KEY CLUSTERED ([idfAggregateDetail] ASC),
    CONSTRAINT [FK_tlbBasicSyndromicSurveillanceAggregateDetail_tlbBasicSyndromicSurveillanceAggregateHeader__idfAggregateHeader] FOREIGN KEY ([idfAggregateHeader]) REFERENCES [dbo].[tlbBasicSyndromicSurveillanceAggregateHeader] ([idfAggregateHeader]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillanceAggregateDetail_tlbOffice__idfHospital] FOREIGN KEY ([idfHospital]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbBasicSyndromicSurveillanceAggregateDetail_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [UK_tlbBasicSyndromicSurveillanceAggregateDetail] UNIQUE NONCLUSTERED ([idfAggregateHeader] ASC, [idfHospital] ASC)
);


GO

CREATE TRIGGER [dbo].[TR_tlbBasicSyndromicSurveillanceAggregateDetail_A_Update] ON [dbo].[tlbBasicSyndromicSurveillanceAggregateDetail]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfAggregateDetail))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbBasicSyndromicSurveillanceAggregateDetail_I_Delete] on [dbo].[tlbBasicSyndromicSurveillanceAggregateDetail]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfAggregateDetail]) as
		(
			SELECT [idfAggregateDetail] FROM deleted
			EXCEPT
			SELECT [idfAggregateDetail] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbBasicSyndromicSurveillanceAggregateDetail as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfAggregateDetail = b.idfAggregateDetail;

	END

END
