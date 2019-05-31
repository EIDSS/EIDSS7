
 
 --##SUMMARY Select data for 60B Journal.
 --##REMARKS Author: 
 --##REMARKS Create date: 17.01.2011
 
 --##REMARKS UPDATED BY: Romasheva S/
 --##REMARKS Date: 23.07.2014
 
 --##REMARKS UPDATED BY: Romasheva S/
 --##REMARKS Date: 31.07.2015
 
 --##RETURNS Doesn't use
 
 /*
 --Example of a call of procedure:
 
 exec spRepJournal60B_test 'ka', '20150101', '20151231', 9844050000000, 1101
 
 exec spRepJournal60B_test 'en', '20150101', '20151231', 9844050000000, 1101


 exec spRepJournal60B 'ka', '20150101', '20151231', 9844050000000, 1101
 
 exec spRepJournal60B 'en', '20150101', '20151231', 9844050000000, 1101

 exec spRepJournal60B 'en', '20150101', '20151231', 9843380000000, 1100
 */
 
 CREATE  Procedure [dbo].[spRepJournal60B]
 	(
 		@LangID		as nvarchar(10), 
 		@StartDate	as datetime,	 
 		@FinishDate	as datetime,
 		@Diagnosis	as bigint	=null,		-- filter value ofa drop-down list of all diseases accounted in EIDSS as case-based diseases with HA Code �Human� or �Human, Livestock� or �Human, Avian� or �Human, Avian, Livestock� (non-mandatory field).
 		@SiteID		as bigint = null
 	)
 AS	
 
 -- Field description may be found here
 -- "https://repos.btrp.net/BTRP/Project_Documents/08x-Implementation/Customizations/GG/Reports/Specification for report development - 60B Journal Human GG v1.0.doc"
 -- by number marked red at screen form prototype 
 
 declare	@ReportTable 	table
 (	
 	strName						nvarchar(2000), --2	
 	strAge						nvarchar(2000), --3
 	strGender					nvarchar(2000), --4
 	strAddress					nvarchar(2000), --5
 	strPlaceOfStudyWork			nvarchar(2000), --6
 	datDiseaseOnsetDate			datetime, --7
 	datDateOfFirstPresentation		datetime, --8
 	strFacilityThatSentNotification NVARCHAR(2000), --9
 	strProvisionalDiagnosis			nvarchar(2000), --10
 	datDateProvisionalDiagnosis		datetime, --11
 	datDateSpecificTreatment		datetime, --12
 	datDateSpecimenTaken			nvarchar(max), --13
 	strResultAndDate			nvarchar(max), --14
 	strVaccinationStatus		nvarchar(2000), --15
 	datDateCaseInvestigation	datetime, --16
 	strFinalDS					nvarchar(2000), --17
 	strFinalClassification		nvarchar(2000), --18
 	datDateFinalDS				datetime, --19
 	strOutcome					nvarchar(2000), --20
 	strCaseStatus				nvarchar(2000), --24
 	strComments					nvarchar(2000), --25
 	strCaseID					nvarchar(200),
 	-- todo: fill this new field:
 	datEntredDate				datetime  -- for sorting in EIDSS
 )	
 
 print ISNULL(@SiteID, dbo.fnSiteID())
 
 declare	@OutbreakID	nvarchar(300)
 select	@OutbreakID = IsNull(RTrim(r.[name]) + N' ', N'')
 from	fnReferenceRepair(@LangID, 19000132) r	-- Additional report Text
 where	r.strDefault = N'Outbreak ID'
 print @OutbreakID
 
 declare	@CurrentResidence	nvarchar(300)
 select	@CurrentResidence = IsNull(RTrim(r.[name]) + N' ' , N'') 
 from	fnReferenceRepair(@LangID, 19000132) r	-- Additional report Text
 where	r.strDefault = N'Current Residence:'
 
 print @CurrentResidence
 
 declare	@PermanentResidence	nvarchar(300)
 select	@PermanentResidence = IsNull(RTrim(r.[name]) + N' ' , N'') 
 from	fnReferenceRepair(@LangID, 19000132) r	-- Additional report Text
 where	r.strDefault = N'Permanent Residence:'
 
 print @PermanentResidence
 
 declare 
	 @OPV5field bigint
	,@OPV4field bigint
	,@OPV3field bigint
	,@OPV2field bigint
	,@OPV1field bigint
	,@Thirdfield bigint
	,@Secondfield bigint
	,@Firstfield bigint 
	,@NumberOfImmunizationsReceived bigint
	,@ArePatientsImmunizationRecordsAvailable bigint
	,@WasSpecificVaccinationAdministered bigint
	,@VaccinatedAgainstRubella bigint
	,@NumberOfReceivedDoses_WithDiphtheriaComponent bigint
	,@RabiesVaccineGiven bigint
	,@NumberOfReceivedDoses_WithMeaslesComponent bigint
	,@HibVaccinationStatus bigint
	,@NumberOfReceivedDoses_WithMumpsComponent bigint
	,@MothersTetanusToxoidHistoryPriorToChildsDisease bigint
	,@NumberOfReceivedDoses_WithPertussisComponent bigint
	,@NumberOfReceivedDoses_WithRubellaComponent bigint
	,@IncludeDosesOfALLTetanusContainingToxoids bigint
	,@WasVaccinationAdministered bigint
	,@Revaccination bigint
	,@DateOfVaccination bigint
	,@DateOfRevaccination bigint
	,@ImmunizationHistory_DateOfLastVaccination bigint
	,@SpecificVaccination_DateOfLastVaccination bigint
	,@IfYes_IndicateDatesOfDoses bigint
	,@IfYes_NumberOfVaccinesReceived bigint
	,@IntervalSinceLastTetanusToxoidDose bigint
	,@DateOfLastOPVDoseReceived bigint
	,@NameVaccine bigint
	
	--NEW!!!
	--Is patient vaccinated against leptospirosis?
	,@IsPatientVaccinatedAgainstLeptospirosis bigint
	
	--Date of vaccination of patient against leptospirosis
	,@DateOfVaccinationOfPatientAgainstLeptospirosis bigint


	--NEW!!! 22.06.2016
	--Rabies vaccine dose
	,@RabiesVaccineDose bigint
	
	--Rabies vaccination date
	,@RabiesVaccinationDate bigint

	--HEI S. pneumonae caused infection GG: S. pneumonae vaccination status
	,@PneumonaeVaccinationStatus bigint
	
	--HEI S. pneumonae caused infection GG: Number of received doses of S. pneumonae vaccine
	,@PneumonaeNumberReceivedDoses bigint
	
	--HEI S. pneumonae caused infection GG: Date of last vaccination
	,@PneumonaeDateLastVaccination bigint
	
	--HEI Acute Viral Hepatitis A GG: Number of received doses of Hepatitis A vaccine
	,@HepatitisANumberReceivedDoses bigint
	
	--HEI Acute Viral Hepatitis A GG: Date of last vaccination
	,@HepatitisADateLastVaccination bigint


	,@Section_AdditionalOPVdoses bigint
	,@Section_Maternalhistory bigint

	,@PVT_Immunization3 bigint
	,@PVT_Immunization5 bigint
	,@PVT_VaccineTypes bigint
	,@PVT_OPVDoses bigint
	,@PVT_Y_N_Unk bigint
     
     
	,@ft_HEI_Acute_viral_hepatitis_B_GG bigint
	,@ft_HEI_AFP_Acute_poliomyelitis_GG bigint
	,@ft_HEI_Anthrax_GG bigint
	,@ft_HEI_Botulism_GG bigint
	,@ft_HEI_Brucellosis_GG bigint
	,@ft_HEI_CRS_GG bigint
	,@ft_HEI_Congenital_Syphilis_GG bigint
	,@ft_HEI_CCHF_GG bigint
	,@ft_HEI_Diphtheria_GG bigint
	,@ft_HEI_Gonococcal_Infection_GG bigint
	,@ft_HEI_Bacterial_Meningitis_GG bigint
	,@ft_HEI_HFRS_GG bigint
	,@ft_HEI_Influenza_Virus_GG bigint
	,@ft_HEI_Measles_GG bigint
	,@ft_HEI_Mumps_GG bigint
	,@ft_HEI_Pertussis_GG bigint
	,@ft_HEI_Plague_GG bigint
	,@ft_HEI_Post_vaccination_unusual_reactions_and_complications_GG bigint
	,@ft_HEI_Rabies_GG bigint
	,@ft_HEI_Rubella_GG bigint
	,@ft_HEI_Smallpox_GG bigint
	,@ft_HEI_Syphilis_GG bigint
	,@ft_HEI_Tetanus_GG bigint
	,@ft_HEI_TBE_GG bigint
	,@ft_HEI_Tularemia_GG bigint
	,@ft_UNI_HEI_GG bigint
	--NEW!!!
	,@ft_HEI_Leptospirosis_GG bigint
	--NEW!!! 22.06.2016
	,@ft_HEI_Pneumonae_GG bigint
	,@ft_HEI_Acute_Viral_Hepatitis_A_GG bigint

    
	,@DG_MotherTtetanusToxoidHistoryPriorToChildDisease bigint

	,@idfsCustomReportType bigint
 
 
set @idfsCustomReportType = 10290013 --GG 60B Journal


select @OPV5field = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'OPV5field'
and intRowStatus = 0

select @OPV4field = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'OPV4field'
and intRowStatus = 0

select @OPV3field = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'OPV3field'
and intRowStatus = 0

select @OPV2field = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'OPV2field'
and intRowStatus = 0

select @OPV1field = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'OPV1field'
and intRowStatus = 0

select @Thirdfield = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'Thirdfield'
and intRowStatus = 0

select @Secondfield = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'Secondfield'
and intRowStatus = 0

select @Firstfield = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'Firstfield'
and intRowStatus = 0

select @NumberOfImmunizationsReceived = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'NumberOfImmunizationsReceived'
and intRowStatus = 0

select @ArePatientsImmunizationRecordsAvailable = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ArePatientsImmunizationRecordsAvailable'
and intRowStatus = 0

select @WasSpecificVaccinationAdministered = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'WasSpecificVaccinationAdministered'
and intRowStatus = 0

