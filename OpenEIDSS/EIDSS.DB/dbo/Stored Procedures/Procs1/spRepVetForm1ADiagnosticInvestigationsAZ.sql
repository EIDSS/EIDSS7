

--##SUMMARY Select data for REPORT ON ACTIONS TAKEN AGAINST EPIZOOTIC: Diagnostic investigations report.

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepVetForm1ADiagnosticInvestigationsAZ @LangID=N'en', @FromYear = 2014, @ToYear = 2015--, @FromMonth = 9, @ToMonth = 9
exec dbo.spRepVetForm1ADiagnosticInvestigationsAZ 'en',2012,2013

exec dbo.spRepVetForm1ADiagnosticInvestigationsAZ 'en',2017,2017

exec dbo.spRepVetForm1ADiagnosticInvestigationsAZ @LangID=N'en', @FromYear = 2015, @ToYear = 2015, @FromMonth = 1, @ToMonth = 12

*/

CREATE  Procedure [dbo].[spRepVetForm1ADiagnosticInvestigationsAZ]
    (
        @LangID as nvarchar(10)
        , @FromYear AS INT
		, @ToYear AS INT
		, @FromMonth AS INT = NULL
		, @ToMonth AS INT = NULL
		, @RegionID AS BIGINT = NULL
		, @RayonID AS BIGINT = NULL
		, @OrganizationEntered AS BIGINT = NULL
		, @OrganizationID AS BIGINT = NULL
		, @idfUserID AS BIGINT = NULL
    )
WITH RECOMPILE
as

--declare @LangID as nvarchar(10) = N'en'
--        , @FromYear AS INT = 2015
--		, @ToYear AS INT = 2015
--		, @FromMonth AS INT = 1
--		, @ToMonth AS INT = 12
--		, @RegionID AS BIGINT = NULL
--		, @RayonID AS BIGINT = NULL
--		, @OrganizationEntered AS BIGINT = NULL
--		, @OrganizationID AS BIGINT = NULL
--		, @idfUserID AS BIGINT = NULL


BEGIN


declare	@drop_cmd	nvarchar(4000)

-- Drop temporary tables
if Object_ID('tempdb..#ActiveSurveillanceSessionList') is not null
begin
	set	@drop_cmd = N'drop table #ActiveSurveillanceSessionList'
	execute sp_executesql @drop_cmd
end

if Object_ID('tempdb..#ASDiagnosisAndSpeciesType') is not null
begin
	set	@drop_cmd = N'drop table #ASDiagnosisAndSpeciesType'
	execute sp_executesql @drop_cmd
end

if Object_ID('tempdb..#ASAnimal') is not null
begin
	set	@drop_cmd = N'drop table #ASAnimal'
	execute sp_executesql @drop_cmd
end

if Object_ID('tempdb..#ActiveSurveillanceSessionSourceData') is not null
begin
	set	@drop_cmd = N'drop table #ActiveSurveillanceSessionSourceData'
	execute sp_executesql @drop_cmd
end

if Object_ID('tempdb..#VetAggregateAction') is not null
begin
	set	@drop_cmd = N'drop table #VetAggregateAction'
	execute sp_executesql @drop_cmd
end

DECLARE @Result AS TABLE
(
	strDiagnosisSpeciesKey	nvarchar(200) collate database_default not null primary key,
	strInvestigationName	nvarchar(2000) collate database_default null,
	idfsDiagnosticAction	bigint not null,
	idfsDiagnosis			bigint not null,
	idfsSpeciesType			bigint not null,
	strDiagnosisName		nvarchar(2000) collate database_default null,
	strOIECode				nvarchar(200) collate database_default null,
	strSpecies				nvarchar(2000) collate database_default null,
	strFooterPerformer		nvarchar(2000) collate database_default null,
	intTested				int null,
	intPositivaReaction		int null,
	strNote					nvarchar(2000) collate database_default null,
	InvestigationOrderColumn	int null,
	SpeciesOrderColumn		int null,
	DiagnosisOrderColumn	int null,
	blnAdditionalText		bit
)

declare	@idfsSummaryReportType	bigint
set	@idfsSummaryReportType = 10290033	-- Veterinary Report Form Vet 1A - Diagnostic

declare	@idfsMatrixType	bigint
set	@idfsMatrixType = 71460000000	-- Diagnostic investigations


-- Specify the value of missing month if remaining month is specified in interval (1-12)
if	@FromMonth is null and @ToMonth is not null and @ToMonth >= 1 and @ToMonth <= 12
	set	@FromMonth = 1
if	@ToMonth is null and @FromMonth is not null and @FromMonth >= 1 and @FromMonth <= 12
	set	@ToMonth = 12

-- Calculate Start and End dates for conditions: Start Date <= date from Vet Case < End date
declare	@StartDate	date
declare	@EndDate	date

if	@FromMonth is null or @FromMonth < 1 or @FromMonth > 12
	set	@StartDate = cast(@FromYear as nvarchar) + N'0101'
else if @FromMonth < 10
	set	@StartDate = cast(@FromYear as nvarchar) + N'0' + cast(@FromMonth as nvarchar) + N'01'
else
	set	@StartDate = cast(@FromYear as nvarchar) + cast(@FromMonth as nvarchar) + N'01'

if	@ToMonth is null or @ToMonth < 1 or @ToMonth > 12
begin
	set	@EndDate = cast(@ToYear as nvarchar) + N'0101'
	set	@EndDate = dateadd(year, 1, @EndDate)
end
else
begin
	if @ToMonth < 10
		set	@EndDate = cast(@ToYear as nvarchar) + N'0' + cast(@ToMonth as nvarchar) + N'01'
	else
		set	@EndDate = cast(@ToYear as nvarchar) + cast(@ToMonth as nvarchar) + N'01'
	
	set	@EndDate = dateadd(month, 1, @EndDate)
end

declare	@OrganizationName_GenerateReport	nvarchar(2000)
select		@OrganizationName_GenerateReport = i.FullName
from		fnInstitutionRepair(@LangID) i
where		i.idfOffice = @OrganizationID
if	@OrganizationName_GenerateReport is null
	set	@OrganizationName_GenerateReport = N''


-- Calculate Footer parameter "Name and Last Name of Performer:" - start
declare	@FooterNameOfPerformer	nvarchar(2000)
set	@FooterNameOfPerformer = N''

-- Show the user Name and Surname which is generating the report 
-- and near it current organization name (Organization from which user has logged on to the system) 
--     in round brackets in respective report language

