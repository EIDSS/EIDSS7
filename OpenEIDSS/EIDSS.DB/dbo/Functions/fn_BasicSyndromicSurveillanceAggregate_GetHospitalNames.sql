
CREATE FUNCTION [dbo].[fn_BasicSyndromicSurveillanceAggregate_GetHospitalNames]
(
	@idfAggregateHeader AS bigint--##PARAM 
	,@LangID AS nvarchar(50)--##PARAM @LangID - language ID
)
RETURNS nvarchar(1000)
AS
BEGIN
	declare @strHospitals  nvarchar(1000)

	select @strHospitals = isnull(@strHospitals + '; ','') + Organizations.[name]
	from (
	  select distinct idfHospital
	  from dbo.tlbBasicSyndromicSurveillanceAggregateDetail
	  where idfAggregateHeader = @idfAggregateHeader and intRowStatus = 0 
	  ) as BSA
	  inner join dbo.fnInstitution(@LangID) Organizations
	  on Organizations.idfOffice = BSA.idfHospital

	RETURN @strHospitals
END
