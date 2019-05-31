
--##SUMMARY

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 10.02.2016


--##RETURNS Doesn't use

/*
--Example of procedure call:
EXEC sptemp_CreateTestData 
	@OrganizationAbbreviation = NULL
	, @StreetName = NULL
	, @StartDate = '2013-01-01 12:00:00:00'
	, @DateRangeInDays = 365
	
	, @TotalHumanCase = 0
	, @TotalHumanCaseAVR = 0
	, @TotalHumanAggrCase = 0
	, @TotalVetAggrCase = 0
	, @TotalVetAggrAction = 0
	, @TotalILIAggr = 0
	, @TotalVetCase = 0
	, @TotalVetCaseAVR = 0
	, @TotalSyndromicSurveillance = 0
	, @TotalBatch = 0
	, @TotalOutbreak = 0
	, @TotalVSSession = 0
	, @TotalCampaign = 2
	
	, @FreezerGenerate = 0
*/

CREATE PROC [dbo].[sptemp_CreateTestData](
	@OrganizationAbbreviation NVARCHAR(200) = NULL,
	@StreetName NVARCHAR(255) = NULL,
	@StartDate DATETIME = NULL,
	@DateRangeInDays INT = NULL,
	
	@TotalHumanCase INT = NULL,
	@TotalHumanCaseAVR INT = NULL,
	@TotalHumanAggrCase INT = NULL,
	@TotalVetAggrCase INT = NULL,
	@TotalVetAggrAction INT = NULL,
	@TotalILIAggr INT = NULL,
	@TotalVetCase INT = NULL,
	@TotalVetCaseAVR INT = NULL,
	@TotalSyndromicSurveillance INT = NULL,
	@TotalBatch INT = NULL,
	@TotalOutbreak INT = NULL,
	@TotalVSSession INT = NULL,
	@TotalCampaign INT = NULL,
	
	@FreezerGenerate BIT = NULL
)
AS
	
SET NOCOUNT ON
SET DATEFORMAT dmy
SET DATEFIRST 1


DECLARE @Employee AS TABLE (
	IdRow INT IDENTITY
	, PersonId BIGINT
	, UserId BIGINT
	, EmployeeFirstName NVARCHAR(200)
	, EmployeeLastName NVARCHAR(200)
	, EmployeeAccountName NVARCHAR(200)
)

DECLARE @AggrEmployee AS TABLE (
	IdRow INT IDENTITY
	, PersonId BIGINT
	, UserId BIGINT
	, EmployeeFirstName NVARCHAR(200)
	, EmployeeLastName NVARCHAR(200)
)

DECLARE @FirstName AS TABLE (
	IdRow INT IDENTITY
	, FirstName NVARCHAR(200)
	, HumanGender NVARCHAR(200)
)

DECLARE @LastName AS TABLE (
	IdRow INT IDENTITY
	, LastName NVARCHAR(200)
	, HumanGender NVARCHAR(200)
)

DECLARE @Region AS TABLE (
	IdRow INT IDENTITY
	, RegionName NVARCHAR(200)
	, RegionId BIGINT
)



/*---------parameters BEGIN------------*/

SET @TotalHumanCase = ISNULL(@TotalHumanCase, 30)
SET @TotalHumanCaseAVR = ISNULL(@TotalHumanCaseAVR, 200)
SET @TotalHumanAggrCase = ISNULL(@TotalHumanAggrCase, 30)
SET @TotalVetAggrCase = ISNULL(@TotalVetAggrCase, 30)
SET @TotalVetAggrAction = ISNULL(@TotalVetAggrAction, 30)
SET @TotalILIAggr = ISNULL(@TotalILIAggr, 30)
SET @TotalVetCase = ISNULL(@TotalVetCase, 30)
SET @TotalVetCaseAVR = ISNULL(@TotalVetCaseAVR, 200)
SET @TotalSyndromicSurveillance = ISNULL(@TotalSyndromicSurveillance, 30)
SET @TotalBatch = ISNULL(@TotalBatch, 30)
SET @TotalOutbreak = ISNULL(@TotalOutbreak, 30)
SET @TotalVSSession = ISNULL(@TotalVSSession, 30)
SET @TotalCampaign = ISNULL(@TotalCampaign, 30)


SET @StartDate = ISNULL(@StartDate, '2015-01-01 12:00:00:00')
SET @DateRangeInDays = ISNULL(@DateRangeInDays, 300)

IF DATEADD(DAY, @DateRangeInDays, @StartDate) >= GETDATE()
BEGIN
	RAISERROR ('The end of the date range appears to be in future. Correct either the start date or the range duration.', 1, 1)
	RETURN
END


DECLARE @CurrentCustomization BIGINT = dbo.fnCurrentCustomization()
	, @CurrentCountry BIGINT = dbo.fnCurrentCountry()
	, @CustomizationPackage BIGINT = dbo.fnCustomizationPackage()

IF @CurrentCustomization = 51577400000000/*Armenia*/
BEGIN 
	SET @OrganizationAbbreviation = ISNULL(@OrganizationAbbreviation, N'Kotayk Marz RVPCLS')

	SET @StreetName = ISNULL(@StreetName, N'Հալաբյան փողոց')

	INSERT INTO @Employee 
		(EmployeeFirstName, EmployeeLastName, EmployeeAccountName)
	VALUES
		(N'Արտակ', N'Արարատյան', N'AraratyanA')
		, (N'Սևակ', N'Սրապյան', N'SrapyanS')
		, (N'Մանուշ', N'Մակարյան', N'MakaryanM')
		, (N'Սարգսյան', N'Սարանդ', N'SargsyanS')
		, (N'Նարգիզ', N'Ներսիսյան', N'NersisyanN')

		, (N'Արա', N'Սարգսյան', N'SentByEmployee')

	INSERT INTO @FirstName
		(FirstName, HumanGender)
	VALUES
		(N'Արա', 'Male')
		, (N'Արտակ', 'Male')
		, (N'Բաբիկ', 'Male')
		, (N'Գուրգեն', 'Male')
		, (N'Զավեն', 'Male')
		, (N'Զորիկ', 'Male')
		, (N'Թաթուլ', 'Male')
		, (N'Թելման', 'Male')
		, (N'Դերենիկ', 'Male')
		, (N'Ծատուր', 'Male')
		, (N'Սևակ', 'Male')
		, (N'Սուրեն', 'Male')

		
		, (N'Անահիտ', 'Female')
		, (N'Ասյա', 'Female')
		, (N'Ալվարդ', 'Female')
		, (N'Գյուլնարա', 'Female')
		, (N'Սիրուն', 'Female')
		, (N'Նազելի', 'Female')
		, (N'Նունե', 'Female')
		, (N'Կլարա', 'Female')
		, (N'Նարգիզ', 'Female')
		, (N'Բելլա', 'Female')
		, (N'Դոնարա', 'Female')
		, (N'Վարսինե', 'Female')


	INSERT INTO @LastName
		(LastName, HumanGender)
	VALUES
		(N'Սարգսյան', 'Male') 
		, (N'Աբրահամյան', 'Male')
		, (N'Հարությունյան', 'Male')
		, (N'Պողոսյան', 'Male')
		, (N'Բալասանյան', 'Male')
		, (N'Բաբայան', 'Male')
		, (N'Գևորգյան', 'Male')
		, (N'Եկանյան', 'Male')
		, (N'Սարդարյան', 'Male')
		, (N'Մամիկոնյան', 'Male')
		, (N'Վարդանյան', 'Male')
		, (N'Զաքարյան', 'Male')
		, (N'Զավարյան', 'Male')
		, (N'Թադևոսյան', 'Male')
		, (N'Թաթոսյան', 'Male')
		, (N'Ժամկոչյան', 'Male')
		, (N'Իսրայելյան', 'Male')
		, (N'Իսկանդարյան', 'Male')
		, (N'Լալայան', 'Male')
		, (N'Լևոնյան', 'Male')
		, (N'Ծատուրյան', 'Male')
		, (N'Կարախանյան', 'Male')
		, (N'Հակոբյան', 'Male')
		, (N'Հաբաթյան', 'Male')

		, (N'Սարգսյան', 'Female') 
		, (N'Աբրահամյան', 'Female')
		, (N'Հարությունյան', 'Female')
		, (N'Պողոսյան', 'Female')
		, (N'Բալասանյան', 'Female')
		, (N'Բաբայան', 'Female')
		, (N'Գևորգյան', 'Female')
		, (N'Եկանյան', 'Female')
		, (N'Սարդարյան', 'Female')
		, (N'Մամիկոնյան', 'Female')
		, (N'Վարդանյան', 'Female')
		, (N'Զաքարյան', 'Female')
		, (N'Զավարյան', 'Female')
		, (N'Թադևոսյան', 'Female')
		, (N'Թաթոսյան', 'Female')
		, (N'Ժամկոչյան', 'Female')
		, (N'Իսրայելյան', 'Female')
		, (N'Իսկանդարյան', 'Female')
		, (N'Լալայան', 'Female')
		, (N'Լևոնյան', 'Female')
		, (N'Ծատուրյան', 'Female')
		, (N'Կարախանյան', 'Female')
		, (N'Հակոբյան', 'Female')
		, (N'Հաբաթյան', 'Female')

	INSERT INTO @Region
		(RegionName)
	VALUES 
		(N'Lori')
		, (N'Tavush')
		, (N'Shirak')
		, (N'Yerevan')
		, (N'Syunik')
END
ELSE IF @CurrentCustomization = 51577410000000/*Azerbaijan*/
BEGIN 
	SET @OrganizationAbbreviation = ISNULL(@OrganizationAbbreviation, N'SVCS')

	SET @StreetName = ISNULL(@StreetName, N'Rəşid Behbudov')

	INSERT INTO @Employee 
		(EmployeeFirstName, EmployeeLastName, EmployeeAccountName)
	VALUES
		(N'Kərim', N'Hüseynov', N'khuseynov')
		, (N'Lalə', N'Orucova', N'lorucova')
		, (N'Səbinə', N'Babayeva', N'sbabayeva')
		, (N'Tural', N'Rzayev', N'trzayev')
		, (N'Rauf', N'Muxtarov', N'rmuxtarov')

		, (N'rim', N'Muxtarov', N'SentByEmployee')

	INSERT INTO @FirstName
		(FirstName, HumanGender)
	VALUES		
		(N'Təbriz', 'Male')
		, (N'İlyas', 'Male')
		, (N'Tural', 'Male')
		, (N'Nicat', 'Male')
		, (N'Rauf', 'Male')
		, (N'Elmar', 'Male')
		, (N'Həci', 'Male')
		, (N'Emil', 'Male')
		, (N'Həsən', 'Male')
		, (N'Əli', 'Male')

		, (N'Səbinə', 'Female')
		, (N'Aynurə', 'Female')
		, (N'Leyla', 'Female')
		, (N'Çinarə', 'Female')
		, (N'Aysel', 'Female')
		, (N'Aydan', 'Female')
		, (N'Əzizə', 'Female')
		, (N'Esmira', 'Female')
		, (N'Kəmalə', 'Female')
		, (N'Lalə', 'Female')


	INSERT INTO @LastName
		(LastName, HumanGender)
	VALUES		
		(N'İbrahimov', 'Male')
		, (N'Rzayev', 'Male')
		, (N'Tağıyev', 'Male')
		, (N'Muxtarov', 'Male')
		, (N'Quliyev', 'Male')
		, (N'Süleymanov', 'Male')
		, (N'Orucov', 'Male')
		, (N'Balayev', 'Male')
		, (N'Abdullayev', 'Male')
		, (N'Paşayev', 'Male')
		, (N'Nərimanov', 'Male')
		, (N'Mustafayev', 'Male')
		, (N'Səmədov', 'Male')
		, (N'Mirzoyev', 'Male')
		, (N'Axundov', 'Male')
		, (N'Xanlarov', 'Male')
		, (N'Əzimov', 'Male')
		, (N'Əmirov', 'Male')
		, (N'Əsgərov', 'Male')
		, (N'Qəmbərov', 'Male')

		, (N'Hüseynova', 'Female')
		, (N'Əliyeva', 'Female')
		, (N'Məmmədova', 'Female')
		, (N'Novruzova', 'Female')
		, (N'Heydərova', 'Female')
		, (N'Nəsirova', 'Female')
		, (N'Nəbiyeva', 'Female')
		, (N'Zeynalova', 'Female')
		, (N'Qarayeva', 'Female')
		, (N'Kərimova', 'Female')
		, (N'Dadaşova', 'Female')
		, (N'Həbibova', 'Female')
		, (N'Həsənova', 'Female')
		, (N'Cəfərova', 'Female')
		, (N'Səfərova', 'Female')
		, (N'Vəliyeva', 'Female')
		, (N'Qasımova', 'Female')
		, (N'Mextiyeva', 'Female')
		, (N'Əmirova', 'Female')
		, (N'Babayeva', 'Female')

	INSERT INTO @Region
		(RegionName)
	VALUES 
		(N'Baku')
		, (N'Other rayons')
		, (N'Nakhichevan AR')