declare	@EmployeeName_GenerateReport	nvarchar(2000)
select		@EmployeeName_GenerateReport = dbo.fnConcatFullName(p.strFamilyName, p.strFirstName, p.strSecondName)
from		tlbPerson p
inner join	tstUserTable ut
on			ut.idfPerson = p.idfPerson
where		ut.idfUserID = @idfUserID
if	@EmployeeName_GenerateReport is null
	set	@EmployeeName_GenerateReport = N''

set	@FooterNameOfPerformer = @EmployeeName_GenerateReport
if	ltrim(rtrim(@OrganizationName_GenerateReport)) <> N''
begin
	if	ltrim(rtrim(@FooterNameOfPerformer)) = N''
	begin
		set @FooterNameOfPerformer = N'(' + @OrganizationName_GenerateReport + N')' 
	end
	else
	begin
		set	@FooterNameOfPerformer = @FooterNameOfPerformer + N' (' + @OrganizationName_GenerateReport + N')'
	end
end

-- Calculate Footer parameter "Name and Last Name of Performer:" - end

-- Select report informative part - start

declare	@vet_form_1_use_specific_gis	bigint
declare	@vet_form_1_specific_gis_region	bigint
declare	@vet_form_1_specific_gis_rayon	bigint
declare	@attr_part_in_report			bigint

select	@vet_form_1_use_specific_gis = at.idfAttributeType
from	trtAttributeType at
where	at.strAttributeTypeName = N'vet_form_1_use_specific_gis'

select	@vet_form_1_specific_gis_region = at.idfAttributeType
from	trtAttributeType at
where	at.strAttributeTypeName = N'vet_form_1_specific_gis_region'

select	@vet_form_1_specific_gis_rayon = at.idfAttributeType
from	trtAttributeType at
where	at.strAttributeTypeName = N'vet_form_1_specific_gis_rayon'

select	@attr_part_in_report = at.idfAttributeType
from	trtAttributeType at
where	at.strAttributeTypeName = N'attr_part_in_report'

DECLARE @SpecificOfficeId BIGINT
SELECT
	 @SpecificOfficeId = ts.idfOffice
FROM tstSite ts 
WHERE ts.intRowStatus = 0
	AND ts.intFlags = 100 /*organization with abbreviation = Baku city VO*/

declare	@Diagnostic_Tested		bigint
declare	@Diagnostic_Positive	bigint
declare	@Diagnostic_Note		bigint


-- Diagnostic_Tested
select		@Diagnostic_Tested = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Diagnostic_Tested'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0

-- Diagnostic_Positive
select		@Diagnostic_Positive = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Diagnostic_Positive'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0

-- Diagnostic_Note
select		@Diagnostic_Note = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Diagnostic_Note'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0

-- Lab Diagnostic - investigation type for data from AS Session
declare	@Lab_diagnostics				bigint
declare	@Lab_diagnostics_Translation	nvarchar(2000)
declare	@Lab_diagnostics_Order			int

select		@Lab_diagnostics = rat.idfsReference,
			@Lab_diagnostics_Translation = rat.[name],
			@Lab_diagnostics_Order = rat.intOrder
from		trtBaseReferenceAttribute bra
inner join	fnReferenceRepair(@LangID, 19000132) rat	/*Report Additional Text*/
on			rat.idfsReference = bra.idfsBaseReference
where		bra.idfAttributeType = @attr_part_in_report
			and cast(bra.varValue as nvarchar) = cast(@idfsSummaryReportType as nvarchar(20))
			and bra.strAttributeItem = N'Name of investigation - Lab diagnostics'

if	@Lab_diagnostics is null
	set	@Lab_diagnostics = -1
if	@Lab_diagnostics_Translation is null
	set	@Lab_diagnostics_Translation = N''
	
	
-- Project monitoring - investigation type for data from AS Session
declare	@Project_monitoring				bigint
declare	@Project_monitoring_Translation	nvarchar(2000)
declare	@Project_monitoring_Order			int

select		@Project_monitoring = rat.idfsReference,
			@Project_monitoring_Translation = rat.[name],
			@Project_monitoring_Order = rat.intOrder
from		trtBaseReferenceAttribute bra
inner join	fnReferenceRepair(@LangID, 19000132) rat	/*Report Additional Text*/
on			rat.idfsReference = bra.idfsBaseReference
where		bra.idfAttributeType = @attr_part_in_report
			and cast(bra.varValue as nvarchar) = cast(@idfsSummaryReportType as nvarchar(20))
			and bra.strAttributeItem = N'Name of investigation - Project monitoring'

if	@Project_monitoring is null
	set	@Project_monitoring = -1
if	@Project_monitoring_Translation is null
	set	@Project_monitoring_Translation = N''

-- Included state sector - note for data from AS Session containing farm, 
-- which has ownership structure = State Farm and is counted for the report
declare	@Included_state_sector				bigint
declare	@Included_state_sector_Translation	nvarchar(2000)

select		@Included_state_sector = rat.idfsReference,
			@Included_state_sector_Translation = rat.[name]
from		trtBaseReferenceAttribute bra
inner join	fnReferenceRepair(@LangID, 19000132) rat	/*Report Additional Text*/
on			rat.idfsReference = bra.idfsBaseReference
where		bra.idfAttributeType = @attr_part_in_report
			and cast(bra.varValue as nvarchar) = cast(@idfsSummaryReportType as nvarchar(20))
			and bra.strAttributeItem = N'Note - Diagnostic'

if	@Included_state_sector is null
	set	@Included_state_sector = -1
if	@Included_state_sector_Translation is null
	set	@Included_state_sector_Translation = N''

-- Active Surveillance Session List for calculations
CREATE table	#ActiveSurveillanceSessionList
(	idfMonitoringSession			bigint not null primary KEY
	, LabDiagnostics BIT NOT NULL
)


insert into	#ActiveSurveillanceSessionList
(	idfMonitoringSession
	, LabDiagnostics
)
select	distinct
			ms.idfMonitoringSession
			, CASE WHEN tc.idfCampaign IS NULL THEN 1 ELSE 0 END
from		
-- AS Session
			tlbMonitoringSession ms

