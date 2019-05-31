
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

CREATE FUNCTION [dbo].[fnCase_DiagnosisList]
(
	@idfCase bigint,
	@LangID nvarchar(20)
)
RETURNS TABLE 
AS

return
	select	distinct	Diagnoses.*,
				Names.name
	from
	(
		select		idfHumanCase as idfCase,ISNULL(idfsFinalDiagnosis, idfsTentativeDiagnosis) as idfsDiagnosis, cast(0 as bigint) as idfsSpeciesType
		from		tlbHumanCase
		where		idfHumanCase=@idfCase and (COALESCE(idfsFinalDiagnosis, idfsTentativeDiagnosis, -1) <> -1)
		union
		select		idfVetCase,idfsFinalDiagnosis, cast(0 as bigint) as idfsSpeciesType
		from		tlbVetCase		
		where		idfVetCase=@idfCase and (idfsFinalDiagnosis is not null)
		union
		select		idfVetCase,idfsTentativeDiagnosis, cast(0 as bigint) as idfsSpeciesType
		from		tlbVetCase
		where		idfVetCase=@idfCase and (idfsTentativeDiagnosis is not null)
		union
		select		idfVetCase,idfsTentativeDiagnosis1, cast(0 as bigint) as idfsSpeciesType
		from		tlbVetCase
		where		idfVetCase=@idfCase and (idfsTentativeDiagnosis1 is not null)
		union
		select		idfVetCase,idfsTentativeDiagnosis2, cast(0 as bigint) as idfsSpeciesType
		from		tlbVetCase
		where		idfVetCase=@idfCase and (idfsTentativeDiagnosis2 is not null)
		union
		select		idfMonitoringSession,idfsDiagnosis, cast (ISNULL(idfsSpeciesType, 0) as bigint)  as idfsSpeciesType
		from		tlbMonitoringSessionToDiagnosis
		where		idfMonitoringSession=@idfCase and (idfsDiagnosis is not null) and intRowStatus=0
		union		
		select		0,idfsReference, cast(0 as bigint) as idfsSpeciesType
		from		fnReference(@LangID,19000019) 
		where		(intHACode & 128)>0 and @idfCase = 0
	)Diagnoses
	left join	fnReference(@LangID,19000019) Names
	on			Names.idfsReference=Diagnoses.idfsDiagnosis

