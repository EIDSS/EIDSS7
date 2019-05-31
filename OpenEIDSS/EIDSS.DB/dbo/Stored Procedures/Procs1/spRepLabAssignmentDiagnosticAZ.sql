

--##SUMMARY Select data for Antibiotic Resistance.
--##REMARKS Author: 
--##REMARKS Create date: 25.09.2014

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepLabAssignmentDiagnosticAZ 'ru', 'HWEB00160095', 12100590000000

*/

CREATE  Procedure [dbo].[spRepLabAssignmentDiagnosticAZ]
	(
		@LangID		as nvarchar(10), 
		@CaseID		as varchar(36),
		@SentToID	as bigint,
		@SiteID		as bigint = null
	)
AS	

-- Field description may be found here
--https://95.167.107.114/BTRP/Project_Documents/08x-Implementation/Customizations/AJ/AJ Customization EIDSS v6/Reports/Assignment for Laboratory Diagnostic/Specification for reportdevelopment - Assignment for Laboratory Diagnostic.docx
-- by number marked red at screen form prototype 

declare	@ReportTable 	table
(	
--- new fields
	strSentOrganizationNameAddress	nvarchar(4000) collate database_default null, --3
	strCaseHistoryPatientCardID nvarchar(4000) collate database_default null, --5
	strTestForDisease 			nvarchar(2000) collate database_default null, --1 from footer
	
	strReferringPhysiciansName  nvarchar(2000) collate database_default null, --12
--- old fields
	strReceivedOrganizationNameAddress	nvarchar(4000) collate database_default null, --4
	strPatientName			nvarchar(2000) collate database_default null,--6
	strSex					nvarchar(200) collate database_default null, --7
	datDateOfBirth			datetime null,	   --8
	strAge		 			nvarchar(200) collate database_default null, --9
	strAddress 				nvarchar(4000) collate database_default null,--10
	strDiagnosis 			nvarchar(2000) collate database_default null, --11
	strSampleId 			nvarchar(200) collate database_default null, --14
	strSampleType 			nvarchar(2000) collate database_default null, --13
	datSampleCollectedDate	datetime null,	   --15
	datSampleSentDate		datetime null	   --16
	
)

declare
	@strSentOrganizationNameAddress nvarchar(2000)
	



insert into	@ReportTable
(	
	
	strSentOrganizationNameAddress,
	strCaseHistoryPatientCardID,
	strTestForDisease,
	strReferringPhysiciansName,
	
	strReceivedOrganizationNameAddress,
	strPatientName,
	strSex,
	datDateOfBirth,
	strAge,
	strAddress,
	strDiagnosis,
	strSampleId,
	strSampleType,
	datSampleCollectedDate,
	datSampleSentDate
)
select	
			notf_sent_by.name,
			null as strCaseHistoryPatientCardID,
			dbo.fnConcatFullName(sent_by_empl.strFamilyName, sent_by_empl.strFirstName, sent_by_empl.strSecondName),
			null as strReferringPhysiciansName,
			
			m_i_sent_to.name as strSentOrganizationNameAddress,
			dbo.fnConcatFullName(h.strLastName, h.strFirstName, h.strSecondName),
			isnull(r_ps.[name], N''),
			h.datDateofBirth,
			case
				when	hc.intPatientAge is not null and r_hat.[name] is not null
					then	cast(hc.intPatientAge as nvarchar(20)) + isnull(N' (' + r_hat.[name] + N')', N'')
				else	null
			end,
			
			case
				when	ltrim(rtrim(isnull(r_ray_cr.[name], N''))) <> N''
						and gis_bra.idfsGISBaseReference is null
						and ltrim(rtrim(isnull(r_reg_cr.[name], N''))) <> N''
					then	r_countr_cr.name  + N', ' +  r_reg_cr.[name] + N', ' + r_ray_cr.[name]
				when	ltrim(rtrim(isnull(r_ray_cr.[name], N''))) <> N''
						and (	gis_bra.idfsGISBaseReference is not null
								or	ltrim(rtrim(isnull(r_reg_cr.[name], N''))) = N''
							)
					then	r_countr_cr.name  + N', ' +  r_ray_cr.[name]
				when	ltrim(rtrim(isnull(r_ray_cr.[name], N''))) = N''
						and ltrim(rtrim(isnull(r_reg_cr.[name], N''))) <> N''
					then	r_countr_cr.name  + N', ' +  r_reg_cr.[name]															 
				else	''
			end
			
			
			,
			isnull(r_d.[name], N''),
			isnull(m.strFieldBarcode, N''),
			isnull(r_st.[name], N''),
			m.datFieldCollectionDate,
			m.datFieldSentDate
from		tlbHumanCase hc
left join	fnReferenceRepair(@LangID, 19000019) r_d /*Diagnosis*/
on			r_d.idfsReference = isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)
left join	fnReferenceRepair(@LangID, 19000042) r_hat	/*Human Age Type*/
on			r_hat.idfsReference = hc.idfsHumanAgeType	
left join	fnInstitutionRepair(@LangID) notf_sent_by
on			notf_sent_by.idfOffice = hc.idfSentByOffice
	
inner join	tlbHuman h
	left join	fnReferenceRepair(@LangID, 19000043) r_ps	/*Human Gender*/
	on			r_ps.idfsReference = h.idfsHumanGender
	left join	tlbGeoLocation gl
	on			gl.idfGeoLocation = h.idfCurrentResidenceAddress
	
	left join	gisRayon ray_cr
			inner join	fnGisReferenceRepair(@LangID, 19000002) r_ray_cr /*Rayon*/
			on			r_ray_cr.idfsReference = ray_cr.idfsRayon
	on			ray_cr.idfsRayon = gl.idfsRayon
	left join	gisRegion reg_cr
		inner join	fnGisReferenceRepair(@LangID, 19000003) r_reg_cr /*Region*/
		on			r_reg_cr.idfsReference = reg_cr.idfsRegion
		inner join	fnGisReferenceRepair(@LangID, 19000001) r_countr_cr /*Country*/
		on			r_countr_cr.idfsReference = reg_cr.idfsCountry
		left join	trtGISBaseReferenceAttribute gis_bra
			inner join	trtAttributeType at
			on			at.idfAttributeType = gis_bra.idfAttributeType
						and at.strAttributeTypeName = N'hide_region_from_report_header'
		on			gis_bra.idfsGISBaseReference = reg_cr.idfsRegion
					and gis_bra.strAttributeItem = N'AZ Human Lab Reports'
					and cast(gis_bra.varValue as nvarchar) = cast(N'AZ Human Lab Reports' as nvarchar(20))
	on			reg_cr.idfsRegion = isnull(ray_cr.idfsRegion, gl.idfsRegion)

	
	
on			h.idfHuman = hc.idfHuman

left join tlbPerson sent_by_empl
on hc.idfSentByPerson = sent_by_empl.idfPerson

left join	tlbMaterial m
	inner join	fnReferenceRepair(@LangID, 19000087) r_st	/*Sample Type*/
	on			r_st.idfsReference = m.idfsSampleType
	
	left join fnInstitutionRepair(@LangID) m_i_sent_to
	on m_i_sent_to.idfOffice = m.idfSendToOffice
on			m.idfHuman = h.idfHuman
			and m.intRowStatus = 0
			and m.idfsSampleType <> 10320001 /*Unknown*/
			and m.idfParentMaterial is null /*it is initially collected sample*/
			and m.idfSendToOffice = @SentToID

where		hc.intRowStatus = 0
			and hc.strCaseID = @CaseID /*Samples belong to specified case*/


select * 
from @ReportTable


