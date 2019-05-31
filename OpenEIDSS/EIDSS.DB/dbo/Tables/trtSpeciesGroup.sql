CREATE TABLE [dbo].[trtSpeciesGroup] (
    [idfsSpeciesGroup]     BIGINT           NOT NULL,
    [strSpeciesGroupAlias] NVARCHAR (50)    NULL,
    [intRowStatus]         INT              CONSTRAINT [Def_0_trtSpeciesGroup] DEFAULT ((0)) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid_trtSpeciesGroup] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtrtSpeciesGroup] PRIMARY KEY CLUSTERED ([idfsSpeciesGroup] ASC),
    CONSTRAINT [FK_trtSpeciesGroup_trtBaseReference_idfsSpeciesGroup] FOREIGN KEY ([idfsSpeciesGroup]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtSpeciesGroup_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO


CREATE TRIGGER [dbo].[TR_trtSpeciesGroup_I_Delete] on [dbo].[trtSpeciesGroup]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRows([idfsSpeciesGroup]) as
		(
			SELECT [idfsSpeciesGroup] FROM deleted
			EXCEPT
			SELECT [idfsSpeciesGroup] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtSpeciesGroup as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.idfsSpeciesGroup = b.idfsSpeciesGroup;


		WITH cteOnlyDeletedRows([idfsSpeciesGroup]) as
		(
			SELECT [idfsSpeciesGroup] FROM deleted
			EXCEPT
			SELECT [idfsSpeciesGroup] FROM inserted
		)

		DELETE a
		FROM dbo.trtBaseReference as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.idfsBaseReference = b.idfsSpeciesGroup;

	END

END

GO

CREATE TRIGGER [dbo].[TR_trtSpeciesGroup_A_Update] ON [dbo].[trtSpeciesGroup]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfsSpeciesGroup))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