END
ELSE 
BEGIN
	SET @OrganizationAbbreviation = ISNULL(@OrganizationAbbreviation, N'MoLHSA')

	SET @StreetName = ISNULL(@StreetName, N'Green')
	
	INSERT INTO @Employee 
		(EmployeeFirstName, EmployeeLastName, EmployeeAccountName)
	VALUES
		(N'Kate', N'Miller', N'Miller.Kate')
		, (N'John', N'Smith', N'Smith.John')
		, (N'David', N'Fox', N'Fox.David')
		, (N'Ann', N'Johnson', N'Johnson.Ann')
		, (N'Helen', N'Brown', N'Brown.Helen')
		
		, (N'Kate', N'Smith', N'SentByEmployee')

	INSERT INTO @FirstName
		(FirstName, HumanGender)
	VALUES
		(N'Jacob', 'Male')
		, (N'Ethan', 'Male')
		, (N'Michael', 'Male')
		, (N'Alexander', 'Male')
		, (N'William', 'Male')
		, (N'Joshua', 'Male')
		, (N'Daniel', 'Male')
		, (N'Jayden', 'Male')
		, (N'Noah', 'Male')
		, (N'Anthony', 'Male')
		
		, (N'Emma', 'Female')
		, (N'Olivia', 'Female')
		, (N'Ava', 'Female')
		, (N'Mia', 'Female')
		, (N'Amelia', 'Female')
		, (N'Madison', 'Female')
		, (N'Abigail', 'Female')
		, (N'Lily', 'Female')
		, (N'Ella', 'Female')
		, (N'Chloe', 'Female')

	INSERT INTO @LastName
		(LastName, HumanGender)
	VALUES
		(N'Smith', 'Male') 
		, (N'Johnson', 'Male')
		, (N'Williams', 'Male')
		, (N'Jones', 'Male')
		, (N'Brown', 'Male')
		, (N'Davis', 'Male')
		, (N'Miller', 'Male')
		, (N'Wilson', 'Male')
		, (N'Moore', 'Male')
		, (N'Taylor', 'Male')
		, (N'Anderson', 'Male')
		, (N'Thomas', 'Male')
		, (N'Jackson', 'Male')
		, (N'White', 'Male')
		, (N'Harris', 'Male')
		, (N'Martin', 'Male')
		
		, (N'Smith', 'Female') 
		, (N'Johnson', 'Female')
		, (N'Williams', 'Female')
		, (N'Jones', 'Female')
		, (N'Brown', 'Female')
		, (N'Davis', 'Female')
		, (N'Miller', 'Female')
		, (N'Wilson', 'Female')
		, (N'Moore', 'Female')
		, (N'Taylor', 'Female')
		, (N'Anderson', 'Female')
		, (N'Thomas', 'Female')
		, (N'Jackson', 'Female')
		, (N'White', 'Female')
		, (N'Harris', 'Female')
		, (N'Martin', 'Female')

	INSERT INTO @Region
		(RegionName)
	VALUES 
		(N'Apkhazeti')
		, (N'Adjara')
		, (N'Guria')
		, (N'Imereti')
		, (N'Kakheti')
END
/*-------------parameters END---------*/	
	


DECLARE @CurrentSite BIGINT = 0

SELECT
	@CurrentSite = ts.idfsSite
FROM trtBaseReference tbr
JOIN tlbOffice to1 ON
	to1.idfsOfficeAbbreviation = tbr.idfsBaseReference
	AND to1.intRowStatus = 0
JOIN tstSite ts ON
	ts.idfOffice = to1.idfOffice
	AND ts.intRowStatus = 0
	AND ts.blnIsWEB = 0
WHERE tbr.strDefault = @OrganizationAbbreviation
	AND tbr.intRowStatus = 0

IF @CurrentSite = 0 
BEGIN
	RAISERROR ('No site required', 1, 1)
	RETURN
END	
	
		
DELETE FROM tstNewID

INSERT INTO tstNewID
	(idfKey1, idfTable)
SELECT
	IdRow
	, 75690000000 /*tlbPerson*/
FROM @Employee

UPDATE e 
SET e.PersonId = tni.[NewID]
FROM @Employee e 
JOIN tstNewID tni ON
	tni.idfKey1 = e.IdRow
	AND tni.idfTable = 75690000000 /*tlbPerson*/
	
	
INSERT INTO tstNewID
	(idfKey1, idfTable)
SELECT
	IdRow
	, 76190000000 /*tstUserTable*/
FROM @Employee

UPDATE e 
SET e.UserId = tni.[NewID]
FROM @Employee e 
JOIN tstNewID tni ON
	tni.idfKey1 = e.IdRow
	AND tni.idfTable = 76190000000 /*tstUserTable*/

DELETE FROM tstNewID

INSERT INTO tstNewID
	(idfKey1, idfTable)
SELECT
	IdRow
	, 75690000000 /*tlbPerson*/
FROM @AggrEmployee

UPDATE e 
SET e.PersonId = tni.[NewID]
FROM @AggrEmployee e 
JOIN tstNewID tni ON
	tni.idfKey1 = e.IdRow
	AND tni.idfTable = 75690000000 /*tlbPerson*/
	
	
INSERT INTO tstNewID
	(idfKey1, idfTable)
SELECT
	IdRow
	, 76190000000 /*tstUserTable*/
FROM @AggrEmployee

UPDATE e 
SET e.UserId = tni.[NewID]
FROM @AggrEmployee e 
JOIN tstNewID tni ON
	tni.idfKey1 = e.IdRow
	AND tni.idfTable = 76190000000 /*tstUserTable*/

DELETE FROM tstNewID


DECLARE @SentByOrganizationAbbreviation NVARCHAR(500)
	
SELECT TOP 1
	@SentByOrganizationAbbreviation = tbr.strDefault
FROM trtBaseReference tbr
JOIN tlbOffice to1 ON
	to1.idfsOfficeAbbreviation = tbr.idfsBaseReference
	AND to1.intRowStatus = 0
JOIN tstSite ts ON
	ts.idfOffice = to1.idfOffice
	AND ts.intRowStatus = 0
	AND ts.blnIsWEB = 0
WHERE tbr.intRowStatus = 0
	AND tbr.strDefault <> @OrganizationAbbreviation
ORDER BY NEWID()


UPDATE r
SET RegionId = gr.idfsRegion
FROM @Region r
JOIN gisBaseReference gbr ON
	gbr.idfsGISReferenceType = 19000003
	AND gbr.strDefault = r.RegionName COLLATE DATABASE_DEFAULT
	AND gbr.intRowStatus = 0
JOIN gisRegion gr ON
	gr.idfsRegion = gbr.idfsGISBaseReference
	AND gr.intRowStatus = 0



/*----------------------CREATE EMPLOYESS BEGIN----------------------------------------------------*/


-- This script creates employees of specified orginizations with specified account names and passwords on specified sites.
-- It configures all applicable "Allow" permissions on the sites, to which employees belongs, and on the sites, for which accounts will be created.
--
-- NB! Account names and passwords shall contain English symbols, digits, spaces and points only.
-- NB! Employee organization abbreviations shall be the same for the same account names and different sites abbreviations in the list.
-- NB! Pairs of account names and sites abbreviations shall be unique in the list.

--SET ANSI_NULLS ON
--SET QUOTED_IDENTIFIER ON
--GO

--ALTER	function [dbo].[fnTriggersWork] ()
--returns bit
--as
--begin
--return 0
--end
--GO

set nocount on
set XACT_ABORT on	

BEGIN TRAN

declare	@UserTable	table
(	idfID								bigint not null identity(1, 2),
	strEmployeeOrganizationAbbreviation	nvarchar(500) collate database_default not null,
	strFirstName						nvarchar(200) collate database_default not null,
	strLastName							nvarchar(200) collate database_default not null,
	strAccountName						varchar(500) collate database_default not null,
	strPassword							varchar(500) collate database_default not null default (N'EIDSS'),
	strSiteAbbreviation					nvarchar(500) collate database_default not null,
	idfOrganization						bigint null,
	idfPerson							bigint null,
	idfUserID							bigint null,
	idfsSite							bigint null,
	primary key	(
		strAccountName asc,
		strSiteAbbreviation asc
				)
)

-- Fill user table
/*declare	@idfsSite	bigint
set	@idfsSite = NULL


select		@idfsSite = s.idfsSite
from		tstGlobalSiteOptions gso
inner join	tstSite s
on			cast(s.idfCustomizationPackage as nvarchar(200)) = gso.strValue collate Cyrillic_General_CI_AS
			and s.idfsSite <> 1
			and s.idfsParentSite is null	-- CDR
			and s.intRowStatus = 0
where		gso.strName = N'CustomizationPackage' collate Cyrillic_General_CI_AS

if	@idfsSite is null
begin
	select		@idfsSite = s.idfsSite
	from		tstGlobalSiteOptions gso
	inner join	tstCustomizationPackage cp
	on			cast(cp.idfCustomizationPackage as nvarchar(200)) = gso.strValue collate Cyrillic_General_CI_AS
				and cp.strCustomizationPackageName = N'DTRA' collate Cyrillic_General_CI_AS
	inner join	tstSite s
	on			s.idfsSite <> 1
				and s.idfsParentSite is null	-- CDR
				and s.intRowStatus = 0
	where		gso.strName = N'CustomizationPackage'
END*/



insert into	@UserTable (strEmployeeOrganizationAbbreviation, strLastName, strFirstName, strAccountName, strSiteAbbreviation)
select		@OrganizationAbbreviation, e.EmployeeLastName, e.EmployeeFirstName, e.EmployeeAccountName, @OrganizationAbbreviation
from		@Employee e
WHERE e.EmployeeAccountName <> 'SentByEmployee'

insert into	@UserTable (strEmployeeOrganizationAbbreviation, strLastName, strFirstName, strAccountName, strSiteAbbreviation)
select distinct
			@OrganizationAbbreviation, e.EmployeeLastName, e.EmployeeFirstName, e.EmployeeAccountName, i_web.[name]
from		tstSite s
inner join	tstSite s_web
on			s_web.idfCustomizationPackage = s.idfCustomizationPackage
			and s_web.blnIsWEB = 1
			and s_web.intRowStatus = 0
inner join	fnInstitution('en') i_web
on			i_web.idfOffice = s_web.idfOffice
CROSS JOIN @Employee e
left join	@UserTable ut_ex
on			ut_ex.strEmployeeOrganizationAbbreviation = @OrganizationAbbreviation collate Cyrillic_General_CI_AS
			and ut_ex.strAccountName = e.EmployeeAccountName collate Cyrillic_General_CI_AS
			and	ut_ex.strSiteAbbreviation = i_web.[name] collate Cyrillic_General_CI_AS
where		s.idfsSite = @CurrentSite
			and ut_ex.idfID is NULL
			AND e.EmployeeAccountName <> 'SentByEmployee'
			
			
insert into	@UserTable (strEmployeeOrganizationAbbreviation, strLastName, strFirstName, strAccountName, strSiteAbbreviation)
select		@SentByOrganizationAbbreviation, e.EmployeeLastName, e.EmployeeFirstName, e.EmployeeAccountName, @SentByOrganizationAbbreviation
from		@Employee e
WHERE e.EmployeeAccountName = 'SentByEmployee'

insert into	@UserTable (strEmployeeOrganizationAbbreviation, strLastName, strFirstName, strAccountName, strSiteAbbreviation)
select distinct
			@SentByOrganizationAbbreviation, e.EmployeeLastName, e.EmployeeFirstName, e.EmployeeAccountName, i_web.[name]
from		tstSite s
inner join	tstSite s_web
on			s_web.idfCustomizationPackage = s.idfCustomizationPackage
			and s_web.blnIsWEB = 1
			and s_web.intRowStatus = 0
inner join	fnInstitution('en') i_web
on			i_web.idfOffice = s_web.idfOffice
CROSS JOIN @Employee e
left join	@UserTable ut_ex
on			ut_ex.strEmployeeOrganizationAbbreviation = @SentByOrganizationAbbreviation collate Cyrillic_General_CI_AS
			and ut_ex.strAccountName = e.EmployeeAccountName collate Cyrillic_General_CI_AS
			and	ut_ex.strSiteAbbreviation = i_web.[name] collate Cyrillic_General_CI_AS
where		s.idfsSite = @CurrentSite
			and ut_ex.idfID is NULL
			AND e.EmployeeAccountName = 'SentByEmployee'


-- Implementation
declare	@N int

-- Select distinct employees
declare	@PersonTable	table
(	idfID								bigint not null,
	strEmployeeOrganizationAbbreviation	nvarchar(500) collate database_default not null,
	strFirstName						nvarchar(200) collate database_default not null,
	strLastName							nvarchar(200) collate database_default not null,
	strAccountName						varchar(500) collate database_default not null,
	idfOrganization						bigint null,
	idfPerson							bigint null,
	primary key	(
		strEmployeeOrganizationAbbreviation asc,
		strAccountName asc
				)
)

insert into	@PersonTable (idfID, strEmployeeOrganizationAbbreviation, strLastName, strFirstName, strAccountName, idfOrganization, idfPerson)
select		ut_format.idfID,
			ut_format.strEmployeeOrganizationAbbreviation,
			ut_format.strLastName,
			ut_format.strFirstName,
			ut_format.strAccountName,
			ut_format.idfOrganization,
			ut_format.idfPerson
from		@UserTable ut_format
where		not exists	(
					select	*
					from	@UserTable ut_format_min
					where	ut_format_min.strEmployeeOrganizationAbbreviation = ut_format.strEmployeeOrganizationAbbreviation
							and ut_format_min.strAccountName = ut_format.strAccountName
							and ut_format_min.idfID < ut_format.idfID
						)


-- Update existing IDs for Employees
update		pt_format
set			pt_format.idfOrganization = i.idfOffice,
			pt_format.idfPerson =
				case
					when	p.idfPerson is not null and p_id.idfEmployee is null
						then	p.idfPerson
					when	p.idfPerson is null and p_id.idfEmployee is null
						then	pt_format.idfPerson
					else	null
				end
from		@PersonTable pt_format
inner join	fnInstitution('en') i
on			i.[name] = pt_format.strEmployeeOrganizationAbbreviation collate Cyrillic_General_CI_AS
inner join	tstSite s
on			s.idfOffice = i.idfOffice
			and s.intRowStatus = 0
left join	tlbPerson p
on			p.strFamilyName = pt_format.strLastName collate Cyrillic_General_CI_AS
			and p.strFirstName = pt_format.strFirstName collate Cyrillic_General_CI_AS
			and p.idfInstitution = i.idfOffice
			and p.intRowStatus = 0
left join	tlbEmployee p_id
on			p_id.idfEmployee = IsNull(pt_format.idfPerson, -1000)
			and p_id.idfEmployee <> IsNull(p.idfPerson, -1000)

-- Generate new IDs for Employees
delete from	tstNewID where idfTable = 75520000000	-- tlbEmployee

insert into	tstNewID
(	idfTable,
	idfKey1,
	idfKey2
)
select		75520000000,	-- tlbEmployee
			pt_format.idfID,
			null
from		@PersonTable pt_format
where		pt_format.idfPerson is null

update		pt_format
set			pt_format.idfPerson = nId.[NewID]
from		@PersonTable pt_format
inner join	tstNewID nId
on			nId.idfTable = 75520000000	-- tlbEmployee
			and nId.idfKey1 = pt_format.idfID