-- Site, Organization entered session
inner join	tstSite s
	left join	fnInstitutionRepair(@LangID) i
	on			i.idfOffice = CASE WHEN s.intFlags = 10 THEN @SpecificOfficeId ELSE s.idfOffice END

	-- Specific Region and Rayon for the site with specific attributes (B46)
	left join	trtBaseReferenceAttribute bra
	on			bra.idfsBaseReference = i.idfsOfficeAbbreviation
				and bra.idfAttributeType = @vet_form_1_use_specific_gis
				and cast(bra.varValue as nvarchar) = s.strSiteID
	left join	trtGISBaseReferenceAttribute gis_bra_region
	on			cast(gis_bra_region.varValue as nvarchar) = s.strSiteID
				and gis_bra_region.idfAttributeType = @vet_form_1_specific_gis_region
	left join	fnGisReferenceRepair(@LangID, 19000003) reg_specific
	on			reg_specific.idfsReference = gis_bra_region.idfsGISBaseReference
	left join	trtGISBaseReferenceAttribute gis_bra_rayon
	on			cast(gis_bra_rayon.varValue as nvarchar) = s.strSiteID
				and gis_bra_rayon.idfAttributeType = @vet_form_1_specific_gis_rayon
	left join	fnGisReferenceRepair(@LangID, 19000002) ray_specific
	on			ray_specific.idfsReference = gis_bra_rayon.idfsGISBaseReference

on			s.idfsSite = ms.idfsSite

-- Region and Rayon
left join	fnGisReferenceRepair(@LangID, 19000003) reg
on			reg.idfsReference = ms.idfsRegion
left join	fnGisReferenceRepair(@LangID, 19000002) ray
on			ray.idfsReference = ms.idfsRayon

LEFT JOIN tlbCampaign tc ON 
	tc.idfCampaign = ms.idfCampaign 
	AND tc.intRowStatus = 0 
	AND tc.idfsCampaignType = 10150002 /*Study*/

where		ms.intRowStatus = 0

			-- Session Start Date is not blank
			and ms.datStartDate is not null

			-- Session contains more than 0--Updated in the specification--1 sample
			and (	select		count(*)
					from		tlbMaterial m_count
					inner join	fnReferenceRepair(@LangID, 19000087) r_st_count	/*Sample Type*/
					on			r_st_count.idfsReference = m_count.idfsSampleType
					where		m_count.idfMonitoringSession = ms.idfMonitoringSession
								and m_count.idfAnimal is not null
								and isnull(m_count.idfRootMaterial, m_count.idfMaterial) = m_count.idfMaterial
								and m_count.intRowStatus = 0
								and m_count.idfsSampleType <> 10320001	/*Unknown*/
				) > 0--Updated in the specification--1

			-- From Year, Month To Year, Month
			and isnull(ms.datEndDate, ms.datStartDate) >= @StartDate
			and isnull(ms.datEndDate, ms.datStartDate) < @EndDate
			
			-- Region
			and (@RegionID is null or (@RegionID is not null and isnull(reg_specific.idfsReference, reg.idfsReference) = @RegionID))
			-- Rayon
			and (@RayonID is null or (@RayonID is not null and isnull(ray_specific.idfsReference, ray.idfsReference) = @RayonID))
			
			-- Entered by organization
			and (@OrganizationEntered is null or (@OrganizationEntered is not null and i.idfOffice = @OrganizationEntered))


-- Active Surveillance Session Diagnoses and Species Types
CREATE table	#ASDiagnosisAndSpeciesType
(	idfID							bigint not null identity (1, 1) primary key,
	idfMonitoringSession			bigint not null,
	idfsDiagnosis					bigint not null,
	idfsSpeciesType					bigint not null
)


insert into	#ASDiagnosisAndSpeciesType
(	idfMonitoringSession,
	idfsDiagnosis,
	idfsSpeciesType
)
select	distinct
			asl.idfMonitoringSession,
			ms_to_d.idfsDiagnosis,
			ms_to_d.idfsSpeciesType
from		tlbMonitoringSessionToDiagnosis ms_to_d
-- AS Session
inner join	#ActiveSurveillanceSessionList asl
on			asl.idfMonitoringSession = ms_to_d.idfMonitoringSession

-- Species Type
where		ms_to_d.idfsSpeciesType is not null
			and ms_to_d.intRowStatus = 0
			
			AND (
				ms_to_d.idfsSampleType IS NULL
				OR (ms_to_d.idfsSampleType IS NOT NULL
					AND EXISTS (
						select		1
						from		tlbMaterial m_count
						where		m_count.idfMonitoringSession = asl.idfMonitoringSession
									and m_count.idfAnimal is not null
									and isnull(m_count.idfRootMaterial, m_count.idfMaterial) = m_count.idfMaterial
									and m_count.intRowStatus = 0
									and m_count.idfsSampleType = ms_to_d.idfsSampleType
						)
					)	
			)



-- Active Surveillance Session data
declare	@ActiveSurveillanceSessionData	table
(	strDiagnosisSpeciesKey			nvarchar(200) collate database_default not null /*primary key*/,
	idfsDiagnosis					bigint not null,
	idfsDiagnosticAction			bigint not null,
	idfsSpeciesType					bigint not null,
	strInvestigationName			nvarchar(2000) collate database_default null,
	strDiagnosisName				nvarchar(2000) collate database_default null,
	strOIECode						nvarchar(200) collate database_default null,
	strSpecies						nvarchar(2000) collate database_default null,
	intTested						int null,
	intPositivaReaction				int null,
	blnAddNote						int null default (0),
	InvestigationOrderColumn		int null,
	SpeciesOrderColumn				int null,
	DiagnosisOrderColumn			int NULL
)


DECLARE @NotDeletedDiagnosis TABLE (
	[name] NVARCHAR(500)
	, idfsDiagnosis BIGINT
	, intOrder INT
	, strOIECode NVARCHAR(100)
	, rn INT
)

INSERT INTO @NotDeletedDiagnosis
SELECT
		r_d_actual.[name]
		, d_actual.idfsDiagnosis
		, r_d_actual.intOrder
		, d_actual.strOIECode
		, ROW_NUMBER() OVER (PARTITION BY r_d_actual.[name] ORDER BY d_actual.idfsDiagnosis) AS rn
	from		trtDiagnosis d_actual
	inner join	fnReference(@LangID, 19000019) r_d_actual
	on			r_d_actual.idfsReference = d_actual.idfsDiagnosis
	where		d_actual.idfsUsingType = 10020001	/*Case-based*/
				and d_actual.intRowStatus = 0
	


DECLARE @NotDeletedSpecies TABLE (
	[name] NVARCHAR(500)
	, idfsSpeciesType BIGINT
	, intOrder INT
	, rn INT
)	

INSERT INTO @NotDeletedSpecies
SELECT
		r_sp_actual.[name]
		, st_actual.idfsSpeciesType
		, r_sp_actual.intOrder
		, ROW_NUMBER() OVER (PARTITION BY r_sp_actual.[name] ORDER BY st_actual.idfsSpeciesType) AS rn
	from		trtSpeciesType st_actual
	inner join	fnReference(@LangID, 19000086) r_sp_actual
	on			r_sp_actual.idfsReference = st_actual.idfsSpeciesType
	where		st_actual.intRowStatus = 0




