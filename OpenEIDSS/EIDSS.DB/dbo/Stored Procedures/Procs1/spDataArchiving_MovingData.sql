
CREATE PROCEDURE [dbo].[spDataArchiving_MovingData](
	@TargetServer NVARCHAR(100)
	, @TargetDataBase NVARCHAR(100)
	, @ArchiveDate DATETIME
	)
AS

SET XACT_ABORT ON
SET NOCOUNT ON




--BEGIN TRAN


--собираем все кейсы в одну временную таблицу для удобства использования
CREATE TABLE ##tCase(IDCase BIGINT, idfOutbreak BIGINT, datModificationForArchiveDate DATETIME)

CREATE NONCLUSTERED INDEX IX_IDCase_##tCase
    ON ##tCase (IDCase)

CREATE NONCLUSTERED INDEX IX_idfOutbreak_##tCase
    ON ##tCase (idfOutbreak)

 

INSERT INTO ##tCase
SELECT
	idfHumanCase
	, idfOutbreak
	, datModificationForArchiveDate
FROM tlbHumanCase

INSERT INTO ##tCase
SELECT
	idfVetCase
	, idfOutbreak
	, datModificationForArchiveDate
FROM tlbVetCase




DECLARE @CaseForArchiveCount INT
DECLARE @MaxCaseForArchiveCount INT = 1000

/*--вычисляем новую дату архивации, отталкиваясь от заданного максимального
--количества кейсов до заданной даты архивации
SELECT
	@CaseForArchiveCount = COUNT(*)
FROM ##tCase tc
WHERE datModificationForArchiveDate <= @ArchiveDate

	
WHILE @CaseForArchiveCount > ISNULL(@MaxCaseForArchiveCount, 100000)
BEGIN
	SET @ArchiveDate = /*CAST(CONVERT(CHAR(6),*/DATEADD(mm, -1, @ArchiveDate)/*,112)+'01' AS DATETIME)*/
	
	SELECT
		@CaseForArchiveCount = COUNT(*)
	FROM ##tCase tc
	WHERE datModificationForArchiveDate <= @ArchiveDate
	
	IF @CaseForArchiveCount = 0
	BEGIN
		SET @ArchiveDate = DATEADD(mm, 1, @ArchiveDate)
		BREAK
	END
END*/



/*---------------------------------------------------------------------*/
/*Выбираем необходимые записи определяющих таблиц                      */
/*---------------------------------------------------------------------*/

--DECLARE @tempOutbreak AS TABLE (id BIGINT)
--DECLARE @tempCase AS TABLE (id BIGINT)
--DECLARE @tempVectorSurveillanceSession AS TABLE (id BIGINT)
--DECLARE @tempCampaign AS TABLE (id BIGINT)
--DECLARE @tempMonitoringSession AS TABLE (id BIGINT)
--DECLARE @tempAggrCase AS TABLE (id BIGINT)
--DECLARE @tempSecurityAudit AS TABLE (id BIGINT)

DECLARE @TablesForArchiving AS TABLE (idTable INT, nameTable NVARCHAR(255), OrderForDelete INT)
INSERT INTO @TablesForArchiving
	(idTable, nameTable, OrderForDelete)
VALUES
	(-4, '##tCase', -1)
	, (50, 'tflAggrCaseFiltered', 1)
	, (6, 'tlbAggrCase', 2)
	, (43, 'tlbActivityParameters', 3)
	, (26, 'tlbAntimicrobialTherapy', 4)
	, (13, 'tlbCampaignToDiagnosis', 5)
	, (27, 'tlbChangeDiagnosisHistory', 6)
	, (28, 'tlbContactedCasePerson', 7)
	, (16, 'tlbMonitoringSessionAction', 8)
	, (17, 'tlbMonitoringSessionToDiagnosis', 9)
	, (19, 'tlbMonitoringSessionSummaryDiagnosis', 10)
	, (20, 'tlbMonitoringSessionSummarySample', 11)
	, (18, 'tlbMonitoringSessionSummary', 12)
	, (10, 'tlbOutbreakNote', 13)
	, (32, 'tlbPensideTest', 14)
	, (40, 'tlbTestValidation', 15)
	, (34, 'tlbTransferOutMaterial', 17)
	, (62, 'tflTransferOutFiltered', 18)
	, (33, 'tlbTransferOUT', 19)
	, (24, 'tlbVaccination', 20)
	, (12, 'tlbVectorSurveillanceSessionSummaryDiagnosis', 21)
	, (11, 'tlbVectorSurveillanceSessionSummary', 22)
	, (21, 'tlbVetCaseLog', 23)
	, (-1, 'tlbVetCaseDisplayDiagnosis', 24) --не переносим, поскольку заполняется триггером
	, (39, 'tstLocalSamplesTestsPreferences', 25)
	, (41, 'tlbTestAmendmentHistory', 26)
	, (38, 'tlbTesting', 27)
	, (30, 'tlbMaterial', 28)
	, (29, 'tlbAnimal', 29)
	, (51, 'tflBatchTestFiltered', 30)
	, (37, 'tlbBatchTest', 31)
	, (23, 'tlbSpecies', 32)
	, (22, 'tlbHerd', 33)
	, (64, 'tflVetCaseFiltered', 34)
	, (45, 'tlbVetCase', 35)	
	, (54, 'tflFarmFiltered', 36)
	, (15, 'tlbFarm', 37)
	, (63, 'tflVectorSurveillanceSessionFiltered', 38)
	, (3, 'tlbVectorSurveillanceSession', 42)
	, (56, 'tflHumanCaseFiltered', 40)
	, (46, 'tlbHumanCase', 41)
	, (25, 'tlbVector', 39)
	, (57, 'tflHumanFiltered', 43)
	, (14, 'tlbHuman', 44)
	, (60, 'tflOutbreakFiltered', 45)
	, (1, 'tlbOutbreak', 46)
	, (58, 'tflMonitoringSessionFiltered', 47)
	, (5, 'tlbMonitoringSession', 48)
	, (4, 'tlbCampaign', 49)
	, (-2, 'tlbGeoLocationTranslation', 50) --не переносим, поскольку заполняется триггером
	, (55, 'tflGeoLocationFiltered', 51)
	, (8, 'tlbGeoLocation', 52)
	, (59, 'tflObservationFiltered', 53)
	, (42, 'tlbObservation', 54)
	, (-3, 'tstSecurityAudit', 55) --не переносим
	, (49, 'tlbBasicSyndromicSurveillanceAggregateDetail', 56)
	, (52, 'tflBasicSyndromicSurveillanceAggregateHeaderFiltered', 57)
	, (48, 'tlbBasicSyndromicSurveillanceAggregateHeader', 58)
	, (53, 'tflBasicSyndromicSurveillanceFiltered', 59)
	, (47, 'tlbBasicSyndromicSurveillance', 60)

--DECLARE @RecordsForArchiving AS TABLE (idTable BIGINT, idRow1 BIGINT, idRow2 BIGINT NULL)

CREATE TABLE ##RecordsForArchiving(idTable BIGINT, idRow1 BIGINT, idRow2 BIGINT NULL)
CREATE NONCLUSTERED INDEX IX_idTable_##RecordsForArchiving ON ##RecordsForArchiving (idTable)
CREATE NONCLUSTERED INDEX IX_idRow1_##RecordsForArchiving ON ##RecordsForArchiving (idRow1)
CREATE NONCLUSTERED INDEX IX_idRow1_idRow2_##RecordsForArchiving ON ##RecordsForArchiving (idRow1, idRow2)


PRINT''
PRINT '-------------------------------------------------------------------------'
PRINT '------------ tlbOutbreak ------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT ''

--0.
-- выбираем записи из tlbOutbreak по дате модификации
INSERT INTO ##RecordsForArchiving
SELECT
	AllTables.idTable
	, idfOutbreak
	, NULL
FROM tlbOutbreak tout
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbOutbreak'
WHERE datModificationForArchiveDate <= @ArchiveDate

PRINT 'tlbOutbreak (select): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

--1.
-- отсекаем записи из tlbOutbreak по дате модификации из tlbHumanCase или tlbVetCase
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbOutbreak tout ON
	tout.idfOutbreak = AllRecords.idRow1
JOIN ##tCase tc ON
	tc.idfOutbreak = tout.idfOutbreak
	AND tc.datModificationForArchiveDate > @ArchiveDate
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbOutbreak'

PRINT '@tempOutbreak (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

--2.			
-- отсекаем записи из tlbOutbreak по дате модификации из tlbVectorSurveillanceSession
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbOutbreak tout ON
	tout.idfOutbreak = AllRecords.idRow1
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfOutbreak = tout.idfOutbreak
	AND tvss.datModificationForArchiveDate > @ArchiveDate
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbOutbreak'

PRINT '@tempOutbreak (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

--3.
-- отсекаем записи из tlbOutbreak, которые связаны через tlbHumanCase или tlbVetCase с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из ##tCase
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbOutbreak tout ON
	tout.idfOutbreak = AllRecords.idRow1
JOIN ##tCase tc ON
	tc.idfOutbreak = tout.idfOutbreak
JOIN tlbMaterial tm ON
	(tm.idfHumanCase = tc.IDCase OR tm.idfVetCase = tc.IDCase)
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tt.idfBatchTest
		FROM ##tCase tc
		JOIN tlbMaterial tm ON
			(tm.idfHumanCase = tc.IDCase OR tm.idfVetCase = tc.IDCase)
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest
		WHERE tc.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbOutbreak'

PRINT '@tempOutbreak (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''
			
--4.			
-- отсекаем записи из tlbOutbreak, которые связаны через ##tCase с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из tlbVectorSurveillanceSession
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbOutbreak tout ON
	tout.idfOutbreak = AllRecords.idRow1
JOIN ##tCase tc ON
	tc.idfOutbreak = tout.idfOutbreak
JOIN tlbMaterial tm ON
	(tm.idfHumanCase = tc.IDCase OR tm.idfVetCase = tc.IDCase)
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tbt.idfBatchTest
		FROM tlbVectorSurveillanceSession tvss
		JOIN tlbMaterial tm ON
			tm.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest	
		WHERE tvss.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbOutbreak'
                        --	
PRINT '@tempOutbreak (delete): ' + CAST(@@rowcount AS VARCHAR(20))	
PRINT ''
						
--5.	
-- отсекаем записи из tlbOutbreak, которые связаны через ##tCase с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из tlbMonitoringSession
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbOutbreak tout ON
	tout.idfOutbreak = AllRecords.idRow1
JOIN ##tCase tc ON
	tc.idfOutbreak = tout.idfOutbreak
JOIN tlbMaterial tm ON
	(tm.idfHumanCase = tc.IDCase OR tm.idfVetCase = tc.IDCase)
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tbt.idfBatchTest
		FROM tlbMonitoringSession tms
		JOIN tlbMaterial tm ON
			tm.idfMonitoringSession = tms.idfMonitoringSession
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest
		WHERE tms.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbOutbreak'

PRINT '@tempOutbreak (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

--6.
-- отсекаем записи из tlbOutbreak, которые связаны через ##tCase с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из tlbCampaign
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbOutbreak tout ON
	tout.idfOutbreak = AllRecords.idRow1
JOIN ##tCase tc ON
	tc.idfOutbreak = tout.idfOutbreak
JOIN tlbMaterial tm ON
	(tm.idfHumanCase = tc.IDCase OR tm.idfVetCase = tc.IDCase)
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tbt.idfBatchTest
		FROM tlbCampaign tc
		JOIN tlbMonitoringSession tms ON
			tms.idfCampaign = tc.idfCampaign
		JOIN tlbMaterial tm ON
			tm.idfMonitoringSession = tms.idfMonitoringSession
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest
		WHERE tc.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbOutbreak'
	
PRINT '@tempOutbreak (delete): ' + CAST(@@rowcount AS VARCHAR(20))	
PRINT ''
		
--7.	
-- отсекаем записи из tlbOutbreak, которые связаны через tlbVectorSurveillanceSession с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из ##tCase
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbOutbreak tout ON
	tout.idfOutbreak = AllRecords.idRow1
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfOutbreak = tout.idfOutbreak
JOIN tlbMaterial tm ON
	tm.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tt.idfBatchTest
		FROM ##tCase tc
		JOIN tlbMaterial tm ON
			(tm.idfHumanCase = tc.IDCase OR tm.idfVetCase = tc.IDCase)
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest
		WHERE tc.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbOutbreak'
	
PRINT '@tempOutbreak (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''
	
--8.	
-- отсекаем записи из tlbOutbreak, которые связаны через tlbVectorSurveillanceSession с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из tlbVectorSurveillanceSession
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbOutbreak tout ON
	tout.idfOutbreak = AllRecords.idRow1
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfOutbreak = tout.idfOutbreak
JOIN tlbMaterial tm ON
	tm.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tbt.idfBatchTest
		FROM tlbVectorSurveillanceSession tvss
		JOIN tlbMaterial tm ON
			tm.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest	
		WHERE tvss.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbOutbreak'
	
PRINT '@tempOutbreak (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''
	
--9.	
-- отсекаем записи из tlbOutbreak, которые связаны через tlbVectorSurveillanceSession с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из tlbMonitoringSession
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbOutbreak tout ON
	tout.idfOutbreak = AllRecords.idRow1
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfOutbreak = tout.idfOutbreak
JOIN tlbMaterial tm ON
	tm.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tbt.idfBatchTest
		FROM tlbMonitoringSession tms
		JOIN tlbMaterial tm ON
			tm.idfMonitoringSession = tms.idfMonitoringSession
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest
		WHERE tms.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbOutbreak'
	
PRINT '@tempOutbreak (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

--10.	
-- отсекаем записи из tlbOutbreak, которые связаны через tlbVectorSurveillanceSession с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из tlbCampaign
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbOutbreak tout ON
	tout.idfOutbreak = AllRecords.idRow1
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfOutbreak = tout.idfOutbreak
JOIN tlbMaterial tm ON
	tm.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
				SELECT
					tbt.idfBatchTest
				FROM tlbCampaign tc
				JOIN tlbMonitoringSession tms ON
					tms.idfCampaign = tc.idfCampaign
				JOIN tlbMaterial tm ON
					tm.idfMonitoringSession = tms.idfMonitoringSession
				JOIN tlbTesting tt ON
					tt.idfMaterial = tm.idfMaterial
				JOIN tlbBatchTest tbt ON
					tbt.idfBatchTest = tt.idfBatchTest
				WHERE tc.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbOutbreak'
	
