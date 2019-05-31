
CREATE  PROCEDURE [dbo].[spTest_CreateHumanCase]
as

EXEC sptemp_CreateHumanCase 
	@CaseCnt = 1
	, @SampleCnt = 0
	, @TestCnt = 0
	, @my_SiteID = 1100
	, @Diagnosis = NULL
	, @LastName = NULL
	, @Age = NULL
	, @Region = NULL
	, @Rayon = NULL
	, @StartDate = '2010-01-01 12:00:00:00'
	, @DateRange = 100
