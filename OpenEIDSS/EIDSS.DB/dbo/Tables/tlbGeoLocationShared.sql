CREATE TABLE [dbo].[tlbGeoLocationShared] (
    [idfGeoLocationShared]  BIGINT           NOT NULL,
    [idfsResidentType]      BIGINT           NULL,
    [idfsGroundType]        BIGINT           NULL,
    [idfsGeoLocationType]   BIGINT           NULL,
    [idfsCountry]           BIGINT           NULL,
    [idfsRegion]            BIGINT           NULL,
    [idfsRayon]             BIGINT           NULL,
    [idfsSettlement]        BIGINT           NULL,
    [idfsSite]              BIGINT           CONSTRAINT [Def_fnSiteID_tlbGeoLocationShared] DEFAULT ([dbo].[fnSiteID]()) NOT NULL,
    [strPostCode]           NVARCHAR (200)   NULL,
    [strStreetName]         NVARCHAR (200)   NULL,
    [strHouse]              NVARCHAR (200)   NULL,
    [strBuilding]           NVARCHAR (200)   NULL,
    [strApartment]          NVARCHAR (200)   NULL,
    [strDescription]        NVARCHAR (200)   NULL,
    [dblDistance]           FLOAT (53)       NULL,
    [dblLatitude]           FLOAT (53)       NULL,
    [dblLongitude]          FLOAT (53)       NULL,
    [dblAccuracy]           FLOAT (53)       NULL,
    [dblAlignment]          FLOAT (53)       NULL,
    [intRowStatus]          INT              CONSTRAINT [Def_0_20562] DEFAULT ((0)) NOT NULL,
    [rowguid]               UNIQUEIDENTIFIER CONSTRAINT [newid__20582] DEFAULT (newid()) ROWGUIDCOL NOT NULL,
    [blnForeignAddress]     BIT              DEFAULT ((0)) NOT NULL,
    [strForeignAddress]     NVARCHAR (200)   NULL,
    [strAddressString]      NVARCHAR (1000)  NULL,
    [strShortAddressString] NVARCHAR (2000)  NULL,
    [strMaintenanceFlag]    NVARCHAR (20)    NULL,
    [strReservedAttribute]  NVARCHAR (MAX)   NULL,
    [SourceSystemNameID]    BIGINT           NULL,
    [SourceSystemKeyValue]  NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtlbGeoLocationShared] PRIMARY KEY CLUSTERED ([idfGeoLocationShared] ASC),
    CONSTRAINT [FK_tlbGeoLocationShared_gisCountry__idfsCountry_R_972] FOREIGN KEY ([idfsCountry]) REFERENCES [dbo].[gisCountry] ([idfsCountry]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbGeoLocationShared_gisRayon__idfsRayon_R_974] FOREIGN KEY ([idfsRayon]) REFERENCES [dbo].[gisRayon] ([idfsRayon]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbGeoLocationShared_gisRegion__idfsRegion_R_973] FOREIGN KEY ([idfsRegion]) REFERENCES [dbo].[gisRegion] ([idfsRegion]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbGeoLocationShared_gisSettlement__idfsSettlement_R_1218] FOREIGN KEY ([idfsSettlement]) REFERENCES [dbo].[gisSettlement] ([idfsSettlement]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbGeoLocationShared_trtBaseReference__idfsGeoLocationType_R_1238] FOREIGN KEY ([idfsGeoLocationType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbGeoLocationShared_trtBaseReference__idfsGroundType_R_1239] FOREIGN KEY ([idfsGroundType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbGeoLocationShared_trtBaseReference__idfsResidentType_R_1277] FOREIGN KEY ([idfsResidentType]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]) NOT FOR REPLICATION,
    CONSTRAINT [FK_tlbGeoLocationShared_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_tlbGeoLocationShared_tstSite__idfsSite_R_1028] FOREIGN KEY ([idfsSite]) REFERENCES [dbo].[tstSite] ([idfsSite]) NOT FOR REPLICATION
);


GO

CREATE  TRIGGER [dbo].[TR_tlbGeoLocationShared_A_Insert] ON [dbo].[tlbGeoLocationShared]	
FOR INSERT
AS

IF ((TRIGGER_NESTLEVEL()<2) AND (dbo.fnTriggersWork ()=1))
BEGIN
	
	UPDATE tgl
	SET	
		tgl.strAddressString = dbo.fnGeoLocationSharedString('en', i.idfGeoLocationShared, i.idfsGeoLocationType),
		tgl.strShortAddressString = dbo.fnGeoLocationSharedShortAddressString('en', i.idfGeoLocationShared, i.idfsGeoLocationType)

	FROM dbo.tlbGeoLocationShared AS tgl 
	JOIN inserted AS i ON tgl.idfGeoLocationShared = i.idfGeoLocationShared
	
	WHERE ISNULL(tgl.strAddressString, '') <> dbo.fnGeoLocationSharedString('en', i.idfGeoLocationShared, i.idfsGeoLocationType)
	OR ISNULL(tgl.strShortAddressString, '') <> dbo.fnGeoLocationSharedShortAddressString('en', i.idfGeoLocationShared, i.idfsGeoLocationType)
		
	INSERT INTO tlbGeoLocationSharedTranslation
	(
		idfGeoLocationShared,
		idfsLanguage, 
		strTextString, 
		strShortAddressString
	)
	SELECT
		tgl.idfGeoLocationShared,
		tltc.idfsLanguage,
		dbo.fnGeoLocationSharedString(tbr.strBaseReferenceCode, i.idfGeoLocationShared, i.idfsGeoLocationType),
		dbo.fnGeoLocationSharedShortAddressString(tbr.strBaseReferenceCode, i.idfGeoLocationShared, i.idfsGeoLocationType)

	FROM dbo.tlbGeoLocationShared AS tgl 
	JOIN inserted AS i ON tgl.idfGeoLocationShared = i.idfGeoLocationShared
	CROSS JOIN trtLanguageToCP tltc	JOIN trtBaseReference tbr ON tbr.idfsBaseReference = tltc.idfsLanguage AND tbr.intRowStatus = 0
	LEFT JOIN tlbGeoLocationSharedTranslation tglt ON tglt.idfGeoLocationShared = tgl.idfGeoLocationShared AND tglt.idfsLanguage = tltc.idfsLanguage
	JOIN tstCustomizationPackage tcp1 ON tcp1.idfCustomizationPackage = tltc.idfCustomizationPackage
	
	WHERE tcp1.idfsCountry = dbo.fnCustomizationCountry()
	AND tglt.idfGeoLocationShared IS NULL

