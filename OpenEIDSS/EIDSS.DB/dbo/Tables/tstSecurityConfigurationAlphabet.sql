CREATE TABLE [dbo].[tstSecurityConfigurationAlphabet] (
    [idfsSecurityConfigurationAlphabet] BIGINT           NOT NULL,
    [strAlphabet]                       NVARCHAR (200)   NULL,
    [intRowStatus]                      INT              CONSTRAINT [Def_0_2665] DEFAULT ((0)) NOT NULL,
    [rowguid]                           UNIQUEIDENTIFIER CONSTRAINT [newid__2556] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]                BIGINT           NULL,
    [SourceSystemKeyValue]              NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstSecurityConfigurationAlphabet] PRIMARY KEY CLUSTERED ([idfsSecurityConfigurationAlphabet] ASC),
    CONSTRAINT [FK_tstSecurityConfigurationAlphabet_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tstSecurityConfigurationAlphabet_A_Update] ON [dbo].[tstSecurityConfigurationAlphabet]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF dbo.FN_GBL_TriggersWork ()=1 
	BEGIN
		IF UPDATE(idfsSecurityConfigurationAlphabet)
		BEGIN
			RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
			ROLLBACK TRANSACTION
		END

	END

END

GO


CREATE TRIGGER [dbo].[TR_tstSecurityConfigurationAlphabet_I_Delete] on [dbo].[tstSecurityConfigurationAlphabet]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfsSecurityConfigurationAlphabet]) as
		(
			SELECT [idfsSecurityConfigurationAlphabet] FROM deleted
			EXCEPT
			SELECT [idfsSecurityConfigurationAlphabet] FROM inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tstSecurityConfigurationAlphabet as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfsSecurityConfigurationAlphabet = b.idfsSecurityConfigurationAlphabet;

	END

END
