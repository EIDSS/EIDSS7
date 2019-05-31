
CREATE PROCEDURE [dbo].[spCDCAgeGroup_SelectLookup]
	@LangID As nvarchar(50)
AS
select 
	ag.idfsDiagnosisAgeGroup as idfsReference,
	isnull(snt_ag.strTextString, br_ag.strDefault) as [name],
	br_ag.strDefault,
	br_ag.intHACode,
	br_ag.intOrder,
	br_ag.strBaseReferenceCode
from trtDiagnosisAgeGroup ag
inner join trtBaseReference br_ag
	on br_ag.idfsBaseReference = ag.idfsDiagnosisAgeGroup
	and br_ag.intRowStatus = 0
left join trtStringNameTranslation snt_ag
	on snt_ag.idfsBaseReference = br_ag.idfsBaseReference
	and snt_ag.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
where br_ag.blnSystem = 1
	and br_ag.strBaseReferenceCode like N'%CDCAgeGroup%'
	and br_ag.intRowStatus = 0

RETURN 0

