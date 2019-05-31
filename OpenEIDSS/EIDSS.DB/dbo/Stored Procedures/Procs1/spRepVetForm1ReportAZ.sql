

--##SUMMARY Select data for REPORT ON ANIMALS QUARANTINE DISEASE report.

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepVetForm1ReportAZ @LangID=N'en', @FromYear = 2012, @ToYear = 2014
exec dbo.spRepVetForm1ReportAZ 'ru',2012,2013, @OrganizationEntered = 48120000000, @OrganizationID = 48120000000

*/

CREATE  Procedure [dbo].[spRepVetForm1ReportAZ]
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
as
begin

declare	@drop_cmd	nvarchar(4000)

-- Drop temporary tables
if Object_ID('tempdb..#VetCaseTable') is not null
begin
	set	@drop_cmd = N'drop table #VetCaseTable'
	execute sp_executesql @drop_cmd
end

DECLARE @Result AS TABLE
(
	strDiagnosisSpeciesKey		NVARCHAR(200) collate database_default NOT NULL PRIMARY KEY,
	idfsDiagnosis				BIGINT NOT NULL,
	strDiagnosisName			NVARCHAR(2000) collate database_default null,
	strOIECode					NVARCHAR(200) collate database_default null,
	strSpecies					NVARCHAR(2000) collate database_default null,
	intNumberSensSpecies		INT null,
	intNumberUnhealthySt		INT null,
	intNumberSick				INT null,
	intNumberDead				INT null,
	intNumberVaccinated			INT null,
	intOtherMeasures 			INT null,
	intNumberAnnihilated		INT null,
	intNumberSlaughtered		INT null,
	intNumberUnhealthyStLeft	INT null,
	intNumberDiseased			INT null,
	SpeciesOrderColumn			INT null,
	DiagnosisOrderColumn		INT null,
	strFooterPerformer			nvarchar(2000) collate database_default null
)
/*
insert into @Result Values('aaa', 7718320000000, 'diagnos', 'B051', 'dog', 12, 23, 34, 45, 56, 67, 78, 89, 90, 111, 1, 1, 'sentby', 'Vasya Pupkin')
insert into @Result Values('b', 7718320000000, 'diagnos', 'B051', 'cat', 13, 24, 35, 46, 57, 68, 79, 80, 91, 112, 1, 1, 'sentby', 'Vasya Pupkin')
insert into @Result Values('c', 7718730000000, 'diagnos2', 'B103, B152, B253', 'sheep', 12, 23, 34, 45, 56, 67, 78, 89, 90, 111, 1, 1, 'sentby', 'Vasya Pupkin')
insert into @Result Values('в', 7718350000000, 'diagnos3', 'B0512', 'cat', 13, 24, 35, 46, 57, 68, 79, 80, 91, 112, 1, 1, 'sentby', 'Vasya Pupkin')
insert into @Result Values('ф', 7718760000000, 'diagnos4', 'B1031, B152, B253', 'sheep', 12, 23, 34, 45, 56, 67, 78, 89, 90, 111, 1, 1, 'sentby', 'Vasya Pupkin')
insert into @Result Values('aaa1', 7718520000000, 'diagnos5', 'B051', 'dog', 12, 23, 34, 45, 56, 67, 78, 89, 90, 111, 1, 1, 'sentby', 'Vasya Pupkin')
insert into @Result Values('b1', 7718520000000, 'diagnos5', 'B051', 'cat', 13, 24, 35, 46, 57, 68, 79, 80, 91, 112, 1, 1, 'sentby', 'Vasya Pupkin')
*/

declare	@idfsSummaryReportType	bigint
set	@idfsSummaryReportType = 10290032	-- Veterinary Report Form Vet 1


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

select	@vet_form_1_use_specific_gis = at.idfAttributeType
from	trtAttributeType at
where	at.strAttributeTypeName = N'vet_form_1_use_specific_gis'

select	@vet_form_1_specific_gis_region = at.idfAttributeType
from	trtAttributeType at
where	at.strAttributeTypeName = N'vet_form_1_specific_gis_region'

select	@vet_form_1_specific_gis_rayon = at.idfAttributeType
from	trtAttributeType at
where	at.strAttributeTypeName = N'vet_form_1_specific_gis_rayon'

DECLARE @SpecificOfficeId BIGINT
SELECT
	 @SpecificOfficeId = ts.idfOffice
