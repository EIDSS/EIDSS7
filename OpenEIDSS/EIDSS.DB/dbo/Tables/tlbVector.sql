CREATE TABLE [dbo].[tlbVector] (
    [idfVector]                    BIGINT           NOT NULL,
    [idfVectorSurveillanceSession] BIGINT           NOT NULL,
    [idfHostVector]                BIGINT           NULL,
    [strVectorID]                  NVARCHAR (50)    NOT NULL,
    [strFieldVectorID]             NVARCHAR (50)    NULL,
    [idfLocation]                  BIGINT           NULL,
    [intElevation]                 INT              NULL,
    [idfsSurrounding]              BIGINT           NULL,
    [strGEOReferenceSources]       NVARCHAR (500)   NULL,
    [idfCollectedByOffice]         BIGINT           NOT NULL,
    [idfCollectedByPerson]         BIGINT           NULL,
    [datCollectionDateTime]        DATETIME         NOT NULL,
    [idfsCollectionMethod]         BIGINT           NULL,
    [idfsBasisOfRecord]            BIGINT           NULL,
    [idfsVectorType]               BIGINT           NOT NULL,
    [idfsVectorSubType]            BIGINT           NOT NULL,
    [intQuantity]                  INT              CONSTRAINT [DF_tlbVector_intQuantity] DEFAULT ((1)) NOT NULL,
    [idfsSex]                      BIGINT           NULL,
    [idfIdentifiedByOffice]        BIGINT           NULL,
    [idfIdentifiedByPerson]        BIGINT           NULL,
    [datIdentifiedDateTime]        DATETIME         NULL,
    [idfsIdentificationMethod]     BIGINT           NULL,
    [idfObservation]               BIGINT           NULL,
    [intRowStatus]                 INT              CONSTRAINT [DF_tlbVector_intRowStatus] DEFAULT ((0)) NOT NULL,
    [rowguid]                      UNIQUEIDENTIFIER CONSTRAINT [DF_tlbVector_rowquid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [idfsDayPeriod]                BIGINT           NULL,
    [strComment]                   NVARCHAR (500)   NULL,
    [idfsEctoparasitesCollected]   BIGINT           NULL,
    [strMaintenanceFlag]           NVARCHAR (20)    NULL,
    [strReservedAttribute]         NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]           BIGINT           NULL,
    [SourceSystemKeyValue]         NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_tlbVector] PRIMARY KEY CLUSTERED ([idfVector] ASC),
    CONSTRAINT [FK_tlbVector_tlbGeoLocation_idfLocation] FOREIGN KEY ([idfLocation]) REFERENCES [dbo].[tlbGeoLocation] ([idfGeoLocation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVector_tlbObservation_idfObservation] FOREIGN KEY ([idfObservation]) REFERENCES [dbo].[tlbObservation] ([idfObservation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVector_tlbOffice_idfCollectedByOffice] FOREIGN KEY ([idfCollectedByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVector_tlbOffice_idfIdentifiedByOffice] FOREIGN KEY ([idfIdentifiedByOffice]) REFERENCES [dbo].[tlbOffice] ([idfOffice]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVector_tlbPerson_idfCollectedByPerson] FOREIGN KEY ([idfCollectedByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVector_tlbPerson_idfIdentifiedByPerson] FOREIGN KEY ([idfIdentifiedByPerson]) REFERENCES [dbo].[tlbPerson] ([idfPerson]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVector_tlbVector_idfHostVector] FOREIGN KEY ([idfHostVector]) REFERENCES [dbo].[tlbVector] ([idfVector]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVector_tlbVectorSurveillanceSession_idfVectorSurveillanceSession] FOREIGN KEY ([idfVectorSurveillanceSession]) REFERENCES [dbo].[tlbVectorSurveillanceSession] ([idfVectorSurveillanceSession]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVector_trtBaseReference__idfsEctoparasitesCollected] FOREIGN KEY ([idfsEctoparasitesCollected]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVector_trtBaseReference_idfsBasisOfREcord] FOREIGN KEY ([idfsBasisOfRecord]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVector_trtBaseReference_idfsCollectionMethod] FOREIGN KEY ([idfsCollectionMethod]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVector_trtBaseReference_idfsDayPeriod] FOREIGN KEY ([idfsDayPeriod]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVector_trtBaseReference_idfsIdentificationMethod] FOREIGN KEY ([idfsIdentificationMethod]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVector_trtBaseReference_idfsSex] FOREIGN KEY ([idfsSex]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVector_trtBaseReference_idfsSurrounding] FOREIGN KEY ([idfsSurrounding]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVector_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbVector_trtVectorSubType_idfsVectorSubType] FOREIGN KEY ([idfsVectorSubType]) REFERENCES [dbo].[trtVectorSubType] ([idfsVectorSubType]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbVector_trtVectorType_idfsVectorType] FOREIGN KEY ([idfsVectorType]) REFERENCES [dbo].[trtVectorType] ([idfsVectorType]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tlbVector_A_Update] ON [dbo].[tlbVector]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfVector))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbVector_I_Delete] on [dbo].[tlbVector]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfVector]) as
		(
			SELECT [idfVector] FROM deleted
			EXCEPT
			SELECT [idfVector] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbVector as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfVector = b.idfVector;

	END

END
