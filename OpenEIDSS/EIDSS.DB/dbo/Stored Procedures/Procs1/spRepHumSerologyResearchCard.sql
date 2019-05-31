

--##SUMMARY Select data for Serology Research Card .
--##REMARKS Author: 
--##REMARKS Create date: 17.01.2011

--##REMARKS UPDATED BY: Romasheva S.
--##REMARKS Date: 17.07.2014


--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepHumSerologyResearchCard @LangID=N'en',@SampleID='S070140007'

*/

create  Procedure [dbo].[spRepHumSerologyResearchCard]
	(
		@LangID		as nvarchar(10), 
		@SampleID	as varchar(36),	 
		@LastName	as nvarchar(200) = null,
		@FirstName	as nvarchar(200) = null,
		@SiteID		as bigint = null
	)
AS	

-- Field description may be found here
-- "https://repos.btrp.net/BTRP/Project_Documents/08x-Implementation/Customizations/GG/Reports/Specification for report development - Serology Research Card Human GG v1.0.doc"
-- by number marked red at screen form prototype 

declare	@ReportTable 	table
(	idfTesting				bigint,
	strSiteName				nvarchar(200), --1
	strSiteAddress			nvarchar(200), --2
	strSampleId				nvarchar(200), --4
	datSampleReceived		datetime,	   --5
	datSampleCollected		datetime,	   --6
	strNameSurname			nvarchar(200), --8
	strAge					nvarchar(200), --9
	strResearchedSample		nvarchar(200), --10
	strSampleReceivedFrom	nvarchar(200), --11
	strResearchMethod		nvarchar(200), --13
	strResearchedDiagnosis	nvarchar(200), --14
	strResultReceived		nvarchar(200), --15
	strNorm					nvarchar(200), --16
	strDiagnosticalMeaning	nvarchar(200), --17
	strResearchConductedBy	nvarchar(max), --19
	strResponsiblePerson		nvarchar(2000),--20
	datResultDate			datetime,	   --21
	
	strKey					nvarchar(200) -- it need's for merge with archive data in application
	
)	
declare
	@idfsOffice				bigint,
	@strOfficeName			nvarchar(200),
	@strOfficeLocation		nvarchar(200),
	@idfsCustomReportType	bigint,
	@tel					nvarchar(10)
  
declare	
	@FFResultReceived	bigint,
	@FFNorm				bigint
  
if @SiteID is null set @SiteID = dbo.fnSiteID() 

set @idfsCustomReportType = 10290014 -- GG Serology Research Result

select @FFResultReceived = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ffp_ResultReceived'
and intRowStatus = 0

select @FFNorm = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'ffp_Norm'
and intRowStatus = 0  
  

  
select	@tel = IsNull(RTrim(r.[name]) + N' ', N'')
from	fnReferenceRepair(@LangID, 19000132) r -- Additional report Text
where	r.strDefault = N'Tel.:'

  
select 
	@idfsOffice = o.idfOffice,
	@strOfficeLocation = isnull(dbo.fnAddressSharedString(@LangID, o.idfLocation), '') + isnull(', ' + @tel + o.strContactPhone, ''),
	@strOfficeName = fni.[name]
from	tstSite s
	inner join	tlbOffice o
	on			o.idfOffice = s.idfOffice
	inner join	fnInstitution(@LangID) fni
	on			o.idfOffice = fni.idfOffice
where	 s.idfsSite = @SiteID



INSERT INTO @ReportTable (
	idfTesting				,
	strSiteName				, --1
	strSiteAddress			, --2
	strSampleId				, --4
	datSampleReceived		, --5
	datSampleCollected		, --6
	strNameSurname			, --8
	strAge					, --9
	strResearchedSample		, --10
	strSampleReceivedFrom	, --11
	strResearchMethod		, --13
	strResearchedDiagnosis	, --14
	strResultReceived		, --15
	strNorm					, --16
	strDiagnosticalMeaning	, --17
	strResearchConductedBy	, --19
	strResponsiblePerson	, --20
	datResultDate			, --21
	
	strKey
) 

