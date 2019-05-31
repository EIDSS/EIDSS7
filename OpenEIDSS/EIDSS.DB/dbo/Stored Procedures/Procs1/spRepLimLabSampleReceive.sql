

--##SUMMARY Select data for Accession in report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 16.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 23.04.2013

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 21.06.2013

--##REMARKS UPDATED BY: Romasheva S.
--##REMARKS Date: 07.05.2015

--##RETURNS Doesn't use
 
/*
--Example of a call of procedure:

exec dbo.spRepLimLabSampleReceive @ObjID=47280000204,@LangID='ru'

exec dbo.spRepLimLabSampleReceive @ObjID=7630000010,@LangID='ru'

exec dbo.spRepLimLabSampleReceive @ObjID=88200000241,@LangID='ru'



// empty
select top 1 * from tlbHumanCase hc
inner join tlbAntimicrobialTherapy ant
on hc.idfHumanCase = ant.idfHumanCase
inner join tlbMaterial m
on m.idfHumanCase = hc.idfHumanCase
inner join tlbTesting tt
on tt.idfMaterial = m.idfMaterial

WHERE hc.strSummaryNotes is not null


exec dbo.spRepLimLabSampleReceive @ObjID=74560000870,@LangID=N'ru'
exec dbo.spRepLimLabSampleReceive @ObjID=1560000870,@LangID='en'

*/

create  Procedure [dbo].[spRepLimLabSampleReceive]
    (
        @ObjID	as bigint,
        @LangID as nvarchar(10) 
    )
    
as
	declare @strAnyAntibioticsAdministration nvarchar(max)

	select @strAnyAntibioticsAdministration = isnull(@strAnyAntibioticsAdministration + ',', '') + at.strAntimicrobialTherapyName
	from	tlbAntimicrobialTherapy at
		inner join tlbHumanCase thc
		on thc.idfHumanCase = at.idfHumanCase
		and thc.intRowStatus = 0
	where	at.idfHumanCase = @ObjID and at.intRowStatus=0
	

	select		
				COALESCE(hc.idfHumanCase, vc.idfVetCase, sess.idfMonitoringSession ) as idfCase,
				COALESCE(hc.strCaseID, vc.strCaseID, sess.strMonitoringSessionID) as CaseID,
				COALESCE(hc.datOnSetDate, vc.datInvestigationDate) 	as DateOfSymptoms,
				-- TODO: implement 
				-----------------------
				
				@strAnyAntibioticsAdministration			as	strAnyAntibioticsAdministration,
				hc.strSampleNotes							as	strAdditionalTestRequested ,
				Material.strFieldBarcode					as  LocalID,
				Material.strCondition						as  Comment,
				-----------------------
				(
					select count(*) from tlbTesting tt
					where tt.idfMaterial = Material.idfMaterial
					and tt.intRowStatus = 0
				)		as			intTests,
				case
					when (hc.idfHumanCase is null) and (vc.idfVetCase is null) then 2
					else 
						case 
							when (hc.idfHumanCase is not null) then 1   else 0	
						end
				end									as intCaseType,
				
				
				dbo.fnGeoLocationString(@LangID, tFarm.idfFarmAddress, null)	as FarmAddress,
				tFarm.strNationalName				as FarmName,
				dbo.fnConcatFullName(tFarmOwner.strLastName, tFarmOwner.strFirstName, tFarmOwner.strSecondName)	
													as FarmOwner,
				dbo.fnConcatFullName(tHuman.strLastName, tHuman.strFirstName, tHuman.strSecondName)				
													as PatientName,
				IsNull(Str(hc.intPatientAge) + ' (' + rfAgeType.[name] + ')', '')	
													as Age,
				(case 
					when vc.idfVetCase IS NULL then rfHumanDiagnosis.name
					else isnull(VetDiagnosis.strDisplayDiagnosis,   vc.strDefaultDisplayDiagnosis)
				end)  as DiagnosisInitial,  
				dbo.fnGeoLocationString(@LangID, tHuman.idfCurrentResidenceAddress, null)	
													as CurrentResidence,

				Material.strFieldBarcode			as LocalSampleID,
				SpecimenType.name					as SampleType,
				fnAnimal.AnimalName					as AnimalID,
				fnAnimal.SpeciesName				as Species,
				Material.datFieldCollectionDate		as CollectionDate,
				Material.datFieldSentDate			as DateSent,
				Material.strBarcode					as LabSampleID,
				Material.datAccession				as AccessionDate,
				sCondition.[name]					as SampleCondition,
				fnRepository.[Path]					as Location,
				
				fnDepartment.[name]					as FunctionalArea,
				dbo.fnConcatFullName(tAccessionPerson.strFamilyName, tAccessionPerson.strFirstName, tAccessionPerson.strSecondName) 
													as AccessionedBy,
				dbo.fnConcatFullName(tCollectedPerson.strFamilyName, tCollectedPerson.strFirstName, tCollectedPerson.strSecondName) 
													as CollectedByPerson,
				tHuman.idfCurrentResidenceAddress	as idfCurrentResidenceAddress,
				fnASRegion.name						as strASRegion,
				fnASRayon.name						as strASRayon,
				fnASSettlement.name					as strASSettlement,
				(
					select
								fnDiagnosis.[name] + '; '
					from		tlbMonitoringSessionToDiagnosis	tSTD
					inner join	dbo.fnReferenceRepair(@LangID,19000019) fnDiagnosis
					on			tSTD.idfsDiagnosis = fnDiagnosis.idfsReference 		
					where		tSTD.idfMonitoringSession = @ObjID
					and			tSTD.intRowStatus = 0
					Order By	tSTD.intOrder	
					for xml path('')
				)									as strDiagnosisList,
				camp.strCampaignID					as strCampaignID,
				camp.strCampaignName				as strCampaignName,
				fnCampaignType.[name]				as strCampaignType
				
				
				
	--get session				
	from	 (	
						dbo.tlbMonitoringSession	as sess
					
			-- Get campaign
			 left join	dbo.tlbCampaign as camp
					on	camp.idfCampaign = sess.idfCampaign 
			 left join	fnReferenceRepair(@LangID,19000116) fnCampaignType
					on	fnCampaignType.idfsReference = camp.idfsCampaignType
			 	 
			-- Get session address
			 left join	fnGisReference(@LangID,19000003) fnASRegion
					on	fnASRegion.idfsReference = sess.idfsRegion
			left join	fnGisReference(@LangID,19000002) fnASRayon
					on	fnASRayon.idfsReference = sess.idfsRayon
			left join	fnGisReference(@LangID,19000004) fnASSettlement
					on	fnASSettlement.idfsReference = sess.idfsSettlement
			)
	-- get human case
	full join (
				dbo.tlbHumanCase as hc
				-- Get Human Age Type 
				left join	fnReferenceRepair(@LangID, 19000042 /* rftHumanAgeType*/) rfAgeType
						on	hc.idfsHumanAgeType	= rfAgeType.idfsReference
				-- Get patient
				inner join	dbo.tlbHuman	as tHuman
						on	hc.idfHuman = tHuman.idfHuman
					     and  tHuman.intRowStatus = 0
				
				-- Get Diagnosis
				left join	fnReferenceRepair(@LangID, 19000019/*'rftDiagnosis' */) as rfHumanDiagnosis
				on	rfHumanDiagnosis.idfsReference = ISNULL(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)
			) on	hc.idfHumanCase = sess.idfMonitoringSession
			
	-- get vet case
	full join (
				dbo.tlbVetCase	as vc
				-- Get Farm		
				inner join	dbo.tlbFarm		as tFarm
					on	vc.idfFarm = tFarm.idfFarm
				   and  tFarm.intRowStatus = 0
				   
				left join	tlbHuman		as tFarmOwner
					on	tFarm.idfHuman = tFarmOwner.idfHuman
					
				-- Get Diagnosis
				left join	fnReferenceRepair(@LangID, 19000019/*'rftDiagnosis' */) as rfVetDiagnosis
					on	rfVetDiagnosis.idfsReference = vc.idfsShowDiagnosis
				left join   dbo.tlbVetCaseDisplayDiagnosis VetDiagnosis  
					on vc.idfVetCase = VetDiagnosis.idfVetCase 
						AND VetDiagnosis.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
			) on	vc.idfVetCase = sess.idfMonitoringSession