END

SET ANSI_NULLS ON

GO


CREATE TRIGGER [dbo].[TR_tlbGeoLocationShared_I_Delete] on [dbo].[tlbGeoLocationShared]
INSTEAD OF DELETE
NOT FOR REPLICATION
AS
BEGIN

	IF (dbo.FN_GBL_TriggersWork() = 1)
	BEGIN

		WITH cteOnlyDeletedRecords([idfGeoLocationShared]) as
		(
			SELECT [idfGeoLocationShared] FROM deleted
			EXCEPT
			SELECT [idfGeoLocationShared] FROM inserted
		)
		
		UPDATE a
		SET intRowStatus = 1
		FROM dbo.tlbGeoLocationShared as a 
		INNER JOIN cteOnlyDeletedRecords as b 
			ON a.idfGeoLocationShared = b.idfGeoLocationShared;

	END

END

GO

CREATE TRIGGER [dbo].[TR_tlbGeoLocationShared_A_Update] ON [dbo].[tlbGeoLocationShared]
FOR UPDATE
NOT FOR REPLICATION
AS

BEGIN
	IF(dbo.FN_GBL_TriggersWork ()=1)
	BEGIN
		IF(UPDATE(idfGeoLocationShared))
		BEGIN
			RAISERROR('Update Trigger: Not allowed to update PK.',16,1)
			ROLLBACK TRANSACTION
		END

		ELSE
		BEGIN
			UPDATE tgl
			SET	tgl.strAddressString = dbo.fnGeoLocationSharedString('en', i.idfGeoLocationShared, i.idfsGeoLocationType),
				tgl.strShortAddressString = dbo.fnGeoLocationSharedShortAddressString('en', i.idfGeoLocationShared, i.idfsGeoLocationType)
			FROM dbo.tlbGeoLocationShared AS tgl 
			JOIN inserted AS i ON tgl.idfGeoLocationShared = i.idfGeoLocationShared
			WHERE ISNULL(tgl.strAddressString, '') <> dbo.fnGeoLocationSharedString('en', i.idfGeoLocationShared, i.idfsGeoLocationType)
			OR ISNULL(tgl.strShortAddressString, '') <> dbo.fnGeoLocationSharedShortAddressString('en', i.idfGeoLocationShared, i.idfsGeoLocationType)
	
			MERGE dbo.tlbGeoLocationSharedTranslation AS [target]
			USING (
					SELECT
						tgl.idfGeoLocationShared,
						tltc.idfsLanguage,
						dbo.fnGeoLocationSharedString(tbr.strBaseReferenceCode, i.idfGeoLocationShared, i.idfsGeoLocationType) as strTextString,
						dbo.fnGeoLocationSharedShortAddressString(tbr.strBaseReferenceCode, i.idfGeoLocationShared, i.idfsGeoLocationType) as strShortAddressString
					FROM dbo.tlbGeoLocationShared AS tgl 
					JOIN inserted AS i ON tgl.idfGeoLocationShared = i.idfGeoLocationShared
					CROSS JOIN trtLanguageToCP tltc	JOIN trtBaseReference tbr ON tbr.idfsBaseReference = tltc.idfsLanguage AND tbr.intRowStatus = 0
					JOIN tstCustomizationPackage tcp1 ON tcp1.idfCustomizationPackage = tltc.idfCustomizationPackage
					WHERE tcp1.idfsCountry = dbo.fnCustomizationCountry()
				) AS [source]
			ON ([target].idfGeoLocationShared = [source].idfGeoLocationShared AND [target].idfsLanguage = [source].idfsLanguage)
			WHEN MATCHED AND (
								ISNULL([target].strTextString, '') <> ISNULL([source].strTextString, '')
								OR ISNULL([target].strShortAddressString, '') <> ISNULL([source].strShortAddressString, '')
							)
			THEN UPDATE SET strTextString = [source].strTextString	,
							strShortAddressString = [source].strShortAddressString;

		END

	END

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Shared Address/Geo Location', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Geo location/address identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'idfGeoLocationShared';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Residence type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'idfsResidentType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Landscape type identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'idfsGroundType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Geo location/address type identifier (exact point/relative point/address)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'idfsGeoLocationType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Country identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'idfsCountry';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Region identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'idfsRegion';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Rayon identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'idfsRayon';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Settlement identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'idfsSettlement';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Site identifier', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'idfsSite';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Postal code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'strPostCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Street name', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'strStreetName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'House number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'strHouse';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Building number', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'strBuilding';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Geo location description', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'strDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Distance from settlement (used in relative point)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'dblDistance';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Latitude', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'dblLatitude';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Longitude', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'dblLongitude';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Accuracy', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'dblAccuracy';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Alignment (used in relative point)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tlbGeoLocationShared', @level2type = N'COLUMN', @level2name = N'dblAlignment';

