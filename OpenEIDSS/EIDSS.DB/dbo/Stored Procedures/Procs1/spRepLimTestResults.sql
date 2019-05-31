

--##SUMMARY Select data for t results report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 15.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 18.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 23.04.2013


--##REMARKS UPDATED BY: Vasilyev I. --removed obsolete fields and add new fields without values
--##REMARKS Date: 23.04.2014

--##RETURNS Doesn't use 

/*
--Example of a call of procedure:

exec dbo.spRepLimTestResults @LangID=N'en',@ObjID=5563010001100
exec dbo.spRepLimTestResults @LangID=N'en',@ObjID=223340001100


*/

create  Procedure [dbo].[spRepLimTestResults]
    (
		@LangID as nvarchar(10),
        @ObjID	as bigint
    )
as

-- TODO: implement select fields. Check existing fields

--- see https://repos.btrp.net/BTRP/Project_Documents/10x-Business Analysis/21 Reports and Paper Forms/Templates v 6/Tests/TestResultReport - to be (with deleted parts).rtf
	
	select  
				btc.strBarcode				as strBatchBarcode,
				m.strFieldBarcode			as strLocalFieldSampleID,
				Category.name				as strCategory,
				TestType.name				as strTestType,
				StatusType.name				as strStatus,
				TestResult.name				as strResult,
				m.strBarcode				as strSampleID,
					
				ISNULL(t.datStartedDate, btc.datPerformedDate)		as datTestStartedDate,
				
				t.datConcludedDate				as datResultDate,
				
				SpecimenType.name				as strSampleType,
				
				dbo.fnConcatFullName(p_TestedBy.strFamilyName, p_TestedBy.strSecondName, p_TestedBy.strFirstName) as strTestedBy,
					
				dbo.fnConcatFullName(p_ResEntBy.strFamilyName, p_ResEntBy.strSecondName, p_ResEntBy.strFirstName) as strResultEnteredBy,
				
				Diagnosis.name						as strDiagnosisName,
				
				isnull(p_ValBy.strFamilyName,'') + 
					' ' + isnull(p_ValBy.strSecondName,'') + 
					' ' + isnull(p_ValBy.strFirstName,'')						as strValidatedBy,
				Laboratory.name								as strLaboratory,
				t.strNote						as strComment

	from		tlbTesting		as t
	
  	inner join tlbMaterial as m	
		on	m.idfMaterial = t.idfMaterial
		and m.intRowStatus = 0
		   
    left join	tlbHumanCase
			on	tlbHumanCase.idfHumanCase = m.idfHumanCase
				AND tlbHumanCase.intRowStatus = 0
				
	left join	tlbBatchTest btc 
	on			t.idfBatchTest = btc.idfBatchTest
    
    left join	fnReferenceRepair(@LangID, 19000095 ) Category --rftTestForDiseaseType
			on	Category.idfsReference = t.idfsTestCategory

    left join	fnReferenceRepair(@LangID, 19000096 ) TestResult --rftTestResult
			on	TestResult.idfsReference = t.idfsTestResult

    inner join	dbo.fnReferenceRepair(@LangID, 19000097 ) TestType --rftTestName
			on	TestType.idfsReference = t.idfsTestName

    left join	dbo.fnReferenceRepair(@LangID, 19000001 ) StatusType --rftActivityStatus
			on	StatusType.idfsReference = t.idfsTestStatus

	left join	dbo.fnReferenceRepair(@LangID,19000087) SpecimenType
			on	SpecimenType.idfsReference = m.idfsSampleType

    left join	fnReferenceRepair(@LangID, 19000019 ) Diagnosis 
			on	Diagnosis.idfsReference = t.idfsDiagnosis
			
			
	left join	tlbPerson p_ResEntBy
	on			isnull(t.idfResultEnteredByPerson, btc.idfPerformedByPerson) = p_ResEntBy.idfPerson					
			
	left join	tlbPerson p_TestedBy
	on			isnull(t.idfTestedByPerson, btc.idfPerformedByPerson) = p_TestedBy.idfPerson	
	
	left join	tlbPerson p_ValBy
	on			ISNULL(t.idfValidatedByPerson, btc.idfValidatedByPerson) = p_ValBy.idfPerson		
	
	left join	tlbOffice lab_off
	on		isnull(t.idfPerformedByOffice, btc.idfPerformedByOffice) = lab_off.idfOffice
			
	left join	dbo.fnReference(@LangID,19000045) Laboratory
	on		Laboratory.idfsReference = lab_off.idfsOfficeAbbreviation		
				
	where	t.idfTesting = @ObjID
			and	t.intRowStatus=0
			