-- Get Accession, Container, Matererial
	 left join	(tlbMaterial as Material
				 left join	fnAnimalList(@LangID) fnAnimal
						on	Material.idfAnimal = fnAnimal.idfParty
				 left join	dbo.tlbPerson as tCollectedPerson
						on	tCollectedPerson.idfPerson = Material.idfFieldCollectedByPerson
				 left join	dbo.fnReferenceRepair(@LangID,19000087) SpecimenType
  					on			SpecimenType.idfsReference = Material.idfsSampleType
				 left join	dbo.tlbPerson		as tAccessionPerson
						on	tAccessionPerson.idfPerson = Material.idfAccesionByPerson
				 left join	dbo.fn_RepositorySchema (@LangID, null, null) as fnRepository
						on	Material.idfSubdivision = fnRepository.idfSubdivision								 
				 left join	fnDepartment(@LangID) as fnDepartment
						on	fnDepartment.idfDepartment = Material.idfInDepartment
				 left join	tlbTransferOutMaterial tOut_M
				 on			tOut_M.idfMaterial = Material.idfMaterial
	 			 left join	fnReferenceRepair(@LangID,19000110) sCondition
					on	sCondition.idfsReference = Material.idfsAccessionCondition

				)
				on	
				Material.blnShowInAccessionInForm = 1 
				and tOut_M.idfMaterial is null -- doesn't include transferred materials
				and ((Material.idfHumanCase = hc.idfHumanCase) OR (Material.idfVetCase = vc.idfVetCase) or
					(Material.idfMonitoringSession = sess.idfMonitoringSession))
					and Material.intRowStatus = 0

	
					
					

 where	((hc.intRowStatus = 0  and	hc.idfHumanCase = @ObjID) or 
		(vc.intRowStatus = 0  and	vc.idfVetCase = @ObjID)	or 
		(sess.intRowStatus = 0  and	sess.idfMonitoringSession = @ObjID))
			

