

--##SUMMARY Selects data for Final Case Classification lookup

--##REMARKS Author: Gorodentseva
--##REMARKS Create date: 01.10.2013

--##RETURNS Doesn't use

/*
Example of procedure call:

EXECUTE spCaseClassification_SelectLookup 'en', 2, 1
EXECUTE spCaseClassification_SelectLookup 'en', 2, 0, 1
EXECUTE spCaseClassification_SelectLookup 'en', 96, 0, 1

*/

CREATE  PROCEDURE spCaseClassification_SelectLookup
(
	@LangID AS nvarchar(50),--##PARAM @LangID - language ID,
	@HACode AS INT,
	@IsInitial AS BIT=NULL,
	@IsFinal AS BIT=NULL
)
AS

SELECT 
	RS.*
FROM dbo.trtCaseClassification CC
	Inner Join dbo.fnReferenceRepair(@LangID, 19000011) RS On CC.idfsCaseClassification = RS.idfsReference
WHERE    (RS.intHACode & @HACode)<>0
	AND (@IsInitial is null or @IsInitial=0 or CC.blnInitialHumanCaseClassification = 1)
	AND (@IsFinal is null or @IsFinal=0  or CC.blnFinalHumanCaseClassification = 1)
  ORDER BY
	intOrder, name


