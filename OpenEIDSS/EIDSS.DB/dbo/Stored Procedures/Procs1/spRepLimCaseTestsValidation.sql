

--##SUMMARY Select data for Test report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 10.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 24.04.2013


--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepLimCaseTestsValidation @ObjID=N'10700001100',@LangID=N'ru'

*/

create  Procedure [dbo].[spRepLimCaseTestsValidation]
    (
        @ObjID	as bigint,
        @LangID as nvarchar(10)
    )
as

	declare @cYes as nvarchar(20)
	declare @cNo as nvarchar(20)
	select @cYes=[name] from fnReferenceRepair(@LangID,19000100 /*'rftYesNoValue'*/) where idfsReference=10100001 /*'ynvYes'*/
	select @cNo=[name] from fnReferenceRepair(@LangID,19000100 /*'rftYesNoValue'*/) where idfsReference=10100002 /*'ynvNo'*/

	select  
	rfDiagnosis.[name]					as Diagnosis,
	rfTestType.[name]					as TestName,
	rfTestForDisease.[name]				as TestType,
	idfsInterpretedStatus				as intRuleStatus,
	tValidation.strInterpretedComment	as strRuleComment,
	tValidation.datInterpretationDate	as interpretedDate,
	dbo.fnConcatFullName(tInterpretedBy.strFamilyName, tInterpretedBy.strFirstName, tInterpretedBy.strSecondName) as InterpretedBy,

	case tValidation.blnValidateStatus 
		when 0 then @cNo
		when 1 then @cYes
	end									as intValidateStatus,
	dbo.fnConcatFullName(tInterpretedBy.strFamilyName, tInterpretedBy.strFirstName, tInterpretedBy.strSecondName) as InterpretedBy,
	tValidation.strValidateComment		as strValidateComment,
	dbo.fnConcatFullName(tValidatedBy.strFamilyName, tValidatedBy.strFirstName, tValidatedBy.strSecondName) as ValidatedBy,
	tValidation.datValidationDate		as validatedDate

	
	from 
				dbo.tlbTesting			as tTests
	 left join	dbo.fnReferenceRepair(@LangID, 19000097 ) rfTestType --rftTestName
			on	rfTestType.idfsReference = tTests.idfsTestName
	 left join	dbo.fnReferenceRepair(@LangID,19000095)	as rfTestForDisease
			on	tTests.idfsTestCategory = rfTestForDisease.idfsReference
	-- Get Tests  Validation		
	 inner join	tlbTestValidation		as tValidation
			on	tTests.idfTesting = tValidation.idfTesting 
		   and	tTests.intRowStatus = 0 
		   and	tValidation.intRowStatus = 0
	 left join	tlbPerson				as tValidatedBy
			on	tValidation.idfValidatedByPerson = tValidatedBy.idfPerson
	 left join	tlbPerson				as tInterpretedBy 
			on	tValidation.idfInterpretedByPerson = tInterpretedBy.idfPerson
	-- Get Diagnosis
	 left join	fnReferenceRepair(@LangID, 19000019/*'rftDiagnosis' */) as rfDiagnosis
			on	rfDiagnosis.idfsReference = tValidation.idfsDiagnosis
			
		
	inner JOIN	tlbMaterial
			ON	tlbMaterial.idfMaterial = tTests.idfMaterial
				AND tlbMaterial.intRowStatus = 0
				AND	(tlbMaterial.idfHumanCase = @ObjID OR tlbMaterial.idfVetCase = @ObjID OR tlbMaterial.idfMonitoringSession = @ObjID)
				

	-- Filter Condition
		 where	tTests.intRowStatus = 0
			

