
CREATE FUNCTION [dbo].[fn_Vector_SelectList]
(
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)
RETURNS table 
AS
return
SELECT 
    V.idfVector,
       V.idfVectorSurveillanceSession, 
       VS.strSessionID,
       V.idfsVectorType, 
       VectorType.name AS [strVectorType],
       V.idfsVectorSubType, 
       V.strVectorID, 
       V.strFieldVectorID, 
       V.idfHostVector,        
       V.idfLocation,
       gl.idfsCountry,
       Country.name as [strCountry],       
       gl.idfsRegion,
       Region.name as [strRegion],
    gl.idfsRayon,
    Rayon.name as [strRayon],
    gl.idfsSettlement,
    Settlement.name as [strSettlement], 
       V.[intElevation], 
       V.idfsSurrounding, 
       Surrounding.name AS [strSurrounding],
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
       RTRIM(ISNULL(IdentifiedByPerson.strFamilyName +N' ',N'') +ISNULL(IdentifiedByPerson.strFirstName +N' ',N'') + ISNULL(IdentifiedByPerson.strSecondName,N'')) AS strIdentifiedByPerson,
       V.datIdentifiedDateTime, 
       V.idfsIdentificationMethod,
       IdentificationMethod.name AS [strIdentificationMethod], 
       V.idfObservation,
       
       gl.dblLatitude,
       gl.dblLongitude,
       V.idfsDayPeriod,
       Period.name AS [strDayPeriod],
       VectorSubType.name AS [strSpecies]
       
 FROM dbo.tlbVector V
 Inner Join dbo.tlbVectorSurveillanceSession VS On V.idfVectorSurveillanceSession = VS.idfVectorSurveillanceSession

 inner join tlbGeoLocation gl
 on gl.idfGeoLocation = V.idfLocation

 left join fnGisReference(@LangID,19000003) Region
 on Region.idfsReference = gl.idfsRegion

 left join fnGisReference(@LangID,19000002) Rayon
 on Rayon.idfsReference = gl.idfsRayon

 left join fnGisReference(@LangID,19000001) Country
 on Country.idfsReference = gl.idfsCountry  

 left join fnGisReference(@LangID,19000004) Settlement
 on Settlement.idfsReference = gl.idfsSettlement
 
 
 
 
 LEFT JOIN dbo.fnReferenceRepair(@LangID,19000139) Surrounding
 ON   Surrounding.idfsReference = V.idfsSurrounding
 
 LEFT JOIN tlbPerson CollectedByPerson
 ON   CollectedByPerson.idfPerson = V.idfCollectedByPerson
 
 JOIN  tlbOffice Office1
 ON   Office1.idfOffice = V.idfCollectedByOffice
    AND Office1.intRowStatus = 0      
 JOIN  dbo.fnReferenceRepair(@LangID,19000045) CollectedByOffice
 ON   CollectedByOffice.idfsReference = Office1.idfsOfficeName 

 LEFT JOIN dbo.fnReferenceRepair(@LangID,19000136) Period
 ON   Period.idfsReference = V.idfsDayPeriod

 JOIN  dbo.fnReferenceRepair(@LangID,19000141) VectorSubType
 ON   VectorSubType.idfsReference = V.idfsVectorSubType
 
 JOIN  dbo.fnReferenceRepair(@LangID,19000140) VectorType
 ON   VectorType.idfsReference = V.idfsVectorType
 
 LEFT JOIN dbo.fnReferenceRepair(@LangID,19000007) Sex
 ON   Sex.idfsReference = V.idfsSex
 
 LEFT JOIN dbo.fnReferenceRepair(@LangID,19000135) CollectionMethod
 ON   CollectionMethod.idfsReference = V.idfsCollectionMethod
 
 LEFT JOIN dbo.fnReferenceRepair(@LangID,19000137) BasisOfRecord
 ON   BasisOfRecord.idfsReference = V.idfsBasisOfRecord
 
 LEFT JOIN tlbPerson IdentifiedByPerson
 ON   IdentifiedByPerson.idfPerson = V.idfIdentifiedByPerson
 
 JOIN  tlbOffice Office2
 ON   Office2.idfOffice = V.idfCollectedByOffice
    AND Office2.intRowStatus = 0
 JOIN  dbo.fnReferenceRepair(@LangID,19000045) IdentifiedByOffice
 ON   IdentifiedByOffice.idfsReference = Office2.idfsOfficeName
    
 LEFT JOIN dbo.fnReferenceRepair(@LangID,19000138) IdentificationMethod
 ON   IdentificationMethod.idfsReference = V.idfsIdentificationMethod
   
   
 WHERE V.intRowStatus = 0
