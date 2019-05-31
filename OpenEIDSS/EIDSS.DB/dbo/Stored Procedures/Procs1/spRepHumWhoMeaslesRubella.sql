

--##SUMMARY Select data for WHO measles rubella

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 23.12.2009
 
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 23.04.2013
 
--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepHumWhoMeaslesRubella @LangID=N'en',@Year=2014,@Month=3, @idfsDiagnosis=7720040000000--Measles

exec dbo.spRepHumWhoMeaslesRubella @LangID=N'en',@Year=2014,@Month=2, @idfsDiagnosis=7720770000000--Rubella

--Rubella
exec dbo.spRepHumWhoMeaslesRubella @LangID=N'en',@Year=2014, @Month=null, @idfsDiagnosis=7720770000000--Rubella
*/

create  Procedure [dbo].[spRepHumWhoMeaslesRubella]
	 (
		 @LangID		As nvarchar(50), 
		 @Year			as int, 
		 @Month			as int = null,
		 @idfsDiagnosis	as bigint = null
	 )
AS	

	
begin
	
	declare	@ResultTable	table
	(	  
		  idfsBaseReference		bigint not null primary key
		, strCaseID				nvarchar(300) collate database_default not null 
		, intInitialDiagnosis	int not null 
		, intAreaID				int not null 
		, datDateOfRashOnset	date null
		, intSex				int not null 
		, datDateOfBirth		date null
		, intNomberOfVaccines	int not null 
		, datDateOfLastVaccination		date null
		, datNotificationDate			date null
		, datInvestigationStartDate		date null
		, intOutcome			int not null 
		, intHospitalization	int not null 
		, intImportedCase		int not null 
		, datSpecimenCollection	date null
		, intTestResult			int not null 
		, intFinalCaseClassification	int NULL 
--		, intOrder				int
	)
	
	declare 
	  
	@idfsCustomReportType bigint,
	
	@FFP_MeaslesOnSetDate bigint,
	@FFP_RubellaOnSetDate bigint,
	@FFP_MeaslesNumberOfVaccine bigint,
	@FFP_RubellaNumberOfVaccine bigint,
	@FFP_MeaslesDateOfLastVaccine bigint,
	@FFP_RubellaDateOfLastVaccine bigint,
	@FFP_MeaslesSourceOfInfectionImportedCase bigint,
	@FFP_RubellaSourceOfInfectionImportedCase bigint,
	
	@idfsDiagnosis_Measles bigint,
	@idfsDiagnosis_Rubella bigint,
	
	@StartDate datetime,
	@EndDate datetime,
	@m nvarchar(10)
	
	if @Month is null 
	begin
		set @StartDate = cast(cast(@Year as nvarchar) + '0101' as datetime)
		set @EndDate = cast(cast(@Year+1 as nvarchar) + '0101' as datetime)
	end
	else begin
		if @Month < 10 
			set @m = '0' + cast(@Month as nvarchar(2))
			else set @m = cast(@Month as nvarchar(2))
		set @StartDate = cast(cast(@Year as nvarchar) + cast(@m as nvarchar) + '01' as datetime)
		
		if @Month = 12 
			begin  set @Month = 1  set @Year = @Year+1 end 
			else 	set @Month = @Month +1
		if @Month < 10 
			set @m = '0' + cast(@Month as nvarchar(2)) 
			else set @m = cast(@Month as nvarchar(2))
		set @EndDate = cast(cast(@Year as nvarchar) + cast(@m as nvarchar) + '01' as datetime)
	end

	print @StartDate
	print @EndDate
	SET @idfsCustomReportType = 10290020 /*AJ WHO Report on Measles and Rubella*/

  --Measles-Additional information on rash-Date of onset
	select @FFP_MeaslesOnSetDate = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_MeaslesOnSetDate'
	and intRowStatus = 0

  --Rubella-Additional information on rash-Date of onset
	select @FFP_RubellaOnSetDate = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_RubellaOnSetDate'
	and intRowStatus = 0
	
	--Measles-Vaccination status-Number of Measles vaccine doses received
    select @FFP_MeaslesNumberOfVaccine = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_MeaslesNumberOfVaccine'
	and intRowStatus = 0	
	
	--Rubella-Vaccination status-Number of Rubella vaccine doses received
	select @FFP_RubellaNumberOfVaccine = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_RubellaNumberOfVaccine'
	and intRowStatus = 0
	
	
	--Measles-Vaccination status-Date of last Measles vaccine
    select @FFP_MeaslesDateOfLastVaccine = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_MeaslesDateOfLastVaccine'
	and intRowStatus = 0		
	
	--Rubella-Vaccination status-Date of last Rubella vaccine
	select @FFP_RubellaDateOfLastVaccine = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_RubellaDateOfLastVaccine'
	and intRowStatus = 0
	
	
	--Measles-Source of infection-Imported case
	select @FFP_MeaslesSourceOfInfectionImportedCase = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_MeaslesSourceOfInfectionImportedCase'
	and intRowStatus = 0		
	
	--Rubella-Source of infection-Imported case
	select @FFP_RubellaSourceOfInfectionImportedCase = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_RubellaSourceOfInfectionImportedCase'
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
	
	print @idfsDiagnosis_Measles
	print @idfsDiagnosis_Rubella

	
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
	and tat.strAttributeTypeName = 'MRrep_specific_gis_rayon'
  
	inner join gisRayon gr
	on gr.idfsRayon = tgra.idfsGISBaseReference
 

 
 
	
  insert into	@ResultTable
  (	
	    idfsBaseReference
		, strCaseID	
		, intInitialDiagnosis
		, intAreaID
		, datDateOfRashOnset
		, intSex
		, datDateOfBirth
		, intNomberOfVaccines
		, datDateOfLastVaccination
		, datNotificationDate
		, datInvestigationStartDate
		, intOutcome
		, intHospitalization
		, intImportedCase
		, datSpecimenCollection
		, intTestResult
		, intFinalCaseClassification
--		, intOrder
  )
  select distinct
			  hc.idfHumanCase AS idfCase,
			  hc.strCaseID,
			  case
				  when hc.idfsTentativeDiagnosis = @idfsDiagnosis_Measles
					  then	1 
					when hc.idfsTentativeDiagnosis = @idfsDiagnosis_Rubella
					  then	2
  			  else	0
			  end, --intInitialDiagnois
			  aid.intAreaID, 
			  case when hc.idfsTentativeDiagnosis = @idfsDiagnosis_Measles and 
			            (cast(SQL_VARIANT_PROPERTY(ap_m.varValue, 'BaseType') as nvarchar) like N'%date%'   or
						(cast(SQL_VARIANT_PROPERTY(ap_m.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_m.varValue as nvarchar)) = 1 ))
			            then dbo.fnDateCutTime(cast(ap_m.varValue as datetime))
			       when hc.idfsTentativeDiagnosis = @idfsDiagnosis_Rubella and 
			            (cast(SQL_VARIANT_PROPERTY(ap_r.varValue, 'BaseType') as nvarchar) like N'%date%'   or
						(cast(SQL_VARIANT_PROPERTY(ap_r.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_r.varValue as nvarchar)) = 1 ))
			            then dbo.fnDateCutTime(cast(ap_r.varValue as datetime))
			  else null
  			end, --datDateOfRashOnset
  			
  			case 
  			  when h.idfsHumanGender = 10043001 then 2
  			  when h.idfsHumanGender = 10043002 then 1
  			  else 4
  			end, --  intSex
  			
  			dbo.fnDateCutTime(h.datDateofBirth), --datDateOfBirth
  			
  			case when hc.idfsTentativeDiagnosis = @idfsDiagnosis_Measles and 
			            SQL_VARIANT_PROPERTY(ap_m1.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			            then cast(ap_m1.varValue as bigint)
			       when hc.idfsTentativeDiagnosis = @idfsDiagnosis_Rubella and 
			            SQL_VARIANT_PROPERTY(ap_r1.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			            then cast(ap_r1.varValue as bigint)
			  else 9
  			END, --intNomberOfVaccines
  		  case when hc.idfsTentativeDiagnosis = @idfsDiagnosis_Measles and 
			            (cast(SQL_VARIANT_PROPERTY(ap_m2.varValue, 'BaseType') as nvarchar) like N'%date%'   or
						(cast(SQL_VARIANT_PROPERTY(ap_m2.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_m2.varValue as nvarchar)) = 1 ))
			            then dbo.fnDateCutTime(cast(ap_m2.varValue as datetime))
			       when hc.idfsTentativeDiagnosis = @idfsDiagnosis_Rubella and 
			            (cast(SQL_VARIANT_PROPERTY(ap_r2.varValue, 'BaseType') as nvarchar) like N'%date%'   or
						(cast(SQL_VARIANT_PROPERTY(ap_r2.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_r2.varValue as nvarchar)) = 1 ))
			            then dbo.fnDateCutTime(cast(ap_r2.varValue as datetime))
			  else null
  			end, --datDateOfLastVaccination
  			
  			dbo.fnDateCutTime(hc.datNotificationDate), --datNotificationDate
  			
  			dbo.fnDateCutTime(hc.datInvestigationStartDate), --datInvestigationStartDate
  			
  			case hc.idfsOutcome
  			    when 10770000000 then 1
  			    when 10760000000 then 2
  			    when 10780000000 then 3
  			    else 3
  			end, --   intOutcome 
  			 
  			case hc.idfsYNHospitalization   
  			    when 10100001 then 1
  			    when 10100002 then 2
  			    when 10100003 then 9
  			    else 9
  			end, -- intHospitalization  
  			
  			case  
  			    case when hc.idfsTentativeDiagnosis = @idfsDiagnosis_Measles and 
			                SQL_VARIANT_PROPERTY(ap_m3.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			                then cast(ap_m3.varValue as bigint)
			           when hc.idfsTentativeDiagnosis = @idfsDiagnosis_Rubella and 
			                SQL_VARIANT_PROPERTY(ap_r3.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			                then cast(ap_r3.varValue as bigint)
			           else null
  			    end
  			    when 25460000000 then 1
  			    when 25640000000 then 2
  			    when 25660000000 then 9
  			    else 9 
  			 end,   --intImportedCase
  			 
         case 
            when hc.idfsYNSpecimenCollected = 10100001 then
            (select top 1 dbo.fnDateCutTime(m.datFieldCollectionDate)
                from tlbMaterial m
                where m.idfsSampleType = 7721770000000
                and m.idfHuman = h.idfHuman
                and m.intRowStatus = 0
                order by m.datFieldCollectionDate desc
            )
            else null
         end , --datSpecimenCollection
      
     

        CASE
			(
				SELECT
					CASE 
						WHEN hc.idfsYNSpecimenCollected = 10100001 AND PositiveResult > 0 THEN 'PositiveResult'
						WHEN hc.idfsYNSpecimenCollected = 10100001 AND NegativeResult > 0 THEN 'NegativeResult'
						WHEN hc.idfsYNSpecimenCollected = 10100001 AND IndeterminateResult > 0 THEN 'IndeterminateResult'
						WHEN hc.idfsYNSpecimenCollected = 10100001 AND NotSpecifiedResult > 0 THEN 'NotSpecifiedResult'
						WHEN CntResult = 0 THEN 'NoRecord'
					END
				FROM (
					SELECT
						SUM(CASE WHEN tt.idfsTestResult = 7723960000000 THEN 1 ELSE 0 END) PositiveResult
						, SUM(CASE WHEN tt.idfsTestResult = 7723940000000 THEN 1 ELSE 0 END) NegativeResult	
						, SUM(CASE WHEN tt.idfsTestResult = 7723820000000 THEN 1 ELSE 0 END) IndeterminateResult
						, SUM(CASE WHEN ISNULL(tt.idfsTestResult, -1) = -1 THEN 1 ELSE 0 END) NotSpecifiedResult
						, COUNT(*) CntResult
					FROM tlbTesting tt
					WHERE tt.idfMaterial = 
						(
							SELECT TOP 1 
								m.idfMaterial
							FROM tlbMaterial m
							WHERE m.idfsSampleType = 7721770000000
								AND m.idfHuman = 1680000871
								AND m.intRowStatus = 0
							ORDER BY m.datFieldCollectionDate DESC 
						)
				)  x
			)
			WHEN 'PositiveResult' THEN 1
			WHEN 'NegativeResult' THEN 2
			WHEN 'IndeterminateResult' THEN 4
			WHEN 'NotSpecifiedResult' THEN 3
			WHEN 'NoRecord' THEN 0
			ELSE 4
		END	AS intTestResult,
		
		
		CASE 
			WHEN hc.idfsFinalCaseStatus = 370000000 
					THEN 0
			WHEN hc.idfsFinalCaseStatus = 350000000 
				AND hc.idfsTentativeDiagnosis = @idfsDiagnosis_Measles
				AND hc.blnLabDiagBasis = 1
					THEN 1
			WHEN hc.idfsFinalCaseStatus = 350000000 
				AND hc.idfsTentativeDiagnosis = @idfsDiagnosis_Measles
				AND hc.blnLabDiagBasis = 0
				AND hc.blnEpiDiagBasis = 1
					THEN 2
			WHEN hc.idfsFinalCaseStatus = 350000000 
				AND hc.idfsTentativeDiagnosis = @idfsDiagnosis_Measles
				AND hc.blnLabDiagBasis = 0
				AND hc.blnEpiDiagBasis = 0
				AND hc.blnClinicalDiagBasis = 1
					THEN 3
			WHEN hc.idfsFinalCaseStatus = 350000000 
				AND hc.idfsTentativeDiagnosis = @idfsDiagnosis_Rubella
				AND hc.blnLabDiagBasis = 1
					THEN 6
			WHEN hc.idfsFinalCaseStatus = 350000000 
				AND hc.idfsTentativeDiagnosis = @idfsDiagnosis_Rubella
				AND hc.blnLabDiagBasis = 0
				AND hc.blnEpiDiagBasis = 1
					THEN 7
			WHEN hc.idfsFinalCaseStatus = 350000000 
				AND hc.idfsTentativeDiagnosis = @idfsDiagnosis_Rubella
				AND hc.blnLabDiagBasis = 0
				AND hc.blnEpiDiagBasis = 0
				AND hc.blnClinicalDiagBasis = 1
					THEN 8
			WHEN hc.idfsFinalCaseStatus = 360000000
				OR hc.idfsFinalCaseStatus = 380000000
					THEN NULL
			ELSE NULL
		END intFinalCaseClassification
  			      			
  from tlbHumanCase hc

      inner join tlbHuman h
          left outer join tlbGeoLocation gl
          on h.idfCurrentResidenceAddress = gl.idfGeoLocation and gl.intRowStatus = 0
          
          left join @AreaIDs aid
          on aid.idfsRegion = gl.idfsRegion and 
          aid.idfsRayon = gl.idfsRayon
          
      on hc.idfHuman = h.idfHuman and
         h.intRowStatus = 0
        
	  left join tstSite ts
	  on ts.idfsSite = hc.idfsSite
		and ts.intRowStatus = 0
		and ts.intFlags = 1         
        
      left join tlbObservation ob_m  
          inner join  tlbActivityParameters ap_m
          on ap_m.idfObservation = ob_m.idfObservation
          and ap_m.intRowStatus = 0
          and ap_m.idfsParameter = @FFP_MeaslesOnSetDate
      on ob_m.idfObservation = hc.idfCSObservation
      and ob_m.intRowStatus = 0
      
      left join tlbObservation ob_r  
          inner join  tlbActivityParameters ap_r
          on ap_r.idfObservation = ob_r.idfObservation
          and ap_r.intRowStatus = 0
          and ap_r.idfsParameter = @FFP_RubellaOnSetDate
      on ob_r.idfObservation = hc.idfCSObservation
      and ob_r.intRowStatus = 0      
  			
  			
      left join tlbObservation ob_m1  
          inner join  tlbActivityParameters ap_m1
          on ap_m1.idfObservation = ob_m1.idfObservation
          and ap_m1.intRowStatus = 0
          and ap_m1.idfsParameter = @FFP_MeaslesNumberOfVaccine
      on ob_m1.idfObservation = hc.idfEpiObservation
      and ob_m1.intRowStatus = 0
      
      left join tlbObservation ob_r1
          inner join  tlbActivityParameters ap_r1
          on ap_r1.idfObservation = ob_r1.idfObservation
          and ap_r1.intRowStatus = 0
          and ap_r1.idfsParameter = @FFP_RubellaNumberOfVaccine
      on ob_r1.idfObservation = hc.idfEpiObservation
      and ob_r1.intRowStatus = 0        			
  			
  			
      left join tlbObservation ob_m2  
          inner join  tlbActivityParameters ap_m2
          on ap_m2.idfObservation = ob_m2.idfObservation
          and ap_m2.intRowStatus = 0
          and ap_m2.idfsParameter = @FFP_MeaslesDateOfLastVaccine
      on ob_m2.idfObservation = hc.idfEpiObservation
      and ob_m2.intRowStatus = 0
      
      left join tlbObservation ob_r2
          inner join  tlbActivityParameters ap_r2
          on ap_r2.idfObservation = ob_r2.idfObservation
          and ap_r2.intRowStatus = 0
          and ap_r2.idfsParameter = @FFP_RubellaDateOfLastVaccine
      on ob_r2.idfObservation = hc.idfEpiObservation
      and ob_r2.intRowStatus = 0        			
  			
      left join tlbObservation ob_m3  
          inner join  tlbActivityParameters ap_m3
          on ap_m3.idfObservation = ob_m3.idfObservation
          and ap_m3.intRowStatus = 0
          and ap_m3.idfsParameter = @FFP_MeaslesSourceOfInfectionImportedCase
      on ob_m3.idfObservation = hc.idfEpiObservation
      and ob_m3.intRowStatus = 0
      
      left join tlbObservation ob_r3
          inner join  tlbActivityParameters ap_r3
          on ap_r3.idfObservation = ob_r3.idfObservation
          and ap_r3.intRowStatus = 0
          and ap_r3.idfsParameter = @FFP_RubellaSourceOfInfectionImportedCase
      on ob_r3.idfObservation = hc.idfEpiObservation
      and ob_r3.intRowStatus = 0        			  			
  			
  		
  WHERE	
	hc.intRowStatus = 0 AND
	ts.idfsSite is null and
	(
    -- Measles
		(
		  hc.idfsTentativeDiagnosis = @idfsDiagnosis_Measles and 
		  (cast(SQL_VARIANT_PROPERTY(ap_m.varValue, 'BaseType') as nvarchar) like N'%date%'   or
					(cast(SQL_VARIANT_PROPERTY(ap_m.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_m.varValue as nvarchar)) = 1 )) and
		  
		  CAST(ap_m.varValue as datetime) is not null and
		  CAST(ap_m.varValue as datetime) >= @StartDate and
		  CAST(ap_m.varValue as datetime) < @EndDate
		) 
		or 
		-- Rubella
		(
		  hc.idfsTentativeDiagnosis = @idfsDiagnosis_Rubella and 
		  (cast(SQL_VARIANT_PROPERTY(ap_r.varValue, 'BaseType') as nvarchar) like N'%date%'   or
					(cast(SQL_VARIANT_PROPERTY(ap_r.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(ap_r.varValue as nvarchar)) = 1 )) and
		  cast(ap_r.varValue as datetime) is not null and
		  CAST(ap_r.varValue as datetime) >= @StartDate and
		  CAST(ap_r.varValue as datetime) < @EndDate
		)
    )
    and hc.idfsTentativeDiagnosis = @idfsDiagnosis
   

  	
	------------------------------
	-- STUB DATA
    ------------------------------		
	--insert into @ResultTable
	--select		  c.idfCase
	--			, c.strCaseID
	--			, cast(2* RAND(CHECKSUM(NEWID())) as int)
	--			, 397
	--			, c.datEnteredDate
	--			, cast(4* RAND(CHECKSUM(NEWID())) as int)
	--			, c.datEnteredDate
	--			, cast(9* RAND(CHECKSUM(NEWID())) as int)
	--			, c.datEnteredDate
	--			, hc.datNotificationDate
	--			, hc.datInvestigationStartDate
	--			, cast(3* RAND(CHECKSUM(NEWID())) as int)
	--			, cast(2* RAND(CHECKSUM(NEWID())) as int)
	--			, cast(2* RAND(CHECKSUM(NEWID())) as int)
	--			, c.datEnteredDate
	--			, cast(2* RAND(CHECKSUM(NEWID())) as int)
	--			, cast(4* RAND(CHECKSUM(NEWID())) as int)
	--			, cast(5* RAND(CHECKSUM(NEWID())) as int)
	--from		tlbCase c
	--inner join	tlbHumanCase hc
	--on	c.idfCase = hc.idfHumanCase
	
	select * from @ResultTable
	order by datDateOfRashOnset, strCaseID	
end


