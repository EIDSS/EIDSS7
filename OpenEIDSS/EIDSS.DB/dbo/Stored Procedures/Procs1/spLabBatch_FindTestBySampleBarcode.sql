
--##SUMMARY Returns list of all tests ready for including to batch for sample with give  barcode.
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 16.01.2012

--##REMARKS UPDATED BY: Grigoreva E.
--##REMARKS Date: 08.01.2012

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 21.06.2013

-- exec spLabBatch_FindTestBySampleBarcode 1, '111', 'en'



CREATE PROCEDURE [dbo].[spLabBatch_FindTestBySampleBarcode]
	@idfsTestName bigint 
	,@strSampleBarcode nvarchar(200)
	,@LangID nvarchar(50)
AS

--list of available tests
--if no records is found,  no sample with such barcode exists
--if record count = 1 and idfTesting = -1, no tests of given type exist, we should add new test in this case


select
		ISNULL(Tests.idfTesting,-1) as idfTesting,
		--Tests.idfBatchTest,
		Tests.intTestNumber,
		Tests.idfsTestResult,
		Tests.idfsTestStatus,
		Tests.idfObservation,
		TestType.name as strTestName,
		@idfsTestName as idfsTestName,
		cast(0 as bigint) as idfsTemplate,
		Material.strBarcode,
		Tests.idfsDiagnosis,
		sampleType.name as strSampleName,
		ISNULL(Material.idfHumanCase, Material.idfVetCase) AS idfCase,
		Material.idfHumanCase, 
		Material.idfVetCase,
		Material.idfMonitoringSession,
		Material.idfVectorSurveillanceSession,
		Tests.idfsTestCategory,
		tlbObservation.idfsFormTemplate,
		Tests.idfResultEnteredByPerson,
		Material.datAccession,
		dbo.fnIsSampleTransferred(Tests.idfMaterial) as blnSampleTransferred, 
		CASE WHEN Tests.idfMaterial IS NULL THEN Material.idfMaterial ELSE 0 END as idfMaterial
from	tlbMaterial as Material 
left join	dbo.fnReferenceRepair(@LangID,19000087) sampleType
	on			sampleType.idfsReference = Material.idfsSampleType

left join tlbTesting as Tests 
      inner join	dbo.fnReferenceRepair(@LangID, 19000097 ) TestType --rftTestName
      on			TestType.idfsReference = Tests.idfsTestName
      left join	tlbObservation
      on			tlbObservation.idfObservation = Tests.idfObservation

	on Material.idfMaterial = Tests.idfMaterial 
	and Tests.idfBatchTest is null
	and Tests.blnNonLaboratoryTest<>1
	and Tests.blnReadOnly<>1
	and Tests.idfsTestName = @idfsTestName
	and not Tests.idfsTestStatus in(10001001,10001003,10001006)/*Completed, In Progress,Ammended*/
	and IsNull(Tests.blnExternalTest, 0) <> 1
	and Tests.intRowStatus=0
	
	
where	
	Material.strBarcode = @strSampleBarcode
	and Material.idfsSite = dbo.fnSiteID()
	and Material.intRowStatus = 0




--list of available diagnosis
SELECT idfsFinalDiagnosis as idfsDiagnosis FROM tlbVetCase 
INNER JOIN tlbMaterial Material  
	ON Material.idfVetCase = tlbVetCase.idfVetCase
	and Material.intRowStatus=0
where
	(Material.strFieldBarcode=@strSampleBarcode or Material.strBarcode=@strSampleBarcode)
	and not idfsFinalDiagnosis is null
union
SELECT idfsTentativeDiagnosis as idfsDiagnosis FROM tlbVetCase 
INNER JOIN tlbMaterial as Material  
	ON Material.idfVetCase = tlbVetCase.idfVetCase
	and Material.intRowStatus=0
where
	(Material.strFieldBarcode=@strSampleBarcode or Material.strBarcode=@strSampleBarcode)
	and not idfsTentativeDiagnosis is null
union
SELECT idfsTentativeDiagnosis1 as idfsDiagnosis FROM tlbVetCase 
INNER JOIN tlbMaterial as Material  
  ON Material.idfVetCase = tlbVetCase.idfVetCase
	and Material.intRowStatus=0
where
	(Material.strFieldBarcode=@strSampleBarcode or Material.strBarcode=@strSampleBarcode)
	and not idfsTentativeDiagnosis1 is null
union
SELECT idfsTentativeDiagnosis2 as idfsDiagnosis FROM tlbVetCase 
INNER JOIN tlbMaterial as Material  
	 ON Material.idfVetCase = tlbVetCase.idfVetCase
	and Material.intRowStatus=0
where
	(Material.strFieldBarcode=@strSampleBarcode or Material.strBarcode=@strSampleBarcode)
	and not idfsTentativeDiagnosis2 is null
union
SELECT tlbHumanCase.idfsFinalDiagnosis as idfsDiagnosis FROM tlbHumanCase
INNER JOIN tlbMaterial as Material 
	 ON Material.idfHumanCase = tlbHumanCase.idfHumanCase
	and Material.intRowStatus=0
where
	(Material.strFieldBarcode=@strSampleBarcode or Material.strBarcode=@strSampleBarcode)
	and not idfsFinalDiagnosis is NULL
union
SELECT tlbHumanCase.idfsTentativeDiagnosis as idfsDiagnosis FROM tlbHumanCase
INNER JOIN tlbMaterial as Material  
	 ON Material.idfHumanCase = tlbHumanCase.idfHumanCase
	and Material.intRowStatus=0
where
	(Material.strFieldBarcode=@strSampleBarcode or Material.strBarcode=@strSampleBarcode)
	and not idfsTentativeDiagnosis is null
union
SELECT DISTINCT idfsDiagnosis FROM tlbMonitoringSessionToDiagnosis
INNER JOIN tlbMaterial as Material  
	 ON Material.idfMonitoringSession = tlbMonitoringSessionToDiagnosis.idfMonitoringSession
	and Material.intRowStatus=0
WHERE
	(Material.strFieldBarcode=@strSampleBarcode or Material.strBarcode=@strSampleBarcode)
	and tlbMonitoringSessionToDiagnosis.intRowStatus = 0

--Select current default diagnosis for test
SELECT ISNULL(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis) as idfsDiagnosis FROM tlbHumanCase
INNER JOIN tlbMaterial as Material  
	ON Material.idfHumanCase = tlbHumanCase.idfHumanCase
	and Material.intRowStatus=0
where
	(Material.strFieldBarcode=@strSampleBarcode or Material.strBarcode=@strSampleBarcode)
	and COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis, -1) <> -1
union
SELECT tlbVetCase.idfsShowDiagnosis as idfsDiagnosis FROM tlbVetCase
INNER JOIN tlbMaterial as Material  
	 ON Material.idfVetCase = tlbVetCase.idfVetCase
	and Material.intRowStatus=0
where
	(Material.strFieldBarcode=@strSampleBarcode or Material.strBarcode=@strSampleBarcode)
	and not idfsShowDiagnosis is null

RETURN 0
