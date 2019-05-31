


CREATE       PROCEDURE [dbo].[spPostalCode_SelectLookup]
	@SettlementID as bigint = NULL 
AS
SELECT 
	idfPostalCode,
	strPostCode, 
	idfsSettlement, 
	intRowStatus
FROM	tlbPostalCode
WHERE	idfsSettlement = isnull(@SettlementID, idfsSettlement)



