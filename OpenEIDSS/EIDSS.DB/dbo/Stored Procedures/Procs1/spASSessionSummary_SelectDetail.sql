
--##SUMMARY Selects data for AS session summary

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 29.11.2011

--##RETURNS Doesn't use


/*
--Example of procedure call:
EXEC spASSessionSummary_SelectDetail 18830000871, 'en'
*/

CREATE PROCEDURE [dbo].[spASSessionSummary_SelectDetail]
	@idfMonitoringSession bigint
	,@LangID nvarchar(50)
AS

--0 main summary table
SELECT DISTINCT idfMonitoringSessionSummary
		,tlbMonitoringSessionSummary.idfMonitoringSession
		,tlbMonitoringSessionSummary.idfFarm
		,strFarmCode
		,idfFarmActual
		,tlbMonitoringSessionSummary.idfSpecies
		,CASE WHEN tlbMonitoringSessionSummary.idfSpecies IS NULL THEN CAST(NULL as bigint) ELSE tlbHerd.idfHerd END as idfHerd 
		,CASE WHEN tlbMonitoringSessionSummary.idfSpecies IS NULL THEN CAST(NULL as nvarchar(100)) ELSE tlbHerd.strHerdCode END as strHerdCode   
		--,tlbHerd.idfHerd
		--,tlbHerd.strHerdCode
		,CASE WHEN tlbMonitoringSessionSummary.idfSpecies IS NULL THEN CAST(NULL as bigint) ELSE tlbSpecies.idfsSpeciesType END as idfsSpeciesType 
		--,Gender.[name] AS strGender
		,CASE WHEN tlbMonitoringSessionSummary.idfSpecies IS NULL THEN CAST(NULL as NVARCHAR(100)) ELSE Species.[name] END as strSpecies 
		,idfsAnimalSex
		,intSampledAnimalsQty
		,intSamplesQty
		,datCollectionDate
		,intPositiveAnimalsQty
		,STUFF((SELECT   ', ' + diagnosis.name AS [text()]
			FROM    tlbMonitoringSessionSummaryDiagnosis sd
			INNER JOIN fnDiagnosisRepair(@LangID, 32, 10020001) diagnosis ON--standard Livestock
				sd.idfsDiagnosis = diagnosis.idfsDiagnosis
			WHERE sd.idfMonitoringSessionSummary = tlbMonitoringSessionSummary.idfMonitoringSessionSummary
					AND sd.blnChecked = 1
			FOR XML PATH ('')),1,2,'') as strDiagnosis
		,STUFF((SELECT ', ' +  st.name AS [text()]
			FROM    tlbMonitoringSessionSummarySample ss
			INNER JOIN fnReferenceRepair(@LangID, 19000087) st ON--standard Livestock
				ss.idfsSampleType = st.idfsReference
			WHERE ss.idfMonitoringSessionSummary = tlbMonitoringSessionSummary.idfMonitoringSessionSummary
					AND ss.blnChecked = 1
			FOR XML PATH ('')),1,2,'') as strSamples
		,CAST (0 AS bit) AS blnNewFarm
  FROM tlbMonitoringSessionSummary
INNER JOIN tlbFarm ON tlbFarm.idfFarm = tlbMonitoringSessionSummary.idfFarm
		INNER JOIN tlbHerd ON
			tlbHerd.idfFarm = tlbFarm.idfFarm
			AND tlbHerd.intRowStatus = 0
		INNER JOIN tlbSpecies ON
			tlbHerd.idfHerd = tlbSpecies.idfHerd
			AND tlbSpecies.intRowStatus = 0
		AND tlbSpecies.idfSpecies = ISNULL(tlbMonitoringSessionSummary.idfSpecies, tlbSpecies.idfSpecies)

		AND tlbFarm.intRowStatus = 0
--LEFT JOIN fnReferenceRepair(@LangID,19000007/*rftAnimalGenderList*/) Gender ON
--	Gender.idfsReference=tlbMonitoringSessionSummary.idfsAnimalSex
LEFT JOIN fnReferenceRepair(@LangID,19000086/*'rftSpeciesList'*/) Species ON
	Species.idfsReference=tlbSpecies.idfsSpeciesType

WHERE	tlbMonitoringSessionSummary.idfMonitoringSession = @idfMonitoringSession
		AND tlbMonitoringSessionSummary.intRowStatus = 0
  
 

RETURN 0

