

--------======================================================================================
-- Name 				: [FN_Rpt_Hum_CaseCountByRule]
-- Description			: Get case count by diagnosis, test type and test result 
--          
-- Author               : Maheshwar Deo
-- Revision History
--		Name			Date		Change Detail
--testing code:

--------======================================================================================

CREATE FUNCTION [dbo].[FN_Rpt_Hum_CaseCountByRule]
	( 
	@HumanCase		dbo.UDT_HumanCasesForReport READONLY 
	,@strIDC10			NVARCHAR(400)
	,@Month				INT
	,@FromAge			INT
	,@ToAge				INT
	,@TestName			NVARCHAR(400)
	,@TestResult		NVARCHAR(400)
	,@CurrentDiagICD10	NVARCHAR(400) = NULL
	)
RETURNS INT
AS
BEGIN

    DECLARE @CaseCount INT

	SELECT 
		@CaseCount = COUNT(*)
	FROM 
		@HumanCase HumanCase
		LEFT OUTER JOIN (Select * From fnTestListOptimized('en')) TestList On
			HumanCase.idfHumanCase = TestList.idfHumanCase
			AND
			HumanCase.idfsDiagnosis = TestList.idfsDiagnosis
			AND
			TestList.TestName = CASE WHEN @TestName IS NULL THEN TestList.TestName ELSE @TestName END
			AND
			TestList.TestResult In (SELECT [Value] FROM dbo.fnsysSplitList(@TestResult, 0, ','))
	WHERE 
		HumanCase.strICD10 = @strIDC10
		AND 
		HumanCase.intNotificationMonth = @Month
		AND 
		HumanCase.AgeYears BETWEEN @FromAge AND @ToAge
		AND
		HumanCase.CurrentDiagICD10 = CASE WHEN @CurrentDiagICD10 IS NULL THEN HumanCase.CurrentDiagICD10 ELSE @CurrentDiagICD10 END
 
    RETURN ISNULL(@CaseCount, 0)

END