select @VaccinatedAgainstRubella = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'VaccinatedAgainstRubella'
and intRowStatus = 0

select @NumberOfReceivedDoses_WithDiphtheriaComponent = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'NumberOfReceivedDoses_WithDiphtheriaComponent'
and intRowStatus = 0

select @RabiesVaccineGiven = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'RabiesVaccineGiven'
and intRowStatus = 0

select @NumberOfReceivedDoses_WithMeaslesComponent = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'NumberOfReceivedDoses_WithMeaslesComponent'
and intRowStatus = 0

select @HibVaccinationStatus = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'HibVaccinationStatus'
and intRowStatus = 0

select @NumberOfReceivedDoses_WithMumpsComponent = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'NumberOfReceivedDoses_WithMumpsComponent'
and intRowStatus = 0

select @MothersTetanusToxoidHistoryPriorToChildsDisease = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'MothersTetanusToxoidHistoryPriorToChildsDisease'
and intRowStatus = 0

select @NumberOfReceivedDoses_WithPertussisComponent = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'NumberOfReceivedDoses_WithPertussisComponent'
and intRowStatus = 0

select @NumberOfReceivedDoses_WithRubellaComponent = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'NumberOfReceivedDoses_WithRubellaComponent'
and intRowStatus = 0

select @IncludeDosesOfALLTetanusContainingToxoids = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'IncludeDosesOfALLTetanusContainingToxoids'
and intRowStatus = 0

select @WasVaccinationAdministered = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'WasVaccinationAdministered'
and intRowStatus = 0

select @Revaccination = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'Revaccination'
and intRowStatus = 0

select @DateOfVaccination = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'DateOfVaccination'
and intRowStatus = 0

select @DateOfRevaccination = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'DateOfRevaccination'
and intRowStatus = 0

select @ImmunizationHistory_DateOfLastVaccination = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ImmunizationHistory_DateOfLastVaccination'
and intRowStatus = 0

select @SpecificVaccination_DateOfLastVaccination = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'SpecificVaccination_DateOfLastVaccination'
and intRowStatus = 0

select @IfYes_IndicateDatesOfDoses = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'IfYes_IndicateDatesOfDoses'
and intRowStatus = 0

select @IfYes_NumberOfVaccinesReceived = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'IfYes_NumberOfVaccinesReceived'
and intRowStatus = 0

select @IntervalSinceLastTetanusToxoidDose = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'IntervalSinceLastTetanusToxoidDose'
and intRowStatus = 0

select @DateOfLastOPVDoseReceived = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'DateOfLastOPVDoseReceived'
and intRowStatus = 0

select @NameVaccine = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'NameVaccine' --Vaccine type that caused post vaccination complications: Name of vaccine
and intRowStatus = 0

--NEW!!!
select @IsPatientVaccinatedAgainstLeptospirosis = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'IsPatientVaccinatedAgainstLeptospirosis'
and intRowStatus = 0

select @DateOfVaccinationOfPatientAgainstLeptospirosis = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'DateOfVaccinationOfPatientAgainstLeptospirosis'
and intRowStatus = 0

--NEW!!! 22.06.2016
select @RabiesVaccineDose = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'RabiesVaccineDose'
and intRowStatus = 0	

select @RabiesVaccinationDate = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'RabiesVaccinationDate'
and intRowStatus = 0		

select @PneumonaeVaccinationStatus = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'PneumonaeVaccinationStatus'
and intRowStatus = 0	
	
select @PneumonaeNumberReceivedDoses = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'PneumonaeNumberReceivedDoses'
and intRowStatus = 0	
	
select @PneumonaeDateLastVaccination = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'PneumonaeDateLastVaccination'
and intRowStatus = 0	
	
select @HepatitisANumberReceivedDoses = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'HepatitisANumberReceivedDoses'
and intRowStatus = 0		
	
select @HepatitisADateLastVaccination = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'HepatitisADateLastVaccination'
and intRowStatus = 0	

--select 
--@RabiesVaccineDose as RabiesVaccineDose
--,@RabiesVaccinationDate as RabiesVaccinationDate
--,@PneumonaeVaccinationStatus as PneumonaeVaccinationStatus
--,@PneumonaeNumberReceivedDoses as PneumonaeNumberReceivedDoses
--,@PneumonaeDateLastVaccination as PneumonaeDateLastVaccination
--,@HepatitisANumberReceivedDoses as HepatitisANumberReceivedDoses
--,@HepatitisADateLastVaccination as HepatitisADateLastVaccination




-- sections
select @Section_AdditionalOPVdoses = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'Section_AdditionalOPVdoses'
and intRowStatus = 0    
 
select @Section_Maternalhistory = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'Section_Maternalhistory'
and intRowStatus = 0

--parameter values type
select @PVT_Immunization3 = pt.idfsReferenceType from trtFFObjectForCustomReport pfc
	inner join dbo.ffParameterType  pt
	on pfc.idfsFFObject = pt.idfsParameterType
	and pt.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'PVT_Immunization3'
and pfc.intRowStatus = 0

select @PVT_Immunization5 = pt.idfsReferenceType from trtFFObjectForCustomReport pfc
	inner join dbo.ffParameterType  pt
	on pfc.idfsFFObject = pt.idfsParameterType
	and pt.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'PVT_Immunization5'
and pfc.intRowStatus = 0

select @PVT_VaccineTypes = pt.idfsReferenceType from trtFFObjectForCustomReport pfc
	inner join dbo.ffParameterType  pt
	on pfc.idfsFFObject = pt.idfsParameterType
	and pt.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'PVT_VaccineTypes'
and pfc.intRowStatus = 0

select @PVT_OPVDoses = pt.idfsReferenceType from trtFFObjectForCustomReport pfc
	inner join dbo.ffParameterType  pt
	on pfc.idfsFFObject = pt.idfsParameterType
	and pt.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'PVT_OPVDoses'
and pfc.intRowStatus = 0

select @PVT_Y_N_Unk = pt.idfsReferenceType from trtFFObjectForCustomReport pfc
	inner join dbo.ffParameterType  pt
	on pfc.idfsFFObject = pt.idfsParameterType
	and pt.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'PVT_Y_N_Unk'
and pfc.intRowStatus = 0
     

--Templates
--ft_HEI_Acute_viral_hepatitis_B_GG
select @ft_HEI_Acute_viral_hepatitis_B_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Acute_viral_hepatitis_B_GG'
and pfc.intRowStatus = 0

--ft_HEI_AFP_Acute_poliomyelitis_GG
select @ft_HEI_AFP_Acute_poliomyelitis_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_AFP_Acute_poliomyelitis_GG'
and pfc.intRowStatus = 0
	
--ft_HEI_Anthrax_GG
select @ft_HEI_Anthrax_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Anthrax_GG'
and pfc.intRowStatus = 0

--ft_HEI_Botulism_GG
select @ft_HEI_Botulism_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Botulism_GG'
and pfc.intRowStatus = 0

--ft_HEI_Brucellosis_GG
select @ft_HEI_Brucellosis_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Brucellosis_GG'
and pfc.intRowStatus = 0

--ft_HEI_CRS_GG
select @ft_HEI_CRS_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_CRS_GG'
and pfc.intRowStatus = 0

--ft_HEI_Congenital_Syphilis_GG
select @ft_HEI_Congenital_Syphilis_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Congenital_Syphilis_GG'
and pfc.intRowStatus = 0

--ft_HEI_CCHF_GG
select @ft_HEI_CCHF_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_CCHF_GG'
and pfc.intRowStatus = 0

--ft_HEI_Diphtheria_GG
select @ft_HEI_Diphtheria_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Diphtheria_GG'
and pfc.intRowStatus = 0

--ft_HEI_Gonococcal_Infection_GG
select @ft_HEI_Gonococcal_Infection_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Gonococcal_Infection_GG'
and pfc.intRowStatus = 0

--ft_HEI_Bacterial_Meningitis_GG
select @ft_HEI_Bacterial_Meningitis_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Bacterial_Meningitis_GG'
and pfc.intRowStatus = 0

--ft_HEI_HFRS_GG
select @ft_HEI_HFRS_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_HFRS_GG'
and pfc.intRowStatus = 0

--ft_HEI_Influenza_Virus_GG
select @ft_HEI_Influenza_Virus_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Influenza_Virus_GG'
and pfc.intRowStatus = 0

--ft_HEI_Measles_GG
select @ft_HEI_Measles_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Measles_GG'
and pfc.intRowStatus = 0

--ft_HEI_Mumps_GG
select @ft_HEI_Mumps_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Mumps_GG'
and pfc.intRowStatus = 0

--ft_HEI_Pertussis_GG
select @ft_HEI_Pertussis_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Pertussis_GG'
and pfc.intRowStatus = 0

--ft_HEI_Plague_GG
select @ft_HEI_Plague_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Plague_GG'
and pfc.intRowStatus = 0

--ft_HEI_Post_vaccination_unusual_reactions_and_comp
select @ft_HEI_Post_vaccination_unusual_reactions_and_complications_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Post_vaccination_unusual_reactions_and_comp'
and pfc.intRowStatus = 0

--ft_HEI_Rabies_GG
select @ft_HEI_Rabies_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Rabies_GG'
and pfc.intRowStatus = 0

--ft_HEI_Rubella_GG
select @ft_HEI_Rubella_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Rubella_GG'
and pfc.intRowStatus = 0

--ft_HEI_Smallpox_GG
select @ft_HEI_Smallpox_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Smallpox_GG'
and pfc.intRowStatus = 0

--ft_HEI_Syphilis_GG
select @ft_HEI_Syphilis_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Syphilis_GG'
and pfc.intRowStatus = 0

--ft_HEI_Tetanus_GG
select @ft_HEI_Tetanus_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Tetanus_GG'
and pfc.intRowStatus = 0

--ft_HEI_TBE_GG
select @ft_HEI_TBE_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_TBE_GG'
and pfc.intRowStatus = 0

--ft_HEI_Tularemia_GG
select @ft_HEI_Tularemia_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Tularemia_GG'
and pfc.intRowStatus = 0

