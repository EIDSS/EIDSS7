

--##SUMMARY Selects data for DerivativeForSampleType form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 116.09.2010

--##RETURNS Doesn't use

/*
Example of procedure call:

EXECUTE spAgeForSpecies_SelectDetail

*/

CREATE  PROCEDURE dbo.spAgeForSpecies_SelectDetail
AS
--0 DerivativeForSampleType
SELECT 
	  trtSpeciesTypeToAnimalAge.idfSpeciesTypeToAnimalAge
	  ,trtSpeciesTypeToAnimalAge.idfsSpeciesType
      ,trtSpeciesTypeToAnimalAge.idfsAnimalAge
	  ,trtBaseReference.intOrder
  FROM trtSpeciesTypeToAnimalAge
INNER JOIN trtBaseReference ON
	trtBaseReference.idfsBaseReference = trtSpeciesTypeToAnimalAge.idfsAnimalAge
	and trtBaseReference.intRowStatus = 0 
WHERE   trtSpeciesTypeToAnimalAge.intRowStatus = 0 
ORDER BY trtBaseReference.intOrder
--1 master Species Type
SELECT 
	CAST (-1 as bigint) idfsSpeciesType






