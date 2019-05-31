
CREATE    PROCEDURE dbo.spTest_CreateVetCase
	@caseNum int
as

EXEC sptemp_CreateVetCase 
	@CaseCnt = @caseNum
	, @SampleCnt = 0
	, @TestCnt = 0
	, @my_SiteID = 1100
	, @Diagnosis = NULL
	, @LastName = NULL
	, @Region = NULL
	, @Rayon = NULL
	, @StartDate = '2010-01-01 12:00:00:00'
	, @DateRange = 100
	, @CaseType = 10012003