PRINT '@tempOutbreak (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''	

--11.
-- выбираем записи из ##tCase, связанные с выбранными записями tlbOutbreak
INSERT INTO ##RecordsForArchiving
SELECT
	AllTables.idTable
	, IDCase
	, NULL
FROM ##tCase tc
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = '##tCase'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tc.idfOutbreak
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbOutbreak'

PRINT 'tlbHumanCase or tlbVetCase (select): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

--12.
-- ищем кейсы с "неподходящими родственниками"
DECLARE @temp_HC AS TABLE (id BIGINT, prz BIT)

INSERT INTO @temp_HC
SELECT DISTINCT
	AllRecords.idRow1
	, NULL
FROM ##RecordsForArchiving AllRecords
LEFT JOIN tlbHumanCase thc1 ON
	thc1.idfHumanCase = AllRecords.idRow1
	AND thc1.idfDeduplicationResultCase IS NOT NULL
LEFT JOIN tlbHumanCase thc2 ON
	thc2.idfDeduplicationResultCase = AllRecords.idRow1
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = '##tCase'
WHERE COALESCE(thc1.idfHumanCase, thc2.idfHumanCase, 0) > 0


DECLARE @temp_id BIGINT


DECLARE _HC CURSOR FOR
SELECT 
	t.id
FROM @temp_HC t
OPEN _HC

FETCH NEXT FROM _HC INTO @temp_id

WHILE @@FETCH_STATUS = 0
	BEGIN


DECLARE @tt AS TABLE (id BIGINT, ded_id BIGINT)
DELETE FROM @tt

;
WITH 
   tree (id, ded_id)
   AS (
		SELECT
			t1.idfHumanCase
			, t1.idfDeduplicationResultCase
		FROM tlbHumanCase t1
		WHERE idfHumanCase = @temp_id
		UNION ALL
		SELECT
			t2.idfHumanCase
			, t2.idfDeduplicationResultCase
		FROM tlbHumanCase t2
		JOIN tree t ON 
			t.ded_id = t2.idfHumanCase
			AND ISNULL(t.id, 0) <> t2.idfDeduplicationResultCase
   )
   
INSERT INTO @tt
SELECT * FROM tree


;
WITH 
   tree2 (id, ded_id) 
   AS (
		SELECT
			t1.idfHumanCase
			, t1.idfDeduplicationResultCase
		FROM tlbHumanCase t1
		WHERE idfHumanCase = @temp_id
		UNION ALL
		SELECT
			t2.idfHumanCase
			, t2.idfDeduplicationResultCase
		FROM tlbHumanCase t2
		JOIN tree2 t ON 
			t.id = t2.idfDeduplicationResultCase
			AND ISNULL(t.ded_id, 0) <> t2.idfHumanCase
   )
   
INSERT INTO @tt
SELECT tree2.* FROM tree2
LEFT JOIN @tt tt ON
	tt.id = tree2.id
WHERE tt.id IS NULL



IF (
		SELECT 
			COUNT(*) 
		FROM @tt t 
		LEFT JOIN ##RecordsForArchiving AllRecords
			JOIN @TablesForArchiving AllTables ON
				AllTables.idTable = AllRecords.idTable
				AND AllTables.nameTable = '##tCase' 
			ON AllRecords.idRow1 = t.id
		WHERE AllRecords.idRow1 IS NULL
	) = 0
BEGIN

	DECLARE @tt2 AS TABLE (id BIGINT, ded_id BIGINT)
	DELETE FROM @tt2
	
	INSERT INTO @tt2
	SELECT * FROM @tt t

	DECLARE @id BIGINT

	DECLARE _T CURSOR FOR
	SELECT 
		t.id
	FROM @tt t
	OPEN _T

	FETCH NEXT FROM _T INTO @id

	WHILE @@FETCH_STATUS = 0
		BEGIN
		
				
		;
		WITH 
		   tree (id, ded_id) 
		   AS (
				SELECT
					t1.idfHumanCase
					, t1.idfDeduplicationResultCase
				FROM tlbHumanCase t1
				WHERE idfHumanCase = @id
				UNION ALL
				SELECT
					t2.idfHumanCase
					, t2.idfDeduplicationResultCase
				FROM tlbHumanCase t2
				JOIN tree t ON 
					t.ded_id = t2.idfHumanCase
					AND ISNULL(t.id, 0) <> t2.idfDeduplicationResultCase
		   )
		   
		INSERT INTO @tt2
		SELECT tree.* FROM tree
		LEFT JOIN @tt2 tt ON
			tt.id = tree.id
		WHERE tt.id IS NULL
		
			;
		WITH 
		   tree2 (id, ded_id) 
		   AS (
				SELECT
					t1.idfHumanCase
					, t1.idfDeduplicationResultCase
				FROM tlbHumanCase t1
				WHERE idfHumanCase = @id
				UNION ALL
				SELECT
					t2.idfHumanCase
					, t2.idfDeduplicationResultCase
				FROM tlbHumanCase t2
				JOIN tree2 t ON 
					t.id = t2.idfDeduplicationResultCase
					AND ISNULL(t.ded_id, 0) <> t2.idfHumanCase
		   )
		   
		INSERT INTO @tt2
		SELECT tree2.* FROM tree2
		LEFT JOIN @tt2 tt ON
			tt.id = tree2.id
		WHERE tt.id IS NULL
		
			
			
			
		FETCH NEXT FROM _T INTO @id
		
		END
		
	CLOSE _T
	DEALLOCATE _T
	
IF (
		SELECT 
			COUNT(*) 
		FROM @tt t 
		LEFT JOIN ##RecordsForArchiving AllRecords
			JOIN @TablesForArchiving AllTables ON
				AllTables.idTable = AllRecords.idTable
				AND AllTables.nameTable = '##tCase'
			ON AllRecords.idRow1 = t.id 
		WHERE AllRecords.idRow1 IS NULL
	) > 0
	UPDATE @temp_HC
	SET	prz = 1
	WHERE id = @temp_id

END
ELSE
	UPDATE @temp_HC
	SET	prz = 1
	WHERE id = @temp_id

	FETCH NEXT FROM _HC INTO @temp_id
	
	END
	
CLOSE _HC
DEALLOCATE _HC

--13.
-- отсекаем записи tlbOutbreak, связанные с кейсами, имеющими "неподходящих родственников"
DELETE AllRecords
FROM ##RecordsForArchiving AllRecords	
JOIN (
		SELECT 
			tc.idfOutbreak
		FROM @temp_HC th
		JOIN ##tCase tc ON
			tc.IDCase = th.id
		WHERE th.prz IS NOT NULL
) x ON
	x.idfOutbreak = idRow1
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbOutbreak'
	
PRINT '@tempOutbreak (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

--14.
-- отсекаем записи кейсов, имеющих "неподходящих родственников"
DELETE AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN (
		SELECT 
			th.id
		FROM @temp_HC th
		WHERE th.prz IS NOT NULL
) x ON
	x.id = idRow1
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = '##tCase'

PRINT '@tempCase (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''		

--15.
-- выбираем записи из tlbVectorSurveillanceSession, связанные с выбранными записями tlbOutbreak
INSERT INTO ##RecordsForArchiving
SELECT
	AllTables.idTable
	, tvss.idfVectorSurveillanceSession
	, NULL
FROM tlbVectorSurveillanceSession tvss
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbVectorSurveillanceSession'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvss.idfOutbreak
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbOutbreak'

PRINT 'tlbVectorSurveillanceSession (select): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''	

		
PRINT'-------------------------------------------------------------------------'
PRINT'-------------------------------------------------------------------------'
PRINT'-------------------------------------------------------------------------'
PRINT''




PRINT'-------------------------------------------------------------------------'
PRINT'------------ tlbHumanCase and tlbVetCase --------------------------------'
PRINT'-------------------------------------------------------------------------'
PRINT ''

--0.
-- выбираем записи из ##tCase по дате модификации
INSERT INTO ##RecordsForArchiving
SELECT TOP (@MaxCaseForArchiveCount)
	AllTables.idTable
	, IDCase
	, NULL
FROM ##tCase tc
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = '##tCase'
WHERE idfOutbreak IS NULL
	AND datModificationForArchiveDate <= @ArchiveDate
ORDER BY datModificationForArchiveDate

PRINT '##tCase (select): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

--1.
-- отсекаем записи из ##tCase, которые связаны с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из ##tCase
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN ##tCase tc ON
	tc.IDCase = AllRecords.idRow1	
JOIN tlbMaterial tm ON
	(tm.idfHumanCase = tc.IDCase OR tm.idfVetCase = tc.IDCase)
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tt.idfBatchTest
		FROM ##tCase tc
		JOIN tlbMaterial tm ON
			(tm.idfHumanCase = tc.IDCase OR tm.idfVetCase = tc.IDCase)
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest
		WHERE tc.idfOutbreak IS NULL
			AND tc.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = '##tCase'
WHERE tc.idfOutbreak IS NULL
	
PRINT '@tempCase (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''
			
--2.			
-- отсекаем записи из ##tCase, которые связаны с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из tlbVectorSurveillanceSession

DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN ##tCase tc ON
	tc.IDCase = AllRecords.idRow1	
JOIN tlbMaterial tm ON
	(tm.idfHumanCase = tc.IDCase OR tm.idfVetCase = tc.IDCase)
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tbt.idfBatchTest
		FROM tlbVectorSurveillanceSession tvss
		JOIN tlbMaterial tm ON
			tm.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest	
		WHERE tvss.idfOutbreak IS NULL
			AND tvss.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = '##tCase'
WHERE tc.idfOutbreak IS NULL
	
PRINT '@tempCase (delete): ' + CAST(@@rowcount AS VARCHAR(20))	
PRINT ''
						
--3.	
-- отсекаем записи из ##tCase, которые связаны с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из tlbMonitoringSession
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN ##tCase tc ON
	tc.IDCase = AllRecords.idRow1	
JOIN tlbMaterial tm ON
	(tm.idfHumanCase = tc.IDCase OR tm.idfVetCase = tc.IDCase)
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
				SELECT
					tbt.idfBatchTest
				FROM tlbMonitoringSession tms
				JOIN tlbMaterial tm ON
					tm.idfMonitoringSession = tms.idfMonitoringSession
				JOIN tlbTesting tt ON
					tt.idfMaterial = tm.idfMaterial
				JOIN tlbBatchTest tbt ON
					tbt.idfBatchTest = tt.idfBatchTest
				WHERE tms.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = '##tCase'
WHERE tc.idfOutbreak IS NULL
	
PRINT '@tempCase (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

--4.
-- отсекаем записи из ##tCase, которые связаны с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из tlbCampaign
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN ##tCase tc ON
	tc.IDCase = AllRecords.idRow1	
JOIN tlbMaterial tm ON
	(tm.idfHumanCase = tc.IDCase OR tm.idfVetCase = tc.IDCase)
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tbt.idfBatchTest
		FROM tlbCampaign tc
		JOIN tlbMonitoringSession tms ON
			tms.idfCampaign = tc.idfCampaign
		JOIN tlbMaterial tm ON
			tm.idfMonitoringSession = tms.idfMonitoringSession
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest
		WHERE tc.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = '##tCase'
WHERE tc.idfOutbreak IS NULL
	
PRINT '@tempCase (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''	
		
PRINT'-------------------------------------------------------------------------'
PRINT'-------------------------------------------------------------------------'
PRINT'-------------------------------------------------------------------------'
PRINT''



PRINT ''
PRINT '-------------------------------------------------------------------------'
PRINT '------------ idfDeduplicationResultCase ---------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT ''

--0.
-- ищем кейсы с "неподходящими родственниками"

UPDATE @temp_HC SET prz = 1

INSERT INTO @temp_HC
SELECT DISTINCT
	AllRecords.idRow1
	, NULL
FROM ##RecordsForArchiving AllRecords
LEFT JOIN tlbHumanCase thc1 ON
	thc1.idfHumanCase = AllRecords.idRow1
	AND thc1.idfDeduplicationResultCase IS NOT NULL
LEFT JOIN tlbHumanCase thc2 ON
	thc2.idfDeduplicationResultCase = AllRecords.idRow1
LEFT JOIN @temp_HC th ON
	th.id = AllRecords.idRow1
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = '##tCase'
WHERE COALESCE(thc1.idfHumanCase, thc2.idfHumanCase, 0) > 0
	AND th.id IS NULL

DELETE FROM @temp_HC WHERE prz = 1



DECLARE _HC CURSOR FOR
SELECT 
	t.id
FROM @temp_HC t
OPEN _HC

FETCH NEXT FROM _HC INTO @temp_id

WHILE @@FETCH_STATUS = 0
	BEGIN


DELETE FROM @tt

;
WITH 
   tree (id, ded_id)
   AS (
		SELECT
			t1.idfHumanCase
			, t1.idfDeduplicationResultCase
		FROM tlbHumanCase t1
		WHERE idfHumanCase = @temp_id
		UNION ALL
		SELECT
			t2.idfHumanCase
			, t2.idfDeduplicationResultCase
		FROM tlbHumanCase t2
		JOIN tree t ON 
			t.ded_id = t2.idfHumanCase
			AND ISNULL(t.id, 0) <> t2.idfDeduplicationResultCase
   )
   
INSERT INTO @tt
SELECT * FROM tree


;
WITH 
   tree2 (id, ded_id) 
   AS (
		SELECT
			t1.idfHumanCase
			, t1.idfDeduplicationResultCase
		FROM tlbHumanCase t1
		WHERE idfHumanCase = @temp_id
		UNION ALL
		SELECT
			t2.idfHumanCase
			, t2.idfDeduplicationResultCase
		FROM tlbHumanCase t2
		JOIN tree2 t ON 
			t.id = t2.idfDeduplicationResultCase
			AND ISNULL(t.ded_id, 0) <> t2.idfHumanCase
   )
   
