

--##SUMMARY Select data for Antibiotic Resistance.
--##REMARKS Author: 
--##REMARKS Create date: 25.09.2014

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepLabTestingResultAZ_test 'ru', 'SWAZ160001', null, 871
exec spRepLabTestingResultAZ 'ru', 'SWAZ160001', null, 871
*/

CREATE  procedure [dbo].[spRepLabTestingResultAZ]
	(
		@LangID		as nvarchar(10), 
		@SampleID	as varchar(36),
		@DepartmentID  as bigint,
		@SiteID as bigint = null
	)
AS	

-- Field description may be found here
-- https://95.167.107.114/BTRP/Project_Documents/08x-Implementation/Customizations/AJ/AJ Customization_Phase_2/Reports/Laboratory testing results/Specification for reportdevelopment -Laboratory testing results.docx
-- by number marked red at screen form prototype 


declare	@ReportTable 	table
(	
	strCaseId				nvarchar(200) collate database_default null, --1
	strReceivedOrganizationNameAddress	nvarchar(2000) collate database_default null, --14
	strPatientName			nvarchar(2000) collate database_default null,--5
	strSex					nvarchar(200) collate database_default null, --6
	datDateOfBirth			datetime null,	   --7
	strAge		 			nvarchar(200) collate database_default null, --8
	strAddress 				nvarchar(4000) collate database_default null,--9
	strDiagnosis 			nvarchar(2000) collate database_default null, --4
	strSampleId 			nvarchar(200) collate database_default null, --17
	strSampleType 			nvarchar(2000) collate database_default null, --10
	strTestName 			nvarchar(2000) collate database_default null, --19
	strResult				nvarchar(2000) collate database_default null, --20
	datFooterDate			datetime null,	   --
	
	--- new fields
	
	datCollectionDate		datetime null,	   --11
	strSentOrganizationNameAddress	nvarchar(2000) collate database_default null, --12
	datSentDate				datetime null,	   --13
	datAccessionDate		datetime null,	   --15
	strSampleConditionReceived	nvarchar(2000) collate database_default null, --16
	datResultDate			datetime null,	   --21
	strTestedBy				nvarchar(2000) collate database_default null --22
)	

-- Report informative part

declare	@MaterialTable 	table
(	idfMaterial				bigint not null primary key,
	idfRootMaterial			bigint null,
	idfParentMaterial		bigint null,
	strCaseId				nvarchar(200) collate database_default null, --
	strPatientName			nvarchar(2000) collate database_default null,--
	strSex					nvarchar(200) collate database_default null, --
	datDateOfBirth			datetime null,	   --
	strAge		 			nvarchar(200) collate database_default null, --
	strAddress 				nvarchar(4000) collate database_default null,--
	strDiagnosis 			nvarchar(2000) collate database_default null, --
	strSampleId 			nvarchar(200) collate database_default null, --
	strSampleType 			nvarchar(2000) collate database_default null, --
	
	datCollectionDate		datetime null,	   --11
	strSentOrganizationNameAddress	nvarchar(2000) collate database_default null, --12
	datSentDate				datetime null,	   --13
	datAccessionDate		datetime null,	   --15
	strSampleConditionReceived	nvarchar(2000) collate database_default null, --16
	datResultDate			datetime null,	   --21
	strTestedBy				nvarchar(2000) collate database_default null --22

)	

-- Header

declare	@CurrentCountry	nvarchar(2000)
select		@CurrentCountry = r_c.[name]
from		gisCountry c
inner join	fnGisReference(@LangID, 19000001) r_c
on			r_c.idfsReference = c.idfsCountry
where		c.intRowStatus = 0
			and c.idfsCountry = dbo.fnCurrentCountry()

declare	@RayonID	bigint
declare	@RegionID	bigint
declare	@OrganizationID_GenerateReport	bigint
declare	@OrganizationName_GenerateReport	nvarchar(2000)

select		@OrganizationID_GenerateReport = i.idfOffice,
			@OrganizationName_GenerateReport = i.[name],
			@RegionID = gls.idfsRegion,
			@RayonID = gls.idfsRayon
from		fnInstitutionRepair(@LangID) i
inner join	tstSite s
on			s.idfOffice = i.idfOffice
left join	tlbGeoLocationShared gls
on			gls.idfGeoLocationShared = i.idfLocation
where		s.idfsSite = @SiteID

if	@OrganizationName_GenerateReport is null
	set	@OrganizationName_GenerateReport = N''


declare	@Header	nvarchar(4000)
set	@Header = N''


declare	@Rayon_Name				nvarchar(2000)
select		@Rayon_Name = r_ray.[name],
			@RegionID = 
			case
				when	@RegionID is null
					then	ray.idfsRayon
				else	@RegionID
			end
