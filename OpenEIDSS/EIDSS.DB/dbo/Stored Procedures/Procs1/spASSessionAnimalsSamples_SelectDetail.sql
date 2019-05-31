

--##SUMMARY Selects list of animals and its samples related with specific monitoring session.

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
DECLARE @ID BIGINT 
SET @ID = 1
exec spASSessionAnimalsSamples_SelectDetail @ID
*/

CREATE PROC	[dbo].[spASSessionAnimalsSamples_SelectDetail]
		@idfMonitoringSession	BIGINT  --##PARAM @idfMonitoringSession -  ID of monitoring session for wich the animals are listed
		,@LangID		NVARCHAR(50)  --##PARAM @LangID - language ID
AS
-- 0 Animal
SELECT
	ISNULL(tlbMaterial.idfMaterial, tlbAnimal.idfAnimal) as id,
	tlbAnimal.idfAnimal,  
	tlbAnimal.idfsAnimalAge,
	tlbAnimal.idfsAnimalGender, 
	tlbAnimal.idfSpecies,
	tlbAnimal.strName,
	tlbAnimal.strColor,
	tlbAnimal.strDescription,
	tlbSpecies.idfsSpeciesType,  
	tlbFarm.idfMonitoringSession,
	tlbFarm.strFarmCode,
	tlbFarm.idfFarm,

	tlbMaterial.idfMaterial,
	tlbMaterial.idfsSampleType,		   
	tlbMaterial.strFieldBarcode,  
	tlbMaterial.datFieldCollectionDate,
	tlbMaterial.datFieldSentDate,
	tlbMaterial.datAccession,
	isnull(CAST((select COUNT(*) from tlbMaterial m where m.idfAnimal = tlbAnimal.idfAnimal
		and m.blnShowInCaseOrSession = 1 
		and m.blnAccessioned = 1
		and m.intRowStatus = 0) as bit),0) as bSampleAccessioned,
	isnull(CAST(tlbMaterial.blnAccessioned as bit),0) as Used,
	tlbMaterial.idfSendToOffice,
	OfficeSendTo.[name] as strSendToOffice,
	
	tlbAnimal.strAnimalCode,
	
	convert(uniqueidentifier, null) as uidOfflineCaseID
	

FROM tlbAnimal
INNER JOIN tlbSpecies ON 
	tlbSpecies.idfSpecies=tlbAnimal.idfSpecies 
	and tlbSpecies.intRowStatus=0 
inner join tlbHerd on
  tlbHerd.idfHerd = tlbSpecies.idfHerd
  and tlbHerd.intRowStatus = 0
inner join tlbFarm on
  tlbFarm.idfFarm = tlbHerd.idfFarm
  and tlbFarm.intRowStatus = 0
left outer join tlbVetCase     
  on tlbVetCase.idfFarm = tlbFarm.idfFarm
	AND tlbVetCase.intRowStatus = 0

left outer join tlbMaterial
  on	tlbMaterial.idfAnimal = tlbAnimal.idfAnimal
		and tlbMaterial.blnShowInCaseOrSession = 1 
		and not (IsNull(tlbMaterial.idfsSampleKind,0) = 12675420000000/*derivative*/ and (IsNull(tlbMaterial.idfsSampleStatus,0) = 10015002 or IsNull(tlbMaterial.idfsSampleStatus,0) = 10015008)/*deleted in lab module*/)
		and tlbMaterial.intRowStatus = 0
left join	dbo.fnInstitution(@LangID) as OfficeSendTo
on			OfficeSendTo.idfOffice = tlbMaterial.idfSendToOffice

WHERE	tlbFarm.idfMonitoringSession=@idfMonitoringSession 
		and tlbVetCase.idfVetCase IS NULL
		and NOT @idfMonitoringSession IS NULL
		and tlbAnimal.intRowStatus = 0





