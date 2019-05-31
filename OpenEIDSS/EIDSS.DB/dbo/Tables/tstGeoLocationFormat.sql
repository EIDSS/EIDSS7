CREATE TABLE [dbo].[tstGeoLocationFormat] (
    [idfsCountry]            BIGINT           NOT NULL,
    [strAddressString]       NVARCHAR (500)   NULL,
    [strExactPointString]    NVARCHAR (500)   NULL,
    [strRelativePointString] NVARCHAR (500)   NULL,
    [strForeignAddress]      NVARCHAR (500)   NULL,
    [strShortAddress]        NVARCHAR (500)   NULL,
    [rowguid]                UNIQUEIDENTIFIER CONSTRAINT [tstGeoLocationFormat_newid] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]     BIGINT           NULL,
    [SourceSystemKeyValue]   NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstGeoLocationFormat] PRIMARY KEY CLUSTERED ([idfsCountry] ASC),
    CONSTRAINT [FK_tstGeoLocationFormat_gisCountry__idfsCountry] FOREIGN KEY ([idfsCountry]) REFERENCES [dbo].[gisCountry] ([idfsCountry]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tstGeoLocationFormat_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO

CREATE TRIGGER [dbo].[TR_tstGeoLocationFormat_A_Update] ON [dbo].[tstGeoLocationFormat]
FOR UPDATE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1 AND UPDATE([idfsCountry]))  -- update to Primary Key is not allowed.
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1);
		ROLLBACK TRANSACTION;
	END

END
