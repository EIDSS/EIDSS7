
create   PROCEDURE dbo.spSmphAnimalAge_SelectLookup
AS
select idfsBaseReference as id, idfsReferenceType as tp, intHACode as ha, strDefault as df, trtBaseReference.intRowStatus as rs, isnull(intOrder,0) as rd,
	trtSpeciesTypeToAnimalAge.idfsSpeciesType as f1
from trtBaseReference 
INNER JOIN trtSpeciesTypeToAnimalAge ON 
	trtSpeciesTypeToAnimalAge.idfsAnimalAge = trtBaseReference.idfsBaseReference
where idfsReferenceType = 19000005 -- BaseReferenceType.rftAnimalAgeList

