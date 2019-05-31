

--##SUMMARY Select Speciemen data for Human report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 21.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 24.04.2013

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 21.06.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepHumCaseFormSpecimens 'en' , 128990000002 

*/
 
CREATE  Procedure [dbo].[spRepHumCaseFormSpecimens]
    (
        @LangID as nvarchar(10), 
        @ObjID	as bigint 
    )
as
	select	
				tMaterial.strFieldBarcode		as SpecimenLocalID,
				SpecimenType.name			as SpecimenType,
				tMaterial.datFieldCollectionDate as DateTimeOfCollection,
				tMaterial.datFieldSentDate		as DateTimeSpecimenSent,
				tMaterial.datAccession			as DateTimeCpecimenReceivedLab,
				tMaterial.strCondition			as Condition,
				tCondition.[name]				as ConditionReceived,
				Category.name				as TypeOfLabTest,
				TestResult.name				as TestResult,
				isnull(tlbBatchTest.datPerformedDate,tTests.datStartedDate)			as TestDate

	from		tlbMaterial as tMaterial  

  left join	dbo.fnReferenceRepair(@LangID,19000087) SpecimenType
  on			SpecimenType.idfsReference = tMaterial.idfsSampleType

	--left join   tlbAccessionIN as tAccession
	--on			tAccession.idfMaterial = tMaterial.idfMaterial
	
	left join	tlbTesting tTests 
	    inner join tlbMaterial on tlbMaterial.idfMaterial = tTests.idfMaterial and tlbMaterial.intRowStatus = 0
	on			tMaterial.idfMainTest = tTests.idfTesting
	and tTests.intRowStatus = 0

  left join	tlbBatchTest
  on			tTests.idfBatchTest = tlbBatchTest.idfBatchTest
	
  left join	fnReferenceRepair(@LangID, 19000095 ) Category --rftTestForDiseaseType
  on			Category.idfsReference = tTests.idfsTestCategory

  left join	fnReferenceRepair(@LangID, 19000096 ) TestResult --rftTestResult
  on			TestResult.idfsReference = tTests.idfsTestResult
	
	left join	[fnReference_FullRepair](@LangID) as tCondition
	on			tCondition.idfsReference = tMaterial.idfsAccessionCondition
	
	where		(tMaterial.idfHumanCase = @ObjID OR tMaterial.idfVetCase = @ObjID)
	and tMaterial.intRowStatus = 0 and SpecimenType.intHACode is not null
			
			