insert into	@ActiveSurveillanceSessionData
(	strDiagnosisSpeciesKey,
	idfsDiagnosis,
	idfsDiagnosticAction,
	idfsSpeciesType,
	strInvestigationName,
	strDiagnosisName,
	strOIECode,
	strSpecies,
	intTested,
	intPositivaReaction,
	blnAddNote,
	InvestigationOrderColumn,
	SpeciesOrderColumn,
	DiagnosisOrderColumn
)
SELECT
	CAST(ISNULL(Actual_Diagnosis.idfsDiagnosis, sd.idfsDiagnosis) AS NVARCHAR(20)) + N'_' + 
		CAST(ISNULL(Actual_Species_Type.idfsSpeciesType, sd.idfsSpeciesType) AS NVARCHAR(20)) + N'_' + 
		CAST(CASE WHEN LabDiagnostics = 1 THEN @Lab_diagnostics ELSE @Project_monitoring END AS NVARCHAR(20)) AS strDiagnosisSpeciesKey,
	ISNULL(Actual_Diagnosis.idfsDiagnosis, sd.idfsDiagnosis) AS idfsDiagnosis,
	CASE WHEN LabDiagnostics = 1 THEN @Lab_diagnostics ELSE @Project_monitoring END AS idfsDiagnosticAction,
	ISNULL(Actual_Species_Type.idfsSpeciesType, sd.idfsSpeciesType) AS idfsSpeciesType,
	CASE WHEN LabDiagnostics = 1 THEN @Lab_diagnostics_Translation ELSE @Project_monitoring_Translation END AS strInvestigationName,
	ISNULL(r_d.[name], N'') AS strDiagnosisName,
	ISNULL(Actual_Diagnosis.strOIECode, ISNULL(d.strOIECode, N'')) AS strOIECode,
	ISNULL(r_sp.[name], N'') AS strSpecies,
		COUNT(sd.idfMaterial),
		COUNT(sd.idfTesting),
		SUM(CAST((ISNULL(sd.idfsOwnershipStructure, 0) / 10820000000) AS INT)) AS blnAddNote, /*State Farm*/
	CASE WHEN LabDiagnostics = 1 THEN @Lab_diagnostics_Order ELSE @Project_monitoring_Order END AS InvestigationOrderColumn,
	ISNULL(Actual_Species_Type.intOrder, ISNULL(r_sp.intOrder, -1000)) AS SpeciesOrderColumn,
	ISNULL(Actual_Diagnosis.intOrder, ISNULL(r_d.intOrder, -1000)) AS DiagnosisOrderColumn
	
FROM
(
	select distinct
			asdst.idfsDiagnosis,
				asdst.idfsSpeciesType,
				a.idfAnimal as idfMaterial,
				case
					when t.idfTesting is not null
						then	a.idfAnimal
					else	null
				end as idfTesting,
				--a.idfsOwnershipStructure
				case
					when	f.idfsOwnershipStructure = 10820000000 /*State Farm*/
						then	10820000000 /*State Farm*/
					else	null
				END idfsOwnershipStructure
			, asl.LabDiagnostics
	from		tlbMaterial m

	JOIN tlbAnimal a ON
		a.idfAnimal = m.idfAnimal
	JOIN tlbSpecies sp ON
		sp.idfSpecies = a.idfSpecies
		AND sp.intRowStatus = 0
	JOIN tlbHerd h ON
		h.idfHerd = sp.idfHerd
		AND h.intRowStatus = 0
	JOIN tlbFarm f ON
		f.idfFarm = h.idfFarm
		AND f.intRowStatus = 0
	JOIN #ActiveSurveillanceSessionList asl ON
		asl.idfMonitoringSession = f.idfMonitoringSession

	inner join	#ASDiagnosisAndSpeciesType asdst
	on			asdst.idfMonitoringSession = f.idfMonitoringSession
				and asdst.idfsSpeciesType = sp.idfsSpeciesType

	left join	tlbTesting t
	on			t.idfMaterial = m.idfMaterial
				and t.intRowStatus = 0
				and isnull(t.blnExternalTest, 0) = 0
				and t.idfsDiagnosis = asdst.idfsDiagnosis
				-- Positive reaction
				and exists	(
						select		*
						from		trtBaseReferenceAttribute bra
						where		bra.idfAttributeType = @attr_part_in_report
									and bra.idfsBaseReference = t.idfsTestResult
									and bra.strAttributeItem = N'Positive reaction taken (ea)'
									and cast(bra.varValue as nvarchar) = cast(@idfsSummaryReportType as nvarchar(20))
							)

	where		m.intRowStatus = 0
				and isnull(m.idfRootMaterial, m.idfMaterial) = m.idfMaterial
				and m.idfsSampleType <> 10320001	/*Unknown*/
				-- Collection date should be not blank for the including sample in the report calculation
				and m.datFieldCollectionDate is not null	
) sd

inner join	trtDiagnosis d
	inner join	fnReferenceRepair(@LangID, 19000019) r_d
	on			r_d.idfsReference = d.idfsDiagnosis
	-- Not deleted diagnosis with the same name and case-based using type
	LEFT JOIN @NotDeletedDiagnosis AS Actual_Diagnosis ON
		Actual_Diagnosis.[name] = r_d.[name] collate Cyrillic_General_CI_AS
		AND Actual_Diagnosis.rn = 1
on			d.idfsDiagnosis = sd.idfsDiagnosis

inner join	fnReferenceRepair(@LangID, 19000086) r_sp
	-- Not deleted species type with the same name
	LEFT JOIN @NotDeletedSpecies AS Actual_Species_Type ON
		Actual_Species_Type.[name] = r_sp.[name] collate Cyrillic_General_CI_AS
		AND Actual_Species_Type.rn = 1
on			r_sp.idfsReference = sd.idfsSpeciesType

group by	cast(isnull(Actual_Diagnosis.idfsDiagnosis, sd.idfsDiagnosis) as nvarchar(20)) + N'_' + 
				cast(isnull(Actual_Species_Type.idfsSpeciesType, sd.idfsSpeciesType) as nvarchar(20)) + N'_' + 
				CAST(CASE WHEN LabDiagnostics = 1 THEN @Lab_diagnostics ELSE @Project_monitoring END AS NVARCHAR(20)),
			isnull(Actual_Diagnosis.idfsDiagnosis, sd.idfsDiagnosis),
			isnull(Actual_Species_Type.idfsSpeciesType, sd.idfsSpeciesType),
			isnull(r_d.[name], N''),
			isnull(Actual_Diagnosis.strOIECode, isnull(d.strOIECode, N'')),
			isnull(r_sp.[name], N''),
			isnull(Actual_Species_Type.intOrder, isnull(r_sp.intOrder, -1000)),
			isnull(Actual_Diagnosis.intOrder, isnull(r_d.intOrder, -1000)),
			LabDiagnostics