INSERT INTO @tt
SELECT tree2.* FROM tree2
LEFT JOIN @tt tt ON
	tt.id = tree2.id
WHERE tt.id IS NULL



IF (
		SELECT 
			COUNT(*) 
		FROM @tt t 
		LEFT JOIN ##RecordsForArchiving AllRecords
			JOIN @TablesForArchiving AllTables ON
				AllTables.idTable = AllRecords.idTable
				AND AllTables.nameTable = '##tCase'
			ON AllRecords.idRow1 = t.id
		WHERE AllRecords.idRow1 IS NULL
	) = 0
BEGIN
	
	DELETE FROM @tt2
	
	INSERT INTO @tt2
	SELECT * FROM @tt t

	DECLARE _T CURSOR FOR
	SELECT 
		t.id
	FROM @tt t
	OPEN _T

	FETCH NEXT FROM _T INTO @id

	WHILE @@FETCH_STATUS = 0
		BEGIN
		
				
		;
		WITH 
		   tree (id, ded_id) 
		   AS (
				SELECT
					t1.idfHumanCase
					, t1.idfDeduplicationResultCase
				FROM tlbHumanCase t1
				WHERE idfHumanCase = @id
				UNION ALL
				SELECT
					t2.idfHumanCase
					, t2.idfDeduplicationResultCase
				FROM tlbHumanCase t2
				JOIN tree t ON 
					t.ded_id = t2.idfHumanCase
					AND ISNULL(t.id, 0) <> t2.idfDeduplicationResultCase
		   )
		   
		INSERT INTO @tt2
		SELECT tree.* FROM tree
		LEFT JOIN @tt2 tt ON
			tt.id = tree.id
		WHERE tt.id IS NULL
		
			;
		WITH 
		   tree2 (id, ded_id) 
		   AS (
				SELECT
					t1.idfHumanCase
					, t1.idfDeduplicationResultCase
				FROM tlbHumanCase t1
				WHERE idfHumanCase = @id
				UNION ALL
				SELECT
					t2.idfHumanCase
					, t2.idfDeduplicationResultCase
				FROM tlbHumanCase t2
				JOIN tree2 t ON 
					t.id = t2.idfDeduplicationResultCase
					AND ISNULL(t.ded_id, 0) <> t2.idfHumanCase
		   )
		   
		INSERT INTO @tt2
		SELECT tree2.* FROM tree2
		LEFT JOIN @tt2 tt ON
			tt.id = tree2.id
		WHERE tt.id IS NULL
		
			
			
			
		FETCH NEXT FROM _T INTO @id
		
		END
		
	CLOSE _T
	DEALLOCATE _T
	
IF (
		SELECT 
			COUNT(*) 
		FROM @tt t 
		LEFT JOIN ##RecordsForArchiving AllRecords
			JOIN @TablesForArchiving AllTables ON
				AllTables.idTable = AllRecords.idTable
				AND AllTables.nameTable = '##tCase'
			ON AllRecords.idRow1 = t.id
		WHERE AllRecords.idRow1 IS NULL
	) > 0
	UPDATE @temp_HC
	SET	prz = 1
	WHERE id = @temp_id

END
ELSE
	UPDATE @temp_HC
	SET	prz = 1
	WHERE id = @temp_id

	FETCH NEXT FROM _HC INTO @temp_id
	
	END
	
CLOSE _HC
DEALLOCATE _HC

--1.
-- отсекаем записи кейсов, имеющих "неподходящих родственников"
DELETE AllRecords
FROM ##RecordsForArchiving AllRecords	
JOIN (
		SELECT 
			th.id
		FROM @temp_HC th
		WHERE th.prz IS NOT NULL
) x ON
	x.id = idRow1
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = '##tCase'

PRINT '@tempCase (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''			


PRINT '-------------------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT ''



PRINT''
PRINT'-------------------------------------------------------------------------'
PRINT'------------ tlbVectorSurveillanceSession -------------------------------'
PRINT'-------------------------------------------------------------------------'
PRINT ''

--0.
-- выбираем записи из tlbVectorSurveillanceSession по дате модификации
INSERT INTO ##RecordsForArchiving
SELECT
	AllTables.idTable
	, idfVectorSurveillanceSession
	, NULL
FROM tlbVectorSurveillanceSession
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbVectorSurveillanceSession'
WHERE idfOutbreak IS NULL
	AND datModificationForArchiveDate <= @ArchiveDate
	
PRINT 'tlbVectorSurveillanceSession (select): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

--1.
-- отсекаем записи из tlbVectorSurveillanceSession, которые связаны с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из ##tCase
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfVectorSurveillanceSession = AllRecords.idRow1
JOIN tlbMaterial tm ON
	tm.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tt.idfBatchTest
		FROM ##tCase tc
		LEFT JOIN ##RecordsForArchiving AllRecords
			JOIN @TablesForArchiving AllTables ON
				AllTables.idTable = AllRecords.idTable
				AND AllTables.nameTable = '##tCase'
			ON AllRecords.idRow1 = tc.IDCase
		JOIN tlbMaterial tm ON
			(tm.idfHumanCase = tc.IDCase OR tm.idfVetCase = tc.IDCase)
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest
		WHERE --tc.idfOutbreak IS NULL
			--AND tc.datModificationForArchiveDate > @ArchiveDate
			AllRecords.idRow1 IS NULL
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbVectorSurveillanceSession'
WHERE tvss.idfOutbreak IS NULL
	
PRINT '@tempVectorSurveillanceSession (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''
			
--2.			
-- отсекаем записи из tlbVectorSurveillanceSession, которые связаны с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из tlbVectorSurveillanceSession
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfVectorSurveillanceSession = AllRecords.idRow1
JOIN tlbMaterial tm ON
	tm.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tbt.idfBatchTest
		FROM tlbVectorSurveillanceSession tvss
		JOIN tlbMaterial tm ON
			tm.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest	
		WHERE tvss.idfOutbreak IS NULL
			AND tvss.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbVectorSurveillanceSession'
WHERE tvss.idfOutbreak IS NULL
	
PRINT '@tempVectorSurveillanceSession (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''		
						
--3.	
-- отсекаем записи из tlbVectorSurveillanceSession, которые связаны с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из tlbMonitoringSession
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfVectorSurveillanceSession = AllRecords.idRow1
JOIN tlbMaterial tm ON
	tm.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tbt.idfBatchTest
		FROM tlbMonitoringSession tms
		JOIN tlbMaterial tm ON
			tm.idfMonitoringSession = tms.idfMonitoringSession
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest
		WHERE tms.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbVectorSurveillanceSession'
WHERE tvss.idfOutbreak IS NULL
	
PRINT '@tempVectorSurveillanceSession (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

--4.
-- отсекаем записи из tlbVectorSurveillanceSession, которые связаны с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из tlbCampaign
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfVectorSurveillanceSession = AllRecords.idRow1
JOIN tlbMaterial tm ON
	tm.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tbt.idfBatchTest
		FROM tlbCampaign tc
		JOIN tlbMonitoringSession tms ON
			tms.idfCampaign = tc.idfCampaign
		JOIN tlbMaterial tm ON
			tm.idfMonitoringSession = tms.idfMonitoringSession
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest
		WHERE tc.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbVectorSurveillanceSession'
WHERE tvss.idfOutbreak IS NULL
	
PRINT '@tempVectorSurveillanceSession (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

--5.
--Отсекаем записи из tlbVectorSurveillanceSession, которые связаны с векторами, у которых есть хост-вектора,
--связанные с ненужными записями из tlbVectorSurveillanceSession
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfVectorSurveillanceSession = AllRecords.idRow1
JOIN tlbVector tv ON
	tv.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
JOIN tlbVector tv2 ON
	tv2.idfVector = tv.idfHostVector
LEFT JOIN ##RecordsForArchiving tempv2 ON
	tempv2.idRow1 = tv2.idfVectorSurveillanceSession
	AND tempv2.idTable = 3 --tlbVectorSurveillanceSession'
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbVectorSurveillanceSession'
WHERE tvss.idfOutbreak IS NULL
	AND tempv2.idRow1 IS NULL
	
PRINT '@tempVectorSurveillanceSession (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

PRINT '-------------------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT ''



PRINT ''
PRINT '-------------------------------------------------------------------------'
PRINT '------------ tlbCampaign ------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT ''

--0.
-- выбираем записи из tlbCampaign по дате модификации
INSERT INTO ##RecordsForArchiving
SELECT
	AllTables.idTable
	, idfCampaign
	, NULL
FROM tlbCampaign
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbCampaign'
WHERE datModificationForArchiveDate <= @ArchiveDate

PRINT 'tlbCampaign (select): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

--1.
-- отсекаем записи из tlbCampaign, которые связаны с ненужными записями из tlbMonitoringSession
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbCampaign tc ON
	tc.idfCampaign = AllRecords.idRow1
JOIN tlbMonitoringSession tms ON
	tms.idfCampaign = tc.idfCampaign
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbCampaign'
WHERE tms.datModificationForArchiveDate > @ArchiveDate

PRINT '@tempCampaign (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''				

--2.
-- отсекаем записи из tlbCampaign, которые связаны с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из ##tCase
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbCampaign tc ON
	tc.idfCampaign = AllRecords.idRow1
JOIN tlbMonitoringSession tms ON
	tms.idfCampaign = tc.idfCampaign
JOIN tlbMaterial tm ON
	tm.idfMonitoringSession = tms.idfMonitoringSession
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tt.idfBatchTest
		FROM ##tCase tc
		LEFT JOIN ##RecordsForArchiving AllRecords
			JOIN @TablesForArchiving AllTables ON
				AllTables.idTable = AllRecords.idTable
				AND AllTables.nameTable = '##tCase'
			ON AllRecords.idRow1 = tc.IDCase
		JOIN tlbMaterial tm ON
			(tm.idfHumanCase = tc.IDCase OR tm.idfVetCase = tc.IDCase)
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest
		WHERE --tc.idfOutbreak IS NULL
			--AND tc.datModificationForArchiveDate > @ArchiveDate
			AllRecords.idRow1 IS NULL
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbCampaign'
	
PRINT '@tempCampaign (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''	
			
--3.			
-- отсекаем записи из tlbCampaign, которые связаны с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из tlbVectorSurveillanceSession
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbCampaign tc ON
	tc.idfCampaign = AllRecords.idRow1
JOIN tlbMonitoringSession tms ON
	tms.idfCampaign = tc.idfCampaign
JOIN tlbMaterial tm ON
	tm.idfMonitoringSession = tms.idfMonitoringSession
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tbt.idfBatchTest
		FROM tlbVectorSurveillanceSession tvss
		JOIN tlbMaterial tm ON
			tm.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest	
		WHERE tvss.idfOutbreak IS NULL
			AND tvss.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbCampaign'
	
PRINT '@tempCampaign (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''	
						
--4.	
-- отсекаем записи из tlbCampaign, которые связаны с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из tlbMonitoringSession
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbCampaign tc ON
	tc.idfCampaign = AllRecords.idRow1
JOIN tlbMonitoringSession tms ON
	tms.idfCampaign = tc.idfCampaign
JOIN tlbMaterial tm ON
	tm.idfMonitoringSession = tms.idfMonitoringSession
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tbt.idfBatchTest
		FROM tlbMonitoringSession tms
		JOIN tlbMaterial tm ON
			tm.idfMonitoringSession = tms.idfMonitoringSession
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest
		WHERE tms.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbCampaign'
	
PRINT '@tempCampaign (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

--5.
-- отсекаем записи из tlbCampaign, которые связаны с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из tlbCampaign
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbCampaign tc ON
	tc.idfCampaign = AllRecords.idRow1
JOIN tlbMonitoringSession tms ON
	tms.idfCampaign = tc.idfCampaign
JOIN tlbMaterial tm ON
	tm.idfMonitoringSession = tms.idfMonitoringSession
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tbt.idfBatchTest
		FROM tlbCampaign tc
		JOIN tlbMonitoringSession tms ON
			tms.idfCampaign = tc.idfCampaign
		JOIN tlbMaterial tm ON
			tm.idfMonitoringSession = tms.idfMonitoringSession
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest
		WHERE tc.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbCampaign'
	
PRINT '@tempCampaign (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''	

--6.
-- выбираем записи из tlbMonitoringSession, связанные с выбранными записями tlbCampaign
INSERT INTO ##RecordsForArchiving
SELECT
	AllTables.idTable
	, idfMonitoringSession
	, NULL
FROM tlbMonitoringSession tms
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbMonitoringSession'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tms.idfCampaign
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbCampaign'
	
PRINT 'tlbMonitoringSession (select): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''
		
PRINT '-------------------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT ''



PRINT ''
PRINT '-------------------------------------------------------------------------'
PRINT '------------ tlbMonitoringSession ---------------------------------------'
PRINT '-------------------------------------------------------------------------'

--0.
-- выбираем записи из tlbMonitoringSession по дате модификации
INSERT INTO ##RecordsForArchiving
SELECT
	AllTables.idTable
	, idfMonitoringSession
	, NULL
FROM tlbMonitoringSession
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbMonitoringSession'
WHERE idfCampaign IS NULL
	AND datModificationForArchiveDate <= @ArchiveDate
	
PRINT 'tlbMonitoringSession (select): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

--1.
-- отсекаем записи из tlbMonitoringSession, которые связаны с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из ##tCase
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbMonitoringSession tms ON
	tms.idfMonitoringSession = AllRecords.idRow1
