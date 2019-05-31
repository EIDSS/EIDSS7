

--##SUMMARY Load list of tests required for Samples panel in Human Case
--##SUMMARY This procedure load only part of information.
--##SUMMARY Information about materials loaded using spCaseSamples_SelectDetail

--##REMARKS Author: Leonov
--##REMARKS Create date: 18.10.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 24.04.2013

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 21.06.2013

--##RETURNS list of tests associated with samples from specified case

CREATE PROCEDURE [dbo].[spVectorSamples_SelectDetail]
(
	@idfVector AS bigint,
	@LangID NVARCHAR(50)
)
AS
Begin

Select	
	 	Samples.idfVector
		,Vector.idfsVectorType
		,Vector.idfsVectorSubType
		,Samples.idfMaterial 
		,Samples.strBarcode -- Lab sample ID
		,Samples.strFieldBarcode -- Field Sample ID
		,Samples.idfsSampleType
		,SampleType.name as strSampleName
		,Samples.datFieldCollectionDate
		,Samples.idfSendToOffice
		,OfficeSendTo.[name] as strSendToOffice
		,Samples.idfFieldCollectedByOffice
		,Samples.datFieldSentDate
		,Samples.strNote
		,Samples.datAccession
		,Samples.idfsAccessionCondition
		,Samples.idfVector As [idfParty]
		,ISNULL(Samples.idfHumanCase, Samples.idfVetCase) AS idfCase
		,Samples.idfVectorSurveillanceSession
		,IsNull(VectorType.[name], VectorType.strDefault) As [strVectorTypeName]
		,IsNull(VectorSubType.[name], VectorSubType.strDefault) As [strVectorSubTypeName]
		,Location.idfsRegion
		,IsNull(Region.[name], Region.strDefault) As [strRegionName]
		,Location.idfsRayon
		,IsNull(Rayon.[name], Rayon.strDefault) As [strRayonName]
		,Vector.intQuantity
		,Vector.datCollectionDateTime
		,Vector.strVectorID
		,Samples.blnAccessioned as Used

from dbo.tlbMaterial Samples 

Inner Join dbo.tlbVector Vector On Samples.idfVector = Vector.idfVector 
Left Join dbo.fnReference(@LangID, 19000140) VectorType On Vector.idfsVectorType = VectorType.idfsReference
Left Join dbo.fnReference(@LangID, 19000141) VectorSubType On Vector.idfsVectorSubType = VectorSubType.idfsReference
Left Join dbo.tlbGeoLocation Location	on Location.idfGeoLocation = Vector.idfLocation

left join	dbo.fnReferenceRepair(@LangID,19000087) SampleType on	SampleType.idfsReference = Samples.idfsSampleType
Left Join fnGisReference(@LangID,19000003) Region on Region.idfsReference = Location.idfsRegion
Left Join fnGisReference(@LangID,19000002) Rayon on	Rayon.idfsReference = Location.idfsRayon
left join	tlbMaterial ParentSample
on			ParentSample.idfMaterial = Samples.idfParentMaterial
			and ParentSample.intRowStatus = 0
left join	dbo.fnInstitution(@LangID) as OfficeSendTo
on OfficeSendTo.idfOffice = Samples.idfSendToOffice

where Samples.blnShowInCaseOrSession = 1 and Samples.idfVector = @idfVector
		and Samples.intRowStatus = 0
		and not (IsNull(Samples.idfsSampleKind,0) = 12675420000000/*derivative*/ and (IsNull(Samples.idfsSampleStatus,0) = 10015002 or IsNull(Samples.idfsSampleStatus,0) = 10015008)/*deleted in lab module*/)


End