select
	testing.idfTesting,
	@strOfficeName,			--1
	@strOfficeLocation,		--2
	m.strBarcode,				--strSampleId --4
	m.datAccession,			--datSampleReceived	--5
	m.datFieldCollectionDate, --datSampleCollected --6
	ISNULL(h.strFirstName + ' ', '') + ISNULL(h.strLastName,''), --strNameSurname--8
	CAST(hc.intPatientAge AS NVARCHAR(10)) + N' (' + ref_age.[name] + N')', --strAge --9
	SampleType.[name],      --strResearchedSample --10
	CollectedByOffice.[name], --strSampleReceivedFrom --11
	TestName.[name],    --strResearchMethod --13
	TestDiagnosis.[name],   --strResearchedDiagnosis --14
	cast(ap_ResultRec.varValue as nvarchar(200)), --strResultReceived --15
	cast(ap_Norm.varValue as nvarchar(200)), --strNorm --16
	TestResult.[name],  --strDiagnosticalMeaning	, --17
	
  	cast(	(	select 
			 isnull(t.strFirstName + ' ', '') + ISNULL(t.strFamilyName, '') + N', '
     	 	from
     	 	(
     	 			select top 1 with ties
     	 				prcb.strFirstName,
     	 				prcb.strFamilyName,
     	 				Diagnosis.[name] as DiagnosisName,
     	 				test.datConcludedDate,
     	 				tn.[name] as TestName
				from tlbTesting test 
					inner join	trtTestTypeForCustomReport ttfcr
					on		ttfcr.idfsTestName = test.idfsTestName
					and		ttfcr.intRowStatus = 0
					and		ttfcr.idfsCustomReportType = @idfsCustomReportType

					left join	fnReference(@LangID,19000019) Diagnosis
					on		test.idfsDiagnosis = Diagnosis.idfsReference

					left join	fnReference(@LangID,19000097) tn
					on			test.idfsTestName = tn.idfsReference		
	            	        
					left join	( tlbEmployee ercb
							inner join	tlbPerson prcb
							on			prcb.idfPerson = ercb.idfEmployee
					)
					on		ercb.idfEmployee = test.idfTestedByPerson	
					and		ercb.intRowStatus = 0	
				where test.idfMaterial = m.idfMaterial
					and test.blnNonLaboratoryTest = 0
  					and test.blnExternalTest = 0
  					and test.blnReadOnly = 0
					and test.intRowStatus = 0
				order by row_number() over(partition by prcb.strFirstName, prcb.strFamilyName order by test.datConcludedDate, tn.[name], Diagnosis.[name])

     	 	) as t
     	 	order by t.datConcludedDate, t.TestName, t.DiagnosisName
		for	xml path('')
		) as nvarchar(max)
	)	as strResearchConductedBy, --  strResearchConductedBy --19
  
	(	select top 1
  				 isnull(prcb.strFirstName + ' ', '') + ISNULL(prcb.strFamilyName, '')
  				from tlbTesting t 
  					inner join trtTestTypeForCustomReport ttfcr
					on  ttfcr.idfsTestName = t.idfsTestName
						and ttfcr.intRowStatus = 0
						and ttfcr.idfsCustomReportType = @idfsCustomReportType
				  						        
  					left join	( tlbEmployee ercb
  							inner join	tlbPerson prcb
  							on			prcb.idfPerson = ercb.idfEmployee
  					)
  					on		ercb.idfEmployee = t.idfValidatedByPerson
  					and		ercb.intRowStatus = 0	
  						          			    
         	 		where	t.idfMaterial = m.idfMaterial
         	 				and t.blnNonLaboratoryTest = 0
  							and t.blnExternalTest = 0
  							and t.blnReadOnly = 0
  							and t.intRowStatus = 0
	 	order by t.datConcludedDate, t.idfTesting desc
	)	as strResponsiblePerson, --  strResponsiblePerson --20
  
  
	(	select top 1
  				 t.datConcludedDate 
  				from tlbTesting t 
  					inner join trtTestTypeForCustomReport ttfcr
					on  ttfcr.idfsTestName = t.idfsTestName
						and ttfcr.intRowStatus = 0
						and ttfcr.idfsCustomReportType = @idfsCustomReportType
				          			    
         	 		where	t.idfMaterial = m.idfMaterial
         	 				and t.blnNonLaboratoryTest = 0
  							and t.blnExternalTest = 0
  							and t.blnReadOnly = 0
  							and t.intRowStatus = 0
	 	order by t.datConcludedDate, t.idfTesting desc
	)	as datResultDate, --datResultDate --21
  
  
  convert(nvarchar(20), isnull(testing.datConcludedDate, testing.datStartedDate), 112)  + '_' + Cast(testing.idfTesting as nvarchar(50)) as strKey -- it need's for merge with archive data in application



