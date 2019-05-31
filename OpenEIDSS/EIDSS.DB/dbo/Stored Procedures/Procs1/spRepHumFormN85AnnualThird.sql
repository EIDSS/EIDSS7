
--##SUMMARY Select data for Armenian Form 85 custom reort

--##REMARKS Author: 
--##REMARKS Create date: 14.04.2012

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013
 
--##RETURNS Doesn't use

/*
--Example of a call of procedure:



exec dbo.spRepHumFormN85AnnualThird @LANGID=N'ru',@Year=2012

*/ 

create  Procedure [dbo].[spRepHumFormN85AnnualThird]
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


SET @idfsSummaryReportType = 10290017 /*National Statistic Form # 85 (annual) - Table 3*/


declare	@ReportTable	table
(	idfsBaseReference	bigint not null primary key,
	intRowNumber		int null, --2
	strDisease			nvarchar(300) collate database_default not null, --1
	strICD				nvarchar(200) collate database_default null,	--3
	intChildrenYear		int not null, --4
	intChildrenMonth	int not null --5
)

INSERT INTO @ReportTable (
	idfsBaseReference,
	intRowNumber,
	strDisease,
	strICD,
	intChildrenYear,
	intChildrenMonth
) 
SELECT		rr.idfsDiagnosisOrReportDiagnosisGroup,
			rr.intRowOrder,
			IsNull(IsNull(snt1.strTextString, br1.strDefault) +  N' ', N'') + IsNull(snt.strTextString, br.strDefault),
			ISNULL(d.strIDC10, dg.strCode),
			0,
			0
FROM   dbo.trtReportRows rr
    LEFT JOIN trtBaseReference br
        LEFT JOIN trtStringNameTranslation snt
        ON br.idfsBaseReference = snt.idfsBaseReference
			AND snt.idfsLanguage = @idfsLanguage
--			and snt.intRowStatus = 0
        LEFT OUTER JOIN trtDiagnosis d
        ON br.idfsBaseReference = d.idfsDiagnosis
			--and d.intRowStatus = 0
        LEFT OUTER JOIN trtReportDiagnosisGroup dg
        ON br.idfsBaseReference = dg.idfsReportDiagnosisGroup
--			and dg.intRowStatus = 0
    ON rr.idfsDiagnosisOrReportDiagnosisGroup = br.idfsBaseReference
		--and br.intRowStatus = 0

    LEFT OUTER JOIN trtBaseReference br1
        LEFT OUTER JOIN trtStringNameTranslation snt1
        ON br1.idfsBaseReference = snt1.idfsBaseReference
			AND snt1.idfsLanguage = @idfsLanguage
--			and snt1.intRowStatus = 0
    ON rr.idfsReportAdditionalText = br1.idfsBaseReference
--		and br1.intRowStatus = 0

WHERE rr.idfsCustomReportType = @idfsSummaryReportType
		and rr.intRowStatus = 0
ORDER BY rr.intRowOrder  



DECLARE	@ReportDiagnosisTable	TABLE
(	idfsDiagnosis		bigint not null primary key,
	intChildrenYear		int not null,
	intChildrenMonth	int not null
)

INSERT INTO @ReportDiagnosisTable (
	idfsDiagnosis,
	intChildrenYear,
	intChildrenMonth
) 
SELECT distinct
  fdt.idfsDiagnosis,
  0,
  0

FROM dbo.trtDiagnosisToGroupForReportType fdt
    INNER JOIN trtDiagnosis trtd
    ON trtd.idfsDiagnosis = fdt.idfsDiagnosis
    -- AND trtd.intRowStatus = 0
WHERE  fdt.idfsCustomReportType = @idfsSummaryReportType 


       
INSERT INTO @ReportDiagnosisTable (
	idfsDiagnosis,
	intChildrenYear,
	intChildrenMonth
) 
SELECT distinct
  trtd.idfsDiagnosis,
  0,
  0

FROM dbo.trtReportRows rr
    INNER JOIN trtBaseReference br
    ON br.idfsBaseReference = rr.idfsDiagnosisOrReportDiagnosisGroup
        AND br.idfsReferenceType = 19000019 --'rftDiagnosis'
--        AND br.intRowStatus = 0
    INNER JOIN trtDiagnosis trtd
    ON trtd.idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup 
--        AND trtd.intRowStatus = 0
WHERE  rr.idfsCustomReportType = @idfsSummaryReportType 
       AND  rr.intRowStatus = 0 
       AND NOT EXISTS 
       (
       SELECT * FROM @ReportDiagnosisTable
       WHERE idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup
       )      


declare	@ReportCaseTable	table
(	idfsDiagnosis	bigint not null,
	idfCase			bigint not null primary key,
	intMonth		int null
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
				when	IsNull(hc .idfsHumanAgeType, -1) = 10042003	-- Years 
						and (IsNull(hc.intPatientAge, -1) >= 0 and IsNull(hc.intPatientAge, -1) <= 200)
					then	hc.intPatientAge * 12 + 1
				when	IsNull(hc .idfsHumanAgeType, -1) = 10042002	-- Months
						and (IsNull(hc.intPatientAge, -1) >= 0 and IsNull(hc.intPatientAge, -1) <= 60)
					then	hc.intPatientAge
				when	IsNull(hc .idfsHumanAgeType, -1) = 10042001	-- Days
						and (IsNull(hc.intPatientAge, -1) >= 0)
					then	0
				else	null
			end
			
from		tlbHumanCase hc

inner join	@ReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = IsNull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)