where		pt_format.idfPerson is null

delete from	tstNewID where idfTable = 75520000000	-- tlbEmployee

-- Print number of records for Employees
select	@N = count(*)
from	@PersonTable pt_format
print	N'Number of employees to create/update: ' + cast(@N as nvarchar(20))

select		@N = count(*)
from		@PersonTable pt_format
inner join	tlbPerson p
on			p.idfPerson = pt_format.idfPerson
			and p.idfInstitution = pt_format.idfOrganization
			and p.intRowStatus = 0
print	N'Number of existing employees: ' + cast(@N as nvarchar(20))
print	N''

-- Insert records in the database for Employees
insert into	tlbEmployee
(	idfEmployee,
	idfsEmployeeType,
	idfsSite,
	intRowStatus
)
select		pt_format.idfPerson,
			10023002,	-- Person
			s.idfsSite,
			0
from		@PersonTable pt_format
inner join	fnInstitution('en') i
on			i.idfOffice = pt_format.idfOrganization
inner join	tstSite s
on			s.idfOffice = pt_format.idfOrganization
			and s.intRowStatus = 0
left join	tlbEmployee e
on			e.idfEmployee = pt_format.idfPerson
where		pt_format.idfPerson is not null
			and e.idfEmployee is null
set	@N = @@rowcount
print		N'Inserted employees (tlbEmployee): ' + cast(@N as nvarchar(20))

insert into	tlbPerson
(	idfPerson,
	idfInstitution,
	strFamilyName,
	strFirstName,
	intRowStatus
)
select		e.idfEmployee,
			i.idfOffice,
			pt_format.strLastName,
			pt_format.strFirstName,
			0
from		@PersonTable pt_format
inner join	fnInstitution('en') i
on			i.idfOffice = pt_format.idfOrganization
inner join	tstSite s
on			s.idfOffice = pt_format.idfOrganization
			and s.intRowStatus = 0
inner join	tlbEmployee e
on			e.idfEmployee = pt_format.idfPerson
left join	tlbPerson p
on			p.idfPerson = pt_format.idfPerson
where		pt_format.idfPerson is not null
			and p.idfPerson is null
set	@N = @@rowcount
print		N'Inserted employees (tlbPerson): ' + cast(@N as nvarchar(20))
print		N''

-- Update employees' IDs in User Table
update		ut_format
set			ut_format.idfPerson = p.idfPerson,
			ut_format.idfOrganization = i.idfOffice
from		@UserTable ut_format
inner join	@PersonTable pt_format
	inner join	fnInstitution('en') i
	on			i.idfOffice = pt_format.idfOrganization
	inner join	tstSite s
	on			s.idfOffice = pt_format.idfOrganization
				and s.intRowStatus = 0
	inner join	tlbEmployee e
	on			e.idfEmployee = pt_format.idfPerson
	inner join	tlbPerson p
	on			p.idfPerson = pt_format.idfPerson
on			pt_format.strEmployeeOrganizationAbbreviation = i.[name] collate Cyrillic_General_CI_AS
			and pt_format.strAccountName = ut_format.strAccountName collate Cyrillic_General_CI_AS

-- Update existing IDs for Logins on sites
update		ut_format
set			ut_format.idfsSite = s_abbr.idfsSite,
			ut_format.idfUserID =
				case
					when	ut.idfUserID is not null and ut_id.idfUserID is null
						then	ut.idfUserID
					when	ut.idfUserID is null and ut_id.idfUserID is null
						then	ut_format.idfUserID
					else	null
				end
from		@UserTable ut_format
inner join	fnInstitution('en') i
on			i.idfOffice = ut_format.idfOrganization
inner join	tstSite s_i
on			s_i.idfOffice = i.idfOffice
			and s_i.intRowStatus = 0
inner join	tlbPerson p
on			p.idfPerson = ut_format.idfPerson
inner join	tstSite s
	inner join	fnInstitution('en') s_abbr
	on			s_abbr.idfOffice = s.idfOffice
on			s_abbr.[name] = ut_format.strSiteAbbreviation collate Cyrillic_General_CI_AS
			and s_abbr.intRowStatus = 0
left join	tstUserTable ut
on			ut.strAccountName = ut_format.strAccountName collate Cyrillic_General_CI_AS
			and ut.idfPerson = p.idfPerson
			and ut.idfsSite = s.idfsSite
			and ut.intRowStatus = 0
left join	tstUserTable ut_id
on			ut_id.idfUserID = IsNull(ut_format.idfUserID, -1)
			and ut_id.idfUserID <> IsNull(ut.idfUserID, -1)


-- Generate new IDs for Logins on sites
delete from	tstNewID where idfTable = 76190000000	-- tstUserTable

insert into	tstNewID
(	idfTable,
	idfKey1,
	idfKey2
)
select		76190000000,	-- tstUserTable
			ut_format.idfID + 1,
			null
from		@UserTable ut_format
where		ut_format.idfUserID is null

update		ut_format
set			ut_format.idfUserID = nId.[NewID]
from		@UserTable ut_format
inner join	tstNewID nId
on			nId.idfTable = 76190000000	-- tstUserTable
			and nId.idfKey1 = ut_format.idfID + 1
where		ut_format.idfUserID is null

delete from	tstNewID where idfTable = 76190000000	-- tstUserTable

-- Print number of records for Logins on Sites
select	@N = count(*)
from	@PersonTable pt_format
print	N'Number of logins on sites to create/update: ' + cast(@N as nvarchar(20))

select		@N = count(*)
from		@UserTable ut_format
inner join	tlbPerson p
on			p.idfPerson = ut_format.idfPerson
			and p.idfInstitution = ut_format.idfOrganization
			and p.intRowStatus = 0
inner join	tstUserTable ut
on			ut.idfUserID = ut_format.idfUserID
			and ut.idfPerson = p.idfPerson
			and ut.idfsSite = ut_format.idfsSite
print	N'Number of existing logins on sites: ' + cast(@N as nvarchar(20))
print	N''


-- Insert records to the database for Logins on sites
update		ut
set			ut.binPassword = hashbytes('SHA1', cast(ut_format.strPassword as nvarchar(500))),
			ut.datPasswordSet = getutcdate(),
			ut.datTryDate = null,
			ut.intTry = null
from		@UserTable ut_format
inner join	tlbPerson p
on			p.idfPerson = ut_format.idfPerson
			and p.idfInstitution = ut_format.idfOrganization
			and p.intRowStatus = 0
inner join	tstUserTable ut
on			ut.idfUserID = ut_format.idfUserID
			and ut.idfPerson = p.idfPerson
			and ut.idfsSite = ut_format.idfsSite
inner join	tstUserTableLocal ut_loc
on			ut_loc.idfUserID = ut.idfUserID
--TODO: add where with comparison of existing values
set	@N = @@rowcount
print		N'Updated passwords and date password set (tstUserTable): ' + cast(@N as nvarchar(20))

insert into	tstUserTable
(	idfUserID,
	idfPerson,
	idfsSite,
	strAccountName,
	binPassword,
	datPasswordSet,
	datTryDate,
	intTry,
	intRowStatus
)
select		ut_format.idfUserID,
			p.idfPerson,
			s.idfsSite,
			ut_format.strAccountName,
			hashbytes('SHA1', cast(ut_format.strPassword as nvarchar(500))),
			getutcdate(),
			null,
			null,
			0
from		@UserTable ut_format
inner join	tlbPerson p
on			p.idfPerson = ut_format.idfPerson
			and p.idfInstitution = ut_format.idfOrganization
			and p.intRowStatus = 0
inner join	tstSite s
on			s.idfsSite = ut_format.idfsSite
			and s.intRowStatus = 0
left join	tstUserTable ut
on			ut.idfUserID = ut_format.idfUserID
where		ut_format.idfUserID is not null
			and ut.idfUserID is null
set	@N = @@rowcount
print		N'Inserted logins on sites (tstUserTable): ' + cast(@N as nvarchar(20))


delete		ut_loc
from		@UserTable ut_format
inner join	tlbPerson p
on			p.idfPerson = ut_format.idfPerson
			and p.idfInstitution = ut_format.idfOrganization
			and p.intRowStatus = 0
inner join	tstUserTable ut
on			ut.idfUserID = ut_format.idfUserID
			and ut.idfPerson = p.idfPerson
			and ut.idfsSite = ut_format.idfsSite
inner join	tstUserTableLocal ut_loc
on			ut_loc.idfUserID = ut.idfUserID
set	@N = @@rowcount
print		N'Deleted login attempts for correct users (tstUserTableLocal): ' + cast(@N as nvarchar(20))


-- Permissions
declare	@ObjectAccess table
(	idfID				bigint not null identity (1, 1),
	idfObjectAccess		bigint null,
	idfPerson			bigint not null,
	idfsSite			bigint not null,
	idfsSystemFunction	bigint not null,
	idfsObjectOperation	bigint not null,
	idfsObjectType		bigint not null,
	intPermission		int not null default (2),
	primary key	(
		idfPerson asc,
		idfsSite asc,
		idfsSystemFunction asc,
		idfsObjectOperation asc
				)
)

insert into	@ObjectAccess
(	idfObjectAccess,
	idfPerson,
	idfsSite,
	idfsSystemFunction,
	idfsObjectOperation,
	idfsObjectType
)
select		oa.idfObjectAccess,
			p.idfPerson,
			ut.idfsSite,
			sf.idfsSystemFunction,
			br_oo.idfsBaseReference,
			sf.idfsObjectType
from		trtSystemFunction sf
inner join	trtBaseReference br_sf
on			br_sf.idfsBaseReference = sf.idfsSystemFunction
			and br_sf.intRowStatus = 0
inner join	trtObjectTypeToObjectOperation oo_to_oo
on			oo_to_oo.idfsObjectType = sf.idfsObjectType
inner join	trtBaseReference br_oo
on			br_oo.idfsBaseReference = oo_to_oo.idfsObjectOperation
			and br_oo.intRowStatus = 0
inner join	@UserTable ut_format
on			ut_format.idfID is not null
inner join	tlbPerson p
on			p.idfPerson = ut_format.idfPerson
			and p.idfInstitution = ut_format.idfOrganization
			and p.intRowStatus = 0
inner join	tstUserTable ut
on			ut.idfUserID = ut_format.idfUserID
			and ut.idfPerson = p.idfPerson
			and ut.idfsSite = ut_format.idfsSite
left join	tstObjectAccess oa
on			oa.idfActor = p.idfPerson
			and oa.idfsOnSite = ut.idfsSite
			and oa.idfsObjectID = sf.idfsSystemFunction
			and oa.idfsObjectOperation = br_oo.idfsBaseReference
			and oa.intRowStatus = 0
where		sf.intRowStatus = 0
			and sf.idfsSystemFunction <> 10094058	-- Use Simplified Human Case Report Form
set	@N = @@rowcount
print		N'Permissions to sys. functions on sites to create/update: ' + cast(@N as nvarchar(20))


-- Generate IDs for permissions
delete from	tstNewID where idfTable = 76160000000	-- tstObjectAccess

insert into	tstNewID
(	idfTable,
	idfKey1,
	idfKey2
)
select		76160000000,	-- tstObjectAccess
			oa_format.idfID,
			null
from		@ObjectAccess oa_format
where		oa_format.idfObjectAccess is null

update		oa_format
set			oa_format.idfObjectAccess = nId.[NewID]
from		@ObjectAccess oa_format
inner join	tstNewID nId
on			nId.idfTable = 76160000000	-- tstObjectAccess
			and nId.idfKey1 = oa_format.idfID
where		oa_format.idfObjectAccess is null

delete from	tstNewID where idfTable = 776160000000	-- tstObjectAccess

-- Insert/update/delete permissions
delete		oa
from		tstObjectAccess oa
inner join	@UserTable ut_format
	inner join	tlbPerson p
	on			p.idfPerson = ut_format.idfPerson
				and p.idfInstitution = ut_format.idfOrganization
				and p.intRowStatus = 0
	inner join	tstUserTable ut
	on			ut.idfUserID = ut_format.idfUserID
				and ut.idfPerson = p.idfPerson
				and ut.idfsSite = ut_format.idfsSite
on			p.idfPerson = oa.idfActor
			and ut.idfsSite = oa.idfsOnSite
left join	@ObjectAccess oa_format
on			oa_format.idfObjectAccess = oa.idfObjectAccess
where		oa_format.idfID is null
set	@N = @@rowcount
print		N'Delete permissions to sys. functions of correct users on specified sites (tstObjectAccess): ' + cast(@N as nvarchar(20))

update		oa
set			oa.intPermission = oa_format.intPermission,
			oa.intRowStatus = 0
from		tstObjectAccess	oa
inner join	@UserTable ut_format
	inner join	tlbPerson p
	on			p.idfPerson = ut_format.idfPerson
				and p.idfInstitution = ut_format.idfOrganization
				and p.intRowStatus = 0
	inner join	tstUserTable ut
	on			ut.idfUserID = ut_format.idfUserID
				and ut.idfPerson = p.idfPerson
				and ut.idfsSite = ut_format.idfsSite
on			p.idfPerson = oa.idfActor
			and ut.idfsSite = oa.idfsOnSite
inner join	@ObjectAccess oa_format
on			oa_format.idfObjectAccess = oa.idfObjectAccess
where		(	IsNull(oa.intPermission, -1) <> oa_format.intPermission
				or	oa.intRowStatus <> 0
			)
set	@N = @@rowcount
print		N'Updated permissions to sys. functions of correct users on specified sites (tstObjectAccess): ' + cast(@N as nvarchar(20))

insert into	tstObjectAccess
(	idfObjectAccess,
	idfActor,
	idfsObjectID,
	idfsObjectOperation,
	idfsObjectType,
	idfsOnSite,
	intPermission,
	intRowStatus
)
select		oa_format.idfObjectAccess,
			oa_format.idfPerson,
			oa_format.idfsSystemFunction,
			oa_format.idfsObjectOperation,
			oa_format.idfsObjectType,
			oa_format.idfsSite,
			oa_format.intPermission,
			0
from		@ObjectAccess oa_format
left join	tstObjectAccess oa
on			oa.idfObjectAccess = oa_format.idfObjectAccess
where		oa_format.idfObjectAccess is not null
			and oa.idfObjectAccess is null
