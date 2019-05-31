

-- renamed to usp_Street_GetLookup from spStreet_SelectLookup by MCW 


CREATE        PROCEDURE [dbo].[usp_Street_GetLookup]
	@idfsSettlement as bigint = NULL 
AS

SELECT	
	idfStreet,
	strStreetName,
	idfsSettlement, 
	intRowStatus

FROM	tlbStreet

WHERE	idfsSettlement = isnull(@idfsSettlement, idfsSettlement)