FROM tstSite ts 
WHERE ts.intRowStatus = 0
	AND ts.intFlags = 100 /*organization with abbreviation = Baku city VO*/

declare	@Livestock_Vaccinated_number bigint
declare	@Avian_Vaccinated_number	bigint

declare	@Livestock_Quarantined_number	bigint
declare	@Avian_Quarantined_number	bigint

declare	@Livestock_Desinfected_number	bigint
declare	@Avian_Desinfected_number	bigint

declare	@Livestock_Number_selected_for_monitoring	bigint
declare	@Avian_Number_selected_for_monitoring	bigint

declare	@Livestock_Annihilated_number	bigint
declare	@Avian_Annihilated_number	bigint

declare	@Livestock_Slaughtered_number	bigint
declare	@Avian_Slaughtered_number	bigint

declare	@Livestock_Number_of_diseased_left	bigint
declare	@Avian_Number_of_diseased_left	bigint

-- Vaccinated_number - start
select		@Livestock_Vaccinated_number = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Livestock_Vaccinated_number'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0

select		@Avian_Vaccinated_number = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Avian_Vaccinated_number'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0
-- Vaccinated_number - end

-- Quarantined_number - start
select		@Livestock_Quarantined_number = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Livestock_Quarantined_number'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0

select		@Avian_Quarantined_number = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Avian_Quarantined_number'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0
-- Quarantined_number - end

-- Desinfected_number - start
select		@Livestock_Desinfected_number = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Livestock_Desinfected_number'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0

select		@Avian_Desinfected_number = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Avian_Desinfected_number'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0
-- Desinfected_number - end

-- Number_selected_for_monitoring - start
select		@Livestock_Number_selected_for_monitoring = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Livestock_Number_selected_for_monitoring'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0

select		@Avian_Number_selected_for_monitoring = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Avian_Number_selected_for_monitoring'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0
-- Number_selected_for_monitoring - end

-- Annihilated_number - start
select		@Livestock_Annihilated_number = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Livestock_Annihilated_number'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0

select		@Avian_Annihilated_number = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Avian_Annihilated_number'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0
-- Annihilated_number - end

-- Slaughtered_number - start
select		@Livestock_Slaughtered_number = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Livestock_Slaughtered_number'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0

select		@Avian_Slaughtered_number = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Avian_Slaughtered_number'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0
-- Slaughtered_number - end

-- Number_of_diseased_left - start
select		@Livestock_Number_of_diseased_left = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Livestock_Number_of_diseased_left'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0

select		@Avian_Number_of_diseased_left = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Avian_Number_of_diseased_left'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0
-- Number_of_diseased_left - end


create table #VetCaseTable
(	idfID							bigint not null identity (1, 1) primary key,
	idfVetCase						bigint not null,
	strDiagnosisSpeciesKey			nvarchar(200) collate database_default not null,
	idfsDiagnosis					bigint not null,
	strDiagnosisName				nvarchar(2000) collate database_default null,
	strOIECode						nvarchar(200) collate database_default null,
	strSpecies						nvarchar(2000) collate database_default null,
	SpeciesOrderColumn				int null,
	DiagnosisOrderColumn			int null,
	idfsSpeciesType					bigint not null,
	idfSpecies						bigint not null,
	idfObservation					bigint not null,
	intDeadAnimalQty				int null,
	intSickAnimalQty				int null,
	intTotalAnimalQty				int null,
	intVaccinatedNumber				int null,
	intVaccinatedNumber_FF			int null,
	intQuarantinedNumber			int null,
	intDesinfectedNumber			int null,
	intSelectedForMonitoringNumber	int null,
	intAnnihilatedNumber			int null,
	intSlaughteredNumber			int null,
	intDiseasedLeftNumber			int null
)

