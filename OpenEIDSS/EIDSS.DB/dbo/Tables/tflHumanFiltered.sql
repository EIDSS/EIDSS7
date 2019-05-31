CREATE TABLE [dbo].[tflHumanFiltered] (
    [idfHumanFiltered]     BIGINT           NOT NULL,
    [idfHuman]             BIGINT           NOT NULL,
    [idfSiteGroup]         BIGINT           NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [DF_tflHumanFiltered_rowguid] DEFAULT (newid()) ROWGUIDCOL NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_tflHumanFiltered] PRIMARY KEY CLUSTERED ([idfHumanFiltered] ASC),
    CONSTRAINT [FK_tflHumanFiltered_tflSiteGroup__idfSiteGroup] FOREIGN KEY ([idfSiteGroup]) REFERENCES [dbo].[tflSiteGroup] ([idfSiteGroup]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflHumanFiltered_tlbHuman] FOREIGN KEY ([idfHuman]) REFERENCES [dbo].[tlbHuman] ([idfHuman]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflHumanFiltered_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [tflHumanFiltered_idfHuman_idfSiteGroup]
    ON [dbo].[tflHumanFiltered]([idfHuman] ASC, [idfSiteGroup] ASC);


GO

CREATE TRIGGER [dbo].[TR_tflHumanFiltered_A_Update] ON [dbo].[tflHumanFiltered]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfHumanFiltered))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
