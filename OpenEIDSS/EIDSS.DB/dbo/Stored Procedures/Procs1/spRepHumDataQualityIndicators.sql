
 
 --##SUMMARY This procedure returns resultset for Main indicators of AFP surveillance report
 
 --##REMARKS Author: 
 --##REMARKS Create date: 
 --##REMARKS Update: 28.05.2015 by Romasheva S.
 --##RETURNS Don't use 
 
 /*
 --Example of a call of procedure:
 
exec [spRepHumDataQualityIndicators_test]  
'en', 
'<ItemList><Item key="7718510000000" value="Bacillar form of tuberculosis of lungs" /></ItemList>',
2015,
1,
6

exec [spRepHumDataQualityIndicators_test]  
'en', 
'<ItemList><Item key="7718060000000" value="Acute intestinal infection with identified aetilogy including bacterial or viral agent, food toxic infections" /></ItemList>',
2015,
1,
6

exec [spRepHumDataQualityIndicators_test]  
'en', 
'<ItemList><Item key="7718070000000" value="Acute intestinal infection with unidentified aetiology" /></ItemList>',
2015,
1,
6



select td.idfsDiagnosis, tbr.strDefault, tsnt.strTextString, tsnt.idfsLanguage, td.idfsUsingType
  from trtDiagnosis td
inner join trtBaseReference tbr
on tbr.idfsBaseReference = td.idfsDiagnosis
inner join trtStringNameTranslation tsnt
on tsnt.idfsBaseReference = tbr.idfsBaseReference

where
--tbr.idfsBaseReference = 7719130000000 
tbr.strDefault like '%Acute intestinal infection %'
--or tsnt.strTextString like '%бешенство%'

and tbr.intRowStatus = 0

 exec spRepHumDataQualityIndicators 
 'en', 
 '<ItemList/>',
 2014,
 1,
 12
 
 exec spRepHumDataQualityIndicators  
'en', 
'<ItemList><Item key="7720550000000" value="Poliomyelitis" /></ItemList>',
2015,
1,
04
 
 
 exec spRepHumDataQualityIndicators  
 'en', 
 '<ItemList><Item key="7718050000000" value="Acute Flaccid Paralysis" /><Item key="7718570000000" value="Botulism" /></ItemList>',
  2014,
 1,
 12
 
 exec spRepHumDataQualityIndicators  
 'en',
 '<ItemList><Item key="7718050000000" value="Acute Flaccid Paralysis" /><Item key="7718570000000" value="Botulism" /></ItemList>',
 2010,
 1,
 12,
 10300053,
 null
 
 */ 
  
