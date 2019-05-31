CREATE TABLE [dbo].[tflObservationFiltered] (
    [idfObservationFiltered] BIGINT           NOT NULL,
    [idfObservation]         BIGINT           NOT NULL,
    [idfSiteGroup]           BIGINT           NOT NULL,
    [rowguid]                UNIQUEIDENTIFIER CONSTRAINT [newid__2568] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]     BIGINT           NULL,
    [SourceSystemKeyValue]   NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtflObservationFiltered] PRIMARY KEY CLUSTERED ([idfObservationFiltered] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_tflObservationFiltered_tflSiteGroup__idfSiteGroup] FOREIGN KEY ([idfSiteGroup]) REFERENCES [dbo].[tflSiteGroup] ([idfSiteGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflObservationFiltered_tlbObservation__idfObservation_R_1809] FOREIGN KEY ([idfObservation]) REFERENCES [dbo].[tlbObservation] ([idfObservation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflObservationFiltered_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [tflObservationFiltered_idfObservation_idfSiteGroup]
    ON [dbo].[tflObservationFiltered]([idfObservation] ASC, [idfSiteGroup] ASC);


GO

CREATE TRIGGER [dbo].[TR_tflObservationFiltered_A_Update] ON [dbo].[tflObservationFiltered]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfObservationFiltered))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