set	@N = @@rowcount
print		N'Inserted permissions to sys. functions of correct users on specified sites (tstObjectAccess): ' + cast(@N as nvarchar(20))

---- Script for filling User Table with identifiers
--select		N'insert into @UserTable (idfOrganization, idfPerson, idfUserID, idfsSite, strEmployeeOrganizationAbbreviation, strAccountName, strPassword, strSiteAbbreviation) values (' +
--cast(i.idfOffice as nvarchar(20)) + N', ' +
--cast(p.idfPerson as nvarchar(20)) + N', ' +
--cast(ut.idfUserID as nvarchar(20)) + N', ' +
--cast(s.idfsSite as nvarchar(20)) + N', ' +
--N'N''' + replace(i.[name], N'''', N'''''') + N''', ' +
--N'''' + replace(ut.strAccountName, N'''', N'''''') + N''', ' +
--N'''' + replace(ut_format.strPassword, N'''', N'''''') + N''', ' +
--N'N''' + replace(i_s.[name], N'''', N'''''') + N''')'
--from		@UserTable ut_format
--inner join	tstUserTable ut
--on			ut.idfUserID = ut_format.idfUserID
--			and ut.idfsSite = ut_format.idfsSite
--			and ut.intRowStatus = 0
--inner join	fnInstitution('en') i
--on			i.idfOffice = ut_format.idfOrganization
--inner join	tlbPerson p
--on			p.idfPerson = ut_format.idfPerson
--			and p.idfInstitution = i.idfOffice
--			and p.intRowStatus = 0
--inner join	tstSite s
--on			s.idfsSite = ut.idfsSite
--			and s.intRowStatus = 0
--inner join	fnInstitution('en') i_s
--on			i_s.idfOffice = s.idfOffice


print	''
print	'----------------------------------------------------------'
print	'Update enable status and password set date of all accounts'
print	''

declare	@datPasswordSet datetime
set	@datPasswordSet = getdate()

update	tstUserTable
set		datPasswordSet = @datPasswordSet,
		blnDisabled = 0
where	intRowStatus = 0
		and (	datPasswordSet <> @datPasswordSet
				or blnDisabled <> 0
			)
set	@N = @@rowcount
print	'Updated accounts (tstUserTable): ' + cast(@N as nvarchar(20))

delete from	tstUserTableLocal
set	@N = @@rowcount
print	'Deleted information about login attemps for accounts (tstUserTableLocal): ' + cast(@N as nvarchar(20))


IF @@ERROR <> 0
	ROLLBACK TRAN
ELSE
	COMMIT TRAN	


set XACT_ABORT off
set nocount off

--SET ANSI_NULLS on
--SET QUOTED_IDENTIFIER on
--GO

--ALTER	function [dbo].[fnTriggersWork] ()
--returns bit
--as
--begin
--return 1 --0
--end
--GO


/*----------------------CREATE EMPLOYESS END----------------------------------------------------*/



/*----------------------CREATE Organization BEGIN-----------------------------------------------*/
DECLARE @OrganizationId BIGINT = 0

SELECT	TOP 1
	@OrganizationId = to1.idfOffice
FROM tlbOffice to1
JOIN trtBaseReference tbr ON
	tbr.idfsBaseReference = to1.idfsOfficeName
	AND tbr.strDefault = 'Research Center #3'
	AND tbr.intRowStatus = 0
WHERE to1.intRowStatus = 0

IF @OrganizationId = 0
BEGIN
	EXEC spsysGetNewID @ID=@OrganizationId OUTPUT

	DECLARE @DataAuditEvent BIGINT
	EXEC dbo.spAudit_CreateNewEvent 
		@idfsDataAuditEventType=10016003 /*Edit*/
		,@idfsDataAuditObjectType=10017034 /*Organization*/
		,@strMainObjectTable=75650000000 /*tlbOffice*/
		,@idfsMainObject=@OrganizationId
		,@strReason=NULL
		,@idfDataAuditEvent=@DataAuditEvent OUTPUT

	DECLARE @GeoLocationId BIGINT
	EXEC spsysGetNewID @ID=@GeoLocationId OUTPUT

	DECLARE @idfsRegion BIGINT
	DECLARE @idfsRayon BIGINT
	DECLARE @idfsSettlement BIGINT
	SELECT TOP 1 
		@idfsRegion = gr.idfsRegion
	FROM gisRegion gr
	JOIN gisBaseReference gbr ON 
		gbr.idfsGISBaseReference = gr.idfsRegion
	WHERE gr.idfsCountry = @CurrentCountry
	ORDER BY NEWID()

	SELECT TOP 1 
		@idfsRayon = gr.idfsRayon
	FROM gisRayon gr 
	JOIN gisBaseReference gbr ON 
		gbr.idfsGISBaseReference = gr.idfsRayon
	WHERE gr.idfsCountry = @CurrentCountry 
		AND gr.idfsRegion = @idfsRegion 
	ORDER BY NEWID()

	SELECT TOP 1 
		@idfsSettlement = gr.idfsSettlement 
	FROM gisSettlement gr 
	JOIN gisBaseReference gbr ON 
		gbr.idfsGISBaseReference = gr.idfsSettlement
	WHERE gr.idfsCountry = @CurrentCountry 
		AND gr.idfsRegion = @idfsRegion 
		AND gr.idfsRayon = @idfsRayon
	ORDER BY NEWID()

	EXEC spAddress_Post 
		@idfGeoLocation=@GeoLocationId
		,@idfsCountry= @CurrentCountry
		,@idfsRegion=@idfsRegion
		,@idfsRayon=@idfsRayon
		,@idfsSettlement=@idfsSettlement
		,@strApartment=N'3'
		,@strBuilding=N'1'
		,@strStreetName=NULL
		,@strHouse=N'2'
		,@strPostCode=NULL
		,@blnForeignAddress=0
		,@strForeignAddress=NULL
		,@dblLatitude=NULL
		,@dblLongitude=NULL
		,@blnGeoLocationShared=1

	EXEC spOrganization_Post 
		@idfOffice=@OrganizationId
		,@EnglishName=NULL
		,@name=N'RC3'
		,@EnglishFullName=NULL
		,@FullName=N'Research Center #3'
		,@idfLocation=@GeoLocationId
		,@strContactPhone=NULL
		,@idfsCurrentCustomization= @CurrentCustomization
		,@intHACode=482
		,@strOrganizationID=NULL
		,@LangID=N'en'
		,@intOrder=0
		
	DECLARE @DepartmentId BIGINT
	EXEC spsysGetNewID @ID=@DepartmentId OUTPUT

	EXEC spDepartment_Post 
		@Action=4
		,@idfDepartment=@DepartmentId
		,@idfOrganization=@OrganizationId
		,@DefaultName=NULL
		,@name=N'Laboratory 1'
		,@idfsCountry=NULL
		,@LangID=N'en'

	EXEC spsysGetNewID @ID=@DepartmentId OUTPUT

	EXEC spDepartment_Post 
		@Action=4
		,@idfDepartment=@DepartmentId
		,@idfOrganization=@OrganizationId
		,@DefaultName=NULL
		,@name=N'Laboratory 2'
		,@idfsCountry=NULL
		,@LangID=N'en'
END
/*----------------------CREATE Organization END  -----------------------------------------------*/



/*----------------------CREATE Human Case Begin----------------------------------------------------*/
DECLARE @hc INT = 0
DECLARE @hc_dead_cnt_total INT = CAST(CAST(@TotalHumanCase AS DECIMAL) / 100 * 2 AS INT)
DECLARE @hc_dead_cnt INT = 0
DECLARE @hc_confirmed INT = 0
DECLARE @hc_outcome_unknown_cnt_total INT = CAST(CAST(@TotalHumanCase AS DECIMAL) / 100 * 30 AS INT)
DECLARE @hc_outcome_unknown_cnt INT = 0
DECLARE @hc_transferout_cnt INT = 0
DECLARE @hc_transferout_cnt_total INT = 3
DECLARE @hc_AmendedTestStatus BIT = 1

WHILE @hc < @TotalHumanCase and @CustomizationPackage <> 51577390000000/*Kazakhstan (MoA)*/
BEGIN	
	SET @hc = @hc + 1
	
	DECLARE @UserAccountName NVARCHAR(200)
		, @PatientGender NVARCHAR(200)
		, @PatientGenderId BIGINT
		, @PatientFirstName NVARCHAR(200)
		, @PatientLastName NVARCHAR(200)
		, @EmployerName NVARCHAR(200)
		, @FirstContactName NVARCHAR(200)
		, @SecondContactName NVARCHAR(200)
		, @PatientFinalState BIGINT
		, @FinalCaseStatus BIGINT
		, @Outcome BIGINT
		
	SELECT TOP 1
		@PatientGender = tbr.strDefault
		, @PatientGenderId = tbr.idfsBaseReference
	FROM trtBaseReference tbr
	WHERE tbr.idfsReferenceType = 19000043 /*Human Gender*/
		AND tbr.intRowStatus = 0
	ORDER BY NEWID()
	
	SELECT TOP 1
		@UserAccountName = tst.strAccountName 
	FROM tstUserTable tst
	JOIN @PersonTable e ON
		e.idfPerson = tst.idfPerson
		AND e.strAccountName <> 'SentByEmployee'
	ORDER BY NEWID()

	
	SELECT TOP 1
		@PatientFirstName = FirstName 
	FROM @FirstName 
	WHERE HumanGender = @PatientGender
	ORDER BY NEWID()
	
	SELECT TOP 1
		@PatientLastName = LastName 
	FROM @LastName
	WHERE HumanGender = @PatientGender
	ORDER BY NEWID()

	
	
	SELECT TOP 1
		@EmployerName = FirstName + ' ' + (SELECT TOP 1 ln.LastName FROM @LastName ln WHERE ln.HumanGender = fn.HumanGender ORDER BY NEWID())
	FROM @FirstName fn
	ORDER BY NEWID()
	
	SELECT TOP 1
		@FirstContactName = FirstName + ' ' + (SELECT TOP 1 ln.LastName FROM @LastName ln WHERE ln.HumanGender = fn.HumanGender ORDER BY NEWID())
	FROM @FirstName fn
	ORDER BY NEWID()
	
	SELECT TOP 1
		@SecondContactName = FirstName + ' ' + (SELECT TOP 1 ln.LastName FROM @LastName ln WHERE ln.HumanGender = fn.HumanGender ORDER BY NEWID())
	FROM @FirstName fn
	ORDER BY NEWID()
	
	IF @hc_dead_cnt_total > 0 AND @hc_dead_cnt <= @hc_dead_cnt_total
	BEGIN
		 SET @hc_dead_cnt = @hc_dead_cnt + 1
		 SET @PatientFinalState = 10035001 /*Dead*/
	END
	ELSE
		SET @PatientFinalState = 10035002 /*Live*/
	
	IF @hc_confirmed = 0
	BEGIN
		SET @hc_confirmed = 1
		SET @FinalCaseStatus = 350000000 /*Confirmed Case*/
	END
		SELECT TOP 1 
			@FinalCaseStatus = tbr.idfsBaseReference 
		FROM trtBaseReference tbr 
		WHERE tbr.idfsReferenceType = 19000011 
			AND tbr.intRowStatus = 0 
		ORDER BY NEWID()
	
	IF @hc_outcome_unknown_cnt_total > 0 AND @hc_outcome_unknown_cnt <= @hc_outcome_unknown_cnt_total
	BEGIN
		 SET @hc_outcome_unknown_cnt = @hc_outcome_unknown_cnt + 1
		 SET @Outcome = 10780000000 /*Unknown*/
	END
	ELSE
		SET @Outcome = 10760000000 /*Recovered*/
		
	DECLARE @SentByPerson BIGINT = (
									SELECT TOP 1
										tst.idfPerson
									FROM tstUserTable tst
									JOIN @PersonTable e ON
										e.idfPerson = tst.idfPerson
										AND e.strAccountName = 'SentByEmployee'
									ORDER BY NEWID()
									)											

	DECLARE @CreateTransferOutMaterial BIT
	IF @hc_transferout_cnt_total > 0 AND @hc_transferout_cnt <= @hc_transferout_cnt_total
	BEGIN
		 SET @hc_transferout_cnt = @hc_transferout_cnt + 1
		 SET @CreateTransferOutMaterial = 1
	END
	ELSE
		SET @CreateTransferOutMaterial = 0
	
	DECLARE @TransferSendToOffice BIGINT
	IF @hc_transferout_cnt = 3
		SET @TransferSendToOffice = @OrganizationId
	ELSE
		SET @TransferSendToOffice = NULL
		
	DECLARE @AmendedTestStatus BIGINT
	SET @AmendedTestStatus = 0
	IF @FinalCaseStatus <> 380000000 /*Suspect*/ AND @hc_AmendedTestStatus = 1
	BEGIN 
		SET @AmendedTestStatus = 1
		SET @hc_AmendedTestStatus = 0
	END
	

	EXEC sptemp_CreateHumanCase 
		@CaseCnt = 1
		, @SampleCnt = 3
		, @TestCnt = 2
		, @ParamCnt = 4
		, @my_SiteID = @CurrentSite
		, @Diagnosis = NULL
		, @LastName = @PatientLastName
		, @FirstName = @PatientFirstName
		, @Age = NULL
		, @Region = NULL
		, @Rayon = NULL
		, @StreetName = @StreetName
		, @StartDate = @StartDate
		, @DateRange = @DateRangeInDays
		, @HumanGender = @PatientGenderId
		, @LocalUserName = @UserAccountName
		, @EmployerName = @EmployerName
		, @FirstContactName = @FirstContactName
		, @SecondContactName = @SecondContactName
		, @PatientFinalState = @PatientFinalState
		, @FinalCaseStatus = @FinalCaseStatus
		, @Outcome = @Outcome
		, @SentByPerson = @SentByPerson
		, @CreateTransferOutMaterial = @CreateTransferOutMaterial
		, @TransferSendToOffice = @TransferSendToOffice
		, @AmendedTestStatus = @AmendedTestStatus	
		
	PRINT 'HumanCase №' + CAST(@hc AS NVARCHAR(10))	
END
/*----------------------CREATE Human Case END----------------------------------------------------*/



/*----------------------CREATE Human Case AVR END----------------------------------------------------*/
DECLARE @hc_avr INT = 0
DECLARE @hc_dead_cnt_total_avr INT = CAST(CAST(@TotalHumanCaseAVR AS DECIMAL) / 100 * 2 AS INT)
DECLARE @hc_dead_cnt_avr INT = 0
DECLARE @hc_confirmed_avr INT = 0
DECLARE @hc_outcome_unknown_cnt_total_avr INT = CAST(CAST(@TotalHumanCaseAVR AS DECIMAL) / 100 * 30 AS INT)
DECLARE @hc_outcome_unknown_cnt_avr INT = 0

WHILE @hc_avr < @TotalHumanCaseAVR and @CustomizationPackage <> 51577390000000/*Kazakhstan (MoA)*/
BEGIN	
	SET @hc_avr = @hc_avr + 1
	
	DECLARE @UserAccountName_avr NVARCHAR(200)
		, @PatientGender_avr NVARCHAR(200)
		, @PatientGenderId_avr BIGINT
		, @PatientFirstName_avr NVARCHAR(200)
		, @PatientLastName_avr NVARCHAR(200)
		, @EmployerName_avr NVARCHAR(200)
		, @FirstContactName_avr NVARCHAR(200)
		, @SecondContactName_avr NVARCHAR(200)
		, @PatientFinalState_avr BIGINT
		, @FinalCaseStatus_avr BIGINT
		, @Outcome_avr BIGINT
		
	SELECT TOP 1
		@PatientGender_avr = tbr.strDefault
		, @PatientGenderId_avr = tbr.idfsBaseReference
	FROM trtBaseReference tbr
	WHERE tbr.idfsReferenceType = 19000043 /*Human Gender*/
		AND tbr.intRowStatus = 0
	ORDER BY NEWID()
	
	SELECT TOP 1
		@UserAccountName_avr = tst.strAccountName 
	FROM tstUserTable tst
	JOIN @PersonTable e ON
		e.idfPerson = tst.idfPerson
		AND e.strAccountName <> 'SentByEmployee'
	ORDER BY NEWID()

	
	SELECT TOP 1
		@PatientFirstName_avr = FirstName 
	FROM @FirstName 
	WHERE HumanGender = @PatientGender_avr
	ORDER BY NEWID()
	
	SELECT TOP 1
		@PatientLastName_avr = LastName 
	FROM @LastName
	WHERE HumanGender = @PatientGender_avr
	ORDER BY NEWID()

	
	
	SELECT TOP 1
		@EmployerName_avr = FirstName + ' ' + (SELECT TOP 1 ln.LastName FROM @LastName ln WHERE ln.HumanGender = fn.HumanGender ORDER BY NEWID())
	FROM @FirstName fn
	ORDER BY NEWID()
	
	SELECT TOP 1
		@FirstContactName_avr = FirstName + ' ' + (SELECT TOP 1 ln.LastName FROM @LastName ln WHERE ln.HumanGender = fn.HumanGender ORDER BY NEWID())
	FROM @FirstName fn
	ORDER BY NEWID()
	
	SELECT TOP 1
		@SecondContactName_avr = FirstName + ' ' + (SELECT TOP 1 ln.LastName FROM @LastName ln WHERE ln.HumanGender = fn.HumanGender ORDER BY NEWID())
	FROM @FirstName fn
	ORDER BY NEWID()
	
	IF @hc_dead_cnt_total_avr > 0 AND @hc_dead_cnt_avr <= @hc_dead_cnt_total_avr
	BEGIN
		 SET @hc_dead_cnt_avr = @hc_dead_cnt_avr + 1
		 SET @PatientFinalState_avr = 10035001 /*Dead*/
	END
	ELSE
		SET @PatientFinalState_avr = 10035002 /*Live*/
	
	IF @hc_confirmed_avr = 0
	BEGIN
		SET @hc_confirmed_avr = 1
		SET @FinalCaseStatus_avr = 350000000 /*Confirmed Case*/
	END
		SELECT TOP 1 
			@FinalCaseStatus_avr = tbr.idfsBaseReference 
		FROM trtBaseReference tbr 
		WHERE tbr.idfsReferenceType = 19000011 
			AND tbr.intRowStatus = 0 
		ORDER BY NEWID()
	
	IF @hc_outcome_unknown_cnt_total_avr > 0 AND @hc_outcome_unknown_cnt_avr <= @hc_outcome_unknown_cnt_total_avr
	BEGIN
		 SET @hc_outcome_unknown_cnt_avr = @hc_outcome_unknown_cnt_avr + 1
		 SET @Outcome_avr = 10780000000 /*Unknown*/
	END
	ELSE
		SET @Outcome_avr = 10760000000 /*Recovered*/
		
	DECLARE @SentByPerson_avr BIGINT = (
									SELECT TOP 1
										tst.idfPerson
									FROM tstUserTable tst
									JOIN @PersonTable e ON
										e.idfPerson = tst.idfPerson
										AND e.strAccountName = 'SentByEmployee'
									ORDER BY NEWID()
									)						
	
	DECLARE @RegionId BIGINT = (SELECT TOP 1 RegionId FROM @Region ORDER BY NEWID())
									
	EXEC sptemp_CreateHumanCase 
		@CaseCnt = 1
		, @SampleCnt = 2
		, @TestCnt = 2
		, @ParamCnt = 4
		, @my_SiteID = @CurrentSite
		, @Diagnosis = NULL
		, @LastName = @PatientLastName_avr
		, @FirstName = @PatientFirstName_avr
		, @Age = NULL
		, @Region = @RegionId
		, @Rayon = NULL
		, @StreetName = @StreetName
		, @StartDate = @StartDate
		, @DateRange = @DateRangeInDays
		, @HumanGender = @PatientGenderId_avr
		, @LocalUserName = @UserAccountName_avr
		, @EmployerName = @EmployerName_avr
		, @FirstContactName = @FirstContactName_avr
		, @SecondContactName = @SecondContactName_avr
		, @PatientFinalState = @PatientFinalState_avr
		, @FinalCaseStatus = @FinalCaseStatus_avr
		, @Outcome = @Outcome_avr
		, @SentByPerson = @SentByPerson_avr
		
	PRINT 'HumanCaseAVR №' + CAST(@hc_avr AS NVARCHAR(10))
END
/*----------------------CREATE Human Case AVR END----------------------------------------------------*/




/*----------------------CREATE Aggr Human Case BEGIN----------------------------------------------------*/
DECLARE @StatisticAreaType BIGINT = NULL
	, @StatisticPeriodType BIGINT = NULL
	, @PeriodStartDate DATETIME = NULL
	, @PeriodFinishDate DATETIME = NULL
	
SELECT 
	@StatisticAreaType = idfsStatisticAreaType
	, @StatisticPeriodType = idfsStatisticPeriodType
FROM tstAggrSetting 
WHERE idfsAggrCaseType = 10102001/*Human Aggregate Case*/ 
	AND intRowStatus = 0
		
DECLARE @hc_aggr INT = 0

WHILE @hc_aggr < @TotalHumanAggrCase and @CustomizationPackage not in (51577390000000/*Kazakhstan (MoA)*/, 51577420000000/*Iraq*/, 51577490000000/*Thailand*/)
BEGIN	
	SET @hc_aggr = @hc_aggr + 1
	
	DECLARE @UserAccountName_aggr NVARCHAR(200)
	
	SELECT TOP 1
		@UserAccountName_aggr = tst.strAccountName 
	FROM tstUserTable tst
	JOIN @PersonTable e ON
		e.idfPerson = tst.idfPerson
		AND e.strAccountName <> 'SentByEmployee'
	ORDER BY NEWID()

	IF @StatisticAreaType IS NULL OR @StatisticPeriodType IS NULL 
	BEGIN
		IF @hc_aggr	<= CAST(CAST(@TotalHumanAggrCase AS DECIMAL) / 100 * 25 AS INT)
		BEGIN 
			SET @StatisticAreaType = ISNULL(@StatisticAreaType, 10089004 /*Settlement*/)
			SET @StatisticPeriodType = ISNULL(@StatisticPeriodType, 10091004 /*Week*/)
		END
		ELSE 
			IF @hc_aggr	<= CAST(CAST(@TotalHumanAggrCase AS DECIMAL) / 100 * 50 AS INT)
			BEGIN 
				SET @StatisticAreaType = ISNULL(@StatisticAreaType, 10089002 /*Rayon*/)
				SET @StatisticPeriodType = ISNULL(@StatisticPeriodType, 10091001 /*Month*/)
			END
			ELSE 
				IF @hc_aggr	<= CAST(CAST(@TotalHumanAggrCase AS DECIMAL) / 100 * 75 AS INT)
				BEGIN 
					SET @StatisticAreaType = ISNULL(@StatisticAreaType, 10089002 /*Rayon*/)
					SET @StatisticPeriodType = ISNULL(@StatisticPeriodType, 10091003 /*Quarter*/)
				END
				ELSE
					BEGIN 
						SET @StatisticAreaType = ISNULL(@StatisticAreaType, 10089004 /*Settlement*/)
						SET @StatisticPeriodType = ISNULL(@StatisticPeriodType, 10091001 /*Month*/)
					END
	END
	
	
	DECLARE @AdministrativeUnit BIGINT		
	SELECT TOP 1
		@AdministrativeUnit = AdmUnit
	FROM (
		SELECT
			gr.idfsRegion AS AdmUnit
		FROM gisRegion gr
		WHERE gr.idfsCountry = @CurrentCountry
			AND ISNULL(@StatisticAreaType, 10089003) = 10089003/*Region*/
		UNION ALL
		SELECT
			gr.idfsRayon
		FROM gisRayon gr
		WHERE gr.idfsCountry = @CurrentCountry
			AND ISNULL(@StatisticAreaType, 10089002) = 10089002/*Rayon*/
		UNION ALL
		SELECT
			gr.idfsSettlement
		FROM gisSettlement gr
		WHERE gr.idfsCountry = @CurrentCountry
			AND ISNULL(@StatisticAreaType, 10089004) = 10089004/*Settlement*/
	) x
	ORDER BY NEWID()
	
	DECLARE @Date DATETIME 
	DECLARE @MonthNumber INT
	IF @StatisticPeriodType = 10091005 /*Year*/
	BEGIN 
		SET @PeriodStartDate = CONVERT(DATETIME,'01.01.' + CAST(YEAR(@StartDate) AS NVARCHAR(4)),101)
		SET @PeriodFinishDate = CONVERT(DATETIME,'31.12.' + CAST(YEAR(@StartDate) AS NVARCHAR(4)),101)
	END
	ELSE IF @StatisticPeriodType = 10091003 /*Quarter*/
	BEGIN 
		SELECT TOP 1
			@MonthNumber = rn
		FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY idfsBaseReference) rn FROM trtBaseReference
		) x
		WHERE rn < 13
		ORDER BY NEWID()
		
		SET @Date = '01.' + CASE WHEN LEN(@MonthNumber) = 1 THEN '0' ELSE '' END + CAST(@MonthNumber AS NVARCHAR(2)) + '.' + CAST(YEAR(@StartDate) AS NVARCHAR(4))

		SET @PeriodStartDate = CONVERT(DATETIME,CONVERT(VARCHAR(2),(MONTH(@Date)-1)/3*3+1)+'/1/'+CONVERT(CHAR(4),YEAR(@Date)),101)
		SET @PeriodFinishDate = DATEADD(MONTH,3,CONVERT(DATETIME,CONVERT(VARCHAR(2),(MONTH(@Date)-1)/3*3+1)+'/1/'+CONVERT(CHAR(4),YEAR(@Date)),101))-1
	END
	ELSE IF @StatisticPeriodType = 10091001 /*Month*/
	BEGIN
		SELECT TOP 1
			@MonthNumber = rn
		FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY idfsBaseReference) rn FROM trtBaseReference
		) x
		WHERE rn < 13
		ORDER BY NEWID()
		
		SET @Date = '01.' + CASE WHEN LEN(@MonthNumber) = 1 THEN '0' ELSE '' END + CAST(@MonthNumber AS NVARCHAR(2)) + '.' + CAST(YEAR(@StartDate) AS NVARCHAR(4))

		SET @PeriodStartDate = @Date
		SET @PeriodFinishDate = DATEADD(MONTH, 1, DATEADD(DAY, 1 - DAY(@Date), @Date)) - 1
	END
	ELSE IF @StatisticPeriodType = 10091004 /*Week*/
	BEGIN
		DECLARE @FirstDayOfWeek INT
		SELECT @FirstDayOfWeek = ISNULL(tgso.strValue, 1) FROM tstGlobalSiteOptions tgso WHERE tgso.strName = 'FirstDayOfWeek'

		DECLARE @FromDate DATETIME = '01.01.' + CAST(YEAR(DATEADD(YEAR, -1, @StartDate)) AS NVARCHAR(4))
		DECLARE @ToDate DATETIME = '31.12.' + CAST(YEAR(DATEADD(YEAR, -1, @StartDate)) AS NVARCHAR(4))
		DECLARE @RandomDate DATETIME = DATEADD(DAY, RAND(CHECKSUM(NEWID())) * (1 + DATEDIFF(DAY, @FromDate, @ToDate)), @FromDate)
		DECLARE @WeekDay INT = DATEPART(weekday, @RandomDate) - 1
		SET @PeriodStartDate = DATEADD(DAY, -1 * @WeekDay, @RandomDate) - CASE WHEN @FirstDayOfWeek = 0 THEN 1 ELSE 0 END
		SET @PeriodFinishDate = DATEADD(DAY, 6, DATEADD(DAY, -1 * @WeekDay, @RandomDate)) - CASE WHEN @FirstDayOfWeek = 0 THEN 1 ELSE 0 END	
	END
	

	DECLARE @SentByPerson_hum_aggr BIGINT = (
												SELECT TOP 1
													tst.idfPerson
												FROM tstUserTable tst
												JOIN @PersonTable e ON
													e.idfPerson = tst.idfPerson
													AND e.strAccountName = 'SentByEmployee'
												ORDER BY NEWID()
											)						
	
	EXEC sptemp_CreateHumanAggrCase 
		@CaseCnt = 1
		, @my_SiteID = @CurrentSite
		, @LocalUserName = @UserAccountName_aggr
		, @AdministrativeUnit = @AdministrativeUnit
		, @SentByPerson = @SentByPerson_hum_aggr
		, @StartDate = @StartDate
		, @DateRange = @DateRangeInDays
		, @PeriodStartDate = @PeriodStartDate
		, @PeriodFinishDate = @PeriodFinishDate
		
	PRINT 'HumanAggrCase №' + CAST(@hc_aggr AS NVARCHAR(10))