from		fnGisReference(@LangID, 19000002) r_ray /*Rayon*/
inner join	gisRayon ray
on			ray.idfsRayon = r_ray.idfsReference
where		r_ray.idfsReference = @RayonID
if	@Rayon_Name is null
	set	@Rayon_Name = N''


declare	@Region_Name			nvarchar(2000)
declare	@Hide_Region			bit
select		@Region_Name = r_reg.[name],
			@Hide_Region =
			case
				when	gis_bra.idfGISBaseReferenceAttribute is null
					then	cast(0 as bit)
				else	cast(1 as bit)
			end
from		fnGisReference(@LangID, 19000003) r_reg /*Region*/
left join	trtGISBaseReferenceAttribute gis_bra
	inner join	trtAttributeType at
	on			at.idfAttributeType = gis_bra.idfAttributeType
				and at.strAttributeTypeName = N'hide_region_from_report_header'
on			gis_bra.idfsGISBaseReference = r_reg.idfsReference
			and gis_bra.strAttributeItem = N'AZ Human Lab Reports'
			and cast(gis_bra.varValue as nvarchar) = cast(N'AZ Human Lab Reports' as nvarchar(20))
where		r_reg.idfsReference = @RegionID
if	@Region_Name is null
	set	@Region_Name = N''
if	@Hide_Region is null
	set	@Hide_Region = 1

declare	@Region_Rayon_Info	nvarchar(4000)
set	@Region_Rayon_Info = N''

if @RegionID is null
	set	@Region_Rayon_Info = N''
else if @RegionID is not null and (@RayonID is null	or ltrim(rtrim(@Rayon_Name)) = N'')
begin
	set	@Region_Rayon_Info = isnull(@Region_Name, N'')
end
else if @RegionID is not null and @RayonID is not null and ltrim(rtrim(@Rayon_Name)) <> N''
begin
	if	@Hide_Region = 1
		set	@Region_Rayon_Info = isnull(@Rayon_Name, N'')
	else
		set	@Region_Rayon_Info = isnull(@Region_Name, N'') + N', ' + isnull(@Rayon_Name, N'')
end


if rtrim(ltrim(@Region_Rayon_Info)) = N'' or @OrganizationID_GenerateReport is null
begin
	set	@Header = @OrganizationName_GenerateReport
end
else if rtrim(ltrim(@Region_Rayon_Info)) <> N'' and @OrganizationID_GenerateReport is not null
begin
	set	@Header = @OrganizationName_GenerateReport + N', ' + @Region_Rayon_Info
end


-- Report informative part


insert into	@MaterialTable
(	idfMaterial,
	idfRootMaterial,
	idfParentMaterial,
	strCaseId,
	strPatientName,
	strSex,
	datDateOfBirth,
	strAge,
	strAddress,
	strDiagnosis,
	strSampleId,
	strSampleType,
	
	--new fields
	datCollectionDate,
	strSentOrganizationNameAddress,
	datSentDate,
	datAccessionDate,
	strSampleConditionReceived
)
select		m.idfMaterial,
			m.idfRootMaterial,
			m.idfParentMaterial,
			isnull(hc.strCaseID, N''),
			dbo.fnConcatFullName(h.strLastName, h.strFirstName, h.strSecondName),
			isnull(r_ps.[name], N''),
			h.datDateofBirth,
			case
				when	hc.intPatientAge is not null and r_hat.[name] is not null
					then	cast(hc.intPatientAge as nvarchar(20)) + isnull(N' (' + r_hat.[name] + N')', N'')
				else	null
			end,
			r_cnt.name + 
				isnull(', ' + case when gis_HideReg.idfGISBaseReferenceAttribute is not null then null else r_reg.name end, '' ) +
				isnull(', ' + r_ray.name, '') 
			,
			isnull(r_d.[name], N''),
			isnull(m.strBarcode, N''),
			isnull(r_st.[name], N''),
			
			--new fields
			m.datFieldCollectionDate,
			case when m.idfParentMaterial is null 
					then sentByOffice.name
					else trOut_SendFromOffice.name
			end as strSentOrganizationNameAddress,
			m.datFieldSentDate,
			m.datAccession,
			acsCond.name as strSampleConditionReceived
			
from		tlbMaterial m

