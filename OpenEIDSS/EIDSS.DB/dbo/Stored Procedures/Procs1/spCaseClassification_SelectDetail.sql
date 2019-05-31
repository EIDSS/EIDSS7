
CREATE PROCEDURE [dbo].[spCaseClassification_SelectDetail]
(
	@idfsCaseClassification bigint
	,@LangID Nvarchar(50) = Null
)
AS
Begin
	Select 
		CC.[idfsCaseClassification] 
		,CCName.strDefault as [CaseClassificationName]
		,ISNULL(CCName.name, CCName.strDefault) as [CaseClassificationNameTranslated]
		,ISNULL(CCName.intOrder, 0) As [intOrder]
		,ISNULL(CC.[blnInitialHumanCaseClassification], CAST(0 as bit)) as blnInitialHumanCaseClassification
		,ISNULL(CC.[blnFinalHumanCaseClassification], CAST(0 as bit)) as blnFinalHumanCaseClassification
		,CCName.intHACode
		, HACodes.name As [strHACode]	
	From [dbo].[trtCaseClassification] CC
	Inner Join dbo.fnReference(@LangID, 19000011) CCName On CC.[idfsCaseClassification] = CCName.idfsReference
	Left join dbo.trtHACodeList HACodeList on CCName.intHACode = HACodeList.intHACode
	Left Join dbo.fnReferenceRepair(@LangID, 19000040) HACodes On HACodeList.idfsCodeName = HACodes.idfsReference
	Where (CC.idfsCaseClassification = @idfsCaseClassification or @idfsCaseClassification = 0) and CC.intRowStatus = 0
	Order by CCName.intOrder
End
