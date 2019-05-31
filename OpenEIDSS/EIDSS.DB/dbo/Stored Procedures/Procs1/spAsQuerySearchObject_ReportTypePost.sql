

--##SUMMARY This procedure saves changes of the attribute Report Type of specified query search object.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 27.01.2014


--##RETURNS Don't use

/*
--Example of a call of procedure:

declare	@idfQuerySearchObject		bigint
declare	@idfsReportType				bigint

execute	spAsQuerySearchObject_ReportTypePost_Post
		 @idfQuerySearchObject output
		,idfsReportType

*/ 


CREATE procedure	[dbo].[spAsQuerySearchObject_ReportTypePost]
(
	@idfQuerySearchObject		bigint output,
	@idfsReportType				bigint = null
	)
as

if exists	(
	select	*
	from	tasQuerySearchObject
	where	idfQuerySearchObject = @idfQuerySearchObject
			)
begin
	update	tasQuerySearchObject
	set		idfsReportType = @idfsReportType
	where	idfQuerySearchObject = @idfQuerySearchObject
end

return 0