END




/*----------------------CREATE Aggr Human Case END----------------------------------------------------*/



/*----------------------CREATE Aggr Vet Case BEGIN----------------------------------------------------*/
DECLARE @StatisticAreaType_vet BIGINT = NULL
	, @StatisticPeriodType_vet BIGINT = NULL
	, @PeriodStartDate_vet DATETIME = NULL
	, @PeriodFinishDate_vet DATETIME = NULL
	
SELECT 
	@StatisticAreaType_vet = idfsStatisticAreaType
	, @StatisticPeriodType_vet = idfsStatisticPeriodType
FROM tstAggrSetting 
WHERE idfsAggrCaseType = 10102002/*Vet Aggregate Case*/ 
	AND intRowStatus = 0
	
DECLARE @vc_aggr INT = 0

WHILE @vc_aggr < @TotalVetAggrCase and @CustomizationPackage not in (
	51577380000000/*Kazakhstan (MoH)*/
	, 51577420000000/*Iraq*/
	, 51577430000000/*Georgia*/
	, 51577490000000/*Thailand*/
	)
BEGIN	
	SET @vc_aggr = @vc_aggr + 1
	
	DECLARE @UserAccountName_aggr_vet NVARCHAR(200)
	
	SELECT TOP 1
		@UserAccountName_aggr_vet = tst.strAccountName 
	FROM tstUserTable tst
	JOIN @PersonTable e ON
		e.idfPerson = tst.idfPerson
		AND e.strAccountName <> 'SentByEmployee'
	ORDER BY NEWID()
	
	IF @StatisticAreaType_vet IS NULL OR @StatisticPeriodType_vet IS NULL 
	BEGIN
		IF @vc_aggr	<= CAST(CAST(@TotalVetAggrCase AS DECIMAL) / 100 * 25 AS INT)
		BEGIN 
			SET @StatisticAreaType_vet = 10089004 /*Settlement*/
			SET @StatisticPeriodType_vet = 10091004 /*Week*/
		END
		ELSE 
			IF @vc_aggr	<= CAST(CAST(@TotalVetAggrCase AS DECIMAL) / 100 * 50 AS INT)
			BEGIN 
				SET @StatisticAreaType_vet = 10089002 /*Rayon*/
				SET @StatisticPeriodType_vet = 10091001 /*Month*/
			END
			ELSE 
				IF @vc_aggr	<= CAST(CAST(@TotalVetAggrCase AS DECIMAL) / 100 * 75 AS INT)
				BEGIN 
					SET @StatisticAreaType_vet = 10089002 /*Rayon*/
					SET @StatisticPeriodType_vet = 10091003 /*Quarter*/
				END
				ELSE
					BEGIN 
						SET @StatisticAreaType_vet = 10089004 /*Settlement*/
						SET @StatisticPeriodType_vet = 10091001 /*Month*/
					END
	END
		
	DECLARE @AdministrativeUnit_vet BIGINT		
	SELECT TOP 1
		@AdministrativeUnit_vet = AdmUnit
	FROM (
		SELECT
			gr.idfsRegion AS AdmUnit
		FROM gisRegion gr
		WHERE gr.idfsCountry = @CurrentCountry
			AND ISNULL(@StatisticAreaType_vet, 10089003) = 10089003/*Region*/
		UNION ALL
		SELECT
			gr.idfsRayon
		FROM gisRayon gr
		WHERE gr.idfsCountry = @CurrentCountry
			AND ISNULL(@StatisticAreaType_vet, 10089002) = 10089002/*Rayon*/
		UNION ALL
		SELECT
			gr.idfsSettlement
		FROM gisSettlement gr
		WHERE gr.idfsCountry = @CurrentCountry
			AND ISNULL(@StatisticAreaType_vet, 10089004) = 10089004/*Settlement*/
	) x
	ORDER BY NEWID()
	
	
	DECLARE @Date_vet DATETIME 
	DECLARE @MonthNumber_vet INT
	IF @StatisticPeriodType_vet = 10091005 /*Year*/
	BEGIN 
		SET @PeriodStartDate_vet = CONVERT(DATETIME,'01.01.' + CAST(YEAR(@StartDate) AS NVARCHAR(4)),101)
		SET @PeriodFinishDate_vet = CONVERT(DATETIME,'31.12.' + CAST(YEAR(@StartDate) AS NVARCHAR(4)),101)
	END
	ELSE IF @StatisticPeriodType_vet = 10091003 /*Quarter*/
	BEGIN 
		SELECT TOP 1
			@MonthNumber_vet = rn
		FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY idfsBaseReference) rn FROM trtBaseReference
		) x
		WHERE rn < 13
		ORDER BY NEWID()
		
		SET @Date_vet = '01.' + CASE WHEN LEN(@MonthNumber_vet) = 1 THEN '0' ELSE '' END + CAST(@MonthNumber_vet AS NVARCHAR(2)) + '.' + CAST(YEAR(@StartDate) AS NVARCHAR(4))

		SET @PeriodStartDate_vet = CONVERT(DATETIME,CONVERT(VARCHAR(2),(MONTH(@Date_vet)-1)/3*3+1)+'/1/'+CONVERT(CHAR(4),YEAR(@Date_vet)),101)
		SET @PeriodFinishDate_vet = DATEADD(MONTH,3,CONVERT(DATETIME,CONVERT(VARCHAR(2),(MONTH(@Date_vet)-1)/3*3+1)+'/1/'+CONVERT(CHAR(4),YEAR(@Date_vet)),101))-1
	END
	ELSE IF @StatisticPeriodType_vet = 10091001 /*Month*/
	BEGIN
		SELECT TOP 1
			@MonthNumber_vet = rn
		FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY idfsBaseReference) rn FROM trtBaseReference
		) x
		WHERE rn < 13
		ORDER BY NEWID()
		
		SET @Date_vet = '01.' + CASE WHEN LEN(@MonthNumber_vet) = 1 THEN '0' ELSE '' END + CAST(@MonthNumber_vet AS NVARCHAR(2)) + '.' + CAST(YEAR(@StartDate) AS NVARCHAR(4))

		SET @PeriodStartDate_vet = @Date_vet
		SET @PeriodFinishDate_vet = DATEADD(MONTH, 1, DATEADD(DAY, 1 - DAY(@Date_vet), @Date_vet)) - 1
	END
	ELSE IF @StatisticPeriodType_vet = 10091004 /*Week*/
	BEGIN
		DECLARE @FirstDayOfWeek_vet INT
		SELECT @FirstDayOfWeek_vet = ISNULL(tgso.strValue, 1) FROM tstGlobalSiteOptions tgso WHERE tgso.strName = 'FirstDayOfWeek'

		DECLARE @FromDate_vet DATETIME = '01.01.' + CAST(YEAR(DATEADD(YEAR, -1, @StartDate)) AS NVARCHAR(4))
		DECLARE @ToDate_vet DATETIME = '31.12.' + CAST(YEAR(DATEADD(YEAR, -1, @StartDate)) AS NVARCHAR(4))
		DECLARE @RandomDate_vet DATETIME = DATEADD(DAY, RAND(CHECKSUM(NEWID())) * (1 + DATEDIFF(DAY, @FromDate_vet, @ToDate_vet)), @FromDate_vet)
		DECLARE @WeekDay_vet INT = DATEPART(weekday, @RandomDate_vet) - 1
		SET @PeriodStartDate_vet = DATEADD(DAY, -1 * @WeekDay_vet, @RandomDate_vet) - CASE WHEN @FirstDayOfWeek_vet = 0 THEN 1 ELSE 0 END
		SET @PeriodFinishDate_vet = DATEADD(DAY, 6, DATEADD(DAY, -1 * @WeekDay_vet, @RandomDate_vet)) - CASE WHEN @FirstDayOfWeek_vet = 0 THEN 1 ELSE 0 END	
	END
	

	DECLARE @SentByPerson_vet_aggr BIGINT = (
												SELECT TOP 1
													tst.idfPerson
												FROM tstUserTable tst
												JOIN @PersonTable e ON
													e.idfPerson = tst.idfPerson
													AND e.strAccountName = 'SentByEmployee'
												ORDER BY NEWID()
											)						
	
	EXEC sptemp_CreateVetAggrCase 
		@CaseCnt = 1
		, @my_SiteID = @CurrentSite
		, @LocalUserName = @UserAccountName_aggr_vet
		, @AdministrativeUnit = @AdministrativeUnit_vet
		, @SentByPerson = @SentByPerson_vet_aggr
		, @StartDate = @StartDate
		, @DateRange = @DateRangeInDays
		, @PeriodStartDate = @PeriodStartDate_vet
		, @PeriodFinishDate = @PeriodFinishDate_vet
		
	PRINT 'VetAggrCase №' + CAST(@vc_aggr AS NVARCHAR(10))
