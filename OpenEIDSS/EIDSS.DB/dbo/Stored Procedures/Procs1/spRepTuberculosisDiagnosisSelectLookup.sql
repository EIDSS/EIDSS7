

--##SUMMARY This procedure 

--##REMARKS Author: 
--##REMARKS Create date:  

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec [spRepTuberculosisDiagnosisSelectLookup] 'en'

*/ 
 
create procedure [dbo].[spRepTuberculosisDiagnosisSelectLookup]
	@LangID			as varchar(36)
AS
begin
	select distinct
		r.idfsReference, 
		r.[name] as strName,
		r.intOrder  

	from		fnReferenceRepair(@LangID, 19000019) r
		inner join trtDiagnosis d
			inner join dbo.trtDiagnosisToGroupForReportType dgrt
			on dgrt.idfsDiagnosis = d.idfsDiagnosis
			and dgrt.idfsCustomReportType = 10290041 --Report on Tuberculosis cases tested for HIV

			inner join dbo.trtReportDiagnosisGroup dg
			on dgrt.idfsReportDiagnosisGroup = dg.idfsReportDiagnosisGroup
			and dg.intRowStatus = 0 and dg.strDiagnosisGroupAlias = 'DG_Tuberculosis'
		on  r.idfsReference = d.idfsDiagnosis
			and d.intRowStatus = 0
	order by	r.[name], r.idfsReference

end