CREATE PROCEDURE [dbo].[spRepHumDataQualityIndicators]
 (
	 @LangID   as nvarchar(50),
	 @Diagnosis  as xml, 
	 @Year   as int, 
	 @StartMonth  as int = null,
	 @EndMonth  as int = null,
	 @RegionID as bigint = null,
	 @RayonID as bigint = null,
	 @SiteID   as bigint = null
 )
 as	
	set nocount on
 
 	declare 
 	     @CountryID	bigint
 		,@iDiagnosis	int
 		,@SDDate datetime
 		,@EDDate datetime
 		,@idfsLanguage bigint
 		,@idfsCustomReportType bigint
 	
 		,@Ind_1_Notification  numeric(4,2)
 		,@Ind_2_CaseInvestigation  numeric(4,2)
 		,@Ind_3_TheResultsOfLabTestsAndInterpretation  numeric(4,2)
 		
 		,@Ind_N1_CaseStatus  numeric(4,2)
 		,@Ind_N1_DateofCompletionPF  numeric(4,2)
 		,@Ind_N1_NameofEmployer  numeric(4,2)
 		,@Ind_N1_CurrentLocationPatient numeric(4,2)
 		,@Ind_N1_NotifDateTime  numeric(4,2)
		,@Ind_N2_NotifDateTime  numeric(4,2)
		,@Ind_N3_NotifDateTime  numeric(4,2)
 		,@Ind_N1_NotifSentByName  numeric(4,2)
 		,@Ind_N1_NotifReceivedByFacility  numeric(4,2)
 		,@Ind_N1_NotifReceivedByName  numeric(4,2)
 		,@Ind_N1_TimelinessOfDataEntryDTEN  numeric(4,2)
		,@Ind_N2_TimelinessOfDataEntryDTEN  numeric(4,2)
		,@Ind_N3_TimelinessOfDataEntryDTEN  numeric(4,2)
 		,@Ind_N1_DIStartingDTOfInvestigation  numeric(4,2)
		,@Ind_N2_DIStartingDTOfInvestigation  numeric(4,2)
		,@Ind_N3_DIStartingDTOfInvestigation  numeric(4,2)
 		,@Ind_N1_DIOccupation  numeric(4,2)
 		,@Ind_N1_CIInitCaseClassification  numeric(4,2)
 		,@Ind_N1_CILocationOfExposure numeric(4,2)
 		,@Ind_N1_CIAntibioticTherapyAdministratedBSC  numeric(4,2)
 		,@Ind_N1_SamplesCollection  numeric(4,2)
 		,@Ind_N1_ContactLisAddContact  numeric(4,2)
 		,@Ind_N1_CaseClassificationCS  numeric(4,2)
 		,@Ind_N1_EpiLinksRiskFactorsByEpidCard   numeric(4,2)
		,@Ind_N2_EpiLinksRiskFactorsByEpidCard   numeric(4,2)
		,@Ind_N3_EpiLinksRiskFactorsByEpidCard   numeric(4,2)
 		,@Ind_N1_FCCOBasisOfDiagnosis  numeric(4,2)
 		,@Ind_N1_FCCOOutcome numeric(4,2)
 		,@Ind_N1_FCCOIsThisCaseRelatedToOutbreak  numeric(4,2)
 		,@Ind_N1_FCCOEpidemiologistName  numeric(4,2)
 		,@Ind_N1_ResultsOfLabTestsTestsConducted  numeric(4,2)
 		,@Ind_N1_ResultsOfLabTestsResultObservation  numeric(4,2)
 		
		,@idfsRegionBaku bigint
		,@idfsRegionOtherRayons bigint
		,@idfsRegionNakhichevanAR bigint		
 	
  	
 	declare @DiagnosisTable	table
 	(
 		intRowNumber int identity(1,1) primary key,
 		[key]		nvarchar(300),
 		[value]		nvarchar(300),
 		intNotificationToCHE int,
 		intStartingDTOfInvestigation int,
 		blnLaboratoryConfirmation bit,
 		intQuantityOfMandatoryFieldCS int,
 		intQuantityOfMandatoryFieldCSForDC int,
 		intEPILincsAndFactors int		
 	)
 	
 	declare @ReportTable table
 	(
 			idfsBaseReference	bigint identity not null primary key,
 			idfsRegion			bigint not null,
 	/*1*/	strRegion			nvarchar(200) not null,
 			intRegionOrder		int null,
 			idfsRayon			bigint not null,
 	/*2*/	strRayon			nvarchar(200) not null,
 			strAZRayon			nvarchar(200) not null,
 			intRayonOrder		int null,
 			intCaseCount		int not null,
 			idfsDiagnosis		bigint not null,
 	/*3*/	strDiagnosis		nvarchar (300) collate database_default not null,
 	
 	/*6(1+2+3+5+6+8+9+10)*/dbl_1_Notification float null,
 	/*7(1)*/	dblCaseStatus	float null,
 	/*8(2)*/	dblDateOfCompletionOfPaperForm	float null,
 	/*9(3)*/	dblNameOfEmployer	float null,
 	/*11(5)*/	dblCurrentLocationOfPatient	float null,
 	/*12(6)*/	dblNotificationDateTime	float null,
 	/*13(7)*/	dbldblNotificationSentByName	float null,
 	/*14(8)*/	dblNotificationReceivedByFacility	float null,
 	/*15(9)*/	dblNotificationReceivedByName	float null,
 	/*16(10)*/	dblTimelinessofDataEntry	float null,
 	
 	/*17(11..23)*/dbl_2_CaseInvestigation	float null,
 	/*18(11)*/	dblDemographicInformationStartingDateTimeOfInvestigation	float null,
 	/*19(12)*/	dblDemographicInformationOccupation	float null,
 	/*20(13)*/	dblClinicalInformationInitialCaseClassification	float null,
 	/*21(14)*/	dblClinicalInformationLocationOfExposure float null,
 	/*22(15)*/	dblClinicalInformationAntibioticAntiviralTherapy float null,
 	/*23(16)*/	dblSamplesCollectionSamplesCollected	float null,
 	/*24(17)*/	dblContactListAddContact	float null,
 	/*25(18)*/	dblCaseClassificationClinicalSigns float null,
 	/*26(19)*/	dblEpidemiologicalLinksAndRiskFactors float null,
 	/*27(20)*/	dblFinalCaseClassificationBasisOfDiagnosis	float null,
 	/*28(21)*/	dblFinalCaseClassificationOutcome	float null,
 	/*29(22)*/	dblFinalCaseClassificationIsThisCaseOutbreak	float null,
 	/*30(23)*/	dblFinalCaseClassificationEpidemiologistName	float null,
 	
 	/*31(24+25)*/dbl_3_TheResultsOfLaboratoryTests float null,
 	/*32(24)*/	dblTheResultsOfLaboratoryTestsTestsConducted	float null,
 	/*33(25)*/	dblTheResultsOfLaboratoryTestsResultObservation	float null,
 	
 	/*34*/		dblSummaryScoreByIndicators float null
  	)
 	
	if @StartMonth IS null
	begin
		set @SDDate = (cast(@Year as varchar(4)) + '01' + '01')
		set @EDDate = dateADD(yyyy, 1, @SDDate)
	end
	else
	begin	
	  if @StartMonth < 10	
			set @SDDate = (cast(@Year as varchar(4)) + '0' +cast(@StartMonth as varchar(2)) + '01')
	  else				
			set @SDDate = (cast(@Year as varchar(4)) + cast(@StartMonth as varchar(2)) + '01')
			
	  if (@EndMonth is null) or (@StartMonth = @EndMonth)
			set @EDDate = dateADD(mm, 1, @SDDate)
	  else	begin
			if @EndMonth < 10	
				set @EDDate = (cast(@Year as varchar(4)) + '0' +cast(@EndMonth as varchar(2)) + '01')
			else				
				set @EDDate = (cast(@Year as varchar(4)) + cast(@EndMonth as varchar(2)) + '01')
				
			set @EDDate = dateADD(mm, 1, @EDDate)
	  end
	end		
	 	
			
 	set @CountryID = 170000000
 	
 	set @idfsLanguage = dbo.fnGetLanguageCode(@LangID)
 	
 	set @idfsCustomReportType =  10290021
 	
 	--diagnosis list from xml
 	exec sp_xml_preparedocument @iDiagnosis output, @Diagnosis
 	insert into @DiagnosisTable (
 		[key],
 		[value]
 	) 
 	select * 
 	from OPENXML (@iDiagnosis, '/ItemList/Item')
 	with (
 			[key] bigint '@key',
 			[value] nvarchar(300) '@value'
 		 )
 
 	exec sp_xml_removedocument @iDiagnosis	
 	
 	
 	-- if @Diagnosis is blanc, fill to @DiagnosisTable all diagnosis
 	if cast(@Diagnosis as nvarchar(max)) = '<ItemList/>'	
 	begin
 		insert into @DiagnosisTable (
 			[key],
 			[value]
 		) 
 		select tbr.idfsBaseReference, tbr.strBaseReferenceCode
 		from trtBaseReference tbr
 			inner join trtBaseReferenceToCP tbrtc
			on tbrtc.idfsBaseReference = tbr.idfsBaseReference
			
			inner join tstCustomizationPackage cp
			on cp.idfCustomizationPackage = tbrtc.idfCustomizationPackage
			and cp.idfsCountry = @CountryID
			
			inner join trtBaseReferenceAttribute tbra3
 				inner join trtAttributeType tat3
 				on tat3.idfAttributeType = tbra3.idfAttributeType
 				and tat3.strAttributeTypeName = 'QI Laboratory Confirmation'
 			on tbra3.idfsBaseReference = tbr.idfsBaseReference
 		where tbr.idfsReferenceType = 19000019 /*diagnosis*/
 		and tbr.intRowStatus = 0
 		and (tbr.intHACode & 2) > 1
 		--and tbr.strBaseReferenceCode like '%;%'
 	end
 	
 	
 	-- new !
 	update dt set
 		dt.intNotificationToCHE	=			case 
 												when SQL_VARIANT_PROPERTY(tbra1.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')  
 												then cast(tbra1.varValue as int)
 												else null
 											end,
		dt.intStartingDTOfInvestigation =	case 
 												when SQL_VARIANT_PROPERTY(tbra2.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')  
 												then cast(tbra2.varValue as int)
 												else null
 											end,
		dt.blnLaboratoryConfirmation =		case 
 												when SQL_VARIANT_PROPERTY(tbra3.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')  
 												then cast(tbra3.varValue as int)
 												else null
 											end,
		dt.intQuantityOfMandatoryFieldCS =	case 
 												when SQL_VARIANT_PROPERTY(tbra5.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')  
 												then cast(tbra5.varValue as int)
 												else null
 											end,
		dt.intQuantityOfMandatoryFieldCSForDC =	case 
 													when SQL_VARIANT_PROPERTY(tbra6.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')  
 													then cast(tbra6.varValue as int)
 													else null
 												end,
		dt.intEPILincsAndFactors =			case 
 												when SQL_VARIANT_PROPERTY(tbra7.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')  
 												then cast(tbra7.varValue as int)
 												else null
 											end								
 	from @DiagnosisTable dt
 		left join trtBaseReferenceAttribute tbra1
 			inner join trtAttributeType tat1
 			on tat1.idfAttributeType = tbra1.idfAttributeType
 			and tat1.strAttributeTypeName = 'QI Transmission of Emergency Notification to CHE'
 		on tbra1.idfsBaseReference = dt.[key]
 		
 		left join trtBaseReferenceAttribute tbra2
 			inner join trtAttributeType tat2
 			on tat2.idfAttributeType = tbra2.idfAttributeType
 			and tat2.strAttributeTypeName = 'QI Starting date, time of investigation'
 		on tbra2.idfsBaseReference = dt.[key]
 		
 		left join trtBaseReferenceAttribute tbra3
 			inner join trtAttributeType tat3
 			on tat3.idfAttributeType = tbra3.idfAttributeType
 			and tat3.strAttributeTypeName = 'QI Laboratory Confirmation'
 		on tbra3.idfsBaseReference = dt.[key]
 		
 	 	left join trtBaseReferenceAttribute tbra5
 			inner join trtAttributeType tat5
 			on tat5.idfAttributeType = tbra5.idfAttributeType
 			and tat5.strAttributeTypeName = 'QI Quantity of mandatory fields of Clinical Signs'
 		on tbra5.idfsBaseReference = dt.[key]
 	 	
 	 	left join trtBaseReferenceAttribute tbra6
 			inner join trtAttributeType tat6
 			on tat6.idfAttributeType = tbra6.idfAttributeType
 			and tat6.strAttributeTypeName = 'QI Quantity of mandatory fields of Clinical Signs that’s nesessary for diagnosis confirmation by Clinical Signs ("Yes")'
 		on tbra6.idfsBaseReference = dt.[key]
 		
 	 	left join trtBaseReferenceAttribute tbra7
 			inner join trtAttributeType tat7
 			on tat7.idfAttributeType = tbra7.idfAttributeType
 			and tat7.strAttributeTypeName = 'QI Epidemiological Links and Risk Factors - Minimum quantity logically filled fields.'
 		on tbra7.idfsBaseReference = dt.[key] 		
 		 	 	
 	
 	--select * from @DiagnosisTable dt
 	--inner join trtDiagnosis td
 	--on  dt.[key] = td.idfsDiagnosis
 	--inner join trtBaseReference tbr
 	--on tbr.idfsBaseReference = td.idfsDiagnosis
 	
 	
	-- new
	--1.
	select 
		@Ind_1_Notification = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '1.Notification'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
	
	--1.1.
 	select 
		@Ind_N1_CaseStatus = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '1.1. Case Status'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
	
	--1.2.
	select 
		@Ind_N1_DateofCompletionPF = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '1.2. Date of Completion of Paper form'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
	
	--1.3.
	select 
		@Ind_N1_NameofEmployer = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '1.3. Name of Employer'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 	
 	
 	--1.5.
 	select 
		@Ind_N1_CurrentLocationPatient = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '1.5. Current location of patient'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 	
 	
 	--1.6.
 	select 
		@Ind_N1_NotifDateTime = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '1.6. Notification date, time'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
	
	select 
		@Ind_N2_NotifDateTime = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
			on tat.idfAttributeType = tbra.idfAttributeType
			and tat.strAttributeTypeName = 'Indicators Max Score N2'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '1.6. Notification date, time'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
	
	select 
		@Ind_N3_NotifDateTime = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
			on tat.idfAttributeType = tbra.idfAttributeType
			and tat.strAttributeTypeName = 'Indicators Max Score N3'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '1.6. Notification date, time'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')	
	
	--1.8.
 	select 
		@Ind_N1_NotifSentByName = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '1.8. Notification sent by: Name'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
 	
 	--1.9.
 	select 
		@Ind_N1_NotifReceivedByFacility = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '1.9. Notification received by: Facility'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
 	
 	--1.10.
 	select 
		@Ind_N1_NotifReceivedByName = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '1.10. Notification received by: Name'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
 	
 	--1.11.
 	select 
		@Ind_N1_TimelinessOfDataEntryDTEN = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '1.11. Timeliness of Data Entry, date and time of the Emergency Notification'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
	
	select 
		@Ind_N2_TimelinessOfDataEntryDTEN = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
			on tat.idfAttributeType = tbra.idfAttributeType
			and tat.strAttributeTypeName = 'Indicators Max Score N2'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '1.11. Timeliness of Data Entry, date and time of the Emergency Notification'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
	
	select 
		@Ind_N3_TimelinessOfDataEntryDTEN = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
			on tat.idfAttributeType = tbra.idfAttributeType
			and tat.strAttributeTypeName = 'Indicators Max Score N3'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '1.11. Timeliness of Data Entry, date and time of the Emergency Notification'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')	 	
 	
 	--2.
 	select 
		@Ind_2_CaseInvestigation = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2. Case Investigation'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 	
 	--2.1.1.
 	select 
		@Ind_N1_DIStartingDTOfInvestigation = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2.1.1. Demographic Information -Starting date, time of investigation'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
	
	select 
		@Ind_N2_DIStartingDTOfInvestigation = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
			on tat.idfAttributeType = tbra.idfAttributeType
			and tat.strAttributeTypeName = 'Indicators Max Score N2'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2.1.1. Demographic Information -Starting date, time of investigation'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
	
	select 
		@Ind_N3_DIStartingDTOfInvestigation = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
			on tat.idfAttributeType = tbra.idfAttributeType
			and tat.strAttributeTypeName = 'Indicators Max Score N3'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2.1.1. Demographic Information -Starting date, time of investigation'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')	 	 	
 	
 	--2.1.2.
 	select 
		@Ind_N1_DIOccupation = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2.1.2. Demographic Information – Occupation'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
	
	--2.2.1.
 	select 
		@Ind_N1_CIInitCaseClassification = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2.2.1. Clinical information - Initial Case Classification'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
 	
 	--2.2.2.
 	select 
		@Ind_N1_CILocationOfExposure = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2.2.2. Clinical information - Location of Exposure if it known'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
 	
 	--2.2.3.
 	select 
		@Ind_N1_CIAntibioticTherapyAdministratedBSC = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2.2.3. Clinical information - Antibiotic/Antiviral therapy administrated before samples collection'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
 	
 	--2.3.1.
 	select 
		@Ind_N1_SamplesCollection = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2.3.1. Samples Collection  - Samples collected'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
 	
 	--2.4.1.
 	select 
		@Ind_N1_ContactLisAddContact = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2.4.1. Contact List  - Add Contact'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
 	
 	--2.5.
 	select 
		@Ind_N1_CaseClassificationCS = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2.5. Case Classification (Clinical signs)'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
 	
 	--2.6.1.
 	select 
		@Ind_N1_EpiLinksRiskFactorsByEpidCard = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2.6.1. Epidemiological Links and Risk Factors - by Epidemiological card'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
	
	select 
		@Ind_N2_EpiLinksRiskFactorsByEpidCard = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
			on tat.idfAttributeType = tbra.idfAttributeType
			and tat.strAttributeTypeName = 'Indicators Max Score N2'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2.6.1. Epidemiological Links and Risk Factors - by Epidemiological card'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
	
	select 
		@Ind_N3_EpiLinksRiskFactorsByEpidCard = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
			on tat.idfAttributeType = tbra.idfAttributeType
			and tat.strAttributeTypeName = 'Indicators Max Score N3'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2.6.1. Epidemiological Links and Risk Factors - by Epidemiological card'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')	 	
 	

 	--2.7.3.
 	select 
		@Ind_N1_FCCOBasisOfDiagnosis = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2.7.3. Final Case Classification and Outcome - Basis of Diagnosis'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
	
	--2.7.4.
 	select 
		@Ind_N1_FCCOOutcome = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2.7.4. Final Case Classification and Outcome – Outcome'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
 	
 	--2.7.5.
 	select 
		@Ind_N1_FCCOIsThisCaseRelatedToOutbreak = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2.7.5. Final Case Classification and Outcome - Is this case related to an outbreak'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
 	
 	--2.7.6.
 	select 
		@Ind_N1_FCCOEpidemiologistName = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '2.7.6. Final Case Classification and Outcome - Epidemiologist name'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint') 
 	
 	--3.
 	select 
		@Ind_3_TheResultsOfLabTestsAndInterpretation = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '3.The results of Laboratory Tests and  Interpretation'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 	
 	--3.1.
 	select 
		@Ind_N1_ResultsOfLabTestsTestsConducted = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '3.1. The results of Laboratory Tests and Interpretation - Tests Conducted'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 	
 	--3.2.
	select 
		@Ind_N1_ResultsOfLabTestsResultObservation = cast(tbra.varValue as numeric(4,2))
	from trtBaseReferenceAttribute tbra
		inner join trtAttributeType tat
 			on tat.idfAttributeType = tbra.idfAttributeType
 			and tat.strAttributeTypeName = 'Indicators Max Score N'
	where tbra.idfsBaseReference = @idfsCustomReportType
	and tbra.strAttributeItem = '3.2. The results of Laboratory Tests and Interpretation - Result/Observation'
	and SQL_VARIANT_PROPERTY(tbra.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')  
 

 
 	--Transport CHE
 	declare @TransportCHE bigint
 
 	select @TransportCHE = frr.idfsReference
 	from dbo.fnGisReferenceRepair('en', 19000020) frr
 	where frr.name =  'Transport CHE'
 	print @TransportCHE
 	

	--1344330000000 --Baku
	select @idfsRegionBaku = tbra.idfsGISBaseReference
	from trtGISBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'AZ Region'
	where cast(tbra.varValue as nvarchar(100)) = N'Baku'

	--1344340000000 --Other rayons
	select @idfsRegionOtherRayons = tbra.idfsGISBaseReference
	from trtGISBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'AZ Region'
	where cast(tbra.varValue as nvarchar(100)) = N'Other rayons'


	--1344350000000 --Nakhichevan AR
	select @idfsRegionNakhichevanAR = tbra.idfsGISBaseReference
	from trtGISBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'AZ Region'
	where cast(tbra.varValue as nvarchar(100)) = N'Nakhichevan AR'
	
	
	-------------------------------------------
	declare @isTLVL bigint
	set @isTLVL = 0
	
	select @isTLVL = case when ts.idfsSiteType = 10085007 then 1 else 0 end 
	from tstSite ts
	where ts.idfsSite = isnull(@SiteID, dbo.fnSiteID())

	declare @isWeb bigint
	set @isWeb = 0 
  
	select @isWeb = isnull(ts.blnIsWEB, 0) 
	from tstSite ts
	where ts.idfsSite = dbo.fnSiteID()  
	-------------------------------------------
  
  
	
  
    if OBJECT_ID('tempdb.dbo.#FilteredRayonsTable') is not null 
	drop table #FilteredRayonsTable
	create table #FilteredRayonsTable  
	(
	idfsRegion bigint,
	idfsRayon bigint,
	primary key (idfsRegion, idfsRayon)  
	)
  
  	--declare #ReportDataTable table
  	if OBJECT_ID('tempdb.dbo.#ReportDataTable') is not null 
	drop table #ReportDataTable
	create table #ReportDataTable
	(
		id int identity(1,1) primary key,
 		IdRegion bigint,
 		strRegion nvarchar(2000) collate database_default,
 		IdRayon	bigint,
 		strRayon nvarchar(2000) collate database_default,
 		strAZRayon nvarchar(2000) collate database_default,
 		IdDiagnosis bigint,
 		Diagnosis nvarchar(2000) collate database_default,
 		intRegionOrder int,
 		intRayonOrder int,
 		CountCasesForDiag int
 	)
  

  	--declare #ReportCaseTable table
  	if OBJECT_ID('tempdb.dbo.#ReportCaseTable') is not null 
	drop table #ReportCaseTable
  	create table #ReportCaseTable
	(
					id int identity(1,1) primary key,
 					idfCase bigint,
 					IdRegion bigint,
 					strRegion nvarchar(2000) collate database_default,
 					IdRayon	bigint,
 					strRayon nvarchar(2000) collate database_default,
 					strAZRayon  nvarchar(2000) collate database_default,
 					intRegionOrder int,
 					intRayonOrder int,
 					idfsShowDiagnosis bigint,
 					Diagnosis nvarchar(2000) collate database_default,	
 					idfsShowDiagnosisFromCase bigint,	
 																				
 		/*7(1)*/	IndCaseStatus float, 
 		/*8(2)*/	IndDateOfCompletionPaperFormDate float, 
 		/*9(3)*/	IndNameOfEmployer float, 
 		/*11(5)*/	IndCurrentLocation float, 
 		/*12(6)*/	IndNotificationDate float, 
 		/*13(7)*/	IndNotificationSentByName float, 
 		/*14(8)*/	IndNotificationReceivedByFacility float, 
 		/*15(9)*/	IndNotificationReceivedByName float,
 		/*16(10)*/	IndDateAndTimeOfTheEmergencyNotification float, 
 		
 		/*18(11)*/	IndInvestigationStartDate float, 
 		/*19(12)*/	IndOccupationType float, 
 		/*20(13)*/	IndInitialCaseClassification float, 
 		/*21(14)*/	IndLocationOfExplosure float, 
 		/*22(15)*/	IndAATherapyAdmBeforeSamplesCollection float, 
 		/*23(16)*/	IndSamplesCollected float, 
 		/*24(17)*/	IndAddcontact float, 
 		/*25(18)*/	IndClinicalSigns float, 
 		/*26(19)*/	IndEpidemiologicalLinksAndRiskFactors float,

 		/*27(20)*/	IndBasisOfDiagnosis float, 
 		/*28(21)*/	IndOutcome float, 
 		/*29(22)*/	IndISThisCaseRelatedToOutbreak float, 
 		/*30(23)*/	IndEpidemiologistName float, 

 		/*32(24)*/	IndResultsTestsConducted float, 
 		/*33(25)*/	IndResultsResultObservation float 
	)
	
	if OBJECT_ID('tempdb.dbo.#ReportCaseTable_CountForDiagnosis') is not null 
	drop table #ReportCaseTable_CountForDiagnosis
	create table #ReportCaseTable_CountForDiagnosis
	(
	CountCase int
 	, IdRegion bigint
 	, IdRayon bigint
	, idfsShowDiagnosis bigint
	primary key (IdRegion, IdRayon, idfsShowDiagnosis)
	)
 		
 
	insert into #FilteredRayonsTable
	select  
		case when s_current.intFlags = 1 and cp.idfsCountry = @CountryID then @TransportCHE else gls.idfsRegion end as idfsRegion,
		case when s_current.intFlags = 1 and cp.idfsCountry = @CountryID then s_current.idfsSite else gls.idfsRayon end as idfsRayon
	from  tstSite s_current
		inner join	tstCustomizationPackage cp
		on			cp.idfCustomizationPackage = s_current.idfCustomizationPackage
					and cp.idfsCountry = @CountryID
		inner join	tlbOffice o_current
		on			o_current.idfOffice = s_current.idfOffice
					and o_current.intRowStatus = 0
		inner join	tlbGeoLocationShared gls
		on			gls.idfGeoLocationShared = o_current.idfLocation
	where  s_current.idfsSite = isnull(@SiteID, dbo.fnSiteID())
	   and gls.idfsRayon is not null
	union
	select  
		case when s.intFlags = 1 and cp.idfsCountry = @CountryID then @TransportCHE else gls.idfsRegion end as idfsRegion,
		case when s.intFlags = 1 and cp.idfsCountry = @CountryID then s.idfsSite else gls.idfsRayon end as idfsRayon
	from  tstSite s
		inner join	tstCustomizationPackage cp
		on			cp.idfCustomizationPackage = s.idfCustomizationPackage	
					and cp.idfsCountry = @CountryID
		
		inner join	tlbOffice o
		on			o.idfOffice = s.idfOffice
					and o.intRowStatus = 0
		inner join	tlbGeoLocationShared gls
		on			gls.idfGeoLocationShared = o.idfLocation
		
		inner join	tflSiteToSiteGroup sts
			inner join	tflSiteGroup tsg
			on			tsg.idfSiteGroup = sts.idfSiteGroup
						and tsg.idfsRayon is null
		on			sts.idfsSite = s.idfsSite
		
		inner join	tflSiteGroupRelation sgr
		on			sgr.idfSenderSiteGroup = sts.idfSiteGroup
		
		inner join	tflSiteToSiteGroup stsr
			inner join	tflSiteGroup tsgr
			on			tsgr.idfSiteGroup = stsr.idfSiteGroup
						and tsgr.idfsRayon is null
		on			sgr.idfReceiverSiteGroup =stsr.idfSiteGroup
					and stsr.idfsSite = isnull(@SiteID, dbo.fnSiteID())
	where  gls.idfsRayon is not null		
    
	-- + border area
	insert into #FilteredRayonsTable (idfsRayon)
	select distinct
		osr.idfsRayon
	from #FilteredRayonsTable fr
		inner join gisRayon r
          on r.idfsRayon = fr.idfsRayon
          and r.intRowStatus = 0
          
        inner join	tlbGeoLocationShared gls
		on			gls.idfsRayon = r.idfsRayon
	
		inner join	tlbOffice o
		on			gls.idfGeoLocationShared = o.idfLocation
					and o.intRowStatus = 0
		
		inner join tstSite s
			inner join	tstCustomizationPackage cp
			on			cp.idfCustomizationPackage = s.idfCustomizationPackage	
		on s.idfOffice = o.idfOffice
		
		inner join tflSiteGroup tsg_cent 
		on tsg_cent.idfsCentralSite = s.idfsSite
		and tsg_cent.idfsRayon is null
		and tsg_cent.intRowStatus = 0	
		
		inner join tflSiteToSiteGroup tstsg
		on tstsg.idfSiteGroup = tsg_cent.idfSiteGroup
		
		inner join tstSite ts
		on ts.idfsSite = tstsg.idfsSite
		
		inner join tlbOffice os
		on os.idfOffice = ts.idfOffice
		and os.intRowStatus = 0
		
		inner join tlbGeoLocationShared ogl
		on ogl.idfGeoLocationShared = o.idfLocation
		
		inner join gisRayon osr
		on osr.idfsRayon = ogl.idfsRayon
		and ogl.intRowStatus = 0				
		
		left join #FilteredRayonsTable fr2 
		on	osr.idfsRayon = fr2.idfsRayon
	where fr2.idfsRayon is null
	

	insert into #ReportDataTable
	(IdRegion
 	,strRegion
 	,IdRayon
 	,strRayon
 	,strAZRayon
 	,IdDiagnosis
 	,Diagnosis
 	,intRegionOrder
 	,intRayonOrder
	)
 	
 	select
 		reg.idfsRegion			as IdRegion
 		, refReg.[name]			as strRegion
 		, ray.idfsRayon			as IdRayon
 		, refRay.[name]			as strRayon
 		, refRayAZ.[name]		as strAZRayon
 		, 0						as IdDiagnosis
 		, ''					as Diagnosis
 		, case reg.idfsRegion
				  when @idfsRegionBaku --1344330000000 --Baku
				  then 1
			      
				  when @idfsRegionOtherRayons --1344340000000 --Other rayons
				  then 2
			      
				  when @idfsRegionNakhichevanAR --1344350000000 --Nakhichevan AR
				  then 3
			      
				  else 0
		  end 					as intRegionOrder
 		, 0						as intRayonOrder		
 	from gisRegion as reg
 	join fnGisReference(@LangID, 19000003 /*rftRegion*/) as refReg on
 		reg.idfsRegion = refReg.idfsReference			
 		and reg.idfsCountry = @CountryID
 	join gisRayon as ray on
 		ray.idfsRegion = reg.idfsRegion	
 	join fnGisReference(@LangID, 19000002 /*rftRayon*/) as refRay on
 		ray.idfsRayon = refRay.idfsReference
 	join fnGisReference('az-l', 19000002 /*rftRayon*/) as refRayAZ on
 		ray.idfsRayon = refRayAZ.idfsReference
	left join #FilteredRayonsTable frt
 		on frt.idfsRegion = reg.idfsRegion
 		and frt.idfsRayon = ray.idfsRayon 	

 	where cast(@Diagnosis as nvarchar(max)) = '<ItemList/>'
 	and (@isTLVL = 0 or frt.idfsRayon is not null or @isWeb = 1)
 	
 	
   union all
 	
 	select 
 		tbr.idfsGISBaseReference		as IdRegion
 		, frr.[name]					as strRegion
 		, ts.idfsSite					as IdRayon
 		, fir.[name]					as strRayon
 		, firAZ.[name]					as strAZRayon
 		, 0								as IdDiagnosis
 		, ''							as Diagnosis 		
 		, 4								as intRegionOrder
 		, tbr1.intOrder					as intRayonOrder		
 	from gisBaseReference tbr --TransportCHE
 	join dbo.fnGisReferenceRepair(@LangID, 19000020) frr
 		on frr.idfsReference = tbr.idfsGISBaseReference
 		and tbr.idfsGISBaseReference = @TransportCHE
	cross join tstSite ts
		left join #FilteredRayonsTable frt
 		on frt.idfsRegion = @TransportCHE
 		and frt.idfsRayon = ts.idfsSite

 	join tstCustomizationPackage cp
 		on cp.idfCustomizationPackage = ts.idfCustomizationPackage
 		and cp.idfsCountry = @CountryID
	join dbo.fnInstitutionRepair(@LangID) fir	
		on fir.idfOffice = ts.idfOffice
		and ts.intFlags = 1
	join dbo.fnInstitutionRepair('az-l') firAZ	
		on firAZ.idfOffice = ts.idfOffice
		and ts.intFlags = 1
	join trtBaseReference tbr1
	on tbr1.idfsBaseReference = fir.idfsOfficeAbbreviation 
 	where cast(@Diagnosis as nvarchar(max)) = '<ItemList/>'		 	
	and (@isTLVL = 0 or frt.idfsRayon is not null or @isWeb = 1)
	
 	

	union all
	
	select
 		reg.idfsRegion			as IdRegion
 		, refReg.[name]			as strRegion
 		, ray.idfsRayon			as IdRayon
 		, refRay.[name]			as strRayon
 		, refRayAZ.[name]		as strAZRayon
 		, cast(dt.[key] as bigint)				as IdDiagnosis
 		, refDiag.name			as Diagnosis
 		, case reg.idfsRegion
				  when @idfsRegionBaku --1344330000000 --Baku
				  then 1
			      
				  when @idfsRegionOtherRayons --1344340000000 --Other rayons
				  then 2
			      
				  when @idfsRegionNakhichevanAR --1344350000000 --Nakhichevan AR
				  then 3
			      
				  else 0
		  end 					as intRegionOrder
 		, 0						as intRayonOrder
 	from gisRegion as reg
 	join fnGisReference(@LangID, 19000003 /*rftRegion*/) as refReg on
 		reg.idfsRegion = refReg.idfsReference			
 		and reg.idfsCountry = @CountryID
 	join gisRayon as ray on
 		ray.idfsRegion = reg.idfsRegion	
 	join fnGisReference(@LangID, 19000002 /*rftRayon*/) as refRay on
 		ray.idfsRayon = refRay.idfsReference	
 	join fnGisReference('az-l', 19000002 /*rftRayon*/) as refRayAZ on
 		ray.idfsRayon = refRayAZ.idfsReference
	left join #FilteredRayonsTable frt
 		on frt.idfsRegion = reg.idfsRegion
 		and frt.idfsRayon = ray.idfsRayon

 	CROSS join @DiagnosisTable as dt	
 	join fnReferenceRepair(@LangID, 19000019 /*rftDiagnosis*/) as refDiag on
 		dt.[key] = refDiag.idfsReference	
 	where cast(@Diagnosis as nvarchar(max)) <> '<ItemList/>'
 	and (@isTLVL = 0 or frt.idfsRayon is not null or @isWeb = 1)
 	
 	
 	union all
 	
 	select 
 		tbr.idfsGISBaseReference		as IdRegion
 		, frr.[name]					as strRegion
 		, ts.idfsSite					as IdRayon
 		, fir.[name]					as strRayon
 		, firAZ.[name]					as strAZRayon
		, cast(dt.[key] as bigint)		as IdDiagnosis
 		, refDiag.name					as Diagnosis
 		, 4								as intRegionOrder
 		, tbr1.intOrder					as intRayonOrder		
 	from gisBaseReference tbr --TransportCHE
 	join dbo.fnGisReferenceRepair(@LangID, 19000020) frr
 		on frr.idfsReference = tbr.idfsGISBaseReference
 		and tbr.idfsGISBaseReference = @TransportCHE
	cross join tstSite ts
		left join #FilteredRayonsTable frt
 		on frt.idfsRegion = @TransportCHE
 		and frt.idfsRayon = ts.idfsSite
 	join tstCustomizationPackage cp
 		on cp.idfCustomizationPackage = ts.idfCustomizationPackage
 		and cp.idfsCountry = @CountryID 		
	join dbo.fnInstitutionRepair(@LangID) fir	
		on fir.idfOffice = ts.idfOffice
		and ts.intFlags = 1
	join dbo.fnInstitutionRepair('az-l') firAZ
		on firAZ.idfOffice = ts.idfOffice
		and ts.intFlags = 1		
	join trtBaseReference tbr1
		on tbr1.idfsBaseReference = fir.idfsOfficeAbbreviation 
 	cross join @DiagnosisTable as dt	
 	join fnReferenceRepair(@LangID, 19000019 /*rftDiagnosis*/) as refDiag 
 		on	dt.[key] = refDiag.idfsReference	
 	where cast(@Diagnosis as nvarchar(max)) <> '<ItemList/>'		
	and (@isTLVL = 0 or frt.idfsRayon is not null or @isWeb = 1)
	
	 	
	
	declare @EPI table 
	(
	idfHumanCase bigint primary key,
	countEPI int	
	)
	
	insert into @EPI (idfHumanCase, countEPI)
	select 
		hcs.idfHumanCase,
		count(tap.idfActivityParameters) as countEPI
	from tlbHumanCase hcs
		inner join tlbObservation obs
		on obs.idfObservation = hcs.idfEpiObservation
		and obs.intRowStatus = 0
				
		inner join ffFormTemplate fft
		on fft.idfsFormTemplate = obs.idfsFormTemplate
		and idfsFormType = 10034011 /*Human Epi Investigations*/ 

		inner join dbo.ffParameterForTemplate pft
		on pft.idfsFormTemplate = obs.idfsFormTemplate
		and pft.intRowStatus = 0					
	
		inner join ffParameter fp
			inner join ffParameterType fpt
			on fpt.idfsParameterType = fp.idfsParameterType
			and fpt.idfsReferenceType is not null
			and fpt.intRowStatus = 0
		on fp.idfsParameter = pft.idfsParameter 
		and fp.idfsFormType = 10034011 /*Human Epi Investigations*/ 
		--and fp.idfsParameterType = 217140000000 /*Y_N_Unk*/
		and fp.intRowStatus = 0
	
		inner join tlbActivityParameters tap
		on tap.idfObservation = obs.idfObservation
		and tap.idfsParameter = fp.idfsParameter
		and (
			fp.idfsParameterType = 217140000000 /*Y_N_Unk*/ and cast(tap.varValue as nvarchar)  in ( N'25460000000' /*pfv_YNU_yes*/ , N'25640000000' /*pfv_YNU_no*/)
			or
			fp.idfsParameterType <> 217140000000 and tap.varValue is not null
			)
		and tap.intRowStatus = 0
	where hcs.intRowStatus = 0 
 		and hcs.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/  
 		and (@SDDate <= hcs.datFinalCaseClassificationDate and hcs.datFinalCaseClassificationDate < @EDDate)
	group by hcs.idfHumanCase

 	--select epi.idfHumanCase, epi.countEPI, thc.strCaseID from @EPI epi
 	--inner join tlbHumanCase thc
 	--on thc.idfHumanCase = epi.idfHumanCase
 	--where thc.strCaseID = 'HWEB00155811'
 	
 	
 	
 	declare @CS table 
	(
	idfHumanCase bigint primary key,
	countCS int,
	blnUNI bit
	)
	
	insert into @CS (idfHumanCase, countCS, blnUNI)
	select 
		hcs.idfHumanCase,
		count(tap.idfActivityParameters) as countCS,
		fft.blnUNI
		
	from tlbHumanCase hcs
		inner join tlbObservation obs
		on obs.idfObservation = hcs.idfCSObservation
		and obs.intRowStatus = 0
		
		inner join dbo.ffParameterForTemplate pft
		on pft.idfsFormTemplate = obs.idfsFormTemplate
		and pft.idfsEditMode = 10068003 /*Mandatory*/
		and pft.idfsFormTemplate = obs.idfsFormTemplate
		and pft.intRowStatus = 0
		
		inner join ffFormTemplate fft
		on fft.idfsFormTemplate = pft.idfsFormTemplate
		
		left join ffParameter fp
		on fp.idfsParameter = pft.idfsParameter
		and (fp.idfsParameterType = 217140000000 /*Y_N_Unk*/ or fp.idfsParameterType = 10071045	 /*text - parString*/)
		and fp.idfsFormType = 10034010 /*Human Clinical Signs*/ 
		and fp.intRowStatus = 0
					
		inner join tlbActivityParameters tap
		on tap.idfObservation = obs.idfObservation
		and tap.idfsParameter = fp.idfsParameter
		and tap.intRowStatus = 0
		
		and (
			(cast(tap.varValue as nvarchar) = N'25460000000' /*pfv_YNU_yes,	Yes*/ 
			and fp.idfsParameterType = 217140000000 /*Y_N_Unk*/
			and fft.blnUNI = 0
			)
			or
			(fft.blnUNI = 1 and
			fp.idfsParameterType = 10071045	 /*text - parString*/
			and cast(tap.varValue as nvarchar(500)) <> ''
			)
		)
	
		
	where hcs.intRowStatus = 0 
 		and hcs.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/  
 		and (@SDDate <= hcs.datFinalCaseClassificationDate and hcs.datFinalCaseClassificationDate < @EDDate)
	group by hcs.idfHumanCase, fft.blnUNI
 		

 	--select cs.idfHumanCase, cs.countCS, thc.strCaseID from @CS cs
 	--inner join tlbHumanCase thc
 	--on thc.idfHumanCase = cs.idfHumanCase
 	
 	--inner join tlbHuman th
 	--on th.idfHuman = thc.idfHuman
 	
 	--inner join tlbGeoLocation tgl
 	--on tgl.idfGeoLocation = th.idfCurrentResidenceAddress
 	--and tgl.idfsRayon = 1344420000000
 	--where thc.strCaseID = 'HWEB00154695'
 	
 	
 		
	if OBJECT_ID('tempdb.dbo.#CCP') is not null 
	drop table #CCP
 	create table  #CCP  
	(
	idfHumanCase bigint primary key,
	countCCP int	
	)
	
	insert into #CCP (idfHumanCase, countCCP)
	select tccp.idfHumanCase,
 			count(tccp.idfContactedCasePerson) as CountContacts
 		from tlbContactedCasePerson tccp 
 		inner join tlbHumanCase thc
 		on thc.idfHumanCase = tccp.idfHumanCase
 		where thc.intRowStatus = 0 
 		and thc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/  
 		and (@SDDate <= thc.datFinalCaseClassificationDate and thc.datFinalCaseClassificationDate < @EDDate)
 		and tccp.intRowStatus = 0
 	group by tccp.idfHumanCase

	
	
	if OBJECT_ID('tempdb.dbo.#CTR') is not null 
	drop table #CTR
 	create table  #CTR  
	(
	idfHumanCase bigint primary key,
	countCTR int	
	)
	
	insert into #CTR (idfHumanCase, countCTR)
	select m.idfHumanCase, count(tt.idfTesting) as CountTestResults
 		from tlbMaterial m
 			inner join tlbTesting tt
 			on tt.idfMaterial = m.idfMaterial
 			and tt.intRowStatus = 0
 			and tt.idfsTestResult is not null
 			inner join tlbHumanCase thc
 			on thc.idfHumanCase = m.idfHumanCase
 		where thc.intRowStatus = 0 
 			and thc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/  
 			and (@SDDate <= thc.datFinalCaseClassificationDate and thc.datFinalCaseClassificationDate < @EDDate)
 			and m.intRowStatus = 0
 			and m.idfHumanCase is not null
 		group by m.idfHumanCase
 			
	
	insert into #ReportCaseTable 
	(
 					idfCase,
 					IdRegion,
 					strRegion,
 					IdRayon,
 					strRayon,
 					strAZRayon,
 					intRegionOrder,
 					intRayonOrder,
 					idfsShowDiagnosis,
 					Diagnosis,	
 					idfsShowDiagnosisFromCase,	
 																				
 		/*7(1)*/	IndCaseStatus, 			
 		/*8(2)*/	IndDateOfCompletionPaperFormDate, 
 		/*9(3)*/	IndNameOfEmployer, 
 		/*11(5)*/	IndCurrentLocation, 
 		/*12(6)*/	IndNotificationDate, 
 		/*13(7)*/	IndNotificationSentByName, 
 		/*14(8)*/	IndNotificationReceivedByFacility, 
 		/*15(9)*/	IndNotificationReceivedByName,
 		/*16(10)*/	IndDateAndTimeOfTheEmergencyNotification, 
 		
 		/*18(11)*/	IndInvestigationStartDate, 
 		/*19(12)*/	IndOccupationType, 
 		/*20(13)*/	IndInitialCaseClassification, 
 		/*21(14)*/	IndLocationOfExplosure, 
 		/*22(15)*/	IndAATherapyAdmBeforeSamplesCollection, 
 		/*23(16)*/	IndSamplesCollected, 
 		/*24(17)*/	IndAddcontact, 
 		/*25(18)*/	IndClinicalSigns, 
 		/*26(19)*/	IndEpidemiologicalLinksAndRiskFactors, 
 		
 		/*27(20)*/	IndBasisOfDiagnosis, 
 		/*28(21)*/	IndOutcome, 
 		/*29(22)*/	IndISThisCaseRelatedToOutbreak, 
 		/*30(23)*/	IndEpidemiologistName, 
 		
 		/*32(24)*/	IndResultsTestsConducted, 
 		/*33(25)*/	IndResultsResultObservation 
	 )	
	 select
 		hc.idfHumanCase as idfCase
 		, fdt.IdRegion 
 		, fdt.strRegion 
 		, fdt.IdRayon
 		, fdt.strRayon 
 		, fdt.strAZRayon
 		, fdt.intRegionOrder
 		, fdt.intRayonOrder
 		, isnull(fdt.IdDiagnosis, '')											as idfsShowDiagnosis 
 		, isnull(fdt.Diagnosis, '')												as Diagnosis 	
 		, isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)				as idfsShowDiagnosisFromCase		
 																		
 		,/*7(1)*/ 
 		case 
 			when hc.idfsCaseProgressStatus = 10109002 /*Closed*/ 
 				then @Ind_N1_CaseStatus 
 			else 0.00 
 		end	as IndCaseStatus 
 		
 		,/*8(2)*/ 
 		case 
 			when isnull(hc.datCompletionPaperFormDate, '') <> '' 
 				then @Ind_N1_DateofCompletionPF 
 			else 0.00 
 		end		as IndDateOfCompletionPaperFormDate 
 		
 		,/*9(3)*/ 
 		case 
 			when isnull(h.strEmployerName, '') <> '' 
 				then @Ind_N1_NameofEmployer 
 			else 0.00 
 		end	as IndNameOfEmployer 
 		
 		,/*11(5)*/ 
 		case 
 			when isnull(hc.idfsHospitalizationStatus, 0) <> 0 
 				then @Ind_N1_CurrentLocationPatient 
 			else 0.00 
 		end		as IndCurrentLocation 
 		
 		,/*12(6)*/ 
 		case 
 			when (isnull(hc.datCompletionPaperFormDate, '') <> '' and hc.datCompletionPaperFormDate = hc.datNotificationDate)
 					OR (
 							isnull(hc.datCompletionPaperFormDate, '') <> '' 
 							and isnull(hc.datNotificationDate, '') <> '' 
 							and cast(hc.datNotificationDate - hc.datCompletionPaperFormDate as float) < 1
 						)
 				then @Ind_N1_NotifDateTime
 			when isnull(hc.datCompletionPaperFormDate, '') <> '' 
 					and isnull(hc.datNotificationDate, '') <> '' 
 					and cast(dbo.fnDateCutTime(hc.datNotificationDate) - dbo.fnDateCutTime(hc.datCompletionPaperFormDate) as float) between 1 and 2
 				then @Ind_N2_NotifDateTime
 			when isnull(hc.datCompletionPaperFormDate, '') <> ''
 					and isnull(hc.datNotificationDate, '') <> ''
 					and cast(dbo.fnDateCutTime(hc.datNotificationDate) - dbo.fnDateCutTime(hc.datCompletionPaperFormDate) as float) > 2
 				then @Ind_N3_NotifDateTime
 			else 0.00
 		end	as IndNotificationDate 
 		
 		
 		,/*13(7)*/ 
		case 
			when isnull(hc.idfSentByPerson, '') <> '' 
				then @Ind_N1_NotifSentByName 
			else 0.00 
		end	as IndNotificationSentByName 
 		
 		,/*14(8)*/ 
		case 
			when isnull(hc.idfReceivedByOffice, '') <> '' 
				then @Ind_N1_NotifReceivedByFacility 
			else 0.00 
		end	as IndNotificationReceivedByFacility 
 		
 		,/*15(9)*/ 
		case 
			when isnull(hc.idfReceivedByPerson, '') <> ''
				then @Ind_N1_NotifReceivedByName 
			else 0.00 
		end	as IndNotificationReceivedByName
 		
 		,/*16(10)*/ 
		case 
			when isnull(hc.datEnteredDate, '') <> '' 
					and isnull(hc.datNotificationDate, '') <> '' 
					and cast(dbo.fnDateCutTime(hc.datEnteredDate) - dbo.fnDateCutTime(hc.datNotificationDate) as float) < 1
				then @Ind_N1_TimelinessOfDataEntryDTEN
			when isnull(hc.datEnteredDate, '') <> '' 
					and isnull(hc.datNotificationDate, '') <> '' 
					and cast(dbo.fnDateCutTime(hc.datEnteredDate) - dbo.fnDateCutTime(hc.datNotificationDate) as float) between 1 and 2
				then @Ind_N2_TimelinessOfDataEntryDTEN
			when isnull(hc.datEnteredDate, '') <> ''
					and isnull(hc.datNotificationDate, '') <> ''
					and cast(dbo.fnDateCutTime(hc.datEnteredDate) - dbo.fnDateCutTime(hc.datNotificationDate) as float) > 2
				then @Ind_N3_TimelinessOfDataEntryDTEN
			else 0.00
		end	as IndDateAndTimeOfTheEmergencyNotification 
		
 		,/*18(11)*/ 
		case 
			when isnull(hc.datInvestigationStartDate, '') <> '' 
			and isnull(hc.datNotificationDate, '') <> '' 
			and cast(dbo.fnDateCutTime(hc.datNotificationDate) - dbo.fnDateCutTime(hc.datInvestigationStartDate) as float) < 1
			then @Ind_N1_DIStartingDTOfInvestigation
 			
			when isnull(hc.datInvestigationStartDate, '') <> '' 
			and isnull(hc.datNotificationDate, '') <> '' 
			and cast(dbo.fnDateCutTime(hc.datNotificationDate) - dbo.fnDateCutTime(hc.datInvestigationStartDate) as float) between 1 and 2
			then @Ind_N2_DIStartingDTOfInvestigation
 			
			when isnull(hc.datInvestigationStartDate, '') <> ''
					and isnull(hc.datNotificationDate, '') <> ''
					and cast(dbo.fnDateCutTime(hc.datNotificationDate) - dbo.fnDateCutTime(hc.datInvestigationStartDate) as float) > 2
			then @Ind_N3_DIStartingDTOfInvestigation
 			
			else 0.00
		end	as IndInvestigationStartDate 
 		
 		,/*19(12)*/ 
 			case	when isnull(h.idfsOccupationType, '') <> '' 
 				then @Ind_N1_DIOccupation 
 				else 0.00 
 			end																					as IndOccupationType --20(13)
 			
 		, case	when isnull(hc.idfsInitialCaseStatus, '') = 380000000 /*Suspect*/
 				OR isnull(hc.idfsInitialCaseStatus, '') = 360000000 /*Probable Case*/ 
 				then @Ind_N1_CIInitCaseClassification 
 				else 0.00 
 				end																				as IndInitialCaseClassification --21(14)
 		  
 		, case 
 			when isnull(tgl.idfsRegion, 0) <> 0 
 				and isnull(tgl.idfsRayon, 0) <> 0 
 				and isnull(tgl.idfsSettlement, 0) <> 0
				then @Ind_N1_CILocationOfExposure 
				else 0.00 
	 		  end																				as IndLocationOfExplosure --22(15)
 		  
 		, case	when isnull(hc.idfsYNAntimicrobialTherapy, '') <> '' 
 				then @Ind_N1_CIAntibioticTherapyAdministratedBSC 
 				else 0.00 
 				end																				as IndAATherapyAdmBeforeSamplesCollection --23(16)
 					
 					
 					
 		, case	when (dt.blnLaboratoryConfirmation = 1 and  
 					hc.idfsYNSpecimenCollected = 10100001 /*Yes*/) or
 					dt.blnLaboratoryConfirmation = 0
 				then  @Ind_N1_SamplesCollection  
 				else 0.00 end																	as IndSamplesCollected -- 24(17)
 		
 		
 		
 		, case	when CCP.CountCCP > 0
 				then @Ind_N1_ContactLisAddContact
 				else 0.00 end 																	as IndAddcontact -- 25(18)
 				 		
 		, case	when 
 					dt.intQuantityOfMandatoryFieldCSForDC = 0 
 					or
 					(dt.intQuantityOfMandatoryFieldCSForDC = 1 and
 					CS.blnUNI = 1 and
 					CS.countCS >= 1
 					)
 					or
 					(dt.intQuantityOfMandatoryFieldCSForDC > 0 
 					and CS.blnUNI = 0
 					and CS.countCS >= dt.intQuantityOfMandatoryFieldCSForDC) 
 				then @Ind_N1_CaseClassificationCS
 				else 0.00
 				end																				as IndClinicalSigns -- 26(19)
 		
 		, case	when (dt.intEPILincsAndFactors > 0
 				and EPI.countEPI > 0.8 * dt.intEPILincsAndFactors) or
 				dt.intEPILincsAndFactors = 0
 				then @Ind_N1_EpiLinksRiskFactorsByEpidCard
 				
 				when dt.intEPILincsAndFactors > 0
 				and EPI.countEPI > 0.5 * dt.intEPILincsAndFactors
 				and EPI.countEPI <= 0.8 * dt.intEPILincsAndFactors
 				then @Ind_N2_EpiLinksRiskFactorsByEpidCard
 				
 				when dt.intEPILincsAndFactors > 0
 				and EPI.countEPI <= 0.5 * dt.intEPILincsAndFactors
 				then @Ind_N3_EpiLinksRiskFactorsByEpidCard
 				else 0.00
 				end																				as IndEpidemiologicalLinksAndRiskFactors --27(20)
 		
 		
 		, case when isnull(hc.blnClinicalDiagBasis, '') = 1 
 				OR isnull(hc.blnLabDiagBasis, '') = 1 
 				OR isnull(hc.blnEpiDiagBasis, '') = 1 
 				then @Ind_N1_FCCOBasisOfDiagnosis 
 				else 0.00 
 				end																				as IndBasisOfDiagnosis --30(23)
 		
 		, case when isnull(hc.idfsOutcome, '') <> '' 
 				then @Ind_N1_FCCOOutcome 
 				else 0.00 
 				end																				as IndOutcome --31(24)
 		
 		, case when isnull(hc.idfsYNRelatedToOutbreak, '') = 10100001 /*Yes*/
 			OR isnull(hc.idfsYNRelatedToOutbreak, '') = 10100002 /*No*/
 				then @Ind_N1_FCCOIsThisCaseRelatedToOutbreak
 				 else 0.00 
 				end																				as IndISThisCaseRelatedToOutbreak	 --32(25)
 		, case	when isnull(hc.idfInvestigatedByPerson, '') <> '' 
 				then @Ind_N1_FCCOEpidemiologistName 
 				else 00.00 
 				end																				as IndEpidemiologistName --33(26)
 		
 		, case	when (dt.blnLaboratoryConfirmation = 1
 				and hc.idfsYNTestsConducted	= 10100001 /*Yes*/) or 
 				dt.blnLaboratoryConfirmation = 0
 				then @Ind_N1_ResultsOfLabTestsTestsConducted
 				else 0.00
 				end																				as IndResultsTestsConducted --35(27)
 		, case	when (dt.blnLaboratoryConfirmation = 1
 				and CTR.CountCTR > 0) or 
 				dt.blnLaboratoryConfirmation = 0
 				then @Ind_N1_ResultsOfLabTestsResultObservation 
 				else 0.00
 				end																				as IndResultsResultObservation --36(28)
 		
  	from (select * from #ReportDataTable as rt
  	      where (rt.IdRegion = @RegionID or @RegionID is null) and
  				(rt.IdRayon = @RayonID or @RayonID is null)
  	)fdt 
	
 	left join tlbHumanCase hc 

		join tstSite ts
 		on ts.idfsSite = hc.idfsSite 		
 			     
 		join tlbHuman h 
 		on	hc.idfHuman = h.idfHuman 
 			and h.intRowStatus = 0
 			
 		join tlbGeoLocation gl 
 		on	h.idfCurrentResidenceAddress = gl.idfGeoLocation 
 			and gl.intRowStatus = 0    
 			
 		left join tlbGeoLocation tgl 
 		on	tgl.idfGeoLocation = hc.idfPointGeoLocation
 		and tgl.intRowStatus = 0
 			
 	on	
 		hc.intRowStatus = 0 
 		and hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/  
 		and (@SDDate <= hc.datFinalCaseClassificationDate and hc.datFinalCaseClassificationDate < @EDDate)
 		and
 		(
 			(isnull(ts.intFlags, 0) = 0 and
 				 fdt.IdRegion = gl.idfsRegion and
				 fdt.IdRayon = gl.idfsRayon
 			) or
			(ts.intFlags = 1 and
				fdt.IdRegion = @TransportCHE and
				fdt.IdRayon = hc.idfsSite         
			)
        ) and 
        fdt.IdDiagnosis =
 						case 
 							when cast(@Diagnosis as nvarchar(max)) <> '<ItemList/>' then isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)	
 							else fdt.IdDiagnosis
 						end
 						
	left join @DiagnosisTable dt
  	on dt.[key] = isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)	
  	 						
 	left join @CS as CS
 	on CS.idfHumanCase = hc.idfHumanCase
 	
 	left join @EPI as EPI
 	on EPI.idfHumanCase = hc.idfHumanCase
 	
  	left join #CCP as CCP
 	on CCP.idfHumanCase = hc.idfHumanCase
 	
 	left join #CTR as CTR
 	on CTR.idfHumanCase = hc.idfHumanCase
	
 	


	insert into #ReportCaseTable_CountForDiagnosis 
 	select
 		count(*) as CountCase
 		,IdRegion
 		, IdRayon
 		, idfsShowDiagnosis
 	from #ReportCaseTable rct
 		left join @DiagnosisTable dt
 		on dt.[key] = rct.idfsShowDiagnosisFromCase
 	where cast(@Diagnosis as nvarchar(max)) <> '<ItemList/>'
 	and rct.idfCase is not null
 	group by IdRegion, strRegion, intRegionOrder, IdRayon, strRayon, intRayonOrder, idfsShowDiagnosis, Diagnosis, blnLaboratoryConfirmation,  intQuantityOfMandatoryFieldCSForDC
	union all
 	select
 		0 as CountCase
 		,IdRegion
 		, IdRayon
 		, idfsShowDiagnosis
 	from #ReportCaseTable rct
 		left join @DiagnosisTable dt
 		on dt.[key] = rct.idfsShowDiagnosisFromCase
 	where cast(@Diagnosis as nvarchar(max)) <> '<ItemList/>'
 	and rct.idfCase is null
 	group by IdRegion, strRegion, intRegionOrder, IdRayon, strRayon, intRayonOrder, idfsShowDiagnosis, Diagnosis, blnLaboratoryConfirmation,  intQuantityOfMandatoryFieldCSForDC


 ;
 with 
 ReportSumCaseTable 
 as
 (
 	select
 		rct.IdRegion
 		, rct.strRegion																											
 		, rct.IdRayon
 		, rct.strRayon		
 		, rct.strAZRayon																										
 		, rct.idfsShowDiagnosis
 		, rct.Diagnosis																											
  		, rct.intRegionOrder
 		, rct.intRayonOrder
 		, rct_count.CountCase as intCaseCount	
 		,/*7(1)*/ 
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndCaseStatus)/rct_count.CountCase								
 				end													as IndCaseStatus							
 		,/*8(2)*/ 
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndDateOfCompletionPaperFormDate)/rct_count.CountCase			
 				end													as IndDateOfCompletionPaperFormDate				
 		,/*9(3)*/
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndNameOfEmployer)/rct_count.CountCase							
 				end													as IndNameOfEmployer							
 		,/*11(5)*/
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndCurrentLocation)/rct_count.CountCase						
 				end													as IndCurrentLocation							
 		,/*12(6)*/
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndNotificationDate)/rct_count.CountCase							
 				end													as IndNotificationDate							
 		,/*13(7)*/
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndNotificationSentByName)/rct_count.CountCase					
 				end													as IndNotificationSentByName					
 		,/*14(8)*/
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndNotificationReceivedByFacility)/rct_count.CountCase			
 				end													as IndNotificationReceivedByFacility			
 		,/*15(9)*/
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndNotificationReceivedByName)/rct_count.CountCase				
 				end													as IndNotificationReceivedByName				
 		,/*16(10)*/
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndDateAndTimeOfTheEmergencyNotification)/rct_count.CountCase	
 				end													as IndDateAndTimeOfTheEmergencyNotification		
  		,/*18(11)*/
  		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndInvestigationStartDate)/rct_count.CountCase					
 				end													as IndInvestigationStartDate					
 		,/*19(12)*/
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndOccupationType)/rct_count.CountCase							
 				end													as IndOccupationType							
 		,/*20(13)*/
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndInitialCaseClassification)/rct_count.CountCase				
 				end													as IndInitialCaseClassification					
 		,/*21(14)*/
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndLocationOfExplosure)/rct_count.CountCase						
 				end													as IndLocationOfExplosure						
 		,/*22(15)*/
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndAATherapyAdmBeforeSamplesCollection)/rct_count.CountCase		
 				end													as IndAATherapyAdmBeforeSamplesCollection		
 		,/*23(16)*/
 		case	when rct_count.CountCase > 0
 				then sum(IndSamplesCollected)/rct_count.CountCase
 				else 0.00 
 				end													as IndSamplesCollected							
 		,/*24(17)*/
 		case	when rct_count.CountCase > 0
 				then sum(IndAddcontact)/rct_count.CountCase								
 				else 0.00 
 				end													as IndAddcontact								
 		,/*25(18)*/
 		case	when rct_count.CountCase > 0 
 				then sum(IndClinicalSigns)/rct_count.CountCase	
 				else 0.00 end										as IndClinicalSigns								
 		,/*26(19)*/
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndEpidemiologicalLinksAndRiskFactors)/rct_count.CountCase		
 				end													as IndEpidemiologicalLinksAndRiskFactors		
 		,/*27(20)*/
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndBasisOfDiagnosis)/rct_count.CountCase							
 				end													as IndBasisOfDiagnosis							
 		,/*28(21)*/
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndOutcome)/rct_count.CountCase									
 				end													as IndOutcome									
 		,/*29(22)*/
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndISThisCaseRelatedToOutbreak)/rct_count.CountCase				
 				end													as IndISThisCaseRelatedToOutbreak				
 		,/*30(23)*/
 		case	when rct_count.CountCase = 0 
 				then 0.00
 				else sum(IndEpidemiologistName)/rct_count.CountCase						
 				end													as IndEpidemiologistName						
 		,/*32(24)*/
 		case	when rct_count.CountCase > 0
 				then sum(IndResultsTestsConducted)/rct_count.CountCase	
 				else 0.00
 				end													as IndResultsTestsConducted						
 		,/*33(25)*/
 		case	when rct_count.CountCase > 0
 				then sum(IndResultsResultObservation)/rct_count.CountCase					
 				else 0.00 
 				end													as IndResultsResultObservation					
 	from #ReportCaseTable rct
 		inner join #ReportCaseTable_CountForDiagnosis rct_count
 		on rct.IdRegion = rct_count.IdRegion
 		and rct.IdRayon = rct_count.IdRayon
 		and rct.idfsShowDiagnosis = rct_count.idfsShowDiagnosis
 		left join @DiagnosisTable dt
 		on dt.[key] = rct.idfsShowDiagnosisFromCase
 	where cast(@Diagnosis as nvarchar(max)) <> '<ItemList/>'
 	group by rct.IdRegion, rct.strRegion, rct.intRegionOrder, rct.IdRayon, rct.strRayon, rct.strAZRayon, rct.intRayonOrder, 
 	rct.idfsShowDiagnosis, rct.Diagnosis, dt.blnLaboratoryConfirmation, dt.intQuantityOfMandatoryFieldCSForDC, rct_count.CountCase
 )
 , ReportSumCaseTableForRayons
 as
 (
 	select
 		IdRegion
 		, strRegion																											
 		, IdRayon
 		, strRayon		
 		, strAZRayon																									
 		, idfsShowDiagnosis
 		, Diagnosis																											
  		, intRegionOrder
 		, intRayonOrder
 		,/*7(1)*/	sum(IndCaseStatus)										as IndCaseStatus							
 		,/*8(2)*/	sum(IndDateOfCompletionPaperFormDate)					as IndDateOfCompletionPaperFormDate				
 		,/*9(3)*/	sum(IndNameOfEmployer)									as IndNameOfEmployer							
 		,/*11(5)*/	sum(IndCurrentLocation)									as IndCurrentLocation						
 		,/*12(6)*/	sum(IndNotificationDate)								as IndNotificationDate							
 		,/*13(7)*/	sum(IndNotificationSentByName)							as IndNotificationSentByName					
 		,/*14(8)*/	sum(IndNotificationReceivedByFacility)					as IndNotificationReceivedByFacility			
 		,/*15(9)*/	sum(IndNotificationReceivedByName)						as IndNotificationReceivedByName				
 		,/*16(10)*/	sum(IndDateAndTimeOfTheEmergencyNotification)			as IndDateAndTimeOfTheEmergencyNotification		
 
 		,/*18(11)*/ sum(IndInvestigationStartDate)							as IndInvestigationStartDate					
 		,/*19(12)*/ sum(IndOccupationType)									as IndOccupationType							
 		,/*20(13)*/ sum(IndInitialCaseClassification)						as IndInitialCaseClassification					
 		,/*21(14)*/ sum(IndLocationOfExplosure)								as IndLocationOfExplosure						
 		,/*22(15)*/ sum(IndAATherapyAdmBeforeSamplesCollection)				as IndAATherapyAdmBeforeSamplesCollection		
 		
 		,/*23(16)*/
 		case	when dt.blnLaboratoryConfirmation = 1 
 				then sum(IndSamplesCollected)
 				else 0.00 
 				end															as IndSamplesCollected							
 		, case	when dt.blnLaboratoryConfirmation = 1 
 				then count(idfCase)
 				else 0.00 
 				end															as CountIndSamplesCollected							
 		,/*24(17)*/ sum(IndAddcontact)										as IndAddcontact								
 		,/*25(18)*/
 		case	when dt.intQuantityOfMandatoryFieldCSForDC > 0 
 				then sum(IndClinicalSigns)
 				else 0.00 end												as IndClinicalSigns								
 		, case	when dt.intQuantityOfMandatoryFieldCSForDC > 0 
 				then count(idfCase)
 				else 0.00 end												as CountIndClinicalSigns								
 		,/*26(19)*/ sum(IndEpidemiologicalLinksAndRiskFactors)				as IndEpidemiologicalLinksAndRiskFactors		
		
 		,/*27(20)*/ sum(IndBasisOfDiagnosis)								as IndBasisOfDiagnosis							
 		,/*28(21)*/ sum(IndOutcome)											as IndOutcome									
 		,/*29(22)*/ sum(IndISThisCaseRelatedToOutbreak)						as IndISThisCaseRelatedToOutbreak				
 		,/*30(23)*/ sum(IndEpidemiologistName)								as IndEpidemiologistName						
 		,/*32(24)*/
 		case	when dt.blnLaboratoryConfirmation = 1 
 				then sum(IndResultsTestsConducted)	
 				else 0.00
 				end															as IndResultsTestsConducted						
 		, case	when dt.blnLaboratoryConfirmation = 1 
 				then count(idfCase)	
 				else 0.00
 				end															as CountIndResultsTestsConducted	 				
 		,/*33(25)*/
 		case	when dt.blnLaboratoryConfirmation = 1 
 				then sum(IndResultsResultObservation)					
 				else 0.00 
 				end															as IndResultsResultObservation					
 		, case	when dt.blnLaboratoryConfirmation = 1 
 				then count(idfCase)					
 				else 0.00 
 				end															as CountIndResultsResultObservation
 		, count(idfCase)													as CountRecForDiag	
 	from #ReportCaseTable rct
 		left join @DiagnosisTable dt
 		on dt.[key] = rct.idfsShowDiagnosisFromCase
	where cast(@Diagnosis as nvarchar(max)) = '<ItemList/>' 		
 	group by IdRegion, strRegion, intRegionOrder, IdRayon, strRayon, strAZRayon, intRayonOrder, idfsShowDiagnosis, Diagnosis, blnLaboratoryConfirmation, intQuantityOfMandatoryFieldCSForDC
 )
 , ReportSumCaseTableForRayons_Summary
 as
 (
 	select
 		IdRegion
 		, strRegion																										
 		, IdRayon
 		, strRayon		
 		, strAZRayon																								
 		, '' as idfsShowDiagnosis
 		, '' as Diagnosis																											
  		, intRegionOrder
 		, intRayonOrder
		, sum(CountRecForDiag) as intCaseCount -- update 29.11.14
		
 		,/*7(1)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndCaseStatus)/sum(CountRecForDiag)										
 				end																		as IndCaseStatus								
 		,/*8(2)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndDateOfCompletionPaperFormDate)/sum(CountRecForDiag)					
 				end																		as IndDateOfCompletionPaperFormDate				
 		,/*9(3)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndNameOfEmployer)/sum(CountRecForDiag)									
 				end																		as IndNameOfEmployer							
 		,/*11(5)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndCurrentLocation)/sum(CountRecForDiag)									
 				end																		as IndCurrentLocation							
 		,/*12(6)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndNotificationDate)/sum(CountRecForDiag)									
 				end																		as IndNotificationDate							
 		,/*13(7)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndNotificationSentByName)/sum(CountRecForDiag)							
 				end																		as IndNotificationSentByName				
 		,/*14(8)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndNotificationReceivedByFacility)/sum(CountRecForDiag)					
 				end																		as IndNotificationReceivedByFacility			
 		,/*15(9)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndNotificationReceivedByName)/sum(CountRecForDiag)						
 				end																		as IndNotificationReceivedByName				
 		,/*16(10)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndDateAndTimeOfTheEmergencyNotification)/sum(CountRecForDiag)			
 				end																		as IndDateAndTimeOfTheEmergencyNotification		
 				
 		,/*18(11)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndInvestigationStartDate)/sum(CountRecForDiag)							
 				end																		as IndInvestigationStartDate					
 		,/*19(12)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndOccupationType)/sum(CountRecForDiag)									
 				end																		as IndOccupationType							
 		,/*20(13)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndInitialCaseClassification)/sum(CountRecForDiag)						
 				end																		as IndInitialCaseClassification					
 		,/*21(14)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndLocationOfExplosure)/sum(CountRecForDiag)								
 				end																		as IndLocationOfExplosure						
 		,/*22(15)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndAATherapyAdmBeforeSamplesCollection)/sum(CountRecForDiag)				
 				end																		as IndAATherapyAdmBeforeSamplesCollection		
 		
 		,/*23(16)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 then 0.00
 				when sum(CountIndSamplesCollected) = 0 then 0.00
 				else sum(IndSamplesCollected)/sum(CountIndSamplesCollected) 						
 				end																		as IndSamplesCollected							
 		,/*24(17)*/
 		 case	when sum(CountRecForDiag) = 0 then 0.00
 				else sum(IndAddcontact)/sum(CountRecForDiag)									
 				end																		as IndAddcontact								
 		,/*25(18)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 then 0.00
 				when sum(CountIndClinicalSigns) = 0 then 0.00
 				else sum(IndClinicalSigns)/sum(CountIndClinicalSigns)								
 				end																		as IndClinicalSigns								
 		,/*26(19)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndEpidemiologicalLinksAndRiskFactors)/sum(CountRecForDiag)				
 				end																		as IndEpidemiologicalLinksAndRiskFactors		

 		,/*27(20)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndBasisOfDiagnosis)/sum(CountRecForDiag)									
 				end																		as IndBasisOfDiagnosis							
 		,/*28(21)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndOutcome)/sum(CountRecForDiag)											
 				end																		as IndOutcome									
 		,/*29(22)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndISThisCaseRelatedToOutbreak)/sum(CountRecForDiag)						
 				end																		as IndISThisCaseRelatedToOutbreak				
 		,/*30(23)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 
 				then 0.00
 				else sum(IndEpidemiologistName)/sum(CountRecForDiag)								
 				end																		as IndEpidemiologistName	
 									
 		,/*32(24)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 then 0.00
 				when sum(CountIndResultsTestsConducted) = 0 then 0.00
 				else sum(IndResultsTestsConducted)/sum(CountIndResultsTestsConducted)				
 				end																		as IndResultsTestsConducted						
 		,/*33(25)*/
 		 case	when sum(isnull(CountRecForDiag,0)) = 0 then 0.00
 				when sum(CountIndResultsResultObservation) = 0 then 0.00
 				else sum(IndResultsResultObservation)/sum(CountIndResultsResultObservation)		
 				end																		as IndResultsResultObservation					
 				
 													
 	from ReportSumCaseTableForRayons rct
 	where cast(@Diagnosis as nvarchar(max)) = '<ItemList/>' 
 	group by IdRegion, strRegion, intRegionOrder, IdRayon, strRayon, strAZRayon, intRayonOrder--, CountRecForDiag -- update 29.11.14
 ) 
 

	insert into @ReportTable
	 (
 		idfsRegion
 		, strRegion	
 		, intRegionOrder								
 		, idfsRayon
 		, strRayon
 		, strAZRayon
 		, intRayonOrder
 		, intCaseCount
 		, idfsDiagnosis
 		, strDiagnosis
 		, dbl_1_Notification
 		, dblCaseStatus
 		, dblDateOfCompletionOfPaperForm
 		, dblNameOfEmployer
 		, dblCurrentLocationOfPatient
 		, dblNotificationDateTime
 		, dbldblNotificationSentByName
 		, dblNotificationReceivedByFacility
 		, dblNotificationReceivedByName
 		, dblTimelinessofDataEntry
 		, dbl_2_CaseInvestigation
 		, dblDemographicInformationStartingDateTimeOfInvestigation
 		, dblDemographicInformationOccupation
 		, dblClinicalInformationInitialCaseClassification
 		, dblClinicalInformationLocationOfExposure
 		, dblClinicalInformationAntibioticAntiviralTherapy
 		, dblSamplesCollectionSamplesCollected
 		, dblContactListAddContact
 		, dblCaseClassificationClinicalSigns
 		, dblEpidemiologicalLinksAndRiskFactors
 		, dblFinalCaseClassificationBasisOfDiagnosis
 		, dblFinalCaseClassificationOutcome
 		, dblFinalCaseClassificationIsThisCaseOutbreak
 		, dblFinalCaseClassificationEpidemiologistName
 		, dbl_3_TheResultsOfLaboratoryTests
 		, dblTheResultsOfLaboratoryTestsTestsConducted
 		, dblTheResultsOfLaboratoryTestsResultObservation
 		, dblSummaryScoreByIndicators
	 )
	 
	select
 			  IdRegion
			, strRegion	
	 		, intRegionOrder
 			, IdRayon
			, strRayon
			, strAZRayon
 			, intRayonOrder
 			, intCaseCount
			, idfsShowDiagnosis
		 	, Diagnosis
 	
		 	,/*6(1+2+3+5+6+8+9+10)*/
		 				  /*7(1)*/IndCaseStatus
 						+ /*8(2)*/IndDateOfCompletionPaperFormDate
 						+ /*9(3)*/IndNameOfEmployer
 						+ /*11(5)*/IndCurrentLocation
 						+ /*12(6)*/IndNotificationDate
 						+ /*13(7)*/IndNotificationSentByName
 						+ /*14(8)*/IndNotificationReceivedByFacility
 						+ /*15(9)*/IndNotificationReceivedByName
 						+ /*16(10)*/IndDateAndTimeOfTheEmergencyNotification
 																	as IndNotification
	
			, /*7(1)*/IndCaseStatus									as IndCaseStatus
			, /*8(2)*/IndDateOfCompletionPaperFormDate				as IndDateOfCompletionPaperFormDate
 			, /*9(3)*/IndNameOfEmployer								as IndNameOfEmployer
 			, /*11(5)*/IndCurrentLocation							as IndCurrentLocation
 			, /*12(6)*/IndNotificationDate							as IndNotificationDate
 			, /*13(7)*/IndNotificationSentByName					as IndNotificationSentByName
 			, /*14(8)*/IndNotificationReceivedByFacility			as IndNotificationReceivedByFacility
 			, /*15(9)*/IndNotificationReceivedByName				as IndNotificationReceivedByName
 			, /*16(10)*/IndDateAndTimeOfTheEmergencyNotification	as IndDateAndTimeOfTheEmergencyNotification
	 	
 	
		 	,/*17(11..23)*/ 
		 				  /*18(11)*/IndInvestigationStartDate
 						+ /*19(12)*/IndOccupationType
 						+ /*20(13)*/IndInitialCaseClassification
 						+ /*21(14)*/IndLocationOfExplosure
 						+ /*22(15)*/IndAATherapyAdmBeforeSamplesCollection
 						+ /*23(16)*/IndSamplesCollected
 						+ /*24(17)*/IndAddcontact 
 						+ /*25(18)*/IndClinicalSigns 
 						+ /*26(19)*/IndEpidemiologicalLinksAndRiskFactors
 						+ /*27(20)*/IndBasisOfDiagnosis
 						+ /*28(21)*/IndOutcome 
 						+ /*29(22)*/IndISThisCaseRelatedToOutbreak
 						+ /*30(23)*/IndEpidemiologistName
 																	as IndCaseInvestigation
 																	
			, /*18(11)*/IndInvestigationStartDate					as IndInvestigationStartDate
			, /*19(12)*/IndOccupationType							as IndOccupationType
			, /*20(13)*/IndInitialCaseClassification				as IndInitialCaseClassification
			, /*21(14)*/IndLocationOfExplosure						as IndLocationOfExplosure
			, /*22(15)*/IndAATherapyAdmBeforeSamplesCollection		as IndAATherapyAdmBeforeSamplesCollection
			, /*23(16)*/IndSamplesCollected							as IndSamplesCollected
			, /*24(17)*/IndAddcontact								as IndAddcontact
			, /*25(18)*/IndClinicalSigns							as IndClinicalSigns
			, /*26(19)*/IndEpidemiologicalLinksAndRiskFactors		as IndEpidemiologicalLinksAndRiskFactors
			, /*27(20)*/IndBasisOfDiagnosis							as IndBasisOfDiagnosis
			, /*28(21)*/IndOutcome									as IndOutcome
			, /*29(22)*/IndISThisCaseRelatedToOutbreak				as IndISThisCaseRelatedToOutbreak
			, /*30(23)*/IndEpidemiologistName						as IndEpidemiologistName
	

			,/*31(24+25)*/
						  /*32(24)*/IndResultsTestsConducted
						+ /*33(25)*/IndResultsResultObservation							
																	as IndResults
			, /*32(24)*/IndResultsTestsConducted					as IndResultsTestsConducted
			, /*33(25)*/IndResultsResultObservation					as IndResultsResultObservation
	 	
		 	,/*34*/ 
 				  /*7(1)*/IndCaseStatus
				+ /*8(2)*/IndDateOfCompletionPaperFormDate
				+ /*9(3)*/IndNameOfEmployer
				+ /*11(5)*/IndCurrentLocation
				+ /*12(6)*/IndNotificationDate
				+ /*13(7)*/IndNotificationSentByName
				+ /*14(8)*/IndNotificationReceivedByFacility
				+ /*15(9)*/IndNotificationReceivedByName
				+ /*16(10)*/IndDateAndTimeOfTheEmergencyNotification 				

				+ /*18(11)*/IndInvestigationStartDate
				+ /*19(12)*/IndOccupationType
				+ /*20(13)*/IndInitialCaseClassification
				+ /*21(14)*/IndLocationOfExplosure
				+ /*22(15)*/IndAATherapyAdmBeforeSamplesCollection
				+ /*23(16)*/IndSamplesCollected
				+ /*24(17)*/IndAddcontact 
				+ /*25(18)*/IndClinicalSigns 
				+ /*26(19)*/IndEpidemiologicalLinksAndRiskFactors
				+ /*27(20)*/IndBasisOfDiagnosis
				+ /*28(21)*/IndOutcome 
				+ /*29(22)*/IndISThisCaseRelatedToOutbreak
				+ /*30(23)*/IndEpidemiologistName 				
 								
 				+ /*32(24)*/IndResultsTestsConducted
				+ /*33(25)*/IndResultsResultObservation					
 																as SummaryScoreByIndicators
	from ReportSumCaseTable
	where cast(@Diagnosis as nvarchar(max)) <> '<ItemList/>'

	union all
	 
	select
 		      IdRegion
			, strRegion	
	 		, intRegionOrder
 			, IdRayon
	 		, strRayon
			, strAZRayon
 			, intRayonOrder
 			, intCaseCount
			, idfsShowDiagnosis
			, Diagnosis

		 	,/*6(1+2+3+5+6+8+9+10)*/
		 				  /*7(1)*/IndCaseStatus
 						+ /*8(2)*/IndDateOfCompletionPaperFormDate
 						+ /*9(3)*/IndNameOfEmployer
 						+ /*11(5)*/IndCurrentLocation
 						+ /*12(6)*/IndNotificationDate
 						+ /*13(7)*/IndNotificationSentByName
 						+ /*14(8)*/IndNotificationReceivedByFacility
 						+ /*15(9)*/IndNotificationReceivedByName
 						+ /*16(10)*/IndDateAndTimeOfTheEmergencyNotification 						
 																as IndNotification

			, /*7(1)*/IndCaseStatus									as IndCaseStatus
			, /*8(2)*/IndDateOfCompletionPaperFormDate				as IndDateOfCompletionPaperFormDate
 			, /*9(3)*/IndNameOfEmployer								as IndNameOfEmployer
 			, /*11(5)*/IndCurrentLocation							as IndCurrentLocation
 			, /*12(6)*/IndNotificationDate							as IndNotificationDate
 			, /*13(7)*/IndNotificationSentByName					as IndNotificationSentByName
 			, /*14(8)*/IndNotificationReceivedByFacility			as IndNotificationReceivedByFacility
 			, /*15(9)*/IndNotificationReceivedByName				as IndNotificationReceivedByName
 			, /*16(10)*/IndDateAndTimeOfTheEmergencyNotification	as IndDateAndTimeOfTheEmergencyNotification	
	
		 	,/*17(11..23)*/ 
		 				  /*18(11)*/IndInvestigationStartDate
 						+ /*19(12)*/IndOccupationType
 						+ /*20(13)*/IndInitialCaseClassification
 						+ /*21(14)*/IndLocationOfExplosure
 						+ /*22(15)*/IndAATherapyAdmBeforeSamplesCollection
 						+ /*23(16)*/IndSamplesCollected
 						+ /*24(17)*/IndAddcontact 
 						+ /*25(18)*/IndClinicalSigns 
 						+ /*26(19)*/IndEpidemiologicalLinksAndRiskFactors
 						+ /*27(20)*/IndBasisOfDiagnosis
 						+ /*28(21)*/IndOutcome 
 						+ /*29(22)*/IndISThisCaseRelatedToOutbreak
 						+ /*30(23)*/IndEpidemiologistName	
		 															as IndCaseInvestigation

			, /*18(11)*/IndInvestigationStartDate					as IndInvestigationStartDate
			, /*19(12)*/IndOccupationType							as IndOccupationType
			, /*20(13)*/IndInitialCaseClassification				as IndInitialCaseClassification
			, /*21(14)*/IndLocationOfExplosure						as IndLocationOfExplosure
			, /*22(15)*/IndAATherapyAdmBeforeSamplesCollection		as IndAATherapyAdmBeforeSamplesCollection
			, /*23(16)*/IndSamplesCollected							as IndSamplesCollected
			, /*24(17)*/IndAddcontact								as IndAddcontact
			, /*25(18)*/IndClinicalSigns							as IndClinicalSigns
			, /*26(19)*/IndEpidemiologicalLinksAndRiskFactors		as IndEpidemiologicalLinksAndRiskFactors
			, /*27(20)*/IndBasisOfDiagnosis							as IndBasisOfDiagnosis
			, /*28(21)*/IndOutcome									as IndOutcome
			, /*29(22)*/IndISThisCaseRelatedToOutbreak				as IndISThisCaseRelatedToOutbreak
			, /*30(23)*/IndEpidemiologistName						as IndEpidemiologistName	
	
			,/*31(24+25)*/
						  /*32(24)*/IndResultsTestsConducted
						+ /*33(25)*/IndResultsResultObservation							
																	as IndResults
			, /*32(24)*/IndResultsTestsConducted					as IndResultsTestsConducted
			, /*33(25)*/IndResultsResultObservation					as IndResultsResultObservation	
	
		 	,/*34*/ 
 				  /*7(1)*/IndCaseStatus
				+ /*8(2)*/IndDateOfCompletionPaperFormDate
				+ /*9(3)*/IndNameOfEmployer
				+ /*11(5)*/IndCurrentLocation
				+ /*12(6)*/IndNotificationDate
				+ /*13(7)*/IndNotificationSentByName
				+ /*14(8)*/IndNotificationReceivedByFacility
				+ /*15(9)*/IndNotificationReceivedByName
				+ /*16(10)*/IndDateAndTimeOfTheEmergencyNotification 				

				+ /*18(11)*/IndInvestigationStartDate
				+ /*19(12)*/IndOccupationType
				+ /*20(13)*/IndInitialCaseClassification
				+ /*21(14)*/IndLocationOfExplosure
				+ /*22(15)*/IndAATherapyAdmBeforeSamplesCollection
				+ /*23(16)*/IndSamplesCollected
				+ /*24(17)*/IndAddcontact 
				+ /*25(18)*/IndClinicalSigns 
				+ /*26(19)*/IndEpidemiologicalLinksAndRiskFactors
				+ /*27(20)*/IndBasisOfDiagnosis
				+ /*28(21)*/IndOutcome 
				+ /*29(22)*/IndISThisCaseRelatedToOutbreak
				+ /*30(23)*/IndEpidemiologistName 				
 								
 				+ /*32(24)*/IndResultsTestsConducted
				+ /*33(25)*/IndResultsResultObservation
				 				
 																as SummaryScoreByIndicators
	 from ReportSumCaseTableForRayons_Summary
	 where cast(@Diagnosis as nvarchar(max)) = '<ItemList/>'
	
	
	
	
