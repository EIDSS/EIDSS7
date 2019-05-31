
  
/************************************************************  
* spASSessionTableView_SelectDetail.proc  
************************************************************/  
  
  
--##SUMMARY Selects farm/animal/sample data for samples table view of Active Surveillance Monitoring Session form  
  
--##REMARKS Author: Zurin M.  
--##REMARKS Create date: 15.12.2011  
  
--##RETURNS Doesn't use  
  
  
  
/*  
--Example of procedure call:  
DECLARE @idfMonitoringSession bigint  
SET @idfMonitoringSession=4581480000000  
EXECUTE spASSessionTableView_SelectDetail   
 @idfMonitoringSession  
 ,'en' 
*/  
  
  
  
CREATE         PROCEDURE [dbo].[spASSessionTableView_SelectDetail](  
 @idfMonitoringSession AS bigint--##PARAM @iidfMonitoringSession - AS session ID  
 ,@LangID AS nvarchar(50)--##PARAM @LangID - language ID  
)  
AS  
Select DISTINCT 
		isnull(f.idfFarm + 1,0) as id
		,s.idfMonitoringSession
		,f.idfFarm
		,f.strFarmCode
		,f.idfFarmActual
		,NULL AS idfsSpeciesType
		,NULL AS idfHerd
		,NULL AS strHerdCode
		,NULL AS idfAnimal  
		,NULL AS idfsAnimalAge
		,NULL AS idfsAnimalGender 
		,NULL AS strAnimalCode 
		,NULL AS idfSpecies
		,NULL AS strName
		,NULL AS strColor
		,NULL as strDescription
		,NULL AS idfMaterial
		,NULL AS idfsSampleType
		,NULL AS idfParty
		,NULL AS datFieldCollectionDate
		,NULL AS strFieldBarcode
		,NULL AS  strSampleName
		,NULL AS strBarcode
		,CAST (0 AS bit) AS blnNewFarm 
		,NULL AS  SpeciesName
		,CAST (0 AS bit) as Used
		,NULL as AnimalName
		,NULL AS idfSendToOffice
  FROM tlbMonitoringSession s
INNER JOIN tlbFarm f ON
	f.idfMonitoringSession = s.idfMonitoringSession AND s.idfMonitoringSession = @idfMonitoringSession 
	AND f.intRowStatus = 0
WHERE f.idfFarm not in (
				SELECT tlbFarm.idfFarm FROM tlbFarm
				INNER JOIN tlbHerd h ON
					h.idfFarm = f.idfFarm
					AND h.intRowStatus = 0
				INNER JOIN tlbSpecies sp ON
					h.idfHerd = sp.idfHerd
					AND sp.intRowStatus = 0
				INNER JOIN tlbAnimal a ON
					sp.idfSpecies=a.idfSpecies 
					and a.intRowStatus=0 

				WHERE	f.idfMonitoringSession = @idfMonitoringSession
						AND f.intRowStatus = 0)

UNION ALL

Select
		a.idfAnimal AS id
		,s.idfMonitoringSession
		,f.idfFarm
		,f.strFarmCode
		,f.idfFarmActual
		,sp.idfsSpeciesType
		,h.idfHerd
		,h.strHerdCode
		,a.idfAnimal  
		,a.idfsAnimalAge
		,a.idfsAnimalGender 
		,a.strAnimalCode 
		,a.idfSpecies
		,a.strName
		,a.strColor
		,a.strDescription
		,NULL AS idfMaterial
		,NULL AS idfsSampleType
		,NULL AS idfParty
		,NULL AS datFieldCollectionDate
		,NULL AS strFieldBarcode
		,NULL AS  strSampleName
		,NULL AS strBarcode
		,CAST (0 AS bit) AS blnNewFarm 
		,SpeciesName.name AS SpeciesName
		,CAST (0 AS bit) as Used
		,a.strAnimalCode as AnimalName
		,NULL AS idfSendToOffice
  FROM tlbMonitoringSession s
INNER JOIN tlbFarm f ON
	f.idfMonitoringSession = s.idfMonitoringSession
	AND f.intRowStatus = 0
INNER JOIN tlbHerd h ON
	h.idfFarm = f.idfFarm
	AND h.intRowStatus = 0
INNER JOIN tlbSpecies sp ON
	h.idfHerd = sp.idfHerd
	AND sp.intRowStatus = 0
INNER JOIN tlbAnimal a ON
	sp.idfSpecies=a.idfSpecies 
	and a.intRowStatus=0 
LEFT JOIN tlbMaterial Material
	on Material.idfAnimal = a.idfAnimal and Material.intRowStatus = 0
LEFT JOIN	fnReferenceRepair(@LangID,19000086) SpeciesName --rftSpeciesList
ON			SpeciesName.idfsReference=sp.idfsSpeciesType

WHERE	s.idfMonitoringSession = @idfMonitoringSession
		AND s.intRowStatus = 0
		AND Material.idfMaterial IS NULL
		
UNION ALL

Select
		Material.idfMaterial AS id
		,s.idfMonitoringSession
		,f.idfFarm
		,f.strFarmCode
		,f.idfFarmActual
		,sp.idfsSpeciesType
		,h.idfHerd
		,h.strHerdCode
		,a.idfAnimal  
		,a.idfsAnimalAge
		,a.idfsAnimalGender 
		,a.strAnimalCode 
		,a.idfSpecies
		,a.strName
		,a.strColor
		,a.strDescription
		,Material.idfMaterial
		,Material.idfsSampleType
		,Material.idfAnimal as idfParty
		,Material.datFieldCollectionDate
		,Material.strFieldBarcode
		,SampleType.name as strSampleName
		,Material.strBarcode
		,CAST (0 AS bit) AS blnNewFarm 
		,SpeciesName.name AS SpeciesName
		,CAST(Material.blnAccessioned as bit) as Used
		,a.strAnimalCode as AnimalName
		,Material.idfSendToOffice
  FROM tlbMonitoringSession s
INNER JOIN tlbFarm f ON
	f.idfMonitoringSession = s.idfMonitoringSession
	AND f.intRowStatus = 0
INNER JOIN tlbHerd h ON
	h.idfFarm = f.idfFarm
	AND h.intRowStatus = 0
INNER JOIN tlbSpecies sp ON
	h.idfHerd = sp.idfHerd
	AND sp.intRowStatus = 0
INNER JOIN tlbAnimal a ON
	sp.idfSpecies=a.idfSpecies 
	and a.intRowStatus=0 
INNER JOIN tlbMaterial Material ON
	Material.idfAnimal = a.idfAnimal and Material.intRowStatus = 0
left join	dbo.fnReferenceRepair(@LangID,19000087) SampleType
	on			SampleType.idfsReference = Material.idfsSampleType	
LEFT JOIN	fnReferenceRepair(@LangID,19000086) SpeciesName --rftSpeciesList
ON			SpeciesName.idfsReference=sp.idfsSpeciesType
WHERE	s.idfMonitoringSession = @idfMonitoringSession
		AND s.intRowStatus = 0
		AND Material.blnShowInCaseOrSession = 1
		and not (IsNull(Material.idfsSampleKind,0) = 12675420000000/*derivative*/ and (IsNull(Material.idfsSampleStatus,0) = 10015002 or IsNull(Material.idfsSampleStatus,0) = 10015008)/*deleted in lab module*/)
		


--1. Farm species
EXECUTE spASSessionTableView_SelectSpecies   @idfMonitoringSession,@LangID

--2. Farm animals
EXECUTE spASSessionTableView_SelectAnimals   @idfMonitoringSession,@LangID
  
