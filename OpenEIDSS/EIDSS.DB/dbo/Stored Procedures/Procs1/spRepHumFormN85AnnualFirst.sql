


--##SUMMARY Select data for Armenian Form 85 custom reort

--##REMARKS Author: 
--##REMARKS Create date: 14.04.2012

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013
 
--##RETURNS Doesn't use

/*
--Example of a call of procedure:


exec dbo.spRepHumFormN85AnnualFirst @LANGID=N'ru',@Year=2012

*/ 

create  Procedure [dbo].[spRepHumFormN85AnnualFirst]
	 (
		 @LangID		As nvarchar(50), 
		 @Year			as int
	 )
AS	 

DECLARE 		
		@StartDate	DATETIME,	 
		@FinishDate	DATETIME,
		@idfsSummaryReportType BIGINT,
		@idfsLanguage BIGINT
		
SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)		
		
set @StartDate = (CAST(@Year AS VARCHAR(4)) + '01' + '01')
set @FinishDate = dateADD(yyyy, 1, @StartDate)


SET @idfsSummaryReportType = 10290015 /*ARM National Statistic Form # 85 (annual) - Table 1*/

declare @DG_TyphoidFever bigint

select @DG_TyphoidFever = dg.idfsReportDiagnosisGroup
from dbo.trtReportDiagnosisGroup dg
where dg.intRowStatus = 0 and
      dg.strDiagnosisGroupAlias = 'DG_TyphoidFever'


declare	@ReportTable	table
(	idfsBaseReference		bigint not null primary key,
	intRowNumber			int null, --2
	strDisease			nvarchar(300) collate database_default not null, --1
	strICD					nvarchar(200) collate database_default null,	--3
	intJan					int not null, --5
	intFeb					int not null, --6
	intMar					int not null, --7
	intApr					int not null, --8
	intMay					int not null, --9
	intJun					int not null, --10
	intJul					int not null, --11
	intAug					int not null, --12
	intSep					int not null, --13
	intOct					int not null, --14
	intNov					int not null, --15
	intDec					int not null --16
)


INSERT INTO @ReportTable (
	idfsBaseReference,
	intRowNumber,
	strDisease,
	strICD,
	intJan,
	intFeb,
	intMar,
	intApr,
	intMay,
	intJun,
	intJul,
	intAug,
	intSep,
	intOct,
	intNov,
	intDec
) 
SELECT		rr.idfsDiagnosisOrReportDiagnosisGroup,
			rr.intRowOrder,
			IsNull(IsNull(snt1.strTextString, br1.strDefault) +  N' ', N'') + IsNull(snt.strTextString, br.strDefault),
			ISNULL(d.strIDC10, dg.strCode),
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0
FROM   dbo.trtReportRows rr
    LEFT JOIN trtBaseReference br
        LEFT JOIN trtStringNameTranslation snt
        ON br.idfsBaseReference = snt.idfsBaseReference
			  AND snt.idfsLanguage = @idfsLanguage
--			  and snt.intRowStatus = 0

        LEFT OUTER JOIN trtDiagnosis d
        ON br.idfsBaseReference = d.idfsDiagnosis
  			--and d.intRowStatus = 0
  
        LEFT OUTER JOIN trtReportDiagnosisGroup dg
        ON br.idfsBaseReference = dg.idfsReportDiagnosisGroup
--	  		and dg.intRowStatus = 0
    ON rr.idfsDiagnosisOrReportDiagnosisGroup = br.idfsBaseReference
		--and br.intRowStatus = 0

    LEFT OUTER JOIN trtBaseReference br1
        LEFT OUTER JOIN trtStringNameTranslation snt1
        ON br1.idfsBaseReference = snt1.idfsBaseReference
			  AND snt1.idfsLanguage = @idfsLanguage
--			  and snt1.intRowStatus = 0
    ON rr.idfsReportAdditionalText = br1.idfsBaseReference
--		and br1.intRowStatus = 0

WHERE rr.idfsCustomReportType = @idfsSummaryReportType
		and rr.intRowStatus = 0
ORDER BY rr.intRowOrder  



