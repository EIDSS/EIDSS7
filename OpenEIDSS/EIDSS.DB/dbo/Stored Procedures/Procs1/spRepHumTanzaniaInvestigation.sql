

--##SUMMARY Select data for Human Notification form for Tanzania republicreport.
--##REMARKS Author: Romasheva S.
--##REMARKS Create: 13.03.2013

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 23.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:


exec spRepHumTanzaniaInvestigation 'en', 12558370000000
exec spRepHumTanzaniaInvestigation 'en', 1260001100
exec spRepHumTanzaniaInvestigation 'en', 1210001508
*/

create  Procedure [dbo].[spRepHumTanzaniaInvestigation]
	(
		@LangID as nvarchar(10),
		@ObjID	as bigint
	)
AS	
 
	declare
		@idfsSummaryReportType bigint,
		@idfsLanguage bigint,
		
		@idfsDiagnosis_AFP bigint,
		@idfsDiagnosis_Cholera bigint,
		@idfsDiagnosis_Measles bigint,
		@idfsDiagnosis_Meningitis bigint,
		@idfsDiagnosis_NeonatalTetanus bigint,
		@idfsDiagnosis_Plague bigint,
		@idfsDiagnosis_VHF bigint,
		@idfsDiagnosis_YellowFever bigint


	set @idfsSummaryReportType = 10290025 --TZ Case Investigation Form
	
	-- @idfsDiagnosis_AFP
	select @idfsDiagnosis_AFP = d.idfsDiagnosis
	from dbo.trtReportDiagnosisGroup dg
		inner join dbo.trtDiagnosisToGroupForReportType dgfrt
		on dgfrt.idfsReportDiagnosisGroup = dg.idfsReportDiagnosisGroup
		and dgfrt.idfsCustomReportType = @idfsSummaryReportType
		
		inner join trtDiagnosis d
		on d.idfsDiagnosis = dgfrt.idfsDiagnosis
		and d.intRowStatus = 0
	where dg.intRowStatus = 0 and
    dg.strDiagnosisGroupAlias = N'DG_CIF_AFP'
    
	-- @idfsDiagnosis_Cholera
	select @idfsDiagnosis_Cholera = d.idfsDiagnosis
	from dbo.trtReportDiagnosisGroup dg
		inner join dbo.trtDiagnosisToGroupForReportType dgfrt
		on dgfrt.idfsReportDiagnosisGroup = dg.idfsReportDiagnosisGroup
		and dgfrt.idfsCustomReportType = @idfsSummaryReportType
		
		inner join trtDiagnosis d
		on d.idfsDiagnosis = dgfrt.idfsDiagnosis
		and d.intRowStatus = 0
	where dg.intRowStatus = 0 and
    dg.strDiagnosisGroupAlias = N'DG_CIF_Cholera'    
    
	-- @idfsDiagnosis_Measles
	select @idfsDiagnosis_Measles = d.idfsDiagnosis
	from dbo.trtReportDiagnosisGroup dg
		inner join dbo.trtDiagnosisToGroupForReportType dgfrt
		on dgfrt.idfsReportDiagnosisGroup = dg.idfsReportDiagnosisGroup
		and dgfrt.idfsCustomReportType = @idfsSummaryReportType
		
		inner join trtDiagnosis d
		on d.idfsDiagnosis = dgfrt.idfsDiagnosis
		and d.intRowStatus = 0
	where dg.intRowStatus = 0 and
    dg.strDiagnosisGroupAlias = N'DG_CIF_Measles'    
        
        
	--@idfsDiagnosis_Meningitis 
	select @idfsDiagnosis_Meningitis  = d.idfsDiagnosis
	from dbo.trtReportDiagnosisGroup dg
		inner join dbo.trtDiagnosisToGroupForReportType dgfrt
		on dgfrt.idfsReportDiagnosisGroup = dg.idfsReportDiagnosisGroup
		and dgfrt.idfsCustomReportType = @idfsSummaryReportType
		
		inner join trtDiagnosis d
		on d.idfsDiagnosis = dgfrt.idfsDiagnosis
		and d.intRowStatus = 0
	where dg.intRowStatus = 0 and
    dg.strDiagnosisGroupAlias = N'DG_CIF_Meningitis'    
        	
	
	--@idfsDiagnosis_NeonatalTetanus 
	select @idfsDiagnosis_NeonatalTetanus  = d.idfsDiagnosis
	from dbo.trtReportDiagnosisGroup dg
		inner join dbo.trtDiagnosisToGroupForReportType dgfrt
		on dgfrt.idfsReportDiagnosisGroup = dg.idfsReportDiagnosisGroup
		and dgfrt.idfsCustomReportType = @idfsSummaryReportType
		
		inner join trtDiagnosis d
		on d.idfsDiagnosis = dgfrt.idfsDiagnosis
		and d.intRowStatus = 0
	where dg.intRowStatus = 0 and
    dg.strDiagnosisGroupAlias = N'DG_CIF_NeonatalTetanus'   
     	
	--@idfsDiagnosis_Plague 
	select @idfsDiagnosis_Plague  = d.idfsDiagnosis
	from dbo.trtReportDiagnosisGroup dg
		inner join dbo.trtDiagnosisToGroupForReportType dgfrt
		on dgfrt.idfsReportDiagnosisGroup = dg.idfsReportDiagnosisGroup
		and dgfrt.idfsCustomReportType = @idfsSummaryReportType
		
		inner join trtDiagnosis d
		on d.idfsDiagnosis = dgfrt.idfsDiagnosis
		and d.intRowStatus = 0
	where dg.intRowStatus = 0 and
    dg.strDiagnosisGroupAlias = N'DG_CIF_Plague'  
     	
	--@idfsDiagnosis_VHF 
	select @idfsDiagnosis_VHF   = d.idfsDiagnosis
	from dbo.trtReportDiagnosisGroup dg
		inner join dbo.trtDiagnosisToGroupForReportType dgfrt
		on dgfrt.idfsReportDiagnosisGroup = dg.idfsReportDiagnosisGroup
		and dgfrt.idfsCustomReportType = @idfsSummaryReportType
		
		inner join trtDiagnosis d
		on d.idfsDiagnosis = dgfrt.idfsDiagnosis
		and d.intRowStatus = 0
	where dg.intRowStatus = 0 and
    dg.strDiagnosisGroupAlias = N'DG_CIF_VHF'  
    	
	--@idfsDiagnosis_YellowFever  
	select @idfsDiagnosis_YellowFever   = d.idfsDiagnosis
	from dbo.trtReportDiagnosisGroup dg
		inner join dbo.trtDiagnosisToGroupForReportType dgfrt
		on dgfrt.idfsReportDiagnosisGroup = dg.idfsReportDiagnosisGroup
		and dgfrt.idfsCustomReportType = @idfsSummaryReportType
		
		inner join trtDiagnosis d
		on d.idfsDiagnosis = dgfrt.idfsDiagnosis
		and d.intRowStatus = 0
	where dg.intRowStatus = 0 and
    dg.strDiagnosisGroupAlias = N'DG_CIF_YellowFever'  

    

	declare @Result table
	(
		blnAFP bit null, --1
		blnCholera bit null, --2
		blnMeasles bit null, --3
		blnMeningitis bit null, --4
		blnNeonatalTetanus bit null, --5
		blnPlague  bit null, -- 6
		blnVHF bit null, --7
		blnYellowFever bit null, --8
		strDiagnosis nvarchar(200)  null, --9
		strCaseID  nvarchar(200) not null, --10
		strSentByFacilityName  nvarchar(2000) null, --11
		strSentByFacilityRegion  nvarchar(200) null, --12
		strPatientName  nvarchar(200) not null, --13
		strPatientSex  nvarchar(200) null, --14
		datPatientDOB  date null,
		intPatientAgeYears int null, --16
		intPatientAgeMonth int null, --17
		strPatientResidenceAddress  nvarchar(2000) null, --18
		datFirstSoughtCare  date null, --19
		datNotificationDate  date null, --20
		datSymptomsOnsetDate  date null, --21
		strOutcome nvarchar(200)  null, --22
		datOutcomeDate date  null, --23
		strIsHospitalization nvarchar(200)  null, --27 -- result should be 'I' for 'Yes', 'O' for 'NO', '' for any other value
		strHospitalizationPlace nvarchar(2000)  null, --28
		strNonNotifiableDiagnosis nvarchar(200)  null, --29
		strFinalCaseClassification nvarchar(200)  null, -- 30
		strCaseCreatorName  nvarchar(200)  null --35
	)
	insert into @Result
	(
		blnAFP,
		blnCholera,
		blnMeasles,
		blnMeningitis,
		blnNeonatalTetanus,
		blnPlague,
		blnVHF,
		blnYellowFever,
		strDiagnosis,
		strCaseID,
		strSentByFacilityName,
		strSentByFacilityRegion,
		strPatientName,
		strPatientSex,
		datPatientDOB,
		intPatientAgeYears,
		intPatientAgeMonth,
		strPatientResidenceAddress,
		datFirstSoughtCare,
		datNotificationDate,
		datSymptomsOnsetDate,
		strOutcome,
		datOutcomeDate,
		strIsHospitalization,
		strHospitalizationPlace,
		strNonNotifiableDiagnosis,
		strFinalCaseClassification,
		strCaseCreatorName
	)
	select		
		case when ISNULL(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_AFP then 1 else 0 end as blnAFP,
		case when ISNULL(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Cholera then 1 else 0 end as blnCholera,
		case when ISNULL(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles then 1 else 0 end as blnMeasles,
		case when ISNULL(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Meningitis then 1 else 0 end as blnMeningitis,
		case when ISNULL(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_NeonatalTetanus then 1 else 0 end as blnNeonatalTetanus,
		case when ISNULL(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Plague then 1 else 0 end as blnPlague,
		case when ISNULL(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_VHF then 1 else 0 end as blnVHF,
		case when ISNULL(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_YellowFever then 1 else 0 end as blnYellowFever,
		case when ISNULL(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) not in (@idfsDiagnosis_AFP, 
												 @idfsDiagnosis_Cholera,
												 @idfsDiagnosis_Measles,
												 @idfsDiagnosis_Meningitis,
												 @idfsDiagnosis_NeonatalTetanus,
												 @idfsDiagnosis_Plague,
												 @idfsDiagnosis_VHF,
												 @idfsDiagnosis_YellowFever
												 ) then [ref_sflHC_ShowDiagnosis].[name] else null end as strDiagnosis,
		hc.strCaseID as strCaseID,
		[ref_sflHC_SentByOffice].[name] as strSentByFacilityName,
		[ref_GIS_sflHC_SentByOfficeRegion].[name] as strSentByFacilityRegion,
		dbo.fnConcatFullName(h_hc.strLastName, h_hc.strFirstName, h_hc.strSecondName) as strPatientName, 
		[ref_sflHC_PatientSex].[name] as strPatientSex,
		h_hc.datDateofBirth as datPatientDOB, 
		case when hc.idfsHumanAgeType = 10042003 /*hatYears*/ then hc.intPatientAge else null end as intPatientAgeYears,
		case when hc.idfsHumanAgeType = 10042002 /*hatMonth*/ then hc.intPatientAge else null end as intPatientAgeMonth,		
		[ref_GIS_sflHC_PatientCRRegion].[name] +  [ref_GIS_sflHC_PatientCRRayon].[name] + 
				isnull(N', ' +[ref_GIS_sflHC_PatientCRSettlement].[name], N'') + 
				isnull(N', ' + gl_cr_hc.strPostCode, N'') + 
				isnull(N', ' + gl_cr_hc.strStreetName, N'') + 
				isnull(N', ' + gl_cr_hc.strHouse, N'') + 
				IsNull(N', ' + gl_cr_hc.strBuilding, N'') + 
				IsNull(N', ' + gl_cr_hc.strApartment, N'') as strPatientResidenceAddress, 
		hc.datFirstSoughtCareDate as datFirstSoughtCare, 		
		hc.datNotificationDate as datNotificationDate, 
		hc.datOnSetDate as datSymptomsOnsetDate, 
		[ref_sflHC_Outcome].[name] as strOutcome, 
		case 
			when hc.idfsOutcome = 10760000000 /*outRecovered*/ then hc.datDischargeDate
			when hc.idfsOutcome = 10770000000 /*outDied*/ then h_hc.datDateOfDeath
			else null 
			end as datOutcomeDate,
		case 
			when hc.idfsYNHospitalization = 10100001 /*ynvYes*/ then N'I'
			when hc.idfsYNHospitalization = 10100002 /*No*/ then N'O'
			else null
			end as strIsHospitalization,
		hc.strHospitalizationPlace as strHospitalizationPlace, 	
		[ref_sflHC_NonNotifiableDiagnosis].[name] as strNonNotifiableDiagnosis,
		[ref_sflHC_FinalCaseClassification].[name] as strFinalCaseClassification,
		dbo.fnConcatFullName(p_eb.strFamilyName, p_eb.strFirstName, p_eb.strSecondName) as strCaseCreatorName

			 
	from 

		( 
			tlbHumanCase hc
			inner join	tlbHuman h_hc 
			on			h_hc.idfHuman = hc.idfHuman 
						and h_hc.intRowStatus = 0 
			left join	tlbGeoLocation gl_cr_hc 
			on gl_cr_hc.idfGeoLocation = h_hc.idfCurrentResidenceAddress AND gl_cr_hc.intRowStatus = 0 
	
			left join 	tlbOffice o_sent_hc 
		 	on o_sent_hc.idfOffice = hc.idfSentByOffice AND o_sent_hc.intRowStatus = 0 
				
			left join tlbGeoLocationShared gl_o_sent_hc 
			on gl_o_sent_hc.idfGeoLocationShared = o_sent_hc.idfLocation
		
			left join tlbPerson p_eb
		 	on p_eb.idfPerson = hc.idfPersonEnteredBy 
		
			
		 	
		) 
		left join	fnReferenceRepair(@LangID, 19000019) [ref_sflHC_ShowDiagnosis] 
		on			[ref_sflHC_ShowDiagnosis].idfsReference = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)	
		
		left join	fnReferenceRepair(@LangID, 19000046) [ref_sflHC_SentByOffice] 
		on			[ref_sflHC_SentByOffice].idfsReference = o_sent_hc.idfsOfficeName
		
		left join	fnReferenceRepair(@LangID, 19000043) [ref_sflHC_PatientSex] 
		on			[ref_sflHC_PatientSex].idfsReference = h_hc.idfsHumanGender
		
		left join	fnReferenceRepair(@LangID, 19000064) [ref_sflHC_Outcome] 
		on			[ref_sflHC_Outcome].idfsReference = hc.idfsOutcome
		
		left join	fnReferenceRepair(@LangID, 19000149) [ref_sflHC_NonNotifiableDiagnosis] 
		on			[ref_sflHC_NonNotifiableDiagnosis].idfsReference = hc.idfsNonNotifiableDiagnosis
		
		left join	fnReferenceRepair(@LangID, 19000011) [ref_sflHC_FinalCaseClassification] 
		on			[ref_sflHC_FinalCaseClassification].idfsReference = hc.idfsFinalCaseStatus
		
		left join	fnGisExtendedReferenceRepair(@LangID, 19000003) [ref_GIS_sflHC_SentByOfficeRegion]  
		on			[ref_GIS_sflHC_SentByOfficeRegion].idfsReference = gl_o_sent_hc.idfsRegion

		left join	fnGisExtendedReferenceRepair(@LangID, 19000003) [ref_GIS_sflHC_PatientCRRegion]  
		on			[ref_GIS_sflHC_PatientCRRegion].idfsReference = gl_cr_hc.idfsRegion
		
		left join	fnGisExtendedReferenceRepair(@LangID, 19000002) [ref_GIS_sflHC_PatientCRRayon]  
		on			[ref_GIS_sflHC_PatientCRRayon].idfsReference = gl_cr_hc.idfsRayon
		
		left join	fnGisExtendedReferenceRepair(@LangID, 19000004) [ref_GIS_sflHC_PatientCRSettlement]  
		on			[ref_GIS_sflHC_PatientCRSettlement].idfsReference = gl_cr_hc.idfsSettlement

	-- Filter condition
	where	@ObjID = hc.idfHumanCase
			AND hc.intRowStatus = 0
	
	
	select * from @Result


