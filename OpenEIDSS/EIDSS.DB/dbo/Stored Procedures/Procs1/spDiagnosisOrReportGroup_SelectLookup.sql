
CREATE  PROCEDURE spDiagnosisOrReportGroup_SelectLookup
(
	@LangID AS nvarchar(50)--##PARAM @LangID - language ID,	
)
AS

Select	idfsReference, [name], 0 as [intRowStatus] from dbo.fnReference(@LangID, 19000076) 
where idfsReference in (19000019, 19000130)