END
/*----------------------CREATE Aggr Vet Case END----------------------------------------------------*/



/*----------------------CREATE Aggr Vet Action BEGIN----------------------------------------------------*/

DECLARE @StatisticAreaType_vet_action BIGINT = NULL
	, @StatisticPeriodType_vet_action BIGINT = NULL
	, @PeriodStartDate_vet_action DATETIME = NULL
	, @PeriodFinishDate_vet_action DATETIME = NULL
	
SELECT 
	@StatisticAreaType_vet_action = idfsStatisticAreaType
	, @StatisticPeriodType_vet_action = idfsStatisticPeriodType
FROM tstAggrSetting 
WHERE idfsAggrCaseType = 10102003/*Vet Aggregate Action*/ 
	AND intRowStatus = 0
	
DECLARE @vc_aggr_action INT = 0

WHILE @vc_aggr_action < @TotalVetAggrAction and @CustomizationPackage not in (
	51577380000000/*Kazakhstan (MoH)*/
	, 51577420000000/*Iraq*/
	, 51577490000000/*Thailand*/
	)
BEGIN	
	SET @vc_aggr_action = @vc_aggr_action + 1
	
	DECLARE @UserAccountName_aggr_vet_action NVARCHAR(200)
	
	SELECT TOP 1
		@UserAccountName_aggr_vet_action = tst.strAccountName 
	FROM tstUserTable tst
	JOIN @PersonTable e ON
		e.idfPerson = tst.idfPerson
		AND e.strAccountName <> 'SentByEmployee'
	ORDER BY NEWID()
	
	IF @StatisticAreaType_vet_action IS NULL OR @StatisticPeriodType_vet_action IS NULL 
	BEGIN
		IF @vc_aggr_action	<= CAST(CAST(@TotalVetAggrAction AS DECIMAL) / 100 * 25 AS INT)
		BEGIN 
			SET @StatisticAreaType_vet_action = 10089004 /*Settlement*/
			SET @StatisticPeriodType_vet_action = 10091004 /*Week*/
		END
		ELSE 
			IF @vc_aggr_action	<= CAST(CAST(@TotalVetAggrAction AS DECIMAL) / 100 * 50 AS INT)
			BEGIN 
				SET @StatisticAreaType_vet_action = 10089002 /*Rayon*/
				SET @StatisticPeriodType_vet_action = 10091001 /*Month*/
			END
			ELSE 
				IF @vc_aggr_action	<= CAST(CAST(@TotalVetAggrAction AS DECIMAL) / 100 * 75 AS INT)
				BEGIN 
					SET @StatisticAreaType_vet_action = 10089002 /*Rayon*/
					SET @StatisticPeriodType_vet_action = 10091003 /*Quarter*/
				END
				ELSE
					BEGIN 
						SET @StatisticAreaType_vet_action = 10089004 /*Settlement*/
						SET @StatisticPeriodType_vet_action = 10091001 /*Month*/
					END
	END 
	
	DECLARE @AdministrativeUnit_vet_action BIGINT		
	SELECT TOP 1
		@AdministrativeUnit_vet_action = AdmUnit
	FROM (
		SELECT
			gr.idfsRegion AS AdmUnit
		FROM gisRegion gr
		WHERE gr.idfsCountry = @CurrentCountry
			AND ISNULL(@StatisticAreaType_vet_action, 10089003) = 10089003/*Region*/
		UNION ALL
		SELECT
			gr.idfsRayon
		FROM gisRayon gr
		WHERE gr.idfsCountry = @CurrentCountry
			AND ISNULL(@StatisticAreaType_vet_action, 10089002) = 10089002/*Rayon*/
		UNION ALL
		SELECT
			gr.idfsSettlement
		FROM gisSettlement gr
		WHERE gr.idfsCountry = @CurrentCountry
			AND ISNULL(@StatisticAreaType_vet_action, 10089004) = 10089004/*Settlement*/
	) x
	ORDER BY NEWID()
	
	DECLARE @Date_vet_action DATETIME 
	DECLARE @MonthNumber_vet_action INT
	IF @MonthNumber_vet_action = 10091005 /*Year*/
	BEGIN 
		SET @PeriodStartDate_vet_action = CONVERT(DATETIME,'01.01.' + CAST(YEAR(@StartDate) AS NVARCHAR(4)),101)
		SET @PeriodFinishDate_vet_action = CONVERT(DATETIME,'31.12.' + CAST(YEAR(@StartDate) AS NVARCHAR(4)),101)
	END
	ELSE IF @StatisticPeriodType_vet_action = 10091003 /*Quarter*/
	BEGIN 
		SELECT TOP 1
			@MonthNumber_vet_action = rn
		FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY idfsBaseReference) rn FROM trtBaseReference
		) x
		WHERE rn < 5
		ORDER BY NEWID()
		
		SET @Date_vet_action = '01.' + CASE WHEN LEN(@MonthNumber_vet_action) = 1 THEN '0' ELSE '' END + CAST(@MonthNumber_vet_action AS NVARCHAR(2)) + '.' + CAST(YEAR(@StartDate) AS NVARCHAR(4))

		SET @PeriodStartDate_vet_action = CONVERT(DATETIME,CONVERT(VARCHAR(2),(MONTH(@Date_vet_action)-1)/3*3+1)+'/1/'+CONVERT(CHAR(4),YEAR(@Date_vet_action)),101)
		SET @PeriodFinishDate_vet_action = DATEADD(MONTH,3,CONVERT(DATETIME,CONVERT(VARCHAR(2),(MONTH(@Date_vet_action)-1)/3*3+1)+'/1/'+CONVERT(CHAR(4),YEAR(@Date_vet_action)),101))-1
	END
	ELSE IF @StatisticPeriodType_vet_action = 10091001 /*Month*/
	BEGIN
		SELECT TOP 1
			@MonthNumber_vet_action = rn
		FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY idfsBaseReference) rn FROM trtBaseReference
		) x
		WHERE rn < 13
		ORDER BY NEWID()
		
		SET @Date_vet_action = '01.' + CASE WHEN LEN(@MonthNumber_vet_action) = 1 THEN '0' ELSE '' END + CAST(@MonthNumber_vet_action AS NVARCHAR(2)) + '.' + CAST(YEAR(@StartDate) AS NVARCHAR(4))

		SET @PeriodStartDate_vet_action = @Date_vet_action
		SET @PeriodFinishDate_vet_action = DATEADD(MONTH, 1, DATEADD(DAY, 1 - DAY(@Date_vet_action), @Date_vet_action)) - 1
	END
	ELSE IF @StatisticPeriodType_vet_action = 10091004 /*Week*/
	BEGIN
		DECLARE @FirstDayOfWeek_vet_action INT
		SELECT @FirstDayOfWeek_vet_action = ISNULL(tgso.strValue, 1) FROM tstGlobalSiteOptions tgso WHERE tgso.strName = 'FirstDayOfWeek'

		DECLARE @FromDate_vet_action DATETIME = '01.01.' + CAST(YEAR(DATEADD(YEAR, -1, @StartDate)) AS NVARCHAR(4))
		DECLARE @ToDate_vet_action DATETIME = '31.12.' + CAST(YEAR(DATEADD(YEAR, -1, @StartDate)) AS NVARCHAR(4))
		DECLARE @RandomDate_vet_action DATETIME = DATEADD(DAY, RAND(CHECKSUM(NEWID())) * (1 + DATEDIFF(DAY, @FromDate_vet_action, @ToDate_vet_action)), @FromDate_vet_action)
		DECLARE @WeekDay_vet_action INT = DATEPART(weekday, @RandomDate_vet_action) - 1
		SET @PeriodStartDate_vet_action = DATEADD(DAY, -1 * @WeekDay_vet_action, @RandomDate_vet_action) - CASE WHEN @FirstDayOfWeek_vet_action = 0 THEN 1 ELSE 0 END
		SET @PeriodFinishDate_vet_action = DATEADD(DAY, 6, DATEADD(DAY, -1 * @WeekDay_vet_action, @RandomDate_vet_action)) - CASE WHEN @FirstDayOfWeek_vet_action = 0 THEN 1 ELSE 0 END	
	END
	

	DECLARE @SentByPerson_vet_aggr_action BIGINT = (
												SELECT TOP 1
													tst.idfPerson
												FROM tstUserTable tst
												JOIN @PersonTable e ON
													e.idfPerson = tst.idfPerson
													AND e.strAccountName = 'SentByEmployee'
												ORDER BY NEWID()
											)						
	
	EXEC sptemp_CreateVetAggrAction 
		@CaseCnt = 1
		, @my_SiteID = @CurrentSite
		, @LocalUserName = @UserAccountName_aggr_vet_action
		, @AdministrativeUnit = @AdministrativeUnit_vet_action
		, @SentByPerson = @SentByPerson_vet_aggr_action
		, @StartDate = @StartDate
		, @DateRange = @DateRangeInDays
		, @PeriodStartDate = @PeriodStartDate_vet_action
		, @PeriodFinishDate = @PeriodFinishDate_vet_action
		
	PRINT 'VetAggrAction №' + CAST(@vc_aggr_action AS NVARCHAR(10))
