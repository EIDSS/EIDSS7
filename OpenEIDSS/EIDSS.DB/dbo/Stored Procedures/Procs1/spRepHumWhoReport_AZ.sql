
   
   --##SUMMARY Select data for Monthly Morbidity and Mortality report
   
   --##REMARKS Author: Romasheva S.
   --##REMARKS Create date: 29.10.2013
    
   --##RETURNS Doesn't use
   
   /*
   --Example of a call of procedure:
   


   --AZ
   --Measles
   exec dbo.[spRepHumWhoReport_AZ] @LangID=N'en',@StartDate='20120101',@EndDate='20141201', @idfsDiagnosis = 7720040000000
   --rubella
   exec dbo.[spRepHumWhoReport_AZ] @LangID=N'en',@StartDate='20130101',@EndDate='20131201', @idfsDiagnosis = 7720770000000
   
        
   */
   
   create  Procedure [dbo].[spRepHumWhoReport_AZ]
   	 (
   			@LangID		as nvarchar(50), 
   			@StartDate datetime,
   			@EndDate datetime,
   			@idfsDiagnosis bigint
   	 )
   AS	
   
   	
   begin
   	
   	declare	@ResultTable	table
   	(	  
   		  idfCase					bigint not null primary key
   		, strCaseID					nvarchar(300) collate database_default not null 
   		, intAreaID					int not null 
   		, datDRash					date null
   		, intGenderID				int not null 
   		, datDBirth					date null
   		, intAgeAtRashOnset			int null
   		, intNumOfVaccines			int null
   		, datDvaccine				datetime null
   		, datDNotification			datetime null
   		, datDInvestigation			datetime null
   		, intClinFever				int null
   		, intClinCCC				int null
   		, intClinRashDuration		int null
   		, intClinOutcome			int null
   		, intClinHospitalization	int null
   		, intSrcInf					int null
   		, intSrcOutbreakRelated		int null
   		, strSrcOutbreakID			nvarchar(50) collate database_default null default null
   		, intCompComplications		int null
   		, intCompEncephalitis		int null
   		, intCompPneumonia			int null
   		, intCompMalnutrition		int null
   		, intCompDiarrhoea			int null
   		, intCompOther				int null
   		, intFinalClassification	int null
   		, datDSpecimen				datetime null
   		, intSpecimen				int null
   		, datDLabResult				datetime null
   		, intMeaslesIgm				int null
   		, intMeaslesVirusDetection	int null		
   		, intRubellaIgm				int null
   		, intRubellaVirusDetection	int null
   		, strCommentsEpi			nvarchar(500) collate database_default null 
   	)
   	
   		
   	
   	declare 
   	  
   		@idfsCustomReportType						bigint,
   		
    		
   		
   		@FFP_DateOfOnset_M				bigint,
   		@FFP_DateOfOnset_R				bigint,  	
   			
   		@FFP_NumberOfReceivedDoses_M	bigint,
   		@FFP_NumberOfReceivedDoses_R	bigint,  		
   		
   		@FFP_DateOfLastVaccination_M	bigint,
   		@FFP_DateOfLastVaccination_R	bigint,  		
   		
   		@FFP_Fever_M					bigint,
   	   		
   		@FFP_Cough_M					bigint,
   		   		
   		@FFP_Coryza_M					bigint,
   	   		
   		@FFP_Conjunctivitis_M			bigint,
   	   		
   		@FFP_RashDuration_M				bigint,
   		@FFP_RashDuration_R				bigint,  		
   		
   		@FFP_SourceOfInfection_M		bigint,
   		@FFP_SourceOfInfection_R		bigint,  		
   		
   		@FFP_Encephalitis_M				bigint,
   		@FFP_Encephalitis_R				bigint,  		
   		  		
   		@FFP_Pneumonia_M				bigint,
   		@FFP_Pneumonia_R				bigint,  		
   		  		  		
   		@FFP_Diarrhoea_M				bigint,
     		  		  		
   		@FFP_Other_M					bigint,  		  		
   		@FFP_Other_R					bigint,  	 
   		 		
  		@idfsDiagnosis_Measles			bigint,
   		@idfsDiagnosis_Rubella			bigint,
   		
   		@idfsCountry					bigint
   		
   		
   	
 	set @idfsCountry = 170000000
 				
			  	
   	SET @idfsCustomReportType = 10290027 /*WHO Report - AJ&GG*/
   
   	--HCS FF - Rash onset date. / HCS FF- Date of onset
   	select @FFP_DateOfOnset_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_DateOfOnset_M'
   	and intRowStatus = 0
   	
   	select @FFP_DateOfOnset_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_DateOfOnset_R'
   	and intRowStatus = 0
   	  
   	--HEI - Number of received doses (any vaccine with measles component) / HEI - Number of Measles vaccine doses received
   	select @FFP_NumberOfReceivedDoses_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_NumberOfReceivedDoses_M'
   	and intRowStatus = 0
   	
   	select @FFP_NumberOfReceivedDoses_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_NumberOfReceivedDoses_R'
   	and intRowStatus = 0  	
   	
   	--HEI - Date of last vaccination/HEI - Date of last Measles vaccine
   	select @FFP_DateOfLastVaccination_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_DateOfLastVaccination_M'
   	and intRowStatus = 0	
   	
   	select @FFP_DateOfLastVaccination_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_DateOfLastVaccination_R'
   	and intRowStatus = 0	  
   		
   	--HCS - Fever/HCS - Fever
   	select @FFP_Fever_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Fever_M'
   	and intRowStatus = 0
   	
     		
   	--HCS - Cough / Coryza / Conjunctivitis /HCS - Cough / Coryza / Conjunctivitis
   	select @FFP_Cough_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Cough_M'
   	and intRowStatus = 0	

   	
   	select @FFP_Coryza_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Coryza_M'
   	and intRowStatus = 0	
   	
    	
   	select @FFP_Conjunctivitis_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Conjunctivitis_M'
   	and intRowStatus = 0	
   	
    	
   	--HCS - Rash duration / HCS - Duration (days)
   	select @FFP_RashDuration_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_RashDuration_M'
   	and intRowStatus = 0
   	
   	select @FFP_RashDuration_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_RashDuration_R'
   	and intRowStatus = 0  	
   		
   	--EPI - Source of infection / EPI - Source of infection
   	select @FFP_SourceOfInfection_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_SourceOfInfection_M'
   	and intRowStatus = 0		
   	
   	select @FFP_SourceOfInfection_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_SourceOfInfection_R'
   	and intRowStatus = 0	  	
   	
   	--HCS - Encephalitis / HCS - Encephalitis
   	select @FFP_Encephalitis_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Encephalitis_M'
   	and intRowStatus = 0		
   	
   	select @FFP_Encephalitis_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Encephalitis_R'
   	and intRowStatus = 0	  	
   	
   	--HCS - Pneumonia / HCS - Pneumonia
   	select @FFP_Pneumonia_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Pneumonia_M'
   	and intRowStatus = 0	
   	
   	select @FFP_Pneumonia_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Pneumonia_R'
   	and intRowStatus = 0	  	
   		
   	--HCS - Diarrhoea / HCS - Diarrhoea
   	select @FFP_Diarrhoea_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Diarrhoea_M'
   	and intRowStatus = 0		

   	--HCS - Other (specify) / HCS - Other
   	select @FFP_Other_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Other_M'
   	and intRowStatus = 0	 
   	
   	select @FFP_Other_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Other_R'
   	and intRowStatus = 0	   	
   	
   	 	
   	--idfsDiagnosis for:
   	--Measles
   	select top 1 @idfsDiagnosis_Measles = d.idfsDiagnosis
   	from trtDiagnosis d
   	  inner join dbo.trtDiagnosisToGroupForReportType dgrt
   	  on dgrt.idfsDiagnosis = d.idfsDiagnosis
   	  and dgrt.idfsCustomReportType = @idfsCustomReportType
   	  
   	  inner join dbo.trtReportDiagnosisGroup dg
   	  on dgrt.idfsReportDiagnosisGroup = dg.idfsReportDiagnosisGroup
   	  and dg.intRowStatus = 0 and dg.strDiagnosisGroupAlias = 'DG_Measles'
     where d.intRowStatus = 0
   	
   	--Rubella
   	select top 1 @idfsDiagnosis_Rubella = d.idfsDiagnosis
   	from trtDiagnosis d
   	  inner join dbo.trtDiagnosisToGroupForReportType dgrt
   	  on dgrt.idfsDiagnosis = d.idfsDiagnosis
   	  and dgrt.idfsCustomReportType = @idfsCustomReportType
   	  
   	  inner join dbo.trtReportDiagnosisGroup dg
   	  on dgrt.idfsReportDiagnosisGroup = dg.idfsReportDiagnosisGroup
   	  and dg.intRowStatus = 0 and dg.strDiagnosisGroupAlias = 'DG_Rubella'
     where d.intRowStatus = 0	     
   	
   	
    declare @AreaIDs table
    (
		intAreaID int,
		idfsRegion bigint,
		idfsRayon bigint
    )

	insert into @AreaIDs (intAreaID, idfsRegion, idfsRayon)
	select		
	cast(tgra.varValue as int), gr.idfsRegion, gr.idfsRayon
	from trtGISBaseReferenceAttribute tgra
		inner join trtAttributeType tat
		on tat.idfAttributeType = tgra.idfAttributeType
		and tat.strAttributeTypeName = 'WHOrep_specific_gis_rayon'

		inner join gisRayon gr
		on gr.idfsRayon = tgra.idfsGISBaseReference
 	    
   	
   	;with hc_obs
   	as (
   	select 
   		hc.idfHumanCase,
   		case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and 
 				(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_M.varValue, 'BaseType') as nvarchar) like N'%date%' or
					(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_M.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_DateOfOnset_M.varValue as nvarchar)) = 1 )	)  
 				then dbo.fnDateCutTime(cast(ap_DateOfOnset_M.varValue as datetime))
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and 
 				(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_R.varValue, 'BaseType') as nvarchar) like N'%date%' or
					(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_R.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_DateOfOnset_R.varValue as nvarchar)) = 1 )	)  
 				then dbo.fnDateCutTime(cast(ap_DateOfOnset_R.varValue as datetime))
 			else null
   		end as DateOfOnset,
   		
   		case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles 
 				then cast(ap_NumberOfReceivedDoses_M.varValue as nvarchar(50)) 
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella 
  				then cast(ap_NumberOfReceivedDoses_R.varValue as nvarchar(50))
 			else null
   		end as NumberOfReceivedDoses,
   		
   		case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and 
 				cast(SQL_VARIANT_PROPERTY(ap_DateOfLastVaccination_M.varValue, 'BaseType') as nvarchar) like N'%date%' or
					(cast(SQL_VARIANT_PROPERTY(ap_DateOfLastVaccination_M.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_DateOfLastVaccination_M.varValue as nvarchar)) = 1 )	
 				then dbo.fnDateCutTime(cast(ap_DateOfLastVaccination_M.varValue as datetime))
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and 
 				cast(SQL_VARIANT_PROPERTY(ap_DateOfLastVaccination_R.varValue, 'BaseType') as nvarchar) like N'%date%' or
					(cast(SQL_VARIANT_PROPERTY(ap_DateOfLastVaccination_R.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_DateOfLastVaccination_R.varValue as nvarchar)) = 1 )	
 				then dbo.fnDateCutTime(cast(ap_DateOfLastVaccination_R.varValue as datetime))
 			else null
   		end as DateOfLastVaccination,
   		
   		case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and 
 				SQL_VARIANT_PROPERTY(ap_Fever_M.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Fever_M.varValue as bigint)
 			else null
   		end as Fever,
   		
   		case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and 
 				SQL_VARIANT_PROPERTY(ap_Cough_M.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Cough_M.varValue as bigint)
 			else null
   		end as Cough,
  		
   		case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and 
 				SQL_VARIANT_PROPERTY(ap_Coryza_M.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Coryza_M.varValue as bigint)
 			else null
   		end as Coryza,  		
 
   		case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and 
 				SQL_VARIANT_PROPERTY(ap_Conjunctivitis_M.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Conjunctivitis_M.varValue as bigint)
 			else null
   		end as Conjunctivitis,  
   		
   		case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles 
 				then cast(ap_RashDuration_M.varValue as nvarchar(50))
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella 
 				then cast(ap_RashDuration_R.varValue as nvarchar(50))
 			else null
   		end as RashDuration,	
   		
   		case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and 
 				SQL_VARIANT_PROPERTY(ap_SourceOfInfection_M.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_SourceOfInfection_M.varValue as bigint)
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and 
 				SQL_VARIANT_PROPERTY(ap_SourceOfInfection_R.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_SourceOfInfection_R.varValue as bigint)
 			else null
   		end as SourceOfInfection,   
   		
   		case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and 
 				SQL_VARIANT_PROPERTY(ap_Encephalitis_M.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Encephalitis_M.varValue as bigint)
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and 
 				SQL_VARIANT_PROPERTY(ap_Encephalitis_R.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Encephalitis_R.varValue as bigint)
 			else null
   		end as Encephalitis,    
   		
   		case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and 
 				SQL_VARIANT_PROPERTY(ap_Pneumonia_M.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Pneumonia_M.varValue as bigint)
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and 
 				SQL_VARIANT_PROPERTY(ap_Pneumonia_R.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Pneumonia_R.varValue as bigint)
 			else null
   		end as Pneumonia,    	

   		case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and 
 				SQL_VARIANT_PROPERTY(ap_Diarrhoea_M.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Diarrhoea_M.varValue as bigint)
 			else null
   		end as Diarrhoea,    
   		
   		case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles 
 				then cast(ap_Other_M.varValue as nvarchar(500))
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella 
 				then cast(ap_Other_R.varValue as nvarchar(500))
 			else null
   		end as Other	  		  		  		  			
 
     from tlbHumanCase hc
 		inner join tlbHuman h
 		on hc.idfHuman = h.idfHuman and  h.intRowStatus = 0
 		   
 		left join tstSite ts
 		on ts.idfsSite = hc.idfsSite
 		and ts.intRowStatus = 0
 		and ts.intFlags = 1         
 		     
		left join tlbObservation ob_CS 
			on	ob_CS.idfObservation = hc.idfCSObservation
 			and ob_CS.intRowStatus = 0
 			
		left join tlbObservation ob_EPI 
			on	ob_EPI.idfObservation = hc.idfEpiObservation
 			and ob_EPI.intRowStatus = 0 	 		     
 		     
    
   		---     
	
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_DateOfOnset_M
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_DateOfOnset_M
 		 		
  		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_DateOfOnset_R
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_DateOfOnset_R 	
 		 		
 				
 		---
		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_EPI.idfObservation
 				and	ap.idfsParameter = @FFP_NumberOfReceivedDoses_M
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_NumberOfReceivedDoses_M 		
		
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_EPI.idfObservation
 				and	ap.idfsParameter = @FFP_NumberOfReceivedDoses_R
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_NumberOfReceivedDoses_R 	 		 			
     			
     	---		
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_EPI.idfObservation
 				and	ap.idfsParameter = @FFP_DateOfLastVaccination_M
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_DateOfLastVaccination_M 	
 
  		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_EPI.idfObservation
 				and	ap.idfsParameter = @FFP_DateOfLastVaccination_R
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_DateOfLastVaccination_R  		   			
   			
   		---
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Fever_M
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Fever_M 	
 		
   		---
		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Cough_M
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Cough_M 	
 		
  		---
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Coryza_M
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Coryza_M
 
   		---
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Conjunctivitis_M	
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Conjunctivitis_M

   		---
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_RashDuration_M	
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_RashDuration_M
 
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_RashDuration_R		
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_RashDuration_R 		
   		
   		---
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_EPI.idfObservation
 				and	ap.idfsParameter = @FFP_SourceOfInfection_M		
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_SourceOfInfection_M
 
   		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_EPI.idfObservation
 				and	ap.idfsParameter = @FFP_SourceOfInfection_R			
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_SourceOfInfection_R 				
   		
   		---
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Encephalitis_M				
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Encephalitis_M
 
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Encephalitis_R					
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Encephalitis_R
	
   		---
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Pneumonia_M					
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Pneumonia_M
 
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Pneumonia_R						
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Pneumonia_R 			
 	
   		---
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Diarrhoea_M						
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Diarrhoea_M
 
   		---
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Other_M							
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Other_M
 

 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Other_R								
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Other_R 		
   	where 	
 		ts.idfsSite is null and
 		isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis and
 		(
 		-- Measles
 		(
 		  isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and 
 		  (cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_M.varValue, 'BaseType') as nvarchar) like N'%date%'  or
					(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_M.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_DateOfOnset_M.varValue as nvarchar)) = 1 )	 
		  ) 		  
 		  and 
 		  CAST(ap_DateOfOnset_M.varValue as datetime) is not null and
 		  CAST(ap_DateOfOnset_M.varValue as datetime) >= @StartDate and
 		  CAST(ap_DateOfOnset_M.varValue as datetime) <  @EndDate
 		) 
 		or 
 		-- Rubella
 		(
 		  isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and 
 		  (cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_R.varValue, 'BaseType') as nvarchar) like N'%date%'   or
					(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_R.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_DateOfOnset_R.varValue as nvarchar)) = 1 )	 
		  ) 	
		  and 
 		  cast(ap_DateOfOnset_R.varValue as datetime) is not null and
 		  CAST(ap_DateOfOnset_R.varValue as datetime) >= @StartDate and
 		  CAST(ap_DateOfOnset_R.varValue as datetime) <  @EndDate
 		)
 		)		
 	), -- end of hc_obs
 	
 	hc_table
 	as 
 	(
 		select distinct
 			hc.idfHumanCase as idfCase,
 			'AZE' + hc.strCaseID as strCaseID,
 			aid.intAreaID, 
 			hc_obs.DateOfOnset as datDRash, 
 			case 
 				when h.idfsHumanGender = 10043001 then 2
 				when h.idfsHumanGender = 10043002 then 1
 				else 4
 			end as intGenderID, 
      		dbo.fnDateCutTime(h.datDateofBirth) as datDBirth, 
      		case
 				when	IsNull(hc.idfsHumanAgeType, -1) = 10042003	-- Years 
 						and (IsNull(hc.intPatientAge, -1) >= 0 and IsNull(hc.intPatientAge, -1) <= 200)
 					then	hc.intPatientAge
 				when	IsNull(hc.idfsHumanAgeType, -1) = 10042002	-- Months
 						and (IsNull(hc.intPatientAge, -1) >= 0 and IsNull(hc.intPatientAge, -1) <= 60)
 					then	cast(hc.intPatientAge / 12 as int)
 				when	IsNull(hc.idfsHumanAgeType, -1) = 10042001	-- Days
 						and (IsNull(hc.intPatientAge, -1) >= 0)
 					then	0
 				else	null
 			end	 as intAgeAtRashOnset,     	
 			
 			isnull(case when isnumeric(hc_obs.NumberOfReceivedDoses) = 1 and cast(hc_obs.NumberOfReceivedDoses as varchar) not in ('.', ',', '-', '+', '$')
 						then --cast(hc_obs.NumberOfReceivedDoses as int)
 							 cast(cast(replace(hc_obs.NumberOfReceivedDoses,',','.') as decimal) as int)
 						else 9 end
 				, 9)	 as intNumOfVaccines, 
 				
 			hc_obs.DateOfLastVaccination as datDvaccine, 			
     		dbo.fnDateCutTime(hc.datNotificationDate) as datDNotification, 
     		dbo.fnDateCutTime(hc.datInvestigationStartDate) as datDInvestigation, 
     		
     		case hc_obs.Fever
 			    when 25460000000 then 1
 			    when 25640000000 then 2
 			    when 25660000000 then 9
 			    else null
 			end	 as intClinFever, 
 			
     		case 
     			case 
     				when hc_obs.Cough = 25460000000 or hc_obs.Coryza = 25460000000 or hc_obs.Conjunctivitis = 25460000000 then 25460000000
     				when hc_obs.Cough = 25640000000 and hc_obs.Coryza = 25640000000 and hc_obs.Conjunctivitis = 25640000000 then 25640000000
     				else 25660000000
     			end		
 				when 25460000000 then 1
 			    when 25640000000 then 2
 			    else 9
 			end	 as intClinCCC, 			    			
 			case when isnumeric(hc_obs.RashDuration) = 1 and cast(hc_obs.RashDuration as varchar) not in ('.', ',', '-', '+', '$')
 				then --cast(hc_obs.RashDuration as int) 
 					 cast(cast(replace(hc_obs.RashDuration,',','.') as decimal) as int)
 				else null end as intClinRashDuration,
    			
 			case hc.idfsOutcome
 			    when 10770000000 then 1
 			    when 10760000000 then 2
 			    when 10780000000 then 3
 			    else 3
 			end as intClinOutcome, 
 			
     		case hc.idfsYNHospitalization   
   			    when 10100001 then 1
   			    when 10100002 then 2
   			    when 10100003 then 9
   			    else null
   			end as intClinHospitalization, 

 			-- AZ
 			-- If Yes, then Imported, if No, then Endemic, If Unknown or not filled, then Unknown 
 			--1 Imported
 			--2 Endemic
 			--3 Import-related
 			--9 Unknown
     		case hc_obs.SourceOfInfection 
     			-- az
 			    when 25460000000 then 1 -- Yes = Imported
 			    when 25640000000 then 2 -- No = Endemic
 			    when 25660000000 then 9 -- Unknown = Unknown
 			    else 9
 			end	 as intSrcInf, 
 			
 			
 			case hc.idfsYNRelatedToOutbreak
   			    when 10100001 then 1
   			    when 10100002 then 2
   			    when 10100003 then 9
   			    else null
   			end as intSrcOutbreakRelated, 
      
			'' as strSrcOutbreakID,
			
    		case 
     			case 
     				--AJ
     				when( hc_obs.Encephalitis = 25460000000 or 
     						hc_obs.Pneumonia =  25460000000 or 
     						hc_obs.Diarrhoea =  25460000000) 
     					and @idfsCountry = 170000000 then 25460000000
     				
     				when ( hc_obs.Encephalitis = 25640000000 and
     						hc_obs.Pneumonia =   25640000000 and 
     						(hc_obs.Diarrhoea =  25640000000 or isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella)
     					) 
     					and @idfsCountry = 170000000 then 25640000000
     				else 25660000000
     			end		
 				when 25460000000 then 1
 			    when 25640000000 then 2
 			    when 25660000000 then 9
 			    else null
 			end	 as intCompComplications, 		 					
			
			
     		case hc_obs.Encephalitis 
 			    when 25460000000 then 1 
 			    when 25640000000 then 2 
 			    when 25660000000 then 9 		
 			    else null
 			end	 as intCompEncephalitis, 				
			
     		case hc_obs.Pneumonia 
 			    when 25460000000 then 1 
 			    when 25640000000 then 2 
 			    when 25660000000 then 9 		
 			    else null
 			end	 as intCompPneumonia, 				
        
			null as intCompMalnutrition, 
			
     		case hc_obs.Diarrhoea 
 			    when 25460000000 then 1 
 			    when 25640000000 then 2 
 			    when 25660000000 then 9 		
 			    else null
 			end	 as intCompDiarrhoea, 		
 			
 			case when len(hc_obs.Other) > 0 then 1 else 2 end as intCompOther, 		
                
   			CASE 
   				WHEN hc.idfsFinalCaseStatus = 370000000 /*Not a Case - casRefused*/
   						THEN 0
   				WHEN hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/
   					AND isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles
   					AND hc.blnLabDiagBasis = 1
   						THEN 1
   				WHEN hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/
   					AND isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles
   					AND isnull(hc.blnLabDiagBasis, 0) = 0
   					AND hc.blnEpiDiagBasis = 1
   						THEN 2
   				WHEN hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/
   					AND isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles
   					AND isnull(hc.blnLabDiagBasis, 0) = 0
   					AND isnull(hc.blnEpiDiagBasis, 0) = 0
   					AND hc.blnClinicalDiagBasis = 1
   						THEN 3
   				WHEN hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/
   					AND isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella
   					AND hc.blnLabDiagBasis = 1
   						THEN 6
   				WHEN hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/
   					AND isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella
   					AND isnull(hc.blnLabDiagBasis, 0) = 0
   					AND hc.blnEpiDiagBasis = 1
   						THEN 7
   				WHEN hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/
   					AND isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella
   					AND isnull(hc.blnLabDiagBasis, 0) = 0
   					AND isnull(hc.blnEpiDiagBasis, 0) = 0
   					AND hc.blnClinicalDiagBasis = 1
   						THEN 8
   				WHEN hc.idfsFinalCaseStatus = 360000000 /*Probable Case*/
   					OR hc.idfsFinalCaseStatus = 380000000 /*Suspect*/
   						THEN NULL
   				ELSE NULL
   			END intFinalClassification,        
        
        
            case 
               when hc.idfsYNSpecimenCollected = 10100001 
					then material.datFieldCollectionDate
					else null
            end as datDSpecimen,    
            
            
			 --Dry drop of Blood=4 Dry blood spot, 
			 --Serum=1 Serum, 
			 --Saliva=2 Saliva/oral fluid, 
			 --Nasopharyngal swab=3 Nasopharyngal swab, 
			 --Urine=5 Urine, 
			 --in other case = 7 Other specimen.
			case
				isnull(case 
				   when hc.idfsYNSpecimenCollected = 10100001 
						then material.idfsSampleType
						else null
				end, -1)
				--AJ
				when 49558310000000	/*Serum*/  then 1 --Serum
				when 7721970000000	/*Saliva*/ then 2 --Saliva/oral fluid
				when 7721900000000	/*Nasopharyngal swab*/ then 3 --Nasopharyngeal swab
				when 7721620000000	/*Dry drop of Blood*/ then 4 --Dry blood spot
				when 7722180000000	/*Urine*/ then 5 --Urine				
				when -1 then null
				else 7
			end as intSpecimen,    

			case 
               when hc.idfsYNSpecimenCollected = 10100001 
					then material.datConcludedDate
					else null
            end as datDLabResult,    			            

            case
				isnull(case 
				   when hc.idfsYNSpecimenCollected = 10100001 and isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles 
						then material.idfsTestResult
						else null
				end, -1)
				--AJ
				when 7723820000000 then 4--Indeterminate
				when 7723940000000 then 2--Negative
				when 7723960000000 then 1--Positive
				when -1 then null
				else 4
			end as intMeaslesIgm,    
			
			null as intMeaslesVirusDetection,
			
			case
				isnull(case 
				   when hc.idfsYNSpecimenCollected = 10100001 and isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella 
						then material.idfsTestResult
						else null
				end, -1)
				--AJ
				when 7723820000000 then 4--Indeterminate
				when 7723940000000 then 2--Negative
				when 7723960000000 then 1--Positive
				when -1 then null
				else 4
			end as intRubellaIgm,  
			null as intRubellaVirusDetection,
			'Outbreak ID: ' + to1.strOutbreakID as strCommentsEpi
    			      			
     from tlbHumanCase hc
		inner join hc_obs
		on hc_obs.idfHumanCase = hc.idfHumanCase

		 inner join (tlbHuman h
			 inner join tlbGeoLocation gl
			 on h.idfCurrentResidenceAddress = gl.idfGeoLocation and gl.intRowStatus = 0
		     
			 inner join @AreaIDs aid
			 on aid.idfsRegion = gl.idfsRegion and 
			 (aid.idfsRayon = gl.idfsRayon or aid.idfsRayon is null)
		 )    
		 on hc.idfHuman = h.idfHuman and
			h.intRowStatus = 0
         
         left join tlbOutbreak to1
         on to1.idfOutbreak = hc.idfOutbreak
         and to1.intRowStatus = 0   
            
		 left join tstSite ts
		 on ts.idfsSite = hc.idfsSite
			and ts.intRowStatus = 0
			and ts.intFlags = 1         

		outer apply
			(select top 1 
					dbo.fnDateCutTime(tt.datConcludedDate) as datConcludedDate,
					m.idfsSampleType as idfsSampleType,
					m.datFieldCollectionDate,
					tt.idfsTestResult
                   from tlbMaterial m
						inner join tlbTesting tt
						on tt.idfMaterial = m.idfMaterial
						and tt.intRowStatus = 0
						and tt.datConcludedDate is not null
						inner join trtTestTypeForCustomReport ttcr
						on ttcr.idfsTestName = tt.idfsTestName
						and ttcr.intRowStatus = 0
						and ttcr.idfsCustomReportType = @idfsCustomReportType
                   where m.idfHuman = h.idfHuman
                   and m.intRowStatus = 0
                   order by isnull(tt.datConcludedDate, '19000101') desc, m.datFieldCollectionDate desc
               )	as material	   
 	 		
  	
 	WHERE	
 			ts.idfsSite is null and
 			isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis and
 			hc_obs.DateOfOnset >= @StartDate and
 			hc_obs.DateOfOnset <  @EndDate
 
 	) -- end of hc_table
 		
 		

   	
   	
   	insert into	@ResultTable
     (	
 		  idfCase
 		, strCaseID	
 		, intAreaID	
   		, datDRash	
   		, intGenderID
   		, datDBirth	
   		, intAgeAtRashOnset	
   		, intNumOfVaccines	
   		, datDvaccine	
   		, datDNotification	
   		, datDInvestigation	
   		, intClinFever		
   		, intClinCCC	
   		, intClinRashDuration	
   		, intClinOutcome		
   		, intClinHospitalization	
   		, intSrcInf				
   		, intSrcOutbreakRelated		
   		, strSrcOutbreakID		
   		, intCompComplications	
   		, intCompEncephalitis	
   		, intCompPneumonia		
   		, intCompMalnutrition	
   		, intCompDiarrhoea		
   		, intCompOther		
   		, intFinalClassification
   		, datDSpecimen			
   		, intSpecimen			
   		, datDLabResult			
   		, intMeaslesIgm			
   		, intMeaslesVirusDetection	
   		, intRubellaIgm				
   		, intRubellaVirusDetection
   		, strCommentsEpi			
   	)
 	select 
 		idfCase
 		, strCaseID	
 		, intAreaID	
   		, datDRash	
   		, intGenderID
   		, datDBirth	
   		, intAgeAtRashOnset	
   		, intNumOfVaccines	
   		, datDvaccine	
   		, datDNotification	
   		, datDInvestigation	
   		, intClinFever		
   		, intClinCCC	
   		, intClinRashDuration	
   		, intClinOutcome		
   		, intClinHospitalization	
   		, intSrcInf				
   		, intSrcOutbreakRelated		
   		, strSrcOutbreakID		
   		, intCompComplications	
   		, intCompEncephalitis	
   		, intCompPneumonia		
   		, intCompMalnutrition	
   		, intCompDiarrhoea		
   		, intCompOther		
   		, intFinalClassification
   		, datDSpecimen			
   		, intSpecimen			
   		, datDLabResult			
   		, intMeaslesIgm			
   		, intMeaslesVirusDetection	
   		, intRubellaIgm		
   		, intRubellaVirusDetection		
   		, strCommentsEpi	 
 	
 	
 	from hc_table
     
   
  

  		
	
	select * from @ResultTable
	order by datDRash, strCaseID	
end


