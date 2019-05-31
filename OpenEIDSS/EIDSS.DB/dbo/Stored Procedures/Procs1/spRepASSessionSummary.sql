

--##SUMMARY 
--##REMARKS Author: 
--##REMARKS Create date: 
--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec [spRepASSessionSummary]  12920000511, 'en'

*/

create  Procedure [dbo].[spRepASSessionSummary]
	(
		@idfCase bigint,
		@LangID nvarchar(20)
	)
AS	

declare @intTotalSamples int
		, @intTotalPositive int
		, @intTotalAnimalsSampled int


select @intTotalSamples = sum(tmss.intSamplesQty)
		,@intTotalPositive = sum(tmss.intPositiveAnimalsQty)
		,@intTotalAnimalsSampled = sum(tmss.intSampledAnimalsQty)
from tlbMonitoringSessionSummary tmss
where tmss.intRowStatus = 0
and tmss.idfMonitoringSession = @idfCase		



select   
			
			 tmss.idfMonitoringSessionSummary			as idfsKey
			,tlbFarm.strFarmCode						as strFarmCode
			,tlbFarm.idfFarm							as idfFarm
			,dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName) 
														as strOwnerName
			,dbo.fnGeoLocationString(@LangID,tlbFarm.idfFarmAddress,null) 
														as strFarmAddress
			,spt.[name]									as strSpecies
			,fnAnimalGender.[name]						as strSex
			,tmss.intSampledAnimalsQty					as intAnimalSampled
			,STUFF((SELECT ', ' +  st.name AS [text()]
				FROM    tlbMonitoringSessionSummarySample ss
				INNER JOIN fnReferenceRepair(@LangID, 19000087) st ON--standard Livestock
					ss.idfsSampleType = st.idfsReference
				WHERE ss.idfMonitoringSessionSummary = tmss.idfMonitoringSessionSummary
						AND ss.blnChecked = 1
				FOR XML PATH ('')),1,2,'')				as strSampleType
			,tmss.intSamplesQty							as intNumberOfSamples
			,tmss.datCollectionDate						as datCollectionDate				
			,tmss.intPositiveAnimalsQty					as intPositiveNumber
			,STUFF((SELECT   ', ' + diagnosis.name AS [text()]
					FROM    tlbMonitoringSessionSummaryDiagnosis sd
					INNER JOIN fnDiagnosisRepair(@LangID, 32, 10020001) diagnosis ON--standard Livestock
						sd.idfsDiagnosis = diagnosis.idfsDiagnosis
					WHERE sd.idfMonitoringSessionSummary = tmss.idfMonitoringSessionSummary
							AND sd.blnChecked = 1
					FOR XML PATH ('')),1,2,'')			as strDiagnosis
			
			,@intTotalSamples				as intTotalSamples
			,@intTotalPositive				as intTotalPositive
			,@intTotalAnimalsSampled		as intTotalAnimalsSampled
			
from tlbMonitoringSessionSummary tmss

-- get farm
inner join
			(	tlbFarm
				
				left join	tlbHuman 
				on			tlbFarm.idfHuman = tlbHuman.idfHuman 
				and tlbHuman.intRowStatus = 0
			)
on 			tlbFarm.idfFarm = tmss.idfFarm and
			tlbFarm.intRowStatus = 0
			
inner join	(	
				tlbSpecies
				inner join	dbo.fnReferenceRepair(@LangID,19000086) as spt
				on			spt.idfsReference = tlbSpecies.idfsSpeciesType
			)
on			tlbSpecies.idfSpecies  = tmss.idfSpecies and
			tlbSpecies.intRowStatus = 0			
			

left join	dbo.fnReferenceRepair(@LangID,19000007) as fnAnimalGender
on			fnAnimalGender.idfsReference = tmss.idfsAnimalSex

	
			
where tmss.intRowStatus = 0
and tmss.idfMonitoringSession = @idfCase			

	

