

/*
select * from fnAnimalNameList('en')
*/

--##SUMMARY Returns the list of species names and possibly associated animals.

--##REMARKS Author: Grigoreva
--##REMARKS Create date: 16.01.2012

CREATE FUNCTION [dbo].[fnAnimalNameList]
(	
	@LangID nvarchar(20)
)
RETURNS TABLE 
AS
RETURN 

SELECT		
	idfAnimal AS idfParty,
	tlbAnimal.strAnimalCode as AnimalName

FROM tlbAnimal
WHERE		tlbAnimal.intRowStatus = 0

UNION ALL

SELECT		
	tlbSpecies.idfSpecies AS idfParty,
	SpeciesName.name as AnimalName
FROM tlbSpecies
LEFT JOIN	fnReferenceRepair(@LangID,19000086) SpeciesName --rftSpeciesList
ON			SpeciesName.idfsReference=tlbSpecies.idfsSpeciesType

WHERE tlbSpecies.intRowStatus = 0
	
UNION ALL

SELECT		
	idfVector AS idfParty,
	VectorType.name	as AnimalName

FROM tlbVector
JOIN		dbo.fnReference(@LangID,19000140) VectorType
ON			VectorType.idfsReference = tlbVector.idfsVectorType
	
WHERE		tlbVector.intRowStatus = 0	


