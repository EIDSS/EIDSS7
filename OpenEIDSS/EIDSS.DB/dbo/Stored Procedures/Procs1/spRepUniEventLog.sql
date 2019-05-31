

--##SUMMARY Select event log records.

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 03.12.2009

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
exec spRepUniEventLog 'en','01/01/00','01/01/10'

*/

CREATE  Procedure [dbo].[spRepUniEventLog]
	(@LangID As nvarchar(50),
	 @SD as nvarchar(20), 
	 @ED as nvarchar(20))
AS	

	declare @SDDate as datetime
	declare @EDDate as datetime

	set @SDDate=dbo.fn_SetMinMaxTime(CAST(@SD as datetime),0)
	set @EDDate=dbo.fn_SetMinMaxTime(CAST(@ED as datetime),1)

	select		* 
	from		dbo.fn_Event_SelectList (@LangID) as a
	where		datEventDatatime between @SDDate and @EDDate
	order by	datEventDatatime


