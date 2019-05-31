
--*************************************************************
-- Name 				: FN_ADMIN_STLE_GetList
-- Description			: Support function for Settlement data
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--
-- Testing code:
-- select * from FN_ADMIN_STLE_GetList ('th') ----JL:checking and return data
--*************************************************************

CREATE FUNCTION [dbo].[FN_ADMIN_STLE_GetList]
(
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)
RETURNS @Table TABLE
 (

	[idfsSettlement]				BIGINT NOT NULL
	,[SettlementDefaultName]		NVARCHAR(255) COLLATE database_default
	,[SettlementNationalName]		NVARCHAR(255) COLLATE database_default
	,[idfsSettlementType]			BIGINT NOT NULL
	,[SettlementTypeDefaultName]	NVARCHAR(255) COLLATE database_default
	,[SettlementTypeNationalName]	NVARCHAR(255) COLLATE database_default
	,[idfsCountry]					BIGINT 
	,[CountryDefaultName]			NVARCHAR(255) COLLATE database_default
	,[CountryNationalName]			NVARCHAR(255) COLLATE database_default
	,[idfsRegion]					BIGINT 
	,[RegionDefaultName]			NVARCHAR(255) COLLATE database_default
	,[RegionNationalName]			NVARCHAR(255) COLLATE database_default
	,[idfsRayon]					BIGINT 
	,[RayonDefaultName]				NVARCHAR(255) COLLATE database_default
	,[RayonNationalName]			NVARCHAR(255) COLLATE database_default
	,[strSettlementCode]			NVARCHAR(200) COLLATE database_default
	,[dblLongitude]					FLOAT
	,[dblLatitude]					FLOAT
	,[intElevation]					INT
 )  

AS

