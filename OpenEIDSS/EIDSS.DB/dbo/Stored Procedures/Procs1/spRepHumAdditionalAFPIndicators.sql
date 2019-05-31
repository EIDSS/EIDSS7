

--##SUMMARY This procedure returns resultset for Main indicators of AFP surveillance report

--##REMARKS Author: 
--##REMARKS Create date: 

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec spRepHumAdditionalAFPIndicators 'en', '20140101', '20141231'

*/ 
 
create PROCEDURE [dbo].[spRepHumAdditionalAFPIndicators]
(
	 @LangID		As nvarchar(50),
	 @SD			as datetime, 
	 @ED			as datetime
)
AS	

	declare 
		@CountryID BIGINT,
		@idfsLanguage bigint,
		@idfsCustomReportType bigint,

		@idfsSample_FecesStool bigint,
		@idfsRegionBaku bigint,
		@idfsRegionOtherRayons bigint,
		@idfsRegionNakhichevanAR bigint,
		@FFP_Date_of_onset_of_paralysis   bigint,
		@FFP_Hastheclinicalexamination bigint,
		@FFP_DateOfFinalClassification bigint,
		@FFP_NumberOfVaccineDoses_SupplementaryImmunization   bigint,
		@FFP_NumberOfVaccineDoses_RoutineImmunization   bigint


		
	set @CountryID = 170000000	
	set @idfsLanguage = dbo.fnGetLanguageCode (@LangID)		
	set @idfsCustomReportType =  10290007
  
	--7721770000000 --Feces-Stool
	select @idfsSample_FecesStool = tbra.idfsBaseReference
	from trtBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'Sample type'
		
		inner join trtBaseReferenceAttribute tbra2
			inner join trtAttributeType tat2
			on tat2.idfAttributeType = tbra2.idfAttributeType
			and tat2.strAttributeTypeName = 'attr_part_in_report'
		on tbra.idfsBaseReference = tbra2.idfsBaseReference
		and tbra2.varValue = @idfsCustomReportType 
	where cast(tbra.varValue as nvarchar(100)) = N'Feces-Stool'
	
	--print '@idfsSample_FecesStool' + cast(@idfsSample_FecesStool as varchar(20))
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
    

    --Flexible Form Type = “Human Clinical Signs” and Tooltip = “Acute Flaccid Paralysis-Date of onset of paralysis”.
    select @FFP_Date_of_onset_of_paralysis = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Date_of_onset_of_paralysis'
	and intRowStatus = 0
    
    --Flexible Form Type = “Human Epi Investigations” and Tooltip = “Acute Flaccid Paralysis-Follow up clinical examination at 60 days-Has the clinical examination of the patient been conducted” 
 	select @FFP_Hastheclinicalexamination = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Hastheclinicalexamination'
	and intRowStatus = 0
	
	--Flexible Form Type = “Human Epi Investigations” and Tooltip = “Acute Flaccid Paralysis-AFP Final Classification-Date of final classification” 
 	select @FFP_DateOfFinalClassification = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_DateOfFinalClassification'
	and intRowStatus = 0
  
    --Flexible Form Type = “Human Epi Investigations” and 
    --Tooltip 1 = “Acute Flaccid Paralysis-Vaccination status-Number of vaccine doses received through routine immunization” and 
 	select @FFP_NumberOfVaccineDoses_RoutineImmunization = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_NumberOfVaccineDoses_RoutineImmunization'
	and intRowStatus = 0 	
	
 	--Tooltip 2 = “Acute Flaccid Paralysis-Vaccination status-Number of vaccine doses received through supplementary immunizationAcute ”
 	select @FFP_NumberOfVaccineDoses_SupplementaryImmunization = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_NumberOfVaccineDoses_SupplementaryImmunization'
	and intRowStatus = 0
 
	
  
	declare @ReportTable table
	(
		idfsRegion bigint not null,
		idfsRayon bigint not null,
		strRegion nvarchar(200) not null,
		strRayon nvarchar(200) not null,
		intTotal int,
		int7DayNotification int,
		int2DayRegistration int,
		int2FaecalSpecimen int,
		intPositiveEnterovirus int,
		intFollowUpInvestigation int,
		intFinalClassification int,
		intOPVDoses int,
		intRegionOrder int
	)
  
	insert into @ReportTable
	(
		idfsRegion,
		idfsRayon,
		strRegion,
		strRayon,
		intRegionOrder
	)
	select
		ray.idfsRegion,
		ray.idfsRayon,

		isnull(gsnt_reg.strTextString, gbr_reg.strDefault),
		isnull(gsnt_ray.strTextString, gbr_ray.strDefault),


		case ray.idfsRegion
		  when @idfsRegionBaku			--Baku
		  then 1
	      
		  when @idfsRegionOtherRayons	--Other rayons
		  then 2
	      
		  when @idfsRegionNakhichevanAR --Nakhichevan AR
		  then 3
	      
		  else 0
		end as intRegionOrder
  
	from gisRayon ray
		inner join gisRegion reg
		on ray.idfsRegion = reg.idfsRegion
		and reg.intRowStatus = 0
		and reg.idfsCountry = @CountryID

		inner join gisBaseReference gbr_reg
		on gbr_reg.idfsGISBaseReference = reg.idfsRegion
		and gbr_reg.intRowStatus = 0

		inner join dbo.gisStringNameTranslation gsnt_reg
		on gsnt_reg.idfsGISBaseReference = gbr_reg.idfsGISBaseReference
		and gsnt_reg.idfsLanguage = @idfsLanguage
		and gsnt_reg.intRowStatus = 0

		inner join gisBaseReference gbr_ray
		on gbr_ray.idfsGISBaseReference = ray.idfsRayon
		and gbr_ray.intRowStatus = 0

		inner join dbo.gisStringNameTranslation gsnt_ray
		on gsnt_ray.idfsGISBaseReference = gbr_ray.idfsGISBaseReference
		and gsnt_ray.idfsLanguage = @idfsLanguage
		and gsnt_ray.intRowStatus = 0
	where ray.intRowStatus = 0


	declare @DiagnosisTable table
	(
		idfsDiagnosis bigint not null primary key
	)

	insert into @DiagnosisTable
	(
		idfsDiagnosis
	)
	select 
		fdt.idfsDiagnosisOrReportDiagnosisGroup
	from  dbo.trtReportRows fdt
	  inner join trtDiagnosis trtd
	  on trtd.idfsDiagnosis = fdt.idfsDiagnosisOrReportDiagnosisGroup AND
	  trtd.intRowStatus = 0
	where  fdt.idfsCustomReportType = @idfsCustomReportType 



	declare	@ReportCaseTable	table
	(	
		idfCase					bigint not null primary key,
		idfsRegion				bigint not null,
		idfsRayon				bigint not null,
		Is7DayNotification		bit not null default(0),
		Is2DayRegistration		bit not null default(0),
		Is2FaecalSpecimen		bit not null default(0),
		IsFollowUpInvestigation	bit not null default(0),
		IsFinalClassification	bit not null default(0),
		IsOPVDoses				bit not null default(0)
	)
	



	insert into	@ReportCaseTable
	(	
		idfCase,
		idfsRegion,
		idfsRayon,
		Is7DayNotification,
		Is2DayRegistration
	)
	select distinct
		hc.idfHumanCase AS idfCase,
		gl.idfsRegion,  
		gl.idfsRayon,  
		case when hc.datNotificationDate - CAST(tap.varValue as datetime) <= 7 then 1 else 0 end,
		case when hc.datInvestigationStartDate - hc.datNotificationDate <= 2 then 1 else 0 end
	from tlbHumanCase hc
		inner join tlbHuman h
			inner  join tlbGeoLocation gl
			on h.idfCurrentResidenceAddress = gl.idfGeoLocation AND gl.intRowStatus = 0
		on hc.idfHuman = h.idfHuman AND
		   h.intRowStatus = 0

		inner join	@ReportTable fdt
		on	fdt.idfsRegion = gl.idfsRegion
		and fdt.idfsRayon = gl.idfsRayon
		
		inner join @DiagnosisTable dt
		on dt.idfsDiagnosis = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)

		inner join tlbObservation obs
			inner join tlbActivityParameters tap
			on tap.idfObservation = obs.idfObservation
			and tap.intRowStatus = 0
			and tap.idfsParameter = @FFP_Date_of_onset_of_paralysis
			and (
					cast(SQL_VARIANT_PROPERTY(tap.varValue, 'BaseType') as nvarchar) like N'%date%' or
					(cast(SQL_VARIANT_PROPERTY(tap.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(tap.varValue as nvarchar)) = 1 )	
				)  
		on	obs.idfObservation = hc.idfCSObservation
			and obs.intRowStatus = 0	
	  			
		left join tstSite ts
		on ts.idfsSite = hc.idfsSite
		and ts.intRowStatus = 0
		and ts.intFlags = 1
  			
	where		(@SD <= CAST(tap.varValue as datetime) and CAST(tap.varValue as datetime) < DATEADD(day, 1, @ED)) 
				and ts.idfsSite is null
				and hc.intRowStatus = 0 
				and hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/

	update rct set
	rct.Is2FaecalSpecimen = 1
	from @ReportCaseTable rct
	where exists
      (
          select  *
          from @ReportCaseTable  rct1
            inner join tlbMaterial m
            on m.idfHumanCase = rct1.idfCase
            and m.idfsSampleType = @idfsSample_FecesStool --7721770000000 --Feces-Stool
            and m.intRowStatus = 0
            
            inner join tlbHumanCase hc
				inner join tlbObservation obs_hc
					inner join tlbActivityParameters tap_hc
					on tap_hc.idfObservation = obs_hc.idfObservation
					and tap_hc.intRowStatus = 0
					and tap_hc.idfsParameter = @FFP_Date_of_onset_of_paralysis
					and (
							cast(SQL_VARIANT_PROPERTY(tap_hc.varValue, 'BaseType') as nvarchar) like N'%date%' or
							(cast(SQL_VARIANT_PROPERTY(tap_hc.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(tap_hc.varValue as nvarchar)) = 1 )	
						)  
				on	obs_hc.idfObservation = hc.idfCSObservation and obs_hc.intRowStatus = 0
            on hc.idfHumanCase = rct1.idfCase
            and m.datFieldCollectionDate - CAST(tap_hc.varValue as datetime) <=  14 
            
            inner join (
              select rct2.idfCase, m2.datFieldCollectionDate
              from @ReportCaseTable  rct2
                  inner join tlbMaterial m2
                    on m2.idfHumanCase = rct2.idfCase
                    and m2.idfsSampleType = @idfsSample_FecesStool--7721770000000 --Feces-Stool
                    and m2.intRowStatus = 0
                  
                  inner join tlbHumanCase hc2
						inner join tlbObservation obs_hc2
							inner join tlbActivityParameters tap_hc2
							on tap_hc2.idfObservation = obs_hc2.idfObservation
							and tap_hc2.intRowStatus = 0
							and tap_hc2.idfsParameter = @FFP_Date_of_onset_of_paralysis
							and (
									cast(SQL_VARIANT_PROPERTY(tap_hc2.varValue, 'BaseType') as nvarchar) like N'%date%' or
									(cast(SQL_VARIANT_PROPERTY(tap_hc2.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(tap_hc2.varValue as nvarchar)) = 1 )	
								)  
						on	obs_hc2.idfObservation = hc2.idfCSObservation and obs_hc2.intRowStatus = 0
                    on hc2.idfHumanCase = rct2.idfCase
                    and m2.datFieldCollectionDate - CAST(tap_hc2.varValue as datetime) <=  14 
            
            ) as rct2_m2
            on rct2_m2.idfCase = rct1.idfCase
            and rct2_m2.datFieldCollectionDate - m.datFieldCollectionDate < 2
            
          where 
            rct.idfCase = rct1.idfCase
      )


	
	update rct set
		rct.IsFollowUpInvestigation = 1
	from @ReportCaseTable rct
	where exists
	  (
		  select  *
		  from @ReportCaseTable  rct1
			inner join tlbHumanCase hc
			on hc.idfHumanCase = rct1.idfCase
	        
			inner join tlbObservation obs
			on obs.idfObservation = hc.idfEpiObservation
			and obs.intRowStatus = 0
	        
			inner join dbo.tlbActivityParameters ap
				  inner join	dbo.ffParameter p
					on	p.idfsParameter = ap.idfsParameter
					  and p.intRowStatus = 0 
					  and p.idfsParameter = @FFP_Hastheclinicalexamination
			on ap.idfObservation = obs.idfObservation
			and ap.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(ap.varValue, 'BaseType') = 'bigint'
			and CAST(ap.varValue AS BIGINT) = 25460000000--217140000000 -- Yes
		  where 
			rct.idfCase = rct1.idfCase
	  )


	update rct set
		rct.IsFinalClassification = 1
	from @ReportCaseTable rct
	where exists
	  (
		  select  *
		  from @ReportCaseTable  rct1
			inner join tlbHumanCase hc
			on hc.idfHumanCase = rct1.idfCase
	        
	        inner join tlbObservation obs_hc
				inner join tlbActivityParameters tap_hc
				on tap_hc.idfObservation = obs_hc.idfObservation
				and tap_hc.intRowStatus = 0
				and tap_hc.idfsParameter = @FFP_Date_of_onset_of_paralysis
				and (cast(SQL_VARIANT_PROPERTY(tap_hc.varValue, 'BaseType') as nvarchar) like N'%date%' or
						(cast(SQL_VARIANT_PROPERTY(tap_hc.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(tap_hc.varValue as nvarchar)) = 1 )	)  
			on	obs_hc.idfObservation = hc.idfCSObservation
				and obs_hc.intRowStatus = 0	
			
			inner join tlbObservation obs
			on obs.idfObservation = hc.idfEpiObservation
			and obs.intRowStatus = 0
	        
			inner join dbo.tlbActivityParameters ap
				  inner join	dbo.ffParameter p
					on	p.idfsParameter = ap.idfsParameter
					  and p.intRowStatus = 0 
					  and p.idfsParameter = @FFP_DateOfFinalClassification
			on ap.idfObservation = obs.idfObservation
			and ap.intRowStatus = 0
			and (cast(SQL_VARIANT_PROPERTY(ap.varValue, 'BaseType') as nvarchar) like N'%date%' or
						(cast(SQL_VARIANT_PROPERTY(ap.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap.varValue as nvarchar)) = 1 )	) 
	      
		  where 
			rct.idfCase = rct1.idfCase
			and CAST(ap.varValue AS datetime) - CAST(tap_hc.varValue as datetime) <= 90
	  )
      
      
	update rct set
		rct.IsOPVDoses  = 1
	from @ReportCaseTable rct
	where exists
	  (
		  select  *
		  from @ReportCaseTable  rct1
			inner join tlbHumanCase hc
			on hc.idfHumanCase = rct1.idfCase
	        
			inner join tlbObservation obs
			on obs.idfObservation = hc.idfEpiObservation
			and obs.intRowStatus = 0
	        
			left join dbo.tlbActivityParameters ap
				  inner join	dbo.ffParameter p
					on	p.idfsParameter = ap.idfsParameter
					  and p.intRowStatus = 0 
					  and p.idfsParameter = @FFP_NumberOfVaccineDoses_SupplementaryImmunization
			on ap.idfObservation = obs.idfObservation
			and ap.intRowStatus = 0
			and (isnumeric( cast(ap.varValue as varchar(20))) =1 and cast(ap.varValue as varchar(20)) not in ('.', ','))
	        
			left join dbo.tlbActivityParameters ap1
				  inner join	dbo.ffParameter p1
					on	p1.idfsParameter = ap1.idfsParameter
					  and p1.intRowStatus = 0 
					  and p1.idfsParameter = @FFP_NumberOfVaccineDoses_RoutineImmunization
			on ap1.idfObservation = obs.idfObservation
			and ap1.intRowStatus = 0
			and (isnumeric( cast(ap1.varValue as varchar(20))) =1 and cast(ap.varValue as varchar(20)) not in ('.', ','))
	        
	      
		  where 
			rct.idfCase = rct1.idfCase
			and (
				  CAST(ap.varValue AS int) is not null or 
				  CAST(ap1.varValue AS int) is not null
				)
			and isnull(CAST(ap.varValue AS int) , 0)  +  isnull(CAST(ap1.varValue AS int), 0) < 3
			and
			case
					  when	hc.idfsHumanAgeType =  10042003	--Years
							and (hc.intPatientAge >= 0 and hc.intPatientAge <= 150)
						then	hc.intPatientAge
					    
					  when	hc.idfsHumanAgeType = 10042002 /*'hatMonth'*/
							and hc.intPatientAge >= 0
						then hc.intPatientAge / 12
					    
					  when	hc.idfsHumanAgeType = 10042001 /*'hatDays'*/
							and hc.intPatientAge >= 0
						then  0
					  else	null
				  end >= 0.2  and 
				  case
					  when	hc .idfsHumanAgeType =  10042003	--Years
							and (hc.intPatientAge >= 0 and hc.intPatientAge <= 150)
						then	hc.intPatientAge
					    
					  when	hc.idfsHumanAgeType = 10042002 /*'hatMonth'*/
							and hc.intPatientAge >= 0
						then hc.intPatientAge / 12
					    
					  when	hc.idfsHumanAgeType = 10042001 /*'hatDays'*/
							and hc.intPatientAge >= 0
						then  0
					  else	null
				  end <= 5
	  )



    
    


  --Total
  declare	@ReportCaseDiagnosisTotalValuesTable	table
  (	
	  intTotal		INT not null,
	  idfsRegion bigint not null,
	  idfsRayon bigint not null
  )

  insert into	@ReportCaseDiagnosisTotalValuesTable
  (	
	  intTotal,
	  idfsRegion,
	  idfsRayon
  )
  SELECT 
			  count(fct.idfCase),
			  idfsRegion,
			  idfsRayon
  from		@ReportCaseTable fct
  group by	fct.idfsRegion, fct.idfsRayon



  --7DayNotification
  declare	@ReportCaseDiagnosisTotalValuesTable_7DayNotification	table
  (	
	  intTotal		INT not null,
	  idfsRegion bigint not null,
	  idfsRayon bigint not null
  )

  insert into	@ReportCaseDiagnosisTotalValuesTable_7DayNotification
  (	
	  intTotal,
	  idfsRegion,
	  idfsRayon
  )
  SELECT 
			  count(rct.idfCase),
			  idfsRegion,
			  idfsRayon
  from		@ReportCaseTable rct
  where rct.Is7DayNotification = 1
  group by	rct.idfsRegion, rct.idfsRayon


  --2DayRegistration
  declare	@ReportCaseDiagnosisTotalValuesTable_2DayRegistration	table
  (	
	  intTotal		INT not null,
	  idfsRegion bigint not null,
	  idfsRayon bigint not null
  )

  insert into	@ReportCaseDiagnosisTotalValuesTable_2DayRegistration
  (	
	  intTotal,
	  idfsRegion,
	  idfsRayon
  )
  SELECT 
			  count(rct.idfCase),
			  idfsRegion,
			  idfsRayon
  from		@ReportCaseTable rct
  where rct.Is2DayRegistration = 1
  group by	rct.idfsRegion, rct.idfsRayon



  --2FaecalSpecimen
  declare	@ReportCaseDiagnosisTotalValuesTable_2FaecalSpecimen	table
  (	
	  intTotal		INT not null,
	  idfsRegion bigint not null,
	  idfsRayon bigint not null
  )

  insert into	@ReportCaseDiagnosisTotalValuesTable_2FaecalSpecimen
  (	
	  intTotal,
	  idfsRegion,
	  idfsRayon
  )
  SELECT 
			  count(rct.idfCase),
			  idfsRegion,
			  idfsRayon
  from		@ReportCaseTable rct
  where rct.Is2FaecalSpecimen = 1
  group by	rct.idfsRegion, rct.idfsRayon



  --FollowUpInvestigation
  declare	@ReportCaseDiagnosisTotalValuesTable_FollowUpInvestigation	table
  (	
	  intTotal		INT not null,
	  idfsRegion bigint not null,
	  idfsRayon bigint not null
  )

  insert into	@ReportCaseDiagnosisTotalValuesTable_FollowUpInvestigation
  (	
	  intTotal,
	  idfsRegion,
	  idfsRayon
  )
  SELECT 
			  count(rct.idfCase),
			  idfsRegion,
			  idfsRayon
  from		@ReportCaseTable rct
  where rct.IsFollowUpInvestigation = 1
  group by	rct.idfsRegion, rct.idfsRayon


  --FinalClassification
  declare	@ReportCaseDiagnosisTotalValuesTable_FinalClassification	table
  (	
	  intTotal		INT not null,
	  idfsRegion bigint not null,
	  idfsRayon bigint not null
  )

  insert into	@ReportCaseDiagnosisTotalValuesTable_FinalClassification
  (	
	  intTotal,
	  idfsRegion,
	  idfsRayon
  )
  SELECT 
			  count(rct.idfCase),
			  idfsRegion,
			  idfsRayon
  from		@ReportCaseTable rct
  where rct.IsFinalClassification = 1
  group by	rct.idfsRegion, rct.idfsRayon


  --OPVDoses
  declare	@ReportCaseDiagnosisTotalValuesTable_OPVDoses	table
  (	
	  intTotal		INT not null,
	  idfsRegion bigint not null,
	  idfsRayon bigint not null
  )

  insert into	@ReportCaseDiagnosisTotalValuesTable_OPVDoses
  (	
	  intTotal,
	  idfsRegion,
	  idfsRayon
  )
  SELECT 
			  count(rct.idfCase),
			  idfsRegion,
			  idfsRayon
  from		@ReportCaseTable rct
  where rct.IsOPVDoses = 1
  group by	rct.idfsRegion, rct.idfsRayon
  
  


  -- update @ReportTable
  update		rt
  set			rt.intTotal = fcdvt.intTotal
  from		@ReportTable rt
  inner join	@ReportCaseDiagnosisTotalValuesTable fcdvt
  on			fcdvt.idfsRegion = rt.idfsRegion
      and fcdvt.idfsRayon = rt.idfsRayon
  	   
  update		rt
  set			rt.int7DayNotification = rtt.intTotal
  from		@ReportTable rt
  inner join	@ReportCaseDiagnosisTotalValuesTable_7DayNotification rtt
  on			rtt.idfsRegion = rt.idfsRegion
      and rtt.idfsRayon  = rt.idfsRayon
  	   
  update		rt
  set			rt.int2DayRegistration = rtt.intTotal
  from		@ReportTable rt
  inner join	@ReportCaseDiagnosisTotalValuesTable_2DayRegistration rtt
  on			rtt.idfsRegion = rt.idfsRegion
      and rtt.idfsRayon  = rt.idfsRayon  	   
  	   
  update		rt
  set			rt.int2FaecalSpecimen = rtt.intTotal
  from		@ReportTable rt
  inner join	@ReportCaseDiagnosisTotalValuesTable_2FaecalSpecimen rtt
  on			rtt.idfsRegion = rt.idfsRegion
      and rtt.idfsRayon  = rt.idfsRayon  	   
  	   
  update		rt
  set			rt.intFollowUpInvestigation = rtt.intTotal
  from		@ReportTable rt
  inner join	@ReportCaseDiagnosisTotalValuesTable_FollowUpInvestigation rtt
  on			rtt.idfsRegion = rt.idfsRegion
      and rtt.idfsRayon  = rt.idfsRayon  	    	   
  	   
  update		rt
  set			rt.intFinalClassification = rtt.intTotal
  from		@ReportTable rt
  inner join	@ReportCaseDiagnosisTotalValuesTable_FinalClassification rtt
  on			rtt.idfsRegion = rt.idfsRegion
      and rtt.idfsRayon  = rt.idfsRayon  	    	   
  	   
  update		rt
  set			rt.intOPVDoses = rtt.intTotal
  from		@ReportTable rt
  inner join	@ReportCaseDiagnosisTotalValuesTable_OPVDoses rtt
  on			rtt.idfsRegion = rt.idfsRegion
      and rtt.idfsRayon  = rt.idfsRayon  	    	   
  	   
  	   
  	   
  select   	   
    strRegion,
    strRayon,
    intTotal,
    int7DayNotification,
    int2DayRegistration,
    int2FaecalSpecimen,
    intPositiveEnterovirus,
    intFollowUpInvestigation,
    intFinalClassification,
    intOPVDoses,
    intRegionOrder  	   
 from @ReportTable   
  	   

			
--=========================================================--					
	--- STUB results ---
	--- it should be deleted after proper implementation ---
--=========================================================--									
	

	--SELECT		refReg.[name] as strRegion, 
	--			refRay.[name] as strRayon,
	--			cast(50*RAND(BINARY_CHECKSUM(NEWID()))as int)	as intTotal,
	--			cast(5*RAND(BINARY_CHECKSUM(NEWID()))as int)	as int7DayNotification,
	--			cast(5*RAND(BINARY_CHECKSUM(NEWID()))as int)	as int2DayRegistration,
	--			cast(5*RAND(BINARY_CHECKSUM(NEWID()))as int)	as int2FaecalSpecimen,
	--			cast(5*RAND(BINARY_CHECKSUM(NEWID()))as int)	as intPositiveEnterovirus,
	--			cast(5*RAND(BINARY_CHECKSUM(NEWID()))as int)	as intFollowUpInvestigation,
	--			cast(5*RAND(BINARY_CHECKSUM(NEWID()))as int)	as intFinalClassification,
	--			cast(5*RAND(BINARY_CHECKSUM(NEWID()))as int)	as intOPVDoses
				


	--FROM		gisRegion	as reg
	--inner join	fnGisReference(@LangID, 19000003 /*rftRegion*/) as refReg 
	--on			reg.idfsRegion = refReg.idfsReference			
	--and			reg.idfsCountry = @CountryID
	--inner join	gisRayon as ray
	--on			ray.idfsRegion = reg.idfsRegion	
	--inner join	fnGisReference(@LangID, 19000002 /*rftRayon*/) as refRay 
	--on			ray.idfsRayon = refRay.idfsReference	
	--order by	strRegion, strRayon 