JOIN tlbMaterial tm ON
	tm.idfMonitoringSession = tms.idfMonitoringSession
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
		SELECT
			tt.idfBatchTest
		FROM ##tCase tc
		LEFT JOIN ##RecordsForArchiving AllRecords
			JOIN @TablesForArchiving AllTables ON
				AllTables.idTable = AllRecords.idTable
				AND AllTables.nameTable = '##tCase'
			ON AllRecords.idRow1 = tc.IDCase
		JOIN tlbMaterial tm ON
			(tm.idfHumanCase = tc.IDCase OR tm.idfVetCase = tc.IDCase)
		JOIN tlbTesting tt ON
			tt.idfMaterial = tm.idfMaterial
		JOIN tlbBatchTest tbt ON
			tbt.idfBatchTest = tt.idfBatchTest
		WHERE --tc.idfOutbreak IS NULL
			--AND tc.datModificationForArchiveDate > @ArchiveDate
			AllRecords.idRow1 IS NULL
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbMonitoringSession'
WHERE tms.idfCampaign IS NULL
	
PRINT '@tempMonitoringSession (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''	
			
--3.			
-- отсекаем записи из tlbMonitoringSession, которые связаны с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из tlbVectorSurveillanceSession
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbMonitoringSession tms ON
	tms.idfMonitoringSession = AllRecords.idRow1
JOIN tlbMaterial tm ON
	tm.idfMonitoringSession = tms.idfMonitoringSession
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
				SELECT
					tbt.idfBatchTest
				FROM tlbVectorSurveillanceSession tvss
				JOIN tlbMaterial tm ON
					tm.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
				JOIN tlbTesting tt ON
					tt.idfMaterial = tm.idfMaterial
				JOIN tlbBatchTest tbt ON
					tbt.idfBatchTest = tt.idfBatchTest	
				WHERE tvss.idfOutbreak IS NULL
					AND tvss.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbMonitoringSession'
WHERE tms.idfCampaign IS NULL
	
PRINT '@tempMonitoringSession (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''	
						
--4.	
-- отсекаем записи из tlbMonitoringSession, которые связаны с тестами, входящими в батчи
-- , в которые также входят и тесты, связанные с ненужными записями из tlbMonitoringSession
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
JOIN tlbMonitoringSession tms ON
	tms.idfMonitoringSession = AllRecords.idRow1
JOIN tlbMaterial tm ON
	tm.idfMonitoringSession = tms.idfMonitoringSession
JOIN tlbTesting tt ON
	tt.idfMaterial = tm.idfMaterial
JOIN tlbBatchTest tbt ON
	tbt.idfBatchTest = tt.idfBatchTest
JOIN (
				SELECT
					tbt.idfBatchTest
				FROM tlbMonitoringSession tms
				JOIN tlbMaterial tm ON
					tm.idfMonitoringSession = tms.idfMonitoringSession
				JOIN tlbTesting tt ON
					tt.idfMaterial = tm.idfMaterial
				JOIN tlbBatchTest tbt ON
					tbt.idfBatchTest = tt.idfBatchTest
				WHERE tms.idfCampaign IS NULL
					AND tms.datModificationForArchiveDate > @ArchiveDate
) x ON
	x.idfBatchTest = tbt.idfBatchTest
JOIN @TablesForArchiving AllTables ON
	AllTables.idTable = AllRecords.idTable
	AND AllTables.nameTable = 'tlbMonitoringSession'
WHERE tms.idfCampaign IS NULL
	
PRINT '@tempMonitoringSession (delete): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''	
			
PRINT '-------------------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT ''


PRINT ''
PRINT '-------------------------------------------------------------------------'
PRINT '------------ tlbAggrCase ------------------------------------------------'
PRINT '-------------------------------------------------------------------------'

--0.
-- выбираем записи из tlbAggrCase по дате модификации
INSERT INTO ##RecordsForArchiving
SELECT
	AllTables.idTable
	, idfAggrCase
	, NULL
FROM tlbAggrCase
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbAggrCase'
WHERE datModificationForArchiveDate <= @ArchiveDate

PRINT 'tlbAggrCase (select): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

PRINT '-------------------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT ''


PRINT ''
PRINT '-------------------------------------------------------------------------'
PRINT '------------ tstSecurityAudit -------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT ''

--0.
-- выбираем записи из tstSecurityAudit по дате модификации
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, idfSecurityAudit
	, NULL
FROM tstSecurityAudit
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tstSecurityAudit'
WHERE datActionDate <= @ArchiveDate

PRINT 'tstSecurityAudit (select): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

PRINT '-------------------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT ''



PRINT ''
PRINT '-------------------------------------------------------------------------'
PRINT '------------ tlbBasicSyndromicSurveillance ------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT ''

--0.
-- выбираем записи из tlbBasicSyndromicSurveillance по дате модификации
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, idfBasicSyndromicSurveillance
	, NULL
FROM tlbBasicSyndromicSurveillance
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbBasicSyndromicSurveillance'
WHERE datModificationForArchiveDate <= @ArchiveDate

PRINT 'tlbBasicSyndromicSurveillance (select): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

PRINT '-------------------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT ''



PRINT ''
PRINT '-------------------------------------------------------------------------'
PRINT '------------ tlbBasicSyndromicSurveillanceAggregateHeader----------------'
PRINT '-------------------------------------------------------------------------'
PRINT ''

--0.
-- выбираем записи из tlbBasicSyndromicSurveillanceAggregateHeader по дате модификации
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, idfAggregateHeader
	, NULL
FROM tlbBasicSyndromicSurveillanceAggregateHeader
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbBasicSyndromicSurveillanceAggregateHeader'
WHERE datModificationForArchiveDate <= @ArchiveDate

PRINT 'tlbBasicSyndromicSurveillanceAggregateHeader (select): ' + CAST(@@rowcount AS VARCHAR(20))
PRINT ''

PRINT '-------------------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------'
PRINT ''



-- отсекаем записи, которые связаны с материалами, входящими в трасфераут,
-- в которые также входят и материалы, не подлежащие архивации
DELETE FROM AllRecords
FROM ##RecordsForArchiving AllRecords
LEFT JOIN ##tCase tc 
	JOIN tlbMaterial tm ON
		(tm.idfHumanCase = tc.IDCase OR tm.idfVetCase = tc.IDCase)
ON tc.IDCase = AllRecords.idRow1

LEFT JOIN tlbVectorSurveillanceSession tvss 
	JOIN tlbMaterial tm2 ON
		tm2.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
ON tvss.idfVectorSurveillanceSession = AllRecords.idRow1

LEFT JOIN tlbMonitoringSession tms 
	JOIN tlbMaterial tm3 ON
		tm3.idfMonitoringSession = tms.idfMonitoringSession
ON tms.idfMonitoringSession = AllRecords.idRow1

JOIN tlbTransferOutMaterial ttom ON
	ttom.idfMaterial = COALESCE(tm.idfMaterial, tm2.idfMaterial, tm3.idfMaterial)
JOIN tlbTransferOutMaterial ttom2 ON
	ttom2.idfTransferOut = ttom.idfTransferOut
	AND ttom2.idfMaterial NOT IN (
									SELECT 
										COALESCE(tm.idfMaterial, tm2.idfMaterial, tm3.idfMaterial)
									FROM ##RecordsForArchiving AllRecords
									LEFT JOIN ##tCase tc 
										JOIN tlbMaterial tm ON
											(tm.idfHumanCase = tc.IDCase OR tm.idfVetCase = tc.IDCase)
									ON tc.IDCase = AllRecords.idRow1	
									LEFT JOIN tlbVectorSurveillanceSession tvss 
										JOIN tlbMaterial tm2 ON
											tm2.idfVectorSurveillanceSession = tvss.idfVectorSurveillanceSession
									ON tvss.idfVectorSurveillanceSession = AllRecords.idRow1
									LEFT JOIN tlbMonitoringSession tms 
										JOIN tlbMaterial tm3 ON
											tm3.idfMonitoringSession = tms.idfMonitoringSession
									ON tms.idfMonitoringSession = AllRecords.idRow1	
									WHERE COALESCE(tm.idfMaterial, tm2.idfMaterial, tm3.idfMaterial, 0) <> 0
								)


/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/








/*----------------------------------------------------------------------*/
/*Копируем в архивную базу отобранные записи определяющих таблиц        */
/*а также связанные с ними записи второстепенных таблиц					*/
/*----------------------------------------------------------------------*/

PRINT ''
PRINT 'Copying information from Work DB into Archive DB'
PRINT '------------------------------------------------'
PRINT ''


DECLARE @RowId BIGINT = 0, @RowId2 BIGINT = 0
DECLARE @RowCount NVARCHAR(10) = ''


--1. tlbGeoLocation
-- запоминаем записи из tlbGeoLocation, связанные с tlbOutbreak
INSERT INTO ##RecordsForArchiving
SELECT
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbOutbreak tout ON
	tout.idfGeoLocation = [source].idfGeoLocation
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tout.idfOutbreak
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbOutbreak'

-- запоминаем записи из tlbGeoLocation, связанные с tlbVectorSurveillanceSession
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfLocation = [source].idfGeoLocation
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvss.idfVectorSurveillanceSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbVectorSurveillanceSession'

-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbMonitoringSession через tlbFarm (idfFarmAddress)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbFarm tf ON
	tf.idfFarmAddress = [source].idfGeoLocation
JOIN tlbMonitoringSession tms ON
	tms.idfMonitoringSession = tf.idfMonitoringSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tms.idfMonitoringSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMonitoringSession'
	
-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbMonitoringSession через tlbHuman (idfCurrentResidenceAddress)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbHuman th ON
	th.idfCurrentResidenceAddress = [source].idfGeoLocation
JOIN tlbFarm tf ON
	tf.idfHuman = th.idfHuman
JOIN tlbMonitoringSession tms ON
	tms.idfMonitoringSession = tf.idfMonitoringSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tms.idfMonitoringSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMonitoringSession'
	
-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbMonitoringSession через tlbHuman (idfEmployerAddress)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbHuman th ON
	th.idfEmployerAddress = [source].idfGeoLocation
JOIN tlbFarm tf ON
	tf.idfHuman = th.idfHuman
JOIN tlbMonitoringSession tms ON
	tms.idfMonitoringSession = tf.idfMonitoringSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tms.idfMonitoringSession	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMonitoringSession'
	
-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbMonitoringSession через tlbHuman (idfRegistrationAddress)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbHuman th ON
	th.idfRegistrationAddress = [source].idfGeoLocation
JOIN tlbFarm tf ON
	tf.idfHuman = th.idfHuman
JOIN tlbMonitoringSession tms ON
	tms.idfMonitoringSession = tf.idfMonitoringSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tms.idfMonitoringSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMonitoringSession'

-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbVetCase через tlbFarm (idfFarmAddress)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbFarm tf ON
	tf.idfFarmAddress = [source].idfGeoLocation
JOIN tlbVetCase tvc ON
	tvc.idfFarm = tf.idfFarm
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvc.idfVetCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'

-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbVetCase через tlbHuman (idfCurrentResidenceAddress)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbHuman th ON
	th.idfCurrentResidenceAddress = [source].idfGeoLocation
JOIN tlbFarm tf ON
	tf.idfHuman = th.idfHuman
JOIN tlbVetCase tvc ON
	tvc.idfFarm = tf.idfFarm
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvc.idfVetCase	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'

-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbVetCase через tlbHuman (idfEmployerAddress)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbHuman th ON
	th.idfEmployerAddress = [source].idfGeoLocation
JOIN tlbFarm tf ON
	tf.idfHuman = th.idfHuman
JOIN tlbVetCase tvc ON
	tvc.idfFarm = tf.idfFarm
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvc.idfVetCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
	
-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbVetCase через tlbHuman (idfRegistrationAddress)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbHuman th ON
	th.idfRegistrationAddress = [source].idfGeoLocation
JOIN tlbFarm tf ON
	tf.idfHuman = th.idfHuman
JOIN tlbVetCase tvc ON
	tvc.idfFarm = tf.idfFarm
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvc.idfVetCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'

-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbVetCase через tlbHuman (idfCurrentResidenceAddress) и tlbVaccination
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbHuman th ON
	th.idfCurrentResidenceAddress = [source].idfGeoLocation
JOIN tlbFarm tf ON
	tf.idfHuman = th.idfHuman
JOIN tlbHerd th2 ON
	th2.idfFarm = tf.idfFarm
JOIN tlbSpecies ts ON
	ts.idfHerd = th2.idfHerd
JOIN tlbVaccination tv ON
	tv.idfSpecies = ts.idfSpecies
JOIN tlbVetCase tvc ON
	tvc.idfVetCase = tv.idfVetCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvc.idfVetCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
	
-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbVetCase через tlbHuman (idfEmployerAddress) и tlbVaccination
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbHuman th ON
	th.idfEmployerAddress = [source].idfGeoLocation
JOIN tlbFarm tf ON
	tf.idfHuman = th.idfHuman
JOIN tlbHerd th2 ON
	th2.idfFarm = tf.idfFarm
JOIN tlbSpecies ts ON
	ts.idfHerd = th2.idfHerd
JOIN tlbVaccination tv ON
	tv.idfSpecies = ts.idfSpecies
JOIN tlbVetCase tvc ON
	tvc.idfVetCase = tv.idfVetCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvc.idfVetCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
	
-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbVetCase через tlbHuman (idfRegistrationAddress) и tlbVaccination
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbHuman th ON
	th.idfRegistrationAddress = [source].idfGeoLocation
JOIN tlbFarm tf ON
	tf.idfHuman = th.idfHuman
JOIN tlbHerd th2 ON
	th2.idfFarm = tf.idfFarm
JOIN tlbSpecies ts ON
	ts.idfHerd = th2.idfHerd
JOIN tlbVaccination tv ON
	tv.idfSpecies = ts.idfSpecies
JOIN tlbVetCase tvc ON
	tvc.idfVetCase = tv.idfVetCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvc.idfVetCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'

-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbVetCase через tlbFarm (idfFarmAddress) и tlbVaccination
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbFarm tf ON
	tf.idfFarmAddress = [source].idfGeoLocation
JOIN tlbHerd th2 ON
	th2.idfFarm = tf.idfFarm
JOIN tlbSpecies ts ON
	ts.idfHerd = th2.idfHerd
JOIN tlbVaccination tv ON
	tv.idfSpecies = ts.idfSpecies
JOIN tlbVetCase tvc ON
	tvc.idfVetCase = tv.idfVetCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvc.idfVetCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'

