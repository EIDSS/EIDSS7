CREATE TABLE [dbo].[tlbVectorSurveillanceSessionSummary] (
    [idfsVSSessionSummary]         BIGINT           NOT NULL,
    [idfVectorSurveillanceSession] BIGINT           NOT NULL,
    [strVSSessionSummaryID]        NVARCHAR (200)   NOT NULL,
    [idfGeoLocation]               BIGINT           NOT NULL,
    [datCollectionDateTime]        DATETIME         NULL,
    [idfsVectorSubType]            BIGINT           NOT NULL,
    [idfsSex]                      BIGINT           NULL,
    [intQuantity]                  INT              NULL,
    [intRowStatus]                 INT              CONSTRAINT [DF_tlbVectorSurveillanceSessionSummary_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]                      UNIQUEIDENTIFIER CONSTRAINT [DF_tlbVectorSurveillanceSessionSummary_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]           NVARCHAR (20)    NULL,
    [strReservedAttribute]         NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]           BIGINT           NULL,
    [SourceSystemKeyValue]         NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_tlbVectorSurveillanceSessionSummary] PRIMARY KEY CLUSTERED ([idfsVSSessionSummary] ASC),
    CONSTRAINT [FK_tlbVectorSurveillanceSessionSummary_tlbGeoLocation__idfGeoLocation] FOREIGN KEY ([idfGeoLocation]) REFERENCES [dbo].[tlbGeoLocation] ([idfGeoLocation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVectorSurveillanceSessionSummary_tlbVectorSurveillanceSession__idfVectorSurveillanceSession] FOREIGN KEY ([idfVectorSurveillanceSession]) REFERENCES [dbo].[tlbVectorSurveillanceSession] ([idfVectorSurveillanceSession]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVectorSurveillanceSessionSummary_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbVectorSurveillanceSessionSummary_trtVectorSubType__idfsVectorSubType] FOREIGN KEY ([idfsVectorSubType]) REFERENCES [dbo].[trtVectorSubType] ([idfsVectorSubType]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tlbVectorSurveillanceSessionSummary_A_Update] ON [dbo].[tlbVectorSurveillanceSessionSummary]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsVSSessionSummary))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO



CREATE TRIGGER [dbo].[TR_tlbVectorSurveillanceSessionSummary_I_Delete] ON [dbo].[tlbVectorSurveillanceSessionSummary]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsVSSessionSummary]) as
		(
			SELECT [idfsVSSessionSummary] FROM deleted
			EXCEPT
			SELECT [idfsVSSessionSummary] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbVectorSurveillanceSessionSummary AS a 
		INNER JOIN cteOnlyDeletedRecords AS b 
			ON a.idfsVSSessionSummary = b.idfsVSSessionSummary;

	END

END
