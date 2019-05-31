
--------======================================================================================
-- Name 				: USP_Rpt_Hum_Form2_Table1
-- Description			: Get Form 2 report for UA 
--          
-- Author               : Mark Wilson 11/30/2017
-- Revision History
--		Name       Date       Change Detail

--testing code:
----exec USP_Rpt_Hum_Form1 'en', 2014, 1, 12
----exec USP_Rpt_Hum_Form1 'en', 2017, 1, 12, null, null, 868

--------======================================================================================

CREATE  PROCEDURE [dbo].[USP_Rpt_Hum_Form2_Table1]
	@LangID				AS VARCHAR(36),
	@Year				AS INT, 
	@RegionID			AS BIGINT = NULL

AS

BEGIN
	BEGIN TRY

		DECLARE @returnCode		INT = 0
				,@returnMsg		NVARCHAR(MAX) = 'SUCCESS'

		EXEC dbo.USP_GBL_FIRSTDAY_SET
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Declare table to hold report data for Ukraine, Form2 Table1
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------		
		DECLARE	@Form2Table1	
		TABLE
			(
			idfsBaseReference	BIGINT NOT NULL PRIMARY KEY
			,idfsReferenceType	BIGINT NOT NULL
			,strDiseaseName		NVARCHAR(300) COLLATE DATABASE_DEFAULT NOT NULL
			,strICD10			NVARCHAR(200) COLLATE DATABASE_DEFAULT NULL
			,intOrder			INT NOT NULL
			,I					NVARCHAR(20) NOT NULL
			,II					NVARCHAR(20) NOT NULL
			,III				NVARCHAR(20) NOT NULL
			,IV					NVARCHAR(20) NOT NULL
			,V					NVARCHAR(20) NOT NULL
			,VI					NVARCHAR(20) NOT NULL
			,VII				NVARCHAR(20) NOT NULL
			,VIII				NVARCHAR(20) NOT NULL
			,IX					NVARCHAR(20) NOT NULL
			,X					NVARCHAR(20) NOT NULL
			,XI					NVARCHAR(20) NOT NULL
			,XII				NVARCHAR(20) NOT NULL
			)

		INSERT INTO @Form2Table1
			(
			idfsBaseReference
			,idfsReferenceType
			,strDiseaseName
			,strICD10
			,intOrder
			,I
			,II
			,III
			,IV
			,V
			,VI
			,VII
			,VIII
			,IX
			,X
			,XI
			,XII
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
				,'0'
				,'0'
				,'0'
			FROM
				dbo.FN_Rpt_List('UA Form #2 - Table1', @LangID)

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
		FROM 
			dbo.FN_Rpt_HumanCase_List(@Year, @RegionID) HumanCase
			INNER JOIN trtDiagnosis On
				HumanCase.idfsDiagnosis = trtDiagnosis.idfsDiagnosis
			LEFT OUTER JOIN tlbChangeDiagnosisHistory On
				HumanCase.idfHumanCase = tlbChangeDiagnosisHistory.idfHumanCase
			LEFT OUTER JOIN trtDiagnosis CurrentDiagnosis On
				tlbChangeDiagnosisHistory.idfsCurrentDiagnosis = CurrentDiagnosis.idfsDiagnosis

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Add the monthly results from HumanCase table to Ukraine Form 2, Table 1
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
				@Form2Table1 As RptTlb
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
				@Form2Table1 As RptTlb
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
				UPDATE @Form2Table1
				SET 
					I += dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, 1, 0, 100),
					II += dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, 2, 0, 100),
					III += dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, 3, 0, 100),
					IV += dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, 4, 0, 100),
					V += dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, 5, 0, 100),
					VI += dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, 6, 0, 100),
					VII += dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, 7, 0, 100),
					VIII += dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, 8, 0, 100),
					IX += dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, 9, 0, 100),
					X += dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, 10, 0, 100),
					XI += dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, 11, 0, 100),
					XII += dbo.FN_Rpt_Hum_CaseCount(@HumanCase, @idfsDiagnosis, 12, 0, 100)
			WHERE
					idfsBaseReference = @idfsBaseReference

			--Count When dianosis is А03.1 and test name is 'Bacteriology Flexner/Zonne' and test result is 'Flexner - Positive'
			If UPPER(@strIDC10) = 'А03.1'
				BEGIN
					UPDATE @Form2Table1
					SET 
						I	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 1, 0, 100, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL),
						II	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 2, 0, 100, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL),
						III +=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 3, 0, 100, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL),
						IV	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 4, 0, 100, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL),
						V	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 5, 0, 100, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL),
						VI	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 6, 0, 100, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL),
						VII +=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 7, 0, 100, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL),
						VIII +=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 8, 0, 100, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL),
						IX	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 9, 0, 100, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL),
						X	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 10, 0, 100, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL),
						XI  +=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 11, 0, 100, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL),
						XII +=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 12, 0, 100, 'Bacteriology Flexner/Zonne', 'Flexner - Positive', NULL)
					WHERE
						idfsBaseReference = @idfsBaseReference
				END
			--Count When dianosis is А03.3 and test name is 'Bacteriology Flexner/Zonne' and test result is 'Zonne – positive'
			If UPPER(@strIDC10) = 'А03.3'
				BEGIN
					UPDATE @Form2Table1
					SET 
						I	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 1, 0, 100, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL),
						II	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 2, 0, 100, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL),
						III +=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 3, 0, 100, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL),
						IV	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 4, 0, 100, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL),
						V	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 5, 0, 100, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL),
						VI	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 6, 0, 100, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL),
						VII +=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 7, 0, 100, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL),
						VIII +=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 8, 0, 100, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL),
						IX	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 9, 0, 100, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL),
						X	+=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 10, 0, 100, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL),
						XI  +=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 11, 0, 100, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL),
						XII +=	dbo.FN_Rpt_Hum_CaseCountByRule(@HumanCase, 'А03', 12, 0, 100, 'Bacteriology Flexner/Zonne', 'Zonne – positive', NULL)
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

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Return results from Ukraine Form 1 Table 1
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
		SELECT
			idfsBaseReference
			,strDiseaseName
			,intOrder as intRowNumber
			,strICD10
			,CASE WHEN I = '0' THEN NULL ELSE I END AS I
			,CASE WHEN II = '0' THEN NULL ELSE II END AS II
			,CASE WHEN III = '0' THEN NULL ELSE III END AS III
			,CASE WHEN IV = '0' THEN NULL ELSE IV END AS IV
			,CASE WHEN V = '0' THEN NULL ELSE V END AS V
			,CASE WHEN VI = '0' THEN NULL ELSE VI END AS VI
			,CASE WHEN VII = '0' THEN NULL ELSE VII END AS VII
			,CASE WHEN VIII = '0' THEN NULL ELSE VIII END AS VIII
			,CASE WHEN IX = '0' THEN NULL ELSE IX END AS IX
			,CASE WHEN X = '0' THEN NULL ELSE X END AS X
			,CASE WHEN XI = '0' THEN NULL ELSE XI END AS XI
			,CASE WHEN XII = '0' THEN NULL ELSE XII END AS XII
			,intOrder
		FROM 
			@Form2Table1 R
			
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