inner join	tlbHuman h
	left join	fnReferenceRepair(@LangID, 19000043) r_ps	/*Human Gender*/
	on			r_ps.idfsReference = h.idfsHumanGender
	left join	tlbGeoLocation gl
	on			gl.idfGeoLocation = h.idfCurrentResidenceAddress
	--left join	fnGeoLocationTranslation(@LangID) glt
	--on			glt.idfGeoLocation = h.idfCurrentResidenceAddress
	left join fnGisReference(@LangID, 19000001) r_cnt /*Country*/
	on r_cnt.idfsReference = gl.idfsCountry
	
	left join fnGisReference(@LangID, 19000002) r_ray /*Rayon*/
	on r_ray.idfsReference = gl.idfsRayon
	
	left join fnGisReference(@LangID, 19000003) r_reg /*Region*/
		left join	trtGISBaseReferenceAttribute gis_HideReg
			inner join	trtAttributeType at
			on			at.idfAttributeType = gis_HideReg.idfAttributeType
						and at.strAttributeTypeName = N'hide_region_from_report_header'
		on			gis_HideReg.idfsGISBaseReference = r_reg.idfsReference
					and gis_HideReg.strAttributeItem = N'AZ Human Lab Reports'
					and cast(gis_HideReg.varValue as nvarchar) = cast(N'AZ Human Lab Reports' as nvarchar(20))
	on r_reg.idfsReference = gl.idfsRegion
	
	
	
on			h.idfHuman = m.idfHuman
inner join	tlbHumanCase hc
	left join	fnReferenceRepair(@LangID, 19000019) r_d /*Diagnosis*/
	on			r_d.idfsReference = isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)
	left join	fnReferenceRepair(@LangID, 19000042) r_hat	/*Human Age Type*/
	on			r_hat.idfsReference = hc.idfsHumanAgeType	
on			hc.idfHuman = h.idfHuman
			and hc.intRowStatus = 0

inner join	fnReferenceRepair(@LangID, 19000087) r_st	/*Sample Type*/
on			r_st.idfsReference = m.idfsSampleType

left join dbo.fnInstitution(@LangID) sentByOffice
on sentByOffice.idfOffice = hc.idfSentByOffice

left join tlbMaterial parentMaterial
	left join tlbTransferOutMaterial ttom
		inner join tlbTransferOUT tto
		on tto.idfTransferOut = ttom.idfTransferOut
		left join dbo.fnInstitution(@LangID) trOut_SendFromOffice
		on trOut_SendFromOffice.idfOffice = tto.idfSendFromOffice
	on ttom.idfMaterial = parentMaterial.idfMaterial
on parentMaterial.idfMaterial = m.idfParentMaterial

left join dbo.fnReferenceRepair(@LangID, 19000110) acsCond
on acsCond.idfsReference = m.idfsAccessionCondition

where		m.intRowStatus = 0
			and m.idfsCurrentSite = @SiteID /*Sample belongs to current laboratory*/
			and m.idfsSampleType <> 10320001 /*Unknown*/
			and isnull(m.blnReadOnly, 0) <> 1 /*It is not copy of another sample*/
			and isnull(m.idfsAccessionCondition,0) <> 10108003 /*Rejected*/
			and m.strBarcode = @SampleID /*Sample has specified Lab ID*/


declare	@ChildMaterials	table
(	idfRootMaterial		bigint null,
	idfMaterial			bigint not null primary key,
	idfParentMaterial	bigint null	
)

insert into	@ChildMaterials
(
	idfRootMaterial,
	idfMaterial,
	idfParentMaterial
)
select		mt.idfRootMaterial,
			mt.idfMaterial,
			mt.idfParentMaterial
from		@MaterialTable mt
	inner join tlbMaterial m
	on m.idfMaterial = mt.idfMaterial
	and (m.idfInDepartment = @DepartmentID or @DepartmentID is null)
	

declare	@rowaffected	int
set	@rowaffected = 1

while	@rowaffected > 0
begin
	insert into	@ChildMaterials
	(
		idfRootMaterial,
		idfMaterial,
		idfParentMaterial
	)
	select	distinct
				m.idfRootMaterial,
				m.idfMaterial,
				m.idfParentMaterial
	from		tlbMaterial m
	left join	tstSite s
	on			s.idfsSite = m.idfsSite
	inner join	@ChildMaterials cm_parent
	on			cm_parent.idfMaterial = m.idfParentMaterial
	left join	@ChildMaterials cm_ex
	on			cm_ex.idfMaterial = m.idfMaterial
	where		m.intRowStatus = 0
				and (m.idfInDepartment = @DepartmentID or @DepartmentID is null)
				and (isnull(m.blnAccessioned, 0) = 0 or s.idfsSite = @SiteID)
				and cm_ex.idfMaterial is null

	set	@rowaffected = @@rowcount
end


