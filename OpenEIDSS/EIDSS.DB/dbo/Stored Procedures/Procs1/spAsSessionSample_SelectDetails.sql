


-- exec [dbo].[spAsSessionSample_SelectDetails] 0, 'en'

CREATE PROCEDURE [dbo].[spAsSessionSample_SelectDetails]
@idfMonitoringSession bigint,
@LangID varchar(50)
AS
SELECT 
	Material.idfMaterial,
	Material.idfsSampleType,		   
	Material.strFieldBarcode,  
	Material.idfMonitoringSession,
	Material.datFieldCollectionDate,
	Material.datFieldSentDate,
	Material.datAccession,
	Animal.strFarmCode,
	Animal.idfsSpeciesType,
	Animal.strAnimalCode,
	Material.blnAccessioned as Used
FROM 	tlbMaterial as Material
	left join	fnAnimalList(@LangID) Animal
	on			Material.idfAnimal = Animal.idfParty
Where   
        Material.blnShowInCaseOrSession =1
		and	Material.idfMonitoringSession = @idfMonitoringSession

