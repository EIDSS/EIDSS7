CREATE TABLE [dbo].[tstSecurityConfigurationAlphabetParticipation] (
    [idfSecurityConfiguration]          BIGINT           NOT NULL,
    [idfsSecurityConfigurationAlphabet] BIGINT           NOT NULL,
    [intRowStatus]                      INT              CONSTRAINT [Def_0_2666] DEFAULT ((0)) NOT NULL,
    [rowguid]                           UNIQUEIDENTIFIER CONSTRAINT [newid__2557] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]                BIGINT           NULL,
    [SourceSystemKeyValue]              NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstSecurityConfigurationAlphabetParticipation] PRIMARY KEY CLUSTERED ([idfSecurityConfiguration] ASC, [idfsSecurityConfigurationAlphabet] ASC),
    CONSTRAINT [FK_tstSecurityConfigurationAlphabetParticipation_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstSecurityConfigurationAlphabetParticipation_tstSecurityConfiguration__idfSecurityConfiguration_R_1763] FOREIGN KEY ([idfSecurityConfiguration]) REFERENCES [dbo].[tstSecurityConfiguration] ([idfSecurityConfiguration]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstSecurityConfigurationAlphabetParticipation_tstSecurityConfigurationAlphabet__idfsSecurityConfigurationAlphabet_R_1762] FOREIGN KEY ([idfsSecurityConfigurationAlphabet]) REFERENCES [dbo].[tstSecurityConfigurationAlphabet] ([idfsSecurityConfigurationAlphabet]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tstSecurityConfigurationAlphabetParticipation_A_Update] ON [dbo].[tstSecurityConfigurationAlphabetParticipation]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF (dbo.FN_GBL_TriggersWork ()=1 )
	BEGIN
		IF (UPDATE(idfSecurityConfiguration) OR UPDATE(idfsSecurityConfigurationAlphabet))
		BEGIN
			RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
			ROLLBACK TRANSACTION
		END

	END

END

GO


CREATE TRIGGER [dbo].[TR_tstSecurityConfigurationAlphabetParticipation_I_Delete] on [dbo].[tstSecurityConfigurationAlphabetParticipation]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfSecurityConfiguration], [idfsSecurityConfigurationAlphabet]) as
		(
			SELECT [idfSecurityConfiguration], [idfsSecurityConfigurationAlphabet] FROM deleted
			EXCEPT
			SELECT [idfSecurityConfiguration], [idfsSecurityConfigurationAlphabet] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tstSecurityConfigurationAlphabetParticipation as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfSecurityConfiguration = b.idfSecurityConfiguration
			AND a.idfsSecurityConfigurationAlphabet = b.idfsSecurityConfigurationAlphabet;

	END

END
