

-- select * from dbo.fnTestListOptimized('en') 
-- select * from dbo.fn_SampleLogBook_SelectList('en') 

create           function [dbo].[fn_SampleLogBook_SelectList](@LangID as nvarchar(50))
returns table
as
return
select		
				isnull(tst.idfTesting, smp.idfMaterial) as ID,
				tst.idfTesting,
				smp.idfMaterial,
				smp.idfsSampleStatus,

				isnull(tst.idfsDiagnosis, smp.idfsShowDiagnosis) as idfsDiagnosis,
				smp.idfsTentativeDiagnosis,
				smp.idfsTentativeDiagnosis1,
				smp.idfsTentativeDiagnosis2,
				smp.idfsFinalDiagnosis,
				nullif(isnull(tst.idfsSampleType, smp.idfsSampleType),0) as idfsSampleType,
				tst.idfsTestName,
				tst.idfsTestCategory,
				tst.idfsTestStatus,
				tst.idfsTestResult,

				isnull(tst.strBarcode, smp.strBarcode) as strBarcode,
				isnull(tst.strFieldBarcode, smp.strFieldBarcode) as strFieldBarcode,
				isnull(tst.strSampleName, smp.strSampleName) as strSampleName,
				isnull(tst.datFieldCollectionDate, smp.datFieldCollectionDate) as datFieldCollectionDate,
				isnull(tst.CaseID, smp.CaseID) as CaseID,
				isnull(tst.DiagnosisName, smp.DiagnosisName) as DiagnosisName,
				tst.TestName,
				tst.TestCategory,
				tst.[Status],
				tst.TestResult,
				tst.datStartedDate,
				tst.datConcludedDate,
				smp.idfCase,
				smp.idfMonitoringSession,
				smp.idfVectorSurveillanceSession,
				smp.idfsAccessionCondition,
				smp.idfsSpeciesType,
				smp.datAccession,
				act.[name] as strSampleConditionReceivedStatus

FROM dbo.fnSampleListOptimized(@LangID) smp
	left outer join dbo.fnTestListOptimized(@LangID) tst
	on tst.idfMaterial = smp.idfMaterial
	left join	fnReference(@LangID, 19000110)	act	-- Accession Condition
	on			act.idfsReference = smp.idfsAccessionCondition
WHERE 
		smp.idfsSampleStatus <> 10015008 --Deleted EFR5336, we sgould not display the samples in Deleted status without tests
		OR NOT tst.idfTesting IS NULL

	