insert into	#VetCaseTable
(	idfVetCase,
	strDiagnosisSpeciesKey,
	idfsDiagnosis,
	strDiagnosisName,
	strOIECode,
	strSpecies,
	SpeciesOrderColumn,
	DiagnosisOrderColumn,
	idfsSpeciesType,
	idfSpecies,
	idfObservation,
	intDeadAnimalQty,
	intSickAnimalQty,
	intTotalAnimalQty,
	intVaccinatedNumber,
	intVaccinatedNumber_FF,
	intQuarantinedNumber,
	intDesinfectedNumber,
	intSelectedForMonitoringNumber,
	intAnnihilatedNumber,
	intSlaughteredNumber,
	intDiseasedLeftNumber
)
select		vc.idfVetCase as idfVetCase,
			cast(isnull(Actual_Diagnosis.idfsDiagnosis, d.idfsDiagnosis) as nvarchar(20)) + N'_' + 
				cast(isnull(Actual_Species_Type.idfsSpeciesType, sp.idfsSpeciesType) as nvarchar(20)) as strDiagnosisSpeciesKey,
			isnull(Actual_Diagnosis.idfsDiagnosis, d.idfsDiagnosis) as idfsDiagnosis,
			isnull(r_d.[name], N'') as strDiagnosisName,
			isnull(Actual_Diagnosis.strOIECode, isnull(d.strOIECode, N'')) as strOIECode,
			isnull(r_sp.[name], N'') as strSpecies,
			isnull(Actual_Species_Type.intOrder, isnull(r_sp.intOrder, -1000)) as SpeciesOrderColumn,
			isnull(Actual_Diagnosis.intOrder, isnull(r_d.intOrder, -1000)) as DiagnosisOrderColumn,
			isnull(Actual_Species_Type.idfsSpeciesType, sp.idfsSpeciesType) as idfsSpeciesType,
			sp.idfSpecies as idfSpecies,
			obs.idfObservation as idfObservation,
			isnull(sp.intDeadAnimalQty, 0) as intDeadAnimalQty,
			isnull(sp.intSickAnimalQty, 0) as intSickAnimalQty,
			isnull(sp.intTotalAnimalQty, isnull(sp.intDeadAnimalQty, 0) + isnull(sp.intSickAnimalQty, 0)) as intTotalAnimalQty,
			max(isnull(vac.intNumberVaccinated, 0)) as intNumberVaccinated,
			isnull(cast(Vaccinated_number.varValue as int), 0) as intNumberVaccinated_FF,
			isnull(cast(Quarantined_number.varValue as int), 0) as intQuarantinedNumber,
			isnull(cast(Desinfected_number.varValue as int), 0) as intDesinfectedNumber,
			isnull(cast(Number_selected_for_monitoring.varValue as int), 0) as intSelectedForMonitoringNumber,
			isnull(cast(Annihilated_number.varValue as int), 0) as intAnnihilatedNumber,
			isnull(cast(Slaughtered_number.varValue as int), 0) as intSlaughteredNumber,
			isnull(cast(Number_of_diseased_left.varValue as int), 0) as intDiseasedLeftNumber
from		
-- Veterinary Case
			tlbVetCase vc

-- Diagnosis = Final Diagnosis of Veterinary Case
inner join	trtDiagnosis d
	inner join	fnReferenceRepair(@LangID, 19000019) r_d
	on			r_d.idfsReference = d.idfsDiagnosis

	-- Not deleted diagnosis with the same name and using type
	outer apply (
 		select top 1
 					d_actual.idfsDiagnosis, r_d_actual.intOrder, d_actual.strOIECode
 		from		trtDiagnosis d_actual
		inner join	fnReference(@LangID, 19000019) r_d_actual
		on			r_d_actual.idfsReference = d_actual.idfsDiagnosis
 		where		d_actual.idfsUsingType = d.idfsUsingType
					and d_actual.intRowStatus = 0
					and r_d_actual.[name] = r_d.[name]
 		order by d_actual.idfsDiagnosis asc
 			) as  Actual_Diagnosis
				
on			d.idfsDiagnosis = vc.idfsFinalDiagnosis
			and d.idfsUsingType = 10020001	/*Case-based*/

-- Species - start
inner join	tlbFarm f
-- Region and Rayon
	left join	tlbGeoLocation gl
		left join	fnGisReferenceRepair(@LangID, 19000003) reg
		on			reg.idfsReference = gl.idfsRegion
		left join	fnGisReferenceRepair(@LangID, 19000002) ray
		on			ray.idfsReference = gl.idfsRayon
	on			gl.idfGeoLocation = f.idfFarmAddress
on			f.idfFarm = vc.idfFarm
			and f.intRowStatus = 0
inner join	tlbHerd h
on			h.idfFarm = f.idfFarm
			and h.intRowStatus = 0
