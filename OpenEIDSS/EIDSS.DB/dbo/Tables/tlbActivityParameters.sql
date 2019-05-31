CREATE TABLE [dbo].[tlbActivityParameters] (
    [idfActivityParameters] BIGINT           NOT NULL,
    [idfsParameter]         BIGINT           NOT NULL,
    [idfObservation]        BIGINT           NOT NULL,
    [idfRow]                BIGINT           CONSTRAINT [Def_0_1979] DEFAULT ((0)) NOT NULL,
    [varValue]              SQL_VARIANT      NULL,
    [intRowStatus]          INT              CONSTRAINT [Def_0_1980] DEFAULT ((0)) NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [newid__1983] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [strMaintenanceFlag]    NVARCHAR (20)    NULL,
    [strReservedAttribute]  NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]    BIGINT           NULL,
    [SourceSystemKeyValue]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbActivityParameters] PRIMARY KEY CLUSTERED ([idfActivityParameters] ASC),
    CONSTRAINT [FK_tlbActivityParameters_ffParameter__idfsParameter_R_222] FOREIGN KEY ([idfsParameter]) REFERENCES [dbo].[ffParameter] ([idfsParameter]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbActivityParameters_tlbObservation__idfObservation_R_1423] FOREIGN KEY ([idfObservation]) REFERENCES [dbo].[tlbObservation] ([idfObservation]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbActivityParameters_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [UK_tlbActivityParameters] UNIQUE NONCLUSTERED ([idfsParameter] ASC, [idfObservation] ASC, [idfRow] ASC)
);


GO

CREATE TRIGGER [dbo].[TR_tlbActivityParameters_A_Update] ON [dbo].[tlbActivityParameters]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND UPDATE(idfActivityParameters))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END

GO


CREATE TRIGGER [dbo].[TR_tlbActivityParameters_I_Delete] on [dbo].[tlbActivityParameters]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfActivityParameters]) as
		(
			SELECT [idfActivityParameters] FROM deleted
			EXCEPT
			SELECT [idfActivityParameters] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbActivityParameters as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfActivityParameters = b.idfActivityParameters;

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flex-Form Parameter identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbActivityParameters', @level2type = N'COLUMN', @level2name = N'idfsParameter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flex-Form instance identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbActivityParameters', @level2type = N'COLUMN', @level2name = N'idfObservation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flex-Form parameter value', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbActivityParameters', @level2type = N'COLUMN', @level2name = N'varValue';

