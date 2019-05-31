

--##SUMMARY Select data for Container details report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 16.12.2009

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 23.04.2013

--##REMARKS UPDATED BY: Vasilyev I --introduce new fields
--##REMARKS Date: 14.08.2014

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

select top 10 * from tlbMaterial

exec [spRepLimSample] 'en' , 3990000426

*/


create  Procedure [dbo].[spRepLimSample]
    (
        @LangID as nvarchar(10),
        @ObjID	as bigint
    )
as
	select
				COALESCE	(tlbHumanCase.strCaseID,tlbVetCase.strCaseID,
							tlbMonitoringSession.strMonitoringSessionID,
							tlbVectorSurveillanceSession.strSessionID)		as strCaseID,
				Material.datAccession				as datAccessionDate,
				Material.datFieldCollectionDate		as datCollectionDate,
				Material.strBarcode					as strLabSampleID,
				SampleType.name						as strSampleType,
				pm.strBarcode						as strParentSampleID,
				Department.name						as strFunctionalArea,
				fnSheme.[Path]						as strStorageLocation,		
				CaseType.name  						as strCaseType,
				ISNULL(tlbHumanCase.strCaseID, tlbVetCase.strCaseID) + ', ' +
					(CASE 
						WHEN tlbHumanCase.idfHumanCase IS NULL THEN ISNULL(VetDiagnosis.strDisplayDiagnosis,   tlbVetCase.strDefaultDisplayDiagnosis)    
						ELSE Diagnosis.name 
				 	END)							as strCaseInfo,
				ISNULL(tlbMonitoringSession.strMonitoringSessionID, tlbVectorSurveillanceSession.strSessionID)		as strSessionID,
		
				(CASE 
						WHEN tlbHumanCase.idfHumanCase is not null THEN 
								dbo.fnConcatFullName(HumanFromCase.strLastName, HumanFromCase.strFirstName,HumanFromCase.strSecondName)
						ELSE COALESCE (Animal.SpeciesName, SpeciesName.name, vt.[name] + IsNull(N' ' + vst.[name], N'') + N', ' + tlbVector.strVectorID)
				 	END)	
				as strPatientSpeciesVectorInfo,
				
				Material.strNote					as strNotes,
				tlbCollectedByOffice.name			as strCollectedByInstitution,
				dbo.fnConcatFullName(tlbCollectedByPerson.strFamilyName, tlbCollectedByPerson.strFirstName, tlbCollectedByPerson.strSecondName)				as strCollectedByOfficer,
					
				TransferFromInst.name				as strReceivedFromInstitution,
				tout_from.strBarcode				as strReceivedFromTransferID,
				originalMaterial.strBarcode			as strReceivedFromLabSampleID,
				tout_from.datSendDate				as datReceivedFromLabDateReceived,
				
				TransferToInst.name					as strTransferredToInstitution,
				tout_to.strBarcode					as strTransferredToTransferID,
				tranferToMaterial.strBarcode		as strTransferredToLabSampleID,
				tout_to.strBarcode					as strTransferredToTransferID,
				tout_to.datSendDate					as datTransferredToDate,
				
				TestName.name						as strTestName,
				TestCategory.name					as strTestCategory,
				TestDiagnosis.name					as strTestDiagnosis,
				TestStatus.name						as strTestStatus,
				TestResult.name						as strTestResult,
				tbt.strBarcode						as strTestRunID,
				tlbTesting.datConcludedDate			as datTestResultDate,
				tlbTesting.datReceivedDate			as datDateTestResultsReceived,
				tlbTesting.strContactPerson			as strTestContactPerson 
							

	from	tlbMaterial	as Material --fnContainerList(@LangID)
	left join	tlbMaterial pm
	on			pm.idfMaterial = Material.idfParentMaterial
				and pm.intRowStatus = 0
	
    left join	dbo.fnReferenceRepair(@LangID,19000087) SampleType
    on			SampleType.idfsReference = Material.idfsSampleType

    left join	tlbMonitoringSession
    on			tlbMonitoringSession.idfMonitoringSession = Material.idfMonitoringSession

    left join	tlbVectorSurveillanceSession
    on			tlbVectorSurveillanceSession.idfVectorSurveillanceSession = Material.idfVectorSurveillanceSession

	left join	tlbVector
		inner join	fnReferenceRepair(@LangID, 19000140)	vt	-- Vector Type
		on			vt.idfsReference = tlbVector.idfsVectorType
		inner join	fnReference(@LangID, 19000141)	vst	-- Vector Sub Type
		on			vst.idfsReference = tlbVector.idfsVectorSubType
	on			tlbVector.idfVector = Material.idfVector
				and tlbVector.intRowStatus = 0
			
    left join	tlbHumanCase
    on			tlbHumanCase.idfHumanCase = Material.idfHumanCase
    
    left join	tlbVetCase
    on			tlbVetCase.idfVetCase = Material.idfVetCase
	
    left join	fnDepartment(@LangID) Department
    on			Department.idfDepartment = Material.idfInDepartment
	
    left join	dbo.fn_RepositorySchema(@LangID, null, null) as fnSheme
    on			fnSheme.idfSubdivision  = Material.idfSubdivision
    
	left join	fnReference(@LangID,19000012) CaseType --rftCaseType
	on			CaseType.idfsReference = CASE WHEN tlbHumanCase.idfHumanCase IS NOT NULL THEN 10012001 ELSE tlbVetCase.idfsCaseType	end
	
	left join	dbo.fnInstitution(@LangID) as tlbCollectedByOffice 
	on			tlbCollectedByOffice.idfOffice = Material.idfFieldCollectedByOffice
	
	left join	tlbPerson as tlbCollectedByPerson
	on			tlbCollectedByPerson.idfPerson = Material.idfFieldCollectedByPerson

	left join   dbo.tlbVetCaseDisplayDiagnosis VetDiagnosis  
	on			tlbVetCase.idfVetCase = VetDiagnosis.idfVetCase AND VetDiagnosis.idfsLanguage = dbo.fnGetLanguageCode(@LangID)  

	left join	dbo.fnReferenceRepair(@LangID, 19000019 ) Diagnosis --rftDiagnosis
	on			COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis, tlbVetCase.idfsShowDiagnosis) = Diagnosis.idfsReference
	
	left join	fnAnimalList(@LangID) Animal
	on			Material.idfAnimal = Animal.idfParty
	
	left join	tlbSpecies
	on			tlbSpecies.idfSpecies = Material.idfSpecies
	
	left join	fnReferenceRepair(@LangID,19000086) SpeciesName --rftSpeciesList
	on			SpeciesName.idfsReference=tlbSpecies.idfsSpeciesType

	left join	tlbHuman HumanFromCase
	on			HumanFromCase.idfHuman = Animal.idfFarmOwner or
				HumanFromCase.idfHuman = tlbHumanCase.idfHuman
			
	-- transfer from
	left join	tlbMaterial originalMaterial
		inner join	tlbTransferOutMaterial tout_m
		on			tout_m.idfMaterial = originalMaterial.idfMaterial			
		inner join	tlbTransferOUT as tout_from
		on			tout_from.idfTransferOut = tout_m.idfTransferOut
					and tout_from.intRowStatus = 0
		left join	dbo.fnInstitution(@LangID) as TransferFromInst
		on			TransferFromInst.idfOffice = tout_from.idfSendFromOffice
	on			originalMaterial.idfMaterial = Material.idfParentMaterial
				and originalMaterial.intRowStatus = 0
				and Material.idfsSampleKind = 12675430000000 --TransferredIn
	
	
	--transfer to
	left  join	tlbTransferOutMaterial
		inner join	tlbTransferOUT tout_to
		on			tlbTransferOutMaterial.idfTransferOut=tout_to.idfTransferOut
					and tout_to.intRowStatus = 0 
					and	tout_to.idfsTransferStatus = 10001003
		inner join	tlbMaterial tranferToMaterial
		on			tranferToMaterial.idfParentMaterial = tlbTransferOutMaterial.idfMaterial
					and tranferToMaterial.intRowStatus = 0
					and tranferToMaterial.idfsSampleKind = 12675430000000 --TransferredIn
					and tranferToMaterial.blnAccessioned = 1
		left join	dbo.fnInstitution(@LangID) as TransferToInst
		on			TransferToInst.idfOffice = tout_to.idfSendToOffice
	on			tlbTransferOutMaterial.idfMaterial = Material.idfMaterial and
				tlbTransferOutMaterial.intRowStatus = 0
				
		

	left join tlbTesting 
		left join	tlbBatchTest tbt
		on			tbt.idfBatchTest = tlbTesting.idfBatchTest
					and tbt.intRowStatus = 0
	
		inner join	dbo.fnReferenceRepair(@LangID, 19000097 ) TestName --rftTestName
		on			TestName.idfsReference = tlbTesting.idfsTestName

		left join	fnReferenceRepair(@LangID, 19000096 ) TestResult --rftTestResult
		on			TestResult.idfsReference = tlbTesting.idfsTestResult

		left join	fnReferenceRepair(@LangID, 19000095 ) TestCategory --rftTestForDiseaseType
		on			TestCategory.idfsReference = tlbTesting.idfsTestCategory

		left join	fnReferenceRepair(@LangID, 19000019 ) TestDiagnosis --rftTestForDiseaseType
		on			TestDiagnosis.idfsReference = tlbTesting.idfsDiagnosis

		left join	dbo.fnReferenceRepair(@LangID, 19000001 ) TestStatus --rftActivityStatus
		on			TestStatus.idfsReference = tlbTesting.idfsTestStatus	
	
	
	
	on tlbTesting.idfMaterial = Material.idfMaterial
	and tlbTesting.intRowStatus = 0				
	
			
				

   
 where	Material.idfMaterial = @ObjID
			

