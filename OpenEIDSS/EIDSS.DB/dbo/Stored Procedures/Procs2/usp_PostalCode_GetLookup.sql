


-- renamed spPostalCode_SelectLookup to usp_PostalCode_GetLookup by MCW

CREATE PROCEDURE [dbo].[usp_PostalCode_GetLookup]
	@SettlementID as bigint = NULL 
AS

SELECT 
	idfPostalCode,
	strPostCode, 
	idfsSettlement, 
	intRowStatus

FROM	tlbPostalCode

WHERE	idfsSettlement = isnull(@SettlementID, idfsSettlement)




