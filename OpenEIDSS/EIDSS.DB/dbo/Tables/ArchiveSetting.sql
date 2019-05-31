CREATE TABLE [dbo].[ArchiveSetting] (
    [ArchiveSettingUID]         BIGINT           NOT NULL,
    [ArchiveBeginDate]          DATE             NULL,
    [ArchiveScheduledStartTime] TIME (7)         NULL,
    [DataAgeforArchiveInYears]  INT              NULL,
    [ArchiveFrequencyInDays]    INT              CONSTRAINT [Def_ArchiveSetting_ArchiveFrequency] DEFAULT ((1)) NOT NULL,
    [intRowStatus]              INT              CONSTRAINT [Def_ArchiveSetting_intRowStatus] DEFAULT ((0)) NOT NULL,
    [AuditCreateUser]           VARCHAR (100)    NOT NULL,
    [AuditCreateDTM]            DATETIME         DEFAULT (getdate()) NOT NULL,
    [AuditUpdateUser]           VARCHAR (100)    NULL,
    [AuditUpdateDTM]            DATETIME         NULL,
    [rowguid]                   UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]        BIGINT           NULL,
    [SourceSystemKeyValue]      NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKArchiveSetting] PRIMARY KEY CLUSTERED ([ArchiveSettingUID] ASC),
    CONSTRAINT [FK_ArchiveSetting_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_ArchiveSetting_I_Delete] ON [dbo].[ArchiveSetting]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([ArchiveSettingUID]) as
		(
			SELECT [ArchiveSettingUID] FROM deleted
			EXCEPT
			SELECT [ArchiveSettingUID] FROM inserted
		)

		UPDATE a
		SET  intRowStatus = 1
		FROM dbo.ArchiveSetting as a
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.ArchiveSettingUID = b.ArchiveSettingUID;
	END

END


GO

CREATE TRIGGER [dbo].[TR_ArchiveSetting_A_Update] ON [dbo].[ArchiveSetting]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE(ArchiveSettingUID))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
