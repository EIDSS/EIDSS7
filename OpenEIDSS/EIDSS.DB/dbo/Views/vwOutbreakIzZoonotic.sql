



create view vwOutbreakIzZoonotic
as
select 
	ob.idfOutbreak,
	ob.idfsDiagnosisOrDiagnosisGroup,
	isnull(isnull(dgr.blnZoonotic, od.blnZoonotic), 0) as blnZoonotic
from tlbOutbreak ob	
	left join trtDiagnosis od
	on od.idfsDiagnosis = ob.idfsDiagnosisOrDiagnosisGroup
	and od.intRowStatus = 0
	outer apply (
		select top 1 max(cast(isnull(d.blnZoonotic ,0)as int)) as blnZoonotic
		from trtDiagnosis d
			inner join trtDiagnosisToDiagnosisGroup dg
			on dg.idfsDiagnosis = d.idfsDiagnosis
			and dg.intRowStatus = 0
		where d.intRowStatus = 0	
		and ob.idfsDiagnosisOrDiagnosisGroup = dg.idfsDiagnosisGroup
		group by dg.idfsDiagnosisGroup
	) dgr

