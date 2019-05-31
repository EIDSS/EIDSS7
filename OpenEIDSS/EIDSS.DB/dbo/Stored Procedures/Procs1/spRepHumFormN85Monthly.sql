


--##SUMMARY Select data for Armenian Form 85 custom reort

--##REMARKS Author: 
--##REMARKS Create date: 14.04.2012

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013
 
--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepHumFormN85Monthly @LANGID=N'ru',@Year=2011,@Month=08

*/ 
   
CREATE  Procedure [dbo].[spRepHumFormN85Monthly]
	 (
		 @LangID		As nvarchar(50), 
		 @Year			as int, 
		 @Month			as int
	 )
AS	



DECLARE 		
		@StartDate	DATETIME,	 
		@FinishDate	DATETIME,
		@idfsSummaryReportType BIGINT,
		@idfsLanguage BIGINT
		
SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)		
		
if @Month IS null
begin
	set @StartDate = (CAST(@Year AS VARCHAR(4)) + '01' + '01')
	set @FinishDate = dateADD(yyyy, 1, @StartDate)
end
else
begin	
  IF @Month < 10 set @StartDate = (CAST(@Year AS VARCHAR(4)) + '0' +CAST(@Month AS VARCHAR(2)) + '01')
  ELSE  set @StartDate = (CAST(@Year AS VARCHAR(4)) + CAST(@Month AS VARCHAR(2)) + '01')
	set @FinishDate = dateADD(mm, 1, @StartDate)
end		



SET @idfsSummaryReportType = 10290018 /*National Statistic Form # 85 (monthly)*/


declare	@ReportTable	table
(	idfsBaseReference		bigint not null primary key,
	intRowNumber			int null, --2
	strDisease				nvarchar(300) collate database_default not null, --1
	strICD					nvarchar(200) collate database_default null,	--3
	intTotal				int not null, --5
	intIncludingChildren	int not null --6
)

INSERT INTO @ReportTable (
	idfsBaseReference,
	intRowNumber,
	strDisease,
	strICD,
	intTotal,
	intIncludingChildren
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
(	idfsDiagnosis			BIGINT NOT NULL PRIMARY KEY,
	intTotal				INT NOT NULL,
	intIncludingChildren	INT NOT NULL
)

INSERT INTO @ReportDiagnosisTable (
	idfsDiagnosis,
	intTotal,
	intIncludingChildren
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
	intTotal,
	intIncludingChildren
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
	intYear				int NULL
)


insert into	@ReportCaseTable
(	idfsDiagnosis,
	idfCase,
	intYear
)
select distinct
			fdt.idfsDiagnosis,
			hc.idfHumanCase AS idfCase,
			case
				when	IsNull(hc .idfsHumanAgeType, -1) = 10042003	-- Years 
						and (IsNull(hc.intPatientAge, -1) >= 0 and IsNull(hc.intPatientAge, -1) <= 200)
					then	hc.intPatientAge
				when	IsNull(hc .idfsHumanAgeType, -1) = 10042002	-- Months
						and (IsNull(hc.intPatientAge, -1) >= 0 and IsNull(hc.intPatientAge, -1) <= 60)
					then	cast(hc.intPatientAge / 12 as int)
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

--Total
declare	@ReportCaseDiagnosisTotalValuesTable	table
(	idfsDiagnosis	BIGINT not null primary key,
	intTotal		INT not null
)

insert into	@ReportCaseDiagnosisTotalValuesTable
(	idfsDiagnosis,
	intTotal
)
select		rct.idfsDiagnosis,
			count(rct.idfCase)
from		@ReportCaseTable rct
group by	rct.idfsDiagnosis


--Total Children
declare	@ReportCaseDiagnosisChildrenValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intIncludingChildren	INT not null
)


insert into	@ReportCaseDiagnosisChildrenValuesTable
(	idfsDiagnosis,
	intIncludingChildren
)
select		rct.idfsDiagnosis,
			count(rct.idfCase)
from		@ReportCaseTable rct
where		rct.intYear >= 0 and rct.intYear <= 14
group by	rct.idfsDiagnosis


update		rdt
set			rdt.intTotal = rcdtvt.intTotal
from		@ReportDiagnosisTable rdt
inner join	@ReportCaseDiagnosisTotalValuesTable rcdtvt
on			rcdtvt.idfsDiagnosis = rdt.idfsDiagnosis
		

update		rdt
set			rdt.intIncludingChildren = rcdcvt.intIncludingChildren
from		@ReportDiagnosisTable rdt
inner join	@ReportCaseDiagnosisChildrenValuesTable rcdcvt
on			rcdcvt.idfsDiagnosis = rdt.idfsDiagnosis



