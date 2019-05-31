

/*
--Example of a call of procedure:
exec	spWhoExport_SelectDetail 'en',@StartDate='20130101',@EndDate='20130701',@idfsDiagnosis=0
*/



CREATE procedure	[dbo].[spWhoExport_SelectDetail]
(		
	@LangID  nvarchar(50),
  	@StartDate datetime,
  	@EndDate datetime,
	@idfsDiagnosis bigint
)
as

exec dbo.[spRepHumWhoReport] @LangID,@StartDate,@EndDate,@idfsDiagnosis
