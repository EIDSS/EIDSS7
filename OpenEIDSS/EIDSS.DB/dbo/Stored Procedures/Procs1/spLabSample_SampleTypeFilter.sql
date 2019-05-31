


--##REMARKS Date: 27.10.2011
--##REMARKS Updated: 08.11.2011

/*
exec spLabSample_SampleTypeFilter 4609070000000
*/

CREATE PROCEDURE [dbo].[spLabSample_SampleTypeFilter]( 
	@idfCase AS nvarchar(30),
	@idfsSpeciesType as bigint
)
AS

BEGIN 
SET NOCOUNT ON;

select distinct  idfsSampleType from trtMaterialForDisease m
inner join dbo.fnCase_DiagnosisList(@idfCase, N'en') d
on d.idfsDiagnosis =  m.idfsDiagnosis
and m.intRowStatus = 0
where ISNULL(@idfsSpeciesType,0) = 0 or d.idfsSpeciesType = 0 or d.idfsSpeciesType = @idfsSpeciesType 



END