-- Select aggregate data
DECLARE @MinAdminLevel BIGINT
DECLARE @MinTimeInterval BIGINT
DECLARE @AggrCaseType BIGINT



SET @AggrCaseType = 10102003 /*Vet Aggregate Action*/

SELECT	@MinAdminLevel = idfsStatisticAreaType,
		@MinTimeInterval = idfsStatisticPeriodType
FROM fnAggregateSettings (@AggrCaseType)

create table #VetAggregateAction
(	idfAggrCase					bigint not null primary key,
	idfDiagnosticObservation	bigint,
	datStartDate				datetime,
	idfDiagnosticVersion		BIGINT
	, idfsRegion BIGINT
	, idfsRayon BIGINT
	, idfsAdministrativeUnit BIGINT
	, datFinishDate DATETIME
)

declare	@idfsCurrentCountry	bigint
select	@idfsCurrentCountry = isnull(dbo.fnCurrentCountry(), 170000000) /*Azerbaijan*/

insert into	#VetAggregateAction
(	idfAggrCase,
	idfDiagnosticObservation,
	datStartDate,
	idfDiagnosticVersion
	, idfsRegion
	, idfsRayon
	, idfsAdministrativeUnit
	, datFinishDate
)
select		a.idfAggrCase,
			obs.idfObservation,
			a.datStartDate,
			a.idfDiagnosticVersion
			, COALESCE(s.idfsRegion, rr.idfsRegion, r.idfsRegion, NULL) AS idfsRegion
			, COALESCE(s.idfsRayon, rr.idfsRayon, NULL) AS idfsRayon
			, a.idfsAdministrativeUnit
			, a.datFinishDate
from		tlbAggrCase a
inner join	tlbObservation obs
on			obs.idfObservation = a.idfDiagnosticObservation
left join	gisCountry c
on			c.idfsCountry = a.idfsAdministrativeUnit
left join	gisRegion r
on			r.idfsRegion = a.idfsAdministrativeUnit 
			and r.idfsCountry = @idfsCurrentCountry
left join	gisRayon rr
on			rr.idfsRayon = a.idfsAdministrativeUnit
			and rr.idfsCountry = @idfsCurrentCountry
left join	gisSettlement s
on			s.idfsSettlement = a.idfsAdministrativeUnit
			and s.idfsCountry = @idfsCurrentCountry

-- Site, Organization entered aggregate action
inner join	tstSite sit
	left join	fnInstitutionRepair(@LangID) i
	on			i.idfOffice = sit.idfOffice
on			sit.idfsSite = a.idfsSite

where		a.idfsAggrCaseType = @AggrCaseType
-- Time Period satisfies Report Filters
			and (	@StartDate <= a.datStartDate
					and a.datFinishDate < @EndDate
				)
	AND (
			(r.idfsRegion = @RegionID OR @RegionID IS NULL)
			OR (
				(rr.idfsRayon = @RayonID OR @RayonID IS NULL) 
				AND (rr.idfsRegion = @RegionID OR @RegionID IS NULL)
				)
			OR (
				a.idfsAdministrativeUnit = s.idfsSettlement
				AND (s.idfsRayon = @RayonID OR @RayonID IS NULL) 
				AND (s.idfsRegion = @RegionID OR @RegionID IS NULL)
				)
		)
			-- Entered by organization satisfies Report Filters
			and (@OrganizationEntered is null or (@OrganizationEntered is not null and i.idfOffice = @OrganizationEntered))

			and a.intRowStatus = 0

	SELECT	
		@MinAdminLevel = idfsStatisticAreaType
		, @MinTimeInterval = idfsStatisticPeriodType
	FROM fnAggregateSettings (10102003 /*Vet Aggregate Action*/)
	

	DELETE FROM #VetAggregateAction
	WHERE idfAggrCase IN (
		SELECT
			idfAggrCase
		FROM (
			SELECT 
				COUNT(*) OVER (PARTITION BY ac.idfAggrCase) cnt
				, ac2.idfAggrCase
				, CASE 
					WHEN DATEDIFF(YEAR, ac2.datStartDate, ac2.datFinishDate) = 0 AND DATEDIFF(quarter, ac2.datStartDate, ac2.datFinishDate) > 1 
						THEN 10091005 --sptYear
					WHEN DATEDIFF(quarter, ac2.datStartDate, ac2.datFinishDate) = 0 AND DATEDIFF(MONTH, ac2.datStartDate, ac2.datFinishDate) > 1
						THEN 10091003 --sptQuarter
					WHEN DATEDIFF(MONTH, ac2.datStartDate, ac2.datFinishDate) = 0 AND dbo.fnWeekDatediff(ac2.datStartDate, ac2.datFinishDate) > 1
						THEN 10091001 --sptMonth
					WHEN dbo.fnWeekDatediff(ac2.datStartDate, ac2.datFinishDate) = 0 AND DATEDIFF(DAY, ac2.datStartDate, ac2.datFinishDate) > 1
						THEN 10091004 --sptWeek
					WHEN DATEDIFF(DAY, ac2.datStartDate, ac2.datFinishDate) = 0
						THEN 10091002 --sptOnday
				END AS TimeInterval
				, CASE
					WHEN ac2.idfsAdministrativeUnit = c2.idfsCountry THEN 10089001 --satCountry
					WHEN ac2.idfsAdministrativeUnit = r2.idfsRegion THEN 10089003 --satRegion
					WHEN ac2.idfsAdministrativeUnit = rr2.idfsRayon THEN 10089002 --satRayon
					WHEN ac2.idfsAdministrativeUnit = s2.idfsSettlement THEN 10089004 --satSettlement
				END AS AdminLevel
			FROM #VetAggregateAction ac
			LEFT JOIN gisCountry c ON
				c.idfsCountry = ac.idfsAdministrativeUnit
			LEFT JOIN gisRegion r ON
				r.idfsRegion = ac.idfsAdministrativeUnit 
				AND r.idfsCountry = @idfsCurrentCountry
			LEFT JOIN gisRayon rr ON
				rr.idfsRayon = ac.idfsAdministrativeUnit
				AND rr.idfsCountry = @idfsCurrentCountry
			LEFT JOIN gisSettlement s ON
				s.idfsSettlement = ac.idfsAdministrativeUnit
				AND s.idfsCountry = @idfsCurrentCountry
				
			JOIN #VetAggregateAction ac2 ON
				(
					ac2.datStartDate BETWEEN ac.datStartDate AND ac.datFinishDate
					OR ac2.datFinishDate BETWEEN ac.datStartDate AND ac.datFinishDate
				)
				
			LEFT JOIN gisCountry c2 ON
				c2.idfsCountry = ac2.idfsAdministrativeUnit
			LEFT JOIN gisRegion r2 ON
				r2.idfsRegion = ac2.idfsAdministrativeUnit 
				AND r2.idfsCountry = @idfsCurrentCountry
			LEFT JOIN gisRayon rr2 ON
				rr2.idfsRayon = ac2.idfsAdministrativeUnit
				AND rr2.idfsCountry = @idfsCurrentCountry
			LEFT JOIN gisSettlement s2 ON
				s2.idfsSettlement = ac2.idfsAdministrativeUnit
				AND s2.idfsCountry = @idfsCurrentCountry
			
			WHERE COALESCE(s2.idfsRayon, rr2.idfsRayon) = ac.idfsAdministrativeUnit
				OR COALESCE(s2.idfsRegion, rr2.idfsRegion, r2.idfsRegion) = ac.idfsAdministrativeUnit
				OR COALESCE(s2.idfsCountry, rr2.idfsCountry, r2.idfsCountry, c2.idfsCountry) = ac.idfsAdministrativeUnit
		) a
		WHERE cnt > 1	
			AND CASE WHEN TimeInterval = @MinTimeInterval AND AdminLevel = @MinAdminLevel THEN 1 ELSE 0 END = 0
	)