inner join	tlbSpecies sp
	inner join	fnReferenceRepair(@LangID, 19000086) r_sp
	on			r_sp.idfsReference = sp.idfsSpeciesType

	-- Not deleted species type with the same name
	outer apply (
 		select top 1
 					st_actual.idfsSpeciesType, r_sp_actual.intOrder
 		from		trtSpeciesType st_actual
		inner join	fnReference(@LangID, 19000086) r_sp_actual
		on			r_sp_actual.idfsReference = st_actual.idfsSpeciesType
 		where		st_actual.intRowStatus = 0
					and r_sp_actual.[name] = r_sp.[name]
 		order by st_actual.idfsSpeciesType asc
 			) as  Actual_Species_Type

on			sp.idfHerd = h.idfHerd
			and sp.intRowStatus = 0
			-- not blank value in Sick and/or Dead fields
			and (	sp.intDeadAnimalQty is not null
					or sp.intSickAnimalQty is not null
				)
-- Species - end

-- Site, Organization entered case
inner join	tstSite s 
	left join	fnInstitutionRepair(@LangID) i
	on			i.idfOffice = CASE WHEN s.intFlags = 10 THEN @SpecificOfficeId ELSE s.idfOffice END
on			s.idfsSite = vc.idfsSite

-- Specific Region and Rayon for the site with specific attributes (B46)
left join	trtBaseReferenceAttribute bra
	left join	trtGISBaseReferenceAttribute gis_bra_region
		inner join	fnGisReferenceRepair(@LangID, 19000003) reg_specific
		on			reg_specific.idfsReference = gis_bra_region.idfsGISBaseReference
	on			cast(gis_bra_region.varValue as nvarchar) = cast(bra.varValue as nvarchar)
				and gis_bra_region.idfAttributeType = @vet_form_1_specific_gis_region
	left join	trtGISBaseReferenceAttribute gis_bra_rayon
		inner join	fnGisReferenceRepair(@LangID, 19000002) ray_specific
		on			ray_specific.idfsReference = gis_bra_rayon.idfsGISBaseReference
	on			cast(gis_bra_rayon.varValue as nvarchar) = cast(bra.varValue as nvarchar)
				and gis_bra_rayon.idfAttributeType = @vet_form_1_specific_gis_rayon
on			bra.idfsBaseReference = i.idfsOfficeAbbreviation
			and bra.idfAttributeType = @vet_form_1_use_specific_gis
			and cast(bra.varValue as nvarchar) = s.strSiteID

-- Vaccination records
left join	tlbVaccination vac
on			vac.idfVetCase = vc.idfVetCase
			and vac.idfSpecies = sp.idfSpecies
			and vac.idfsDiagnosis = d.idfsDiagnosis -- NOT from specification, but from common sense
			and vac.intNumberVaccinated is not null
			and vac.intRowStatus = 0


-- Species Observation
left join	tlbObservation	obs
on			obs.idfObservation = sp.idfObservation


-- FF values