select 	
		-1 as	idfsBaseReference
		,-1 as	idfsRegion
		,'' as	strRegion
		,-1 as	intRegionOrder
		,-1 as	idfsRayon
		,'' as	strRayon
		,'' as  strAZRayon
		,-1 as	intRayonOrder
		, 0 as  intCaseCount
		,-1 as	idfsDiagnosis
		,'' as	strDiagnosis	

		,@Ind_1_Notification as dbl_1_Notification
 		,@Ind_N1_CaseStatus as dblCaseStatus
 		,@Ind_N1_DateofCompletionPF as dblDateOfCompletionOfPaperForm
 		,@Ind_N1_NameofEmployer as dblNameOfEmployer
 		,@Ind_N1_CurrentLocationPatient as dblCurrentLocationOfPatient
 		,@Ind_N1_NotifDateTime as dblNotificationDateTime
 		,@Ind_N1_NotifSentByName as dbldblNotificationSentByName
 		,@Ind_N1_NotifReceivedByFacility as dblNotificationReceivedByFacility
 		,@Ind_N1_NotifReceivedByName as dblNotificationReceivedByName
 		,@Ind_N1_TimelinessOfDataEntryDTEN as dblTimelinessofDataEntry
 		
		,@Ind_2_CaseInvestigation as dbl_2_CaseInvestigation
 		,@Ind_N1_DIStartingDTOfInvestigation as dblDemographicInformationStartingDateTimeOfInvestigation
  		,@Ind_N1_DIOccupation as dblDemographicInformationOccupation
 		,@Ind_N1_CIInitCaseClassification as dblClinicalInformationInitialCaseClassification
 		,@Ind_N1_CILocationOfExposure as dblClinicalInformationLocationOfExposure
 		,@Ind_N1_CIAntibioticTherapyAdministratedBSC as dblClinicalInformationAntibioticAntiviralTherapy
 		,@Ind_N1_SamplesCollection as dblSamplesCollectionSamplesCollected
 		,@Ind_N1_ContactLisAddContact as dblContactListAddContact
 		,@Ind_N1_CaseClassificationCS as dblCaseClassificationClinicalSigns
 		,@Ind_N1_EpiLinksRiskFactorsByEpidCard as dblEpidemiologicalLinksAndRiskFactors
 		,@Ind_N1_FCCOBasisOfDiagnosis as dblFinalCaseClassificationBasisOfDiagnosis
 		,@Ind_N1_FCCOOutcome as dblFinalCaseClassificationOutcome
 		,@Ind_N1_FCCOIsThisCaseRelatedToOutbreak as dblFinalCaseClassificationIsThisCaseOutbreak
 		,@Ind_N1_FCCOEpidemiologistName as dblFinalCaseClassificationEpidemiologistName
 		,@Ind_3_TheResultsOfLabTestsAndInterpretation as dbl_3_TheResultsOfLaboratoryTests
 		,@Ind_N1_ResultsOfLabTestsTestsConducted as dblTheResultsOfLaboratoryTestsTestsConducted
 		,@Ind_N1_ResultsOfLabTestsResultObservation as dblTheResultsOfLaboratoryTestsResultObservation
 		,@Ind_1_Notification + @Ind_2_CaseInvestigation + @Ind_3_TheResultsOfLabTestsAndInterpretation  as dblSummaryScoreByIndicators
 		
		