DECLARE	@ReportDiagnosisTable	TABLE
(	idfsDiagnosis			BIGINT NOT NULL PRIMARY KEY,
	intJan					int not null, --5
	intFeb					int not null, --6
	intMar					int not null, --7
	intApr					int not null, --8
	intMay					int not null, --9
	intJun					int not null, --10
	intJul					int not null, --11
	intAug					int not null, --12
	intSep					int not null, --13
	intOct					int not null, --14
	intNov					int not null, --15
	intDec					int not null --16
)

INSERT INTO @ReportDiagnosisTable (
	idfsDiagnosis,
	intJan,
	intFeb,
	intMar,
	intApr,
	intMay,
	intJun,
	intJul,
	intAug,
	intSep,
	intOct,
	intNov,
	intDec
) 
SELECT distinct
	fdt.idfsDiagnosis,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0

FROM dbo.trtDiagnosisToGroupForReportType fdt
    INNER JOIN trtDiagnosis trtd
    ON trtd.idfsDiagnosis = fdt.idfsDiagnosis
    -- AND trtd.intRowStatus = 0
WHERE  fdt.idfsCustomReportType = @idfsSummaryReportType 

       
INSERT INTO @ReportDiagnosisTable (
	idfsDiagnosis,
	intJan,
	intFeb,
	intMar,
	intApr,
	intMay,
	intJun,
	intJul,
	intAug,
	intSep,
	intOct,
	intNov,
	intDec
) 
SELECT distinct
	trtd.idfsDiagnosis,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0

FROM dbo.trtReportRows rr
    INNER JOIN trtBaseReference br
    ON br.idfsBaseReference = rr.idfsDiagnosisOrReportDiagnosisGroup
        AND br.idfsReferenceType = 19000019 --'rftDiagnosis'
        --AND br.intRowStatus = 0
    INNER JOIN trtDiagnosis trtd
    ON trtd.idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup 
        --AND trtd.intRowStatus = 0
WHERE  rr.idfsCustomReportType = @idfsSummaryReportType 
       AND  rr.intRowStatus = 0 
       AND NOT EXISTS 
       (
       SELECT * FROM @ReportDiagnosisTable
       WHERE idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup
       )      


declare	@ReportCaseTable	table
(	idfsDiagnosis		BIGINT  not null,
	idfCase				BIGINT not null primary key,
	intMonth			int NULL
)


insert into	@ReportCaseTable
(	idfsDiagnosis,
	idfCase,
	intMonth
)
select distinct
			fdt.idfsDiagnosis,
			hc.idfHumanCase AS idfCase,
			case
				when	hc.datOnSetDate is not null
					then	Month(hc.datOnSetDate)
				when	hc.datOnSetDate is null
						and hc.datFinalDiagnosisDate is not null
					then	Month(hc.datFinalDiagnosisDate)
				when	hc.datOnSetDate is null
						and hc.datFinalDiagnosisDate is null
						and hc.datTentativeDiagnosisDate is not null
					then	Month(hc.datTentativeDiagnosisDate)
				when	hc.datOnSetDate is null
						and hc.datFinalDiagnosisDate is null
						and hc.datTentativeDiagnosisDate is null
						and hc.datNotificationDate is not null
					then	Month(hc.datNotificationDate)
				when	hc.datOnSetDate is null
						and hc.datFinalDiagnosisDate is null
						and hc.datTentativeDiagnosisDate is null
						and hc.datNotificationDate is null
						and hc.datEnteredDate is not null
					then	Month(hc.datEnteredDate)
				else	null
			end
			
from		tlbHumanCase hc

inner join	tlbHuman h
on		hc.idfHuman	= h.idfHuman
and h.intRowStatus = 0
			

inner join	@ReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = IsNull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)

left join dbo.trtDiagnosisToGroupForReportType dgfrt
on dgfrt.idfsDiagnosis = IsNull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)
and dgfrt.idfsReportDiagnosisGroup = @DG_TyphoidFever
and dgfrt.idfsCustomReportType = @idfsSummaryReportType
			
