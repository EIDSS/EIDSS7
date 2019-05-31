

--##SUMMARY Select data for Test report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 10.12.2009

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 24.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepLimCaseTests 735060000205 , 'en' 

select * from tlbVetCase tvc
inner join tlbMaterial tm
on tm.idfVetCase = tvc.idfVetCase

inner join tlbTesting tt
on tt.idfMaterial = tm.idfMaterial

inner join tlbFarm tf
on tf.idfFarm = tvc.idfFarm
and isnull(tf.strNationalName, '') <> ''

inner join tlbHuman th
on th.idfHuman = tf.idfHuman
and isnull(th.strLastName, '') <> ''



*/

--declare @LangID as nvarchar(10)
--set @LangID = 'en'


--select 	isnull(rfVetDiagnosis.name, '') + 
--		isnull(', ' + rfVetDiagnosis1.name, '') + 
--		isnull(', ' + rfVetDiagnosis2.name, '') + 
--		isnull(', ' + rfVetDiagnosis3.name, '') as strVetDiagnoses, * 

--from tlbVetCase tvc
--left join	fnReferenceRepair(@LangID, 19000019/*'rftDiagnosis' */) as rfVetDiagnosis
--					on	rfVetDiagnosis.idfsReference = tvc.idfsTentativeDiagnosis
					
--		left join	fnReferenceRepair(@LangID, 19000019/*'rftDiagnosis' */) as rfVetDiagnosis1
--					on	rfVetDiagnosis1.idfsReference = tvc.idfsTentativeDiagnosis1
					
--		left join	fnReferenceRepair(@LangID, 19000019/*'rftDiagnosis' */) as rfVetDiagnosis2
--					on	rfVetDiagnosis2.idfsReference = tvc.idfsTentativeDiagnosis2
					
--		left join	fnReferenceRepair(@LangID, 19000019/*'rftDiagnosis' */) as rfVetDiagnosis3
--					on	rfVetDiagnosis3.idfsReference = tvc.idfsFinalDiagnosis					
					
--		left join fnReferenceRepair(@LangID, 19000011 ) VetCaseClassification 
--		on			VetCaseClassification.idfsReference = tvc.idfsCaseClassification

--where tvc.idfsTentativeDiagnosis1 is not null
--and tvc.idfVetCase = 735060000205

--select * from trtBaseReference tbr
--inner join trtDiagnosis td
--on td.idfsDiagnosis = tbr.idfsBaseReference

--where tbr.idfsBaseReference = 9843120000000

--select * from fnReferenceRepair('en', 19000019/*'rftDiagnosis' */) 
--where idfsReference = 9843120000000


create  Procedure [dbo].[spRepLimCaseTests]
    (
        @ObjID	as bigint,
        @LangID as nvarchar(10)
    )