-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbVectorSurveillanceSession через hostvector
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbVector tv ON
	tv.idfLocation = [source].idfGeoLocation
JOIN tlbVector tv2 ON
	tv2.idfHostVector = tv.idfVector
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfVectorSurveillanceSession = tv2.idfVectorSurveillanceSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvss.idfVectorSurveillanceSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbVectorSurveillanceSession'

-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbVectorSurveillanceSession
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbVector tv ON
	tv.idfLocation = [source].idfGeoLocation
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfVectorSurveillanceSession = tv.idfVectorSurveillanceSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvss.idfVectorSurveillanceSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbVectorSurveillanceSession'

-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbHumanCase
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbHumanCase thc ON
	thc.idfPointGeoLocation = [source].idfGeoLocation
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = thc.idfHumanCase	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'

-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbHumanCase через tlbHuman (idfCurrentResidenceAddress)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbHuman th ON
	th.idfCurrentResidenceAddress = [source].idfGeoLocation
JOIN tlbHumanCase thc ON
	thc.idfHuman = th.idfHuman
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = thc.idfHumanCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'

-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbHumanCase через tlbHuman (idfEmployerAddress)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbHuman th ON
	th.idfEmployerAddress = [source].idfGeoLocation
JOIN tlbHumanCase thc ON
	thc.idfHuman = th.idfHuman
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = thc.idfHumanCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
	
-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbHumanCase через tlbHuman (idfRegistrationAddress)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbHuman th ON
	th.idfRegistrationAddress = [source].idfGeoLocation
JOIN tlbHumanCase thc ON
	thc.idfHuman = th.idfHuman
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = thc.idfHumanCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'

-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbHumanCase через tlbContactedCasePerson (idfCurrentResidenceAddress)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbHuman th ON
	th.idfCurrentResidenceAddress = [source].idfGeoLocation
JOIN tlbContactedCasePerson tccp ON
	tccp.idfHuman = th.idfHuman
JOIN tlbHumanCase thc ON
	thc.idfHumanCase= tccp.idfHumanCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = thc.idfHumanCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
	
-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbHumanCase через tlbContactedCasePerson (idfEmployerAddress)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbHuman th ON
	th.idfEmployerAddress = [source].idfGeoLocation
JOIN tlbContactedCasePerson tccp ON
	tccp.idfHuman = th.idfHuman
JOIN tlbHumanCase thc ON
	thc.idfHumanCase= tccp.idfHumanCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = thc.idfHumanCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
	
-- запоминаем записи из tlbGeoLocation, связанные с ранее отобранными записями tlbHumanCase через tlbContactedCasePerson (idfRegistrationAddress)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, NULL
FROM tlbGeoLocation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocation'
JOIN tlbHuman th ON
	th.idfRegistrationAddress = [source].idfGeoLocation
JOIN tlbContactedCasePerson tccp ON
	tccp.idfHuman = th.idfHuman
JOIN tlbHumanCase thc ON
	thc.idfHumanCase= tccp.idfHumanCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = thc.idfHumanCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
	

--2.
-- запоминаем записи таблицы tlbOutbreakNote, связанные с отобранными ранее записями таблицы tlbOutbreak
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfOutbreakNote
	, NULL