--ft_UNI_HEI_GG
select @ft_UNI_HEI_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_UNI_HEI_GG'
and pfc.intRowStatus = 0

--NEW!!!
--ft_HEI_Leptospirosis_GG
select @ft_HEI_Leptospirosis_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Leptospirosis_GG'
and pfc.intRowStatus = 0


--NEW!!! 22.06.2016
--@ft_HEI_Pneumonae_GG 
select @ft_HEI_Pneumonae_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Pneumonae_GG'
and pfc.intRowStatus = 0
	
--@ft_HEI_Acute_Viral_Hepatitis_A_GG 
select @ft_HEI_Acute_Viral_Hepatitis_A_GG = ft.idfsFormTemplate 
from trtFFObjectForCustomReport pfc
	inner join ffFormTemplate ft
	on pfc.idfsFFObject = ft.idfsFormTemplate
	and ft.intRowStatus = 0
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ft_HEI_Acute_Viral_Hepatitis_A_GG'
and pfc.intRowStatus = 0	

--select 
--	 @ft_HEI_Acute_viral_hepatitis_B_GG 
--	,@ft_HEI_AFP_Acute_poliomyelitis_GG 
--	,@ft_HEI_Anthrax_GG 
--	,@ft_HEI_Botulism_GG 
--	,@ft_HEI_Brucellosis_GG 
--	,@ft_HEI_CRS_GG 
--	,@ft_HEI_Congenital_Syphilis_GG 
--	,@ft_HEI_CCHF_GG 
--	,@ft_HEI_Diphtheria_GG 
--	,@ft_HEI_Gonococcal_Infection_GG 
--	,@ft_HEI_Bacterial_Meningitis_GG 
--	,@ft_HEI_HFRS_GG 
--	,@ft_HEI_Influenza_Virus_GG 
--	,@ft_HEI_Measles_GG 
--	,@ft_HEI_Mumps_GG 
--	,@ft_HEI_Pertussis_GG 
--	,@ft_HEI_Plague_GG 
--	,@ft_HEI_Post_vaccination_unusual_reactions_and_complications_GG 
--	,@ft_HEI_Rabies_GG 
--	,@ft_HEI_Rubella_GG 
--	,@ft_HEI_Smallpox_GG 
--	,@ft_HEI_Syphilis_GG 
--	,@ft_HEI_Tetanus_GG 
--	,@ft_HEI_TBE_GG 
--	,@ft_HEI_Tularemia_GG 
--	,@ft_UNI_HEI_GG 
--	,@ft_HEI_Leptospirosis_GG  as ft_HEI_Leptospirosis_GG
--	,@ft_HEI_Pneumonae_GG as ft_HEI_Pneumonae_GG
--	,@ft_HEI_Acute_Viral_Hepatitis_A_GG as ft_HEI_Acute_Viral_Hepatitis_A_GG
	

---- Diagnosis groups
  
