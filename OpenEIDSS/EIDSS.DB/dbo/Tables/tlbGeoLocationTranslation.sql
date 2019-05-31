CREATE TABLE [dbo].[tlbGeoLocationTranslation] (
    [idfGeoLocation]        BIGINT           NOT NULL,
    [idfsLanguage]          BIGINT           NOT NULL,
    [strTextString]         NVARCHAR (2000)  NULL,
    [strShortAddressString] NVARCHAR (2000)  NULL,
    [strMaintenanceFlag]    NVARCHAR (20)    NULL,
    [strReservedAttribute]  NVARCHAR (MAX)   NULL,
    [rowguid]               UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]    BIGINT           NULL,
    [SourceSystemKeyValue]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbGeoLocationTranslation] PRIMARY KEY CLUSTERED ([idfGeoLocation] ASC, [idfsLanguage] ASC),
    CONSTRAINT [FK_tlbGeoLocationTranslation_tlbGeoLocation__idfGeoLocation] FOREIGN KEY ([idfGeoLocation]) REFERENCES [dbo].[tlbGeoLocation] ([idfGeoLocation]) ON DELETE CASCADE NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbGeoLocationTranslation_trtBaseReference__idfsLanguage] FOREIGN KEY ([idfsLanguage]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbGeoLocationTranslation_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);


GO
CREATE NONCLUSTERED INDEX [IX_tlbGeoLocationTranslation_BL]
    ON [dbo].[tlbGeoLocationTranslation]([idfGeoLocation] ASC, [idfsLanguage] ASC)
    INCLUDE([strTextString]);


GO

CREATE TRIGGER [dbo].[TR_tlbGeoLocationTranslation_A_Update] ON [dbo].[tlbGeoLocationTranslation]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1 AND (UPDATE(idfGeoLocation) OR UPDATE(idfsLanguage)))
	BEGIN
		RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
		ROLLBACK TRANSACTION
	END

END