where		(	(	hc.datOnSetDate is not null
					and (	@StartDate <= hc.datOnSetDate
							and hc.datOnSetDate < @FinishDate
						)
				)
				or	(	hc.datOnSetDate is null
						and hc.datFinalDiagnosisDate is not null
						and (	@StartDate <= hc.datFinalDiagnosisDate
								and hc.datFinalDiagnosisDate < @FinishDate
							)
					)
				or	(	hc.datOnSetDate is null
						and hc.datFinalDiagnosisDate is null
						and hc.datTentativeDiagnosisDate is not null
						and (	@StartDate <= hc.datTentativeDiagnosisDate
								and hc.datTentativeDiagnosisDate < @FinishDate
							)
					)
				or	(	hc.datOnSetDate is null
						and hc.datFinalDiagnosisDate is null
						and hc.datTentativeDiagnosisDate is null
						and hc.datNotificationDate is not null
						and (	@StartDate <= hc.datNotificationDate
								and hc.datNotificationDate < @FinishDate
							)
					)
				or	(	hc.datOnSetDate is null
						and hc.datFinalDiagnosisDate is null
						and hc.datTentativeDiagnosisDate is null
						and hc.datNotificationDate is null
						and hc.datEnteredDate is not null
						and (	@StartDate <= hc.datEnteredDate
								and hc.datEnteredDate < @FinishDate
							)
					)
			)
			and	(	(	IsNull(hc.idfsFinalCaseStatus, hc.idfsInitialCaseStatus) = 350000000 -- Confirmed Case
						--and IsNull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = 786460000000	-- Typhoid fever
						and dgfrt.idfsReportDiagnosisGroup = @DG_TyphoidFever
					)
					or	--IsNull(hc.idfsFinalDiagnosis, IsNull(hc.idfsTentativeDiagnosis, -1)) <> 786460000000	-- Typhoid fever
					    dgfrt.idfsReportDiagnosisGroup IS NULL
				)
			AND hc.intRowStatus = 0
			
-- January
declare	@ReportCaseDiagnosisJanValuesTable	table
(	idfsDiagnosis	BIGINT not null primary key,
	intJan		INT not null
)

insert into	@ReportCaseDiagnosisJanValuesTable
(	idfsDiagnosis,
	intJan
)
select		rct.idfsDiagnosis,
			count(rct.idfCase)
from		@ReportCaseTable rct
where		intMonth = 1
group by	rct.idfsDiagnosis

-- February
declare	@ReportCaseDiagnosisFebValuesTable	table
(	idfsDiagnosis	BIGINT not null primary key,
	intFeb		INT not null
)

insert into	@ReportCaseDiagnosisFebValuesTable
(	idfsDiagnosis,
	intFeb
)
select		rct.idfsDiagnosis,
			count(rct.idfCase)
from		@ReportCaseTable rct
where		intMonth = 2
group by	rct.idfsDiagnosis

-- March
declare	@ReportCaseDiagnosisMarValuesTable	table
(	idfsDiagnosis	BIGINT not null primary key,
	intMar		INT not null
)

insert into	@ReportCaseDiagnosisMarValuesTable
(	idfsDiagnosis,
	intMar
)
select		rct.idfsDiagnosis,
			count(rct.idfCase)
from		@ReportCaseTable rct
where		intMonth = 3
group by	rct.idfsDiagnosis

-- April
declare	@ReportCaseDiagnosisAprValuesTable	table
(	idfsDiagnosis	BIGINT not null primary key,
	intApr		INT not null
)

insert into	@ReportCaseDiagnosisAprValuesTable
(	idfsDiagnosis,
	intApr
)
select		rct.idfsDiagnosis,
			count(rct.idfCase)
from		@ReportCaseTable rct
where		intMonth = 4
group by	rct.idfsDiagnosis

-- May
declare	@ReportCaseDiagnosisMayValuesTable	table
(	idfsDiagnosis	BIGINT not null primary key,
	intMay		INT not null
)

insert into	@ReportCaseDiagnosisMayValuesTable
(	idfsDiagnosis,
	intMay
)
select		rct.idfsDiagnosis,
			count(rct.idfCase)
from		@ReportCaseTable rct
where		intMonth = 5
group by	rct.idfsDiagnosis