inner join	tlbHuman h
on		hc.idfHuman	= h.idfHuman
and h.intRowStatus = 0
			
			
where		(	hc.datOnSetDate is not null
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
			AND hc.intRowStatus = 0

-- Children Year
declare	@ReportCaseDiagnosis_ChildrenYear_ValuesTable	table
(	idfsDiagnosis	bigint not null primary key,
	intChildrenYear	int not null
)

insert into	@ReportCaseDiagnosis_ChildrenYear_ValuesTable
(	idfsDiagnosis,
	intChildrenYear
)
select		rct.idfsDiagnosis,
			count(rct.idfCase)
from		@ReportCaseTable rct
where		rct.intMonth >= 0 and rct.intMonth <= 12
group by	rct.idfsDiagnosis


-- Children Month
declare	@ReportCaseDiagnosis_ChildrenMonth_ValuesTable	table
(	idfsDiagnosis		bigint not null primary key,
	intChildrenMonth	int not null
)

insert into	@ReportCaseDiagnosis_ChildrenMonth_ValuesTable
(	idfsDiagnosis,
	intChildrenMonth
)
select		rct.idfsDiagnosis,
			count(rct.idfCase)
from		@ReportCaseTable rct
where		rct.intMonth = 0
group by	rct.idfsDiagnosis



update		rdt
set			rdt.intChildrenYear = rcd_vt.intChildrenYear
from		@ReportDiagnosisTable rdt
inner join	@ReportCaseDiagnosis_ChildrenYear_ValuesTable rcd_vt
on			rcd_vt.idfsDiagnosis = rdt.idfsDiagnosis

update		rdt
set			rdt.intChildrenMonth = rcd_vt.intChildrenMonth
from		@ReportDiagnosisTable rdt
inner join	@ReportCaseDiagnosis_ChildrenMonth_ValuesTable rcd_vt
on			rcd_vt.idfsDiagnosis = rdt.idfsDiagnosis


DECLARE	@ReportDiagnosisGroupTable	TABLE
(	idfsDiagnosisGroup	bigint not null primary key,
	intChildrenYear		int not null,
	intChildrenMonth	int not null
)

INSERT INTO @ReportDiagnosisGroupTable
(	idfsDiagnosisGroup,
	intChildrenYear,
	intChildrenMonth
)
select		dtg.idfsReportDiagnosisGroup,
			sum(rdt.intChildrenYear),	
			sum(rdt.intChildrenMonth)
from		@ReportDiagnosisTable rdt
inner join	trtDiagnosisToGroupForReportType dtg
on			dtg.idfsDiagnosis = rdt.idfsDiagnosis
			and dtg.idfsCustomReportType = @idfsSummaryReportType

group by	dtg.idfsReportDiagnosisGroup	


update		rt
set			rt.intChildrenYear = rdt.intChildrenYear,
			rt.intChildrenMonth = rdt.intChildrenMonth
from		@ReportTable rt
inner join	@ReportDiagnosisTable rdt
on			rdt.idfsDiagnosis = rt.idfsBaseReference	
		
		
update		rt
set			rt.intChildrenYear = rdgt.intChildrenYear,
			rt.intChildrenMonth = rdgt.intChildrenMonth
from		@ReportTable rt
inner join	@ReportDiagnosisGroupTable rdgt
on			rdgt.idfsDiagnosisGroup = rt.idfsBaseReference			



select		strDisease,
			strICD,
			case	intChildrenYear
				when	0
					then	null
				else intChildrenYear
			end as intChildrenYear,
			case	intChildrenMonth
				when	0
					then	null
				else intChildrenMonth
			end as intChildrenMonth
			
from		@ReportTable
order by	intRowNumber











	--declare @DiseaseTable as table
	--(
	--	En  nvarchar(max),
	--	Arm  nvarchar(max),
	--	Ru  nvarchar(max),
	--	ICD  nvarchar(max)
	--)

--insert into @DiseaseTable values (N'Shigellosis and acute intestinal infection with identified aetilogy including bacterial or viral agent, food toxic infections',	N'Մանրէային դիզենտերիա (շիգելոզ), հաստատված հարուցիչներով հարուցված սուր աղիքային վարակիչ հիվանդություններ, այդ թվում բակտերային կամ վիրուսային պատճառներով, սննդային տոքսիկոինֆեկցիաներ',	N'Бактериальная дизентерия и энтериты, колиты, гастроэнтериты, а также пищевые токсикоинфекции установленной этиологии',	N'A03, A03.0-03.3 A05.0-A05.8')
--insert into @DiseaseTable values (N'Acute intestinal infection with unidentified aetiology',	N'Չհաստատված հարուցիչներով հարուցված սուր աղիքային վարակիչ հիվանդություններ, անհայտ ծագումնաբանությամբ սննդային տոքսիկոինֆեկցիաներ',	N'Энтериты, колиты,гастроэнтериты, а также пищевые токсикоинфекции неустановленной этиологии',	N'A05.9')
--insert into @DiseaseTable values (N'Measles ',	N'Կարմրուկ',	N'Корь',	N'B05')
--insert into @DiseaseTable values (N'Other Salmonella infections',	N'Այլ սալմոնելոզային վարակներ',	N'Другие сальмонеллёзные инфекции',	N'A02')


--	select 
--		case 
--		 when @LangID = 'ru' then Ru
--		 when @LangID = 'hy' then Arm
--		 else En
--		end as strDisease,
--		ICD as strICD,
--	    cast(2* RAND(CHECKSUM(NEWID())) as int) + cast(2* RAND(CHECKSUM(NEWID())) as int) as intChildrenYear,
--	    cast(2* RAND(CHECKSUM(NEWID())) as int) as intChildrenMonth
	    
--	 from @DiseaseTable



