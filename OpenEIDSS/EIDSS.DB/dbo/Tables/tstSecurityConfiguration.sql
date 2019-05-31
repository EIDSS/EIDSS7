CREATE TABLE [dbo].[tstSecurityConfiguration] (
    [idfSecurityConfiguration]       BIGINT           NOT NULL,
    [idfParentSecurityConfiguration] BIGINT           NULL,
    [idfsSecurityLevel]              BIGINT           NOT NULL,
    [intAccountLockTimeout]          INT              NULL,
    [intAccountTryCount]             INT              NULL,
    [intInactivityTimeout]           INT              NULL,
    [intPasswordAge]                 INT              NULL,
    [intPasswordHistoryLength]       INT              NULL,
    [intPasswordMinimalLength]       INT              NULL,
    [intAlphabetCount]               INT              CONSTRAINT [Def_0_2662] DEFAULT ((0)) NOT NULL,
    [intForcePasswordComplexity]     INT              CONSTRAINT [Def_0_2663] DEFAULT ((0)) NOT NULL,
    [blnPredefined]                  BIT              CONSTRAINT [Def_0___2731] DEFAULT ((0)) NULL,
    [intRowStatus]                   INT              CONSTRAINT [Def_0_2647] DEFAULT ((0)) NOT NULL,
    [rowguid]                        UNIQUEIDENTIFIER CONSTRAINT [newid__2519] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]             BIGINT           NULL,
    [SourceSystemKeyValue]           NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstSecurityConfiguration] PRIMARY KEY CLUSTERED ([idfSecurityConfiguration] ASC),
    CONSTRAINT [FK_tstSecurityConfiguration_trtBaseReference__idfsSecurityLevel_R_1759] FOREIGN KEY ([idfsSecurityLevel]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstSecurityConfiguration_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tstSecurityConfiguration_tstSecurityConfiguration__idfParentSecurityConfiguration_R_1761] FOREIGN KEY ([idfParentSecurityConfiguration]) REFERENCES [dbo].[tstSecurityConfiguration] ([idfSecurityConfiguration]) NOT FOR REPLICATION
);


GO

CREATE TRIGGER [dbo].[TR_tstSecurityConfiguration_A_Update] ON [dbo].[tstSecurityConfiguration]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF dbo.FN_GBL_TriggersWork ()=1 
	BEGIN
		IF UPDATE(idfSecurityConfiguration)
		BEGIN
			RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
			ROLLBACK TRANSACTION
		END

	END

END

GO



CREATE TRIGGER [dbo].[TR_tstSecurityConfiguration_I_Delete] on [dbo].[tstSecurityConfiguration]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfSecurityConfiguration]) as
		(
			SELECT [idfSecurityConfiguration] FROM deleted
			EXCEPT
			SELECT [idfSecurityConfiguration] from inserted
		)

		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tstSecurityConfiguration as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			on a.idfSecurityConfiguration = b.idfSecurityConfiguration;

	END

END