declare	@VetAggregateActionData	table
(	strDiagnosisSpeciesKey		nvarchar(200) collate database_default not null primary key,
	idfsDiagnosis				bigint not null,
	idfsDiagnosticAction		bigint not null,
	idfsSpeciesType				bigint not null,
	strInvestigationName		nvarchar(2000) collate database_default null,
	strDiagnosisName			nvarchar(2000) collate database_default null,
	strOIECode					nvarchar(200) collate database_default null,
	strSpecies					nvarchar(2000) collate database_default null,
	intTested					int null,
	intPositivaReaction			int null,
	strNote						nvarchar(2000) collate database_default null,
	SpeciesOrderColumn			int null,
	DiagnosisOrderColumn		int null,
	InvestigationOrderColumn	int NULL
)

DECLARE @NotDeletedAggregateDiagnosis TABLE (
	[name] NVARCHAR(500)
	, idfsDiagnosis BIGINT
	, intOrder INT
	, strOIECode NVARCHAR(100)
	, rn INT
)

INSERT INTO @NotDeletedAggregateDiagnosis
SELECT
	r_d_actual.[name]
	, d_actual.idfsDiagnosis
	, r_d_actual.intOrder
	, d_actual.strOIECode
	, ROW_NUMBER() OVER (PARTITION BY r_d_actual.[name] ORDER BY d_actual.idfsDiagnosis) AS rn
from		trtDiagnosis d_actual
inner join	fnReference(@LangID, 19000019) r_d_actual
on			r_d_actual.idfsReference = d_actual.idfsDiagnosis
where		d_actual.idfsUsingType = 10020002	/*Aggregate*/
			and d_actual.intRowStatus = 0
	

DECLARE @NotDeletedAggregateSpecies TABLE (
	[name] NVARCHAR(500)
	, idfsSpeciesType BIGINT
	, intOrder INT
	, rn INT
)	

INSERT INTO @NotDeletedAggregateSpecies
SELECT
	r_sp_actual.[name]
	, st_actual.idfsSpeciesType
	, r_sp_actual.intOrder
	, ROW_NUMBER() OVER (PARTITION BY r_sp_actual.[name] ORDER BY st_actual.idfsSpeciesType) AS rn
from		trtSpeciesType st_actual
inner join	fnReference(@LangID, 19000086) r_sp_actual
on			r_sp_actual.idfsReference = st_actual.idfsSpeciesType
where		st_actual.intRowStatus = 0


DECLARE @NotDeletedAggregateInvestigationType TABLE (
	[name] NVARCHAR(500)
	, idfsDiagnosticAction BIGINT
	, intOrder INT
	, rn INT
)

INSERT INTO @NotDeletedAggregateInvestigationType
SELECT
	r_di_actual.[name]
	, r_di_actual.idfsReference as idfsDiagnosticAction
	, r_di_actual.intOrder
	, ROW_NUMBER() OVER (PARTITION BY r_di_actual.[name] ORDER BY r_di_actual.idfsReference) AS rn
from		fnReference(@LangID, 19000021) r_di_actual



insert into	@VetAggregateActionData
(	strDiagnosisSpeciesKey,
	idfsDiagnosis,
	idfsDiagnosticAction,
	idfsSpeciesType,
	strInvestigationName,
	strDiagnosisName,
	strOIECode,
	strSpecies,
	intTested,
	intPositivaReaction,
	strNote,
	SpeciesOrderColumn,
	DiagnosisOrderColumn,
	InvestigationOrderColumn
)
select		cast(isnull(Actual_Diagnosis.idfsDiagnosis, mtx.idfsDiagnosis) as nvarchar(20)) + N'_' + 
				cast(isnull(Actual_Species_Type.idfsSpeciesType, mtx.idfsSpeciesType) as nvarchar(20)) + N'_' + 
				cast(isnull(Actual_Investigation_Type.idfsDiagnosticAction, 
								mtx.idfsDiagnosticAction) as nvarchar(20)) as strDiagnosisSpeciesKey,
			isnull(Actual_Diagnosis.idfsDiagnosis, mtx.idfsDiagnosis) as idfsDiagnosis,
			isnull(Actual_Investigation_Type.idfsDiagnosticAction, mtx.idfsDiagnosticAction) as idfsDiagnosticAction,
			isnull(Actual_Species_Type.idfsSpeciesType, mtx.idfsSpeciesType) as idfsSpeciesType,
			isnull(r_di.[name], N'') as strInvestigationName,
			isnull(r_d.[name], N'') as strDiagnosisName,
			isnull(Actual_Diagnosis.strOIECode, isnull(d.strOIECode, N'')) as strOIECode,
			isnull(r_sp.[name], N'') as strSpecies,
			sum(isnull(cast(Diagnostic_Tested.varValue as int), 0)) as intTested,
			sum(isnull(cast(Diagnostic_Positive.varValue as int), 0)) as intPositivaReaction,
			max(left(isnull(cast(Diagnostic_Note.varValue as nvarchar), N''), 2000)) as strNote,
			isnull(Actual_Species_Type.intOrder, isnull(r_sp.intOrder, -1000)) as SpeciesOrderColumn,
			isnull(Actual_Diagnosis.intOrder, isnull(r_d.intOrder, -1000)) as DiagnosisOrderColumn,
			isnull(Actual_Investigation_Type.intOrder, isnull(r_di.intOrder, -1000)) as InvestigationOrderColumn
			
