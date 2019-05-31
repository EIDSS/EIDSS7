
 --##SUMMARY Select data for Laboratory Research Result Form .
 --##REMARKS Author: Romasheva S.
 --##REMARKS Create date: 24.07.2014
 
 --##RETURNS Doesn't use
 
 /*
 --Example of a call of procedure:
 
	exec [spRepVetLMALaboratoryResearchResult]  'en', 'caseID', null, 'Reg#', 'condition sample received', 'ResultRecipient', 1176 -- E02	6640000000

	exec [spRepVetLMALaboratoryResearchResult]  'en', 'caseID', null, 'Reg#', 'condition sample received', 'ResultRecipient', 1178 -- E09	6530000000

	exec [spRepVetLMALaboratoryResearchResult]  'en', 'caseID', null, 'Reg#', 'condition sample received', 'ResultRecipient', 1117 -- A26	5500000000
	
	
	
	
	exec [spRepVetLMALaboratoryResearchResult]  'en', 'VGEAJKV1140343', null, 'Reg#', 'condition sample received', 'ResultRecipient', 1115 
*/
   
 create  Procedure [dbo].[spRepVetLMALaboratoryResearchResult]
   	(
   		 @LangID						as nvarchar(10) 
   		,@strCaseID						as nvarchar(100)	= null
   		,@strSessionID					as nvarchar(100)	= null
   		,@strRegistrationNumber			as nvarchar(100)
   		,@strConditionSampleReceived	as nvarchar(500)	= null 
   		,@strResultRecipient			as nvarchar(500)
   		,@SiteID						as bigint			= null
   	)
   AS	
   
   -- Field description may be found here
   -- "https://95.167.107.114/BTRP/Project_Documents/08x-Implementation/Customizations/GG/Customization EIDSS v6/Reports/Specification for report development - LMA Laboratory Results Form GG v1.0.doc"
   -- by number marked red at screen form prototype 
   
 	declare	@ReportTable 	table
 	(	
 		 intRow							int identity(1,1) primary key			--27
 		,strSiteName					nvarchar(2000)	--3
 		,strSiteAddress					nvarchar(2000)	--4
 		,strPhone						nvarchar(100)	--5
 		,strDate						nvarchar(200)	--8
 		,strForm						nvarchar(200)	--9
 		,strVersion						nvarchar(200)	--10
 		,strRegNumberAndResultDate		nvarchar(200)	--12
 		,strDateSampleReceived			nvarchar(max)	--13
 		,strSampleOwner					nvarchar(max)	--14
 		,strReceivedSampleType			nvarchar(max)	--15
 		,strSampleNumber				nvarchar(max)	--16
 		,strConditionSampleReceived		nvarchar(2000)	--17
 		,strPrimaryDiagnosis			nvarchar(max)	--18
 		,strResultRecipient				nvarchar(2000)	--19
 		,strRequestedLaboratoryTests	nvarchar(max)	--20
 		,strTestResult					nvarchar(max)	--21
 		,strNotes						nvarchar(max)	--22
 		,strDirector					nvarchar(500)	--23
 		,strHeadOfDepartment			nvarchar(500)	--24
 		--?Laboratory Research Result Attachment? Part
 		
 		,strDiagnosis					nvarchar(500)	--28
 		,strFarmOwner					nvarchar(500)	--29
 		,intSpeciesTypeOrder			int
 		,strSpecies						nvarchar(500)	--30
 		,strAnimal						nvarchar(500)	--31
 		
 		
 	)
 	
 	
   declare
   	@idfsCustomReportType			bigint,
   	
   	@idfsOfficeAbbr					bigint,
    @strSiteName					nvarchar(2000),
    @strSiteAddress					nvarchar(2000),
    @strPhone						nvarchar(100),
    @strDate						nvarchar(200),
 	@strForm						nvarchar(200),
 	@strVersion						nvarchar(200),
 	@strRegNumberAndResultDate		nvarchar(200),
 	@strPositiveResult				nvarchar(200),
 	@strAttachmentLink				nvarchar(200),
 
     
 	@strDateSampleReceived			nvarchar(max),--13
 	@strSampleOwner					nvarchar(max),--14
 	@strReceivedSampleType			nvarchar(max),--15
 	@strSampleNumber				nvarchar(max),--16
 	@strPrimaryDiagnosis			nvarchar(max),--18
 	@strRequestedLaboratoryTests	nvarchar(max),--20
 	@strTestResult					nvarchar(max),--21
 	@strNotes						nvarchar(max),--22
 	@strDirector					nvarchar(200),--23
 	@strHeadOfDepartment			nvarchar(200) --24
 		
	
	set @idfsCustomReportType = 10290030 -- GG LMA Laboratory Research Result Form
   
 	if @SiteID is null set @SiteID = dbo.fnSiteID()       
   
 	select 
 		@strSiteAddress = isnull(dbo.fnAddressSharedString(@LangID, o.idfLocation), ''),
 		@strPhone = o.strContactPhone,
 		@strSiteName = fni.FullName,
 		@idfsOfficeAbbr = fni.idfsOfficeAbbreviation
 	from tstSite s
 		inner join	tlbOffice o
 		on			o.idfOffice = s.idfOffice
 		inner join	fnInstitution(@LangID) fni
 		on			o.idfOffice = fni.idfOffice
 	where	 s.idfsSite = @SiteID	
 	
 	select @strDate = IsNull(RTrim(r.[name]) + N' ', N'')
 	from fnReferenceRepair(@LangID, 19000132) r -- Additional report Text
 		inner join	trtBaseReference br
 		on			br.idfsBaseReference = r.idfsReference
 	where br.strBaseReferenceCode = N'Date'
 	
 	select @strForm = IsNull(RTrim(r.[name]) + N' ', N'')
 	from fnReferenceRepair(@LangID, 19000132) r -- Additional report Text
 		inner join	trtBaseReference br
 		on			br.idfsBaseReference = r.idfsReference
 	where br.strBaseReferenceCode = N'Form #'	
   
 	select @strVersion = IsNull(RTrim(r.[name]) + N' ', N'')
 	from fnReferenceRepair(@LangID, 19000132) r -- Additional report Text
 		inner join	trtBaseReference br
 		on			br.idfsBaseReference = r.idfsReference
 	where br.strBaseReferenceCode = N'Version #'	
 	
 	select @strPositiveResult = IsNull(RTrim(r.[name]), N'')
 	from fnReferenceRepair(@LangID, 19000132) r -- Additional report Text
 		inner join	trtBaseReference br
 		on			br.idfsBaseReference = r.idfsReference
 	where br.strBaseReferenceCode = N'Positive result'	
 	
 	select @strAttachmentLink = IsNull(RTrim(r.[name]), N'')
 	from fnReferenceRepair(@LangID, 19000132) r -- Additional report Text
 		inner join	trtBaseReference br
 		on			br.idfsBaseReference = r.idfsReference
 	where br.strBaseReferenceCode = N'Attachment link'		
 	
 	select @strRegNumberAndResultDate = isnull(@strRegistrationNumber + '; ', '') + convert(nvarchar(20), getdate(), 104)
 	
 	
 	select @strDirector = IsNull(RTrim(r.[name]) + N' ', N'')
 	from fnReferenceRepair(@LangID, 19000132) r -- Additional report Text
 		inner join	trtBaseReference br
 		on			br.idfsBaseReference = r.idfsReference
  		
 		inner join trtBaseReferenceAttribute tbra
 				inner join trtAttributeType tat
				on tat.idfAttributeType = tbra.idfAttributeType
				and tat.strAttributeTypeName = 'attr_position'
		
 		on tbra.varValue = br.idfsBaseReference
 		and tbra.idfsBaseReference = @idfsOfficeAbbr

	
		inner join trtBaseReferenceAttribute tbra2
			inner join trtAttributeType tat2
			on tat2.idfAttributeType = tbra2.idfAttributeType
			and tat2.strAttributeTypeName = 'attr_part_in_report'
		on tbra.idfsBaseReference = tbra2.idfsBaseReference
		and tbra2.varValue = @idfsCustomReportType 
		
	print @strDirector	

 	select @strHeadOfDepartment = IsNull(RTrim(r.[name]) + N' ', N'')
 	from fnReferenceRepair(@LangID, 19000132) r -- Additional report Text
 		inner join	trtBaseReference br
 		on			br.idfsBaseReference = r.idfsReference
  		
 		inner join trtBaseReferenceAttribute tbra
 				inner join trtAttributeType tat
				on tat.idfAttributeType = tbra.idfAttributeType
				and tat.strAttributeTypeName = 'attr_department'
		
 		on tbra.varValue = br.idfsBaseReference
 		and tbra.idfsBaseReference = @idfsOfficeAbbr

	
		inner join trtBaseReferenceAttribute tbra2
			inner join trtAttributeType tat2
			on tat2.idfAttributeType = tbra2.idfAttributeType
			and tat2.strAttributeTypeName = 'attr_part_in_report'
		on tbra.idfsBaseReference = tbra2.idfsBaseReference
		and tbra2.varValue = @idfsCustomReportType  	
 	
 
 	declare @table table
 	(
 		datDateSampleReceived	datetime,
 		strFarmOwner			nvarchar(2000),
 		strSampleTypeName		nvarchar(2000),
 		intSampleTypeOrder		int,
 		strSpeciesTypeName		nvarchar(2000),
 		intSpeciesTypeOrder		int,
 		strPrimaryDiagnosis		nvarchar(2000),
   		strTestName				nvarchar(2000),
   		strDiagnosisNameForTV	nvarchar(2000),
   		idfsAccessionCondition	bigint,
   		strAnimalCode			nvarchar(200), 
   		strAnimalName			nvarchar(200),
   		strFieldSampleID		nvarchar(200), 
   		strCondition			nvarchar(200),
   		
   		idfCaseOrSession		bigint,
   		idfMaterial				bigint,
   		idfSpecies				bigint,
   		idfAnimal				bigint,
   		idfTesting				bigint,
   		idfTestValidation		bigint,
   		strRowType				nvarchar(100)
 	
 	
 	
 	) 
 	
 	-- get material tree for site
	declare @MaterialTree table 
		(	
			idfMaterial bigint not null, 
			idfParentMaterial bigint null, 
			idfsSite bigint, 
			idfRootMaterial bigint null, 
			rowNum int
		)

	declare @MTree table 
		(	idfMaterial bigint not null, 
			idfParentMaterial bigint null, 
			idfRootMaterial bigint null, 
			idfsSite bigint,
			isDelete bit default (0),
			rowNum int
		)
	
	insert into @MaterialTree
	(idfMaterial, idfParentMaterial, idfsSite)	
	select distinct
		tm.idfMaterial, tm.idfParentMaterial, tm.idfsSite
	from tlbVetCase tvc
 		inner join tlbFarm tf
 		on tf.idfFarm = tvc.idfFarm
 		and tf.intRowStatus = 0
 		
 		inner join tlbHerd th
 		on th.idfFarm = tf.idfFarm
 		and th.intRowStatus = 0
 		
 		inner join tlbSpecies ts
  			left join tlbAnimal ta
 			on ta.idfSpecies = ts.idfSpecies
 			and ta.intRowStatus = 0
 		on ts.idfHerd = th.idfHerd
 		and ts.intRowStatus = 0
 		
 		inner join	tlbMaterial tm
 		on			(	(tm.idfSpecies = ts.idfSpecies and tm.idfAnimal is null)
 						or 
 						(tm.idfAnimal = ta.idfAnimal and tm.idfSpecies is null) 
 					)
 					and	tm.intRowStatus = 0
	where	tvc.strCaseID = @strCaseID 
 			and @strSessionID is null
 			and tvc.intRowStatus = 0		
	union
	select distinct
		tm.idfMaterial, tm.idfParentMaterial, tm.idfsSite
	from	tlbMonitoringSession tms
 		inner join tlbFarm tf
 		on tf.idfMonitoringSession = tms.idfMonitoringSession
 		and tf.intRowStatus = 0
 		
 		inner join tlbHerd th
 		on th.idfFarm = tf.idfFarm
 		and th.intRowStatus = 0
 		
 		inner join tlbSpecies ts
 		on ts.idfHerd = th.idfHerd
 		and ts.intRowStatus = 0

		inner join tlbAnimal ta
		on ta.idfSpecies = ts.idfSpecies
		and ta.intRowStatus = 0

 		inner join	tlbMaterial tm
 		on			tm.idfAnimal = ta.idfAnimal
 					and	tm.intRowStatus = 0	
	where	tms.strMonitoringSessionID = @strSessionID 
 			and @strCaseID is null
 			and tms.intRowStatus = 0
	
	
	;with CTERec(idfMaterial, idfParentMaterial, idfRootMaterial, idfsSite, rowNum) 
	as
	(
		select	T.idfMaterial
				,T.idfParentMaterial
				,idfRootMaterial = T.idfMaterial
				,idfsSite = T.idfsSite
				,0 as rowNum
		from	@MaterialTree T
		where	T.idfParentMaterial is null
		union all
		select	T.idfMaterial
				,T.idfParentMaterial
				,idfRootMaterial = CR.idfRootMaterial
				,idfsSite = T.idfsSite
				,CR.rowNum+1
		from	@MaterialTree T
				join CTERec CR on CR.idfMaterial = T.idfParentMaterial
	)

	insert into @MTree (idfMaterial, idfParentMaterial, idfRootMaterial, idfsSite, rowNum)
	select	 a.idfMaterial, a.idfParentMaterial, a.idfRootMaterial, a.idfsSite, a.rowNum
	from CTERec a
	order by a.idfRootMaterial, a.rowNum
	
	delete from @MaterialTree

	while exists	(select * from @MTree where idfParentMaterial is null and idfsSite <> @SiteID and isDelete = 0)
	begin
 		update mt set
 			mt.isDelete = 1 
 		from @MTree mt
 		where idfParentMaterial is null and idfsSite <> @SiteID
	 	
 		update mt set
 			mt.idfParentMaterial = null
 		from @MTree mt
 			inner join @MTree mtp
 			on mt.idfParentMaterial = mtp.idfMaterial
 			and mtp.idfParentMaterial is null and mtp.idfsSite <> @SiteID and mtp.isDelete = 1
	end
 	
 	;with CTERec(idfMaterial, idfParentMaterial, idfRootMaterial, idfsSite, rowNum) 
 	as
 	(
		select	T.idfMaterial
				,T.idfParentMaterial
				,idfRootMaterial = T.idfMaterial
				,idfsSite = T.idfsSite
				,0 as rowNum
		from	@MTree T
		where	T.idfParentMaterial is null and T.isDelete = 0
		union all
		select	T.idfMaterial
				,T.idfParentMaterial
				,idfRootMaterial = CR.idfRootMaterial
				,idfsSite = T.idfsSite
				,CR.rowNum+1
		from	@MTree T
				join CTERec CR on CR.idfMaterial = T.idfParentMaterial
		where	T.isDelete = 0
 	)
 	
 	insert into @MaterialTree
	(idfMaterial, idfParentMaterial, idfRootMaterial, idfsSite, rowNum)
	select idfMaterial, idfParentMaterial, idfRootMaterial, idfsSite, rowNum from CTERec
	order by idfRootMaterial, rowNum

	-- END get material tree for site	
 
 	insert into @table
 	(
 		datDateSampleReceived,
 		strFarmOwner,
 		strSampleTypeName,
 		intSampleTypeOrder,
 		strSpeciesTypeName,
 		intSpeciesTypeOrder,
 		strPrimaryDiagnosis,
 		strTestName,
 		strDiagnosisNameForTV,
 		idfsAccessionCondition,
 		strAnimalCode,
 		strAnimalName,
 		strFieldSampleID,
 		strCondition,
 		idfCaseOrSession,
 		idfMaterial,
 		idfSpecies,
 		idfAnimal,
 		idfTesting,
 		idfTestValidation,
 		strRowType
 	)
 	
 	select
 		dbo.fnDateCutTime(RootMaterial.datAccession) as datDateSampleReceived,
 		isnull(h.strFirstName + ' ', '') + h.strLastName as strFarmOwner,
 		SampleType.name as strSampleTypeName,
 		SampleType.intOrder as intSampleTypeOrder,
 		SpeciesType.name as strSpeciesTypeName,
 		SpeciesType.intOrder as intSpeciesTypeOrder,
 		isnull(Diagnosis1.name, '') + isnull(', '+ Diagnosis2.name, '') + isnull(', '+Diagnosis3.name, '') as strPrimaryDiagnosis,
   		TestName.name as strTestName,
   		DiagnosisTV.name as strDiagnosisNameForTV,
   		RootMaterial.idfsAccessionCondition,
   		ta.strAnimalCode, 
   		ta.strName as strAnimalName,
   		RootMaterial.strBarcode as strFieldSampleID, 
   		RootMaterial.strCondition,
   		
   		tvc.idfVetCase as idfCaseOrSession,
   		RootMaterial.idfMaterial,
   		ts.idfSpecies,
   		ta.idfAnimal,
   		tt.idfTesting,
   		ttv.idfTestValidation,
   		case when tvc.idfsCaseType = 10012004 then 'AvianCase' else 'LivestockCase' end as strRowType
 	  		
 	
 	from	tlbVetCase tvc
 		inner join tlbFarm tf
 			left join tlbHuman h
 			on h.idfHuman = tf.idfHuman
 		on tf.idfFarm = tvc.idfFarm
 		and tf.intRowStatus = 0
 		
 		inner join tlbHerd th
 		on th.idfFarm = tf.idfFarm
 		and th.intRowStatus = 0
 		
 		inner join tlbSpecies ts
 			inner join	fnReferenceRepair(@LangID, 19000086) SpeciesType --	rftSpeciesList
   			on			SpeciesType.idfsReference = ts.idfsSpeciesType
 			left join tlbAnimal ta
 			on ta.idfSpecies = ts.idfSpecies
 			and ta.intRowStatus = 0
 		on ts.idfHerd = th.idfHerd
 		and ts.intRowStatus = 0
 		
 		inner join	tlbMaterial tm
 			inner join @MaterialTree mtree
 			on mtree.idfMaterial = tm.idfMaterial
 			
 			inner join tlbMaterial RootMaterial
 			on RootMaterial.idfMaterial = mtree.idfRootMaterial
 			
 			inner join	fnReferenceRepair(@LangID, 19000087) SampleType --	rftSampleType
   			on			SampleType.idfsReference = RootMaterial.idfsSampleType
   			
 		on			(	(tm.idfSpecies = ts.idfSpecies and tm.idfAnimal is null)
 						or 
 						(tm.idfAnimal = ta.idfAnimal and tm.idfSpecies is null) 
 					)
 					and	tm.intRowStatus = 0
					and (tm.idfsSampleStatus in ( 
												  10015007,	-- Accessioned In
 												  10015003,  -- Marked for routine destruction
 												  10015009   -- Destroyed
												)
						or mtree.idfParentMaterial is null
						)
					
 		left join tlbTesting tt
  			inner join	tlbTestValidation ttv
  			on			ttv.idfTesting = tt.idfTesting
  						and ttv.intRowStatus = 0
  						and ttv.idfsInterpretedStatus = 10104001	--Rule In
  						
  	 		left join	fnReferenceRepair(@LangID, 19000097) TestName 
 			on			TestName.idfsReference = tt.idfsTestName
 			
  			left join	fnReferenceRepair(@LangID, 19000019) DiagnosisTV --rftDiagnosis
 			on			DiagnosisTV.idfsReference = ttv.idfsDiagnosis
 
  	 	on	tt.idfMaterial = tm.idfMaterial
  	 		and tt.intRowStatus = 0
 		
 		left join	fnReferenceRepair(@LangID, 19000019) Diagnosis1 --rftDiagnosis	
   		on			Diagnosis1.idfsReference = tvc.idfsTentativeDiagnosis
   		
 		left join	fnReferenceRepair(@LangID, 19000019) Diagnosis2 --rftDiagnosis	
   		on			Diagnosis2.idfsReference = tvc.idfsTentativeDiagnosis1
 
 		left join	fnReferenceRepair(@LangID, 19000019) Diagnosis3 --rftDiagnosis	
   		on			Diagnosis3.idfsReference = tvc.idfsTentativeDiagnosis2		
   		
 	where	tvc.strCaseID = @strCaseID 
 			and @strSessionID is null
 			and tvc.intRowStatus = 0
 	
 	union
 	
 	select 
 		dbo.fnDateCutTime(RootMaterial.datAccession) as dateDateSampleReceived,
 		isnull(h.strFirstName + ' ', '') + h.strLastName as strFarmOwner,
 		SampleType.name as strSampleTypeName,
 		SampleType.intOrder as intSampleTypeOrder,
 		SpeciesType.name as strSpeciesTypeName,
 		SpeciesType.intOrder as intSpeciesTypeOrder,
 		case
 		when	len	(	isnull(cast(	(	select distinct
			   						diag.DiagName + N', '
 		     	 					from (	select distinct Diagnosis.name as DiagName
 		     	 							from tlbMonitoringSessionToDiagnosis mstd
          									left join	fnReferenceRepair(@LangID, 19000019) Diagnosis --rftDiagnosis
          									on			Diagnosis.idfsReference = mstd.idfsDiagnosis
		 		     	 					where mstd.idfMonitoringSession = tms.idfMonitoringSession
 				     	 					and mstd.intRowStatus = 0
 				     					 ) diag
   									for	xml path('')
   									) as nvarchar(max)
   								), N', '
   					)) = 0
	   		then	N''
	   	else
 		left (isnull(cast(	(	select distinct
   						diag.DiagName + N', '
 		     	 	from (	select distinct Diagnosis.name as DiagName
 		     	 			from tlbMonitoringSessionToDiagnosis mstd
          					left join	fnReferenceRepair(@LangID, 19000019) Diagnosis --rftDiagnosis
          					on			Diagnosis.idfsReference = mstd.idfsDiagnosis
		 		     	 	where mstd.idfMonitoringSession = tms.idfMonitoringSession
 				     	 	and mstd.intRowStatus = 0
 				     	 ) diag
   					for	xml path('')
   					) as nvarchar(max)
   				), N', '),
   				len	(	isnull(cast(	(	select distinct
			   						diag.DiagName + N', '
 		     	 					from (	select distinct Diagnosis.name as DiagName
 		     	 							from tlbMonitoringSessionToDiagnosis mstd
          									left join	fnReferenceRepair(@LangID, 19000019) Diagnosis --rftDiagnosis
          									on			Diagnosis.idfsReference = mstd.idfsDiagnosis
		 		     	 					where mstd.idfMonitoringSession = tms.idfMonitoringSession
 				     	 					and mstd.intRowStatus = 0
 				     					 ) diag
   									for	xml path('')
   									) as nvarchar(max)
   								), N', '
   					)) - 1
   			)
   		end	as strPrimaryDiagnosis,
   		TestName.name as strTestName,
   		DiagnosisTV.name as strDiagnosisNameForTV,
   		RootMaterial.idfsAccessionCondition,
   		ta.strAnimalCode, 
   		ta.strName as strAnimalName,
   		RootMaterial.strBarcode as strFieldSampleID, 
   		RootMaterial.strCondition,
   		
   		tms.idfMonitoringSession as idfCaseOrSession,
   		RootMaterial.idfMaterial,
   		ts.idfSpecies,
   		ta.idfAnimal,
   		tt.idfTesting,
   		ttv.idfTestValidation,
   		'AS Session' as strRowType
   		
 	from	tlbMonitoringSession tms
 		inner join tlbFarm tf
 			left join tlbHuman h
 			on h.idfHuman = tf.idfHuman
 		on tf.idfMonitoringSession = tms.idfMonitoringSession
 		and tf.intRowStatus = 0
 		
 		inner join tlbHerd th
 		on th.idfFarm = tf.idfFarm
 		and th.intRowStatus = 0
 		
 		inner join tlbSpecies ts
 			inner join	fnReferenceRepair(@LangID, 19000086) SpeciesType --	rftSpeciesList
   			on			SpeciesType.idfsReference = ts.idfsSpeciesType
   			
 		on ts.idfHerd = th.idfHerd
 		and ts.intRowStatus = 0

		inner join tlbAnimal ta
		on ta.idfSpecies = ts.idfSpecies
		and ta.intRowStatus = 0

 		
 		inner join	tlbMaterial tm
 			inner join @MaterialTree mtree
 			on mtree.idfMaterial = tm.idfMaterial
 			
 			inner join tlbMaterial RootMaterial
 			on RootMaterial.idfMaterial = mtree.idfRootMaterial
 			
 			inner join	fnReferenceRepair(@LangID, 19000087) SampleType --	rftSampleType
   			on			SampleType.idfsReference = RootMaterial.idfsSampleType
 		on			tm.idfAnimal = ta.idfAnimal
 					and	tm.intRowStatus = 0
 					and tm.idfParentMaterial is null
 					and (tm.idfsSampleStatus in ( 
												  10015007,	-- Accessioned In
 												  10015003,  -- Marked for routine destruction
 												  10015009   -- Destroyed
												)
						or mtree.idfParentMaterial is null
						)
 					
 		left join tlbTesting tt
  			inner join	tlbTestValidation ttv
  			on			ttv.idfTesting = tt.idfTesting
  						and ttv.intRowStatus = 0
  						and ttv.idfsInterpretedStatus = 10104001	--Rule In
  						
  			left join	fnReferenceRepair(@LangID, 19000019) DiagnosisTV --rftDiagnosis
 			 on			DiagnosisTV.idfsReference = ttv.idfsDiagnosis
         
  	 		left join	fnReferenceRepair(@LangID, 19000097) TestName 
 			on			TestName.idfsReference = tt.idfsTestName
 	 	on	tt.idfMaterial = tm.idfMaterial
  	 		and tt.intRowStatus = 0	
  	 		
   							
  	 							
 	where	tms.strMonitoringSessionID = @strSessionID 
 			and @strCaseID is null
 			and tms.intRowStatus = 0
 
 	-- 13
 	declare	@comma	nvarchar(20)
 	set	@comma = N''
 	set @strDateSampleReceived = null
 	select @strDateSampleReceived = isnull(@strDateSampleReceived, '') + @comma + convert(nvarchar(20),  t.datDateSampleReceived, 104),
 		@comma = N', '
 	from (select distinct datDateSampleReceived  from @table where datDateSampleReceived is not null) as t
 
 	-- 14
 	set	@comma = N''
 	set @strSampleOwner = null
 	select @strSampleOwner = isnull(@strSampleOwner, '') + @comma + t.strFarmOwner,
 		@comma = N', '
 	from (select distinct strFarmOwner from @table where strFarmOwner is not null) as t

 	-- 15
 	set	@comma = N''
 	set @strReceivedSampleType = null
 	select @strReceivedSampleType = isnull(@strReceivedSampleType, '') + @comma + t.strSpeciesTypeName + 
 	case
 		when	len (	isnull(cast(	(	select st.strSampleTypeName + N', '
 	             	 		from	(	select  distinct
   											samples.strSampleTypeName,
   											samples.intSampleTypeOrder
 	     	 							from @table as samples
 										where samples.idfSpecies = t.idfSpecies
 	             	 				) as st
 	             	 		order by st.intSampleTypeOrder
 	  						for	xml path('') 
	   			) as nvarchar(max) ), N', ')) = 0
	   		then	N''
	   	else
 	' - ' +
	left(isnull(cast(	(	select st.strSampleTypeName + N', '
 	             	 	from	(	select  distinct
   										samples.strSampleTypeName,
   										samples.intSampleTypeOrder
 	     	 						from @table as samples
 									where samples.idfSpecies = t.idfSpecies
 	             	 			) as st
 	             	 	order by st.intSampleTypeOrder
 	  					for	xml path('') 
   			) as nvarchar(max) ), N', '),
   		len (	isnull(cast(	(	select st.strSampleTypeName + N', '
 	             	 		from	(	select  distinct
   											samples.strSampleTypeName,
   											samples.intSampleTypeOrder
 	     	 							from @table as samples
 										where samples.idfSpecies = t.idfSpecies
 	             	 				) as st
 	             	 		order by st.intSampleTypeOrder
 	  						for	xml path('') 
	   			) as nvarchar(max) ), N', ')
   			) - 1
   		)
   	end,
 		@comma = N', ' + char(13)+ char(10)
   			
 	from (select distinct idfSpecies, strSpeciesTypeName, intSpeciesTypeOrder from @table) as t
 	order by intSpeciesTypeOrder, strSpeciesTypeName
 			
 	--16
 	set	@comma = N''
 	set @strSampleNumber = null
 	select @strSampleNumber =  isnull(@strSampleNumber, '') + @comma + t.strSpeciesTypeName + ' - ' +
 		cast (count(distinct t.idfMaterial) as nvarchar(20)),
 		@comma = N', ' + char(13)+ char(10)
 	from (select distinct strSpeciesTypeName, intSpeciesTypeOrder, idfMaterial
 	      from @table where datDateSampleReceived is not null) as t
 	group by t.strSpeciesTypeName, t.intSpeciesTypeOrder
 	order by t.intSpeciesTypeOrder, t.strSpeciesTypeName
 		
 	--18
 	select top 1 @strPrimaryDiagnosis = t.strPrimaryDiagnosis 
 	from @table t
 	
 	--20
 	set	@comma = N''
 	set @strRequestedLaboratoryTests = null
 	select @strRequestedLaboratoryTests = isnull(@strRequestedLaboratoryTests, '') + @comma + t.strTestName,
 		@comma = N', '
 	from (select distinct strTestName from @table where strTestName is not null) as t
 	
 	--21
 	set	@comma = N''
 	set @strTestResult = null
 	select @strTestResult = isnull(@strTestResult, '') + @comma + t.strDiagnosisNameForTV + ' - ' + 
 		cast(count(distinct t.idfAnimal) as nvarchar(20)) + ' ' + @strPositiveResult + ' ' + @strAttachmentLink,
 		@comma = char(13)+ char(10)
 	from @table t
 	where t.strDiagnosisNameForTV is not null
 	and t.strRowType in ('AS Session', 'LivestockCase') 
 	group by t.strDiagnosisNameForTV
 	

 	set	@comma = N''
 	if	ltrim(rtrim(isnull(@strTestResult, ''))) <> N''
 		set	@comma = char(13)+ char(10)
 	select @strTestResult = isnull(@strTestResult, '') + @comma + t.strDiagnosisNameForTV + 
	case
	when	len	(	isnull(cast(	(	select sp.strSpeciesTypeName + N', '
 	             	 		from	(	select  top 1 with ties
   											species.strSpeciesTypeName,
   											species.intSpeciesTypeOrder
 	     	 							from @table as species
 										where species.strDiagnosisNameForTV = t.strDiagnosisNameForTV
 										order by row_number() over(partition by species.strSpeciesTypeName order by species.intSpeciesTypeOrder)
 	             	 				) as sp
 	             	 		order by sp.intSpeciesTypeOrder
 	  						for	xml path('') 
   				) as nvarchar(max) ), N', ')
   			) = 0
   		then	N''
   	else
	' - ' + 
 	left(isnull(cast(	(	select sp.strSpeciesTypeName + N', '
 	             	 	from	(	select  top 1 with ties
   										species.strSpeciesTypeName,
   										species.intSpeciesTypeOrder
 	     	 						from @table as species
 									where species.strDiagnosisNameForTV = t.strDiagnosisNameForTV
 									order by row_number() over(partition by species.strSpeciesTypeName order by species.intSpeciesTypeOrder)
 	             	 			) as sp
 	             	 	order by sp.intSpeciesTypeOrder
 	  					for	xml path('') 
   			) as nvarchar(max) ), N', '), 
   		len	(	isnull(cast(	(	select sp.strSpeciesTypeName + N', '
 	             	 		from	(	select  top 1 with ties
   											species.strSpeciesTypeName,
   											species.intSpeciesTypeOrder
 	     	 							from @table as species
 										where species.strDiagnosisNameForTV = t.strDiagnosisNameForTV
 										order by row_number() over(partition by species.strSpeciesTypeName order by species.intSpeciesTypeOrder)
 	             	 				) as sp
 	             	 		order by sp.intSpeciesTypeOrder
 	  						for	xml path('') 
   				) as nvarchar(max) ), N', ')
   			) - 1) + 
 	' ' + @strPositiveResult + ' ' + @strAttachmentLink
   	end,
 		@comma =  + char(13)+ char(10)
 	
 	from @table t
 	where t.strDiagnosisNameForTV is not null
 	and t.strRowType in ('AvianCase') 
 	group by t.strDiagnosisNameForTV
 
 	--22
 	set	@comma = N''
 	set @strNotes = null
 	select  @strNotes = isnull(@strNotes, '') + @comma +
 		isnull(t.strFarmOwner + ' - ', '') + t.strSpeciesTypeName + ' - ' + t.strAnimalCode + isnull(' - ' + t.strAnimalName, '') + ' - ' +
 		t.strSampleTypeName + isnull(' - ' + t.strFieldSampleID, '') + isnull(' - ' + t.strCondition, ''),
 		@comma =  char(13)+ char(10)
 	from @table t
 	where t.idfsAccessionCondition in (10108002, 10108003) -- a.	?Accepted in Poor Condition?; ?Rejected?.
 	and t.strRowType in ('AS Session', 'LivestockCase') 

 	set	@comma = N''
 	if	ltrim(rtrim(isnull(@strNotes, ''))) <> N''
 		set	@comma = char(13)+ char(10)
 	select  @strNotes = isnull(@strNotes, '') + @comma +
 		isnull(t.strFarmOwner + ' - ', '') + t.strSpeciesTypeName + ' - ' +
 		t.strSampleTypeName + isnull(' - ' + t.strFieldSampleID, '') + isnull(' - ' + t.strCondition, ''),
 		@comma = char(13)+ char(10)
 	from @table t
 	where t.idfsAccessionCondition in (10108002, 10108003) -- a.	?Accepted in Poor Condition?; ?Rejected?.
 	and t.strRowType in ('AvianCase')  	
 	
 	
 	if exists (select * from @table)
 		insert into @ReportTable 
 		(
 			 strSiteName					--3
 			,strSiteAddress					--4
 			,strPhone						--5
 			,strDate						--8
 			,strForm						--9
 			,strVersion						--10
 			,strRegNumberAndResultDate		--12
 			,strDateSampleReceived			--13
 			,strSampleOwner					--14
 			,strReceivedSampleType			--15
 			,strSampleNumber				--16
 			,strConditionSampleReceived		--17
 			,strPrimaryDiagnosis			--18
 			,strResultRecipient				--19
 			,strRequestedLaboratoryTests	--20
 			,strTestResult					--21
 			,strNotes						--22
	 		
 			,strDirector					--23
 			,strHeadOfDepartment			--24
 			----?Laboratory Research Result Attachment? Part
 			,strDiagnosis					--28
 			,strFarmOwner					--29
 			,intSpeciesTypeOrder
 			,strSpecies						--30
 			,strAnimal						--31
 		)
 		select  distinct
 			 @strSiteName					
 			,@strSiteAddress					
 			,@strPhone	
 			,@strDate
 			,@strForm
 			,@strVersion
 			,@strRegNumberAndResultDate
 			,@strDateSampleReceived			
 			,@strSampleOwner					
 			,@strReceivedSampleType			
 			,@strSampleNumber				
 			,@strConditionSampleReceived
 			,@strPrimaryDiagnosis			
 			,@strResultRecipient				
 			,@strRequestedLaboratoryTests	
 			,@strTestResult				
 			,@strNotes	
	 		
 			,@strDirector					
 			,@strHeadOfDepartment	
 			----?Laboratory Research Result Attachment? Part		
 			,t.strDiagnosisNameForTV	
 			,t.strFarmOwner
 			,t.intSpeciesTypeOrder
 			,t.strSpeciesTypeName
 			,t.strAnimalCode + isnull(' - ' + t.strAnimalName, '')
 		from @table t
 		order by t.strDiagnosisNameForTV, t.strFarmOwner, t.intSpeciesTypeOrder, t.strSpeciesTypeName, t.strAnimalCode + isnull(' - ' + t.strAnimalName, '')
	else
		insert into @ReportTable 
 		(
 			 strSiteName					--3
 			,strSiteAddress					--4
 			,strPhone						--5
 			,strDate						--8
 			,strForm						--9
 			,strVersion						--10
  		
 			,strDirector					--23
 			,strHeadOfDepartment			--24
 
 		)
 		select 
 			 @strSiteName					
 			,@strSiteAddress					
 			,@strPhone	
 			,@strDate
 			,@strForm
 			,@strVersion
	 		
 			,@strDirector					
 			,@strHeadOfDepartment	

 
 	
 	
 	select 
 	 	 strSiteName					--3
 		,strSiteAddress					--4
 		,strPhone						--5
 		,strDate						--8
 		,strForm						--9
 		,strVersion						--10
 		,strRegNumberAndResultDate		--12
 		,strDateSampleReceived			--13
 		,strSampleOwner					--14
 		,strReceivedSampleType			--15
 		,strSampleNumber				--16
 		,strConditionSampleReceived		--17
 		,strPrimaryDiagnosis			--18
 		,strResultRecipient				--19
 		,strRequestedLaboratoryTests	--20
 		,strTestResult					--21
 		,strNotes						--22
 		
 		,strDirector					--23
 		,strHeadOfDepartment			--24
 		----?Laboratory Research Result Attachment? Part
 		,intRow							--27
 		,strDiagnosis					--28
 		,strFarmOwner					--29
 		,strSpecies						--30
 		,strAnimal						--31
 	from @ReportTable 
 	order by intRow


