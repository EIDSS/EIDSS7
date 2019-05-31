

--##REMARKS UPDATED BY: Romasheva s.
--##REMARKS Date: 16.03.2012

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

-- exec spLabSample_SelectDetail 0, 'en'

CREATE            PROCEDURE [dbo].[spLabSample_SelectDetail]( 
	@idfMaterial AS bigint,
	@LangID NVARCHAR(50)
)
AS


select		
			Material.idfMaterial,
			Material.idfsSampleStatus,
			Material.datAccession,
			Material.strBarcode,
			ISNULL(Material.idfHumanCase, Material.idfVetCase) AS idfCase ,
			Material.idfMonitoringSession,
			ISNULL(tlbHumanCase.strCaseID, tlbVetCase.strCaseID) AS strCaseID,
			ISNULL(tlbMonitoringSession.strMonitoringSessionID, tlbVectorSurveillanceSession.strSessionID) as strMonitoringSessionID,
			tlbVectorSurveillanceSession.idfVectorSurveillanceSession, 
			CASE 
				WHEN tlbHumanCase.idfHumanCase IS NOT NULL THEN 10012001
				ELSE tlbVetCase.idfsCaseType
			END AS idfsCaseType,
			dbo.fnReferenceRepair.name AS strSampleName,
			COALESCE (Animal.SpeciesName, SpeciesName.name, vt.[name] + IsNull(N' ' + vst.[name], N'') + N', ' + tlbVector.strVectorID) as SpeciesName,
			Animal.strAnimalCode,
		    dbo.fnConcatFullName(HumanFromCase.strLastName, HumanFromCase.strFirstName, HumanFromCase.strSecondName) as HumanName,
			(CASE 
				WHEN tlbHumanCase.idfHumanCase IS NULL THEN 
					--This is workaround for task 13227 (Vet case final diagnosis shall be displayed in bold), affects to desktop only
					ISNULL(N'<b>'+ Diagnosis.name+ N'</b>, ', N'') + ISNULL(VetDiagnosis.strDisplayDiagnosis,   tlbVetCase.strDefaultDisplayDiagnosis) COLLATE DATABASE_DEFAULT 
				ELSE Diagnosis.name 
			END) as DiagnosisName,
			(CASE 
				WHEN tlbMonitoringSession.idfMonitoringSession IS NOT NULL THEN dbo.fnASSessionDiagnoses(tlbMonitoringSession.idfMonitoringSession,@LangID)
				ELSE N'' 
			END) as SessionDiagnosisName,
			COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis, tlbVetCase.idfsShowDiagnosis) AS idfsShowDiagnosis,
			Material.idfInDepartment,
			Material.idfSubdivision,
			Material.idfFieldCollectedByOffice,
			tlbCollectedByOffice.[name] as strFieldCollectedByOffice,
			Material.idfFieldCollectedByPerson,
			dbo.fnConcatFullName(tlbCollectedByPerson.strFamilyName, tlbCollectedByPerson.strFirstName, tlbCollectedByPerson.strSecondName) as strFieldCollectedByPerson,
			Material.strNote,
			Parent.idfMaterial as idfParentMaterial,
			Parent.strBarcode as strParentBarcode,
			CaseType.name as CaseType,
			Material.datFieldCollectionDate,
			Material.idfsBirdStatus,
			CASE WHEN NOT tlbMonitoringSession.strMonitoringSessionID IS NULL THEN 32  --Livestock
			WHEN NOT  tlbVectorSurveillanceSession.strSessionID IS NULL THEN 128 --Vector
			WHEN NOT tlbHumanCase.idfHumanCase IS NULL  THEN 2 --Human
			WHEN ISNULL(tlbVetCase.idfsCaseType,0) = 10012003 THEN 32 --Livestock
			WHEN ISNULL(tlbVetCase.idfsCaseType,0) = 10012004 THEN 64 --Avian
			ELSE 0 END as intHACode,
			Material.idfsDestructionMethod,
			Material.idfsSite,
			Material.idfsCurrentSite,
			dbo.fnIsSampleTransferred(Material.idfMaterial) as blnSampleTransferred,
			Material.strCondition 

from		tlbMaterial Material
left join	tlbVetCase
on			tlbVetCase.idfVetCase = Material.idfVetCase
left join	tlbHumanCase
on			tlbHumanCase.idfHumanCase = Material.idfHumanCase
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
left join	dbo.fnReferenceRepair(@LangID,19000087) --rftSampleType
on			dbo.fnReferenceRepair.idfsReference = Material.idfsSampleType
left join	fnAnimalList(@LangID) Animal
on			Material.idfAnimal = Animal.idfParty
LEFT JOIN	tlbSpecies
ON			tlbSpecies.idfSpecies = Material.idfSpecies
LEFT JOIN	fnReferenceRepair(@LangID,19000086) SpeciesName --rftSpeciesList
ON			SpeciesName.idfsReference=tlbSpecies.idfsSpeciesType
left join	tlbHuman HumanFromCase
on			HumanFromCase.idfHuman = Animal.idfFarmOwner or
			HumanFromCase.idfHuman = tlbHumanCase.idfHuman
left join	dbo.fnReferenceRepair(@LangID, 19000019 ) Diagnosis --rftDiagnosis
on			COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis, tlbVetCase.idfsShowDiagnosis) = Diagnosis.idfsReference
			
			
LEFT JOIN	tlbMaterial Parent
ON			Parent.idfMaterial = Material.idfParentMaterial
			AND Parent.intRowStatus = 0
