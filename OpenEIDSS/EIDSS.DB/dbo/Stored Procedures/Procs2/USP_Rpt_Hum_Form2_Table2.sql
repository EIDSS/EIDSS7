
--------======================================================================================
-- Name 				: USP_Rpt_Hum_Form2_Table2
-- Description			: Get Form 2 Table 2 for UA 
--          
-- Author               : Mark Wilson 11/30/2017
-- Revision History
--		Name       Date       Change Detail

--testing code:
----exec USP_Rpt_Hum_Form2_Table2 'en', 2014, 11111111
--------======================================================================================

CREATE  PROCEDURE [dbo].[USP_Rpt_Hum_Form2_Table2]
	@LangID				AS VARCHAR(36),
	@Year				AS INT, 
	@Month				AS INT = NULL,
	@RegionID			AS BIGINT = NULL

AS

BEGIN
	BEGIN TRY

		DECLARE @returnCode		INT = 0
				,@returnMsg		NVARCHAR(MAX) = 'SUCCESS'

		EXEC dbo.USP_GBL_FIRSTDAY_SET
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Declare table to hold report data for Ukraine, Form2 Table2
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------		
		DECLARE	@Form2Table2	
		TABLE
			(
			idfsBaseReference	BIGINT NOT NULL PRIMARY KEY
			,idfsReferenceType	BIGINT NOT NULL
			,strDiseaseName		NVARCHAR(300) COLLATE DATABASE_DEFAULT NOT NULL
			,strICD10			NVARCHAR(200) COLLATE DATABASE_DEFAULT NULL
			,intOrder			INT NOT NULL
			,intTotal			NVARCHAR(20) NOT NULL
			,intAge_0_17		NVARCHAR(20) NOT NULL
			,intAge_0_1			NVARCHAR(20) NOT NULL
			,intAge_1_4			NVARCHAR(20) NOT NULL
			,intAge_5_9			NVARCHAR(20) NOT NULL
			,intAge_10_14		NVARCHAR(20) NOT NULL
			,intAge_15_17		NVARCHAR(20) NOT NULL
			,intRuralTotal		NVARCHAR(20) NOT NULL
			,intRuralAge_0_17	NVARCHAR(20) NOT NULL

			)

		INSERT INTO @Form2Table2
			(
			idfsBaseReference
			,idfsReferenceType
			,strDiseaseName
			,strICD10
			,intOrder
			,intTotal
			,intAge_0_17
			,intAge_0_1
			,intAge_1_4
			,intAge_5_9
			,intAge_10_14
			,intAge_15_17
			,intRuralTotal
			,intRuralAge_0_17
			)
			SELECT
				idfsBaseReference
				,idfsReferenceType
				,DiagnosisDesc
				,ICD10
				,RowOrder
				,'0'
				,'0'
				,'0'
				,'0'
				,'0'
				,'0'
				,'0'
				,'0'
				,'0'
			FROM
				dbo.FN_Rpt_List('UA Form #2 - Table2', @LangID)
				
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- table to hold Diagnosis that won't be displayed for some agg data
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
		DECLARE @RuleOutDiagnosis_x 
		TABLE
		(
			icd10 NVARCHAR(100)
		)

		INSERT INTO @RuleOutDiagnosis_x

		SELECT
			D.strIDC10

		FROM dbo.trtDiagnosis D
		LEFT JOIN dbo.trtBaseReference R on R.idfsBaseReference = D.idfsDiagnosis
		WHERE R.strDefault IN
		(
		'Tularaemia',
		'Anthrax',
		'Brucellosis',
		'Leptospirosis',
		'Rickettsioses ', 
		'Brill disease', 
		'Typhus fever',
		'Spotted fever',
		'Rabies',
		'Tick-borne viral encephalitis',
		'Viral fever and viral hemorrhagic fever',
		'West Nile fever',
		'Including West Nile fever',
		'Haemorrhagic fever with renal syndrome',
		'Malaria',
		'Acute upper respiratory infections',
		'Influenza',
		'Carriers of malaria'

		)

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- Table to hold Human Case Data		
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
		DECLARE @HumanCase dbo.UDT_HumanCasesForReport

		INSERT INTO @HumanCase
		SELECT
			HumanCase.idfHumanCase
			,HumanCase.intNotificationMonth
			,HumanCase.intNotificationYear
			,HumanCase.AgeYears
			,HumanCase.AgeMonths
			,HumanCase.idfsRegion
			,HumanCase.idfsDiagnosis
			,trtDiagnosis.strIDC10
			,HumanCase.idfsReportDiagnosisGp
			,CurrentDiagnosis.strIDC10 As CurrentDiagICD10
		FROM dbo.FN_Rpt_HumanCase_List(@Year, @RegionID) HumanCase
			INNER JOIN trtDiagnosis On
				HumanCase.idfsDiagnosis = trtDiagnosis.idfsDiagnosis		
			LEFT OUTER JOIN tlbChangeDiagnosisHistory On
				HumanCase.idfHumanCase = tlbChangeDiagnosisHistory.idfHumanCase
			LEFT OUTER JOIN trtDiagnosis CurrentDiagnosis On
				tlbChangeDiagnosisHistory.idfsCurrentDiagnosis = CurrentDiagnosis.idfsDiagnosis

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Add the results from HumanCase table to Ukraine Form 2, Table 2
----------------------------------------------------------------------------------
		DECLARE	@idfsBaseReference BIGINT

		--Get diagnosic and count

		DECLARE	@idfsDiagnosis	BIGINT
				,@strIDC10		NVARCHAR(400)

		DECLARE 
			Rpt_Diag_Cursor 
		CURSOR FOR   
			SELECT
				RptTlb.idfsBaseReference
				,trtDiagnosis.idfsDiagnosis
				,trtDiagnosis.strIDC10
			FROM
				@Form2Table2 As RptTlb
				INNER JOIN trtDiagnosisToGroupForReportType On
					RptTlb.idfsBaseReference = trtDiagnosisToGroupForReportType.idfsReportDiagnosisGroup
				INNER JOIN trtDiagnosis On
					trtDiagnosisToGroupForReportType.idfsDiagnosis = trtDiagnosis.idfsDiagnosis
					And
					IsNull(trtDiagnosis.intRowStatus, 0) = 0
			
			UNION ALL

			SELECT
				RptTlb.idfsBaseReference
				,trtDiagnosis.idfsDiagnosis
				,trtDiagnosis.strIDC10
			FROM
				@Form2Table2 As RptTlb
				Inner Join trtDiagnosis On
					RptTlb.idfsBaseReference = trtDiagnosis.idfsDiagnosis
					And
					IsNull(trtDiagnosis.intRowStatus, 0) = 0

		OPEN Rpt_Diag_Cursor;

		FETCH NEXT FROM 
			Rpt_Diag_Cursor
		INTO 
			@idfsBaseReference
			,@idfsDiagnosis
			,@strIDC10

		WHILE @@FETCH_STATUS = 0  

			BEGIN  

				UPDATE @Form2Table2
				SET 
					intTotal		+=	dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, @Month, 0, 100)
					,intAge_0_17	+=	dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, @Month, 0, 17)
					,intAge_0_1		+=	dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, @Month, 0, 0)
					,intAge_1_4		+=	dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, @Month, 1, 4)
					,intAge_5_9		+=	dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, @Month, 5, 9)
					,intAge_10_14	+=	dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, @Month, 10, 14)
					,intAge_15_17	+=	dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, @Month, 15, 17)
				WHERE
					idfsBaseReference = @idfsBaseReference

				--Count When dianosis is А03.1 and test name is 'Bacteriology Flexner/Zonne' and test result is 'Flexner - Positive'
				If UPPER(@strIDC10) = 'А03.1'
					BEGIN
						UPDATE @Form2Table2
						SET 
							intTotal		+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', @Month, 0, 100, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL)
							,intAge_0_17	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', @Month, 0, 17, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL)
							,intAge_0_1		+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', @Month, 0, 0, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL)
							,intAge_1_4		+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', @Month, 1, 4, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL)
							,intAge_5_9		+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', @Month, 5, 9, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL)
							,intAge_10_14	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', @Month, 10, 14, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL)
							,intAge_15_17	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', @Month, 15, 17, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL)
						WHERE
							idfsBaseReference = @idfsBaseReference
					END

				--Count When dianosis is А03.3 and test name is 'Bacteriology Flexner/Zonne' and test result is 'Zonne – positive'
				If UPPER(@strIDC10) = 'А03.3'
					BEGIN
						UPDATE @Form2Table2
						SET 
							intTotal		+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', @Month, 0, 100, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL)
							,intAge_0_17	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', @Month, 0, 17, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL)
							,intAge_0_1		+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', @Month, 0, 0, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL)
							,intAge_1_4		+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', @Month, 1, 4, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL)
							,intAge_5_9		+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', @Month, 5, 9, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL)
							,intAge_10_14	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', @Month, 10, 14, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL)
							,intAge_15_17	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', @Month, 15, 17, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL)
						WHERE
							idfsBaseReference = @idfsBaseReference
					END

				--Count When dianosis is Z22.2 and test name is 'Bacteriology of determination of toxigenic properties' and test result is 'Positive'
				If UPPER(@strIDC10) = 'Z22.2'
					BEGIN
						UPDATE @Form2Table2
						SET 
							intTotal		+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'Z22', @Month, 0, 100, 'Bacteriology of determination of toxigenic properties', 'Positive', NULL)
							,intAge_0_17	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'Z22', @Month, 0, 17, 'Bacteriology of determination of toxigenic properties', 'Positive', NULL)
							,intAge_0_1		+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'Z22', @Month, 0, 0, 'Bacteriology of determination of toxigenic properties', 'Positive', NULL)
							,intAge_1_4		+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'Z22', @Month, 1, 4, 'Bacteriology of determination of toxigenic properties', 'Positive', NULL)
							,intAge_5_9		+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'Z22', @Month, 5, 9, 'Bacteriology of determination of toxigenic properties', 'Positive', NULL)
							,intAge_10_14	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'Z22', @Month, 10, 14, 'Bacteriology of determination of toxigenic properties', 'Positive', NULL)
							,intAge_15_17	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'Z22', @Month, 15, 17, 'Bacteriology of determination of toxigenic properties', 'Positive', NULL)
						WHERE
							idfsBaseReference = @idfsBaseReference
					END

				--Count When dianosis is Z22.2 and test name is 'Bacteriology of determination of toxigenic properties' and test result is 'Negative'
				If UPPER(@strIDC10) = 'Z22.2.0'
					BEGIN
						UPDATE @Form2Table2
						SET 
							intTotal		+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'Z22', @Month, 0, 100, 'Bacteriology of determination of toxigenic properties', 'Negative', NULL)
							,intAge_0_17	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'Z22', @Month, 0, 17, 'Bacteriology of determination of toxigenic properties', 'Negative', NULL)
							,intAge_0_1		+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'Z22', @Month, 0, 0, 'Bacteriology of determination of toxigenic properties', 'Negative', NULL)
							,intAge_1_4		+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'Z22', @Month, 1, 4, 'Bacteriology of determination of toxigenic properties', 'Negative', NULL)
							,intAge_5_9		+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'Z22', @Month, 5, 9, 'Bacteriology of determination of toxigenic properties', 'Negative', NULL)
							,intAge_10_14	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'Z22', @Month, 10, 14, 'Bacteriology of determination of toxigenic properties', 'Negative', NULL)
							,intAge_15_17	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'Z22', @Month, 15, 17, 'Bacteriology of determination of toxigenic properties', 'Negative', NULL)
						WHERE
							idfsBaseReference = @idfsBaseReference
					END

				FETCH NEXT FROM 
					Rpt_Diag_Cursor
				INTO 
					@idfsBaseReference
					,@idfsDiagnosis
					,@strIDC10 
		END

		CLOSE Rpt_Diag_Cursor;  
		DEALLOCATE Rpt_Diag_Cursor; 

		-----------------------------------------------------------------------------
		-----------------------------------------------------------------------------
		-- Set the x disaggs
		-----------------------------------------------------------------------------
		-----------------------------------------------------------------------------

				UPDATE @Form2Table2
		
				SET intAge_0_1 =	'x',

					intAge_1_4 =	'x'
		
				WHERE strDiseaseName 
				IN
				(
				'Tularaemia',
				'Anthrax',
				'Brucellosis',
				'Leptospirosis',
				'Rickettsioses ', 
				'Brill disease', 
				'Typhus fever',
				'Spotted fever',
				'Rabies',
				'Tick-borne viral encephalitis',
				'Viral fever and viral hemorrhagic fever',
				'West Nile fever',
				'Including West Nile fever',
				'Haemorrhagic fever with renal syndrome',
				'Malaria',
				'Acute upper respiratory infections',
				'Influenza',
				'Carriers of malaria'
				)
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Return results from Ukraine Form 1 Table 2
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
		SELECT
			idfsBaseReference
			,strDiseaseName
			,intOrder as intRowNumber
			,strICD10
			,CASE WHEN intTotal = '0' THEN NULL ELSE intTotal END AS intTotal
			,CASE WHEN intAge_0_17 = '0' THEN NULL ELSE intAge_0_17 END AS intAge_0_17
			,CASE WHEN intAge_0_1 = '0' THEN NULL ELSE intAge_0_1 END AS intAge_0_1
			,CASE WHEN intAge_1_4 = '0' THEN NULL ELSE intAge_1_4 END AS intAge_1_4
			,CASE WHEN intAge_5_9 = '0' THEN NULL ELSE intAge_5_9 END AS intAge_5_9
			,CASE WHEN intAge_10_14 = '0' THEN NULL ELSE intAge_10_14 END AS intAge_10_14
			,CASE WHEN intAge_15_17 = '0' THEN NULL ELSE intAge_15_17 END AS intAge_15_17
			,CASE WHEN intRuralTotal = '0' THEN NULL ELSE intRuralTotal END AS intRuralTotal
			,CASE WHEN intRuralAge_0_17 = '0' THEN NULL ELSE intRuralAge_0_17 END AS intRuralAge_0_17
			,intOrder
		FROM 
			@Form2Table2 R
			
		ORDER BY intOrder

		SELECT  @returnCode, @returnMsg

	END TRY

	BEGIN CATCH
			IF @@TRANCOUNT > 0 
				ROLLBACK

			SET @returnCode = ERROR_NUMBER()
			SET @returnMsg	= ERROR_MESSAGE()
			
			SELECT @returnCode, @returnMsg
			
	END CATCH
	
END