--DG_MotherTtetanusToxoidHistoryPriorToChildDisease
select @DG_MotherTtetanusToxoidHistoryPriorToChildDisease = dg.idfsReportDiagnosisGroup
from dbo.trtReportDiagnosisGroup dg
where dg.intRowStatus = 0 and
   dg.strDiagnosisGroupAlias = 'DG_MotherTtetanusToxoidHistoryPriorToChildDisease'      
    

      
      
 
 INSERT INTO @ReportTable (
 	strName,
 	strAge,
 	strGender,
 	strAddress,
 	strPlaceOfStudyWork,
 	datDiseaseOnsetDate,
 	datDateOfFirstPresentation,
 	strFacilityThatSentNotification,
 	strProvisionalDiagnosis,
 	datDateProvisionalDiagnosis,
 	datDateSpecificTreatment,
 	datDateSpecimenTaken,
 	strResultAndDate,
 	strVaccinationStatus,
 	datDateCaseInvestigation,
 	strFinalDS,
 	strFinalClassification,
 	datDateFinalDS,
 	strOutcome,
 	strCaseStatus,
 	strComments,
 	strCaseID
 ) 
 SELECT
   dbo.fnConcatFullName(h.strLastName, h.strFirstName, h.strSecondName) AS strName,
   CAST(hc.intPatientAge AS VARCHAR(10)) + N' (' + ref_AgeType.[name] + N')' +
     CASE WHEN	(IsNull(hc.intPatientAge, 100) < 15 AND  IsNull(hc.idfsHumanAgeType, 10042003) = 10042003 /*years*/)
 				or (IsNull(hc.idfsHumanAgeType, 10042003) <> 10042003 /*years*/)
          THEN IsNull(N', ' + CONVERT(varchar(10), h.datDateofBirth , 104), N'')
          ELSE N'' 
     END AS strAge,
   ref_hg.[name] AS strGender,
   IsNull(@CurrentResidence, N'') + 
 		dbo.fnCreateAddressString
 				(	gl_cr.Country,
 					gl_cr.Region,
 					gl_cr.Rayon,
 					gl_cr.PostalCode,
 					gl_cr.SettlementType,
 					gl_cr.Settlement,
 					gl_cr.Street,
 					gl_cr.House,
 					gl_cr.Building,
 					gl_cr.Appartment,
 					gl_cr.blnForeignAddress,
 					gl_cr.strForeignAddress
 				) +
     CASE WHEN dbo.fnCreateAddressString
 				(	gl_cr.Country,
 					gl_cr.Region,
 					gl_cr.Rayon,
 					gl_cr.PostalCode,
 					gl_cr.SettlementType,
 					gl_cr.Settlement,
 					gl_cr.Street,
 					gl_cr.House,
 					gl_cr.Building,
 					gl_cr.Appartment,
 					gl_cr.blnForeignAddress,
 					gl_cr.strForeignAddress
 				) <> 
 			dbo.fnCreateAddressString
 				(	gl_r.Country,
 					gl_r.Region,
 					gl_r.Rayon,
 					gl_r.PostalCode,
 					gl_r.SettlementType,
 					gl_r.Settlement,
 					gl_r.Street,
 					gl_r.House,
 					gl_r.Building,
 					gl_r.Appartment,
 					gl_r.blnForeignAddress,
 					gl_r.strForeignAddress
 				)
 				and IsNull(gl_r.Region, N'') <> N''
          THEN '; ' +  IsNull(@PermanentResidence, N'') + 
 				dbo.fnCreateAddressString
 						(	gl_r.Country,
 							gl_r.Region,
 							gl_r.Rayon,
 							gl_r.PostalCode,
 							gl_r.SettlementType,
 							gl_r.Settlement,
 							gl_r.Street,
 							gl_r.House,
 							gl_r.Building,
 							gl_r.Appartment,
 							gl_r.blnForeignAddress,
 							gl_r.strForeignAddress
 						)
 		ELSE N''
     END AS strAddress,
   IsNull(case when h.strEmployerName = '' then null else h.strEmployerName end + '; ', N'') + 
     CASE WHEN IsNull(gl_em.Region, N'') <> N''
          THEN 		IsNull(dbo.fnCreateAddressString
 					(	gl_em.Country,
 						gl_em.Region,
 						gl_em.Rayon,
 						gl_em.PostalCode,
 						gl_em.SettlementType,
 						gl_em.Settlement,
 						gl_em.Street,
 						gl_em.House,
 						gl_em.Building,
 						gl_em.Appartment,
 						gl_em.blnForeignAddress,
 						gl_em.strForeignAddress
 					), '')
 		ELSE N''
 	END AS   strPlaceOfStudyWork,
   hc.datOnSetDate AS datDiseaseOnsetDate,
   hc.datFirstSoughtCareDate AS datDateOfFirstPresentation,
   ISNULL(fi.name, '') + 
 	ISNULL(', ' + tp.strFamilyName, '') + ISNULL(' ' + tp.strFirstName, '') + ISNULL(' ' + tp.strSecondName, '') + 
     ISNULL(', ' + CONVERT(varchar(10),hc.datNotificationDate, 104),'') AS strFacilityThatSentNotification,
   ref_diag.[name] AS strProvisionalDiagnosis,
   hc.datTentativeDiagnosisDate AS datDateProvisionalDiagnosis,
   CASE WHEN hc.idfsYNAntimicrobialTherapy = 10100001 THEN
         (SELECT TOP 1 a.datFirstAdministeredDate 
           FROM tlbAntimicrobialTherapy a
           WHERE a.idfHumanCase = hc.idfHumanCase 
 				and a.intRowStatus = 0
           ORDER BY 1 ASC)
      ELSE NULL END AS datDateSpecificTreatment,
 	CAST((SELECT 	
   	          ref_st_collected.[name] +
   	          ISNULL(', ' + CONVERT(VARCHAR, m_collected.datFieldCollectionDate, 103), '') + '; '
 			FROM tlbMaterial m_collected
 			inner join	fnReferenceRepair(@LangID, 19000087 /*rftSpecimenType*/) ref_st_collected
   						ON ref_st_collected.idfsReference = m_collected.idfsSampleType
 			WHERE m_collected.idfHuman = h.idfHuman
 				and m_collected.idfHumanCase = hc.idfHumanCase
 				and m_collected.blnShowInLabList = 1
 					and m_collected.intRowStatus = 0
 					
 			order by	m_collected.datFieldCollectionDate 	                
   	        for xml path('')		
     ) AS NVARCHAR(MAX))  AS datDateSpecimenTaken,
 	CAST((SELECT 	
   	          ref_st.[name] +
   	          ISNULL(', ' + ref_tt.[name], '') +
   	          ISNULL(', ' + ref_tr.[name], '') +
   	          ISNULL(', ' + CONVERT(VARCHAR, b.datValidatedDate, 103), '') + '; '
   	        FROM	(
 				tlbTesting t
   	            INNER JOIN fnReferenceRepair(@LangID, 19000097 /*rftTestName*/)  AS ref_tt
   	            ON ref_tt.idfsReference = t.idfsTestName
 					)
 			inner join	(
 				tlbMaterial m
   	                INNER JOIN fnReferenceRepair(@LangID, 19000087 /*rftSpecimenType*/) ref_st
   	                ON ref_st.idfsReference = m.idfsSampleType
 						)
   	            ON m.idfMaterial = t.idfMaterial AND
   	               m.intRowStatus = 0
   	            LEFT OUTER JOIN tlbBatchTest b
   	            ON t.idfBatchTest = b.idfBatchTest
 					and b.intRowStatus = 0
   	            
   	            LEFT JOIN fnReferenceRepair(@LangID, 19000096 /*rftTestResult*/)  AS ref_tr
   	            ON ref_tr.idfsReference = t.idfsTestResult
   	         WHERE t.intRowStatus = 0 AND
   	                m.idfHuman = h.idfHuman
   	        order by	b.datValidatedDate
   	        for xml path('')		
     ) AS NVARCHAR(MAX))  AS strResultAndDate,
   --------------------------------------------------------------------------------------------------------------------
   CASE 
 --------------------
     /*Number of immunizations received + Date of last vaccination*/ 
     WHEN obs.idfsFormTemplate in (@ft_HEI_Acute_viral_hepatitis_B_GG) 
         THEN ISNULL(ref_ap1.name + ', ','') + CONVERT(VARCHAR(10), CAST(ap18.varValue AS DATETIME), 103) 
 --------------------    
     /*Are patient is immunization records available*/    
     WHEN obs.idfsFormTemplate in (@ft_HEI_AFP_Acute_poliomyelitis_GG) 
         /*
			Show the following string "{1} [- {2} - {3}; ][[{4}: {5} - {6}; ]]{7}", 
			where {1} is the value of the parameter with tooltip "Are patient's immunization records available";
			{2} is the tooltip of the first not blank parameter with a value different 
				from "Unknown", which is taken from the following list 
				in specified order: "OPV-5", "OPV-4", "OPV-3", "OPV-2", and "OPV-1";
			{3} is the value of the parameter selected for {2};
			{4} is the name of the section with full 
				path “Immunization history>Additional OPV doses received during mass campaigns”;
			{5} is the tooltip of the first not blank parameter with a value different 
				from "Unknown", which is taken from the following list in specified order: 
				"Third additional OPV dose", "Second additional OPV dose", "First additional OPV dose";
			{6} is the value of the parameter selected for {5};
			{7} is the value of the parameter with tooltip "Date of last OPV dose received";
			and the parts [...] and [[...]] are optional and depend on the following conditions:
			- the part [...] shall be displayed if {1} is equal to "Yes"
			- the part [[...]] shall be displayed if {6} is not blank;
			the square brackets that indicate the beginning and end of the optional parts 
			shall not be displayed in the report
		*/
         THEN 
             /*{1} -*/
              ISNULL(ref_ap2.name + '- ', '')
             /*{2} - {3};*/  
              +
              CASE WHEN ref_ap2.idfsReference = 10100001 /*yes*/
                   THEN 
                     CASE WHEN ref_ap26.name IS NOT NULL AND ref_ap26.idfsReference <> 995360000000 /*Unknown*/ 
                          THEN (SELECT [name] 
                                 FROM fnReferenceRepair(@LangID, 19000066/*rftParameter*/) 
                                 WHERE idfsReference = @OPV5field -- /*"OPV-5" field*/
                                ) + '-' + ref_ap26.name + '; '
                          ELSE
                          CASE WHEN ref_ap25.name IS NOT NULL AND ref_ap25.idfsReference <> 995360000000 /*Unknown*/ 
                              THEN (SELECT [name] 
                                     FROM fnReferenceRepair(@LangID, 19000066/*rftParameter*/) 
                                     WHERE idfsReference = @OPV4field -- /*"OPV-4" field*/
                                    ) + '-' + ref_ap25.name + '; '
                              ELSE
                              CASE WHEN ref_ap24.name IS NOT NULL AND ref_ap24.idfsReference <> 995360000000 /*Unknown*/ 
                                  THEN (SELECT [name] 
                                         FROM fnReferenceRepair(@LangID, 19000066/*rftParameter*/) 
                                         WHERE idfsReference = @OPV3field -- /*"OPV-3" field*/
                                        ) + '-' + ref_ap24.name + '; '
                                  ELSE
                                  CASE WHEN ref_ap23.name IS NOT NULL AND ref_ap23.idfsReference <> 995360000000 /*Unknown*/ 
                                      THEN (SELECT [name] 
                                             FROM fnReferenceRepair(@LangID, 19000066/*rftParameter*/) 
                                             WHERE idfsReference = @OPV2field -- /*"OPV-2" field*/
                                            ) + '-' + ref_ap23.name + '; '
                                      ELSE
                                      CASE WHEN ref_ap22.name IS NOT NULL AND ref_ap22.idfsReference <> 995360000000 /*Unknown*/ 
                                          THEN (SELECT [name] 
                                                 FROM fnReferenceRepair(@LangID, 19000066/*rftParameter*/) 
                                                 WHERE idfsReference = @OPV1field -- /*"OPV-1" field*/
                                                ) + '-' + ref_ap22.name + '; '
                                          ELSE ''
                                      END /*OPV-1*/                                      
                                  END /*OPV-2*/                              
                              END /*OPV-3*/                              
                          END /*OPV-4*/   
                      END /*OPV-5*/          
                   ELSE ''
              END --CASE WHEN ref_ap2.idfsReference = 10100001 /*yes*/    
             /* {4} : */  
              +
              CASE WHEN ref_ap29.name /*"Third" field*/ IS NOT NULL OR 
                        ref_ap28.name /*"Second" field*/ IS NOT NULL OR
                        ref_ap27.name /*"First" field*/ IS NOT NULL
                   THEN (SELECT snt.strTextString FROM trtStringNameTranslation snt
                            WHERE snt.idfsBaseReference = @Section_AdditionalOPVdoses /*section name - Additional OPV doses received during mass campaigns*/
                                   AND snt.idfsLanguage = dbo.fnGetLanguageCode(@LangID) 
                                   AND snt.intRowStatus = 0                
                         ) + ':' +
                             /*{5} - {6}; */  
                             CASE WHEN ref_ap29.name IS NOT NULL AND ref_ap29.idfsReference <> 995360000000 /*Unknown*/ 
                                  THEN (SELECT [name] 
                                         FROM fnReferenceRepair(@LangID, 19000066/*rftParameter*/) 
                                         WHERE idfsReference = @Thirdfield -- /*"Third" field*/
                                        ) + '-' + ref_ap29.name
                                  ELSE
                                  CASE WHEN ref_ap28.name IS NOT NULL AND ref_ap28.idfsReference <> 995360000000 /*Unknown*/ 
                                      THEN (SELECT [name] 
                                             FROM fnReferenceRepair(@LangID, 19000066/*rftParameter*/) 
                                             WHERE idfsReference = @Secondfield -- /*"Second" field*/
                                            ) + '-' + ref_ap28.name
                                      ELSE
                                      CASE WHEN ref_ap27.name IS NOT NULL AND ref_ap27.idfsReference <> 995360000000 /*Unknown*/ 
                                          THEN (SELECT [name] 
                                                 FROM fnReferenceRepair(@LangID, 19000066/*rftParameter*/) 
                                                 WHERE idfsReference = @Firstfield -- /*"First" field*/
                                                ) + '-' + ref_ap27.name
                                          ELSE ''
                                      END /*First*/               
                                  END /*Second*/
                              END /*Third*/  
                              /*7)*/
                              + '; '                       
                   ELSE ''
              END  
             /* {7} */  
              +    
             CONVERT(VARCHAR(10), CAST(ap30.varValue AS DATETIME), 103) 
 
 --------------------    
     /*Was specific vaccination administered? + Date of last vaccination*/
     WHEN  obs.idfsFormTemplate in  (
     									@ft_HEI_Anthrax_GG,
     									@ft_HEI_Botulism_GG,
     									@ft_HEI_Brucellosis_GG,
     									@ft_HEI_Congenital_Syphilis_GG,
     									@ft_HEI_CCHF_GG,    
     									@ft_HEI_Gonococcal_Infection_GG, 
     									@ft_HEI_HFRS_GG,
     									@ft_HEI_Plague_GG ,
     									@ft_HEI_Smallpox_GG,
     									@ft_HEI_Syphilis_GG,
     									@ft_HEI_TBE_GG,
     									@ft_HEI_Tularemia_GG   
     
									)
         THEN ISNULL(ref_ap3.name + ', ','') + CONVERT(VARCHAR(10), CAST(ap18_2.varValue AS DATETIME), 103) 
 --------------------    
     /*Vaccinated against rubella
		 name of section "Maternal history" then ":" then name of "Vaccinated against rubella" 
		 then "-" and value in "Vaccinated against rubella".*/    
     WHEN obs.idfsFormTemplate in  (
     									@ft_HEI_CRS_GG         
									)
         THEN (SELECT snt.strTextString FROM trtStringNameTranslation snt
                 WHERE snt.idfsBaseReference = @Section_Maternalhistory /*name of section "Maternal history"*/
                       AND snt.idfsLanguage = dbo.fnGetLanguageCode(@LangID) 
                       AND snt.intRowStatus = 0                
               ) + ':' + 
               (SELECT [name] 
                 FROM fnReferenceRepair(@LangID, 19000066/*rftParameter*/) 
                 WHERE idfsReference = @VaccinatedAgainstRubella
                ) + '-' +  ref_ap4.name
 --------------------    
     /* Number of received doses (any vaccine with diphtheria component) + Date of last vaccination
        1) value in "Number of received doses (any vaccine with diphtheria component)"; 
        2) if value in 1) is not blank then "," otherwise nothing; 
        3) value in "Immunization history: Date of last vaccination". 
     */    
     WHEN obs.idfsFormTemplate in  (
     									@ft_HEI_Diphtheria_GG         
									)
         
         THEN ISNULL(ref_ap5.name + ', ','') + CONVERT(VARCHAR(10), CAST(ap18.varValue AS DATETIME), 103) 
 --------------------    
     /*Hib vaccination status + If "Yes", number of vaccines received + Date of last vaccination
      1) value in "Hib vaccination status"; 
      2) if value in 1) is not blank then "," otherwise nothing;
      3) value in "Number of Hib vaccines received"; 
      4) if value in 3) is not blank then "," otherwise nothing; 
      5) value in "Immunization history: Date of last vaccination".
     */    
     WHEN obs.idfsFormTemplate in  (
     									@ft_HEI_Bacterial_Meningitis_GG         
									)
         THEN ISNULL(ref_ap8.name + ', ','') + 
              ISNULL(ref_ap20.name + ', ','') + 
              CONVERT(VARCHAR(10), CAST(ap18.varValue AS DATETIME), 103) 
 --------------------    
     /*Number of received doses (any vaccine with measles component) + Date of last vaccination
     1) value in "Number of received doses (any vaccine with measles component)"; 
     2) if value in 1) is not blank then "," otherwise nothing; 
     3) value in "Immunization history: Date of last vaccination".
     */    
     WHEN obs.idfsFormTemplate in  (
     									@ft_HEI_Measles_GG         
									)
         THEN ISNULL(ref_ap7.name + ', ','') + CONVERT(VARCHAR(10), CAST(ap18.varValue AS DATETIME), 103) 
