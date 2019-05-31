

--##SUMMARY Select data for Batch report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 10.12.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepLimBatchTest @ObjID=195860001100,@LangID=N'en'

*/

create  Procedure [dbo].[spRepLimBatchTest]
    (
        @ObjID	as bigint,
        @LangID as nvarchar(10)
    )
as
	select 
	tBatch.strBarcode			as BatchTestID,	
	rfTestType.[name]			as TestName,
	rfPerformed.[name]			as LocationPerformed,
	dbo.fnConcatFullName(rfTestedBy.strFamilyName, rfTestedBy.strFirstName, rfTestedBy.strSecondName) as TestedByName,
	tBatch.datPerformedDate		as TestedDate,
	dbo.fnConcatFullName(rfValidatedBy.strFamilyName, rfValidatedBy.strFirstName, rfValidatedBy.strSecondName) as ValidatedByName,
	tBatch.datValidatedDate		as datValidatedDate	,
	tBatch.idfObservation		as idfBatchObservation,
	rfBatchStatus.name			as BatchStatus
	

	from		tlbBatchTest			as tBatch
	 left join	fnReferenceRepair(@LangID, 19000097 /* rftTestName*/ )	as  rfTestType
			on	rfTestType.idfsReference = tBatch.idfsTestName
	 left join	fnInstitution (@LangID) as rfPerformed
			on	rfPerformed.idfOffice = tBatch.idfPerformedByOffice
	 left join	tlbPerson				as rfTestedBy
			on	rfTestedBy.idfPerson = tBatch.idfPerformedByPerson	
	 left join	tlbPerson				as rfValidatedBy
			on	rfValidatedBy.idfPerson = tBatch.idfValidatedByPerson	
	left join	fnReferenceRepair(@LangID, 19000001  )	as  rfBatchStatus
			on	rfBatchStatus.idfsReference = tBatch.idfsBatchStatus
			
		 where  tBatch.idfBatchTest = @ObjID

			



