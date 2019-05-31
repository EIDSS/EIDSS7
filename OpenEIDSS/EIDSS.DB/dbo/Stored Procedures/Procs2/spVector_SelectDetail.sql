
--##SUMMARY Select data for Vector form

--##REMARKS Author: Zhdanova A.
--##REMARKS Create date: 3.08.2011

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
declare	@idfVector	bigint

select @idfVector = MAX(idfVector) from dbo.tlbVector

execute	dbo.spVector_SelectDetail
	@idfVector
*/

create procedure	[dbo].[spVector_SelectDetail]
(		
	@idfVectorSurveillanceSession AS bigint--##PARAM @idfVectorSurveillanceSession - AS session ID
	--@idfVector	bigint		--##PARAM @idfVector Vector Id
	,@LangID AS nvarchar(50)--##PARAM @LangID - language ID
)
as
Begin
	SELECT 
		V.idfVector,
		V.idfVectorSurveillanceSession, 
		VS.strSessionID,
		V.idfsVectorType, 
		VectorType.name	AS [strVectorType],
		V.idfsVectorSubType, 
		V.strVectorID, 
		V.strFieldVectorID, 
		V.idfHostVector,
		V2.strVectorID As [strHostVector],
		V.idfLocation,
		--gl.idfsCountry,
		Country.name as [strCountry],			    
		--gl.idfsRegion,
		Region.name as [strRegion],
		--gl.idfsRayon,
		Rayon.name as [strRayon],
		--gl.idfsSettlement,
		Settlement.name as [strSettlement], 
		V.[intElevation], 
		V.idfsSurrounding, 
		Surrounding.name	AS [strSurrounding],
		V.strGEOReferenceSources, 
		V.idfCollectedByOffice, 
		CollectedByOffice.name AS [strCollectedByOffice],
		V.idfCollectedByPerson,
		dbo.fnConcatFullName(CollectedByPerson.strFamilyName, CollectedByPerson.strFirstName, CollectedByPerson.strSecondName) AS strCollectedByPerson,
		V.datCollectionDateTime, 
		--V.intCollectionEffort, 
		V.idfsCollectionMethod, 
		CollectionMethod.name AS [strCollectionMethod],
		V.idfsBasisOfRecord, 
		BasisOfRecord.name AS [strBasisOfRecord],
		V.intQuantity, 
		V.idfsSex, 
		Sex.name AS [strSex],
		V.idfIdentifiedByOffice, 
		IdentifiedByOffice.name AS [strIdentifiedByOffice],
		V.idfIdentifiedByPerson, 
		dbo.fnConcatFullName(IdentifiedByPerson.strFamilyName, IdentifiedByPerson.strFirstName, IdentifiedByPerson.strSecondName) AS strIdentifiedByPerson,
		V.datIdentifiedDateTime, 
		V.idfsIdentificationMethod,
		IdentificationMethod.name AS [strIdentificationMethod], 
		V.idfObservation,
		Observation.idfsFormTemplate,
		gl.dblLatitude,
		gl.dblLongitude,
		V.idfsDayPeriod,
		Period.name	AS [strDayPeriod],
		VectorSubType.name AS [strSpecies],
		V.strComment,
		V.idfsEctoparasitesCollected
		,ISNULL(EctoparasitesCollected.[name], EctoparasitesCollected.strDefault) AS [strEctoparasitesCollected]
FROM dbo.tlbVector V
Inner Join dbo.tlbVectorSurveillanceSession VS On V.idfVectorSurveillanceSession = VS.idfVectorSurveillanceSession

left join tlbGeoLocation gl
on gl.idfGeoLocation = V.idfLocation

left join fnGisReference(@LangID,19000003) Region
on	Region.idfsReference = gl.idfsRegion

left join fnGisReference(@LangID,19000002) Rayon
on	Rayon.idfsReference = gl.idfsRayon

left join fnGisReference(@LangID,19000001) Country
on	Country.idfsReference = gl.idfsCountry  

left join fnGisReference(@LangID,19000004) Settlement
on	Settlement.idfsReference = gl.idfsSettlement
	
LEFT JOIN	dbo.fnReference(@LangID,19000139) Surrounding
ON			Surrounding.idfsReference = V.idfsSurrounding
	
LEFT JOIN	tlbPerson CollectedByPerson
ON			CollectedByPerson.idfPerson = V.idfCollectedByPerson
	
JOIN		tlbOffice Office1
ON			Office1.idfOffice = V.idfCollectedByOffice
		AND Office1.intRowStatus = 0						
JOIN		dbo.fnReference(@LangID,19000045) CollectedByOffice
ON			CollectedByOffice.idfsReference = Office1.idfsOfficeAbbreviation	

LEFT JOIN	dbo.fnReference(@LangID,19000136) Period
ON			Period.idfsReference = V.idfsDayPeriod

JOIN		dbo.fnReference(@LangID,19000141) VectorSubType
ON			VectorSubType.idfsReference = V.idfsVectorSubType
	
JOIN		dbo.fnReference(@LangID,19000140) VectorType
ON			VectorType.idfsReference = V.idfsVectorType
	
LEFT JOIN	dbo.fnReference(@LangID,19000007) Sex
ON			Sex.idfsReference = V.idfsSex
	
LEFT JOIN	dbo.fnReference(@LangID,19000135) CollectionMethod
ON			CollectionMethod.idfsReference = V.idfsCollectionMethod
	
LEFT JOIN	dbo.fnReference(@LangID,19000137) BasisOfRecord
ON			BasisOfRecord.idfsReference = V.idfsBasisOfRecord
	
LEFT JOIN	tlbPerson IdentifiedByPerson
ON			IdentifiedByPerson.idfPerson = V.idfIdentifiedByPerson
	
LEFT JOIN	tlbOffice Office2
ON			Office2.idfOffice = V.idfIdentifiedByOffice
		AND Office2.intRowStatus = 0
LEFT JOIN	dbo.fnReference(@LangID,19000045) IdentifiedByOffice
ON			IdentifiedByOffice.idfsReference = Office2.idfsOfficeAbbreviation
				
LEFT JOIN	dbo.fnReference(@LangID,19000138) IdentificationMethod
ON			IdentificationMethod.idfsReference = V.idfsIdentificationMethod
			
LEFT JOIN	dbo.tlbObservation Observation
ON			V.idfObservation = Observation.idfObservation	
	
Left Join dbo.tlbVector V2 On V.idfHostVector = V2.idfVector

LEFT JOIN dbo.fnReference(@LangID, 19000100) EctoparasitesCollected ON EctoparasitesCollected.idfsReference = V.idfsEctoparasitesCollected
			
WHERE V.idfVectorSurveillanceSession = @idfVectorSurveillanceSession

AND V.intRowStatus = 0
		
-- all vectors for this session (for lookup)
Select 
V.idfVector,
V.idfVectorSurveillanceSession,
V.idfsVectorType, 
VectorType.name	AS [strVectorType],
V.idfsVectorSubType, 
VectorSubType.name AS [strSpecies],
V.strVectorID, 
V.strFieldVectorID
From dbo.tlbVector V
	
Inner Join		dbo.fnReference(@LangID,19000141) VectorSubType
ON			VectorSubType.idfsReference = V.idfsVectorSubType	
Inner Join		dbo.fnReference(@LangID,19000140) VectorType
ON			VectorType.idfsReference = V.idfsVectorType
	
WHERE V.idfVectorSurveillanceSession = @idfVectorSurveillanceSession
		
end