left join	fnReference(@LangID,19000012) CaseType--rftCaseType
on			CaseType.idfsReference = CASE WHEN tlbHumanCase.idfHumanCase IS NOT NULL THEN 10012001 ELSE tlbVetCase.idfsCaseType	END
left join	dbo.fnInstitution(@LangID) as tlbCollectedByOffice 
on			tlbCollectedByOffice.idfOffice = Material.idfFieldCollectedByOffice
left join	tlbPerson as tlbCollectedByPerson
on			tlbCollectedByPerson.idfPerson = Material.idfFieldCollectedByPerson
  
LEFT JOIN   dbo.tlbVetCaseDisplayDiagnosis VetDiagnosis  
on tlbVetCase.idfVetCase = VetDiagnosis.idfVetCase AND VetDiagnosis.idfsLanguage = dbo.fnGetLanguageCode(@LangID)  
where		Material.idfMaterial = @idfMaterial and
        Material.intRowStatus = 0


select
	tst.idfTesting,
	tst.idfsTestName,
	tst.idfsTestCategory,
	tst.idfsTestResult,
	tst.idfBatchTest,
	tst.idfsTestStatus,
	btc.strBarcode as BatchTestCode,
	tst.idfsDiagnosis,
	ISNULL(tst.datStartedDate, btc.datPerformedDate) as datStartedDate,
	ISNULL(tst.datConcludedDate, btc.datValidatedDate) as datConcludedDate,
	tst.blnExternalTest,
	ISNULL(tst.idfTestedByOffice,btc.idfPerformedByOffice) as idfTestedByOffice,
	ISNULL(tst.idfTestedByPerson,btc.idfPerformedByPerson) as idfTestedByPerson,
	tst.datReceivedDate,
	tst.strContactPerson,
	tst.idfMaterial,
	tst.idfObservation,
	ISNULL(tst.idfResultEnteredByOffice,btc.idfPerformedByOffice) as idfResultEnteredByOffice,
	ISNULL(tst.idfResultEnteredByPerson,btc.idfPerformedByPerson) as idfResultEnteredByPerson,
	ISNULL(tst.idfValidatedByOffice, btc.idfValidatedByOffice) as idfValidatedByOffice,
	ISNULL(tst.idfValidatedByPerson, btc.idfValidatedByPerson) as idfValidatedByPerson,
	tst.strNote,
	tst.idfPerformedByOffice,
	tst.blnNonLaboratoryTest,
	CAST(CASE WHEN vc.idfsFinalDiagnosis = tst.idfsDiagnosis THEN 1 ELSE 0 END as bit) as blnFinalDiagnosis 
from
	tlbTesting tst
inner join tlbMaterial Material
	on			Material.idfMaterial = tst.idfMaterial
	and     Material.intRowStatus = 0
left join tlbVetCase vc
	on Material.idfVetCase = vc.idfVetCase
left join	tlbBatchTest btc
	on			tst.idfBatchTest = btc.idfBatchTest
left join	tlbObservation obs
	on			obs.idfObservation = tst.idfObservation
left join	tlbPerson pen
	on			ISNULL(tst.idfResultEnteredByPerson,btc.idfPerformedByPerson) = pen.idfPerson
where		
	tst.intRowStatus=0
	and tst.idfMaterial=@idfMaterial

--returns information about original material that was transferred to current site
select		tlbTransferOUT.idfTransferOut,
			tlbTransferOUT.idfSendFromOffice,
			tlbTransferOUT.strBarcode,
			originalMaterial.idfMaterial,
			originalMaterial.strBarcode as MaterialBarcode
from		tlbMaterial currentMaterial
INNER JOIN	tlbMaterial originalMaterial
ON			originalMaterial.idfMaterial = currentMaterial.idfParentMaterial
			AND originalMaterial.intRowStatus = 0
			AND currentMaterial.idfsSampleKind = 12675430000000 --TransferredIn
INNER JOIN tlbTransferOutMaterial
ON			tlbTransferOutMaterial.idfMaterial = originalMaterial.idfMaterial			
INNER JOIN tlbTransferOUT 
ON			tlbTransferOUT.idfTransferOut = tlbTransferOutMaterial.idfTransferOut
			AND tlbTransferOUT.intRowStatus = 0
where		currentMaterial.idfMaterial=@idfMaterial
			AND tlbTransferOUT.intRowStatus=0
			AND currentMaterial.intRowStatus = 0

--returns information about material that was transferred to remote site
select		tlbTransferOUT.idfTransferOut,
			tlbTransferOUT.idfSendToOffice,
			tlbTransferOUT.strBarcode,
			tlbTransferOUT.datSendDate,
			tlbMaterial.idfMaterial,
			tlbMaterial.strBarcode as MaterialBarcode,
			tstSite.idfsSite
from		tlbTransferOUT
inner join	tlbTransferOutMaterial
on			tlbTransferOutMaterial.idfTransferOut=tlbTransferOUT.idfTransferOut and
			tlbTransferOutMaterial.idfMaterial=@idfMaterial and
			tlbTransferOutMaterial.intRowStatus=0
LEFT JOIN	tlbMaterial
ON			tlbMaterial.idfParentMaterial = tlbTransferOutMaterial.idfMaterial
			AND tlbMaterial.intRowStatus = 0
			AND tlbMaterial.idfsSampleKind = 12675430000000 --TransferredIn
			AND tlbMaterial.blnAccessioned = 1
left join	tstSite
on			tstSite.idfOffice=tlbTransferOUT.idfSendToOffice and
			tstSite.intRowStatus=0
where		tlbTransferOUT.intRowStatus=0 and
			tlbTransferOUT.idfsTransferStatus=10001003
