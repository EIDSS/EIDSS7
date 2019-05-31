

CREATE FUNCTION [dbo].[fn_AVR_BasicSyndromicSurveillanceAggregateReport]
(
@LangID	as nvarchar(50)
)
returns table
as
return
select		
v.[sflBssAForm_FormID], 
			v.[sflBssAForm_DateEntered], 
			v.[sflBssAForm_DateLastSaved], 
			v.[sflBssAForm_EnteredBy], 
			v.[sflBssAForm_Site_ID], 
			[ref_sflBssAForm_Site].[name] as [sflBssAForm_Site], 
			v.[sflBssAForm_WeekStartDate], 
			v.[sflBssAForm_WeekEndDate], 
			v.[sflBssAForm_WeekDateForGrouping], 
			v.[sflBssAValues_NameOfHospital_ID], 
			[ref_sflBssAValues_NameOfHospital].[name] as [sflBssAValues_NameOfHospital], 
			v.[sflBssAValues_ColumnName_ID], 
			[ref_sflBssAValues_ColumnName].[name] as [sflBssAValues_ColumnName], 
			v.[sflBssAValues_Value] 
from		vw_AVR_BasicSyndromicSurveillanceAggregateReport v

left join	fnReferenceRepair(@LangID, 19000045) [ref_sflBssAForm_Site] 
on			[ref_sflBssAForm_Site].idfsReference = v.[sflBssAForm_Site_ID] 
left join	fnReferenceRepair(@LangID, 19000045) [ref_sflBssAValues_NameOfHospital] 
on			[ref_sflBssAValues_NameOfHospital].idfsReference = v.[sflBssAValues_NameOfHospital_ID] 
left join	fnReferenceRepair(@LangID, 19000163) [ref_sflBssAValues_ColumnName] 
on			[ref_sflBssAValues_ColumnName].idfsReference = v.[sflBssAValues_ColumnName_ID] 



--Not needed--left join	fnReference(@LangID, 19000044) ref_None	-- Information String
--Not needed--on			ref_None.idfsReference = 0		-- Workaround. We dont need (none) anymore

 