-- Vaccinated_number
outer apply ( 
 	select top 1
 			ap.varValue
 	from	tlbActivityParameters ap
 	where	ap.idfObservation = obs.idfObservation
			and ap.idfsParameter in (@Livestock_Vaccinated_number, @Avian_Vaccinated_number)
			and ap.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(ap.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			and ap.varValue is not null
			and not exists	(
						select	*
						from	tlbVaccination vac_ex
						where	vac_ex.idfVetCase = vc.idfVetCase
								and vac_ex.idfSpecies = sp.idfSpecies
								and vac_ex.idfsDiagnosis = d.idfsDiagnosis -- NOT from specification, but from common sense
								and vac_ex.intNumberVaccinated is not null
								and vac_ex.intRowStatus = 0
							)
 			order by ap.idfRow asc
 		) as  Vaccinated_number

-- Quarantined_number
outer apply ( 
 	select top 1
 			ap.varValue
 	from	tlbActivityParameters ap
 	where	ap.idfObservation = obs.idfObservation
			and ap.idfsParameter in (@Livestock_Quarantined_number, @Avian_Quarantined_number)
			and ap.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(ap.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			and ap.varValue is not null
 			order by ap.idfRow asc
 		) as  Quarantined_number

-- Desinfected_number
outer apply ( 
 	select top 1
 			ap.varValue
 	from	tlbActivityParameters ap
 	where	ap.idfObservation = obs.idfObservation
			and ap.idfsParameter in (@Livestock_Desinfected_number, @Avian_Desinfected_number)
			and ap.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(ap.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			and ap.varValue is not null
 			order by ap.idfRow asc
 		) as  Desinfected_number

-- Number_selected_for_monitoring
outer apply ( 
 	select top 1
 			ap.varValue
 	from	tlbActivityParameters ap
 	where	ap.idfObservation = obs.idfObservation
			and ap.idfsParameter in (@Livestock_Number_selected_for_monitoring, @Avian_Number_selected_for_monitoring)
			and ap.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(ap.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			and ap.varValue is not null
 			order by ap.idfRow asc
 		) as  Number_selected_for_monitoring

-- Annihilated_number
outer apply ( 
 	select top 1
 			ap.varValue
 	from	tlbActivityParameters ap
 	where	ap.idfObservation = obs.idfObservation
			and ap.idfsParameter in (@Livestock_Annihilated_number, @Avian_Annihilated_number)
			and ap.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(ap.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			and ap.varValue is not null
 			order by ap.idfRow asc
 		) as  Annihilated_number

-- Slaughtered_number
outer apply ( 
 	select top 1
 			ap.varValue
 	from	tlbActivityParameters ap
 	where	ap.idfObservation = obs.idfObservation
			and ap.idfsParameter in (@Livestock_Slaughtered_number, @Avian_Slaughtered_number)
			and ap.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(ap.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			and ap.varValue is not null
 			order by ap.idfRow asc
 		) as  Slaughtered_number

-- Number_of_diseased_left
outer apply ( 
 	select top 1
 			ap.varValue
 	from	tlbActivityParameters ap
 	where	ap.idfObservation = obs.idfObservation
			and ap.idfsParameter in (@Livestock_Number_of_diseased_left, @Avian_Number_of_diseased_left)
			and ap.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(ap.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			and ap.varValue is not null
 			order by ap.idfRow asc
 		) as  Number_of_diseased_left


where		vc.intRowStatus = 0
			-- Case Classification = Confirmed
			and vc.idfsCaseClassification = 350000000	/*Confirmed*/
			
			-- From Year, Month To Year, Month
			and isnull(vc.datFinalDiagnosisDate, vc.datTentativeDiagnosis1Date) >= @StartDate
			and isnull(vc.datFinalDiagnosisDate, vc.datTentativeDiagnosis1Date) < @EndDate
			
			-- Region
			and (@RegionID is null or (@RegionID is not null and isnull(reg_specific.idfsReference, reg.idfsReference) = @RegionID))
			-- Rayon
			and (@RayonID is null or (@RayonID is not null and isnull(ray_specific.idfsReference, ray.idfsReference) = @RayonID))
			
			-- Entered by organization
			and (@OrganizationEntered is null or (@OrganizationEntered is not null and i.idfOffice = @OrganizationEntered))

group by	vc.idfVetCase,
			cast(isnull(Actual_Diagnosis.idfsDiagnosis, d.idfsDiagnosis) as nvarchar(20)) + N'_' + 
				cast(isnull(Actual_Species_Type.idfsSpeciesType, sp.idfsSpeciesType) as nvarchar(20)),
			isnull(Actual_Diagnosis.idfsDiagnosis, d.idfsDiagnosis),
			isnull(r_d.[name], N''),
			isnull(Actual_Diagnosis.strOIECode, isnull(d.strOIECode, N'')),
			isnull(r_sp.[name], N''),
			isnull(Actual_Species_Type.intOrder, isnull(r_sp.intOrder, -1000)),
			isnull(Actual_Diagnosis.intOrder, isnull(r_d.intOrder, -1000)),
			isnull(Actual_Species_Type.idfsSpeciesType, sp.idfsSpeciesType),
			sp.idfSpecies,
			obs.idfObservation,
			isnull(sp.intDeadAnimalQty, 0),
			isnull(sp.intSickAnimalQty, 0),
			isnull(sp.intTotalAnimalQty, isnull(sp.intDeadAnimalQty, 0) + isnull(sp.intSickAnimalQty, 0)),
			isnull(cast(Vaccinated_number.varValue as int), 0),
			isnull(cast(Quarantined_number.varValue as int), 0),
			isnull(cast(Desinfected_number.varValue as int), 0),
			isnull(cast(Number_selected_for_monitoring.varValue as int), 0),
			isnull(cast(Annihilated_number.varValue as int), 0),
			isnull(cast(Slaughtered_number.varValue as int), 0),
			isnull(cast(Number_of_diseased_left.varValue as int), 0)

insert into	@Result
(	strDiagnosisSpeciesKey,
	idfsDiagnosis,
	strDiagnosisName,
	strOIECode,
	strSpecies,
	intNumberSensSpecies,
	intNumberUnhealthySt,
	intNumberSick,
	intNumberDead,
	intNumberVaccinated,
	intOtherMeasures,
	intNumberAnnihilated,
	intNumberSlaughtered,
	intNumberUnhealthyStLeft,
	intNumberDiseased,
	SpeciesOrderColumn,
	DiagnosisOrderColumn,
	strFooterPerformer
)
select distinct
			vct.strDiagnosisSpeciesKey,
			vct.idfsDiagnosis,
			vct.strDiagnosisName,
			vct.strOIECode,
			vct.strSpecies,
			sum(isnull(vct.intTotalAnimalQty, 0) - isnull(vct.intSickAnimalQty, 0) - isnull(vct.intDeadAnimalQty, 0)), /*intNumberSensSpecies - Number of sensitive species*/
			count(vct.idfVetCase), /*intNumberUnhealthySt - Number of unhealthy stations*/
			sum(isnull(vct.intSickAnimalQty, 0)), /*intNumberSick - Number of sick*/
			sum(isnull(vct.intDeadAnimalQty, 0)), /*intNumberDead - Number of dead*/
			sum(isnull(vct.intVaccinatedNumber, 0) + isnull(vct.intVaccinatedNumber_FF, 0)), /*intNumberVaccinated - Vaccinated*/
			sum(isnull(vct.intQuarantinedNumber, 0) + 
				isnull(vct.intDesinfectedNumber, 0) + 
				isnull(vct.intSelectedForMonitoringNumber, 0)), /*intOtherMeasures - Other measures (disinfection, monitoring and etc.)*/
			sum(isnull(vct.intAnnihilatedNumber, 0)), /*intNumberAnnihilated - Annihilated*/
			sum(isnull(vct.intSlaughteredNumber, 0)), /*intNumberSlaughtered - Slaughtered*/
			0, /*intNumberUnhealthyStLeft - Left until the end of the reported period: Number of unhealthy stations*/
			sum(isnull(vct.intDiseasedLeftNumber, 0)), /*intNumberDiseased - Left until the end of the reported period: Number of diseased*/
			vct.SpeciesOrderColumn,
			vct.DiagnosisOrderColumn,
			@FooterNameOfPerformer

from		#VetCaseTable vct

group by	vct.strDiagnosisSpeciesKey,
			vct.idfsDiagnosis,
			vct.strDiagnosisName,
			vct.strOIECode,
			vct.strSpecies,
			vct.SpeciesOrderColumn,
			vct.DiagnosisOrderColumn

/*intNumberUnhealthyStLeft - Left until the end of the reported period: Number of unhealthy stations*/
update		r
set			r.intNumberUnhealthyStLeft = 
			(	select	count(vct.idfVetCase)
				from	#VetCaseTable vct
				where	vct.strDiagnosisSpeciesKey = r.strDiagnosisSpeciesKey
						and vct.intDiseasedLeftNumber > 0
			)
from		@Result r

-- Select report informative part - start

-- Return results
if (SELECT count(*) FROM @result) = 0
	select	'' as strDiagnosisSpeciesKey,
	- 1 as idfsDiagnosis,
	'' as strDiagnosisName,
	'' as strOIECode, 
	'' as strSpecies,
	null as intNumberSensSpecies, 
	null as intNumberUnhealthySt, 
	null as intNumberSick, 
	null as intNumberDead, 
	null as intNumberVaccinated, 
	null as intOtherMeasures, 
	null as intNumberAnnihilated, 
	null as intNumberSlaughtered, 
	null as intNumberUnhealthyStLeft, 
	null as intNumberDiseased, 
	null as SpeciesOrderColumn, 
	null as DiagnosisOrderColumn, 
	@FooterNameOfPerformer as strFooterPerformer
else
	SELECT * FROM @result ORDER BY DiagnosisOrderColumn, strDiagnosisName, idfsDiagnosis, SpeciesOrderColumn


-- Drop temporary tables
if Object_ID('tempdb..#VetCaseTable') is not null
begin
	set	@drop_cmd = N'drop table #VetCaseTable'
	execute sp_executesql @drop_cmd
end
	     
end