FROM tlbOutbreakNote [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbOutbreakNote'
JOIN tlbOutbreak tout ON
	tout.idfOutbreak = [source].idfOutbreakNote
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tout.idfOutbreak
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbOutbreak'


--3.
-- запоминаем записи таблицы tlbVectorSurveillanceSessionSummary 
--связанные c отобранными ранее записями из tlbVectorSurveillanceSession
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfsVSSessionSummary
	, NULL
FROM tlbVectorSurveillanceSessionSummary [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbVectorSurveillanceSessionSummary'
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfVectorSurveillanceSession = [source].idfVectorSurveillanceSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvss.idfVectorSurveillanceSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbVectorSurveillanceSession'


--4.
-- запоминаем записи таблицы tlbVectorSurveillanceSessionSummaryDiagnosis 
--связанные c отобранными ранее записями из tlbVectorSurveillanceSession
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfsVSSessionSummary
	, NULL
FROM tlbVectorSurveillanceSessionSummaryDiagnosis [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbVectorSurveillanceSessionSummaryDiagnosis'
JOIN tlbVectorSurveillanceSessionSummary tvsss ON
	tvsss.idfsVSSessionSummary = [source].idfsVSSessionSummary
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfVectorSurveillanceSession = tvsss.idfVectorSurveillanceSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvss.idfVectorSurveillanceSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbVectorSurveillanceSession'
		

--4.
-- запоминаем записи таблицы tlbCampaignToDiagnosis, связанные с ранее отобранными записями таблицы tlbCampaign
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfCampaignToDiagnosis
	, NULL
FROM tlbCampaignToDiagnosis [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbCampaignToDiagnosis'
JOIN tlbCampaign tc ON
	tc.idfCampaign = [source].idfCampaign
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tc.idfCampaign
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbCampaign'
	

--5.
-- запоминаем записи из tlbHuman, связанные с ранее отобранными записями tlbMonitoringSession через tlbFarm
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfHuman
	, NULL
FROM tlbHuman [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbHuman'
JOIN tlbFarm tf ON
	tf.idfHuman = [source].idfHuman
JOIN tlbMonitoringSession tms ON
	tms.idfMonitoringSession = tf.idfMonitoringSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tms.idfMonitoringSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMonitoringSession'

-- запоминаем записи из tlbHuman, связанные с ранее отобранными записями tlbVetCase через tlbFarm
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfHuman
	, NULL
FROM tlbHuman [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbHuman'
JOIN tlbFarm tf ON
	tf.idfHuman = [source].idfHuman
JOIN tlbVetCase tvc ON
	tvc.idfFarm = tf.idfFarm
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvc.idfVetCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'

-- запоминаем записи из tlbHuman, связанные с ранее отобранными записями tlbVetCase через tlbVaccination
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfHuman
	, NULL
FROM tlbHuman [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbHuman'
JOIN tlbFarm tf ON
	tf.idfHuman = [source].idfHuman
JOIN tlbHerd th2 ON
	th2.idfFarm = tf.idfFarm
JOIN tlbSpecies ts ON
	ts.idfHerd = th2.idfHerd
JOIN tlbVaccination tv ON
	tv.idfSpecies = ts.idfSpecies
JOIN tlbVetCase tvc ON
	tvc.idfVetCase = tv.idfVetCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvc.idfVetCase	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'

-- запоминаем записи из tlbHuman, связанные с ранее отобранными записями tlbHumanCase
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfHuman
	, NULL
FROM tlbHuman [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbHuman'
JOIN tlbHumanCase thc ON
	thc.idfHuman = [source].idfHuman
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = thc.idfHumanCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'		

-- запоминаем записи из tlbHuman, связанные с ранее отобранными записями tlbHumanCase через tlbContactedCasePerson
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfHuman
	, NULL
FROM tlbHuman [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbHuman'
JOIN tlbContactedCasePerson tccp ON
	tccp.idfHuman = [source].idfHuman
JOIN tlbHumanCase thc ON
	thc.idfHumanCase= tccp.idfHumanCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = thc.idfHumanCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'	
	
		
--6.
-- запоминаем записи из tlbFarm, связанные с ранее отобранными записями tlbMonitoringSession
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfFarm
	, NULL
FROM tlbFarm [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbFarm'
JOIN tlbMonitoringSession tms ON
	tms.idfMonitoringSession = [source].idfMonitoringSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tms.idfMonitoringSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMonitoringSession'

-- запоминаем записи из tlbFarm, связанные с ранее отобранными записями tlbMonitoringSession через tlbMonitoringSessionSummary
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfFarm
	, NULL
FROM tlbFarm [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbFarm'
JOIN tlbMonitoringSessionSummary tmss ON
	tmss.idfFarm = [source].idfFarm
JOIN tlbMonitoringSession tms ON
	tms.idfMonitoringSession = tmss.idfMonitoringSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tms.idfMonitoringSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMonitoringSession'		

-- запоминаем записи из tlbFarm, связанные с ранее отобранными записями tlbVetCase
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfFarm
	, NULL
FROM tlbFarm [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbFarm'
JOIN tlbVetCase tvc ON
	tvc.idfFarm = [source].idfFarm
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1= tvc.idfVetCase	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'

-- запоминаем записи из tlbFarm, связанные с ранее отобранными записями tlbVetCase через tlbVaccination
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfFarm
	, NULL
FROM tlbFarm [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbFarm'
JOIN tlbHerd th2 ON
	th2.idfFarm = [source].idfFarm
JOIN tlbSpecies ts ON
	ts.idfHerd = th2.idfHerd
JOIN tlbVaccination tv ON
	tv.idfSpecies = ts.idfSpecies
JOIN tlbVetCase tvc ON
	tvc.idfVetCase = tv.idfVetCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvc.idfVetCase	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'	


--7.
-- запоминаем записи таблицы tlbMonitoringSessionAction, связанные с ранее отобранными записями таблицы tlbMonitoringSession
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfMonitoringSessionAction
	, NULL
FROM tlbMonitoringSessionAction [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbMonitoringSessionAction'
JOIN tlbMonitoringSession tms ON
	tms.idfMonitoringSession = [source].idfMonitoringSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tms.idfMonitoringSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMonitoringSession'
	
		
--8.
-- запоминаем записи таблицы tlbMonitoringSessionToDiagnosis, связанные с ранее отобранными записями таблицы tlbMonitoringSession
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfMonitoringSessionToDiagnosis
	, NULL
FROM tlbMonitoringSessionToDiagnosis [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbMonitoringSessionToDiagnosis'
JOIN tlbMonitoringSession tms ON
	tms.idfMonitoringSession = [source].idfMonitoringSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tms.idfMonitoringSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMonitoringSession'
	
	
--9.
-- запоминаем записи таблицы tlbMonitoringSessionSummary, связанные с ранее отобранными записями таблицы tlbMonitoringSession
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfMonitoringSessionSummary
	, NULL
FROM tlbMonitoringSessionSummary [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbMonitoringSessionSummary'
JOIN tlbMonitoringSession tms ON
	tms.idfMonitoringSession = [source].idfMonitoringSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tms.idfMonitoringSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMonitoringSession'
	

--10.
-- запоминаем записи таблицы tlbMonitoringSessionSummaryDiagnosis, связанные с ранее отобранными записями таблицы tlbMonitoringSession через tlbMonitoringSessionSummary
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfMonitoringSessionSummary
	, [source].idfsDiagnosis
FROM tlbMonitoringSessionSummaryDiagnosis [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbMonitoringSessionSummaryDiagnosis'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfMonitoringSessionSummary
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMonitoringSessionSummary'
		
	
--11.
-- запоминаем записи таблицы tlbMonitoringSessionSummarySample, связанные с ранее отобранными записями таблицы tlbMonitoringSession через tlbMonitoringSessionSummary
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfMonitoringSessionSummary
	, [source].idfsSampleType
FROM tlbMonitoringSessionSummarySample [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbMonitoringSessionSummarySample'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfMonitoringSessionSummary
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMonitoringSessionSummary'
	
	
--12.
-- запоминаем записи таблицы tlbVetCaseLog, связанные с ранее отобранными записями tlbVetCase
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfVetCaseLog
	, NULL
FROM tlbVetCaseLog [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbVetCaseLog'
JOIN tlbVetCase tvc ON
	tvc.idfVetCase = [source].idfVetCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1  = tvc.idfVetCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
		
	
--13.
-- запоминаем записи из tlbHerd, связанные с ранее отобранными записями tlbVetCase через tlbVaccination
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfHerd
	, NULL
FROM tlbHerd [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbHerd'
JOIN tlbSpecies ts ON
	ts.idfHerd = [source].idfHerd
JOIN tlbVaccination tv ON
	tv.idfSpecies = ts.idfSpecies
JOIN tlbVetCase tvc ON
	tvc.idfVetCase = tv.idfVetCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1  = tvc.idfVetCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
	
-- запоминаем записи из tlbHerd, связанные с ранее отобранными записями tlbFarm
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfHerd
	, NULL
FROM tlbHerd [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbHerd'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfFarm	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbFarm'
	
	
--14.
-- запоминаем записи из tlbSpecies, связанные с ранее отобранными записями tlbVetCase через tlbVaccination
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfSpecies
	, NULL
FROM tlbSpecies [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbSpecies'
JOIN tlbVaccination tv ON
	tv.idfSpecies = [source].idfSpecies
JOIN tlbVetCase tvc ON
	tvc.idfVetCase = tv.idfVetCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1  = tvc.idfVetCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
	
-- запоминаем записи из tlbSpecies, связанные с ранее отобранными записями tlbFarm
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfSpecies
	, NULL
FROM tlbSpecies [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbSpecies'
JOIN tlbHerd th ON
	th.idfHerd = [source].idfHerd
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = th.idfFarm
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbFarm'
		
	
--15.
-- запоминаем записи из tlbVaccination, связанные с ранее отобранными записями tlbVetCase
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfVaccination
	, NULL
FROM tlbVaccination [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbVaccination'
JOIN tlbVetCase tvc ON
	tvc.idfVetCase = [source].idfVetCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1  = tvc.idfVetCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
	
--16.
-- запоминаем записи из tlbVector, связанные с ранее отобранными записями tlbVectorSurveillanceSession через hostvector
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfVector
	, NULL
FROM tlbVector [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbVector'
JOIN tlbVector tv2 ON
	tv2.idfHostVector = [source].idfVector
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfVectorSurveillanceSession = tv2.idfVectorSurveillanceSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvss.idfVectorSurveillanceSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbVectorSurveillanceSession'
	
-- запоминаем записи из tlbVector, связанные с ранее отобранными записями tlbVectorSurveillanceSession
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfVector
	, NULL
FROM tlbVector [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbVector'
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfVectorSurveillanceSession = [source].idfVectorSurveillanceSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvss.idfVectorSurveillanceSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbVectorSurveillanceSession'
	
	
--17.
-- запоминаем записи из tlbAntimicrobialTherapy, связанные с ранее отобранными записями tlbHumanCase
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfAntimicrobialTherapy
	, NULL
FROM tlbAntimicrobialTherapy [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbAntimicrobialTherapy'
JOIN tlbHumanCase thc ON
	thc.idfHumanCase = [source].idfHumanCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = thc.idfHumanCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
		
	
--18.
-- запоминаем записи из tlbChangeDiagnosisHistory, связанные с ранее отобранными записями tlbHumanCase
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfChangeDiagnosisHistory
	, NULL
FROM tlbChangeDiagnosisHistory [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbChangeDiagnosisHistory'
JOIN tlbHumanCase thc ON
	thc.idfHumanCase = [source].idfHumanCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = thc.idfHumanCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
		
	
--19.
-- запоминаем записи из tlbContactedCasePerson, связанные с ранее отобранными записями tlbHumanCase
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfContactedCasePerson
	, NULL
FROM tlbContactedCasePerson [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbContactedCasePerson'
JOIN tlbHumanCase thc ON
	thc.idfHumanCase= [source].idfHumanCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = thc.idfHumanCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
		
	
--20.
-- запоминаем записи таблицы tlbAnimal, связанные с ранее отобранными записями таблицы tlbFarm
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfAnimal
	, NULL
FROM tlbAnimal [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbAnimal'
JOIN tlbSpecies ts ON
	ts.idfSpecies = [source].idfSpecies
JOIN tlbHerd th ON
	th.idfHerd = ts.idfHerd
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = th.idfFarm
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbFarm'
		
	
--21.
-- запоминаем записи из tlbMaterial, связанные с ранее отобранными записями ##tCase, tlbMonitoringSession, tlbVectorSurveillanceSession
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfMaterial
	, NULL
FROM tlbMaterial [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbMaterial'
LEFT JOIN ##RecordsForArchiving AllRecordsCase
	JOIN @TablesForArchiving AllTables2 ON
		AllTables2.idTable = AllRecordsCase.idTable
		AND AllTables2.nameTable = '##tCase'
	ON (AllRecordsCase.idRow1 = [source].idfHumanCase OR AllRecordsCase.idRow1 = [source].idfVetCase)
LEFT JOIN ##RecordsForArchiving AllRecordsAS
	JOIN @TablesForArchiving AllTables3 ON
		AllTables3.idTable = AllRecordsAS.idTable
		AND AllTables3.nameTable = 'tlbMonitoringSession'
	ON AllRecordsAS.idRow1 = [source].idfMonitoringSession
LEFT JOIN ##RecordsForArchiving AllRecordsVS
	JOIN @TablesForArchiving AllTables4 ON
		AllTables4.idTable = AllRecordsVS.idTable
		AND AllTables4.nameTable = 'tlbVectorSurveillanceSession'
	ON AllRecordsVS.idRow1 = [source].idfVectorSurveillanceSession	
WHERE COALESCE(AllRecordsCase.idRow1, AllRecordsAS.idRow1, AllRecordsVS.idRow1, 0) <> 0


----22.
---- запоминаем записи из tlbAccessionIN, связанные с ранее отобранными записями tlbMaterial
--INSERT INTO ##RecordsForArchiving
--SELECT 
--	AllTables.idTable
--	, [source].idfMaterial
--	, NULL
--FROM tlbAccessionIN [source]
--JOIN @TablesForArchiving AllTables ON
--	AllTables.nameTable = 'tlbAccessionIN'
--JOIN ##RecordsForArchiving AllRecords ON
--	AllRecords.idRow1 = [source].idfMaterial	
--JOIN @TablesForArchiving AllTables2 ON
--	AllTables2.idTable = AllRecords.idTable
--	AND AllTables2.nameTable = 'tlbMaterial'
		
	
--23.
-- запоминаем записи из tlbPensideTest, связанные с ранее отобранными записями tlbMaterial
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfPensideTest
	, NULL
FROM tlbPensideTest [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbPensideTest'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfMaterial
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMaterial'
		
	
--24.
-- запоминаем записи из tlbTransferOUT, связанные с ранее отобранными записями tlbMaterial через tlbTransferOutMaterial
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfTransferOut
	, NULL
FROM tlbTransferOUT [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbTransferOUT'
JOIN tlbTransferOutMaterial ttom ON
	ttom.idfTransferOut = [source].idfTransferOut
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = ttom.idfMaterial	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMaterial'	
LEFT JOIN tlbTransferOutMaterial ttom2 ON
	ttom2.idfTransferOut = [source].idfTransferOut
	AND ttom2.idfMaterial NOT IN (
									SELECT 
										idRow1 
									FROM ##RecordsForArchiving AllRecords
									JOIN @TablesForArchiving AllTables ON 
										AllTables.idTable = AllRecords.idTable 
										AND AllTables.nameTable = 'tlbMaterial'
									)

WHERE ttom2.idfMaterial IS NULL


--25.
-- запоминаем записи из tlbTransferOutMaterial, связанные с ранее отобранными записями tlbMaterial
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfMaterial
	, [source].idfTransferOut
FROM tlbTransferOutMaterial [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbTransferOutMaterial'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfMaterial
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMaterial'
		
	
--28.
-- запоминаем записи таблицы tlbBatchTest, связанные с ранее отобранными записями таблицы tlbMaterial через tlbTesting
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfBatchTest
	, NULL
FROM tlbBatchTest [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbBatchTest'
JOIN tlbTesting ttest ON
	ttest.idfBatchTest = [source].idfBatchTest
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = ttest.idfMaterial
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMaterial'
WHERE [source].idfBatchTest NOT IN (
										SELECT 
											ttest2.idfBatchTest 
										FROM tlbTesting ttest2 
										LEFT JOIN ##RecordsForArchiving AllRecords
											JOIN @TablesForArchiving AllTables2 ON
												AllTables2.idTable = AllRecords.idTable
												AND AllTables2.nameTable = 'tlbMaterial' 
											ON AllRecords.idRow1 = ttest2.idfMaterial 
										WHERE AllRecords.idRow1 IS NULL
											AND ttest2.idfBatchTest IS NOT NULL
									)


--29.
-- запоминаем записи таблицы tlbTesting, связанные с ранее отобранными записями таблицы tlbMaterial
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfTesting
	, NULL
FROM tlbTesting [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbTesting'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfMaterial
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMaterial'
		
	
--30.
-- запоминаем записи таблицы tstLocalSamplesTestsPreferences, связанные с ранее отобранными записями таблицы tlbMaterial
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfSamplesTestsPreferences
	, NULL
FROM tstLocalSamplesTestsPreferences [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tstLocalSamplesTestsPreferences'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfMaterial
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMaterial'	
	
--31.
-- запоминаем записи таблицы tlbTestValidation, связанные с ранее отобранными записями таблицы tlbTesting
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfTestValidation
	, NULL
FROM tlbTestValidation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbTestValidation'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfTesting
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbTesting'
		
	
--32.
-- запоминаем записи таблицы tlbTestAmendmentHistory, связанные с ранее отобранными записями таблицы tlbTesting
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfTestAmendmentHistory
	, NULL
FROM tlbTestAmendmentHistory [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbTestAmendmentHistory'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfTesting
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbTesting'
	
	
--33.
-- запоминаем записи таблицы tlbObservation, связанные с ранее отобранными записями таблицы tlbMonitoringSession через tlbFarm
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservation
	, NULL
FROM tlbObservation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbObservation'
JOIN tlbFarm tf ON
	tf.idfObservation = [source].idfObservation
JOIN tlbMonitoringSession tms ON
	tms.idfMonitoringSession = tf.idfMonitoringSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tms.idfMonitoringSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMonitoringSession'
	
-- запоминаем записи таблицы tlbObservation, связанные с ранее отобранными записями таблицы tlbAggrCase (idfCaseObservation)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservation
	, NULL
FROM tlbObservation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbObservation'
JOIN tlbAggrCase tac ON
	tac.idfCaseObservation = [source].idfObservation
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tac.idfAggrCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbAggrCase'
		
-- запоминаем записи таблицы tlbObservation, связанные с ранее отобранными записями таблицы tlbAggrCase (idfDiagnosticObservation)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservation
	, NULL
FROM tlbObservation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbObservation'
JOIN tlbAggrCase tac ON
	tac.idfDiagnosticObservation = [source].idfObservation
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tac.idfAggrCase	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbAggrCase'
		
-- запоминаем записи таблицы tlbObservation, связанные с ранее отобранными записями таблицы tlbAggrCase (idfProphylacticObservation)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservation
	, NULL
FROM tlbObservation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbObservation'
JOIN tlbAggrCase tac ON
	tac.idfProphylacticObservation = [source].idfObservation
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tac.idfAggrCase	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbAggrCase'
		
-- запоминаем записи таблицы tlbObservation, связанные с ранее отобранными записями таблицы tlbAggrCase (idfSanitaryObservation)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservation
	, NULL
FROM tlbObservation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbObservation'
JOIN tlbAggrCase tac ON
	tac.idfSanitaryObservation = [source].idfObservation
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tac.idfAggrCase	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbAggrCase'
	
-- запоминаем записи таблицы tlbObservation, связанные с ранее отобранными записями таблицы tlbVetCase
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservation
	, NULL
FROM tlbObservation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbObservation'
JOIN tlbVetCase tvc ON
	tvc.idfObservation = [source].idfObservation
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvc.idfVetCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
	
-- запоминаем записи таблицы tlbObservation, связанные с ранее отобранными записями таблицы tlbVetCase через tlbFarm
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservation
	, NULL
FROM tlbObservation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbObservation'
JOIN tlbFarm tf ON
	tf.idfObservation = [source].idfObservation
JOIN tlbVetCase tvc ON
	tvc.idfFarm = tf.idfFarm
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvc.idfVetCase		
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
	
-- запоминаем записи таблицы tlbObservation, связанные с ранее отобранными записями таблицы tlbVetCase через tlbFarm и tlbVaccination
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservation
	, NULL
FROM tlbObservation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbObservation'
JOIN tlbFarm tf ON
	tf.idfObservation = [source].idfObservation
JOIN tlbHerd th2 ON
	th2.idfFarm = tf.idfFarm
JOIN tlbSpecies ts ON
	ts.idfHerd = th2.idfHerd
JOIN tlbVaccination tv ON
	tv.idfSpecies = ts.idfSpecies
JOIN tlbVetCase tvc ON
	tvc.idfVetCase = tv.idfVetCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvc.idfVetCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
	
-- запоминаем записи таблицы tlbObservation, связанные с ранее отобранными записями таблицы tlbVetCase через tlbSpecies и tlbVaccination
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservation
	, NULL
FROM tlbObservation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbObservation'
JOIN tlbSpecies ts ON
	ts.idfObservation = [source].idfObservation
JOIN tlbVaccination tv ON
	tv.idfSpecies = ts.idfSpecies
JOIN tlbVetCase tvc ON
	tvc.idfVetCase = tv.idfVetCase
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvc.idfVetCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
	
-- запоминаем записи таблицы tlbObservation, связанные с ранее отобранными записями таблицы tlbVectorSurveillanceSession через hostvector
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservation
	, NULL
FROM tlbObservation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbObservation'
JOIN tlbVector tv ON
	tv.idfObservation = [source].idfObservation
JOIN tlbVector tv2 ON
	tv2.idfHostVector = tv.idfVector
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfVectorSurveillanceSession = tv2.idfVectorSurveillanceSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvss.idfVectorSurveillanceSession	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbVectorSurveillanceSession'
	
-- запоминаем записи таблицы tlbObservation, связанные с ранее отобранными записями таблицы tlbVectorSurveillanceSession
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservation
	, NULL
FROM tlbObservation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbObservation'
JOIN tlbVector tv ON
	tv.idfObservation = [source].idfObservation
JOIN tlbVectorSurveillanceSession tvss ON
	tvss.idfVectorSurveillanceSession = tv.idfVectorSurveillanceSession
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tvss.idfVectorSurveillanceSession
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbVectorSurveillanceSession'
	
-- запоминаем записи таблицы tlbObservation, связанные с ранее отобранными записями таблицы tlbHumanCase (idfEpiObservation)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservation
	, NULL
FROM tlbObservation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbObservation'
JOIN tlbHumanCase thc ON
	thc.idfEpiObservation = [source].idfObservation
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = thc.idfHumanCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
		
-- запоминаем записи таблицы tlbObservation, связанные с ранее отобранными записями таблицы tlbHumanCase (idfCSObservation)
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservation
	, NULL
FROM tlbObservation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbObservation'
JOIN tlbHumanCase thc ON
	thc.idfCSObservation = [source].idfObservation
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = thc.idfHumanCase	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
	
-- запоминаем записи таблицы tlbObservation, связанные с ранее отобранными записями таблицы tlbFarm
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservation
	, NULL
FROM tlbObservation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbObservation'
JOIN tlbSpecies ts ON
	ts.idfObservation = [source].idfObservation
JOIN tlbHerd th ON
	th.idfHerd = ts.idfHerd
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = th.idfFarm			
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbFarm'
	
-- запоминаем записи таблицы tlbObservation, связанные с ранее отобранными записями таблицы tlbFarm
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservation
	, NULL
FROM tlbObservation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbObservation'
JOIN tlbAnimal ta ON
	ta.idfObservation = [source].idfObservation
JOIN tlbSpecies ts ON
	ts.idfSpecies = ta.idfSpecies
JOIN tlbHerd th ON
	th.idfHerd = ts.idfHerd
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = th.idfFarm		
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbFarm'
	
-- запоминаем записи таблицы tlbObservation, связанные с ранее отобранными записями таблицы tlbMaterial через tlbBatchTest
-- и не участвующие в батчах, в которые входят тесты неподходящих материалов
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservation
	, NULL
FROM tlbObservation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbObservation'
JOIN tlbBatchTest tbt ON
	tbt.idfObservation = [source].idfObservation
JOIN tlbTesting ttest ON
	ttest.idfBatchTest= tbt.idfBatchTest
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = ttest.idfMaterial
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMaterial'
WHERE tbt.idfBatchTest NOT IN (
								SELECT 
									ttest2.idfBatchTest 
								FROM tlbTesting ttest2 
								LEFT JOIN ##RecordsForArchiving AllRecords
									JOIN @TablesForArchiving AllTables2 ON
										AllTables2.idTable = AllRecords.idTable
										AND AllTables2.nameTable = 'tlbMaterial'
									ON AllRecords.idRow1 = ttest2.idfMaterial 
								WHERE AllRecords.idRow1 IS NULL
									AND ttest2.idfBatchTest IS NOT NULL
								)

-- запоминаем записи таблицы tlbObservation, связанные с ранее отобранными записями таблицы tlbMaterial через tlbTesting
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservation
	, NULL
FROM tlbObservation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbObservation'
JOIN tlbTesting ttest ON
	ttest.idfObservation= [source].idfObservation
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = ttest.idfMaterial
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMaterial'
		
	
--34.
-- запоминаем записи таблицы tlbActivityParameters, связанные с ранее отобранными записями таблицы tlbObservation
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfActivityParameters
	, NULL
FROM tlbActivityParameters [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbActivityParameters'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfObservation
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbObservation'
		

--35.
-- запоминаем записи таблицы tlbVetCaseDisplayDiagnosis, связанные с ранее отобранными записями таблицы ##tCase
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfVetCase
	, [source].idfsLanguage
FROM tlbVetCaseDisplayDiagnosis [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbVetCaseDisplayDiagnosis'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfVetCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
	
		
----36.
---- запоминаем записи таблицы tlbMaterialOnSite, связанные с ранее отобранными записями таблицы tlbMaterial
--INSERT INTO ##RecordsForArchiving
--SELECT 
--	AllTables.idTable
--	, [source].idfMaterial
--	, [source].idfsSite
--FROM tlbMaterialOnSite [source]
--JOIN @TablesForArchiving AllTables ON
--	AllTables.nameTable = 'tlbMaterialOnSite'
--JOIN ##RecordsForArchiving AllRecords ON
--	AllRecords.idRow1 = [source].idfMaterial
--JOIN @TablesForArchiving AllTables2 ON
--	AllTables2.idTable = AllRecords.idTable
--	AND AllTables2.nameTable = 'tlbMaterial'
	
		
--37.
-- запоминаем записи таблицы tlbVetCase, связанные с ранее отобранными записями таблицы ##tCase
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfVetCase
	, NULL
FROM tlbVetCase [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbVetCase'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfVetCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
		
--38.
-- запоминаем записи таблицы tlbHumanCase, связанные с ранее отобранными записями таблицы ##tCase
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfHumanCase
	, NULL
FROM tlbHumanCase [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbHumanCase'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfHumanCase
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = '##tCase'
	
	
--39.
-- запоминаем записи таблицы tlbGeoLocationTranslation, связанные с ранее отобранными записями таблицы tlbGeoLocation
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocation
	, [source].idfsLanguage
FROM tlbGeoLocationTranslation [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbGeoLocationTranslation'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfGeoLocation	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbGeoLocation'
	
	
	
--39.
-- запоминаем записи таблицы tlbBasicSyndromicSurveillanceAggregateDetail, связанные с ранее отобранными записями таблицы tlbGeoLocation
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfAggregateDetail
	, NULL
FROM tlbBasicSyndromicSurveillanceAggregateDetail [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tlbBasicSyndromicSurveillanceAggregateDetail'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfAggregateHeader	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbBasicSyndromicSurveillanceAggregateHeader'
	
		
--удаление из списка локейшенов, которые из-за ошибки могли быть закреплены за разными объектами и при этом часть этих объектов не попала в выборку архивации
	DELETE AllRecords
	FROM ##RecordsForArchiving AllRecords
	LEFT JOIN (
				SELECT 
					th.idfCurrentResidenceAddress AS loc 
				FROM tlbHuman th 
				LEFT JOIN ##RecordsForArchiving AllRecords
					JOIN @TablesForArchiving AllTables2 ON
						AllTables2.idTable = AllRecords.idTable
						AND AllTables2.nameTable = 'tlbHuman' 
					ON AllRecords.idRow1 = th.idfHuman 
				WHERE AllRecords.idRow1 IS NULL
			) h1 ON h1.loc = AllRecords.idRow1
	LEFT JOIN (
				SELECT 
					th.idfEmployerAddress AS loc 
				FROM tlbHuman th 
				LEFT JOIN ##RecordsForArchiving AllRecords
					JOIN @TablesForArchiving AllTables2 ON
						AllTables2.idTable = AllRecords.idTable
						AND AllTables2.nameTable = 'tlbHuman' 
					ON AllRecords.idRow1 = th.idfHuman 
				WHERE AllRecords.idRow1 IS NULL
			) h2 ON h2.loc = AllRecords.idRow1
	LEFT JOIN (
				SELECT 
					th.idfRegistrationAddress AS loc 
				FROM tlbHuman th 
				LEFT JOIN ##RecordsForArchiving AllRecords
					JOIN @TablesForArchiving AllTables2 ON
						AllTables2.idTable = AllRecords.idTable
						AND AllTables2.nameTable = 'tlbHuman' 
					ON AllRecords.idRow1 = th.idfHuman 
				WHERE AllRecords.idRow1 IS NULL
			) h3 ON h3.loc = AllRecords.idRow1
	LEFT JOIN (
				SELECT 
					th.idfFarmAddress AS loc 
				FROM tlbFarm th 
				LEFT JOIN ##RecordsForArchiving AllRecords
					JOIN @TablesForArchiving AllTables2 ON
						AllTables2.idTable = AllRecords.idTable
						AND AllTables2.nameTable = 'tlbFarm' 
					ON  AllRecords.idRow1 = th.idfFarm 
				WHERE AllRecords.idRow1 IS NULL
			) h4 ON h4.loc = AllRecords.idRow1
	LEFT JOIN (
				SELECT 
					th.idfGeoLocation AS loc 
				FROM tlbOutbreak th 
				LEFT JOIN ##RecordsForArchiving AllRecords
					JOIN @TablesForArchiving AllTables2 ON
						AllTables2.idTable = AllRecords.idTable
						AND AllTables2.nameTable = 'tlbOutbreak' 
					ON AllRecords.idRow1 = th.idfOutbreak 
				WHERE AllRecords.idRow1 IS NULL
		) h6 ON h6.loc = AllRecords.idRow1
	JOIN @TablesForArchiving AllTables ON
		AllTables.nameTable = 'tlbGeoLocation'
	WHERE (
				h1.loc IS NOT NULL
				OR h2.loc IS NOT NULL
				OR h3.loc IS NOT NULL
				OR h4.loc IS NOT NULL
				OR h6.loc IS NOT NULL
			)
		AND AllRecords.idTable = AllTables.idTable


--40.
-- запоминаем записи таблицы tflAggrCaseFiltered, связанные с ранее отобранными записями таблицы tlbAggrCase
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfAggrCaseFiltered
	, NULL
FROM tflAggrCaseFiltered [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tflAggrCaseFiltered'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfAggrCase	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbAggrCase'
	
--41.
-- запоминаем записи таблицы tflBatchTestFiltered, связанные с ранее отобранными записями таблицы tlbBatchTest
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfBatchTestFiltered
	, NULL
FROM tflBatchTestFiltered [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tflBatchTestFiltered'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfBatchTest	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbBatchTest'
	
--42.
-- запоминаем записи таблицы tflBasicSyndromicSurveillanceAggregateHeaderFiltered, связанные с ранее отобранными записями таблицы tlbBasicSyndromicSurveillanceAggregateHeader
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfBasicSyndromicSurveillanceAggregateHeaderFiltered
	, NULL
FROM tflBasicSyndromicSurveillanceAggregateHeaderFiltered [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tflBasicSyndromicSurveillanceAggregateHeaderFiltered'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfAggregateHeader	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbBasicSyndromicSurveillanceAggregateHeader'
	
--43.
-- запоминаем записи таблицы tflBasicSyndromicSurveillanceFiltered, связанные с ранее отобранными записями таблицы tlbBasicSyndromicSurveillance
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfBasicSyndromicSurveillanceFiltered
	, NULL
FROM tflBasicSyndromicSurveillanceFiltered [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tflBasicSyndromicSurveillanceFiltered'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfBasicSyndromicSurveillance	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbBasicSyndromicSurveillance'
	
--44.
-- запоминаем записи таблицы tflFarmFiltered, связанные с ранее отобранными записями таблицы tlbFarm
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfFarmFiltered
	, NULL
FROM tflFarmFiltered [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tflFarmFiltered'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfFarm	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbFarm'
	
--45.
-- запоминаем записи таблицы tflGeoLocationFiltered, связанные с ранее отобранными записями таблицы tlbGeoLocation
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfGeoLocationFiltered
	, NULL
FROM tflGeoLocationFiltered [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tflGeoLocationFiltered'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfGeoLocation	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbGeoLocation'
	
--46.
-- запоминаем записи таблицы tflHumanCaseFiltered, связанные с ранее отобранными записями таблицы tlbHumanCase
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfHumanCaseFiltered
	, NULL
FROM tflHumanCaseFiltered [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tflHumanCaseFiltered'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfHumanCase	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbHumanCase'
	
--47.
-- запоминаем записи таблицы tflHumanFiltered, связанные с ранее отобранными записями таблицы tlbHuman
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfHumanFiltered
	, NULL
FROM tflHumanFiltered [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tflHumanFiltered'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfHuman	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbHuman'
	
--48.
-- запоминаем записи таблицы tflMonitoringSessionFiltered, связанные с ранее отобранными записями таблицы tlbMonitoringSession
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfMonitoringSessionFiltered
	, NULL
FROM tflMonitoringSessionFiltered [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tflMonitoringSessionFiltered'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfMonitoringSession	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbMonitoringSession'
	
--49.
-- запоминаем записи таблицы tflObservationFiltered, связанные с ранее отобранными записями таблицы tlbObservation
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfObservationFiltered
	, NULL
FROM tflObservationFiltered [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tflObservationFiltered'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfObservation	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbObservation'
	
--50.
-- запоминаем записи таблицы tflOutbreakFiltered, связанные с ранее отобранными записями таблицы tlbOutbreak
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfOutbreakFiltered
	, NULL
FROM tflOutbreakFiltered [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tflOutbreakFiltered'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfOutbreak	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbOutbreak'
	
--51.
-- запоминаем записи таблицы tflTransferOutFiltered, связанные с ранее отобранными записями таблицы tlbTransferOUT
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfTransferOutFiltered
	, NULL
FROM tflTransferOutFiltered [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tflTransferOutFiltered'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfTransferOut	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbTransferOUT'
	
--52.
-- запоминаем записи таблицы tflVectorSurveillanceSessionFiltered, связанные с ранее отобранными записями таблицы tlbVectorSurveillanceSession
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfVectorSurveillanceSessionFiltered
	, NULL
FROM tflVectorSurveillanceSessionFiltered [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tflVectorSurveillanceSessionFiltered'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfVectorSurveillanceSession	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbVectorSurveillanceSession'
	
--53.
-- запоминаем записи таблицы tflVetCaseFiltered, связанные с ранее отобранными записями таблицы tlbVetCase
INSERT INTO ##RecordsForArchiving
SELECT 
	AllTables.idTable
	, [source].idfVetCaseFiltered
	, NULL
FROM tflVetCaseFiltered [source]
JOIN @TablesForArchiving AllTables ON
	AllTables.nameTable = 'tflVetCaseFiltered'
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = [source].idfVetCase	
JOIN @TablesForArchiving AllTables2 ON
	AllTables2.idTable = AllRecords.idTable
	AND AllTables2.nameTable = 'tlbVetCase'


CREATE TABLE #TempTable (idTable BIGINT, idRow1 BIGINT, idRow2 BIGINT NULL)
INSERT INTO #TempTable
	(idTable, idRow1, idRow2)
SELECT * FROM ##RecordsForArchiving AllRecords



DECLARE @InsertSQL NVARCHAR(MAX) = N''
DECLARE @idTable INT, @OrderForDelete INT
DECLARE @TableName NVARCHAR(200) = N'', @IDColumnName NVARCHAR(200) = N'', @IDColumnName2 NVARCHAR(200) = N'', @ColumnName NVARCHAR (200) = N''


--- table
DECLARE _T CURSOR FOR
	SELECT 
		nameTable, idTable
	FROM @TablesForArchiving
	WHERE idTable > 0
	ORDER BY idTable
OPEN _T

FETCH NEXT FROM _T into @TableName, @idTable

WHILE @@FETCH_STATUS = 0
BEGIN	
		
	SET @InsertSQL = N''

	SET @InsertSQL = 
	N'INSERT INTO ' + @TargetServer + '.' + @TargetDataBase + '.dbo.' + @TableName
	+ NCHAR(13)+ NCHAR(10)
	
	SET @InsertSQL +=
	N'('	
	
	--insert fields
	DECLARE _C3 CURSOR FAST_FORWARD FOR
	SELECT
		a.COLUMN_NAME
	from INFORMATION_SCHEMA.COLUMNS as a
	JOIN sys.all_objects ao ON
		ao.[type] = 'U'
		AND ao.name = a.TABLE_NAME
	JOIN sys.all_columns ac ON
		ac.[object_id] = ao.[object_id]
		AND ac.name = a.COLUMN_NAME
	WHERE a.TABLE_NAME = @TableName
		AND ac.is_computed = 0 --no calculated field
	ORDER BY ORDINAL_POSITION	
	OPEN _C3
	
	FETCH NEXT FROM _C3 INTO @ColumnName
	
	SET @InsertSQL += N'
		' + @ColumnName
	
	WHILE @@FETCH_STATUS = 0
		BEGIN			
			SET @ColumnName = N''			
			
			FETCH NEXT FROM _C3 INTO @ColumnName
			
			IF @ColumnName <> N''
			SET @InsertSQL += N'
		, ' + @ColumnName
		END
	CLOSE _C3
	DEALLOCATE _C3
	
	SET @InsertSQL += NCHAR(13)+ NCHAR(10) +
	N')'	
	+ NCHAR(13)+ NCHAR(10)
	
	SET @InsertSQL +=
	N'SELECT DISTINCT'	
	
	--value fields
	DECLARE _C3 CURSOR FAST_FORWARD FOR
	SELECT
		a.COLUMN_NAME
	from INFORMATION_SCHEMA.COLUMNS as a
	JOIN sys.all_objects ao ON
		ao.[type] = 'U'
		AND ao.name = a.TABLE_NAME
	JOIN sys.all_columns ac ON
		ac.[object_id] = ao.[object_id]
		AND ac.name = a.COLUMN_NAME
	WHERE a.TABLE_NAME = @TableName
		AND ac.is_computed = 0 --no calculated field
	ORDER BY ORDINAL_POSITION	
	OPEN _C3
	
	FETCH NEXT FROM _C3 INTO @ColumnName
	
	SET @InsertSQL += N'
		' + @ColumnName
	
	WHILE @@FETCH_STATUS = 0
		BEGIN			
			SET @ColumnName = N''			
			
			FETCH NEXT FROM _C3 INTO @ColumnName
			
			IF @ColumnName <> N''
			SET @InsertSQL += N'
		, t.' + @ColumnName
		END
	CLOSE _C3
	DEALLOCATE _C3
	
	SET @InsertSQL += NCHAR(13)+ NCHAR(10) +
	N'FROM ' + @TableName + ' t'	
	+ NCHAR(13)+ NCHAR(10)
	
	SET @InsertSQL +=
	N'JOIN #TempTable tt ON'
	+ NCHAR(13)+ NCHAR(10)
	
	SET @InsertSQL +=
	N'	tt.idTable = ' + CAST(@idTable AS NVARCHAR(3))
	+ NCHAR(13)+ NCHAR(10)
	
	--- primary key	
	DECLARE _PK CURSOR FOR
	SELECT 
		a.COLUMN_NAME
	FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS a
	inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS b
	ON a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
	WHERE b.CONSTRAINT_TYPE = 'PRIMARY KEY'
		AND a.TABLE_NAME = @TableName
	ORDER BY a.ORDINAL_POSITION
	OPEN _PK

	FETCH NEXT FROM _PK INTO @IDColumnName

	IF @IDColumnName <> N''
	SET @InsertSQL += 
		N'	AND tt.idRow1 = t.' + @IDColumnName
		+ NCHAR(13)+ NCHAR(10)

	WHILE @@FETCH_STATUS = 0
		BEGIN 
			SET @IDColumnName2 = N''

			FETCH NEXT FROM _PK into @IDColumnName2
			
			IF @IDColumnName2 <> N''
			SET @InsertSQL += 
				N'	AND tt.idRow2 = t.' + @IDColumnName2
				+ NCHAR(13)+ NCHAR(10)
		END 

	CLOSE _PK
	DEALLOCATE _PK
	
	SET @InsertSQL +=
	N'DECLARE @RowCount NVARCHAR(5) = ''''
SELECT @RowCount = CAST(COUNT(*) AS VARCHAR(20)) FROM (SELECT DISTINCT idRow1, idRow2 FROM #TempTable tt WHERE tt.idTable = ' + CAST(@idTable AS NVARCHAR(3)) + ') x
PRINT ''' + @TableName + ':'' + @RowCount' 
	+ NCHAR(13)+ NCHAR(10)
	+ NCHAR(13)+ NCHAR(10)
	+ NCHAR(13)+ NCHAR(10)
 
	EXEC (@InsertSQL)
	
		
	FETCH NEXT FROM _T into @TableName, @idTable
	
	END
CLOSE _T
DEALLOCATE _T




PRINT'--------------------------------------------------------'


/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/








/*----------------------------------------------------------------------*/
/*Удаляем записи из фильтрационных таблиц, tstEvent, tstNotification, tstNotificationShared,   */      
/*tauDataAuditEvent и все tauDataAuditDetail, связанные с               */
/*отобранными записями определяющих и второстепенных таблиц             */
/*----------------------------------------------------------------------*/

PRINT''
PRINT'Deleting rows filter and audit tables Work DB'
PRINT'---------------------------------------------'
PRINT''


--tflNotificationFiltered
DELETE tnf
FROM tflNotificationFiltered tnf
JOIN tstNotification tn ON
	tn.idfNotification = tnf.idfNotification
WHERE tn.datCreationDate <= @ArchiveDate

PRINT'tflNotificationFiltered: ' + CAST(@@rowcount AS VARCHAR(20))
PRINT''

--tflNotification
DELETE tn
FROM tstNotification tn
WHERE tn.datCreationDate <= @ArchiveDate

PRINT'tflNotification: ' + CAST(@@rowcount AS VARCHAR(20))
PRINT''

--tstNotificationShared
DELETE tns
FROM tstNotificationShared tns
WHERE tns.datCreationDate <= @ArchiveDate

PRINT'tstNotificationShared: ' + CAST(@@rowcount AS VARCHAR(20))
PRINT''

--tstLocalConnectionContext
DELETE tlcc
FROM tstLocalConnectionContext tlcc
JOIN tstEvent te ON
	te.idfEventID = tlcc.idfEventID
	AND te.datEventDatatime <= @ArchiveDate
	
PRINT'tstLocalConnectionContext: ' + CAST(@@rowcount AS VARCHAR(20))
PRINT''

--tstEvent
DELETE te
FROM tstEvent te 
WHERE te.datEventDatatime <= @ArchiveDate

PRINT'tstEvent: ' + CAST(@@rowcount AS VARCHAR(20))
PRINT''

--tflDataAuditEventFiltered
DELETE tdaef
FROM tflDataAuditEventFiltered tdaef
JOIN tauDataAuditEvent tdae ON
	tdae.idfDataAuditEvent = tdaef.idfDataAuditEvent
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tdae.idfMainObject

PRINT'tflDataAuditEventFiltered: ' + CAST(@@rowcount AS VARCHAR(20))
PRINT''

--tau
DELETE tdadc
FROM tauDataAuditDetailCreate tdadc
JOIN tauDataAuditEvent tdae ON
	tdae.idfDataAuditEvent = tdadc.idfDataAuditEvent
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tdae.idfMainObject
	
PRINT'tauDataAuditDetailCreate: ' + CAST(@@rowcount AS VARCHAR(20))
PRINT''
	
DELETE tdadu
FROM tauDataAuditDetailDelete tdadu
JOIN tauDataAuditEvent tdae ON
	tdae.idfDataAuditEvent = tdadu.idfDataAuditEvent
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tdae.idfMainObject
	
PRINT'tauDataAuditDetailDelete: ' + CAST(@@rowcount AS VARCHAR(20))
PRINT''
	
DELETE tdadd
FROM tauDataAuditDetailUpdate tdadd
JOIN tauDataAuditEvent tdae ON
	tdae.idfDataAuditEvent = tdadd.idfDataAuditEvent
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tdae.idfMainObject
	
PRINT'tauDataAuditDetailUpdate: ' + CAST(@@rowcount AS VARCHAR(20))
PRINT''

DELETE tdadd
FROM tauDataAuditDetailRestore tdadd
JOIN tauDataAuditEvent tdae ON
	tdae.idfDataAuditEvent = tdadd.idfDataAuditEvent
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tdae.idfMainObject
	
PRINT'tauDataAuditDetailRestore: ' + CAST(@@rowcount AS VARCHAR(20))
PRINT''

--tstLocalConnectionContext
DELETE tlcc
FROM tstLocalConnectionContext tlcc
JOIN tauDataAuditEvent tdae ON
	tdae.idfDataAuditEvent = tlcc.idfDataAuditEvent
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tdae.idfMainObject
	
PRINT'tstLocalConnectionContext: ' + CAST(@@rowcount AS VARCHAR(20))
PRINT''
	
DELETE tdae
FROM tauDataAuditEvent tdae
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tdae.idfMainObject
	
PRINT'tauDataAuditEvent: ' + CAST(@@rowcount AS VARCHAR(20))
PRINT''
	
DELETE tdadc
FROM tauDataAuditDetailCreate tdadc
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tdadc.idfObject
	AND ISNULL(AllRecords.idRow2, -1) = ISNULL(tdadc.idfObjectDetail, -1)
	
PRINT'tauDataAuditDetailCreate: ' + CAST(@@rowcount AS VARCHAR(20))
PRINT''
	
DELETE tdadu
FROM tauDataAuditDetailDelete tdadu
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tdadu.idfObject
	AND ISNULL(AllRecords.idRow2, -1) = ISNULL(tdadu.idfObjectDetail, -1)
	
PRINT'tauDataAuditDetailDelete: ' + CAST(@@rowcount AS VARCHAR(20))
PRINT''
	
DELETE tdadd
FROM tauDataAuditDetailUpdate tdadd
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tdadd.idfObject
	AND ISNULL(AllRecords.idRow2, -1) = ISNULL(tdadd.idfObjectDetail, -1)
	
PRINT'tauDataAuditDetailUpdate: ' + CAST(@@rowcount AS VARCHAR(20))
PRINT''

DELETE tdadr
FROM tauDataAuditDetailRestore tdadr
JOIN ##RecordsForArchiving AllRecords ON
	AllRecords.idRow1 = tdadr.idfObject
	AND ISNULL(AllRecords.idRow2, -1) = ISNULL(tdadr.idfObjectDetail, -1)
	
PRINT'tauDataAuditDetailRestore: ' + CAST(@@rowcount AS VARCHAR(20))
PRINT''

PRINT'-----------------------------------'

--/*----------------------------------------------------------------------*/
--/*----------------------------------------------------------------------*/
--/*----------------------------------------------------------------------*/
--/*----------------------------------------------------------------------*/
--/*----------------------------------------------------------------------*/








/*----------------------------------------------------------------------*/
/*Удаляем скопированные записи определяющих							    */
/* и второстепенных таблиц таблиц										*/
/*----------------------------------------------------------------------*/

PRINT''
PRINT''
PRINT'Deleting rows tlb-tables'
PRINT'------------------------'
PRINT''




--- table
DECLARE _T CURSOR FOR
	SELECT 
		nameTable, idTable
	FROM @TablesForArchiving
	WHERE OrderForDelete > 0
	ORDER BY OrderForDelete
OPEN _T

FETCH NEXT FROM _T into @TableName, @idTable

WHILE @@FETCH_STATUS = 0
BEGIN	
	
	SET @InsertSQL = N''
	
	IF @TableName = 'tlbTesting'
	BEGIN
		SET @InsertSQL +=
		N'UPDATE t
SET t.idfMainTest = NULL,
	t.idfRootMaterial = NULL,
	t.idfParentMaterial = NULL
FROM tlbMaterial t
JOIN #TempTable tt ON
	tt.idTable = 30 --tlbMaterial
	AND tt.idRow1 = t.idfMaterial'
		+ NCHAR(13)+ NCHAR(10)
		+ NCHAR(13)+ NCHAR(10)
	END
	
	IF @TableName = 'tlbVector'
	BEGIN
		SET @InsertSQL +=
		N'DELETE t
FROM tlbVector t
JOIN tlbVector tv ON
	tv.idfVector = t.idfHostVector
JOIN #TempTable tt ON
	tt.idTable = 36 --tlbVector
	AND tt.idRow1 = tv.idfVector
JOIN #TempTable tt2 ON
	tt2.idTable = 36 --tlbVector
	AND tt2.idRow1 = t.idfHostVector	
PRINT ''tlbVector:'' + CAST(@@rowcount AS VARCHAR(20))'
		+ NCHAR(13)+ NCHAR(10)
		+ NCHAR(13)+ NCHAR(10)
	END

	
	SET @InsertSQL +=
	N'DELETE t FROM ' + @TableName + ' t'	
	+ NCHAR(13)+ NCHAR(10)
	
	SET @InsertSQL +=
	N'JOIN #TempTable tt ON'
	+ NCHAR(13)+ NCHAR(10)
	
	SET @InsertSQL +=
	N'	tt.idTable = ' + CAST(@idTable AS NVARCHAR(3))
	+ NCHAR(13)+ NCHAR(10)
	
	--- primary key	
	DECLARE _PK CURSOR FOR
	SELECT 
		a.COLUMN_NAME
	FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS a
	inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS b
	ON a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
	WHERE b.CONSTRAINT_TYPE = 'PRIMARY KEY'
		AND a.TABLE_NAME = @TableName
	ORDER BY a.ORDINAL_POSITION
	OPEN _PK

	FETCH NEXT FROM _PK INTO @IDColumnName

	IF @IDColumnName <> N''
	SET @InsertSQL += 
		N'	AND tt.idRow1 = t.' + @IDColumnName
		+ NCHAR(13)+ NCHAR(10)

	WHILE @@FETCH_STATUS = 0
		BEGIN 
			SET @IDColumnName2 = N''

			FETCH NEXT FROM _PK into @IDColumnName2
			
			IF @IDColumnName2 <> N''
			SET @InsertSQL += 
				N'	AND tt.idRow2 = t.' + @IDColumnName2
				+ NCHAR(13)+ NCHAR(10)
		END 

	CLOSE _PK
	DEALLOCATE _PK
	
	SET @InsertSQL += 
--	N'SELECT @RowCount = CAST(COUNT(*) AS VARCHAR(20)) FROM @tempGeoLocation
	N'PRINT ''' + @TableName + ':'' + CAST(@@rowcount AS VARCHAR(20))' 
	+ NCHAR(13)+ NCHAR(10)
	+ NCHAR(13)+ NCHAR(10)
	+ NCHAR(13)+ NCHAR(10)
 
--	PRINT @InsertSQL
	EXEC (@InsertSQL)
	
		
	FETCH NEXT FROM _T into @TableName, @idTable
	
	END
CLOSE _T
DEALLOCATE _T




PRINT''
PRINT'------------------------'
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/


DROP TABLE #TempTable
DROP TABLE ##tCase
DROP TABLE ##RecordsForArchiving

IF @@ERROR <> 0
--BEGIN
--	ROLLBACK TRAN
	RETURN 1
--END
ELSE
--BEGIN
--	COMMIT TRAN
	RETURN 0
--END


SET NOCOUNT OFF
SET XACT_ABORT OFF

