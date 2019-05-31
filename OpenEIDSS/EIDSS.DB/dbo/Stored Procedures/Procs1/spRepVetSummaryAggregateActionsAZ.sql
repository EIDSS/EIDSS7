
--##SUMMARY

--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec spRepVetSummaryAggregateActionsAZ 
'en', 
N'2015-10-01 00:00:00.000',
N'2015-12-31 00:00:00.000',
51740560000000,
'<ItemList><Item key="49558310000000" value=""/><Item key="49558320000000" value=""/><Item key="49558330000000" value=""/></ItemList>',
51740610000000

*/ 


CREATE PROCEDURE [dbo].[spRepVetSummaryAggregateActionsAZ]
(
	 @LangID			AS NVARCHAR(50),
	 @SD				AS DATETIME, 
	 @ED				AS DATETIME,
	 @Diagnosis			AS BIGINT,
	 @SpeciesType		AS XML,
	 @InvestigationOrMeasureType BIGINT
)
AS

/*
	DECLARE @LangID		AS NVARCHAR(50) = 'en',
		@SD				AS DATETIME = N'2015-10-01 00:00:00.000', 
		@ED				AS DATETIME = N'2015-12-31 00:00:00.000',
		@Diagnosis		AS BIGINT = 51740560000000/*51739460000000*/,
		@SpeciesType	AS XML = '<ItemList><Item key="49558310000000" value=""/><Item key="49558320000000" value=""/><Item key="49558330000000" value=""/></ItemList>',
		@InvestigationOrMeasureType BIGINT = 51740610000000/*51740620000000*/
