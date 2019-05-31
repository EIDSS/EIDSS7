CREATE TABLE [dbo].[tlbVectorSurveillanceSessionSummaryDiagnosis] (
    [idfsVSSessionSummaryDiagnosis] BIGINT           NOT NULL,
    [idfsVSSessionSummary]          BIGINT           NOT NULL,
    [idfsDiagnosis]                 BIGINT           NOT NULL,
    [intPositiveQuantity]           INT              NULL,
    [intRowStatus]                  INT              CONSTRAINT [DF_tlbVectorSurveillanceSessionSummaryDiagnosis_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]                       UNIQUEIDENTIFIER CONSTRAINT [DF_tlbVectorSurveillanceSessionSummaryDiagnosis_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]            NVARCHAR (20)    NULL,
    [strReservedAttribute]          NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]            BIGINT           NULL,
    [SourceSystemKeyValue]          NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_tlbVectorSurveillanceSessionSummaryDiagnosis] PRIMARY KEY CLUSTERED ([idfsVSSessionSummaryDiagnosis] ASC),
    CONSTRAINT [FK_tlbVectorSurveillanceSessionSummaryDiagnosis_tlbVectorSurveillanceSessionSummary__idfsVSSessionSummary] FOREIGN KEY ([idfsVSSessionSummary]) REFERENCES [dbo].[tlbVectorSurveillanceSessionSummary] ([idfsVSSessionSummary]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVectorSurveillanceSessionSummaryDiagnosis_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbVectorSurveillanceSessionSummaryDiagnosis_trtDiagnosis__idfsDiagnosis] FOREIGN KEY ([idfsDiagnosis]) REFERENCES [dbo].[trtDiagnosis] ([idfsDiagnosis]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tlbVectorSurveillanceSessionSummaryDiagnosis_A_Update] 
ON [dbo].[tlbVectorSurveillanceSessionSummaryDiagnosis]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsVSSessionSummaryDiagnosis))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO



CREATE TRIGGER [dbo].[TR_tlbVectorSurveillanceSessionSummaryDiagnosis_I_Delete] ON [dbo].[tlbVectorSurveillanceSessionSummaryDiagnosis]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsVSSessionSummaryDiagnosis]) as
		(
			SELECT [idfsVSSessionSummaryDiagnosis] FROM deleted
			EXCEPT
			SELECT [idfsVSSessionSummaryDiagnosis] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbVectorSurveillanceSessionSummaryDiagnosis AS a 
		INNER JOIN cteOnlyDeletedRecords AS b 
			ON a.idfsVSSessionSummaryDiagnosis = b.idfsVSSessionSummaryDiagnosis;

	END

END
