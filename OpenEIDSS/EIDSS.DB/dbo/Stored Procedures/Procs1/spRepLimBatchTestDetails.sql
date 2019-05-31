

--##SUMMARY Select data for Batch report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 10.12.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepLimBatchTestDetails @ObjID=195860001100,@LangID=N'en'

*/

create  Procedure [dbo].[spRepLimBatchTestDetails]
    (
        @ObjID	as bigint,
        @LangID as nvarchar(10)
    )
as
		select 
			Testing.idfTesting,  
			Testing.idfObservation,
			Testing.intTestNumber		as Sequence,
			TestResult.name			as Result,
			TestType.name			as TestName,
			Material.strBarcode			as LabSampleID,
			Diagnosis.name		as Diagnosis,
			SpecimenType.name		as Specimen,
			Category.name		as Category,
			dbo.fnConcatFullName(enteredBy.strFamilyName, enteredBy.strFirstName, enteredBy.strSecondName) as ResultEnteredBy
			

    from	tlbTesting as Testing

    inner join	tlbMaterial as Material
    on			Material.idfMaterial = Testing.idfMaterial
    and Material.intRowStatus = 0

	left join	dbo.fnReferenceRepair(@LangID,19000087) SpecimenType
	on			SpecimenType.idfsReference = Material.idfsSampleType

    inner join	dbo.fnReferenceRepair(@LangID, 19000097 ) TestType --rftTestName
    on			TestType.idfsReference = Testing.idfsTestName

    left join	fnReferenceRepair(@LangID, 19000096 ) TestResult --rftTestResult
    on			TestResult.idfsReference = Testing.idfsTestResult

    left join	fnReferenceRepair(@LangID, 19000019 ) Diagnosis --rftTestForDiseaseType
    on			Diagnosis.idfsReference = Testing.idfsDiagnosis

    left join	fnReferenceRepair(@LangID, 19000095 ) Category 
    on			Category.idfsReference = Testing.idfsTestCategory
    
    left join	tlbPerson				as enteredBy
	on			enteredBy.idfPerson = Testing.idfResultEnteredByPerson


    where	idfBatchTest=@ObjID and
	          Testing.intRowStatus = 0

			

