--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/20/2017
-- Last modified by:		Joan Li
-- Description:				06/20/2017: Created based on V6 spFinalCaseClassification_SelectLookup :  V7 USP72
--                          Get look up data from tables:trtCaseClassification
/*
----testing code:
EXECUTE spFinalCaseClassification_SelectLookup 'en'
----related fact data from
select * from trtCaseClassification
*/
--=====================================================================================================

CREATE  PROCEDURE [dbo].[usp_FinalCaseClassification_GetLookup]
(
	@LangID AS nvarchar(50)--##PARAM @LangID - language ID
)
AS

	SELECT 
		RS.*
	FROM dbo.trtCaseClassification CC
		Inner Join dbo.fnReferenceRepair(@LangID, 19000011) RS On CC.idfsCaseClassification = RS.idfsReference
	WHERE    (RS.intHACode & 2)<>0
		AND CC.blnFinalHumanCaseClassification = 1
	  ORDER BY
		intOrder, name

