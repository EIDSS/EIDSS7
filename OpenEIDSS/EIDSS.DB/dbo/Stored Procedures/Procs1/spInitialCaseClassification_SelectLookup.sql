

--##SUMMARY Selects data for Initial Case Classification lookup

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 07.06.2013

--##RETURNS Doesn't use

/*
Example of procedure call:

EXECUTE spInitialCaseClassification_SelectLookup 'en'

*/

CREATE  PROCEDURE spInitialCaseClassification_SelectLookup
(
	@LangID AS nvarchar(50)--##PARAM @LangID - language ID
)
AS

SELECT 
	RS.*
FROM dbo.trtCaseClassification CC
	Inner Join dbo.fnReferenceRepair(@LangID, 19000011) RS On CC.idfsCaseClassification = RS.idfsReference
WHERE    (RS.intHACode & 2)<>0
	AND CC.blnInitialHumanCaseClassification = 1
  ORDER BY
	intOrder, name