from tlbMaterial m
	inner join	fnReferenceRepair(@LangID, 19000087) SampleType	-- Sample Type
	on			SampleType.idfsReference = m.idfsSampleType

	left join	fnInstitution(@LangID) CollectedByOffice
	on			CollectedByOffice.idfOffice = m.idfFieldCollectedByOffice
	
	left join	fnDepartment(@LangID) dep
	on			dep.idfDepartment = m.idfInDepartment

	inner join	( tlbHumanCase hc
					left join	fnReferenceRepair(@LangID, 19000042) ref_age	-- Human Age Type
					on			ref_age.idfsReference = hc.idfsHumanAgeType
				    
					left join	fnReferenceRepair(@LangID,19000019) ref_diag_c
					on			COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = ref_diag_c.idfsReference
				)
	on		hc.idfHumanCase = m.idfHumanCase
	and		hc.intRowStatus = 0
			
	inner join	tlbHuman h
	on			h.idfHuman = m.idfHuman
	and			h.intRowStatus = 0

	inner join (tlbTesting testing 
            inner join trtTestTypeForCustomReport ttfcr
            on  ttfcr.idfsTestName = testing.idfsTestName
                and ttfcr.intRowStatus = 0
                and ttfcr.idfsCustomReportType = @idfsCustomReportType
                
            left join tlbBatchTest tbt
            on tbt.idfBatchTest = testing.idfBatchTest
            and tbt.intRowStatus = 0
            
            left join tlbObservation BatchObs
			on BatchObs.idfObservation = tbt.idfObservation
			and BatchObs.intRowStatus = 0
			            
			left join tlbObservation TestObs
			on TestObs.idfObservation = testing.idfObservation
			and TestObs.intRowStatus = 0
			
			left join tlbActivityParameters ap_ResultRec
			on ap_ResultRec.idfObservation = TestObs.idfObservation
			and ap_ResultRec.intRowStatus = 0
			and ap_ResultRec.idfsParameter = @FFResultReceived
			
			left join tlbActivityParameters ap_Norm
			on ap_Norm.idfObservation = BatchObs.idfObservation
			and ap_Norm.intRowStatus = 0
			and ap_Norm.idfsParameter = @FFNorm		
         			
            left join	fnReference(@LangID,19000097) TestName
            on			testing.idfsTestName=TestName.idfsReference			   

            left join	fnReference(@LangID,19000019) TestDiagnosis
            on			testing.idfsDiagnosis = TestDiagnosis.idfsReference

	        left join	fnReferenceRepair (@LangID, 19000096) TestResult
	        on			testing.idfsTestResult = TestResult.idfsReference
	) 
	on	testing.idfMaterial = m.idfMaterial 
		and testing.blnNonLaboratoryTest = 0
  		and testing.blnExternalTest = 0
  		and testing.blnReadOnly = 0
		and testing.intRowStatus = 0
           
where	
		m.strBarcode = @SampleID
		and m.idfsSite = @SiteID
		and ((h.strLastName like @LastName + '%') OR IsNull(@LastName, N'') = N'')
		and ((h.strFirstName like @FirstName + '%') OR IsNull(@FirstName, N'') = N'')

order by isnull(testing.datConcludedDate, testing.datStartedDate), testing.idfTesting



update	@ReportTable
set		strResearchConductedBy = substring(ltrim(rtrim(strResearchConductedBy)), 0, LEN(ltrim(rtrim(strResearchConductedBy))))
where	ltrim(rtrim(strResearchConductedBy)) like N'%,'


if not exists (select * from @ReportTable)
begin
  insert into @ReportTable (strSiteName, strSiteAddress)
  values  (@strOfficeName, @strOfficeLocation)
end

    

select 	
	idfTesting				,
	strSiteName				, --1
	strSiteAddress			, --2
	strSampleId				, --4
	datSampleReceived		, --5
	datSampleCollected		, --6
	strNameSurname			, --8
	strAge					, --9
	strResearchedSample		, --10
	strSampleReceivedFrom	, --11
	strResearchMethod		, --13
	strResearchedDiagnosis	, --14
	strResultReceived		, --15
	strNorm					, --16
	strDiagnosticalMeaning	, --17
	strResearchConductedBy	, --19
	strResponsiblePerson	, --20
	datResultDate			, --21
	
	strKey
 
from @ReportTable
order by strKey