-- June
declare	@ReportCaseDiagnosisJunValuesTable	table
(	idfsDiagnosis	BIGINT not null primary key,
	intJun		INT not null
)

insert into	@ReportCaseDiagnosisJunValuesTable
(	idfsDiagnosis,
	intJun
)
select		rct.idfsDiagnosis,
			count(rct.idfCase)
from		@ReportCaseTable rct
where		intMonth = 6
group by	rct.idfsDiagnosis

-- July
declare	@ReportCaseDiagnosisJulValuesTable	table
(	idfsDiagnosis	BIGINT not null primary key,
	intJul		INT not null
)

insert into	@ReportCaseDiagnosisJulValuesTable
(	idfsDiagnosis,
	intJul
)
select		rct.idfsDiagnosis,
			count(rct.idfCase)
from		@ReportCaseTable rct
where		intMonth = 7
group by	rct.idfsDiagnosis

-- August
declare	@ReportCaseDiagnosisAugValuesTable	table
(	idfsDiagnosis	BIGINT not null primary key,
	intAug		INT not null
)

insert into	@ReportCaseDiagnosisAugValuesTable
(	idfsDiagnosis,
	intAug
)
select		rct.idfsDiagnosis,
			count(rct.idfCase)
from		@ReportCaseTable rct
where		intMonth = 8
group by	rct.idfsDiagnosis

-- September
declare	@ReportCaseDiagnosisSepValuesTable	table
(	idfsDiagnosis	BIGINT not null primary key,
	intSep		INT not null
)

insert into	@ReportCaseDiagnosisSepValuesTable
(	idfsDiagnosis,
	intSep
)
select		rct.idfsDiagnosis,
			count(rct.idfCase)
from		@ReportCaseTable rct
where		intMonth = 9
group by	rct.idfsDiagnosis

-- October
declare	@ReportCaseDiagnosisOctValuesTable	table
(	idfsDiagnosis	BIGINT not null primary key,
	intOct		INT not null
)

insert into	@ReportCaseDiagnosisOctValuesTable
(	idfsDiagnosis,
	intOct
)
select		rct.idfsDiagnosis,
			count(rct.idfCase)
from		@ReportCaseTable rct
where		intMonth = 10
group by	rct.idfsDiagnosis

-- November
declare	@ReportCaseDiagnosisNovValuesTable	table
(	idfsDiagnosis	BIGINT not null primary key,
	intNov		INT not null
)

insert into	@ReportCaseDiagnosisNovValuesTable
(	idfsDiagnosis,
	intNov
)
select		rct.idfsDiagnosis,
			count(rct.idfCase)
from		@ReportCaseTable rct
where		intMonth = 11
group by	rct.idfsDiagnosis

-- December
declare	@ReportCaseDiagnosisDecValuesTable	table
(	idfsDiagnosis	BIGINT not null primary key,
	intDec		INT not null
)

insert into	@ReportCaseDiagnosisDecValuesTable
(	idfsDiagnosis,
	intDec
)
select		rct.idfsDiagnosis,
			count(rct.idfCase)
from		@ReportCaseTable rct
where		intMonth = 12
group by	rct.idfsDiagnosis


update		rdt
set			rdt.intJan = rcd_jan.intJan
from		@ReportDiagnosisTable rdt
inner join	@ReportCaseDiagnosisJanValuesTable rcd_jan
on			rcd_jan.idfsDiagnosis = rdt.idfsDiagnosis

update		rdt
set			rdt.intFeb = rcd_feb.intFeb
from		@ReportDiagnosisTable rdt
inner join	@ReportCaseDiagnosisFebValuesTable rcd_feb
on			rcd_feb.idfsDiagnosis = rdt.idfsDiagnosis

update		rdt
set			rdt.intMar = rcd_mar.intMar
from		@ReportDiagnosisTable rdt
inner join	@ReportCaseDiagnosisMarValuesTable rcd_mar
on			rcd_mar.idfsDiagnosis = rdt.idfsDiagnosis

update		rdt
set			rdt.intApr = rcd_apr.intApr
from		@ReportDiagnosisTable rdt
inner join	@ReportCaseDiagnosisAprValuesTable rcd_apr
on			rcd_apr.idfsDiagnosis = rdt.idfsDiagnosis