BEGIN

		DECLARE @langid_int		BIGINT

		SET @langid_int = dbo.FN_GBL_LanguageCode_GET(@LangID);

		DECLARE @SettlementTypes TABLE 
			(

			  idfsSettlementType BIGINT
			 ,SettlementTypeDefaultName NVARCHAR(255)
			 ,SettlementTypeNationalName NVARCHAR(255)			
			)

		INSERT 
		INTO	@SettlementTypes
			(
				idfsSettlementType,
				SettlementTypeDefaultName,
				SettlementTypeNationalName
			)

		SELECT	BR.idfsGISBaseReference, 
				BR.strDefault, 
				ISNULL(SNT.strTextString, BR.strDefault)
		FROM	dbo.gisBaseReference BR
		LEFT OUTER JOIN dbo.gisStringNameTranslation SNT 
		ON		BR.idfsGISBaseReference = SNT.idfsGISBaseReference And SNT.idfsLanguage = @langid_int AND SNT.intRowStatus = 0
		WHERE	BR.idfsGISBaseReference In 	(
											 SELECT DISTINCT idfsSettlementType 
											 FROM dbo.gisSettlement
											)
		AND		BR.intRowStatus = 0

		DECLARE @GRCountry TABLE
			(
				idfsReference BIGINT
				,DefaultName NVARCHAR(255)
				,NationalName NVARCHAR(255)			
		)

		INSERT
		INTO	@GRCountry
			(
				idfsReference,
				DefaultName,
				NationalName
			)

		SELECT
				b.idfsGISBaseReference, 
				b.strDefault, 
				ISNULL(c.strTextString, b.strDefault)
		FROM	dbo.gisBaseReference as b 
		LEFT JOIN	dbo.gisStringNameTranslation AS c 
		ON			b.idfsGISBaseReference = c.idfsGISBaseReference 
		AND			c.idfsLanguage = @langid_int AND c.intRowStatus = 0
		WHERE		b.idfsGISReferenceType = 19000001  ----JL: get country list from gisBaseReference
		AND			b.intRowStatus = 0

		DECLARE @GRRayon TABLE
			(
				idfsReference BIGINT
				,DefaultName NVARCHAR(255)
				,NationalName NVARCHAR(255)			
			)
		INSERT
		INTO	@GRRayon
			(
				idfsReference,
				DefaultName,
				NationalName
			)

		SELECT
				b.idfsGISBaseReference, 
				b.strDefault, 
				ISNULL(c.strTextString, b.strDefault)
		FROM	dbo.gisBaseReference as b 
		LEFT JOIN	dbo.gisStringNameTranslation AS c 
		ON			b.idfsGISBaseReference = c.idfsGISBaseReference and c.idfsLanguage = @langid_int AND c.intRowStatus = 0
		WHERE		b.idfsGISReferenceType = 19000002
		AND			b.intRowStatus = 0

		DECLARE @GRRegion TABLE
			(
				idfsReference Bigint
				,DefaultName NVARCHAR(255)
				,NationalName NVARCHAR(255)			
			)

		INSERT 
		INTO	@GRRegion
			(
				idfsReference,
				DefaultName,
				NationalName
			)

		SELECT
				b.idfsGISBaseReference, 
				b.strDefault, 
				ISNULL(c.strTextString, b.strDefault)
		FROM	dbo.gisBaseReference as b 
		LEFT JOIN	dbo.gisStringNameTranslation AS c 
		ON			b.idfsGISBaseReference = c.idfsGISBaseReference and c.idfsLanguage = @langid_int AND c.intRowStatus = 0
		WHERE		b.idfsGISReferenceType = 19000003
		AND			b.intRowStatus = 0

		DECLARE @GRidfsSettlement TABLE 
			(
				idfsReference Bigint
				,DefaultName NVARCHAR(255)
				,NationalName NVARCHAR(255)			
			)

		INSERT
		INTO	 @GRidfsSettlement
			(
				idfsReference,
				DefaultName,
				NationalName
			)
		SELECT
				b.idfsGISBaseReference, 
				b.strDefault, 
				ISNULL(c.strTextString, b.strDefault)
		FROM	dbo.gisBaseReference AS b 
		LEFT JOIN	dbo.gisStringNameTranslation AS c 
		ON			b.idfsGISBaseReference = c.idfsGISBaseReference 
		AND			c.idfsLanguage = @langid_int 
		AND			c.intRowStatus = 0
		WHERE		b.idfsGISReferenceType = 19000004
		AND			b.intRowStatus = 0

		INSERT
		INTO	@Table
			(
				idfsSettlement,
				SettlementDefaultName,
				SettlementNationalName,
				idfsSettlementType,
				SettlementTypeDefaultName,
				SettlementTypeNationalName,
				idfsCountry,
				CountryDefaultName,
				CountryNationalName,
				idfsRegion,
				RegionDefaultName,
				RegionNationalName,
				idfsRayon,
				RayonDefaultName,
				RayonNationalName,
				strSettlementCode,
				dblLongitude,
				dblLatitude,
				intElevation
			)

		SELECT
				idfsSettlement
				,GRidfsSettlement.DefaultName
				,GRidfsSettlement.NationalName
				,GS.idfsSettlementType
				,ST.SettlementTypeDefaultName
				,ST.SettlementTypeNationalName
				,idfsCountry
				,GRCountry.DefaultName
				,GRCountry.NationalName
				,idfsRegion
				,GRRegion.DefaultName
				,GRRegion.NationalName
				,idfsRayon
				,GRRayon.DefaultName
				,GRRayon.NationalName
				,strSettlementCode
				,dblLongitude
				,dblLatitude
				,intElevation
		FROM	dbo.gisSettlement GS
		INNER JOIN	@SettlementTypes ST 
		ON			GS.[idfsSettlementType] = ST.idfsSettlementType
		INNER JOIN	@GRCountry GRCountry 
		ON			GS.[idfsCountry] = GRCountry.idfsReference
		INNER JOIN	@GRRayon GRRayon 
		ON			GS.[idfsRayon] = GRRayon.idfsReference
		INNER JOIN	@GRRegion GRRegion 
		ON			GS.[idfsRegion] = GRRegion.idfsReference
		INNER JOIN	@GRidfsSettlement GRidfsSettlement 
		ON			GS.[idfsSettlement] = GRidfsSettlement.idfsReference

		RETURN
END