as
	select  
		test.idfTesting				as idfTest,
		test.idfObservation			as idfTestObservation,
		test.idfsTestName			as idfsTestName,
		mat.strFieldBarcode			as strLocalSampleID,
		mat.strBarcode				as strLabSampleID,
		sType.[name]				as strSampleType,
		diag.name					as strTestDiagnosis,
		tName.[name]				as strTestName,
		batch.strBarcode			as strTestRunID,
		test.datConcludedDate		as datResultDate,
		dep.[name]					as strFunctionalArea,
		tCategory.[name]			as strTestCategory,
		tStatus.[name]				as strTestStatus,
		tResult.[name]				as strTestResult,
		thc.strCaseID				as strHumCaseId,
		CaseStatus.name				as strHumCaseStatus,
		dbo.fnConcatFullName(th.strLastName, th.strFirstName, th.strSecondName)							
									as strHumPatient,
		pdiag.name					as strHumDiagnosis,
		CaseClassification.name		as strHumCaseClassification,

		tvc.strCaseID				as strVetCaseId,
		VetCaseStatus.name			as strVetCaseStatus,
		isnull(tf.strNationalName, '') +
			case when  isnull(tf.strNationalName, '') <> '' and isnull(fown.strLastName, '') <> '' then ' / ' else '' end +
			isnull(dbo.fnConcatFullName(fown.strLastName, fown.strFirstName, fown.strSecondName), '')	as strVetFarmOwner,
			
		isnull(rfVetDiagnosis.name, '') + 
		isnull(', ' + rfVetDiagnosis1.name, '') + 
		isnull(', ' + rfVetDiagnosis2.name, '') + 
		isnull(', ' + rfVetDiagnosis3.name, '') as strVetDiagnoses,
		
		VetCaseClassification.name			as strVetCaseClassification,
		
		case when test.blnExternalTest = 1 then office.name else null end	as strExternalLaboratory,
		case when test.blnExternalTest = 1 then isnull(tp.strFamilyName + ' ', '') + 
												isnull(tp.strFirstName + ' ', '') + 
												isnull(tp.strSecondName, '') else null end	as strExternalEmployee,
		case when test.blnExternalTest = 1 then tResult.name else null end	as strExternalDataTestResultReceived
	
	from	tlbTesting as test 
	
	inner join tlbMaterial as mat
	on			mat.idfMaterial = test.idfMaterial
	and			mat.intRowStatus = 0
	
	left join	dbo.fnReferenceRepair(@LangID,19000019) diag
	on			diag.idfsReference = test.idfsDiagnosis	
	
	left join	dbo.fnReferenceRepair(@LangID,19000087) sType
	on			sType.idfsReference = mat.idfsSampleType

	inner join	dbo.fnReferenceRepair(@LangID, 19000097 ) tName --rftTestName
	on			tName.idfsReference = test.idfsTestName

	left join	tlbBatchTest batch
	on			test.idfBatchTest = batch.idfBatchTest

	left join	fnDepartment(@LangID) dep
	on			dep.idfDepartment = mat.idfInDepartment
	
	left join	fnInstitution(@LangID) office
	on			office.idfOffice = test.idfTestedByOffice
	
	left join tlbPerson tp
	on tp.idfPerson = test.idfTestedByPerson

	left join	fnReferenceRepair(@LangID, 19000095 ) tCategory --rftTestForDiseaseType
	on			tCategory.idfsReference = test.idfsTestCategory

	left join	dbo.fnReferenceRepair(@LangID, 19000001 ) tStatus --rftActivityStatus
	on			tStatus.idfsReference = test.idfsTestStatus

	left join	fnReferenceRepair(@LangID, 19000096 ) tResult --rftTestResult
	on			tResult.idfsReference = test.idfsTestResult

	left join tlbHumanCase thc
		left join fnReferenceRepair(@LangID, 19000111 ) CaseStatus 
		on			CaseStatus.idfsReference = thc.idfsCaseProgressStatus
		
		left join tlbHuman th
		on th.idfHuman = thc.idfHuman
		
		left join fnReferenceRepair(@LangID, 19000019 ) pdiag 
		on			pdiag.idfsReference = isnull(thc.idfsFinalDiagnosis, thc.idfsTentativeDiagnosis)
		
		left join fnReferenceRepair(@LangID, 19000011 ) CaseClassification 
		on			CaseClassification.idfsReference = isnull(thc.idfsFinalCaseStatus, thc.idfsInitialCaseStatus)
	on thc.idfHumanCase = mat.idfHumanCase
	
	left join tlbVetCase tvc
		left join fnReferenceRepair(@LangID, 19000111 ) VetCaseStatus 
		on			VetCaseStatus.idfsReference = tvc.idfsCaseProgressStatus
		
		left join tlbFarm tf
		on tf.idfFarm = tvc.idfFarm
		
		left join tlbHuman fown
		on fown.idfHuman = tf.idfHuman
		
		left join	fnReferenceRepair(@LangID, 19000019/*'rftDiagnosis' */) as rfVetDiagnosis
					on	rfVetDiagnosis.idfsReference = tvc.idfsTentativeDiagnosis
					
		left join	fnReferenceRepair(@LangID, 19000019/*'rftDiagnosis' */) as rfVetDiagnosis1
					on	rfVetDiagnosis1.idfsReference = tvc.idfsTentativeDiagnosis1
					
		left join	fnReferenceRepair(@LangID, 19000019/*'rftDiagnosis' */) as rfVetDiagnosis2
					on	rfVetDiagnosis2.idfsReference = tvc.idfsTentativeDiagnosis2
					
		left join	fnReferenceRepair(@LangID, 19000019/*'rftDiagnosis' */) as rfVetDiagnosis3
					on	rfVetDiagnosis3.idfsReference = tvc.idfsFinalDiagnosis					
					
		left join fnReferenceRepair(@LangID, 19000011 ) VetCaseClassification 
		on			VetCaseClassification.idfsReference = tvc.idfsCaseClassification
	
	on tvc.idfVetCase = mat.idfVetCase

	where	
	test.intRowStatus = 0	and 
	(
		mat.idfHumanCase = @ObjID or 
		mat.idfVetCase = @ObjID or		
		mat.idfMonitoringSession = @ObjID
	)
		   
			

