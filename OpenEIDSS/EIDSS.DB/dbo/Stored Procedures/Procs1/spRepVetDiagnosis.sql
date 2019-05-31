

--##SUMMARY Select data for Diagnosis details for Vet report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 22.12.2009

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 23.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepVetDiagnosis 7395140000871 , 'en' 

*/ 

--select *from tlbVetCase where strCaseID = 'VBA000140001'

create  Procedure [dbo].[spRepVetDiagnosis]
    (
        @ObjID	as bigint,
        @LangID as nvarchar(10)
    )
as

	select		rfDiagnosis0.[name]		as strTentativeDiagnosis,
				rfDiagnosis1.[name]		as strTentativeDiagnosis1,
				rfDiagnosis2.[name]		as strTentativeDiagnosis2,
				rfDiagnosisf.[name]		as strFinalDiagnosis,
				tVetCase.datTentativeDiagnosisDate,
				tVetCase.datTentativeDiagnosis1Date,
				tVetCase.datTentativeDiagnosis2Date,
				tVetCase.datFinalDiagnosisDate,
				diagnosis0.strOIECode		as strTentativeDiagnosisCode,
				diagnosis1.strOIECode		as strTentativeDiagnosis1Code,
				diagnosis2.strOIECode		as strTentativeDiagnosis2Code,
				diagnosisf.strOIECode		as strFinalDiagnosisCode
	
	from		dbo.tlbVetCase	as tVetCase
	-- Get Diagnosis
	 left join	fnReferenceRepair(@LangID, 19000019 /*'rftDiagnosis' */)		as rfDiagnosis0
			on	rfDiagnosis0.idfsReference = tVetCase.idfsTentativeDiagnosis
	 left join  trtDiagnosis		as diagnosis0
			on	diagnosis0.idfsDiagnosis = tVetCase.idfsTentativeDiagnosis
	 left join	fnReferenceRepair(@LangID, 19000019 /*'rftDiagnosis' */)		as rfDiagnosis1
			on	rfDiagnosis1.idfsReference = tVetCase.idfsTentativeDiagnosis1	
	 left join  trtDiagnosis		as diagnosis1
			on	diagnosis1.idfsDiagnosis = tVetCase.idfsTentativeDiagnosis1
	 left join	fnReferenceRepair(@LangID, 19000019 /*'rftDiagnosis' */)		as rfDiagnosis2
			on	rfDiagnosis2.idfsReference = tVetCase.idfsTentativeDiagnosis2
	 left join  trtDiagnosis		as diagnosis2
			on	diagnosis2.idfsDiagnosis = tVetCase.idfsTentativeDiagnosis2
	 left join	fnReferenceRepair(@LangID, 19000019 /*'rftDiagnosis' */)		as rfDiagnosisf
			on	rfDiagnosisf.idfsReference = tVetCase.idfsFinalDiagnosis
	 left join  trtDiagnosis		as diagnosisf
			on	diagnosisf.idfsDiagnosis = tVetCase.idfsFinalDiagnosis
			
	where  tVetCase.idfVetCase = @ObjID
		and  tVetCase.intRowStatus = 0
			
			