*/

	DECLARE @InvestigationOrMeasure AS BIT
	DECLARE @SDDate AS DATETIME
	DECLARE @EDDate AS DATETIME
	DECLARE @CountryID BIGINT
	DECLARE @iSpeciesType INT
	
	DECLARE @idfsRegionBaku BIGINT,
		@idfsRegionOtherRayons BIGINT,
		@idfsRegionNakhichevanAR BIGINT
		
		
	DECLARE @sql AS NVARCHAR (MAX) = ''

	
	SET @SDDate=dbo.fn_SetMinMaxTime(CAST(@SD AS DATETIME),0)
	SET @EDDate=dbo.fn_SetMinMaxTime(CAST(@ED AS DATETIME),1)
	
	SET @CountryID = 170000000
	
	SELECT 
		@InvestigationOrMeasure =
			CASE tbr.idfsReferenceType
				WHEN 19000021 /*Diagnostic Investigation List*/ THEN 0
				WHEN 19000074 /*Prophylactic Measure List*/ THEN 1
			END
	FROM trtBaseReference tbr
	WHERE tbr.intRowStatus = 0
		AND tbr.idfsBaseReference = @InvestigationOrMeasureType
				

	EXEC sp_xml_preparedocument @iSpeciesType OUTPUT, @SpeciesType

	DECLARE @SpeciesTypeTable AS TABLE
	(
		[key] NVARCHAR(300)
	)
	
	INSERT INTO @SpeciesTypeTable 
	(
		[key]
	)	
	SELECT 
		* 
	FROM OPENXML (@iSpeciesType, '/ItemList/Item')
	WITH ([key] BIGINT '@key')

	EXEC sp_xml_removedocument @iSpeciesType	


	--1344330000000 --Baku
	SELECT
		@idfsRegionBaku = fgr.idfsReference
	FROM dbo.fnGisReference('en', 19000003) fgr
	WHERE fgr.name = N'Baku'

	--1344340000000 --Other rayons
	SELECT
		@idfsRegionOtherRayons = fgr.idfsReference
	FROM dbo.fnGisReference('en', 19000003) fgr
	WHERE fgr.name = N'Other rayons'

	--1344350000000 --Nakhichevan AR
	SELECT
		@idfsRegionNakhichevanAR = fgr.idfsReference
	FROM dbo.fnGisReference('en', 19000003) fgr
	WHERE fgr.name = N'Nakhichevan AR'  
	
	
	
	DECLARE @idfsCurrentCountry	BIGINT
	SELECT @idfsCurrentCountry = ISNULL(dbo.fnCurrentCountry(), 170000000) /*Azerbaijan*/
		
	DECLARE @AggrCase TABLE (
		idfAggrCase BIGINT
		, idfObservation BIGINT
		, idfAggrActionMTX BIGINT
		, idfsSpeciesType BIGINT
		, idfsRegion BIGINT
		, idfsRayon BIGINT
		, idfsAdministrativeUnit BIGINT
		, datStartDate DATETIME
		, datFinishDate DATETIME
	)
	
	
	;WITH NotDeletedDiagnosis AS (
		SELECT
			CAST(r_d.[name] AS NVARCHAR(2000)) AS [name]
			, ISNULL(r_d.idfsReference,d_actual.idfsDiagnosis) AS idfsDiagnosis
			, ISNULL(d_actual.idfsDiagnosis, r_d.idfsReference) AS idfsActualDiagnosis
			, ROW_NUMBER() OVER (PARTITION BY ISNULL(r_d.idfsReference,d_actual.idfsDiagnosis) ORDER BY ISNULL(d_actual.idfsDiagnosis, r_d.idfsReference)) AS rn
		FROM fnReferenceRepair(@LangID, 19000019) r_d
		LEFT JOIN trtDiagnosis d_actual
			JOIN fnReference(@LangID, 19000019) r_d_actual ON
				r_d_actual.idfsReference = d_actual.idfsDiagnosis
		ON r_d_actual.[name] = r_d.[name] COLLATE Cyrillic_General_CI_AS
			AND d_actual.idfsUsingType = 10020002	/*Aggregate Case*/
			AND d_actual.intRowStatus = 0
	)
	, NotDeletedSpecies AS (
		SELECT
			CAST(r_sp.[name] AS NVARCHAR(2000)) AS [name]
			, ISNULL(r_sp.idfsReference, st_actual.idfsSpeciesType) AS idfsSpeciesType
			, ISNULL(st_actual.idfsSpeciesType, r_sp.idfsReference) AS idfsActualSpeciesType
			, ROW_NUMBER() OVER (PARTITION BY ISNULL(r_sp.idfsReference, st_actual.idfsSpeciesType) ORDER BY ISNULL(st_actual.idfsSpeciesType, r_sp.idfsReference)) AS rn
		FROM fnReferenceRepair(@LangID, 19000086) r_sp
		LEFT JOIN trtSpeciesType st_actual
			JOIN fnReference(@LangID, 19000086) r_sp_actual on	
				r_sp_actual.idfsReference = st_actual.idfsSpeciesType
		ON r_sp_actual.[name] = r_sp.[name] COLLATE Cyrillic_General_CI_AS
			AND st_actual.intRowStatus = 0
	)
	
	
	INSERT INTO @AggrCase
	SELECT
		tac.idfAggrCase
		, tac.idfDiagnosticObservation
		, tadam.idfAggrDiagnosticActionMTX
		, Actual_Species_Type.idfsActualSpeciesType
		, COALESCE(s.idfsRegion, rr.idfsRegion, r.idfsRegion, NULL) AS idfsRegion
		, COALESCE(s.idfsRayon, rr.idfsRayon, NULL) AS idfsRayon
		, tac.idfsAdministrativeUnit
		, tac.datStartDate
		, tac.datFinishDate
	FROM tlbAggrCase tac
	JOIN tlbAggrDiagnosticActionMTX tadam ON
		tadam.idfVersion = tac.idfDiagnosticVersion
		AND tadam.intRowStatus = 0
		AND tadam.idfsDiagnosticAction = @InvestigationOrMeasureType
		
	JOIN NotDeletedDiagnosis AS Actual_Diagnosis ON
		Actual_Diagnosis.idfsDiagnosis = tadam.idfsDiagnosis
		AND Actual_Diagnosis.rn = 1
		AND Actual_Diagnosis.idfsActualDiagnosis = @Diagnosis
		
	JOIN NotDeletedSpecies AS Actual_Species_Type ON
		Actual_Species_Type.idfsSpeciesType = tadam.idfsSpeciesType
		AND Actual_Species_Type.rn = 1
	JOIN @SpeciesTypeTable stt ON
		stt.[key] = Actual_Species_Type.idfsActualSpeciesType
		
	LEFT JOIN gisCountry c ON
		c.idfsCountry = tac.idfsAdministrativeUnit
	LEFT JOIN gisRegion r ON
		r.idfsRegion = tac.idfsAdministrativeUnit 
		AND r.idfsCountry = @idfsCurrentCountry
	LEFT JOIN gisRayon rr ON
		rr.idfsRayon = tac.idfsAdministrativeUnit
		AND rr.idfsCountry = @idfsCurrentCountry
	LEFT JOIN gisSettlement s ON
		s.idfsSettlement = tac.idfsAdministrativeUnit
		AND s.idfsCountry = @idfsCurrentCountry
		
	WHERE @InvestigationOrMeasure = 0
		AND tac.intRowStatus = 0
		AND tac.idfsAggrCaseType = 10102003 /*Vet Aggregate Action*/
		AND tac.datStartDate >= @SDDate
		AND tac.datFinishDate < @EDDate
	UNION ALL
	SELECT
		tac.idfAggrCase
		, tac.idfProphylacticObservation
		, tapam.idfAggrProphylacticActionMTX
		, Actual_Species_Type.idfsActualSpeciesType
		, COALESCE(s.idfsRegion, rr.idfsRegion, r.idfsRegion, NULL) AS idfsRegion
		, COALESCE(s.idfsRayon, rr.idfsRayon, NULL) AS idfsRayon
		, tac.idfsAdministrativeUnit
		, tac.datStartDate
		, tac.datFinishDate
	FROM tlbAggrCase tac
	JOIN tlbAggrProphylacticActionMTX tapam ON
		tapam.idfVersion = tac.idfProphylacticVersion
		AND tapam.intRowStatus = 0
		AND tapam.idfsProphilacticAction = @InvestigationOrMeasureType
		
	JOIN NotDeletedDiagnosis AS Actual_Diagnosis ON
		Actual_Diagnosis.idfsDiagnosis = tapam.idfsDiagnosis
		AND Actual_Diagnosis.rn = 1
		AND Actual_Diagnosis.idfsActualDiagnosis = @Diagnosis
		
	JOIN NotDeletedSpecies AS Actual_Species_Type ON
		Actual_Species_Type.idfsSpeciesType = tapam.idfsSpeciesType
		AND Actual_Species_Type.rn = 1
	JOIN @SpeciesTypeTable stt ON
		stt.[key] = Actual_Species_Type.idfsActualSpeciesType
	
	LEFT JOIN gisCountry c ON
		c.idfsCountry = tac.idfsAdministrativeUnit
	LEFT JOIN gisRegion r ON
		r.idfsRegion = tac.idfsAdministrativeUnit 
		AND r.idfsCountry = @idfsCurrentCountry
	LEFT JOIN gisRayon rr ON
		rr.idfsRayon = tac.idfsAdministrativeUnit
		AND rr.idfsCountry = @idfsCurrentCountry
	LEFT JOIN gisSettlement s ON
		s.idfsSettlement = tac.idfsAdministrativeUnit
		AND s.idfsCountry = @idfsCurrentCountry
		
	WHERE @InvestigationOrMeasure = 1
		AND tac.intRowStatus = 0
		AND tac.idfsAggrCaseType = 10102003 /*Vet Aggregate Action*/
		AND tac.datStartDate >= @SDDate
		AND tac.datFinishDate < @EDDate
		
		
	DECLARE @MinAdminLevel BIGINT
	DECLARE @MinTimeInterval BIGINT

	SELECT	
		@MinAdminLevel = idfsStatisticAreaType
		, @MinTimeInterval = idfsStatisticPeriodType
	FROM fnAggregateSettings (10102003 /*Vet Aggregate Action*/)
	

	DELETE FROM @AggrCase
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
			FROM @AggrCase ac
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
				
			JOIN @AggrCase ac2 ON
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

		


	DECLARE @TestedCnt TABLE (
		idfAggrCase BIGINT
		--, idfObservation BIGINT
		--, idfAggrActionMTX BIGINT
		, idfsSpeciesType BIGINT
		, idfsRegion BIGINT
		, idfsRayon BIGINT
		, idfTestedCount INT
	)
	
	INSERT INTO @TestedCnt
	SELECT
		ag.idfAggrCase
		--, ag.idfObservation
		--, ag.idfAggrActionMTX
		, ag.idfsSpeciesType
		, ag.idfsRegion
		, ag.idfsRayon
		, CAST(tap.varValue AS INT)
	FROM @AggrCase ag 
	JOIN tlbActivityParameters tap ON
		tap.idfObservation = ag.idfObservation
		AND tap.idfRow = ag.idfAggrActionMTX
	JOIN ffParameter fp ON
		fp.idfsParameter = tap.idfsParameter
	JOIN trtBaseReference tbr ON
		tbr.idfsBaseReference = fp.idfsFormType
		AND tbr.idfsReferenceType = 19000034 /*Flexible Form Type*/
		AND tbr.strDefault = 'Diagnostic investigations' --'Vet Aggregate Diagnostic Investigations'
	JOIN trtBaseReference tbr2 ON
		tbr2.idfsBaseReference = fp.idfsParameter
		AND tbr2.idfsReferenceType = 19000066 /*Flexible Form Parameter Tooltip*/
		AND tbr2.strDefault = 'Tested'
		AND tbr2.intRowStatus = 0
	WHERE @InvestigationOrMeasure = 0
		AND SQL_VARIANT_PROPERTY(tap.varValue, 'BaseType') IN ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
	
	
	DECLARE @PositiveCnt TABLE (
		idfAggrCase BIGINT
		--, idfObservation BIGINT
		--, idfAggrActionMTX BIGINT
		, idfsSpeciesType BIGINT
		, idfsRegion BIGINT
		, idfsRayon BIGINT
		, idfPositiveCount INT
	)
	
	INSERT INTO @PositiveCnt
	SELECT
		ag.idfAggrCase
		--, ag.idfObservation
		--, ag.idfAggrActionMTX
		, ag.idfsSpeciesType
		, ag.idfsRegion
		, ag.idfsRayon
		, CAST(tap.varValue AS INT)
	FROM @AggrCase ag 
	JOIN tlbActivityParameters tap ON
		tap.idfObservation = ag.idfObservation
		AND tap.idfRow = ag.idfAggrActionMTX
	JOIN ffParameter fp ON
		fp.idfsParameter = tap.idfsParameter
	JOIN trtBaseReference tbr ON
		tbr.idfsBaseReference = fp.idfsFormType
		AND tbr.idfsReferenceType = 19000034 /*Flexible Form Type*/
		AND tbr.strDefault = 'Diagnostic investigations' --'Vet Aggregate Diagnostic Investigations'
	JOIN trtBaseReference tbr2 ON
		tbr2.idfsBaseReference = fp.idfsParameter
		AND tbr2.idfsReferenceType = 19000066 /*Flexible Form Parameter Tooltip*/
		AND tbr2.strDefault = 'Positive reaction taken (ea)'
		AND tbr2.intRowStatus = 0
	WHERE @InvestigationOrMeasure = 0
		AND SQL_VARIANT_PROPERTY(tap.varValue, 'BaseType') IN ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
		AND EXISTS (SELECT 1 FROM @TestedCnt tc WHERE tc.idfAggrCase = ag.idfAggrCase)
	
	DECLARE @ActionTakenCnt TABLE (
		idfAggrCase BIGINT
		--, idfObservation BIGINT
		--, idfAggrActionMTX BIGINT
		, idfsSpeciesType BIGINT
		, idfsRegion BIGINT
		, idfsRayon BIGINT
		, idfActionTakenCount INT
	)
	
	INSERT INTO @ActionTakenCnt
	SELECT
		ag.idfAggrCase
		--, ag.idfObservation
		--, ag.idfAggrActionMTX
		, ag.idfsSpeciesType
		, ag.idfsRegion
		, ag.idfsRayon
		, CAST(tap.varValue AS INT)
	FROM @AggrCase ag 
	JOIN tlbActivityParameters tap ON
		tap.idfObservation = ag.idfObservation
		AND tap.idfRow = ag.idfAggrActionMTX
	JOIN ffParameter fp ON
		fp.idfsParameter = tap.idfsParameter
	JOIN trtBaseReference tbr ON
		tbr.idfsBaseReference = fp.idfsFormType
		AND tbr.idfsReferenceType = 19000034 /*Flexible Form Type*/
		AND tbr.strDefault = 'Treatment-prophylactics and vaccination measures'
	JOIN trtBaseReference tbr2 ON
		tbr2.idfsBaseReference = fp.idfsParameter
		AND tbr2.idfsReferenceType = 19000066 /*Flexible Form Parameter Tooltip*/
		AND tbr2.strDefault = 'Action taken (ea)'
		AND tbr2.intRowStatus = 0
	WHERE @InvestigationOrMeasure = 1
		AND SQL_VARIANT_PROPERTY(tap.varValue, 'BaseType') IN ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
	
	
	
	DECLARE @cmd NVARCHAR(MAX)
	
	IF OBJECT_ID('tempdb..##AggrCase') IS NOT NULL
	BEGIN
		SET @cmd = N'
			DROP TABLE ##AggrCase
		'
		EXECUTE sp_executesql @cmd 
	END
	
	IF @InvestigationOrMeasure = 0 /*Diagnostic Investigation List*/ 
		SET @cmd = N'
			CREATE TABLE ##AggrCase
			(
				idfsRegion BIGINT
				, idfsRayon BIGINT
				, idfsSpeciesType BIGINT
				, CntTested INT
				, CntPositive INT
			)	
		'
	ELSE
		SET @cmd = N'
			CREATE TABLE ##AggrCase
			(
				idfsRegion BIGINT
				, idfsRayon BIGINT
				, idfsSpeciesType BIGINT
				, CntActionTaken INT
			)	
		'
	EXECUTE sp_executesql @cmd 
	
	IF @InvestigationOrMeasure = 0
		INSERT INTO ##AggrCase
		SELECT
			tc.idfsRegion
			, tc.idfsRayon
			, tc.idfsSpeciesType
			, SUM(idfTestedCount)
			, SUM(ISNULL(pc.idfPositiveCount, 0))
		FROM @TestedCnt tc
		LEFT JOIN @PositiveCnt pc ON
			pc.idfAggrCase = tc.idfAggrCase
			AND pc.idfsSpeciesType = tc.idfsSpeciesType
		GROUP BY tc.idfsRegion
			, tc.idfsRayon
			, tc.idfsSpeciesType
	ELSE
		INSERT INTO ##AggrCase
		SELECT
			tc.idfsRegion
			, tc.idfsRayon
			, tc.idfsSpeciesType
			, SUM(tc.idfActionTakenCount)
		FROM @ActionTakenCnt tc
		GROUP BY tc.idfsRegion
			, tc.idfsRayon
			, tc.idfsSpeciesType
			
	
	DECLARE @SpeciesToDiagnosis AS TABLE (
			RowNumber INT
			, SpeciesTypeId BIGINT
			, SpeciesTypeName NVARCHAR(2000)
		)	
		
	INSERT INTO @SpeciesToDiagnosis (RowNumber, SpeciesTypeId, SpeciesTypeName)
	SELECT
		ROW_NUMBER() OVER (ORDER BY ref_spec.[name])
		, ref_spec.idfsReference
		, ref_spec.name
	FROM dbo.fnReference(@LangID, 19000086) ref_spec
	JOIN @SpeciesTypeTable stt ON
		stt.[key] = ref_spec.idfsReference
	/*SELECT
		ROW_NUMBER() OVER (ORDER BY ref_spec.[name])
		, ag.idfsSpeciesType
		, ref_spec.name
	FROM ##AggrCase ag
	JOIN dbo.fnReference(@LangID, 19000086) ref_spec ON
		ref_spec.idfsReference = ag.idfsSpeciesType
	GROUP BY ag.idfsSpeciesType
		, ref_spec.[name]*/

	
	DECLARE @SpeciesTypeId BIGINT = 0
		, @SpeciesTypeNum INT
		, @SpeciesTypeName NVARCHAR(2000)

	SELECT @sql = N'
		SELECT
			CASE ray.idfsRegion 
				WHEN @idfsRegionBaku THEN 1 
				WHEN @idfsRegionOtherRayons THEN 2
				WHEN @idfsRegionNakhichevanAR THEN 3
				ELSE 0
			END AS intRegionOrder
			, refReg.[name] AS strRegion
			, refRay.[name] AS strRayon'
			
			IF @InvestigationOrMeasure = 0
				SET @Sql += N', 2 AS intSubcolumnCount'
			ELSE
				SET @Sql += N', 1 AS intSubcolumnCount'
				
			--���������� ������� ����� ��������
			DECLARE _Species CURSOR FOR
				SELECT 
					SpeciesTypeId
					, RowNumber
					, SpeciesTypeName
				FROM @SpeciesToDiagnosis
				ORDER BY RowNumber
			OPEN _Species

			FETCH NEXT FROM _Species INTO @SpeciesTypeId, @SpeciesTypeNum, @SpeciesTypeName

			WHILE @@FETCH_STATUS = 0
				BEGIN 
					SET @Sql += N'
	, MAX(N''' + replace(@SpeciesTypeName, N'''', N'''''') + N''') AS strSpecies_' + CAST(@SpeciesTypeNum AS NVARCHAR)
					
				IF @InvestigationOrMeasure = 0
				BEGIN
					SET @Sql += N'
	, MAX(CASE WHEN ag.idfsSpeciesType =  ' + CAST(@SpeciesTypeId AS NVARCHAR) + N' THEN ag.CntTested ELSE NULL END) AS intFirstSubcolumn_' + CAST(@SpeciesTypeNum AS NVARCHAR)
			
					SET @Sql += N'
	, MAX(CASE WHEN ag.idfsSpeciesType =  ' + CAST(@SpeciesTypeId AS NVARCHAR) + N' THEN ag.CntPositive ELSE NULL END) AS intSecondSubcolumn_' + CAST(@SpeciesTypeNum AS NVARCHAR)
				END
				ELSE
					SET @Sql += N'
	, MAX(CASE WHEN ag.idfsSpeciesType =  ' + CAST(@SpeciesTypeId AS NVARCHAR) + N' THEN ag.CntActionTaken ELSE NULL END) AS intFirstSubcolumn_' + CAST(@SpeciesTypeNum AS NVARCHAR)
						
								
					FETCH NEXT FROM _Species INTO @SpeciesTypeId, @SpeciesTypeNum, 	@SpeciesTypeName		
				END 

			CLOSE _Species
			DEALLOCATE _Species		
				
		
			
	SELECT @sql += N'
		FROM gisRegion AS reg
		JOIN fnGisReference(@LangID, 19000003 /*rftRegion*/) AS refReg ON
			reg.idfsRegion = refReg.idfsReference			
			AND reg.idfsCountry = @CountryID
		JOIN gisRayon AS ray ON 
			ray.idfsRegion = reg.idfsRegion	
		JOIN fnGisReference(@LangID, 19000002 /*rftRayon*/) AS refRay ON
			ray.idfsRayon = refRay.idfsReference
			
		LEFT JOIN ##AggrCase ag ON
			ag.idfsRegion = ray.idfsRegion
			AND ag.idfsRayon = ray.idfsRayon
			
		LEFT JOIN dbo.fnReference(@LangID, 19000086) ref_spec ON
			ref_spec.idfsReference = ag.idfsSpeciesType
			
		GROUP BY CASE ray.idfsRegion 
					WHEN @idfsRegionBaku THEN 1 
					WHEN @idfsRegionOtherRayons THEN 2
					WHEN @idfsRegionNakhichevanAR THEN 3
					ELSE 0
				END
				, refReg.[name]
				, refRay.[name]

		ORDER BY intRegionOrder, strRayon
	'

	--PRINT @sql
	
	EXEC sp_executesql @sql
		, N'@idfsRegionBaku BIGINT
			, @idfsRegionOtherRayons BIGINT
			, @idfsRegionNakhichevanAR BIGINT
			, @LangID NVARCHAR(50)
			, @CountryID BIGINT'
		, @idfsRegionBaku = @idfsRegionBaku
		, @idfsRegionOtherRayons = @idfsRegionOtherRayons
		, @idfsRegionNakhichevanAR = @idfsRegionNakhichevanAR
		, @LangID = @LangID
		, @CountryID = @CountryID
		
		
	IF OBJECT_ID('tempdb..##AggrCase') IS NOT NULL
	BEGIN
		SET @cmd = N'
			DROP TABLE ##AggrCase
		'
		EXECUTE sp_executesql @cmd 
	END
	

