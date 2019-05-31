


CREATE        PROCEDURE [dbo].[spStreet_SelectLookup]
	@idfsSettlement as bigint = NULL 
AS
SELECT	
	idfStreet,
	strStreetName,
	idfsSettlement, 
	intRowStatus
FROM	tlbStreet
WHERE	idfsSettlement = isnull(@idfsSettlement, idfsSettlement)