update		rdt
set			rdt.intMay = rcd_may.intMay
from		@ReportDiagnosisTable rdt
inner join	@ReportCaseDiagnosisMayValuesTable rcd_may
on			rcd_may.idfsDiagnosis = rdt.idfsDiagnosis

update		rdt
set			rdt.intJun = rcd_jun.intJun
from		@ReportDiagnosisTable rdt
inner join	@ReportCaseDiagnosisJunValuesTable rcd_jun
on			rcd_jun.idfsDiagnosis = rdt.idfsDiagnosis

update		rdt
set			rdt.intJul = rcd_jul.intJul
from		@ReportDiagnosisTable rdt
inner join	@ReportCaseDiagnosisJulValuesTable rcd_jul
on			rcd_jul.idfsDiagnosis = rdt.idfsDiagnosis

update		rdt
set			rdt.intAug = rcd_aug.intAug
from		@ReportDiagnosisTable rdt
inner join	@ReportCaseDiagnosisAugValuesTable rcd_aug
on			rcd_aug.idfsDiagnosis = rdt.idfsDiagnosis

update		rdt
set			rdt.intSep = rcd_sep.intSep
from		@ReportDiagnosisTable rdt
inner join	@ReportCaseDiagnosisSepValuesTable rcd_sep
on			rcd_sep.idfsDiagnosis = rdt.idfsDiagnosis

update		rdt
set			rdt.intOct = rcd_oct.intOct
from		@ReportDiagnosisTable rdt
inner join	@ReportCaseDiagnosisOctValuesTable rcd_oct
on			rcd_oct.idfsDiagnosis = rdt.idfsDiagnosis

update		rdt
set			rdt.intNov = rcd_nov.intNov
from		@ReportDiagnosisTable rdt
inner join	@ReportCaseDiagnosisNovValuesTable rcd_nov
on			rcd_nov.idfsDiagnosis = rdt.idfsDiagnosis

update		rdt
set			rdt.intDec = rcd_dec.intDec
from		@ReportDiagnosisTable rdt
inner join	@ReportCaseDiagnosisDecValuesTable rcd_dec
on			rcd_dec.idfsDiagnosis = rdt.idfsDiagnosis


DECLARE	@ReportDiagnosisGroupTable	TABLE
(	idfsDiagnosisGroup		BIGINT NOT NULL PRIMARY KEY,
	intJan					int not null,
	intFeb					int not null,
	intMar					int not null,
	intApr					int not null,
	intMay					int not null,
	intJun					int not null,
	intJul					int not null,
	intAug					int not null,
	intSep					int not null,
	intOct					int not null,
	intNov					int not null,
	intDec					int not null
)

INSERT INTO @ReportDiagnosisGroupTable (
	idfsDiagnosisGroup,
	intJan,
	intFeb,
	intMar,
	intApr,
	intMay,
	intJun,
	intJul,
	intAug,
	intSep,
	intOct,
	intNov,
	intDec
)
select		dtg.idfsReportDiagnosisGroup,
			sum(rdt.intJan),
			sum(rdt.intFeb),
			sum(rdt.intMar),
			sum(rdt.intApr),
			sum(rdt.intMay),
			sum(rdt.intJun),
			sum(rdt.intJul),
			sum(rdt.intAug),
			sum(rdt.intSep),
			sum(rdt.intOct),
			sum(rdt.intNov),
			sum(rdt.intDec)
from		@ReportDiagnosisTable rdt
inner join	trtDiagnosisToGroupForReportType dtg
on			dtg.idfsDiagnosis = rdt.idfsDiagnosis
			and dtg.idfsCustomReportType = @idfsSummaryReportType
group by	dtg.idfsReportDiagnosisGroup	


update		rt
set			rt.intJan = rdt.intJan,
			rt.intFeb = rdt.intFeb,
			rt.intMar = rdt.intMar,
			rt.intApr = rdt.intApr,
			rt.intMay = rdt.intMay,
			rt.intJun = rdt.intJun,
			rt.intJul = rdt.intJul,
			rt.intAug = rdt.intAug,
			rt.intSep = rdt.intSep,
			rt.intOct = rdt.intOct,
			rt.intNov = rdt.intNov,
			rt.intDec = rdt.intDec
