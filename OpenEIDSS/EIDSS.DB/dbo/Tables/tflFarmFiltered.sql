CREATE TABLE [dbo].[tflFarmFiltered] (
    [idfFarmFiltered]      BIGINT           NOT NULL,
    [idfFarm]              BIGINT           NOT NULL,
    [idfSiteGroup]         BIGINT           NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [DF_tflFarmFiltered_rowguid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_tflFarmFiltered] PRIMARY KEY CLUSTERED ([idfFarmFiltered] ASC),
    CONSTRAINT [FK_tflFarmFiltered_tlbFarm] FOREIGN KEY ([idfFarm]) REFERENCES [dbo].[tlbFarm] ([idfFarm]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tflFarmFiltered_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tflFarmFilteredGroup_tflSiteGroup__idfSiteGroup] FOREIGN KEY ([idfSiteGroup]) REFERENCES [dbo].[tflSiteGroup] ([idfSiteGroup]) NOT FOR REPLICATION
);


GO
CREATE NONCLUSTERED INDEX [tflFarmFiltered_idfFarm_idfSiteGroup]
    ON [dbo].[tflFarmFiltered]([idfFarm] ASC, [idfSiteGroup] ASC);


GO

CREATE TRIGGER [dbo].[TR_tflFarmFiltered_A_Update] ON [dbo].[tflFarmFiltered]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfFarmFiltered))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
