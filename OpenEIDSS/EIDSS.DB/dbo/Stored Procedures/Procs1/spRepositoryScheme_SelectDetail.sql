

CREATE     PROCEDURE dbo.spRepositoryScheme_SelectDetail 
	@idfFreezer AS bigint
AS

SELECT	tlbFreezer.idfFreezer,
		--tlbFreezer.idfsPlacementID, 
		tlbFreezer.strFreezerName, 
		--tlbFreezer.intMaximumChildNumber, 
		tlbFreezer.strNote, 
		--tlbFreezer.intNormalTemperature, 
		--tlbFreezer.intPossibleTemperatureDeviation, 
		tlbFreezer.strBarcode, 
		--tlbFreezer.idfsSite, 
		--tlbFreezer.idfsSubdivisionType, 
--		tlbFreezer.idfUserID, 
		tlbFreezer.idfsStorageType/*,

--	@LangID instead of "en"	--

		dbo.fn_RepositoryGetPlacement('en', tlbFreezer.idfsPlacementID) as fullPath*/
--		ST.[name]	
FROM		tlbFreezer
--			fnReference('en', 'rftStorageType') AS ST 
WHERE	idfFreezer = @idfFreezer
and	tlbFreezer.intRowStatus = 0
--	AND ST.idfsReference = tlbFreezer.idfsStorageType

SELECT	idfSubdivision, 
		strNameChars, 
		idfFreezer, 
		--intChildMaximumNumber, 
		strNote, 
		strBarcode, 
		--blnMovable, 
		--idfsSite, 
		--idfsLabLocationStatus, 
		idfsSubdivisionType, 
--		idfUserID, 
		idfParentSubdivision,
		intCapacity/*,
		idfsChild_SubdivisionType*/
FROM		tlbFreezerSubdivision
WHERE		idfFreezer = @idfFreezer
and		tlbFreezerSubdivision.intRowStatus = 0
order by strNameChars




