
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 24.04.2013

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 21.06.2013

-- exec [dbo].[spLabBatch_SelectDetail] 0, 'en'

create proc [dbo].[spLabBatch_SelectDetail]
				@idfBatchTest bigint,
				@LangID varchar(10)
as 

select 
	tlbBatchTest.idfBatchTest,
	tlbBatchTest.strBarcode,	
	tlbBatchTest.idfsBatchStatus,
	tlbBatchTest.idfsTestName,
	TestName = TestType.name,
	tlbBatchTest.datPerformedDate,
	tlbBatchTest.datValidatedDate,
	tlbBatchTest.idfPerformedByOffice,
	tlbBatchTest.idfPerformedByPerson,
	tlbBatchTest.idfValidatedByOffice,
	tlbBatchTest.idfValidatedByPerson,
	tlbBatchTest.idfResultEnteredByOffice,
	tlbBatchTest.idfResultEnteredByPerson,
	tlbBatchTest.idfObservation,
	tlbObservation.idfsFormTemplate,
	tlbBatchTest.datModificationForArchiveDate

from		tlbBatchTest 
left join	tlbObservation
on			tlbBatchTest.idfObservation=tlbObservation.idfObservation
left join	fnReference(@LangID, 19000097) TestType
					on TestType.idfsReference = tlbBatchTest.idfsTestName
where tlbBatchTest.idfBatchTest=@idfBatchTest


select
		Tests.idfTesting,
		Tests.intTestNumber,--
		Tests.idfsTestResult,
		Tests.idfObservation,
		TestType.name as strTestName,
		Tests.idfsTestName,
		cast(0 as bigint) as idfsTemplate,
		Material.strBarcode,--
		Tests.idfsDiagnosis,--
		SpecimenType.name as strSampleName,--
		ISNULL(Material.idfHumanCase, Material.idfVetCase) AS idfCase,
		Material.idfHumanCase, 
		Material.idfVetCase,
		Material.idfMonitoringSession,
		Material.idfVectorSurveillanceSession,
		Tests.idfsTestCategory,--
		tlbObservation.idfsFormTemplate,
		Tests.idfResultEnteredByPerson,
		Material.datAccession,
		dbo.fnIsSampleTransferred(Tests.idfMaterial) as blnSampleTransferred, 
		cast(0 as bigint) as idfMaterial -- dummy field. will be not empty when new test is created from batch form
from	tlbTesting as Tests 
  inner join tlbMaterial as Material
  on Material.idfMaterial = Tests.idfMaterial
  and Material.intRowStatus = 0
  
  inner join	dbo.fnReferenceRepair(@LangID, 19000097 ) as TestType --rftTestName
  on			TestType.idfsReference = Tests.idfsTestName
  
  left join	dbo.fnReferenceRepair(@LangID,19000087) as SpecimenType
  on			SpecimenType.idfsReference = Material.idfsSampleType
  
  left join	tlbObservation
  on			tlbObservation.idfObservation = Tests.idfObservation
  
where	Tests.idfBatchTest=@idfBatchTest
and Tests.intRowStatus = 0


