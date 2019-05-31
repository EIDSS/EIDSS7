CREATE TABLE [dbo].[tlbAnimal] (
    [idfAnimal]            BIGINT           NOT NULL,
    [idfsAnimalGender]     BIGINT           NULL,
    [idfsAnimalCondition]  BIGINT           NULL,
    [idfsAnimalAge]        BIGINT           NULL,
    [idfSpecies]           BIGINT           NULL,
    [idfObservation]       BIGINT           NULL,
    [strDescription]       NVARCHAR (200)   NULL,
    [strAnimalCode]        NVARCHAR (200)   NULL,
    [strName]              NVARCHAR (200)   NULL,
    [strColor]             NVARCHAR (200)   NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [newid__2082] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [intRowStatus]         INT              CONSTRAINT [tlbAnimal_intRowStatus] DEFAULT ((0)) NOT NULL,
    [strMaintenanceFlag]   NVARCHAR (20)    NULL,
    [strReservedAttribute] NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]   BIGINT           NULL,
    [SourceSystemKeyValue] NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbAnimal] PRIMARY KEY CLUSTERED ([idfAnimal] ASC),
    CONSTRAINT [FK_tlbAnimal_tlbObservation__idfObservation_R_1481] FOREIGN KEY ([idfObservation]) REFERENCES [dbo].[tlbObservation] ([idfObservation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAnimal_tlbSpecies__idfSpecies_R_1478] FOREIGN KEY ([idfSpecies]) REFERENCES [dbo].[tlbSpecies] ([idfSpecies]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAnimal_trtBaseReference__idfsAnimalAge_R_1236] FOREIGN KEY ([idfsAnimalAge]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAnimal_trtBaseReference__idfsAnimalCondition_R_1280] FOREIGN KEY ([idfsAnimalCondition]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAnimal_trtBaseReference__idfsAnimalGender_R_1237] FOREIGN KEY ([idfsAnimalGender]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbAnimal_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [IX_tlbAnimal_AS]
    ON [dbo].[tlbAnimal]([idfAnimal] ASC, [idfSpecies] ASC)
    INCLUDE([strAnimalCode]);


GO

CREATE TRIGGER [dbo].[TR_tlbAnimal_A_Update] ON [dbo].[tlbAnimal]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfAnimal))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbAnimal_I_Delete] on [dbo].[tlbAnimal]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfAnimal]) as
		(
			SELECT [idfAnimal] FROM deleted
			EXCEPT
			SELECT [idfAnimal] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbAnimal as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfAnimal = b.idfAnimal;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Animals', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbAnimal';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Animal identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbAnimal', @level2type = N'COLUMN', @level2name = N'idfAnimal';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Animal gender identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbAnimal', @level2type = N'COLUMN', @level2name = N'idfsAnimalGender';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Animal condition identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbAnimal', @level2type = N'COLUMN', @level2name = N'idfsAnimalCondition';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Animal age identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbAnimal', @level2type = N'COLUMN', @level2name = N'idfsAnimalAge';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Animal species identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbAnimal', @level2type = N'COLUMN', @level2name = N'idfSpecies';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Assocciated flex-form identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbAnimal', @level2type = N'COLUMN', @level2name = N'idfObservation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Description', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbAnimal', @level2type = N'COLUMN', @level2name = N'strDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = 'Animal code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbAnimal', @level2type = N'COLUMN', @level2name = N'strAnimalCode';