from		#VetAggregateAction vaa
-- Matrix version
inner join	tlbAggrMatrixVersionHeader h
on			h.idfsMatrixType = @idfsMatrixType
			and (	-- Get matrix version selected by the user in aggregate action
					h.idfVersion = vaa.idfDiagnosticVersion
					-- If matrix version is not selected by the user in aggregate case, 
					-- then select active matrix with the latest date activation that is earlier than aggregate action start date
					or (	vaa.idfDiagnosticVersion is null 
							and	h.datStartDate <= vaa.datStartDate
							and	h.blnIsActive = 1
							and not exists	(
										select	*
										from	tlbAggrMatrixVersionHeader h_later
										where	h_later.idfsMatrixType = @idfsMatrixType
												and	h_later.datStartDate <= vaa.datStartDate
												and	h_later.blnIsActive = 1
												and h_later.intRowStatus = 0
												and	h_later.datStartDate > h.datStartDate
											)
						)
				)
			and h.intRowStatus = 0
			
-- Matrix row
inner join	tlbAggrDiagnosticActionMTX mtx
on			mtx.idfVersion = h.idfVersion
			and mtx.intRowStatus = 0

-- Diagnosis       
inner join	trtDiagnosis d
	inner join	fnReferenceRepair(@LangID, 19000019) r_d
	on			r_d.idfsReference = d.idfsDiagnosis

	-- Not deleted diagnosis with the same name and aggregate using type
	LEFT JOIN @NotDeletedAggregateDiagnosis AS Actual_Diagnosis ON
		Actual_Diagnosis.[name] = r_d.[name] collate Cyrillic_General_CI_AS
		AND Actual_Diagnosis.rn = 1
on			d.idfsDiagnosis = mtx.idfsDiagnosis

-- Species Type
inner join	fnReferenceRepair(@LangID, 19000086) r_sp
	-- Not deleted species type with the same name
	LEFT JOIN @NotDeletedAggregateSpecies AS Actual_Species_Type ON
		Actual_Species_Type.[name] = r_sp.[name] collate Cyrillic_General_CI_AS
		AND Actual_Species_Type.rn = 1
on			r_sp.idfsReference = mtx.idfsSpeciesType

-- Investigation Type
inner join	fnReferenceRepair(@LangID, 19000021) r_di
	-- Not deleted species type with the same name
	LEFT JOIN @NotDeletedAggregateInvestigationType AS Actual_Investigation_Type ON
		Actual_Investigation_Type.[name] = r_di.[name] collate Cyrillic_General_CI_AS
		AND Actual_Investigation_Type.rn = 1
on			r_di.idfsReference = mtx.idfsDiagnosticAction