--------------------    
     /*Number of received doses (any vaccine with mumps component) + Date of last vaccination
     1) value in "Number of received doses (any vaccine with mumps component)"; 
     2) if value in 1) is not blank then "," otherwise nothing; 
     3) value in "Immunization history: Date of last vaccination".
     */    
     WHEN obs.idfsFormTemplate in  (
     									@ft_HEI_Mumps_GG         
									)
         THEN ISNULL(ref_ap9.name+ ', ','') + CONVERT(VARCHAR(10), CAST(ap18.varValue AS DATETIME), 103)  
--------------------    
     /*Number of received doses (any vaccine with pertussis component) + Date of last vaccination
     1) value in "Number of received doses (any vaccine with pertussis component)";
     2) if value in 1) is not blank then "," otherwise nothing; 
     3) value in "Immunization history: Date of last vaccination".
     */    
     WHEN  obs.idfsFormTemplate in  (
     									@ft_HEI_Pertussis_GG         
									)
         THEN ISNULL(ref_ap11.name+ ', ','') + CONVERT(VARCHAR(10), CAST(ap18.varValue AS DATETIME), 103)
 --------------------    
     /*Vaccine type that caused post vaccination complications: Name of vaccine
     Show all distinct values from the column of the table section, 
     which is linked to the parameter tooltip "Vaccine type that caused post vaccination complications: Name of vaccine", 
     combined in the string of the following format: "{1};{2};{3}", where {n} is a unique value from the specified column.
     */    
     WHEN obs.idfsFormTemplate in  (
     									@ft_HEI_Post_vaccination_unusual_reactions_and_complications_GG         
									)
         THEN 
			cast(	(	select distinct
							isnull(ref_ap34.name + '; ', '') 
     	 				from	tlbObservation obs34
							 INNER JOIN tlbActivityParameters ap34
							 ON ap34.idfObservation = obs34.idfObservation AND
								ap34.idfsParameter = @NameVaccine /* Vaccine type that caused post vaccination complications: Name of vaccine*/ AND 
								ap34.intRowStatus = 0   
				 
							 LEFT JOIN fnReferenceRepair(@LangID, @PVT_VaccineTypes /*Vaccine types*/)  ref_ap34
							 ON ref_ap34.idfsReference = ap34.varValue
			     	 	where	obs34.idfObservation = hc.idfEpiObservation AND
								obs34.intRowStatus = 0  
					for	xml path('')
					) as nvarchar(max)
				)         	
 --------------------    
	-- UPDATED
     /*Show combination of following: 
     *	1) value in "Rabies vaccine given?"; 
     *	2) if value in 1) is not blank then ";" otherwise nothing; 
     *	3) value from "Rabies vaccine dose" field that corresponds the latest value in "Rabies vaccination date" field of table 
     *	section "Rabies Immunization Details" followed by ","; 
     *	4) respective value in "Rabies vaccination date" field.
     */    
     WHEN obs.idfsFormTemplate in  (
     									@ft_HEI_Rabies_GG         
									)
         THEN ISNULL(ref_ap6.name+ '; ','') + isnull(RabiesVacination.RabiesVaccinationDate + ', ', '') + isnull(RabiesVacination.RabiesVaccineDose, '')
