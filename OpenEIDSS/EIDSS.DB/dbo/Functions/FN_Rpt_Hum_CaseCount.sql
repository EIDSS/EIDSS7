

--------======================================================================================
-- Name 				: FN_Rpt_Hum_CaseCount
-- Description			: Get case count by diagnosis 
--          
-- Author               : Maheshwar Deo
-- Revision History
--		Name			Date		Change Detail
--testing code:

--------======================================================================================

CREATE FUNCTION [dbo].[FN_Rpt_Hum_CaseCount]
	( 
	@HumanCase		dbo.UDT_HumanCasesForReport READONLY 
	,@idfsDiagnosis BIGINT
	,@Month			INT
	,@FromAge		INT
	,@ToAge			INT
	)
RETURNS INT
AS
BEGIN

    DECLARE @CaseCount INT

	SELECT 
		@CaseCount = COUNT(*)
	FROM 
		@HumanCase HumanCase
	WHERE 
		HumanCase.idfsDiagnosis = @idfsDiagnosis
		AND 
		HumanCase.intNotificationMonth = @Month
		AND 
		HumanCase.AgeYears BETWEEN @FromAge AND @ToAge

    RETURN ISNULL(@CaseCount, 0)

END

