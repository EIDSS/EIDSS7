
  
  --##SUMMARY Select data for Microbiology Research Card .
  --##REMARKS Author: 
  --##REMARKS Create date: 17.01.2011
  
  --##REMARKS UPDATED BY: Romasheva S.
  --##REMARKS Date: 17.07.2014
  
  --##RETURNS Doesn't use
  
  /*
  --Example of a call of procedure:
  
  exec spRepHumMicrobiologyResearchCard  'en', 'S070140005'
  
  */
  
create  Procedure [dbo].[spRepHumMicrobiologyResearchCard]
  	(
  		@LangID		as nvarchar(10), 
  		@SampleID	as varchar(36),	 
  		@LastName	as nvarchar(200) = null,
  		@FirstName	as nvarchar(200) = null,
  		@SiteID		as bigint = null
  	)
  AS	
  
  -- Field description may be found here
  -- "https://repos.btrp.net/BTRP/Project_Documents/08x-Implementation/Customizations/GG/Reports/Specification for report development - Microbiology Research Card Human GG v1.0.doc"
  -- by number marked red at screen form prototype 
  
  declare	@ReportTable 	table
  (	
  	strSiteName				nvarchar(2000), --1
  	strSiteAddress			nvarchar(2000), --2
  	strSampleId				nvarchar(200),  --4
  	datSampleReceived		datetime,		--5
  	datSampleCollected		datetime,		--6
  	strNameSurname			nvarchar(2000), --8
  	strAge					nvarchar(200),  --9
  	strResearchedSample		nvarchar(2000), --10
  	strResearchedDiagnosis	nvarchar(2000), --11
  	strSampleReceivedFrom	nvarchar(2000), --12
  
  	blnBacteriology			bit,			--14 new
  	blnVirology				bit,			--15 new
  	blnMicroscopy			bit,			--16 new
  	blnPCR					bit,			--17 new
  	blnOther				bit,			--18 new
  	strOther				nvarchar(max),	--19 new
  		
  	strResearchResult		nvarchar(max),  --20
  	strResearchConductedBy	nvarchar(max),  --21
  	strResponsiblePerson	nvarchar(2000), --22 
  	datResultIssueDate		datetime		--23
  )	
  
  
  declare
    @idfsOffice bigint,
    @strOfficeName nvarchar(200),
    @strOfficeLocation nvarchar(200),
    @idfsCustomReportType bigint,
    @tel nvarchar(10)
    
  
	set @idfsCustomReportType = 10290011 -- GG Microbiology Research Result

	if @SiteID is null set @SiteID = dbo.fnSiteID()       
  
	select @tel = IsNull(RTrim(r.[name]) + N' ', N'')
	from fnReferenceRepair(@LangID, 19000132) r -- Additional report Text
	where r.strDefault = N'Tel.:'
  
	select 
		@idfsOffice = o.idfOffice,
		@strOfficeLocation = isnull(dbo.fnAddressSharedString(@LangID, o.idfLocation), '') + isnull(', ' + @tel + o.strContactPhone, ''),
		@strOfficeName = fni.FullName
	from tstSite s
	inner join tlbOffice o
	on o.idfOffice = s.idfOffice
	inner join	fnInstitution(@LangID) fni
	on			o.idfOffice = fni.idfOffice
	where	 s.idfsSite = @SiteID
  
  
  insert into @ReportTable (
  	strSiteName,
  	strSiteAddress,
  	strSampleId,
  	datSampleReceived,
  	datSampleCollected,
  	strNameSurname,
  	strAge,
  	strResearchedSample,
  	strResearchedDiagnosis,
  	strSampleReceivedFrom,
  	blnBacteriology,			--14 new
  	blnVirology,			--15 new
  	blnMicroscopy,			--16 new
  	blnPCR,			--17 new
  	blnOther,			--18 new
  	strOther,	--19 new	
  	
  	strResearchResult,
  	strResearchConductedBy,
  	strResponsiblePerson,
  	datResultIssueDate
  )
  select
  	@strOfficeName,
  	@strOfficeLocation,
  	m.strBarcode,             --strSampleId
  	m.datAccession,           --datSampleReceived
  	m.datFieldCollectionDate, --datSampleCollected
  	ISNULL(h.strFirstName + ' ', '') + ISNULL(h.strLastName,''),            --strNameSurname
  	CAST(hc.intPatientAge AS NVARCHAR(10)) + N' (' + ref_age.[name] + N')', --strAge
  
  	ref_st.[name],      --strResearchedSample		-- 10
  	ref_diag_c.[name],  --strResearchedDiagnosis	--11
  	mcb.[name],         --strSampleReceivedFrom	--12
  
  	-- 14 blnBacteriology
  	-- Checkbox should be checked if and only if there is at least one laboratory test 
  	-- (created in laboratory module (not added in H02, not added as external result) 
  	-- at the EIDSS site where the report generation takes place) assigned to the sample 
  	-- selected in the filters of the report with the name equal to any item from attachment 
  	-- Microbiology Tests List with Test Sub-type = “Bacteriology”, to which at least one 
  	-- Interpretation record in H02 form -> Tests tab -> Results Summary and Interpretation 
  	-- zone is connected and has the attribute Validated Yes/No = “Yes” (selected the Validated 
  	-- check-box for corresponding row in the grid).
 
 	-- If there is no laboratory test that meets abovementioned criteria, 
 	-- then the Bacteriology checkbox should be clear.
 
  	case when exists (
  			select top 1 *
  			from		tlbTesting testing 
  				inner join	trtTestTypeForCustomReport ttfcr
  				on		ttfcr.idfsTestName = testing.idfsTestName
  				and		ttfcr.intRowStatus = 0
  				and		ttfcr.idfsCustomReportType = @idfsCustomReportType
  			    
  			    inner join trtBaseReferenceAttribute tbra
  					inner join	trtAttributeType at
  					on			at.strAttributeTypeName = N'Test Sub-type'
  			    on tbra.idfsBaseReference = ttfcr.idfsTestName
  			    and cast(tbra.varValue as nvarchar(100)) = 'Bacteriology'
  			    
  				inner join	tlbTestValidation tv
  				on		testing.idfTesting = tv.idfTesting
  				and		tv.blnValidateStatus = 1
  				and		tv.intRowStatus = 0		
    
  			where testing.idfMaterial = m.idfMaterial
  				and testing.blnNonLaboratoryTest = 0
  				and testing.blnExternalTest = 0    
  				and testing.blnReadOnly = 0    
  				and testing.intRowStatus = 0
  	) then 1 else null end as blnBacteriology,	--14 
  	
  	--15 blnVirology
  	case when exists (
  			select top 1 *
  			from		tlbTesting testing 
  				inner join	trtTestTypeForCustomReport ttfcr
  				on		ttfcr.idfsTestName = testing.idfsTestName
  				and		ttfcr.intRowStatus = 0
  				and		ttfcr.idfsCustomReportType = @idfsCustomReportType
  			    
  			    inner join trtBaseReferenceAttribute tbra
  					inner join	trtAttributeType at
  					on			at.strAttributeTypeName = N'Test Sub-type'
  			    on tbra.idfsBaseReference = ttfcr.idfsTestName
  			    and cast(tbra.varValue as nvarchar(100)) = 'Virology'
  			      			    
  				inner join	tlbTestValidation tv
  				on		testing.idfTesting = tv.idfTesting
  				and		tv.blnValidateStatus = 1
  				and		tv.intRowStatus = 0		
    
  			where testing.idfMaterial = m.idfMaterial
  				and testing.blnNonLaboratoryTest = 0
  				and testing.blnExternalTest = 0  
  				and testing.blnReadOnly = 0          
  				and testing.intRowStatus = 0
  	) then 1 else null end as blnVirology,			--15 
  	
  	--16 blnMicroscopy
  	case when exists (
  			select top 1 *
  			from		tlbTesting testing 
  				inner join	trtTestTypeForCustomReport ttfcr
  				on		ttfcr.idfsTestName = testing.idfsTestName
  				and		ttfcr.intRowStatus = 0
  				and		ttfcr.idfsCustomReportType = @idfsCustomReportType

  			    inner join trtBaseReferenceAttribute tbra
  					inner join	trtAttributeType at
  					on			at.strAttributeTypeName = N'Test Sub-type'
  			    on tbra.idfsBaseReference = ttfcr.idfsTestName
  			    and cast(tbra.varValue as nvarchar(100)) = 'Microscopy'
  			    		    
  				inner join	tlbTestValidation tv
  				on		testing.idfTesting = tv.idfTesting
  				and		tv.blnValidateStatus = 1
  				and		tv.intRowStatus = 0		
    
  			where testing.idfMaterial = m.idfMaterial
  				and testing.blnNonLaboratoryTest = 0
  				and testing.blnExternalTest = 0    
  				and testing.blnReadOnly = 0        
  				and testing.intRowStatus = 0
  	) then 1 else null end as blnMicroscopy,			--16 
  	
  	--17 blnPCR
  	case when exists (
  			select top 1 *
  			from		tlbTesting testing 
  				inner join	trtTestTypeForCustomReport ttfcr
  				on		ttfcr.idfsTestName = testing.idfsTestName
  				and		ttfcr.intRowStatus = 0
  				and		ttfcr.idfsCustomReportType = @idfsCustomReportType
  				
  				inner join trtBaseReferenceAttribute tbra
  					inner join	trtAttributeType at
  					on			at.strAttributeTypeName = N'Test Sub-type'
  			    on tbra.idfsBaseReference = ttfcr.idfsTestName
  			    and cast(tbra.varValue as nvarchar(100)) = 'PCR'
  			    
  				inner join	tlbTestValidation tv
  				on		testing.idfTesting = tv.idfTesting
  				and		tv.blnValidateStatus = 1
  				and		tv.intRowStatus = 0		
  		
  			where testing.idfMaterial = m.idfMaterial
  				and testing.blnNonLaboratoryTest = 0
  				and testing.blnExternalTest = 0   
  				and testing.blnReadOnly = 0         
  				and testing.intRowStatus = 0
  	) then 1 else null end as blnPCR,			--17 
  	
  	--18 blnOther
  	case when exists (
  			select top 1 *
  			from		tlbTesting testing 
  				inner join	trtTestTypeForCustomReport ttfcr
  				on		ttfcr.idfsTestName = testing.idfsTestName
  				and		ttfcr.intRowStatus = 0
  				and		ttfcr.idfsCustomReportType = @idfsCustomReportType

  				inner join trtBaseReferenceAttribute tbra
  					inner join	trtAttributeType at
  					on			at.strAttributeTypeName = N'Test Sub-type'
  			    on tbra.idfsBaseReference = ttfcr.idfsTestName
  			    and cast(tbra.varValue as nvarchar(100)) = 'Other'  				
 			    
  				inner join	tlbTestValidation tv
  				on		testing.idfTesting = tv.idfTesting
  				and		tv.blnValidateStatus = 1
  				and		tv.intRowStatus = 0		
    
  			where testing.idfMaterial = m.idfMaterial
  				and testing.blnNonLaboratoryTest = 0
  				and testing.blnExternalTest = 0     
  				and testing.blnReadOnly = 0       
  				and testing.intRowStatus = 0
  	) then 1 else null end as blnOther,			--18 
    
 	--19 strOther
 	--  Unique (different) names of laboratory tests that meet criteria described 
 	--  for the Other check-box (18) splitted by comma and given in alphabetical 
 	--  order in current language of the report. 
 	
  	cast(	(	
  			select top 1 with ties
  					IsNull(TestName.[name], N'') + N', '
  			from		tlbTesting testing 
  				inner join	trtTestTypeForCustomReport ttfcr
  				on		ttfcr.idfsTestName = testing.idfsTestName
  				and		ttfcr.intRowStatus = 0
  				and		ttfcr.idfsCustomReportType = @idfsCustomReportType

  				inner join trtBaseReferenceAttribute tbra
  					inner join	trtAttributeType at
  					on			at.strAttributeTypeName = N'Test Sub-type'
  			    on tbra.idfsBaseReference = ttfcr.idfsTestName
  			    and cast(tbra.varValue as nvarchar(100)) = 'Other' 
  			      				
  				left join	fnReference(@LangID,19000097) TestName
  				on			testing.idfsTestName=TestName.idfsReference
 			    
  				inner join	tlbTestValidation tv
  				on		testing.idfTesting = tv.idfTesting
  				and		tv.blnValidateStatus = 1
  				and		tv.intRowStatus = 0		
  			where testing.idfMaterial = m.idfMaterial
  				and testing.blnNonLaboratoryTest = 0
  				and testing.blnExternalTest = 0   
  				and testing.blnReadOnly = 0         
  				and testing.intRowStatus = 0
  	     	order by row_number() over(partition by TestName.[name] order by TestName.[name] asc) 
  			for	xml path('')
  			) as nvarchar(max)
  		) as strOther,			--19  
  	
  	--20 strResearchResult
  	-- Unique combination of the “Diagnosis”, “Test Name”, and “Rule Out/Rule In” attributes of all interpretation 
  	-- records from H02 form -> Tests tab -> Results Summary and Interpretation zone  that have the attribute 
  	-- Validated Yes/No = “Yes” (selected the Validated check-box for corresponding row in the grid) and are 
  	-- connected to the tests that meet at least one criterion described for the check-boxes 14-18. 
  	-- Attributes should be displayed in following order:

	--[data from Diagnosis field], then “:“, [data from Test Name field],  then “-“, [data from Rule Out/Rule In field]

	--NB:If there are two interpretation records that meet abovementioned criteria and have the same combination 
	--of the “Diagnosis”, “Test Name”, and “Rule Out/Rule In” attributes, then include only one combination of 
	--these attributes taken from the first interpretation record from these two records to the text displayed 
	--in the Research result (20) field.

	--Split information taken from different interpretation records by semicolon (;). Do not add semicolon
	-- after the attributes taken from the last interpretation record.

	--Sort interpretation records by serial numbers of the test names as given in attachment Microbiology 
	--Tests List first, after that sort them by the Date Interpreted attribute of interpretation records, 
	--after that sort them by the Diagnosis attribute of interpretation records in alphabetical order 
	--in current language of the report.

  	cast(	(	
  			select	
  					t.DiagnosisName + 
  					IsNull(N': ' + t.TestNameName, N'')+ 
  					IsNull(N' - ' + t.RuleInOutName, N'') + N'; '
  			from		
  			(
  					select	top 1 with ties
  							Diagnosis.[name]  as DiagnosisName, 
  							TestName.[name] as TestNameName, 
  							RuleInOut.[name] as RuleInOutName, 
  							ttfcr.intRowOrder, 
  							tv.datInterpretationDate
         	 			from		tlbTesting testing 
  					inner join	trtTestTypeForCustomReport ttfcr
  					on		ttfcr.idfsTestName = testing.idfsTestName
  					and		ttfcr.intRowStatus = 0
  					and		ttfcr.idfsCustomReportType = @idfsCustomReportType
  				    
  					inner join trtBaseReferenceAttribute tbra
						inner join trtAttributeType tat
  						on tat.idfAttributeType = tbra.idfAttributeType
  						and tat.strAttributeTypeName = 'Test Sub-type'  					
  					on tbra.idfsBaseReference = ttfcr.idfsTestName
  					and cast(tbra.varValue as nvarchar(100)) in ('Bacteriology', 'Microscopy', 'Virology', 'PCR', 'Other')
  			      				    
  					inner join	tlbTestValidation tv
  					on		testing.idfTesting = tv.idfTesting
  					and		tv.blnValidateStatus = 1
  					and		tv.intRowStatus = 0
  						    
  					left join	fnReference(@LangID,19000019) Diagnosis
  					on			tv.idfsDiagnosis = Diagnosis.idfsReference
  		            
  					left join	fnReference(@LangID,19000097) TestName
  					on			testing.idfsTestName=TestName.idfsReference
  		        
  					left join	fnReference(@LangID,19000106) RuleInOut
  					on			tv.idfsInterpretedStatus = RuleInOut.idfsReference
  					where
  						testing.idfMaterial = m.idfMaterial
  						and testing.blnNonLaboratoryTest = 0
  						and testing.blnExternalTest = 0     
  						and testing.blnReadOnly = 0       
  						and testing.intRowStatus = 0
  					order by row_number() over(partition by Diagnosis.[name], TestName.[name], RuleInOut.[name] order by ttfcr.intRowOrder, tv.datInterpretationDate, Diagnosis.[name])
  			)	as t
  	     	order by t.intRowOrder, t.datInterpretationDate, t.DiagnosisName
  			for	xml path('')
  			) as nvarchar(max)
  		)	as strResearchResult, --20
    
 	-- 21 strResearchConductedBy
  	cast(	(	select 
  				 isnull(t.strFirstName + ' ', '') + ISNULL(t.strFamilyName, '') + N', '
         	 	from
         	 	(
         	 			select top 1 with ties
         	 				prcb.strFirstName,
         	 				prcb.strFamilyName,
         	 				ttfcr.intRowOrder, 
         	 				tv.datInterpretationDate, 
         	 				Diagnosis.[name] as DiagnosisName
  					from tlbTesting testing 
  					inner join	trtTestTypeForCustomReport ttfcr
  					on		ttfcr.idfsTestName = testing.idfsTestName
  					and		ttfcr.intRowStatus = 0
  					and		ttfcr.idfsCustomReportType = @idfsCustomReportType
  
    				inner join trtBaseReferenceAttribute tbra
						inner join trtAttributeType tat
  						on tat.idfAttributeType = tbra.idfAttributeType
  						and tat.strAttributeTypeName = 'Test Sub-type'  	    				
  					on tbra.idfsBaseReference = ttfcr.idfsTestName
  					and cast(tbra.varValue as nvarchar(100)) in ('Bacteriology', 'Microscopy', 'Virology', 'PCR', 'Other')
  					
  					inner join dbo.tlbTestValidation tv
  					on		testing.idfTesting = tv.idfTesting
  					and		tv.blnValidateStatus = 1
  					and		tv.intRowStatus = 0
  
  					left join	fnReference(@LangID,19000019) Diagnosis
  					on		tv.idfsDiagnosis = Diagnosis.idfsReference
  		        
  					left join	( tlbEmployee ercb
  							inner join	tlbPerson prcb
  							on			prcb.idfPerson = ercb.idfEmployee
  					)
  					on		ercb.idfEmployee = tv.idfInterpretedByPerson
  					and		ercb.intRowStatus = 0	
  						          			    
  					where testing.idfMaterial = m.idfMaterial
  						and testing.intRowStatus = 0
  						and testing.blnNonLaboratoryTest = 0
  						and testing.blnExternalTest = 0    	
  						and testing.blnReadOnly = 0    			
  					order by row_number() over(partition by prcb.strFirstName, prcb.strFamilyName order by ttfcr.intRowOrder, tv.datInterpretationDate, Diagnosis.[name])
  
         	 	) as t
         	 	order by t.intRowOrder, t.datInterpretationDate, t.DiagnosisName
  			for	xml path('')
  			) as nvarchar(max)
  		)	as strResearchConductedBy, --21
    
 	-- 22	strResponsiblePerson
  	cast(	(	select 
  				isnull(t.strFirstName + ' ', '') + ISNULL(t.strFamilyName, '') + N', '
         	 	from
         	 	(	
  			select top 1 with ties
  				 prcb.strFirstName,
  				 prcb.strFamilyName,
  				 ttfcr.intRowOrder, 
  				 tv.datInterpretationDate,
  				 Diagnosis.[name] as DiagnosisName
  			from	tlbTesting testing 
  			inner join trtTestTypeForCustomReport ttfcr
  			on		ttfcr.idfsTestName = testing.idfsTestName
  			and		ttfcr.intRowStatus = 0
  			and		ttfcr.idfsCustomReportType = @idfsCustomReportType
  
			inner join trtBaseReferenceAttribute tbra
						inner join trtAttributeType tat
  						on tat.idfAttributeType = tbra.idfAttributeType
  						and tat.strAttributeTypeName = 'Test Sub-type'  	    				
			on tbra.idfsBaseReference = ttfcr.idfsTestName
			and cast(tbra.varValue as nvarchar(100)) in ('Bacteriology', 'Microscopy', 'Virology', 'PCR', 'Other')
  					
  			inner join dbo.tlbTestValidation tv
  			on		testing.idfTesting = tv.idfTesting
  			and		tv.intRowStatus = 0
  			and		tv.blnValidateStatus = 1
  			
  			left join	fnReference(@LangID,19000019) Diagnosis
  			on			tv.idfsDiagnosis = Diagnosis.idfsReference
  			
  			left join	(tlbEmployee ercb
  						inner join	tlbPerson prcb
  						on			prcb.idfPerson = ercb.idfEmployee
  						)
  			on		ercb.idfEmployee = tv.idfValidatedByPerson
  			and ercb.intRowStatus = 0				    
          where testing.idfMaterial = m.idfMaterial
  				and testing.blnNonLaboratoryTest = 0
  				and testing.blnExternalTest = 0    
  				and testing.blnReadOnly = 0    			        
  				and testing.intRowStatus = 0
  		order by row_number() over(partition by prcb.strFirstName, prcb.strFamilyName order by ttfcr.intRowOrder, tv.datInterpretationDate, Diagnosis.[name])
         	) as t
         	
        order by t.intRowOrder, t.datInterpretationDate, t.DiagnosisName
  		for	xml path('')
  		) as nvarchar(max)
  		)	as strResponsiblePerson, --22
    
 	-- 23 	datResultIssueDate
 	(	select top 1 
  			tv.datInterpretationDate
  		from tlbTesting testing 
  		inner join	trtTestTypeForCustomReport ttfcr
  		on		ttfcr.idfsTestName = testing.idfsTestName
  		and		ttfcr.intRowStatus = 0
  		and		ttfcr.idfsCustomReportType = @idfsCustomReportType
  
  		inner join	dbo.tlbTestValidation tv
  		on		testing.idfTesting = tv.idfTesting
  		and		tv.blnValidateStatus = 1
  		and		tv.intRowStatus = 0
  
          where testing.idfMaterial = m.idfMaterial
  				and testing.blnNonLaboratoryTest = 0
  				and testing.blnExternalTest = 0   
  				and testing.blnReadOnly = 0     		        
  				and testing.intRowStatus = 0
          order by tv.datInterpretationDate desc
      ) as datResultIssueDate -- 23
                               
  from	tlbMaterial m
  	inner join	fnReferenceRepair(@LangID, 19000087) ref_st	-- Sample Type
  	on			ref_st.idfsReference = m.idfsSampleType
  	
  	left join	fnInstitution(@LangID) mcb
  	on			mcb.idfOffice = m.idfFieldCollectedByOffice
  	
  	left join	fnDepartment(@LangID) dep
  	on			dep.idfDepartment = m.idfInDepartment
  	
    inner join	( tlbHumanCase hc
  				left join	fnReferenceRepair(@LangID, 19000042) ref_age	-- Human Age Type
  				on			ref_age.idfsReference = hc.idfsHumanAgeType
  				left join	fnReferenceRepair(@LangID,19000019) ref_diag_c
  				on			ISNULL(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = ref_diag_c.idfsReference
  				)
  	on		hc.idfHumanCase = m.idfHumanCase
  	and		hc.intRowStatus = 0
  	
  	inner join	tlbHuman h
  	on		h.idfHuman = m.idfHuman
  	and		h.intRowStatus = 0
  where   
	m.strBarcode = @SampleID
	and m.idfsSite = @SiteID
	and ((h.strLastName like @LastName + '%') OR IsNull(@LastName, N'') = N'')
	and ((h.strFirstName like @FirstName + '%') OR IsNull(@FirstName, N'') = N'')
	and exists (
		select *
		from tlbTesting testing 
			inner join trtTestTypeForCustomReport ttfcr
			on		ttfcr.idfsTestName = testing.idfsTestName
			and		ttfcr.intRowStatus = 0
			and		ttfcr.idfsCustomReportType = @idfsCustomReportType

			left join	dbo.tlbTestValidation tv
			on		testing.idfTesting = tv.idfTesting
			and		tv.intRowStatus = 0
			and tv.blnValidateStatus = 1
	  where testing.idfMaterial = m.idfMaterial
			and testing.blnNonLaboratoryTest = 0
			and testing.blnExternalTest = 0
			and testing.blnReadOnly = 0    
			and testing.intRowStatus = 0    
	)
  
  
	update	@ReportTable
	set		strOther = substring(ltrim(rtrim(strOther)), 0, LEN(ltrim(rtrim(strOther))))
	where	ltrim(rtrim(strOther)) like N'%;'
	  
	update	@ReportTable
	set		strResearchResult = substring(ltrim(rtrim(strResearchResult)), 0, LEN(ltrim(rtrim(strResearchResult))))
	where	ltrim(rtrim(strResearchResult)) like N'%;'

	update	@ReportTable
	set		strResearchConductedBy = substring(ltrim(rtrim(strResearchConductedBy)), 0, LEN(ltrim(rtrim(strResearchConductedBy))))
	where	ltrim(rtrim(strResearchConductedBy)) like N'%,'
	
	update	@ReportTable
	set		strResponsiblePerson = substring(ltrim(rtrim(strResponsiblePerson)), 0, LEN(ltrim(rtrim(strResponsiblePerson))))
	where	ltrim(rtrim(strResponsiblePerson)) like N'%,'  
  
  
  
	if not exists (select * from @ReportTable)
	begin
	insert into @ReportTable (strSiteName, strSiteAddress)
	values  (@strOfficeName, @strOfficeLocation)
	end

  
	select * 
	from @ReportTable
 
 