DECLARE	@ReportDiagnosisGroupTable	TABLE
(	idfsDiagnosisGroup		BIGINT NOT NULL PRIMARY KEY,
	intTotal				INT NOT NULL,
	intIncludingChildren	INT NOT NULL
)


insert into	@ReportDiagnosisGroupTable
(	idfsDiagnosisGroup,
	intTotal,
	intIncludingChildren
)
select		dtg.idfsReportDiagnosisGroup,
			sum(rdt.intTotal),	
			sum(rdt.intIncludingChildren)
from		@ReportDiagnosisTable rdt
inner join	trtDiagnosisToGroupForReportType dtg
on			dtg.idfsDiagnosis = rdt.idfsDiagnosis
			and dtg.idfsCustomReportType = @idfsSummaryReportType

group by	dtg.idfsReportDiagnosisGroup	


update		rt
set			rt.intTotal = rdt.intTotal,
			rt.intIncludingChildren = rdt.intIncludingChildren
from		@ReportTable rt
inner join	@ReportDiagnosisTable rdt
on			rdt.idfsDiagnosis = rt.idfsBaseReference	
		
		
update		rt
set			rt.intTotal = rdgt.intTotal,	
			rt.intIncludingChildren = rdgt.intIncludingChildren
from		@ReportTable rt
inner join	@ReportDiagnosisGroupTable rdgt
on			rdgt.idfsDiagnosisGroup = rt.idfsBaseReference			



DECLARE @MonthTranslation NVARCHAR(300)
if @Month is not null
begin
	select		@MonthTranslation = IsNull(snt.strTextString, br.strDefault)
	from		trtBaseReference br
	left join	trtStringNameTranslation snt
	on			snt.idfsBaseReference = br.idfsBaseReference
				and snt.idfsLanguage = dbo.fnGetLanguageCode(@LangId)
				and snt.intRowStatus = 0
	where		br.idfsReferenceType = 19000132	-- Report Additional Text
				and br.intRowStatus = 0
				and br.intOrder = @Month
end
	

select		cast(@Year as nvarchar(10)) + ', '+ @MonthTranslation as strReportedPeriod,
			strDisease,
			strICD,
			case	intTotal
				when	0
					then	null
				else intTotal
			end as intTotal,
			case	intIncludingChildren
				when	0
					then	null
				else intIncludingChildren
			end as intIncludingChildren
			
from		@ReportTable
order by	intRowNumber


-- DECLARE @MonthTranslation NVARCHAR(300)
-- if @Month is not null
--	begin
--		select		@MonthTranslation = IsNull(snt.strTextString, br.strDefault)
--		from		trtBaseReference br
--		left join	trtStringNameTranslation snt
--		on			snt.idfsBaseReference = br.idfsBaseReference
--					and snt.idfsLanguage = dbo.fnGetLanguageCode(@LangId)
--					and snt.intRowStatus = 0
--		where		br.idfsReferenceType = 19000132	-- Report Additional Text
--					and br.intRowStatus = 0
--					and br.intOrder = @Month
--	end
	
	
	
--	declare @DiseaseTable as table
--	(
--		En  nvarchar(max),
--		Arm  nvarchar(max),
--		Ru  nvarchar(max),
--		ICD  nvarchar(max)
--	)