END
/*----------------------CREATE Aggr Vet Action END----------------------------------------------------*/


/*----------------------CREATE ILI Aggr BEGIN----------------------------------------------------*/
DECLARE @ili_aggr INT = 0

WHILE @ili_aggr < @TotalILIAggr
BEGIN	
	SET @ili_aggr = @ili_aggr + 1
	
	DECLARE @UserAccountName_ili_aggr NVARCHAR(200)
	
	SELECT TOP 1
		@UserAccountName_ili_aggr = tst.strAccountName 
	FROM tstUserTable tst
	JOIN @PersonTable e ON
		e.idfPerson = tst.idfPerson
		AND e.strAccountName <> 'SentByEmployee'
	ORDER BY NEWID()					
	
	EXEC sptemp_CreateILIAggr
		@ILICnt = 1
		, @my_SiteID = @CurrentSite
		, @LocalUserName = @UserAccountName_ili_aggr
		, @StartDate = @StartDate
		
	PRINT 'ILIAggr №' + CAST(@ili_aggr AS NVARCHAR(10))
END
/*----------------------CREATE ILI Aggr END----------------------------------------------------*/




/*----------------------CREATE Vet Case BEGIN----------------------------------------------------*/
DECLARE @vc INT = 0
DECLARE @vc_confirmed INT = 0

WHILE @vc < @TotalVetCase and @CustomizationPackage not in (
	51577380000000/*Kazakhstan (MoH)*/
	, 51577420000000/*Iraq*/
	, 51577490000000/*Thailand*/
	)
BEGIN	
	SET @vc = @vc + 1
	
	DECLARE @UserAccountName_vc NVARCHAR(200)
		, @FarmOwnerGender NVARCHAR(200)
		, @FarmOwnerGenderId BIGINT
		, @FarmOwnerFirstName NVARCHAR(200)
		, @FarmOwnerLastName NVARCHAR(200)
		, @FinalCaseStatus_vc BIGINT
		
	SELECT TOP 1
		@FarmOwnerGender = tbr.strDefault
		, @FarmOwnerGenderId = tbr.idfsBaseReference
	FROM trtBaseReference tbr
	WHERE tbr.idfsReferenceType = 19000043 /*Human Gender*/
		AND tbr.intRowStatus = 0
	ORDER BY NEWID()
	
	SELECT TOP 1
		@UserAccountName_vc = tst.strAccountName 
	FROM tstUserTable tst
	JOIN @PersonTable e ON
		e.idfPerson = tst.idfPerson
		AND e.strAccountName <> 'SentByEmployee'
	ORDER BY NEWID()

	
	SELECT TOP 1
		@FarmOwnerFirstName = FirstName 
	FROM @FirstName 
	WHERE HumanGender = @FarmOwnerGender
	ORDER BY NEWID()
	
	SELECT TOP 1
		@FarmOwnerLastName = LastName 
	FROM @LastName
	WHERE HumanGender = @FarmOwnerGender
	ORDER BY NEWID()
	
	IF @vc_confirmed = 0
	BEGIN
		SET @vc_confirmed = 1
		SET @FinalCaseStatus_vc = 350000000 /*Confirmed Case*/
	END
		SELECT TOP 1 
			@FinalCaseStatus_vc = tbr.idfsBaseReference 
		FROM trtBaseReference tbr 
		WHERE tbr.idfsReferenceType = 19000011 
			AND tbr.intRowStatus = 0 
		ORDER BY NEWID()
		
	DECLARE @PersonReportedBy BIGINT = (
										SELECT TOP 1
											tst.idfPerson
										FROM tstUserTable tst
										JOIN @PersonTable e ON
											e.idfPerson = tst.idfPerson
											AND e.strAccountName = 'SentByEmployee'
										ORDER BY NEWID()
										)						
	DECLARE @CaseType BIGINT = (
									SELECT TOP 1
										tbr.idfsBaseReference
									FROM trtBaseReference tbr
									WHERE tbr.idfsBaseReference IN (10012003, 10012004)
										AND tbr.intRowStatus = 0
									ORDER BY NEWID()
								)	
		
	EXEC sptemp_CreateVetCase
		@CaseCnt = 1
		, @SampleCnt = 2
		, @TestCnt = 2
		, @PensideTestCnt = 0
		, @ParamCnt = 4
		, @HerdCnt = 2
		, @AnimalCnt = 3
		, @my_SiteID = @CurrentSite
		, @Diagnosis = NULL
		, @LastName = @FarmOwnerLastName
		, @FirstName = @FarmOwnerFirstName
		, @Region = NULL
		, @Rayon = NULL
		, @StreetName = @StreetName
		, @StartDate = @StartDate
		, @DateRange = @DateRangeInDays
		, @CaseType = @CaseType
		, @LocalUserName = @UserAccountName_vc
		, @FinalCaseStatus = @FinalCaseStatus_vc
		, @PersonReportedBy = @PersonReportedBy

	PRINT 'VetCase №' + CAST(@vc AS NVARCHAR(10))
END
/*----------------------CREATE Vet Case END----------------------------------------------------*/



/*----------------------CREATE Vet Case AVR END----------------------------------------------------*/
DECLARE @vc_avr INT = 0
DECLARE @vc_confirmed_avr INT = 0

WHILE @vc_avr < @TotalVetCaseAVR and @CustomizationPackage not in (
	51577380000000/*Kazakhstan (MoH)*/
	, 51577420000000/*Iraq*/
	, 51577490000000/*Thailand*/
	)
BEGIN	
	SET @vc_avr = @vc_avr + 1
	
	DECLARE @UserAccountName_vc_avr NVARCHAR(200)
		, @FarmOwnerGender_avr NVARCHAR(200)
		, @FarmOwnerGenderId_avr BIGINT
		, @FarmOwnerFirstName_avr NVARCHAR(200)
		, @FarmOwnerLastName_avr NVARCHAR(200)
		, @FinalCaseStatus_vc_avr BIGINT
		
	SELECT TOP 1
		@FarmOwnerGender_avr = tbr.strDefault
		, @FarmOwnerGenderId_avr = tbr.idfsBaseReference
	FROM trtBaseReference tbr
	WHERE tbr.idfsReferenceType = 19000043 /*Human Gender*/
		AND tbr.intRowStatus = 0
	ORDER BY NEWID()
	
	SELECT TOP 1
		@UserAccountName_vc_avr = tst.strAccountName 
	FROM tstUserTable tst
	JOIN @PersonTable e ON
		e.idfPerson = tst.idfPerson
		AND e.strAccountName <> 'SentByEmployee'
	ORDER BY NEWID()

	
	SELECT TOP 1
		@FarmOwnerFirstName_avr = FirstName 
	FROM @FirstName 
	WHERE HumanGender = @FarmOwnerGender_avr
	ORDER BY NEWID()
	
	SELECT TOP 1
		@FarmOwnerLastName_avr = LastName 
	FROM @LastName
	WHERE HumanGender = @FarmOwnerGender_avr
	ORDER BY NEWID()
	
	IF @vc_confirmed_avr = 0
	BEGIN
		SET @vc_confirmed_avr = 1
		SET @FinalCaseStatus_vc_avr = 350000000 /*Confirmed Case*/
	END
		SELECT TOP 1 
			@FinalCaseStatus_vc_avr = tbr.idfsBaseReference 
		FROM trtBaseReference tbr 
		WHERE tbr.idfsReferenceType = 19000011 
			AND tbr.intRowStatus = 0 
		ORDER BY NEWID()
		
	DECLARE @PersonReportedBy_vc_avr BIGINT = (
										SELECT TOP 1
											tst.idfPerson
										FROM tstUserTable tst
										JOIN @PersonTable e ON
											e.idfPerson = tst.idfPerson
											AND e.strAccountName = 'SentByEmployee'
										ORDER BY NEWID()
										)						
	DECLARE @CaseType_vc_avr BIGINT = (
									SELECT TOP 1
										tbr.idfsBaseReference
									FROM trtBaseReference tbr
									WHERE tbr.idfsBaseReference IN (10012003, 10012004)
										AND tbr.intRowStatus = 0
									ORDER BY NEWID()
								)	
	
	DECLARE @RegionId_vc_avr BIGINT = (SELECT TOP 1 RegionId FROM @Region ORDER BY NEWID())
		
	EXEC sptemp_CreateVetCase
		@CaseCnt = 1
		, @SampleCnt = 2
		, @TestCnt = 2
		, @PensideTestCnt = 0
		, @ParamCnt = 4
		, @HerdCnt = 2
		, @AnimalCnt = 3
		, @my_SiteID = @CurrentSite
		, @Diagnosis = NULL
		, @LastName = @FarmOwnerLastName_avr
		, @FirstName = @FarmOwnerFirstName_avr
		, @Region = @RegionId_vc_avr
		, @Rayon = NULL
		, @StreetName = @StreetName
		, @StartDate = @StartDate
		, @DateRange = @DateRangeInDays
		, @CaseType = @CaseType_vc_avr
		, @LocalUserName = @UserAccountName_vc_avr
		, @FinalCaseStatus = @FinalCaseStatus_vc_avr
		, @PersonReportedBy = @PersonReportedBy_vc_avr

	PRINT 'VetCaseAVR №' + CAST(@vc_avr AS NVARCHAR(10))
END
/*----------------------CREATE Vet Case AVR END----------------------------------------------------*/



/*----------------------CREATE SyndromicSurveillance Begin----------------------------------------------------*/
DECLARE @ss INT = 0

