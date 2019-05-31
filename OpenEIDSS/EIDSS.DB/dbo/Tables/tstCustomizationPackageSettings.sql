CREATE TABLE [dbo].[tstCustomizationPackageSettings] (
    [idfCustomizationPackage]                  BIGINT           NOT NULL,
    [intFirstDayOfWeek]                        INT              CONSTRAINT [DF__tstCustom__intFi__4CB11185] DEFAULT ((1)) NOT NULL,
    [intCalendarWeekRule]                      INT              CONSTRAINT [DF__tstCustom__intCa__4DA535BE] DEFAULT ((2)) NOT NULL,
    [intForcedReplicationPeriodSlvl]           INT              CONSTRAINT [DF__tstCustom__intFo__4E9959F7] DEFAULT ((60)) NOT NULL,
    [intForcedReplicationPeriodTlvl]           INT              CONSTRAINT [DF__tstCustom__intFo__4F8D7E30] DEFAULT ((120)) NOT NULL,
    [intForcedReplicationExpirationPeriodCdr]  INT              CONSTRAINT [DF__tstCustom__intFo__5081A269] DEFAULT ((5)) NOT NULL,
    [intForcedReplicationExpirationPeriodSlvl] INT              CONSTRAINT [DF__tstCustom__intFo__5175C6A2] DEFAULT ((5)) NOT NULL,
    [intForcedReplicationExpirationPeriodTlvl] INT              CONSTRAINT [DF__tstCustom__intFo__5269EADB] DEFAULT ((15)) NOT NULL,
    [intWhoReportPeriod]                       INT              CONSTRAINT [DF__tstCustom__intWh__535E0F14] DEFAULT ((6)) NOT NULL,
    [rowguid]                                  UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]                       BIGINT           NULL,
    [SourceSystemKeyValue]                     NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstCustomizationPackageSettings] PRIMARY KEY CLUSTERED ([idfCustomizationPackage] ASC),
    CONSTRAINT [FK_tstCustomizationPackageSettings_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tstCustomizationPackageSettings_A_Update] ON [dbo].[tstCustomizationPackageSettings]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfCustomizationPackage]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