-- Tested
outer apply ( 
 	select top 1
 			ap.varValue
 	from	tlbActivityParameters ap
 	where	ap.idfObservation = vaa.idfDiagnosticObservation
 			and ap.idfRow = mtx.idfAggrDiagnosticActionMTX
			and ap.idfsParameter = @Diagnostic_Tested
			and ap.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(ap.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			and ap.varValue is not null
 			order by ap.idfActivityParameters asc
 		) as  Diagnostic_Tested

-- Positive reaction
outer apply ( 
 	select top 1
 			ap.varValue
 	from	tlbActivityParameters ap
 	where	ap.idfObservation = vaa.idfDiagnosticObservation
 			and ap.idfRow = mtx.idfAggrDiagnosticActionMTX
			and ap.idfsParameter = @Diagnostic_Positive
			and ap.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(ap.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			and ap.varValue is not null
 			order by ap.idfActivityParameters asc
 		) as  Diagnostic_Positive

-- Note
outer apply ( 
 	select top 1
 			ap.varValue
 	from	tlbActivityParameters ap
 	where	ap.idfObservation = vaa.idfDiagnosticObservation
 			and ap.idfRow = mtx.idfAggrDiagnosticActionMTX
			and ap.idfsParameter = @Diagnostic_Note
			and ap.intRowStatus = 0
			and ap.varValue is not null
 			order by ap.idfActivityParameters asc
 		) as  Diagnostic_Note

group by	cast(isnull(Actual_Diagnosis.idfsDiagnosis, mtx.idfsDiagnosis) as nvarchar(20)) + N'_' + 
				cast(isnull(Actual_Species_Type.idfsSpeciesType, mtx.idfsSpeciesType) as nvarchar(20)) + N'_' + 
				cast(isnull(Actual_Investigation_Type.idfsDiagnosticAction, 
								mtx.idfsDiagnosticAction) as nvarchar(20)),
			isnull(Actual_Diagnosis.idfsDiagnosis, mtx.idfsDiagnosis),
			isnull(Actual_Investigation_Type.idfsDiagnosticAction, mtx.idfsDiagnosticAction),
			isnull(Actual_Species_Type.idfsSpeciesType, mtx.idfsSpeciesType),
			isnull(r_di.[name], N''),
			isnull(r_d.[name], N''),
			isnull(Actual_Diagnosis.strOIECode, isnull(d.strOIECode, N'')),
			isnull(r_sp.[name], N''),
			isnull(Actual_Species_Type.intOrder, isnull(r_sp.intOrder, -1000)),
			isnull(Actual_Diagnosis.intOrder, isnull(r_d.intOrder, -1000)),
			isnull(Actual_Investigation_Type.intOrder, isnull(r_di.intOrder, -1000))
-- Do not include the rows with Tested = 0 in the report
having		sum(isnull(cast(Diagnostic_Tested.varValue as int), 0)) > 0


-- Fill result table
insert into	@Result
(	strDiagnosisSpeciesKey,
	strInvestigationName,
	idfsDiagnosis,
	idfsDiagnosticAction,
	idfsSpeciesType,
	strDiagnosisName,
	strOIECode,
	strSpecies,
	strFooterPerformer,
	intTested,
	intPositivaReaction,
	strNote,
	InvestigationOrderColumn,
	SpeciesOrderColumn,
	DiagnosisOrderColumn,
	blnAdditionalText
)
select distinct
			s.strDiagnosisSpeciesKey,
			s.strInvestigationName,
			s.idfsDiagnosis,
			s.idfsDiagnosticAction,
			s.idfsSpeciesType,
			s.strDiagnosisName,
			s.strOIECode,
			s.strSpecies,
			@FooterNameOfPerformer,
			s.intTested,
			s.intPositivaReaction,
			case
				when	s.blnAddNote > 0
					then	@Included_state_sector_Translation
				else	N''
			end,
			s.InvestigationOrderColumn,
			s.SpeciesOrderColumn,
			s.DiagnosisOrderColumn,
			1 AS blnAdditionalText

from		@ActiveSurveillanceSessionData s



insert into	@Result
(	strDiagnosisSpeciesKey,
	strInvestigationName,
	idfsDiagnosis,
	idfsDiagnosticAction,
	idfsSpeciesType,
	strDiagnosisName,
	strOIECode,
	strSpecies,
	strFooterPerformer,
	intTested,
	intPositivaReaction,
	strNote,
	InvestigationOrderColumn,
	SpeciesOrderColumn,
	DiagnosisOrderColumn,
	blnAdditionalText
)
select		a.strDiagnosisSpeciesKey,
			a.strInvestigationName,
			a.idfsDiagnosis,
			a.idfsDiagnosticAction,
			a.idfsSpeciesType,
			a.strDiagnosisName,
			a.strOIECode,
			a.strSpecies,
			@FooterNameOfPerformer,
			a.intTested,
			a.intPositivaReaction,
			case
				when	@FromYear = @ToYear
						and	@FromMonth = @ToMonth
					then	a.strNote
				else	N''
			end,
			a.InvestigationOrderColumn,
			a.SpeciesOrderColumn,
			a.DiagnosisOrderColumn,
			0 AS blnAdditionalText
			
from		@VetAggregateActionData a
left join	@Result r
on			r.strDiagnosisSpeciesKey = a.strDiagnosisSpeciesKey
where		r.idfsDiagnosis is null

-- Update orders in the table
update	r
set		r.InvestigationOrderColumn = -1000000,
		r.DiagnosisOrderColumn = 0,
		r.SpeciesOrderColumn = 0
from	@Result r
where	(ISNULL(r.idfsDiagnosticAction, -1) = @Lab_diagnostics OR ISNULL(r.idfsDiagnosticAction, -1) = @Project_monitoring)
		and (	ISNULL(r.InvestigationOrderColumn, 0) <> -1000000
				or	ISNULL(r.DiagnosisOrderColumn, 0) <> 0
				or	ISNULL(r.SpeciesOrderColumn, 0) <> 0
			)

update		r
set			r.InvestigationOrderColumn = isnull(adaMTX.intNumRow, 0),
			r.DiagnosisOrderColumn = 0,
			r.SpeciesOrderColumn = 0
from		@Result r
inner join	tlbAggrDiagnosticActionMTX adaMTX
on			adaMTX.idfsDiagnosis = r.idfsDiagnosis
			and adaMTX.idfsDiagnosticAction = r.idfsDiagnosticAction
			and adaMTX.idfsSpeciesType = r.idfsSpeciesType
			and adaMTX.intRowStatus = 0
inner join	tlbAggrMatrixVersionHeader amvh
on			amvh.idfVersion = adaMTX.idfVersion
			and amvh.intRowStatus = 0
			and amvh.blnIsActive = 1
			and amvh.blnIsDefault = 1
			and amvh.datStartDate <= getdate()
where		(	ISNULL(r.InvestigationOrderColumn, 0) <> isnull(adaMTX.intNumRow, 0)
				or	ISNULL(r.DiagnosisOrderColumn, 0) <> 0
				or	ISNULL(r.SpeciesOrderColumn, 0) <> 0
			)

update		r
set			r.InvestigationOrderColumn = 1000000,
			r.DiagnosisOrderColumn = 0,
			r.SpeciesOrderColumn = 0
from		@Result r

where		not exists	(
					select	*
					from		tlbAggrDiagnosticActionMTX adaMTX
					inner join	tlbAggrMatrixVersionHeader amvh
					on			amvh.idfVersion = adaMTX.idfVersion
								and amvh.intRowStatus = 0
								and amvh.blnIsActive = 1
								and amvh.blnIsDefault = 1
								and amvh.datStartDate <= getdate()
					where		adaMTX.idfsDiagnosis = r.idfsDiagnosis
								and adaMTX.idfsDiagnosticAction = r.idfsDiagnosticAction
								and adaMTX.idfsSpeciesType = r.idfsSpeciesType
								and adaMTX.intRowStatus = 0
						)
			and (ISNULL(r.idfsDiagnosticAction, -1) = @Lab_diagnostics OR ISNULL(r.idfsDiagnosticAction, -1) = @Project_monitoring)
			and (	ISNULL(r.InvestigationOrderColumn, 0) <> 1000000
					or	ISNULL(r.DiagnosisOrderColumn, 0) <> 0
					or	ISNULL(r.SpeciesOrderColumn, 0) <> 0
				)


-- Select report informative part - start

-- Return results
if (SELECT count(*) FROM @result) = 0
	select	'' as strDiagnosisSpeciesKey,
	'' as strInvestigationName,
	- 1 as idfsDiagnosis,
	- 1 as idfsDiagnosticAction,
	- 1 as idfsSpeciesType,
	'' as strDiagnosisName,
	'' as strOIECode, 
	'' as strSpecies,
	@FooterNameOfPerformer as strFooterPerformer,
	null as intTested, 
	null as intPositivaReaction, 
	null as strNote,
	null as InvestigationOrderColumn,
	null as SpeciesOrderColumn, 
	null as DiagnosisOrderColumn,
	0   as blnAdditionalText
else
	SELECT * FROM @result ORDER BY InvestigationOrderColumn, strInvestigationName, DiagnosisOrderColumn, strDiagnosisName, idfsDiagnosis, SpeciesOrderColumn, blnAdditionalText
	
	

	
	     
-- Drop temporary tables
if Object_ID('tempdb..#ActiveSurveillanceSessionList') is not null
begin
	set	@drop_cmd = N'drop table #ActiveSurveillanceSessionList'
	execute sp_executesql @drop_cmd
end

if Object_ID('tempdb..#ASDiagnosisAndSpeciesType') is not null
begin
	set	@drop_cmd = N'drop table #ASDiagnosisAndSpeciesType'
	execute sp_executesql @drop_cmd
end

if Object_ID('tempdb..#ASAnimal') is not null
begin
	set	@drop_cmd = N'drop table #ASAnimal'
	execute sp_executesql @drop_cmd
end

if Object_ID('tempdb..#ActiveSurveillanceSessionSourceData') is not null
begin
	set	@drop_cmd = N'drop table #ActiveSurveillanceSessionSourceData'
	execute sp_executesql @drop_cmd
end

if Object_ID('tempdb..#VetAggregateAction') is not null
begin
	set	@drop_cmd = N'drop table #VetAggregateAction'
	execute sp_executesql @drop_cmd
end




end