--insert into @DiseaseTable values (N'Smallpox',	N'Բնական ծաղիկ',	N'Натуральная оспа',	N'B03')
--insert into @DiseaseTable values (N'Atypical pneumonia',	N'Ատիպիկ թոքաբորբ',	N'Атипичная пневмония',	N'')
--insert into @DiseaseTable values (N'Influenza caused by a new logotype of a virus',	N'Վիրուսի նոր լոգոտիպով հարուցված գրիպ',	N'Грипп с новым логотипом',	N'')
--insert into @DiseaseTable values (N'Influenza - Avian (HPAI; H5N1)',	N'Թռչնի գրիպ',	N'Птичий грипп',	N'')
--insert into @DiseaseTable values (N'Plague ',	N'Ժանտախտ',	N'Чума',	N'A20')
--insert into @DiseaseTable values (N'Yellow fever  ',	N'Դեղին տենդ',	N'Желтая лихорадка',	N'A95, A95.0, A95.1, A95.9')
--insert into @DiseaseTable values (N'Cholera, including 0139 ',	N'Խոլերա, այդ թվում 0139',	N'Холера',	N'A.00.0, A00.1, A00.9')
--insert into @DiseaseTable values (N'Marburg fever  ',	N'Մարբուրգի տենդ',	N'Церкопитековая геморрагическая лихорадка',	N'A98.3')
--insert into @DiseaseTable values (N'Ebola Hemorrhagic Fever',	N'Էբոլի տենդ',	N'Лихорадка Эбола',	N'A98.4')
--insert into @DiseaseTable values (N'Lassa fever ',	N'Լասսի տենդ',	N'Лихорадка Ласса',	N'A96.2')
--insert into @DiseaseTable values (N'Junin fever',	N'Խունինի հեմոռագիկ տենդ',	N'Геморрагическая лихорадка Хунин',	N'A96.0')
--insert into @DiseaseTable values (N'Machupo fever  ',	N'Մաչուպոյի հեմոռագիկ տենդ',	N'Геморрагическая лихорадка Мачупо',	N'A96.1')
--insert into @DiseaseTable values (N'Glanders   ',	N'Խլնախտ',	N'Сап лошадей',	N'A24, A24.0')
--insert into @DiseaseTable values (N'Melioidosis ',	N'Մելիոիդոզ',	N'Мелиоидоз',	N'A24, A24.1, A24.2, A24.3, A24.4')
--insert into @DiseaseTable values (N'Monkeypox   ',	N'Կապիկների ծախիկ',	N'Инфекции, вызванные вирусом обезьяньей оспы',	N'B04')
--insert into @DiseaseTable values (N'Rift valley fever  ',	N'Ռիֆտ հովտի տենդ',	N'Лихорадка долины Рифт',	N'A92.4')
--insert into @DiseaseTable values (N'Leishmaniasis',	N'լեյշմանիոզ',	N'Лейшманиоз',	N'B55.0, B55.1')
--insert into @DiseaseTable values (N'Leptospirosis ',	N'Լեպտոսպիրոզ',	N'Лептоспироз',	N'A27')
--insert into @DiseaseTable values (N'Erysipeloid ',	N'Էրիզիպելոիդ',	N'Эризипелоид',	N'A26')
--insert into @DiseaseTable values (N'Typhoid fever',	N'Որովայնային տիֆ',	N'Брюшной тиф',	N'A01.0')
--insert into @DiseaseTable values (N'Paratyphoid fevers A,B,C',	N'Պարատիֆեր Ա,Բ,Ց',	N'Паратифы A, B, C',	N'A01.1, A01.2,A01.3')
--insert into @DiseaseTable values (N'Typhoid fever and paratyphoids carrier',	N'Որովայնային տիֆի հարուցիչների վարակակրություն',	N'Носительство возбудителя брюшного тифа',	N'Z22.0')
--insert into @DiseaseTable values (N'Other Salmonella infections',	N'Այլ սալմոնելոզային վարակներ',	N'Другие сальмонеллёзные инфекции',	N'A02')
--insert into @DiseaseTable values (N'Shigellosis ',	N'Մանրէային դիզենտերիա (շիգելոզ)',	N'Бактериальная дизентерия (шигелёз',	N'A03, A03.0-03.3')
--insert into @DiseaseTable values (N'Yersiniosises',	N'Յերսինիոզներ',	N'Йерсиниоз',	N'A04.6')
--insert into @DiseaseTable values (N'Acute intestinal infection with identified aetilogy including bacterial or viral agent, food toxic infections',	N'հաստատված հարուցիչներով հարուցված սուր աղիքային վարակիչ հիվանդություններ, այդ թվում բակտերային կամ վիրուսային պատճառներով, սննդային տոքսիկոինֆեկցիաներ',	N'Энтериты, колиты, гастроэнтериты, а также пищевые токсикоинфекции установленной этиологии',	N'A05.0-A05.8')
--insert into @DiseaseTable values (N'Acute intestinal infection with unidentified aetiology',	N'Չհաստատված հարուցիչներով հարուցված սուր աղիքային վարակիչ հիվանդություններ, անհայտ ծագումնաբանությամբ սննդային տոքսիկոինֆեկցիաներ',	N'Энтериты, колиты,гастроэнтериты, а также пищевые токсикоинфекции неустановленной этиологии',	N'A05.9')
--insert into @DiseaseTable values (N'Tularemia  ',	N'Տուլյարեմիա',	N'Туляремия',	N'A21')
--insert into @DiseaseTable values (N'Anthrax ',	N'Սիբիրախտ',	N'Сибирская язва',	N'A22')
--insert into @DiseaseTable values (N'Brucellosis ',	N'Բրուցելոզ',	N'Бруцеллез',	N'A23, A23.0, A23.1, A23.2, A23.3, A23.9')
--insert into @DiseaseTable values (N'Diphtheria  ',	N'Դիֆթերիա',	N'Дифтерия',	N'A36')
--insert into @DiseaseTable values (N'Toxigenic strains causing diphtheria carrier',	N'Դիֆթերիայի հարուցիչների վարակակրություն',	N'Носительство возбудителя дифтерии',	N'Z22.2')
--insert into @DiseaseTable values (N'Pertussis',	N'Կապույտ հազ',	N'Коклюш',	N'A37')
--insert into @DiseaseTable values (N'Scarlet fever  ',	N'Քութեշ',	N'Скарлатина',	N'A38')
--insert into @DiseaseTable values (N'Meningococcal infections',	N'Մենինգակոկային վարակ',	N'Менингококковая инфекция',	N'A39')
--insert into @DiseaseTable values (N'Tetanus ',	N'Փայտացում',	N'Столбняк',	N'')
--insert into @DiseaseTable values (N'AIDS',	N'ՁԻԱՀ',	N'СПИД',	N'B20-B24')
--insert into @DiseaseTable values (N'HIV',	N'ՄԻԱՎ',	N'ВИЧ',	N'Z21')
--insert into @DiseaseTable values (N'Acute poliomyelitis/Acute flaccid paralysis',	N'Սուր պոլիոմիելիտ/Սուր թորշոմած կաթվածահարություն',	N'Острый полиомелит/Острый вялый паралич',	N'A80, G61.0')
--insert into @DiseaseTable values (N'Measles',	N'Կարմրուկ',	N'Корь',	N'B05')
--insert into @DiseaseTable values (N'Rubella ',	N'Կարմրախտ',	N'Краснуха',	N'B06')
--insert into @DiseaseTable values (N'Congenital rubella syndrome',	N'Բնածին կարմրախտային համախտանիշ',	N'Синдром врожденной краснухи',	N'P35.0')
--insert into @DiseaseTable values (N'Tick-borne viral encephalitis',	N'Տզային էնցեֆալիտ',	N'Клещевой энцефалит',	N'A84')
--insert into @DiseaseTable values (N'Crimean-Congo, Omsk, West Nile and other hemorrhagic fevers,  hemorrhagic fever with renal syndrome, other viral hemorrhagic fevers ',	N'Ղրիմ-Կոնգոյան, Օմսկի, Արևմտյան Նեղոսի և այլ հեմոռագիկ տենդեր. հեմոռագիկ տենդ երիկամային համախտանիշով, այլ վիրուսային հեմոռագիկ տենդեր)',	N'Лихорадка Крым-Конго, Омская геморрагическая лихорадка, Гемморагическая лихорадка восточного Нила, Лихорадка Эбола, Геморрагическая лихорадка с почечным синдромом, Другие геморрагические лихорадки',	N'A98.0, A98.1, A98.4, A98.5')
--insert into @DiseaseTable values (N'Viral hepatitis, including Hepatitis A and Hepatitis B  ',	N'Վիրուսային հեպատիտ',	N'Вирусный гепатит, включая гепатит А и B.',	N'B15-B19')
--insert into @DiseaseTable values (N'Hepatatis B and C carrier',	N'Վիրուսային հեպատիտ Բ և Ց վարակակրություն',	N'Носительство возбудителя вирусного гепатита',	N'Z22.5')
--insert into @DiseaseTable values (N'Rabies  ',	N'Կատաղություն',	N'Бешенство',	N'A82')
--insert into @DiseaseTable values (N'Ornithosis ',	N'Օրնիթոզ',	N'Орнитоз',	N'')
--insert into @DiseaseTable values (N'Infectious mononucleosis  ',	N'Վարակային մոնոնուկլեոզ',	N'Инфекционный мононуклеоз',	N'B27')
--insert into @DiseaseTable values (N'Mumps',	N'Համաճարակային պարոտիտ',	N'Эпидемический паротит',	N'B26')
--insert into @DiseaseTable values (N'Riccetsia',	N'Ռիկեցիոզներ',	N'Риккетсиозы',	N'A75-A79')
--insert into @DiseaseTable values (N'Epidemic typhus',	N'Համաճարակային բծավոր տիֆ',	N'Эпидемический сыпной тиф',	N'A75.0')
--insert into @DiseaseTable values (N'Brill''s disease',	N'Բրիլլի հիվանդություն',	N'Болезнь Брилля',	N'A75.1')
--insert into @DiseaseTable values (N'Q fever',	N'Կու տենդ',	N'Ку-лихорадка',	N'A78')
--insert into @DiseaseTable values (N'Malaria',	N'Մալարիայի մակաբուծակրություն',	N'Малярия первично диагностированная',	N'B50-B54')
--insert into @DiseaseTable values (N'Malaria carrier',	N'Մալարիայի մակաբուծակրություն',	N'Носительство возбудителя малярии',	N'Z22.8')
--insert into @DiseaseTable values (N'Leptospirosis',	N'Լեպտոսպիրոզ',	N'Лептоспироз',	N'A27')
--insert into @DiseaseTable values (N'Influenza  ',	N'գրիպ',	N'Грипп',	N'J10-J11')
--insert into @DiseaseTable values (N'Legionnaires'' disease',	N'Լեգիոնելիոզ',	N'Болезнь легионеров',	N'A48.1')
--insert into @DiseaseTable values (N'Tuberculosis',	N'Տուբերկուլոզ',	N'Туберкулез',	N'A15 – A19')
--insert into @DiseaseTable values (N'Amoebiasis, lambliasis,  balantidiasis',	N'Ամեոբիազ, Լյամբլոզ, Բալանտիդիազ',	N'Амеобиаз, жиардиаз, балантидиаз',	N'A06, A07.1, A07.0')
--insert into @DiseaseTable values (N'Helminthiases (Trematodosis; Echinococcosis; Taeniosis;  Teniarinhosis; Diphyllobothriasis; Hymenolepiasis; Ancylostomidos; Ascariasis;  Strongiloidosis; Trichocephalosis; Enterobiasis) ',	N'Հելմինթոզներ (Տրեմատոդոզ, Էխինոկոկոզ, Տենիոզ, Տենիարինխոզ, Դիֆիլոբոտրիոզ, Հիմենոլեպիդոզ, Անկիլոստոմիդոզ, Ասկարիդոզ, Ստրոնգիլոիդոզ, Տրիխոցեֆալոզ, էնտերոբիոզ)',	N'Гельминтозы (Трематодоз, Эхинококкоз, Тениоз, Тениаринхоз, Дифиллоботриоз, Гименолепидоз, Анкилостидоз, Аскаридоз, Стронгилоидоз, Трихоцефалез, Энтеробиоз)',	N'B67, B68, B68.1, B70.0, B71.0, B77, B78, B79, B80')
--insert into @DiseaseTable values (N'Pneumocytosis,  Cryptosporidiosis,  Toxoplasmosis, Campylobacteriosis  ',	N'Պնևմոցիստոզ, Կրիպտոսպորիդիոզ, Տոքսոպլազմոզ, Կամպիլոբակտերիոզ',	N'Пневмоцистоз, Криптоспоридиоз, Токсоплазмоз, Кампилобактериоз',	N'B59, A07.2, B58')
--insert into @DiseaseTable values (N'Pneumonia',	N'Թոքաբորբ',	N'Пневмония',	N'J10 – J18')
--insert into @DiseaseTable values (N'Cytomegaloviral disease',	N'Ցիտոմեգալովիրուսային հիվանդություն',	N'Цитомегаловирусная болезнь',	N'B25')
--insert into @DiseaseTable values (N'Herpesviral infections',	N'Վարակներ` հարուցված հերպես վիրուսով',	N'Инфекции, вызванные вирусом герпеса',	N'B00')
--insert into @DiseaseTable values (N'Pediculosis',	N'Ոջլոտություն',	N'Педикулёз',	N'B85')
--insert into @DiseaseTable values (N'Toxic sepsis diseases in newborn infants',	N'Նորածինների մանրէային սեպսիս',	N'Бактериальный сепсис новорожденного',	N'P36')
--insert into @DiseaseTable values (N'Acute intestinal infection with identified aetilogy including bacterial or viral agent, food toxic infections',	N'հաստատված հարուցիչներով հարուցված սուր աղիքային վարակիչ հիվանդություններ, այդ թվում բակտերային կամ վիրուսային պատճառներով, սննդային տոքսիկոինֆեկցիաներ',	N'Энтериты, колиты, гастроэнтериты, а также пищевые токсикоинфекции установленной этиологии',	N'A05.0-A05.8')
--insert into @DiseaseTable values (N'Prion diseases',	N'Պրիոնային հիվանդություններ',	N'Прионные заболевания',	N'')

--	select 
--		cast(@Year as nvarchar(10)) + ', '+@MonthTranslation as strReportedPeriod,
--		case 
--		 when @LangID = 'ru' then Ru
--		 when @LangID = 'hy' then Arm
--		 else En
--		end as strDisease,
--		ICD as strICD,
--	    cast(3* RAND(CHECKSUM(NEWID())) as int) as intTotal,
--	    cast(2* RAND(CHECKSUM(NEWID())) as int) as intIncludingChildren
	    
	    
--	 from @DiseaseTable


