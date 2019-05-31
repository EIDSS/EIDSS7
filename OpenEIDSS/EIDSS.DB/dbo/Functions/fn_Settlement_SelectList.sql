--##SUMMARY 
--##REMARKS Author: 
--##REMARKS Create date: 
--##RETURNS 
/*

select * from fn_Settlement_SelectList ('th') ----JL:checking and return data

*/

CREATE  Function [dbo].[fn_Settlement_SelectList](
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)

Returns @Table Table

(

		[idfsSettlement] BIGINT NOT NULL

		,[SettlementDefaultName] Nvarchar(255) COLLATE database_default

		,[SettlementNationalName] Nvarchar(255) COLLATE database_default

		,[idfsSettlementType]  BIGINT NOT NULL

		,[SettlementTypeDefaultName] Nvarchar(255) COLLATE database_default

		,[SettlementTypeNationalName] Nvarchar(255) COLLATE database_default

		,[idfsCountry]   BIGINT 

		,[CountryDefaultName] Nvarchar(255) COLLATE database_default

		,[CountryNationalName] Nvarchar(255) COLLATE database_default

		,[idfsRegion]  BIGINT 

		,[RegionDefaultName] Nvarchar(255) COLLATE database_default

		,[RegionNationalName] Nvarchar(255) COLLATE database_default

		,[idfsRayon]  BIGINT 

		,[RayonDefaultName] Nvarchar(255) COLLATE database_default

		,[RayonNationalName] Nvarchar(255) COLLATE database_default

		,[strSettlementCode] Nvarchar(200) COLLATE database_default

		,[dblLongitude] Float

		,[dblLatitude] Float

		,[intElevation] int	

) 

As

Begin	

	Declare @langid_int Bigint

	Set @langid_int = dbo.fnGetLanguageCode(@LangID);



	Declare @SettlementTypes Table (

			idfsSettlementType Bigint

			,SettlementTypeDefaultName Nvarchar(255)

			,SettlementTypeNationalName Nvarchar(255)			

	)

	

	Insert into @SettlementTypes

	(

		idfsSettlementType,

		SettlementTypeDefaultName,

		SettlementTypeNationalName

	)

	Select 

		BR.idfsGISBaseReference, 

		BR.strDefault, 

		IsNull(SNT.strTextString, BR.strDefault)

	From dbo.gisBaseReference BR

		Left Outer Join dbo.gisStringNameTranslation SNT On BR.idfsGISBaseReference = SNT.idfsGISBaseReference And SNT.idfsLanguage = @langid_int AND SNT.intRowStatus = 0

	Where BR.idfsGISBaseReference In (Select Distinct idfsSettlementType From dbo.gisSettlement)

		AND BR.intRowStatus = 0

			



	Declare @GRCountry Table 

	(

			idfsReference Bigint

			,DefaultName Nvarchar(255)

			,NationalName Nvarchar(255)			

	)

	Insert into @GRCountry

	(

		idfsReference,

		DefaultName,

		NationalName

	)

	select

				b.idfsGISBaseReference, 

				b.strDefault, 

				IsNull(c.strTextString, b.strDefault)

	from		dbo.gisBaseReference as b 

	left join	dbo.gisStringNameTranslation as c 

	on			b.idfsGISBaseReference = c.idfsGISBaseReference and c.idfsLanguage = @langid_int AND c.intRowStatus = 0

	where		b.idfsGISReferenceType = 19000001  ----JL: get country list from gisBaseReference

		AND b.intRowStatus = 0

		





	Declare @GRRayon Table 

	(

			idfsReference Bigint

			,DefaultName Nvarchar(255)

			,NationalName Nvarchar(255)			

	)

	Insert into @GRRayon

	(

		idfsReference,

		DefaultName,

		NationalName

	)

	select

				b.idfsGISBaseReference, 

				b.strDefault, 

				IsNull(c.strTextString, b.strDefault)

	from		dbo.gisBaseReference as b 

	left join	dbo.gisStringNameTranslation as c 

	on			b.idfsGISBaseReference = c.idfsGISBaseReference and c.idfsLanguage = @langid_int AND c.intRowStatus = 0

	where		b.idfsGISReferenceType = 19000002

		AND b.intRowStatus = 0

		



	Declare @GRRegion Table 

	(

			idfsReference Bigint

			,DefaultName Nvarchar(255)

			,NationalName Nvarchar(255)			

	)

	Insert into @GRRegion

	(

		idfsReference,

		DefaultName,

		NationalName

	)

	select

				b.idfsGISBaseReference, 

				b.strDefault, 

				IsNull(c.strTextString, b.strDefault)

	from		dbo.gisBaseReference as b 

	left join	dbo.gisStringNameTranslation as c 

	on			b.idfsGISBaseReference = c.idfsGISBaseReference and c.idfsLanguage = @langid_int AND c.intRowStatus = 0

	where		b.idfsGISReferenceType = 19000003

		AND b.intRowStatus = 0

		





	Declare @GRidfsSettlement Table 

	(

			idfsReference Bigint

			,DefaultName Nvarchar(255)

			,NationalName Nvarchar(255)			

	)

	Insert into @GRidfsSettlement

	(

		idfsReference,

		DefaultName,

		NationalName

	)

	select

				b.idfsGISBaseReference, 

				b.strDefault, 

				IsNull(c.strTextString, b.strDefault)

	from		dbo.gisBaseReference as b 

	left join	dbo.gisStringNameTranslation as c 

	on			b.idfsGISBaseReference = c.idfsGISBaseReference and c.idfsLanguage = @langid_int AND c.intRowStatus = 0

	where		b.idfsGISReferenceType = 19000004

		AND b.intRowStatus = 0

		







	Insert into @Table

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

	Select  

		[idfsSettlement]

		,GRidfsSettlement.DefaultName

		,GRidfsSettlement.NationalName

		,GS.[idfsSettlementType]

		,ST.SettlementTypeDefaultName

		,ST.SettlementTypeNationalName

		,[idfsCountry]

		,GRCountry.DefaultName

		,GRCountry.NationalName

		,[idfsRegion]

		,GRRegion.DefaultName

		,GRRegion.NationalName

		,[idfsRayon]

		,GRRayon.DefaultName

		,GRRayon.NationalName

		,[strSettlementCode]

		,[dblLongitude]

		,[dblLatitude]

		,intElevation

	From dbo.gisSettlement GS

	Inner Join @SettlementTypes ST On GS.[idfsSettlementType] = ST.idfsSettlementType

	Inner Join @GRCountry GRCountry On GS.[idfsCountry] = GRCountry.idfsReference

	Inner Join @GRRayon GRRayon On GS.[idfsRayon] = GRRayon.idfsReference

	Inner Join @GRRegion GRRegion On GS.[idfsRegion] = GRRegion.idfsReference

	Inner Join @GRidfsSettlement GRidfsSettlement On GS.[idfsSettlement] = GRidfsSettlement.idfsReference



	Return

End






