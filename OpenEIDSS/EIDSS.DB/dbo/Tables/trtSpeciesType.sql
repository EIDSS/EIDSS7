CREATE TABLE [dbo].[trtSpeciesType] (
    [idfsSpeciesType]      BIGINT           NOT NULL,
    [strCode]              NVARCHAR (200)   NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_2043] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2045] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtSpeciesType] PRIMARY KEY CLUSTERED ([idfsSpeciesType] ASC),
    CONSTRAINT [FK_trtSpeciesType_trtBaseReference__idfsSpeciesType_R_1650] FOREIGN KEY ([idfsSpeciesType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtSpeciesType_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_trtSpeciesType_A_Update] ON [dbo].[trtSpeciesType]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsSpeciesType))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_trtSpeciesType_I_Delete] on [dbo].[trtSpeciesType]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsSpeciesType]) as
		(
			SELECT [idfsSpeciesType] FROM deleted
			EXCEPT
			SELECT [idfsSpeciesType] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtSpeciesType as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsSpeciesType = b.idfsSpeciesType;


		WITH cteOnlyDeletedRecords([idfsSpeciesType]) as
		(
			SELECT [idfsSpeciesType] FROM deleted
			EXCEPT
			SELECT [idfsSpeciesType] FROM inserted
		)

		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.idfsBaseReference = b.idfsSpeciesType;

	END

END
