

CREATE     Function [dbo].[fn_BasicSyndromicSurveillanceAggregate_SelectList]
(
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)
returns table 
as
return

Select
	BSA.idfAggregateHeader
	,BSA.strFormID
	,BSA.intYear
	,BSA.intWeek
	,[dbo].[fn_BasicSyndromicSurveillanceAggregate_GetHospitalNames](BSA.idfAggregateHeader, @LangID) as [strHospitals]
	,BSA.idfsSite
	,BSA.datStartDate
	,BSA.datFinishDate
	From [dbo].[tlbBasicSyndromicSurveillanceAggregateHeader] BSA
	where BSA.intRowStatus = 0