union all 			
select 
 				rt.idfsBaseReference
 				,rt.idfsRegion
 				,rt.strRegion
 				,rt.intRegionOrder
 				,rt.idfsRayon
 				,rt.strRayon
 				,rt.strAZRayon
 				,rt.intRayonOrder
 				,rt.intCaseCount
 				,rt.idfsDiagnosis
 				,rt.strDiagnosis
 				
				,/*6(1+2+3+5+6+8+9+10)*/	rt.dbl_1_Notification
				,/*7(1)*/					rt.dblCaseStatus
				,/*8(2)*/					rt.dblDateOfCompletionOfPaperForm
				,/*9(3)*/					rt.dblNameOfEmployer
				,/*11(5)*/					rt.dblCurrentLocationOfPatient
				,/*12(6)*/					rt.dblNotificationDateTime
				,/*13(7)*/					rt.dbldblNotificationSentByName
				,/*14(8)*/					rt.dblNotificationReceivedByFacility
				,/*15(9)*/					rt.dblNotificationReceivedByName
				,/*16(10)*/					rt.dblTimelinessofDataEntry
 	
				,/*17(11..23)*/				rt.dbl_2_CaseInvestigation
				,/*18(11)*/					rt.dblDemographicInformationStartingDateTimeOfInvestigation
				,/*19(12)*/					rt.dblDemographicInformationOccupation
				,/*20(13)*/					rt.dblClinicalInformationInitialCaseClassification
				,/*21(14)*/					rt.dblClinicalInformationLocationOfExposure
				,/*22(15)*/					rt.dblClinicalInformationAntibioticAntiviralTherapy
				,/*23(16)*/					rt.dblSamplesCollectionSamplesCollected
				,/*24(17)*/					rt.dblContactListAddContact
				,/*25(18)*/					rt.dblCaseClassificationClinicalSigns
				,/*26(19)*/					rt.dblEpidemiologicalLinksAndRiskFactors
				,/*27(20)*/					rt.dblFinalCaseClassificationBasisOfDiagnosis
				,/*28(21)*/					rt.dblFinalCaseClassificationOutcome
				,/*29(22)*/					rt.dblFinalCaseClassificationIsThisCaseOutbreak
				,/*30(23)*/					rt.dblFinalCaseClassificationEpidemiologistName
 	
				,/*31(24+25)*/				rt.dbl_3_TheResultsOfLaboratoryTests
				,/*32(24)*/					rt.dblTheResultsOfLaboratoryTestsTestsConducted
				,/*33(25)*/					rt.dblTheResultsOfLaboratoryTestsResultObservation
 	
 				,/*35*/						rt.dblSummaryScoreByIndicators
  	
from @ReportTable rt


	
order by intRegionOrder, strRegion, strRayon, idfsDiagnosis