WHILE @ss < @TotalSyndromicSurveillance
BEGIN	
	SET @ss = @ss + 1
	
	DECLARE @UserAccountName_ss NVARCHAR(200)
		, @PatientGender_ss NVARCHAR(200)
		, @PatientGenderId_ss BIGINT
		, @PatientFirstName_ss NVARCHAR(200)
		, @PatientLastName_ss NVARCHAR(200)
		, @EmployerName_ss NVARCHAR(200)
		
	SELECT TOP 1
		@PatientGender_ss = tbr.strDefault
		, @PatientGenderId_ss = tbr.idfsBaseReference
	FROM trtBaseReference tbr
	WHERE tbr.idfsReferenceType = 19000043 /*Human Gender*/
		AND tbr.intRowStatus = 0
	ORDER BY NEWID()
	
	SELECT TOP 1
		@UserAccountName_ss = tst.strAccountName 
	FROM tstUserTable tst
	JOIN @PersonTable e ON
		e.idfPerson = tst.idfPerson
		AND e.strAccountName <> 'SentByEmployee'
	ORDER BY NEWID()

	
	SELECT TOP 1
		@PatientFirstName_ss = FirstName 
	FROM @FirstName 
	WHERE HumanGender = @PatientGender_ss
	ORDER BY NEWID()
	
	SELECT TOP 1
		@PatientLastName_ss = LastName 
	FROM @LastName
	WHERE HumanGender = @PatientGender_ss
	ORDER BY NEWID()							
		
	EXEC sptemp_CreateSyndromicSurveillance 
		@SSCnt = 1
		, @my_SiteID = @CurrentSite
		, @LastName = @PatientLastName_ss
		, @FirstName = @PatientFirstName_ss
		, @Age = NULL
		, @Region = NULL
		, @Rayon = NULL
		, @StreetName = @StreetName
		, @StartDate = @StartDate
		, @DateRange = @DateRangeInDays
		, @LocalUserName = @UserAccountName_ss
		, @EmployerName = @EmployerName_ss
		, @HumanGender = @PatientGenderId_ss

	PRINT 'SyndromicSurveillance №' + CAST(@ss AS NVARCHAR(10))
END
/*----------------------CREATE SyndromicSurveillance END----------------------------------------------------*/



/*----------------------CREATE Batch Begin----------------------------------------------------*/
DECLARE @bt INT = 0

WHILE @bt < @TotalBatch
BEGIN	
	SET @bt = @bt + 1
	
	DECLARE @UserAccountName_bt NVARCHAR(200)
		
	
	SELECT TOP 1
		@UserAccountName_bt = tst.strAccountName 
	FROM tstUserTable tst
	JOIN @PersonTable e ON
		e.idfPerson = tst.idfPerson
		AND e.strAccountName <> 'SentByEmployee'
	ORDER BY NEWID()	
	
	DECLARE @SetTestResult BIT
		, @ResultEnteredByPerson BIGINT	
	SET @SetTestResult = NULL
	SET @ResultEnteredByPerson = NULL
	
	IF @bt <= @TotalBatch / 2		
	BEGIN 
		SET @SetTestResult = 1
		
		SELECT TOP 1
			@ResultEnteredByPerson = tst.idfPerson 
		FROM tstUserTable tst
		JOIN @PersonTable e ON
			e.idfPerson = tst.idfPerson
			AND e.strAccountName <> 'SentByEmployee'
			AND e.strAccountName <> @UserAccountName_bt
		ORDER BY NEWID()	
	END	
	
	EXEC sptemp_CreateBatch 
		@BatchCnt = 1
		, @TestCnt = 2
		, @my_SiteID = @CurrentSite
		, @LocalUserName = @UserAccountName_bt
		, @SetTestResult = @SetTestResult
		, @ResultEnteredByPerson = @ResultEnteredByPerson

END
/*----------------------CREATE Batch END----------------------------------------------------*/


/*----------------------CREATE FreezerTree Begin----------------------------------------------------*/
IF ISNULL(@FreezerGenerate, 0) <> 0
BEGIN
	DECLARE @FreezerId BIGINT
		, @ShelfId BIGINT
		, @BoxId BIGINT

	IF NOT EXISTS (SELECT * FROM tlbFreezer tf WHERE tf.strFreezerName = N'Atlant')
	BEGIN
		EXEC spsysGetNewID @ID=@FreezerId OUTPUT							
		INSERT INTO tlbFreezer (idfFreezer, idfsStorageType, idfsSite, strFreezerName, strBarcode) 
		VALUES (@FreezerId, 39870000000/*Freezer*/, @CurrentSite, N'Atlant', LEFT(REPLACE(NEWID(), '-', '') , 6))

			EXEC spsysGetNewID @ID=@ShelfId OUTPUT
			INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars)
			VALUES (@ShelfId, 39900000000/*Shelf*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 6), 'Shelf 1')

				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Blue Box', 81, @ShelfId)

				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Red Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'White Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Yellow Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Orange Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Green Box', 81, @ShelfId)

			EXEC spsysGetNewID @ID=@ShelfId OUTPUT
			INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars)
			VALUES (@ShelfId, 39900000000/*Shelf*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 6), 'Shelf 2')
			
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Blue Box', 81, @ShelfId)

				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Red Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'White Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Yellow Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Orange Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Green Box', 81, @ShelfId)

			EXEC spsysGetNewID @ID=@ShelfId OUTPUT
			INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars)
			VALUES (@ShelfId, 39900000000/*Shelf*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 6), 'Shelf 3')
			
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Blue Box', 81, @ShelfId)

				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Red Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'White Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Yellow Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Orange Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Green Box', 81, @ShelfId)
	END

	IF NOT EXISTS (SELECT * FROM tlbFreezer tf WHERE tf.strFreezerName = N'Liebherr')
	BEGIN
		EXEC spsysGetNewID @ID=@FreezerId OUTPUT							
		INSERT INTO tlbFreezer (idfFreezer, idfsStorageType, idfsSite, strFreezerName, strBarcode) 
		VALUES (@FreezerId, 39870000000/*Freezer*/, @CurrentSite, N'Lubherr', LEFT(REPLACE(NEWID(), '-', '') , 6))

			EXEC spsysGetNewID @ID=@ShelfId OUTPUT
			INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars)
			VALUES (@ShelfId, 39900000000/*Shelf*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 6), 'Shelf 1')
			
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Blue Box', 81, @ShelfId)

				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Red Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'White Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Yellow Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Orange Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Green Box', 81, @ShelfId)

			EXEC spsysGetNewID @ID=@ShelfId OUTPUT
			INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars)
			VALUES (@ShelfId, 39900000000/*Shelf*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 6), 'Shelf 2')
			
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Blue Box', 81, @ShelfId)

				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Red Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'White Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Yellow Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Orange Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Green Box', 81, @ShelfId)

			EXEC spsysGetNewID @ID=@ShelfId OUTPUT
			INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars)
			VALUES (@ShelfId, 39900000000/*Shelf*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 6), 'Shelf 3')
			
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Blue Box', 81, @ShelfId)

				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Red Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'White Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Yellow Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Orange Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Green Box', 81, @ShelfId)
	END

	IF NOT EXISTS (SELECT * FROM tlbFreezer tf WHERE tf.strFreezerName = N'Siemens')
	BEGIN
		EXEC spsysGetNewID @ID=@FreezerId OUTPUT							
		INSERT INTO tlbFreezer (idfFreezer, idfsStorageType, idfsSite, strFreezerName, strBarcode) 
		VALUES (@FreezerId, 39870000000/*Freezer*/, @CurrentSite, N'Siemens', LEFT(REPLACE(NEWID(), '-', '') , 6))

			EXEC spsysGetNewID @ID=@ShelfId OUTPUT
			INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars)
			VALUES (@ShelfId, 39900000000/*Shelf*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 6), 'Shelf 1')
			
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Blue Box', 81, @ShelfId)

				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Red Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'White Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Yellow Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Orange Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Green Box', 81, @ShelfId)

			EXEC spsysGetNewID @ID=@ShelfId OUTPUT
			INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars)
			VALUES (@ShelfId, 39900000000/*Shelf*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 6), 'Shelf 2')
			
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Blue Box', 81, @ShelfId)

				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Red Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'White Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Yellow Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Orange Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Green Box', 81, @ShelfId)

			EXEC spsysGetNewID @ID=@ShelfId OUTPUT
			INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars)
			VALUES (@ShelfId, 39900000000/*Shelf*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 6), 'Shelf 3')
			
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Blue Box', 81, @ShelfId)

				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Red Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'White Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Yellow Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Orange Box', 81, @ShelfId)
				
				EXEC spsysGetNewID @ID=@BoxId OUTPUT
				INSERT INTO tlbFreezerSubdivision (idfSubdivision, idfsSubdivisionType, idfFreezer, idfsSite, strBarcode, strNameChars, intCapacity, idfParentSubdivision)
				VALUES (@BoxId, 39890000000/*Box*/, @FreezerId, @CurrentSite, LEFT(REPLACE(NEWID(), '-', '') , 7), 'Green Box', 81, @ShelfId)
	END

END
/*----------------------CREATE FreezerTree END----------------------------------------------------*/



/*----------------------CREATE Outbreak Begin----------------------------------------------------*/
DECLARE @o INT = 0

WHILE @o < @TotalOutbreak
BEGIN	
	SET @o = @o + 1
	
	DECLARE @UserAccountName_out NVARCHAR(200)		
	
	SELECT TOP 1
		@UserAccountName_out = tst.strAccountName 
	FROM tstUserTable tst
	JOIN @PersonTable e ON
		e.idfPerson = tst.idfPerson
		AND e.strAccountName <> 'SentByEmployee'
	ORDER BY NEWID()	
	
	EXEC sptemp_CreateOutbreak 
		@OutbreakCnt = 1
		,@CaseCnt = 2
		, @my_SiteID = @CurrentSite
		, @Diagnosis = NULL
		, @Region = NULL
		, @Rayon = NULL
		, @Settlement = NULL
		, @LocalUserName = @UserAccountName_out
		, @OutbreakStatus = NULL
		
	PRINT 'Outbreak №' + CAST(@o AS NVARCHAR(10))
END
/*----------------------CREATE Outbreak END----------------------------------------------------*/



/*----------------------CREATE VSSession Begin----------------------------------------------------*/
DECLARE @vss INT = 0

WHILE @vss < @TotalVSSession and @CustomizationPackage not in (
	51577400000000/*Armenia*/
	, 51577410000000/*Azerbaijan*/
	, 51577420000000/*Iraq*/
	, 51577490000000/*Thailand*/
	)
BEGIN	
	SET @vss = @vss + 1
	
	DECLARE @UserAccountName_vss NVARCHAR(200)		
	
	SELECT TOP 1
		@UserAccountName_vss = tst.strAccountName 
	FROM tstUserTable tst
	JOIN @PersonTable e ON
		e.idfPerson = tst.idfPerson
		AND e.strAccountName <> 'SentByEmployee'
	ORDER BY NEWID()	
	
	EXEC sptemp_CreateVSSession 
		@VSSCnt = 1
		, @InfoCnt = 4
		, @SampleCnt = 2
		, @my_SiteID = @CurrentSite
		, @Region = NULL
		, @Rayon = NULL
		, @StartDate = @StartDate
		, @DateRange = @DateRangeInDays
		, @LocalUserName = @UserAccountName_vss

	PRINT 'VSSession №' + CAST(@vss AS NVARCHAR(10))
END
/*----------------------CREATE VSSession END----------------------------------------------------*/



/*----------------------CREATE Campaign Begin----------------------------------------------------*/
DECLARE @c INT = 0

WHILE @c < @TotalCampaign and @CustomizationPackage not in (
	51577390000000/*Kazakhstan (MoA)*/
	, 51577400000000/*Armenia*/
	, 51577420000000/*Iraq*/
	, 51577490000000/*Thailand*/
	)
BEGIN	
	SET @c = @c + 1
	
	DECLARE @UserAccountName_c NVARCHAR(200)
		, @AdministratorGender_c NVARCHAR(200)
		, @AdministratorFirstName_c NVARCHAR(200)
		, @AdministratorLastName_c NVARCHAR(200)	
		, @CampaignAdministrator NVARCHAR(200)
		, @FarmOwnerGender_c NVARCHAR(200)
		, @FarmOwnerFirstName_c NVARCHAR(200)
		, @FarmOwnerLastName_c NVARCHAR(200)
		
	
	SELECT TOP 1
		@UserAccountName_c = tst.strAccountName 
	FROM tstUserTable tst
	JOIN @PersonTable e ON
		e.idfPerson = tst.idfPerson
		AND e.strAccountName <> 'SentByEmployee'
	ORDER BY NEWID()
		
		
	SELECT TOP 1
		@AdministratorGender_c = tbr.strDefault
	FROM trtBaseReference tbr
	WHERE tbr.idfsReferenceType = 19000043 /*Human Gender*/
		AND tbr.intRowStatus = 0
	ORDER BY NEWID()
	
	SELECT TOP 1
		@AdministratorFirstName_c = FirstName 
	FROM @FirstName 
	WHERE HumanGender = @AdministratorGender_c
	ORDER BY NEWID()
	
	SELECT TOP 1
		@AdministratorLastName_c = LastName 
	FROM @LastName
	WHERE HumanGender = @AdministratorGender_c
	ORDER BY NEWID()	
	
	SET @CampaignAdministrator = @AdministratorLastName_c + ' ' + @AdministratorFirstName_c
	
	
	SELECT TOP 1
		@FarmOwnerGender_c = tbr.strDefault
	FROM trtBaseReference tbr
	WHERE tbr.idfsReferenceType = 19000043 /*Human Gender*/
		AND tbr.intRowStatus = 0
	ORDER BY NEWID()
	
	SELECT TOP 1
		@FarmOwnerFirstName_c = FirstName 
	FROM @FirstName 
	WHERE HumanGender = @FarmOwnerGender_c
	ORDER BY NEWID()
	
	SELECT TOP 1
		@FarmOwnerLastName_c = LastName 
	FROM @LastName
	WHERE HumanGender = @FarmOwnerGender_c
	ORDER BY NEWID()
		
	EXEC sptemp_Campaign 
		@CampaignCnt = 1
		, @my_SiteID = @CurrentSite
		, @StartDate = @StartDate
		, @DateRange = @DateRangeInDays
		, @DiseaseAndSpeciesCnt = 3
		, @ASSessionCnt = 3
		, @LocalUserName = @UserAccountName_c
		, @CampaignAdministrator = @CampaignAdministrator
		, @FarmOwnerLastName = @FarmOwnerLastName_c
		, @FarmOwnerFirstName = @FarmOwnerFirstName_c

	PRINT 'Campaign №' + CAST(@vss AS NVARCHAR(10))
END
/*----------------------CREATE Campaign END----------------------------------------------------*/