---------------------   
     /*Number of received doses (any vaccine with rubella component) + Date of last vaccination
     1) value in "Number of received doses (any vaccine with rubella component)"; 
     2) if value in 1) is not blank then "," otherwise nothing; 
     3) value in "Immunization history: Date of last vaccination".
     */    
     WHEN obs.idfsFormTemplate in  (
     									@ft_HEI_Rubella_GG         
									)
         THEN ISNULL(ref_ap12.name+ ', ','')  + CONVERT(VARCHAR(10), CAST(ap18.varValue AS DATETIME), 103)       
                 
 --------------------    
     /*Mother's tetanus toxoid history prior to child's disease (known doses only) + Interval since last tetanus toxoid dose (years)
     For cases, where "Final Diagnosis" = "Neonatal Tetanus": show combination of following: 
     1) value in "Mother's tetanus toxoid history prior to child's disease (known doses only)"; 
     2) if value in 1) is not blank then ";" otherwise nothing; 
     3) value in "Interval since last tetanus toxoid dose (years) (mother's)"
     */    
     when	obs.idfsFormTemplate in		(
     										@ft_HEI_Tetanus_GG         
										) 
			and				
			COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) IN
			(select idfsDiagnosis 
				from dbo.trtDiagnosisToGroupForReportType 
				where idfsCustomReportType = @idfsCustomReportType
				and idfsReportDiagnosisGroup = @DG_MotherTtetanusToxoidHistoryPriorToChildDisease --"Final Diagnosis" = "Neonatal Tetanus"
			)
         THEN ISNULL(ref_ap10.name + '; ', '') + CAST(ap21.varValue AS NVARCHAR(300))
 --------------------    
     /*Include doses of ALL tetanus-containing toxoids. Exclude doses received after this particular injury + 
      Interval since last tetanus toxoid dose (years)
     For cases, where "Final Diagnosis" does not equal to "Neonatal Tetanus": show combination of following: 
     1) value in "Include doses of ALL tetanus-containing toxoids. Exclude doses received after this particular injury"; 
     2) if value in 1) is not blank then "," otherwise nothing 
     3) value in "Interval since last tetanus toxoid dose (years)".
     */    
     WHEN obs.idfsFormTemplate in		(
     										@ft_HEI_Tetanus_GG         
										) 
			and				
			COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) not IN
			(select idfsDiagnosis 
				from dbo.trtDiagnosisToGroupForReportType 
				where idfsCustomReportType = @idfsCustomReportType
				and idfsReportDiagnosisGroup = @DG_MotherTtetanusToxoidHistoryPriorToChildDisease --"Final Diagnosis" = "Neonatal Tetanus"
			)
         THEN ISNULL(ref_ap13.name  + '; ','') + CAST(ap21.varValue AS NVARCHAR(300))
         
 --------------------    
     /*Revaccination + Date of revaccination
     1)  if the value in "Revaccination" is "Yes" show the combination of the following:
     a) the value in "Revaccination"
     b) if the value in 1a) is not blank then "," otherwise nothing
     c) the value in "Date of revaccination" 
     */    
     WHEN  obs.idfsFormTemplate in		(
     										@ft_UNI_HEI_GG         
										)
         AND ref_ap15.idfsReference = 10100001
         THEN ISNULL(ref_ap15.name + ', ','') + CONVERT(VARCHAR(10), CAST(ap17.varValue AS DATETIME), 103)
 
 --------------------    
     /*Was vaccination administered? + Date of vaccination
     if the value in "Revaccination" is empty, or equals to "No", or "Unknown" show the combination of the following:
     a) the value in "Was vaccination administered?"
     b) if the value in 2a) is not blank then "," otherwise nothing
     c) the value in "Date of vaccination"
     */    
     WHEN obs.idfsFormTemplate in		(
     										@ft_UNI_HEI_GG         
										)
         AND ref_ap15.idfsReference <> 10100001
         THEN ISNULL(ref_ap14.name + ', ','') + CONVERT(VARCHAR(10), CAST(ap16.varValue AS DATETIME), 103)        
         
  
 
  --------------------    
  --NEW!!!
     /*Show combination of following: 
     *			1) value in "Is patient vaccinated against leptospirosis?"; 
     *			2) if value in 1) is not blank then "," otherwise nothing; 
     *			3) value in "Date of vaccination of patient against leptospirosis".
     */    
     WHEN obs.idfsFormTemplate in		(
     										@ft_HEI_Leptospirosis_GG         
										)
         THEN ISNULL(ref_ap31.name,'') + case when ref_ap31.name is not null and ap32.varValue is not null then ',' else '' end +   isnull( CONVERT(VARCHAR(10),CAST(ap32.varValue AS DATETIME), 103), '')      
         
  
 
  --------------------      
  --NEW!!!
     /*Show combination of following: 
     * 1) value in "HEI S. pneumonae caused infection GG: S. pneumonae vaccination status"; 
     * 2) if value in 1) is not blank then "," otherwise nothing; 
     * 3) value in "HEI S. pneumonae caused infection GG: Number of received doses of S. pneumonae vaccine"; 
     * 4) if value in 3) is not blank then "," otherwise nothing; 
     * 5) value in "HEI S. pneumonae caused infection GG: Date of last vaccination".
     */    
     WHEN obs.idfsFormTemplate in		(
     										@ft_HEI_Pneumonae_GG         
										)
         THEN ISNULL(ref_ap37.name, '') + ISNULL(', ' + ref_ap38.name, '') + isnull( ', ' + CONVERT(VARCHAR(10),CAST(ap39.varValue AS DATETIME), 103), '')      

  --------------------    
  --NEW!!!
     /*Show combination of following: 
     * 1) value in "HEI Acute Viral Hepatitis A GG: Number of received doses of Hepatitis A vaccine"; 
     * 2) if value in 1) is not blank then "," otherwise nothing; 
     * 3) value in "HEI Acute Viral Hepatitis A GG: Date of last vaccination".
     */    
     WHEN obs.idfsFormTemplate in		(
     										@ft_HEI_Acute_Viral_Hepatitis_A_GG         
										)
         THEN ISNULL(ref_ap40.name,'') + case when ref_ap40.name is not null and ap41.varValue is not null then ',' else '' end +   isnull( CONVERT(VARCHAR(10),CAST(ap41.varValue AS DATETIME), 103), '')      
         

  --------------------      
  
  
     ELSE NULL
   END AS strVaccinationStatus,
  
 ----------------------------------------------------------------------------------------------
   hc.datInvestigationStartDate AS datDateCaseInvestigation,
   ISNULL(ref_diag_f.[name], ref_diag.[name]) AS strFinalDS,
   isnull(ref_final_cs.[name], ref_init_cs.[name]) AS strFinalClassification,
   CASE WHEN hc.datFinalDiagnosisDate IS NULL AND ref_diag_f.idfsReference IS NULL 
         THEN hc.datTentativeDiagnosisDate
         ELSE hc.datFinalDiagnosisDate 
        END AS datDateFinalDS,
   ref_outcome.[name] +  CASE WHEN hc.idfsOutcome = 10760000000 /*outRecovered*/ 
                                 THEN ISNULL(', ' + CONVERT(VARCHAR(10),hc.datDischargeDate, 104), '')
                              WHEN hc.idfsOutcome = 10770000000 /*outDied*/ 
                                 THEN ISNULL(', ' + CONVERT(VARCHAR(10),h.datDateOfDeath, 104), '')
                              ELSE ''
                          END AS strOutcome      ,
   IsNull(@OutbreakID, N'') + o.strOutbreakID  AS  strCaseStatus,
 	IsNull(case when hc.strNote = '' then null else hc.strNote end + N'; ', N'') + 
 		ISNULL(case when hc.strClinicalNotes = '' then null else hc.strClinicalNotes end + N'; ', N'') + 
 		ISNULL(case when hc.strSummaryNotes = '' then null else hc.strSummaryNotes end + N';', N'') as strComments,
 ----------------------------------------------------------------------------------------------
          
   hc.strCaseID
   
 FROM tlbHumanCase hc
		INNER JOIN 
		(tlbHuman h
		   LEFT OUTER JOIN fnReferenceRepair(@LangID, 19000043/*rftHumanGender*/) ref_hg
		   ON ref_hg.idfsReference = h.idfsHumanGender
		    
		   left join		fnAddressAsRow(@LangID) gl_cr
					on			gl_cr.idfGeoLocation = h.idfCurrentResidenceAddress
		    
		   left join		fnAddressAsRow(@LangID) gl_r
					on			gl_r.idfGeoLocation = h.idfRegistrationAddress
		    
		   left join		fnAddressAsRow(@LangID) gl_em
					on			gl_em.idfGeoLocation = h.idfEmployerAddress
		)
		ON hc.idfHuman = h.idfHuman AND
		  h.intRowStatus = 0
             
             
         LEFT OUTER JOIN fnReferenceRepair(@LangID, 19000042/*rftHumanAgeType*/) ref_AgeType
         ON ref_AgeType.idfsReference = hc.idfsHumanAgeType
         
         INNER JOIN fnReferenceRepair(@LangID, 19000019/*rftDiagnosis*/) ref_diag
         ON ref_diag.idfsReference = hc.idfsTentativeDiagnosis
         
         LEFT OUTER JOIN fnReferenceRepair(@LangID, 19000019/*rftDiagnosis*/) ref_diag_f
         ON ref_diag_f.idfsReference = hc.idfsFinalDiagnosis
         
         LEFT OUTER JOIN fnReferenceRepair(@LangID, 19000011/*rftCaseStatus*/) ref_final_cs
         ON ref_final_cs.idfsReference = hc.idfsFinalCaseStatus
         
         LEFT OUTER JOIN fnReferenceRepair(@LangID, 19000011/*rftCaseStatus*/) ref_init_cs
         ON ref_init_cs.idfsReference = hc.idfsInitialCaseStatus
 
         LEFT OUTER JOIN fnReferenceRepair(@LangID, 19000064 /*rftOutcome*/) ref_outcome
         ON ref_outcome.idfsReference = hc.idfsOutcome
         
         LEFT OUTER JOIN tlbObservation obs
         ON obs.idfObservation = hc.idfEpiObservation AND
            obs.intRowStatus = 0
                     
         LEFT OUTER JOIN 
         (tlbObservation obs1
             INNER JOIN tlbActivityParameters ap1
             ON ap1.idfObservation = obs1.idfObservation AND
                ap1.idfsParameter = @NumberOfImmunizationsReceived --  /*Number of immunizations received*/ 
                AND ap1.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Immunization5 /*Immunization 5+*/)  ref_ap1
             ON ref_ap1.idfsReference = ap1.varValue 
         )
         ON obs1.idfObservation = hc.idfEpiObservation AND
            obs1.intRowStatus = 0
            
         LEFT OUTER JOIN 
         (tlbObservation obs2
             INNER JOIN tlbActivityParameters ap2
             ON ap2.idfObservation = obs2.idfObservation AND
                ap2.idfsParameter =  @ArePatientsImmunizationRecordsAvailable/* Are patient�s immunization records available*/ AND 
                ap2.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Y_N_Unk /*Y_N_Unk*/)  ref_ap2
             ON ref_ap2.idfsReference = ap2.varValue 
         )
         ON obs2.idfObservation = hc.idfEpiObservation AND
            obs2.intRowStatus = 0
      
         LEFT OUTER JOIN 
         (tlbObservation obs3
             INNER JOIN tlbActivityParameters ap3
             ON ap3.idfObservation = obs3.idfObservation AND
                ap3.idfsParameter =  @WasSpecificVaccinationAdministered/* Was specific vaccination administered?*/ AND 
                ap3.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Y_N_Unk /*Y_N_Unk*/)  ref_ap3
             ON ref_ap3.idfsReference = ap3.varValue 
         )
         ON obs3.idfObservation = hc.idfEpiObservation AND
            obs3.intRowStatus = 0  
               
         LEFT OUTER JOIN 
         (tlbObservation obs4
             INNER JOIN tlbActivityParameters ap4
             ON ap4.idfObservation = obs4.idfObservation AND
                ap4.idfsParameter =  @VaccinatedAgainstRubella/* Vaccinated against rubella*/ AND 
                ap4.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Y_N_Unk /*Y_N_Unk*/)  ref_ap4
             ON ref_ap4.idfsReference = ap4.varValue 
         )
         ON obs4.idfObservation = hc.idfEpiObservation AND
            obs4.intRowStatus = 0     
            
         LEFT OUTER JOIN 
         (tlbObservation obs5
             INNER JOIN tlbActivityParameters ap5
             ON ap5.idfObservation = obs5.idfObservation AND
                ap5.idfsParameter =  @NumberOfReceivedDoses_WithDiphtheriaComponent/* Number of received doses (any vaccine with diphtheria component)*/ AND 
                ap5.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Immunization5 /*Immunization 5+*/)  ref_ap5
             ON ref_ap5.idfsReference = ap5.varValue 
         )
         ON obs5.idfObservation = hc.idfEpiObservation AND
            obs5.intRowStatus = 0             
            
         LEFT OUTER JOIN 
         (tlbObservation obs6
             INNER JOIN tlbActivityParameters ap6
             ON ap6.idfObservation = obs6.idfObservation AND
                ap6.idfsParameter =  @RabiesVaccineGiven/* Rabies vaccine given?*/ AND 
                ap6.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Y_N_Unk /*Y_N_Unk*/)  ref_ap6
             ON ref_ap6.idfsReference = ap6.varValue 
         )
         ON obs6.idfObservation = hc.idfEpiObservation AND
            obs6.intRowStatus = 0             
            
            
         LEFT OUTER JOIN 
         (tlbObservation obs7
             INNER JOIN tlbActivityParameters ap7
             ON ap7.idfObservation = obs7.idfObservation AND
                ap7.idfsParameter =  @NumberOfReceivedDoses_WithMeaslesComponent/* Number of received doses (any vaccine with measles component)*/ AND 
                ap7.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Immunization3 /*Immunization 3+*/)  ref_ap7
             ON ref_ap7.idfsReference = ap7.varValue 
         )
         ON obs7.idfObservation = hc.idfEpiObservation AND
            obs7.intRowStatus = 0             
            
            
         LEFT OUTER JOIN 
         (tlbObservation obs8
             INNER JOIN tlbActivityParameters ap8
             ON ap8.idfObservation = obs8.idfObservation AND
                ap8.idfsParameter =  @HibVaccinationStatus/* Hib vaccination status*/ AND 
                ap8.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Y_N_Unk /*Y_N_Unk*/)  ref_ap8
             ON ref_ap8.idfsReference = ap8.varValue 
         )
         ON obs8.idfObservation = hc.idfEpiObservation AND
            obs8.intRowStatus = 0                 
            
         LEFT OUTER JOIN 
         (tlbObservation obs9
             INNER JOIN tlbActivityParameters ap9
             ON ap9.idfObservation = obs9.idfObservation AND
                ap9.idfsParameter =  @NumberOfReceivedDoses_WithMumpsComponent/* Number of received doses (any vaccine with mumps component)*/ AND 
                ap9.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Immunization3 /*Immunization 3+*/)  ref_ap9
             ON ref_ap9.idfsReference = ap9.varValue 
         )
         ON obs9.idfObservation = hc.idfEpiObservation AND
            obs9.intRowStatus = 0      
                    
         LEFT OUTER JOIN 
         (tlbObservation obs10
             INNER JOIN tlbActivityParameters ap10
             ON ap10.idfObservation = obs10.idfObservation AND
                ap10.idfsParameter =  @MothersTetanusToxoidHistoryPriorToChildsDisease/* Mother's tetanus toxoid history prior to child's disease (known doses only)*/ AND 
                ap10.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Immunization5 /*Immunization 5+*/)  ref_ap10
             ON ref_ap10.idfsReference = ap10.varValue 
         )
         ON obs10.idfObservation = hc.idfEpiObservation AND
            obs10.intRowStatus = 0      
               
         LEFT OUTER JOIN 
         (tlbObservation obs11
             INNER JOIN tlbActivityParameters ap11
             ON ap11.idfObservation = obs11.idfObservation AND
                ap11.idfsParameter =  @NumberOfReceivedDoses_WithPertussisComponent/* Number of received doses (any vaccine with pertussis component)*/ AND 
                ap11.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Immunization5 /*Immunization 5+*/)  ref_ap11
             ON ref_ap11.idfsReference = ap11.varValue 
         )
         ON obs11.idfObservation = hc.idfEpiObservation AND
            obs11.intRowStatus = 0      
                             
         LEFT OUTER JOIN 
         (tlbObservation obs12
             INNER JOIN tlbActivityParameters ap12
             ON ap12.idfObservation = obs12.idfObservation AND
                ap12.idfsParameter =  @NumberOfReceivedDoses_WithRubellaComponent/* Number of received doses (any vaccine with rubella component)*/ AND 
                ap12.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Immunization3 /*Immunization 3+*/)  ref_ap12
             ON ref_ap12.idfsReference = ap12.varValue 
         )
         ON obs12.idfObservation = hc.idfEpiObservation AND
            obs12.intRowStatus = 0      
                
         LEFT OUTER JOIN 
         (tlbObservation obs13
             INNER JOIN tlbActivityParameters ap13
             ON ap13.idfObservation = obs13.idfObservation AND
                ap13.idfsParameter = @IncludeDosesOfALLTetanusContainingToxoids /* Include doses of ALL tetanus-containing toxoids. Exclude doses received after this particular injury*/ AND 
                ap13.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Immunization5 /*Immunization 5+*/)  ref_ap13
             ON ref_ap13.idfsReference = ap13.varValue 
         )
         ON obs13.idfObservation = hc.idfEpiObservation AND
            obs13.intRowStatus = 0                 
                
         LEFT OUTER JOIN 
         (tlbObservation obs14
             INNER JOIN tlbActivityParameters ap14
             ON ap14.idfObservation = obs14.idfObservation AND
                ap14.idfsParameter =  @WasVaccinationAdministered /* Was vaccination administered?*/ AND 
                ap14.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Y_N_Unk /*Y_N_Unk*/)  ref_ap14
             ON ref_ap14.idfsReference = ap14.varValue 
         )
         ON obs14.idfObservation = hc.idfEpiObservation AND
            obs14.intRowStatus = 0                      
                      
         LEFT OUTER JOIN 
         (tlbObservation obs15
             INNER JOIN tlbActivityParameters ap15
             ON ap15.idfObservation = obs15.idfObservation AND
                ap15.idfsParameter = @Revaccination /*Revaccination*/ AND 
                ap15.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Y_N_Unk /*Y_N_Unk*/)  ref_ap15
             ON ref_ap15.idfsReference = ap15.varValue 
         )
         ON obs15.idfObservation = hc.idfEpiObservation AND
            obs15.intRowStatus = 0 
         LEFT OUTER JOIN 
         (tlbObservation obs16
             INNER JOIN tlbActivityParameters ap16
             ON ap16.idfObservation = obs16.idfObservation AND
                ap16.idfsParameter = @DateOfVaccination /* Date of vaccination*/ AND 
                ap16.intRowStatus = 0
         )
         ON obs16.idfObservation = hc.idfEpiObservation AND
            obs16.intRowStatus = 0            
            
                         
         LEFT OUTER JOIN 
         (tlbObservation obs17
             INNER JOIN tlbActivityParameters ap17
             ON ap17.idfObservation = obs17.idfObservation AND
                ap17.idfsParameter = @DateOfRevaccination /* Date of revaccination*/ AND 
                ap17.intRowStatus = 0
         )
         ON obs17.idfObservation = hc.idfEpiObservation AND
            obs17.intRowStatus = 0     
         LEFT OUTER JOIN 
         (tlbObservation obs18
             INNER JOIN tlbActivityParameters ap18
             ON ap18.idfObservation = obs18.idfObservation AND
                ap18.idfsParameter = @ImmunizationHistory_DateOfLastVaccination /* Date of last vaccination*/ AND 
                ap18.intRowStatus = 0
         )
         ON obs18.idfObservation = hc.idfEpiObservation AND
            obs18.intRowStatus = 0   
                      
         LEFT OUTER JOIN 
         (tlbObservation obs18_2
             INNER JOIN tlbActivityParameters ap18_2
             ON ap18_2.idfObservation = obs18_2.idfObservation AND
                ap18_2.idfsParameter =  @SpecificVaccination_DateOfLastVaccination /* Date of last vaccination*/ AND 
                ap18_2.intRowStatus = 0
         )
         ON obs18_2.idfObservation = hc.idfEpiObservation AND
            obs18_2.intRowStatus = 0             
 
         --LEFT OUTER JOIN 
         --(tlbObservation obs19
         --    INNER JOIN tlbActivityParameters ap19
         --    ON ap19.idfObservation = obs19.idfObservation AND
         --       ap19.idfsParameter = @IfYes_IndicateDatesOfDoses /* Dates and doses of rabies vaccine given*/ AND 
         --       ap19.intRowStatus = 0
         --)
         --ON obs19.idfObservation = hc.idfEpiObservation AND
         --   obs19.intRowStatus = 0     
         
         outer apply (
         		select top 1
         					convert(varchar(10),cast(ap35.varValue as datetime), 104) as RabiesVaccinationDate,
         					cast(ap36.varValue as nvarchar(20)) as RabiesVaccineDose
     	 				from	tlbObservation obs35
							 inner join tlbActivityParameters ap35
							 on ap35.idfObservation = obs35.idfObservation and
								ap35.idfsParameter = @RabiesVaccinationDate /* Rabies vaccination date*/ AND 
								ap35.intRowStatus = 0   
								and (cast(SQL_VARIANT_PROPERTY(ap35.varValue, 'BaseType') as nvarchar) like N'%date%' or
									(
										cast(SQL_VARIANT_PROPERTY(ap35.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap35.varValue as nvarchar)) = 1 )	)
							 left  JOIN tlbActivityParameters ap36
							 on ap36.idfObservation = obs35.idfObservation and
								ap36.idfsParameter = @RabiesVaccineDose /* Rabies vaccination dose*/ AND 
								ap36.intRowStatus = 0   
								and ap35.idfRow = ap36.idfRow
			     	 	where	obs35.idfObservation = hc.idfEpiObservation and
								obs35.intRowStatus = 0  
         		order by cast(ap35.varValue as datetime) desc
         ) as RabiesVacination
 
         LEFT OUTER JOIN 
         (tlbObservation obs20
             INNER JOIN tlbActivityParameters ap20
             ON ap20.idfObservation = obs20.idfObservation AND
                ap20.idfsParameter = @IfYes_NumberOfVaccinesReceived /* Number of vaccines received*/ AND 
                ap20.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Immunization5 /*Immunization 5+*/)  ref_ap20
             ON ref_ap20.idfsReference = ap20.varValue 
         )
         ON obs20.idfObservation = hc.idfEpiObservation AND
            obs20.intRowStatus = 0 
 
         LEFT OUTER JOIN 
         (tlbObservation obs21
             INNER JOIN tlbActivityParameters ap21
             ON ap21.idfObservation = obs21.idfObservation AND
                ap21.idfsParameter = @IntervalSinceLastTetanusToxoidDose /* Interval since last tetanus toxoid dose (years)*/ AND 
                ap21.intRowStatus = 0     
         )
         ON obs21.idfObservation = hc.idfEpiObservation AND
            obs21.intRowStatus = 0  
 
         --LEFT OUTER JOIN 
         --(tlbObservation obs21_2
         --    INNER JOIN tlbActivityParameters ap21_2
         --    ON ap21_2.idfObservation = obs21_2.idfObservation AND
         --       ap21_2.idfsParameter = @IntervalSinceLastTetanusToxoidDose1 /* Interval since last tetanus toxoid dose (years)*/ AND 
         --       ap21_2.intRowStatus = 0     
         --)
         --ON obs21_2.idfObservation = hc.idfEpiObservation AND
         --   obs21_2.intRowStatus = 0  
 
         LEFT OUTER JOIN 
         (tlbObservation obs22
             INNER JOIN tlbActivityParameters ap22
             ON ap22.idfObservation = obs22.idfObservation AND
                ap22.idfsParameter = @OPV1field   /* OPV-1*/ 
                AND ap22.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_OPVDoses /*OPV Doses*/)  ref_ap22
             ON ref_ap22.idfsReference = ap22.varValue 
         )
         ON obs22.idfObservation = hc.idfEpiObservation AND
            obs22.intRowStatus = 0 
 
         LEFT OUTER JOIN 
         (tlbObservation obs23
             INNER JOIN tlbActivityParameters ap23
             ON ap23.idfObservation = obs23.idfObservation AND
                ap23.idfsParameter = @OPV2field  /* OPV-2*/ 
                AND ap23.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_OPVDoses /*OPV Doses*/)  ref_ap23
             ON ref_ap23.idfsReference = ap23.varValue 
         )
         ON obs23.idfObservation = hc.idfEpiObservation AND
            obs23.intRowStatus = 0
 
         LEFT OUTER JOIN 
         (tlbObservation obs24
             INNER JOIN tlbActivityParameters ap24
             ON ap24.idfObservation = obs24.idfObservation AND
                ap24.idfsParameter = @OPV3field  /* OPV-3*/ 
                AND ap24.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_OPVDoses /*OPV Doses*/)  ref_ap24
             ON ref_ap24.idfsReference = ap24.varValue 
         )
         ON obs24.idfObservation = hc.idfEpiObservation AND
            obs24.intRowStatus = 0
 
         LEFT OUTER JOIN 
         (tlbObservation obs25
             INNER JOIN tlbActivityParameters ap25
             ON ap25.idfObservation = obs25.idfObservation AND
                ap25.idfsParameter = @OPV4field  /* OPV-4*/  
                AND ap25.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_OPVDoses /*OPV Doses*/)  ref_ap25
             ON ref_ap25.idfsReference = ap25.varValue 
         )
         ON obs25.idfObservation = hc.idfEpiObservation AND
            obs25.intRowStatus = 0
 
         LEFT OUTER JOIN 
         (tlbObservation obs26
             INNER JOIN tlbActivityParameters ap26
             ON ap26.idfObservation = obs26.idfObservation AND
                ap26.idfsParameter = @OPV5field  /* OPV-5*/  
                AND ap26.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_OPVDoses /*OPV Doses*/)  ref_ap26
             ON ref_ap26.idfsReference = ap26.varValue 
         )
         ON obs26.idfObservation = hc.idfEpiObservation AND
            obs26.intRowStatus = 0
 
         LEFT OUTER JOIN 
         (tlbObservation obs27
             INNER JOIN tlbActivityParameters ap27
             ON ap27.idfObservation = obs27.idfObservation AND
                ap27.idfsParameter = @Firstfield  /* First*/ 
                AND ap27.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_OPVDoses /*OPV Doses*/)  ref_ap27
             ON ref_ap27.idfsReference = ap27.varValue 
         )
         ON obs27.idfObservation = hc.idfEpiObservation AND
            obs27.intRowStatus = 0
 
         LEFT OUTER JOIN 
         (tlbObservation obs28
             INNER JOIN tlbActivityParameters ap28
             ON ap28.idfObservation = obs28.idfObservation AND
                ap28.idfsParameter = @Secondfield  /* Second*/ 
                AND ap28.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_OPVDoses /*OPV Doses*/)  ref_ap28
             ON ref_ap28.idfsReference = ap28.varValue 
         )
         ON obs28.idfObservation = hc.idfEpiObservation AND
            obs28.intRowStatus = 0
 
         LEFT OUTER JOIN 
         (tlbObservation obs29
             INNER JOIN tlbActivityParameters ap29
             ON ap29.idfObservation = obs29.idfObservation AND
                ap29.idfsParameter = @Thirdfield   /* Third*/ 
                AND ap29.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_OPVDoses /*OPV Doses*/)  ref_ap29
             ON ref_ap29.idfsReference = ap29.varValue 
         )
         ON obs29.idfObservation = hc.idfEpiObservation AND
            obs29.intRowStatus = 0
 
         LEFT OUTER JOIN 
         (tlbObservation obs30
             INNER JOIN tlbActivityParameters ap30
             ON ap30.idfObservation = obs30.idfObservation AND
                ap30.idfsParameter = @DateOfLastOPVDoseReceived /* Date of last OPV dose received*/ AND 
                ap30.intRowStatus = 0     
         )
         ON obs30.idfObservation = hc.idfEpiObservation AND
            obs30.intRowStatus = 0  
		
		--NEW!!!
		 LEFT OUTER JOIN 
         (tlbObservation obs31
             INNER JOIN tlbActivityParameters ap31
             ON ap31.idfObservation = obs31.idfObservation AND
                ap31.idfsParameter =  @IsPatientVaccinatedAgainstLeptospirosis /*Is patient vaccinated against leptospirosis?*/ AND 
                ap31.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Y_N_Unk /*Y_N_Unk*/)  ref_ap31
             ON ref_ap31.idfsReference = ap31.varValue 
         )
         ON obs31.idfObservation = hc.idfEpiObservation AND
            obs31.intRowStatus = 0   
            
         LEFT OUTER JOIN 
         (tlbObservation obs32
             INNER JOIN tlbActivityParameters ap32
             ON ap32.idfObservation = obs32.idfObservation AND
                ap32.idfsParameter = @DateOfVaccinationOfPatientAgainstLeptospirosis /*Date of vaccination of patient against leptospirosis*/ AND 
                ap32.intRowStatus = 0     
         )
         ON obs32.idfObservation = hc.idfEpiObservation AND
            obs32.intRowStatus = 0              
 
         --LEFT OUTER JOIN 
         --(tlbObservation obs31
         --    INNER JOIN tlbActivityParameters ap31
         --    ON ap31.idfObservation = obs31.idfObservation AND
         --       ap31.idfsParameter = @NameVaccine1 /* Vaccine 1: Name of vaccine*/ AND 
         --       ap31.intRowStatus = 0   
 
         --    LEFT JOIN fnReferenceRepair(@LangID, @PVT_VaccineTypes /*Vaccine types*/)  ref_ap31
         --    ON ref_ap31.idfsReference = ap31.varValue 
                  
         --)
         --ON obs31.idfObservation = hc.idfEpiObservation AND
         --   obs31.intRowStatus = 0  
 
         --LEFT OUTER JOIN 
         --(tlbObservation obs32
         --    INNER JOIN tlbActivityParameters ap32
         --    ON ap32.idfObservation = obs32.idfObservation AND
         --       ap32.idfsParameter = @NameVaccine2 /* Vaccine 2: Name of vaccine*/ AND 
         --       ap32.intRowStatus = 0   
 
         --    LEFT JOIN fnReferenceRepair(@LangID, @PVT_VaccineTypes /*Vaccine types*/)  ref_ap32
         --    ON ref_ap32.idfsReference = ap32.varValue 
                  
         --)
         --ON obs32.idfObservation = hc.idfEpiObservation AND
         --   obs32.intRowStatus = 0  
            
         --LEFT OUTER JOIN 
         --(tlbObservation obs33
         --    INNER JOIN tlbActivityParameters ap33
         --    ON ap33.idfObservation = obs33.idfObservation AND
         --       ap33.idfsParameter = @NameVaccine3 /* Vaccine 3: Name of vaccine*/ AND 
         --       ap33.intRowStatus = 0   
 
         --    LEFT JOIN fnReferenceRepair(@LangID, @PVT_VaccineTypes /*Vaccine types*/)  ref_ap33
         --    ON ref_ap33.idfsReference = ap33.varValue 
                  
         --)
         --ON obs33.idfObservation = hc.idfEpiObservation AND
         --   obs33.intRowStatus = 0         
         
     LEFT OUTER JOIN 
         (tlbObservation obs37
             INNER JOIN tlbActivityParameters ap37
             ON ap37.idfObservation = obs37.idfObservation AND
                ap37.idfsParameter =  @PneumonaeNumberReceivedDoses/*HEI S. pneumonae caused infection GG: Number of received doses of S. pneumonae vaccine*/ AND 
                ap37.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Immunization3 /*Immunization 3+*/)  ref_ap37
             ON ref_ap37.idfsReference = ap37.varValue 
         )
         ON obs37.idfObservation = hc.idfEpiObservation AND
            obs37.intRowStatus = 0    
     
     LEFT OUTER JOIN 
         (tlbObservation obs38
             INNER JOIN tlbActivityParameters ap38
             ON ap38.idfObservation = obs38.idfObservation AND
                ap38.idfsParameter =  @PneumonaeVaccinationStatus /*HEI S. pneumonae caused infection GG: S. pneumonae vaccination status*/ AND 
                ap38.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Y_N_Unk /*Y_N_Unk*/)  ref_ap38
             ON ref_ap38.idfsReference = ap38.varValue 
         )
         ON obs38.idfObservation = hc.idfEpiObservation AND
            obs38.intRowStatus = 0     
            
     LEFT OUTER JOIN 
         (tlbObservation obs39
             INNER JOIN tlbActivityParameters ap39
             ON ap39.idfObservation = obs39.idfObservation AND
                ap39.idfsParameter = @PneumonaeDateLastVaccination /*HEI S. pneumonae caused infection GG: Date of last vaccination*/ AND 
                ap39.intRowStatus = 0     
                and (cast(SQL_VARIANT_PROPERTY(ap39.varValue, 'BaseType') as nvarchar) like N'%date%' or
					(cast(SQL_VARIANT_PROPERTY(ap39.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap39.varValue as nvarchar)) = 1 )	)
         )
         ON obs39.idfObservation = hc.idfEpiObservation AND
            obs39.intRowStatus = 0         

         LEFT OUTER JOIN 
         (tlbObservation obs40
             INNER JOIN tlbActivityParameters ap40
             ON ap40.idfObservation = obs40.idfObservation AND
                ap40.idfsParameter = @HepatitisANumberReceivedDoses /* HEI Acute Viral Hepatitis A GG: Number of received doses of Hepatitis A vaccine*/ AND 
                ap40.intRowStatus = 0
             LEFT JOIN fnReferenceRepair(@LangID, @PVT_Immunization5 /*Immunization 5+*/)  ref_ap40
             ON ref_ap40.idfsReference = ap40.varValue 
         )
         ON obs40.idfObservation = hc.idfEpiObservation AND
            obs40.intRowStatus = 0             
            
      LEFT OUTER JOIN 
         (tlbObservation obs41
             INNER JOIN tlbActivityParameters ap41
             ON ap41.idfObservation = obs41.idfObservation AND
                ap41.idfsParameter = @HepatitisADateLastVaccination /*HEI Acute Viral Hepatitis A GG: Date of last vaccination*/ AND 
                ap41.intRowStatus = 0     
                and (cast(SQL_VARIANT_PROPERTY(ap41.varValue, 'BaseType') as nvarchar) like N'%date%' or
					(cast(SQL_VARIANT_PROPERTY(ap41.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap41.varValue as nvarchar)) = 1 )	)
         )
         ON obs41.idfObservation = hc.idfEpiObservation AND
            obs41.intRowStatus = 0   
 
 
 
 
     LEFT OUTER JOIN tlbOutbreak o
     ON hc.idfOutbreak = o.idfOutbreak
 		and o.intRowStatus = 0
 		
 	LEFT JOIN tlbPerson tp ON
 		tp.idfPerson = hc.idfSentByPerson
 
 	LEFT JOIN dbo.fnInstitution(@LangID) fi ON
 		fi.idfOffice = hc.idfSentByOffice
 		
 		
 		
 WHERE    hc.idfsSite = ISNULL(@SiteID, dbo.fnSiteID()) AND
          hc.intRowStatus = 0 AND 
          DATEDIFF(D, @StartDate, isnull(hc.datNotificationDate ,hc.datEnteredDate)) >= 0 AND
          DATEDIFF(D, @FinishDate, isnull(hc.datNotificationDate ,hc.datEnteredDate)) <= 0 AND
 			(IsNull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @Diagnosis OR @Diagnosis is null)
 		
 		
 select * 
 from @ReportTable
 order by datEntredDate
 

