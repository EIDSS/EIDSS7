

--##SUMMARY Select data for Human Case Investigation report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 10.12.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepHumCaseForm @LangID=N'en',@ObjID=55693870000000

*/

create  Procedure [dbo].[spRepHumCaseForm]
	(
		@LangID as nvarchar(10),
		@ObjID	as bigint
	)
AS	
	select 
	rfHumanCase.idfCase							as idfCase,
	rfHumanCase.strLocalIdentifier				as LocalID,
	SendByOffice.FullName						as OrgSentNotification,
	InvestigatedByOffice.FullName				as OrgConductInv,
	--- Reg Address ---
	rfRegistratedRegion.[name]					as RegRegion,
	rfRegistratedRayon.[name]					as RegRayon,	
	rfRegistratedSettlement.[name]				as RegVillage,
	tRegistratedLocation.strStreetName			as RegStreet,
	tRegistratedLocation.strPostCode			as RegPostalCode,
	tRegistratedLocation.strBuilding			as RegBuld,
	tRegistratedLocation.strHouse				as RegHouse,
	tRegistratedLocation.strApartment			as RegApp,
	rfHumanCase.strRegistrationPhone			as RegPhone,
	case 
		when tRegistratedLocation.blnForeignAddress =1 then	tRegistratedLocation.strAddressString
		else ''
	end											as RegForeignAddress,
	tRegistratedLocation.dblLongitude			as RegLongitude,
	tRegistratedLocation.dblLatitude			as RegLatitude,
	---- Employer Address---
	rfEmployerCountry.[name]					as EmpCountry,
	rfEmployerRegion.[name]						as EmpRegion,
	rfEmployerRayon.[name]						as EmpRayon,
	rfEmployerSettlement.[name]					as EmpVillage,
	tEmployerLocation.strStreetName				as EmpStreet,
	rfHumanCase.strWorkPhone					as EmpPhone,
	tEmployerLocation.strPostCode				as EmpPostalCode,
	tEmployerLocation.strBuilding				as EmpBuild,
	tEmployerLocation.strHouse					as EmpHouse,
	tEmployerLocation.strApartment				as EmpApp,

	---
	rfInitialCaseStatus.[name]					as InitCaseStatus,
	rfHumanCase.datNotificationDate				as DateFromHealthCareProvider, -- dbo.Activity.datReportDate
	rfHumanCase.strCaseID						as CaseIdentifier,
	rfHumanCase.datInvestigationStartDate		as StartingDateOfInvestigation,
	rfHumanCase.datCompletionPaperFormDate		as CompletionPaperFormDate,
	rfHumanCase.strPatientFullName				as NameOfPatient,
	rfHumanCase.datDateofBirth					as DOB,
	rfHumanCase.strPersonID						as strPersonID,
	rfHumanCase.strPersonIDType					as strPersonIDType,	
	rfHumanCase.strPatientAgeType				as AgeType,
	rfHumanCase.intPatientAge					as Age,
	rfHumanCase.strPatientGender				as Sex,
	rfNationality.[name]						as Citizenship,
	---- Home Address---
	rfCurrentRegion.[name]						as Region,
	rfCurrentRayon.[name]						as Rayon,	
	rfCurrentSettlement.[name]					as City,
	tCurrentLocation.strStreetName				as Street,
	tCurrentLocation.strPostCode				as strPost_Code,
	rfHumanCase.strHomePhone					as PhoneNumber,
	rfOccupationType.[name]						as Occupation,
	tCurrentLocation.strBuilding				as BuildingNum,
	tCurrentLocation.strHouse					as HouseNum,
	tCurrentLocation.strApartment				as AptNum,
	tCurrentLocation.dblLongitude				as Longitude,
	tCurrentLocation.dblLatitude				as Latitude,
	
	---
	rfHospitalizationStatus.[name]				as strCurrentLocationStatus,
	rfHumanCase.strEmployerName					as NameOfEmployer,
	rfHumanCase.datFacilityLastVisit			as datFacilityLastVisit,
	rfHumanCase.datExposureDate					as DateOfExposure,
	rfHumanCase.datOnSetDate					as DateofSymptomsOnset,
	rfHumanCase.datFirstSoughtCareDate			as DateOfFirstSoughtCare,
	SoughtCareFacility.FullName					as FacilityOfPatientSoughtCare,
	CurrentLocationOffice.[name]				as CurrentLocationOfficeName,
	rfHumanCase.datHospitalizationDate			as HospitalizationDate,
	rfHumanCase.datDischargeDate				as DateOfDischarged,
	rfHumanCase.strHospitalizationPlace			as PlaceOfHospitalization,
	rfHospitalisationYN.[name]					as Hospitalization,
	rfHumanCase.strClinicalNotes				as ClinicalComments,
	rfCaseStatus.[name]							as FinalCaseClassification,
	rfHumanCase.datFinalCaseClassificationDate	as FinalCaseClassificationDate,
	rfCaseProgerssStatus.[name]					as CaseProgerssStatus,
	isnull(rfHumanCase.strFinalDiagnosis, rfHumanCase.strTentetiveDiagnosis) as FinalDiagnosis,
	isnull(rfHumanCase.datFinalDiagnosisDate, rfHumanCase.datTentativeDiagnosisDate) as FinalDiagDate,
	rfHumanCase.strTentetiveDiagnosis			as InitialDiagnosis,
	rfHumanCase.datTentativeDiagnosisDate		as InitialDiagDate,
	rfHumanCase.strClinicalDiagnosis			as ClinicalDiagnosis,
	rfSpecimenCollectedYN.[name]				as SpeciemenCollected,
	rfHumanCase.strNotCollectedReason			as ReasonForNotCollectingSpeciemens,
	tHumanCase.strSampleNotes					as strSampleNotes,
	rfTherapyYN.[name]							as Antibiotics,
	isnull(tHumanCase.blnClinicalDiagBasis,0)	as blnClinicalDiagBasis,
	isnull(tHumanCase.blnLabDiagBasis,0)		as blnLabDiagBasis,
	isnull(tHumanCase.blnEpiDiagBasis,0)		as blnEpiDiagBasis,
	rfOutcome.[name]							as Outcome,
	rfHumanCase.datDateOfDeath					as DateOfDeath,
	rfRelatedToOutbreakYN.[name]				as RelatedToOutbreak,
	tOutbreak.strOutbreakID						as OutbreakID,
	rfHumanCase.strSummaryNotes					as SummaryComments,
	rfHumanCase.strEpidemiologistsName			as EpiName,
	rfHumanCase.strGeoLocation					as strGeoLocation,
	rfHumanCase.strFinalState					as strFinalState,
	rfHumanCase.strNote							as strClinicalInformationComments
	

	from		dbo.fnRepGetHumanCaseProperties(@LangID) as rfHumanCase
	-- Get HOME ADDRESS 
	 left join	dbo.tlbGeoLocation tCurrentLocation
			on	rfHumanCase.idfCurrentResidenceAddress = tCurrentLocation.idfGeoLocation
 	 left join	fnGisReference(@LangID, 19000001 /*'rftCountry'*/) rfCurrentCountry 
			on	rfCurrentCountry.idfsReference = tCurrentLocation.idfsCountry
	 left join	fnGisReference(@LangID, 19000003 /*'rftRegion'*/)  rfCurrentRegion 
			on	rfCurrentRegion.idfsReference = tCurrentLocation.idfsRegion
	 left join	fnGisReference(@LangID, 19000002 /*'rftRayon'*/)   rfCurrentRayon 
			on	rfCurrentRayon.idfsReference = tCurrentLocation.idfsRayon
	 left join	fnGisReference(@LangID, 19000004 /*'rftSettlement'*/) rfCurrentSettlement
			on	rfCurrentSettlement.idfsReference = tCurrentLocation.idfsSettlement
	-- Get Registrated ADDRESS 
	 left join	dbo.tlbGeoLocation tRegistratedLocation
			on	rfHumanCase.idfRegistrationAddress = tRegistratedLocation.idfGeoLocation
 	 left join	fnGisReference(@LangID, 19000001 /*'rftCountry'*/) rfRegistratedCountry 
			on	rfRegistratedCountry.idfsReference = tRegistratedLocation.idfsCountry
	 left join	fnGisReference(@LangID, 19000003 /*'rftRegion'*/)  rfRegistratedRegion 
			on	rfRegistratedRegion.idfsReference = tRegistratedLocation.idfsRegion
	 left join	fnGisReference(@LangID, 19000002 /*'rftRayon'*/)   rfRegistratedRayon 
			on	rfRegistratedRayon.idfsReference = tRegistratedLocation.idfsRayon
	 left join	fnGisReference(@LangID, 19000004 /*'rftSettlement'*/) rfRegistratedSettlement
			on	rfRegistratedSettlement.idfsReference = tRegistratedLocation.idfsSettlement
	-- Get Employer ADDRESS 
	 left join	dbo.tlbGeoLocation tEmployerLocation
			on	rfHumanCase.idfEmployerAddress = tEmployerLocation.idfGeoLocation
 	 left join	fnGisReference(@LangID, 19000001 /*'rftCountry'*/) rfEmployerCountry 
			on	rfEmployerCountry.idfsReference = tEmployerLocation.idfsCountry
	 left join	fnGisReference(@LangID, 19000003 /*'rftRegion'*/)  rfEmployerRegion 
			on	rfEmployerRegion.idfsReference = tEmployerLocation.idfsRegion
	 left join	fnGisReference(@LangID, 19000002 /*'rftRayon'*/)   rfEmployerRayon 
			on	rfEmployerRayon.idfsReference = tEmployerLocation.idfsRayon
	 left join	fnGisReference(@LangID, 19000004 /*'rftSettlement'*/) rfEmployerSettlement
			on	rfEmployerSettlement.idfsReference = tEmployerLocation.idfsSettlement

	-- Get sent by office name
	 left join  fnInstitution(@LangID) as SendByOffice
		on  SendByOffice.idfOffice = rfHumanCase.idfSentByOffice
	-- Get investigated by office name
	 left join  fnInstitution(@LangID) as InvestigatedByOffice
		on  InvestigatedByOffice.idfOffice = rfHumanCase.idfInvestigatedByOffice
	-- Get Sought Care Facility
	 left join  fnInstitution(@LangID) as SoughtCareFacility
		on  SoughtCareFacility.idfOffice = rfHumanCase.idfSoughtCareFacility
	-- Get current location - Hospital
	 left join  fnInstitution(@LangID) as CurrentLocationOffice
		on  CurrentLocationOffice.idfOffice = rfHumanCase.idfHospital	
	
			
	-- Get Case status
	 left join  fnReferenceRepair(@LangID, 19000111 /*'rftCaseProgressStatus'*/)		as rfCaseProgerssStatus
			on  rfCaseProgerssStatus.idfsReference = rfHumanCase.idfsCaseProgressStatus
	-- Get Case classification
	 left join  fnReferenceRepair(@LangID, 19000011 /*'rftCaseStatus'*/)		as rfCaseStatus
			on  rfCaseStatus.idfsReference = rfHumanCase.idfsCaseStatus
	 left join  fnReferenceRepair(@LangID, 19000011 /*'rftCaseStatus'*/)		as rfInitialCaseStatus
			on  rfInitialCaseStatus.idfsReference = rfHumanCase.idfsInitialCaseStatus
	-- Get Nationality
	 left join	fnReferenceRepair(@LangID, 19000054 /*'rftNationality'*/)		as rfNationality
			on	rfNationality.idfsReference = rfHumanCase.idfsNationality
	-- Get HospitalizationStatus
	 left join	fnReferenceRepair(@LangID, 19000041 /*'rftHospStatus'*/)		as rfHospitalizationStatus
			on	rfHospitalizationStatus.idfsReference = rfHumanCase.idfsHospitalizationStatus
	-- Get OcupationType
	 left join	fnReferenceRepair(@LangID, 19000061 /*'rftOccupationType'*/)	as rfOccupationType
			on	rfOccupationType.idfsReference = rfHumanCase.idfsOccupationType
	-- Get is Hospitalisation
	 left join	fnReferenceRepair(@LangID, 19000100 /*'rftYesNoValue'*/)		as rfHospitalisationYN
			on  rfHospitalisationYN.idfsReference = rfHumanCase.idfsYNHospitalization
	-- Get is SpecimenCollected
	 left join	fnReferenceRepair(@LangID, 19000100 /*'rftYesNoValue'*/)		as rfSpecimenCollectedYN
			on  rfSpecimenCollectedYN.idfsReference=rfHumanCase.idfsYNSpecimenCollected
	-- Get is AntimicrobialTherapy
	 left join	fnReferenceRepair(@LangID, 19000100 /*'rftYesNoValue'*/)		as rfTherapyYN
			on  rfTherapyYN.idfsReference=rfHumanCase.idfsYNAntimicrobialTherapy
	-- Get is RelatedToOutbreak
	 left join	fnReferenceRepair(@LangID, 19000100 /*'rftYesNoValue'*/)		as rfRelatedToOutbreakYN
			on  rfRelatedToOutbreakYN.idfsReference=rfHumanCase.idfsYNRelatedToOutbreak
	-- Get is Outcome
	 left join	fnReferenceRepair(@LangID, 19000064 /*'rftOutcome'*/) as rfOutcome
			on	rfOutcome.idfsReference=rfHumanCase.idfsOutcome
	-- Get Outbreak
	 left join	dbo.tlbOutbreak as tOutbreak
			on	tOutbreak.idfOutbreak = rfHumanCase.idfOutbreak
	 left join	tlbHumanCase as tHumanCase
	 on  tHumanCase.idfHumanCase = @ObjID
	
	-- Filter condition
		where	@ObjID = rfHumanCase.idfCase