from		@ReportTable rt
inner join	@ReportDiagnosisTable rdt
on			rdt.idfsDiagnosis = rt.idfsBaseReference	
		
		
update		rt
set			rt.intJan = rdgt.intJan,
			rt.intFeb = rdgt.intFeb,
			rt.intMar = rdgt.intMar,
			rt.intApr = rdgt.intApr,
			rt.intMay = rdgt.intMay,
			rt.intJun = rdgt.intJun,
			rt.intJul = rdgt.intJul,
			rt.intAug = rdgt.intAug,
			rt.intSep = rdgt.intSep,
			rt.intOct = rdgt.intOct,
			rt.intNov = rdgt.intNov,
			rt.intDec = rdgt.intDec
from		@ReportTable rt
inner join	@ReportDiagnosisGroupTable rdgt
on			rdgt.idfsDiagnosisGroup = rt.idfsBaseReference			
	

select		cast(@Year as nvarchar(10)) as strReportedPeriod,
			strDisease,
			strICD,
			case	intJan
				when	0
					then	null
				else intJan
			end as intJan,
			case	intFeb
				when	0
					then	null
				else intFeb
			end as intFeb,
			case	intMar
				when	0
					then	null
				else intMar
			end as intMar,
			case	intApr
				when	0
					then	null
				else intApr
			end as intApr,
			case	intMay
				when	0
					then	null
				else intMay
			end as intMay,
			case	intJun
				when	0
					then	null
				else intJun
			end as intJun,
			case	intJul
				when	0
					then	null
				else intJul
			end as intJul,
			case	intAug
				when	0
					then	null
				else intAug
			end as intAug,
			case	intSep
				when	0
					then	null
				else intSep
			end as intSep,
			case	intOct
				when	0
					then	null
				else intOct
			end as intOct,
			case	intNov
				when	0
					then	null
				else intNov
			end as intNov,
			case	intDec
				when	0
					then	null
				else intDec
			end as intDec
			
from		@ReportTable
order by	intRowNumber



	--declare @DiseaseTable as table
	--(
	--	En  nvarchar(max),
	--	Arm  nvarchar(max),
	--	Ru  nvarchar(max),
	--	ICD  nvarchar(max)
	--)

--insert into @DiseaseTable values (N'Shigellosis',	N'Մանրէային դիզենտերիա (շիգելոզ)',	N'Бактериальная дизентерия (шигелёз)',	N'A03, A03.0-03.3')
--insert into @DiseaseTable values (N'Confirmed typhoid fever, including confirmed by hemoculture and serologically',	N'Որովայնային տիֆ հաստատված',	N'Подтвержденный брюшной тиф',	N'A01.0')


--	select 
--		cast(@Year as nvarchar(10)) as strReportedPeriod,
--		case 
--		 when @LangID = 'ru' then Ru
--		 when @LangID = 'hy' then Arm
--		 else En
--		end as strDisease,
--		ICD as strICD,
--	    cast(2* RAND(CHECKSUM(NEWID())) as int) as intJan,
--	    cast(2* RAND(CHECKSUM(NEWID())) as int) as intFeb,
--	    cast(2* RAND(CHECKSUM(NEWID())) as int) as intMar,
--	    cast(2* RAND(CHECKSUM(NEWID())) as int) as intApr,
--	    cast(2* RAND(CHECKSUM(NEWID())) as int) as intMay,
--	    cast(2* RAND(CHECKSUM(NEWID())) as int) as intJun,
--	    cast(2* RAND(CHECKSUM(NEWID())) as int) as intJul,
--	    cast(2* RAND(CHECKSUM(NEWID())) as int) as intAug,
--	    cast(2* RAND(CHECKSUM(NEWID())) as int) as intSep,
--	    cast(2* RAND(CHECKSUM(NEWID())) as int) as intOct,
--	    cast(2* RAND(CHECKSUM(NEWID())) as int) as intNov,
--	    cast(2* RAND(CHECKSUM(NEWID())) as int) as intDec
	    
--	 from @DiseaseTable