insert into	@ReportTable
(	strCaseId,
	strReceivedOrganizationNameAddress,
	strPatientName,
	strSex,
	datDateOfBirth,
	strAge,
	strAddress,
	strDiagnosis,
	strSampleId,
	strSampleType,
	strTestName,
	strResult,
	datFooterDate,
	
	--new fields
	datCollectionDate,	   --11
	strSentOrganizationNameAddress, --12
	datSentDate,	   --13
	datAccessionDate,	   --15
	strSampleConditionReceived, --16
	datResultDate,	   --21
	strTestedBy	--22
)
select		mt.strCaseId,
			@Header,
			mt.strPatientName,
			mt.strSex,
			mt.datDateOfBirth,
			mt.strAge,
			mt.strAddress,
			mt.strDiagnosis,
			mt.strSampleId,
			mt.strSampleType,
			r_tn.[name],
			r_tr.[name],
			null,
			
			mt.datCollectionDate,
			mt.strSentOrganizationNameAddress,
			mt.datSentDate,
			mt.datAccessionDate,
			mt.strSampleConditionReceived,
			t.datConcludedDate,
			case 
				when isnull(t.blnExternalTest, 0) = 0 then dbo.fnConcatFullName(p_TestedBy.strFamilyName, p_TestedBy.strFirstName, p_TestedBy.strSecondName)
				when t.blnExternalTest = 1 then o_ResultReceivedFrom.name + isnull(', ' + t.strContactPerson, '')
				else null
			end as strTestedBy
from		@MaterialTable mt
left join	tlbTesting t
	left join tlbPerson p_TestedBy
	on p_TestedBy.idfPerson = t.idfTestedByPerson

	left join dbo.fnInstitution(@LangID) o_ResultReceivedFrom
	on o_ResultReceivedFrom.idfOffice = t.idfPerformedByOffice
	
	inner join	fnReferenceRepair(@LangID, 19000097) r_tn /*Test Name*/
	on			r_tn.idfsReference = t.idfsTestName
	left join	fnReferenceRepair(@LangID, 19000096) r_tr /*Test Result*/
	on			r_tr.idfsReference = t.idfsTestResult
on			t.intRowStatus = 0
			and isnull(t.blnNonLaboratoryTest, 0) <> 1 /*Laboratory Test*/
			and isnull(t.blnReadOnly, 0) <> 1 /*It is not copy of another test*/
			/*Test belongs to any child of the sample or it is external result for the sample transferred to not EIDSS laboratory*/
			and exists	(
					select	*
					from	@ChildMaterials cm
					where	cm.idfMaterial = t.idfMaterial
						)
			/*Test Status is Final or Amended*/
			and (	t.idfsTestStatus = 10001001	/*Final*/
					or	t.idfsTestStatus = 10001006 /*Amended*/
				)
	
if	exists	(
		select	*
		from	@ReportTable
			)
begin
	select 
		strCaseId,
		strReceivedOrganizationNameAddress,
		strPatientName,
		strSex,
		datDateOfBirth,
		strAge,
		strAddress,
		strDiagnosis,
		strSampleId,
		strSampleType,
		strTestName,
		strResult,
		datFooterDate,
		
		--new fields
		datCollectionDate,	   --11
		strSentOrganizationNameAddress, --12
		datSentDate,	   --13
		datAccessionDate,	   --15
		strSampleConditionReceived, --16
		datResultDate,	   --21
		strTestedBy	--22
	from @ReportTable
end
else if	exists	(
			select	*
			from	@MaterialTable
				)
begin	
	select		mt.strCaseId,
				@Header as strReceivedOrganizationNameAddress,
				mt.strPatientName,
				mt.strSex,
				mt.datDateOfBirth,
				mt.strAge,
				mt.strAddress,
				mt.strDiagnosis,
				mt.strSampleId,
				mt.strSampleType,
				cast(null as nvarchar) as strTestName,
				cast(null as nvarchar) as strResult,
				cast(null as date) as datFooterDate,
				
				--new fields
				mt.datCollectionDate,	   --11
				mt.strSentOrganizationNameAddress, --12
				mt.datSentDate,	   --13
				mt.datAccessionDate,	   --15
				mt.strSampleConditionReceived, --16
				cast(null as date) as datResultDate,	   --21
				cast(null as nvarchar) as strTestedBy	--22
	
	from		@MaterialTable mt	
end
else
begin
	select		'' as strCaseId,
				@Header as strReceivedOrganizationNameAddress,
				'' as strPatientName,
				'' as strSex,
				cast(null as date) as datDateOfBirth,
				'' as strAge,
				'' as strAddress,
				'' as strDiagnosis,
				'' as strSampleId,
				'' as strSampleType,
				cast(null as nvarchar) as strTestName,
				cast(null as nvarchar) as strResult,
				cast(null as date) as datFooterDate,
				
				--new fields
				cast(null as date) as datCollectionDate,	   --11
				cast(null as nvarchar) as strSentOrganizationNameAddress, --12
				cast(null as date) as datSentDate,	   --13
				cast(null as date) as datAccessionDate,	   --15
				cast(null as nvarchar) as strSampleConditionReceived, --16
				cast(null as date) as datResultDate,	   --21
				cast(null as nvarchar) as strTestedBy	--22
				
				
				
end

