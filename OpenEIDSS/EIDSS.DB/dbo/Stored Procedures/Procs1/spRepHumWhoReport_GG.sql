
   
   --##SUMMARY Select data for Monthly Morbidity and Mortality report
   
   --##REMARKS Author: Romasheva S.
   --##REMARKS Create date: 29.10.2013
   
    
   --##RETURNS Doesn't use
   
   /*
   --Example of a call of procedure:
   

   --GG
   --Measles
   exec dbo.[spRepHumWhoReport_GG_old] @LangID=N'en',@StartDate='20130101',@EndDate='20131101', @idfsDiagnosis = 9843460000000   
   
   exec dbo.[spRepHumWhoReport_GG] @LangID=N'en',@StartDate='20140101',@EndDate='20141231', @idfsDiagnosis = 9843460000000   
   
      
   exec dbo.[spRepHumWhoReport_GG] @LangID=N'en',@StartDate='20130801',@EndDate='20130901', @idfsDiagnosis = 9843460000000   
   
   
   
   */
   
   create  Procedure [dbo].[spRepHumWhoReport_GG]
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
   	  
   		@idfsSummaryReportType						bigint,
  		
   		
   		@FFP_DateOfOnset_M				bigint,
   		@FFP_DateOfOnset_R				bigint,  	
   			
   		@FFP_NumberOfReceivedDoses_M	bigint,
   		@FFP_NumberOfReceivedDoses_R	bigint,  		
   		
   		@FFP_DateOfLastVaccination_M	bigint,
   		@FFP_DateOfLastVaccination_R	bigint,  		
   		
   		@FFP_Fever_M					bigint,
   		@FFP_Fever_R					bigint,  		
   		
   		@FFP_Cough_M					bigint,
   		@FFP_Cough_R					bigint,  	
   		
   		@FFP_Coryza_M					bigint,
   		@FFP_Coryza_R					bigint,  	  	
   		
   		@FFP_Conjunctivitis_M			bigint,
   		@FFP_Conjunctivitis_R			bigint,  	   				
   		
   		@FFP_RashDuration_M				bigint,
   		@FFP_RashDuration_R				bigint,  		
   		
   		@FFP_SourceOfInfection_M		bigint,
   		@FFP_SourceOfInfection_R		bigint,  		
   		
   		@FFP_Complications_M			bigint,
   		@FFP_Complications_R			bigint,  		

   		@FFP_Encephalitis_M				bigint,
   		@FFP_Encephalitis_R				bigint,  		
   		  		
   		@FFP_Pneumonia_M				bigint,
   		@FFP_Pneumonia_R				bigint,  		
   		  		  		
   		@FFP_Diarrhoea_M				bigint,
   		--@FFP_Diarrhoea_R				bigint,  		
   		  		  		
   		@FFP_Other_M					bigint,  		  		
   		--@FFP_Other_R					bigint,  	 
   		 		
  		@idfsDiagnosis_Measles			bigint,
   		@idfsDiagnosis_Rubella			bigint
   		
 				  	
   	SET @idfsSummaryReportType = 10290027 /*WHO Report - AJ&GG*/
   
   	--HCS FF - Rash onset date. / HCS FF- Date of onset
   	select @FFP_DateOfOnset_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_DateOfOnset_M'
   	and intRowStatus = 0
   	
   	select @FFP_DateOfOnset_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_DateOfOnset_R'
   	and intRowStatus = 0
   	  
   	--HEI - Number of received doses (any vaccine with measles component) / HEI - Number of Measles vaccine doses received
   	select @FFP_NumberOfReceivedDoses_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_NumberOfReceivedDoses_M'
   	and intRowStatus = 0
   	
   	select @FFP_NumberOfReceivedDoses_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_NumberOfReceivedDoses_R'
   	and intRowStatus = 0  	
   	
   	--HEI - Date of last vaccination/HEI - Date of last Measles vaccine
   	select @FFP_DateOfLastVaccination_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_DateOfLastVaccination_M'
   	and intRowStatus = 0	
   	
   	select @FFP_DateOfLastVaccination_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_DateOfLastVaccination_R'
   	and intRowStatus = 0	  
   		
   	--HCS - Fever/HCS - Fever
   	select @FFP_Fever_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Fever_M'
   	and intRowStatus = 0
   	
   	select @FFP_Fever_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Fever_R'
   	and intRowStatus = 0  	
   		
   	--HCS - Cough / Coryza / Conjunctivitis /HCS - Cough / Coryza / Conjunctivitis
   	select @FFP_Cough_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Cough_M'
   	and intRowStatus = 0	
   	
   	select @FFP_Cough_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Cough_R'
   	and intRowStatus = 0	 
   	
   	
   	select @FFP_Coryza_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Coryza_M'
   	and intRowStatus = 0	
   	
   	select @FFP_Coryza_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Coryza_R'
   	and intRowStatus = 0	  	
   	
   	
   	select @FFP_Conjunctivitis_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Conjunctivitis_M'
   	and intRowStatus = 0	
   	
   	select @FFP_Conjunctivitis_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Conjunctivitis_R'
   	and intRowStatus = 0	  	
   	
  	
   	--HCS - Rash duration / HCS - Duration (days)
   	select @FFP_RashDuration_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_RashDuration_M'
   	and intRowStatus = 0
   	
   	select @FFP_RashDuration_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_RashDuration_R'
   	and intRowStatus = 0  	
   		
   	--EPI - Source of infection / EPI - Source of infection
   	select @FFP_SourceOfInfection_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_SourceOfInfection_M'
   	and intRowStatus = 0		
   	
   	select @FFP_SourceOfInfection_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_SourceOfInfection_R'
   	and intRowStatus = 0	  	
   	
   	--HCS - Complications / HCS - Complications
   	select @FFP_Complications_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Complications_M'
   	and intRowStatus = 0		
   	
   	select @FFP_Complications_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Complications_R'
   	and intRowStatus = 0		  
   	
   	--HCS - Encephalitis / HCS - Encephalitis
   	select @FFP_Encephalitis_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Encephalitis_M'
   	and intRowStatus = 0		
   	
   	select @FFP_Encephalitis_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Encephalitis_R'
   	and intRowStatus = 0	  	
   	
   	--HCS - Pneumonia / HCS - Pneumonia
   	select @FFP_Pneumonia_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Pneumonia_M'
   	and intRowStatus = 0	
   	
   	select @FFP_Pneumonia_R = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Pneumonia_R'
   	and intRowStatus = 0	  	
   		
   	--HCS - Diarrhoea / HCS - Diarrhoea
   	select @FFP_Diarrhoea_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Diarrhoea_M'
   	and intRowStatus = 0		
   	
   	--select @FFP_Diarrhoea_R = idfsFFObject from trtFFObjectForCustomReport
   	--where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Diarrhoea_R'
   	--and intRowStatus = 0		  	
   	
   	--HCS - Other (specify) / HCS - Other
   	select @FFP_Other_M = idfsFFObject from trtFFObjectForCustomReport
   	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Other_M'
   	and intRowStatus = 0	 
   	
   	--select @FFP_Other_R = idfsFFObject from trtFFObjectForCustomReport
   	--where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Other_R'
   	--and intRowStatus = 0	   	
   	
   	 	
   	--idfsDiagnosis for:
   	--Measles
   	select top 1 @idfsDiagnosis_Measles = d.idfsDiagnosis
   	from trtDiagnosis d
   	  inner join dbo.trtDiagnosisToGroupForReportType dgrt
   	  on dgrt.idfsDiagnosis = d.idfsDiagnosis
   	  and dgrt.idfsCustomReportType = @idfsSummaryReportType
   	  
   	  inner join dbo.trtReportDiagnosisGroup dg
   	  on dgrt.idfsReportDiagnosisGroup = dg.idfsReportDiagnosisGroup
   	  and dg.intRowStatus = 0 and dg.strDiagnosisGroupAlias = 'DG_Measles'
     where d.intRowStatus = 0
   	
   	--Rubella
   	select top 1 @idfsDiagnosis_Rubella = d.idfsDiagnosis
   	from trtDiagnosis d
   	  inner join dbo.trtDiagnosisToGroupForReportType dgrt
   	  on dgrt.idfsDiagnosis = d.idfsDiagnosis
   	  and dgrt.idfsCustomReportType = @idfsSummaryReportType
   	  
   	  inner join dbo.trtReportDiagnosisGroup dg
   	  on dgrt.idfsReportDiagnosisGroup = dg.idfsReportDiagnosisGroup
   	  and dg.intRowStatus = 0 and dg.strDiagnosisGroupAlias = 'DG_Rubella'
     where d.intRowStatus = 0	
   	



   	
     declare @AreaIDs table
     (
     intAreaID int,
     idfsRegion bigint
     )
   
    insert into @AreaIDs (intAreaID, idfsRegion)
	select		
	cast(tgra.varValue as int), gr.idfsRegion
	from trtGISBaseReferenceAttribute tgra
		inner join trtAttributeType tat
		on tat.idfAttributeType = tgra.idfAttributeType
		and tat.strAttributeTypeName = 'WHOrep_specific_gis_region'

		inner join gisRegion gr
		on gr.idfsRegion = tgra.idfsGISBaseReference
 	    
  	
   	;with hc_obs
   	as (
   	select 
   		ct.idfHumanCase,
   		isnull(case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and 
 				(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_M.varValue, 'BaseType') as nvarchar) like N'%date%' or
					(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_M.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_DateOfOnset_M.varValue as nvarchar)) = 1 )	)  
 				then dbo.fnDateCutTime(cast(ap_DateOfOnset_M.varValue as datetime))
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and 
 				(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_R.varValue, 'BaseType') as nvarchar) like N'%date%' or
					(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_R.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_DateOfOnset_R.varValue as nvarchar)) = 1 )	)  
 				then dbo.fnDateCutTime(cast(ap_DateOfOnset_R.varValue as datetime))
 			else null
   		end, isnull(hc.datOnSetDate, isnull(hc.datFinalDiagnosisDate, isnull(hc.datTentativeDiagnosisDate, isnull(hc.datNotificationDate, ct.datEnteredDate))))) as DateOfOnset,
   		
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
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and 
 				SQL_VARIANT_PROPERTY(ap_Fever_R.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Fever_R.varValue as bigint)
 			else null
   		end as Fever,
   		
   		case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and 
 				SQL_VARIANT_PROPERTY(ap_Cough_M.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Cough_M.varValue as bigint)
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and 
 				SQL_VARIANT_PROPERTY(ap_Cough_R.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Cough_R.varValue as bigint)
 			else null
   		end as Cough,
  		
   		case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and 
 				SQL_VARIANT_PROPERTY(ap_Coryza_M.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Coryza_M.varValue as bigint)
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and 
 				SQL_VARIANT_PROPERTY(ap_Coryza_R.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Coryza_R.varValue as bigint)
 			else null
   		end as Coryza,  		
 
   		case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and 
 				SQL_VARIANT_PROPERTY(ap_Conjunctivitis_M.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Conjunctivitis_M.varValue as bigint)
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and 
 				SQL_VARIANT_PROPERTY(ap_Conjunctivitis_R.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Conjunctivitis_R.varValue as bigint)
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
 				SQL_VARIANT_PROPERTY(ap_Complications_M.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Complications_M.varValue as bigint)
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and 
 				SQL_VARIANT_PROPERTY(ap_Complications_R.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 				then cast(ap_Complications_R.varValue as bigint)
 			else null
   		end as Complications,    
   		
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
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella 
 				then null
 			--when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and 
 			--	SQL_VARIANT_PROPERTY(ap_Diarrhoea_R.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
 			--	then cast(ap_Diarrhoea_R.varValue as bigint)
 			else null
   		end as Diarrhoea,    
   		
   		case
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles 
 				then cast(ap_Other_M.varValue as nvarchar(500))
 			when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella 
 				then null
 					
 			--when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella 
 			--	then cast(ap_Other_R.varValue as nvarchar(500))
 			else null
   		end as Other	  		  		  		  			
 
     from tlbHumanCase ct
 		inner join tlbHumanCase hc
 		on ct.idfHumanCase = hc.idfHumanCase  and ct.intRowStatus = 0 
 
 		inner join tlbHuman h
 		on hc.idfHuman = h.idfHuman and  h.intRowStatus = 0
 		   
  
		left join tlbObservation ob_CS 
			on	ob_CS.idfObservation = hc.idfCSObservation
 			and ob_CS.intRowStatus = 0
 			
		left join tlbObservation ob_EPI 
			on	ob_EPI.idfObservation = hc.idfEpiObservation
 			and ob_EPI.intRowStatus = 0 			
  
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
   			
  		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Fever_M
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Fever_M 	
 		
 
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Fever_R
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Fever_R 			  			
   			
		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Cough_M
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Cough_M 	
 		
  		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Cough_R
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Cough_R 	
   		
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Coryza_M
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Coryza_M
 
   		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Coryza_R	
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Coryza_R
   		
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Conjunctivitis_M	
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Conjunctivitis_M
 
		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Conjunctivitis_R	
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Conjunctivitis_R
 
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
 		
		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Complications_M			
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Complications_M
 		
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Complications_R				
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Complications_R
 		
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
 		
 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Diarrhoea_M						
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Diarrhoea_M
 
  		  		
		--outer apply ( 
 	--		select top 1 
 	--			ap.varValue
 	--		from tlbActivityParameters ap
 	--		where	ap.idfObservation = ob_CS.idfObservation
 	--			and	ap.idfsParameter = @FFP_Diarrhoea_R							
 	--			and ap.intRowStatus = 0
 	--		order by ap.idfRow asc	
 	--	) as  ap_Diarrhoea_R
 

 		outer apply ( 
 			select top 1 
 				ap.varValue
 			from tlbActivityParameters ap
 			where	ap.idfObservation = ob_CS.idfObservation
 				and	ap.idfsParameter = @FFP_Other_M							
 				and ap.intRowStatus = 0
 			order by ap.idfRow asc	
 		) as  ap_Other_M
 

 		--outer apply ( 
 		--	select top 1 
 		--		ap.varValue
 		--	from tlbActivityParameters ap
 		--	where	ap.idfObservation = ob_CS.idfObservation
 		--		and	ap.idfsParameter = @FFP_Other_R								
 		--		and ap.intRowStatus = 0
 		--	order by ap.idfRow asc	
 		--) as  ap_Other_R
 		
   	where 	
 		isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis 
 		and
		isnull	(	case
						when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and 
							(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_M.varValue, 'BaseType') as nvarchar) like N'%date%' or
								(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_M.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_DateOfOnset_M.varValue as nvarchar)) = 1 )	)  
							then dbo.fnDateCutTime(cast(ap_DateOfOnset_M.varValue as datetime))
						when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and 
							(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_R.varValue, 'BaseType') as nvarchar) like N'%date%' or
								(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_R.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_DateOfOnset_R.varValue as nvarchar)) = 1 )	)  
							then dbo.fnDateCutTime(cast(ap_DateOfOnset_R.varValue as datetime))
						else null
					end, isnull(hc.datOnSetDate, isnull(hc.datFinalDiagnosisDate, isnull(hc.datTentativeDiagnosisDate, isnull(hc.datNotificationDate, ct.datEnteredDate))))
				) >= @StartDate
		
		and
		
		isnull	(	case
						when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and 
							(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_M.varValue, 'BaseType') as nvarchar) like N'%date%' or
								(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_M.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_DateOfOnset_M.varValue as nvarchar)) = 1 )	)  
							then dbo.fnDateCutTime(cast(ap_DateOfOnset_M.varValue as datetime))
						when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and 
							(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_R.varValue, 'BaseType') as nvarchar) like N'%date%' or
								(cast(SQL_VARIANT_PROPERTY(ap_DateOfOnset_R.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_DateOfOnset_R.varValue as nvarchar)) = 1 )	)  
							then dbo.fnDateCutTime(cast(ap_DateOfOnset_R.varValue as datetime))
						else null
					end, isnull(hc.datOnSetDate, isnull(hc.datFinalDiagnosisDate, isnull(hc.datTentativeDiagnosisDate, isnull(hc.datNotificationDate, ct.datEnteredDate))))
				) < @EndDate   			
	
 
  	), -- end of hc_obs
 	
 	hc_table
 	as 
 	(
 		select distinct
 			ct.idfHumanCase,
 			'GEO' + ct.strCaseID as strCaseID,
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
 			
 			isnull(case when isnumeric(hc_obs.NumberOfReceivedDoses) = 1  and cast(hc_obs.NumberOfReceivedDoses as varchar) not in ('.', ',', '-', '+', '$')
 						then	
							case  cast(hc_obs.NumberOfReceivedDoses as bigint)
								when 9878670000000 then 0
								when 9878680000000 then 1
								when 9878690000000 then 2
								when 9878700000000 then 3
								else 9
							end	
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
 			case when isnumeric(hc_obs.RashDuration) = 1  and cast(hc_obs.RashDuration as varchar) not in ('.', ',', '-', '+', '$')
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
 
 			
 			-- GG - FF parameter = 'Source of infection' -- idfsParameter = 9951440000000
 			--9879590000000	Imported
 			--9879600000000	Import-related
 			--9879610000000	Indigenous
 			--9879620000000	Unknown
 			--Indigenous=Endemic, Imported=Imported, Import-related=Import-related, Unknown = Unknown, Blank = Blank

      		case hc_obs.SourceOfInfection 
 			    --GG
 			    when 9879590000000 then 1 --Imported = Imported
 			    when 9879610000000 then 2 --Indigenous = Endemic
 			    when 9879600000000 then 3 -- Import-related=Import-related
 			    when 9879620000000 then 9 --  Unknown = Unknown
 			    else null --Blank = Blank
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
     				-- GG
     				when hc_obs.Complications = 25460000000 and isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles then 25460000000
     				when hc_obs.Complications = 25640000000 and isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles then 25640000000
     				when hc_obs.Complications = 25660000000 and isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles then 25660000000
     				else 25660000000
     			end		
 				when 25460000000 then 1
 			    when 25640000000 then 2
 			    when 25660000000 then 9
 			    else null
 			end	 as intCompComplications, 		 					
			
			case when hc_obs.Complications = 25460000000 /*Yes*/ and isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles 
				then
     				case hc_obs.Encephalitis 
 						when 25460000000 then 1 
 						when 25640000000 then 2 
 						when 25660000000 then 9 		
 						else null
 					end	 
 				else null
 			end as intCompEncephalitis, 				
			
			case when hc_obs.Complications = 25460000000 /*Yes*/ and isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles 
				then
     				case hc_obs.Pneumonia 
 						when 25460000000 then 1 
 						when 25640000000 then 2 
 						when 25660000000 then 9 		
 						else null
 					end		 
 				else null
 			end as intCompPneumonia, 				
        
			null as intCompMalnutrition, 
			
     		case when hc_obs.Complications = 25460000000 /*Yes*/ and isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles 
				then
     				case hc_obs.Diarrhoea 
 						when 25460000000 then 1 
 						when 25640000000 then 2 
 						when 25660000000 then 9 		
 						else null
 					end		 
 				else null
 			end as intCompDiarrhoea, 		
 			
 			case when hc_obs.Complications = 25460000000 /*Yes*/ and isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles 
				then
					case when len(hc_obs.Other) > 0 then 1 else 2 end 
				else null
			end as intCompOther, 		
                
   			CASE 
   				WHEN hc.idfsFinalCaseStatus = 370000000  --Not a Case
   						THEN 0
   				WHEN hc.idfsFinalCaseStatus = 350000000 --Confirmed
   					AND isnull(ct.idfsFinalDiagnosis, ct.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles
   					AND hc.blnLabDiagBasis = 1
   						THEN 1
   				WHEN hc.idfsFinalCaseStatus = 350000000  --Confirmed
   					AND isnull(ct.idfsFinalDiagnosis, ct.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles
   					AND isnull(hc.blnLabDiagBasis, 0) = 0
   					AND hc.blnEpiDiagBasis = 1
   						THEN 2
   				WHEN hc.idfsFinalCaseStatus = 360000000 --Probable
   					AND isnull(ct.idfsFinalDiagnosis, ct.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles
   					AND (hc.blnLabDiagBasis = 1 or hc.blnEpiDiagBasis = 1 or hc.blnClinicalDiagBasis = 1)
   						THEN 3
   				WHEN hc.idfsFinalCaseStatus = 350000000 
   					AND isnull(ct.idfsFinalDiagnosis, ct.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella
   					AND hc.blnLabDiagBasis = 1
   						THEN 6
   				WHEN hc.idfsFinalCaseStatus = 350000000 
   					AND isnull(ct.idfsFinalDiagnosis, ct.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella
   					AND isnull(hc.blnLabDiagBasis, 0) = 0
   					AND hc.blnEpiDiagBasis = 1
   						THEN 7
   				WHEN hc.idfsFinalCaseStatus = 360000000 --Probable
   					AND isnull(ct.idfsFinalDiagnosis, ct.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella
   					AND  (hc.blnLabDiagBasis = 1 or hc.blnEpiDiagBasis = 1 or hc.blnClinicalDiagBasis = 1)
   						THEN 8
   				WHEN hc.idfsFinalCaseStatus = 380000000
   					OR hc.idfsFinalCaseStatus = 12137920000000
   					or hc.idfsFinalCaseStatus is null
   					or (hc.blnLabDiagBasis is null and hc.blnEpiDiagBasis is null and hc.blnClinicalDiagBasis is null)
   						THEN NULL
   				ELSE NULL
   			END intFinalClassification,        
        
        
            case 
               when hc.idfsYNSpecimenCollected = 10100001 then material.datFieldCollectionDate
               else null
            end as datDSpecimen,    
            
            
			--Type of sample associated with the test which result is shown in #29/31. 
			--If #29/31 is blank then the sample with the latest date of sample collection should be taken. 
			--Blood = 1 Serum, 
			--Blood - serum=1 Serum, 
			--Saliva=2 Saliva/oral fluid, 
			--Swab - Rhinopharyngeal = 3 Nasopharyngeal swab, 
			--Urine=5 Urine, 
			--Blood - anticoagulated whole blood= 6 EDTA whole blood, 
			--in other case = 7 Other specimen. 
			--Which sample to send, it shall be defined by tests (see 29/31) NB: Parent Sample Type should be tranferred to CISID in case Sample Derivative was created.
			case
				isnull(case 
				   when hc.idfsYNSpecimenCollected = 10100001 then material.idfsSampleType
				   else null
				end, -1)
				--GG
				when 9844440000000 /*Blood*/ then 1 --Serum
				when 9844480000000/*Blood - serum*/  then 1 --Serum
				when 9845550000000	/*Saliva*/ then 2 --Saliva/oral fluid
				when 9845840000000	/*Swab - Rhinopharyngeal*/ then 3 --Nasopharyngeal swab
				when 9846060000000	/*Urine*/ then 5 --Urine
				when 9844450000000 /*Blood - anticoagulated whole blood*/ then 6 --EDTA whole blood
				when -1 then null
				else 7
			end as intSpecimen,    

			case 
               when hc.idfsYNSpecimenCollected = 10100001 then material.datConcludedDate
               else null
            end as datDLabResult,    			            
           
			

			--Test Name: ELISA IgM, Antibody detection
			--The Result of the lastest "ELISA IgM, Antibody detection" 
			--Test Name shall be taken (by Result Date). 
			--1 Positive = Positive AND Test Status = Final or Amended, 
			--2 Negative= Negative AND Test Status = Final or Amended, 
			--4 Inclonclusive = Cut off AND Test Status = Final or Amended, 
			--0 Not Tested = if sample data is filled in #26/27 but no test data available, 
			--3 In Process = any test result (including blank) for assigned test AND Test Status = In Process or Preliminary      
			case
				isnull(
						case 
						   when hc.idfsYNSpecimenCollected = 10100001 and isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and material.idfsTestStatus in (10001001, 10001006) --Final or Amended
								then material.idfsTestResult
						   when hc.idfsYNSpecimenCollected = 10100001 and isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and material.idfsTestStatus in( 10001003, 10001004)	--In Process or Preliminary   
								then 3
						   when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Measles and material.idfTesting is null and material.idfsSampleType is not null
								then 0
						   else null
						end, -1)
				--GG
				when 9848880000000 then 4--Indeterminate
				when 9848980000000 then 2--Negative
				when 9849050000000 then 1--Positive
				when 3			   then 3--In Process
				when 0			   then 0--Tested
				when -1 then null
				else null
			end as intMeaslesIgm,    
			
			null as intMeaslesVirusDetection,
			
			case
				isnull(
					case 
						   when hc.idfsYNSpecimenCollected = 10100001 and isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and material.idfsTestStatus  in (10001001, 10001006) --Final or Amended
								then material.idfsTestResult
						   when hc.idfsYNSpecimenCollected = 10100001 and isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and material.idfsTestStatus in( 10001003, 10001004)	--In Process or Preliminary   
								then 3
						   when isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @idfsDiagnosis_Rubella and material.idfTesting is null	 and material.idfsSampleType is not null
								then 0
						   else null
				end, -1)
				when 9848880000000 then 4--Indeterminate
				when 9848980000000 then 2--Negative
				when 9849050000000 then 1--Positive
				when 3			   then 3--In Process
				when 0			   then 0--Tested
				when -1 then null
				else null
			end as intRubellaIgm,  
			null as intRubellaVirusDetection,
			'Outbreak ID: ' + to1.strOutbreakID as strCommentsEpi
          
   		
   		

     			      			
     from tlbHumanCase ct
		inner join hc_obs
		on hc_obs.idfHumanCase = ct.idfHumanCase

		 inner join tlbHumanCase hc
		 on ct.idfHumanCase = hc.idfHumanCase  and ct.intRowStatus = 0 

		 inner join (tlbHuman h
			 inner join tlbGeoLocation gl
			 on h.idfCurrentResidenceAddress = gl.idfGeoLocation and gl.intRowStatus = 0
		     
			 inner join @AreaIDs aid
			 on aid.idfsRegion = gl.idfsRegion 
		 )    
		 on hc.idfHuman = h.idfHuman and
			h.intRowStatus = 0
         
         left join tlbOutbreak to1
         on to1.idfOutbreak = ct.idfOutbreak
         and to1.intRowStatus = 0   
            
		outer apply
			(select top 1 
					dbo.fnDateCutTime(tt.datConcludedDate) as datConcludedDate,
					isnull(rm.idfsSampleType, m.idfsSampleType) as idfsSampleType,
					m.datFieldCollectionDate,
					tt.idfsTestResult,
					tt.idfsTestStatus,
					tt.idfTesting
                   from tlbMaterial m
						left join (tlbTesting tt
							inner join trtTestTypeForCustomReport ttcr
							on ttcr.idfsTestName = tt.idfsTestName
							and ttcr.intRowStatus = 0
							and ttcr.idfsCustomReportType = @idfsSummaryReportType
						)
						on tt.idfMaterial = m.idfMaterial
						and tt.intRowStatus = 0
						and tt.datConcludedDate is not null
						
						left join tlbMaterial rm
						on rm.idfMaterial = m.idfParentMaterial
						and rm.intRowStatus = 0						
						
                   where m.idfHuman = h.idfHuman
                   and m.intRowStatus = 0
                   order by isnull(tt.datConcludedDate, '19000101') desc, m.datFieldCollectionDate desc
               )	as material	   
 	 		
 		where hc.intRowStatus = 0
 
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
 		idfHumanCase
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


