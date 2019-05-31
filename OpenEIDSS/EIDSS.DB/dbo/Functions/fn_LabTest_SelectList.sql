



-- select * from fn_LabTest_SelectList('en')


create function [dbo].[fn_LabTest_SelectList](@LangID as nvarchar(50))
returns table
as
return

select		
				idfTesting,
				idfsTestName,
				idfsTestStatus,
				idfObservation,
				TestName,
				TestResult,
				TestCategory,
				idfsTestCategory, --required for batch initialization
				idfBatchTest,
				BatchTestCode,
				datConcludedDate,
				datPerformedDate,
				--blnVisible,
				[Status],


				strBarcode,
				strSampleName,
				idfCase,
				--the fields below are needed for test events generation from batch
				--when we select test to batch, we should know to which owber it belongs
				idfHumanCase, 
				idfVetCase,
				idfMonitoringSession,
				idfVectorSurveillanceSession,
				--
				idfsCaseType,
				CaseID,
				DiagnosisName,
				idfsDiagnosis,
				idfsSampleType,
				DepartmentName,
				datFieldCollectionDate,
				datAccession, --required for batch form
				strFieldBarcode,
				HumanName,
				AnimalName,

				idfsBatchStatus,
				idfsTestResult,
				strPatientName,
				strFarmOwner 
FROM dbo.fnTestListOptimized(@LangID)  




