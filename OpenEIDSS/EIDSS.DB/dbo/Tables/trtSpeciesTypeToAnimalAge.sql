CREATE TABLE [dbo].[trtSpeciesTypeToAnimalAge] (
    [idfSpeciesTypeToAnimalAge] BIGINT           NOT NULL,
    [idfsSpeciesType]           BIGINT           NOT NULL,
    [idfsAnimalAge]             BIGINT           NOT NULL,
    [intRowStatus]              INT              CONSTRAINT [Def_0_2018] DEFAULT ((0)) NOT NULL,
    [rowguid]                   UNIQUEIDENTIFIER CONSTRAINT [newid__2021] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]        NVARCHAR (20)    NULL,
    [strReservedAttribute]      NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]        BIGINT           NULL,
    [SourceSystemKeyValue]      NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_trtSpeciesTypeToAnimalAge] PRIMARY KEY CLUSTERED ([idfSpeciesTypeToAnimalAge] ASC),
    CONSTRAINT [FK_trtSpeciesTypeToAnimalAge_trtBaseReference__idfsAnimalAge_R_1599] FOREIGN KEY ([idfsAnimalAge]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_trtSpeciesTypeToAnimalAge_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_trtSpeciesTypeToAnimalAge_trtSpeciesType__idfsSpeciesType_R_1598] FOREIGN KEY ([idfsSpeciesType]) REFERENCES [dbo].[trtSpeciesType] ([idfsSpeciesType]) NOT FOR REPLICATION,
    CONSTRAINT [UQ_trtSpeciesTypeToAnimalAge] UNIQUE NONCLUSTERED ([idfsSpeciesType] ASC, [idfsAnimalAge] ASC)
);


GO

CREATE TRIGGER [dbo].[TR_trtSpeciesTypeToAnimalAge_A_Update] ON [dbo].[trtSpeciesTypeToAnimalAge]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfSpeciesTypeToAnimalAge))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_trtSpeciesTypeToAnimalAge_I_Delete] on [dbo].[trtSpeciesTypeToAnimalAge]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfSpeciesTypeToAnimalAge]) as
		(
			SELECT [idfSpeciesTypeToAnimalAge] FROM deleted
			EXCEPT
			SELECT [idfSpeciesTypeToAnimalAge] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.trtSpeciesTypeToAnimalAge as a 
		INNER JOIN cteOnlyDeletedRows as b 
			ON a.idfSpeciesTypeToAnimalAge = b.idfSpeciesTypeToAnimalAge;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Animal age types for animal species', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtSpeciesTypeToAnimalAge';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Specie type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtSpeciesTypeToAnimalAge', @level2type = N'COLUMN', @level2name = N'idfsSpeciesType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Animal age identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'trtSpeciesTypeToAnimalAge', @level2type = N'COLUMN', @level2name = N'idfsAnimalAge';

