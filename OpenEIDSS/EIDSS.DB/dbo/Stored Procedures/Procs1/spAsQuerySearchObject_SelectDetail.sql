

--##SUMMARY This procedure selects specified query search object 
--##SUMMARY and related search fields and coonditions' tree.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 19.04.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.11.2011

--##RETURNS Don't use

/*
--Example of a call of procedure:

declare	@ID	bigint
exec spAsQuerySearchObject_SelectDetail 49540090000000, 'en'
*/ 
 
CREATE procedure	[dbo].[spAsQuerySearchObject_SelectDetail]
	@ID			bigint,
	@LangID		nvarchar(50)
as

-- tasQuerySearchObject
select		qso.idfQuerySearchObject,
			qso.idflQuery,
			qso.idfsSearchObject,
			qso.intOrder,
			qso.idfsReportType
from		tasQuerySearchObject qso
where		qso.idfQuerySearchObject = @ID

-- tasQuerySearchField
execute spAsQuerySearchObject_SelectFieldList @ID, @LangID

-- tasQueryConditionGroup
exec spAsQuerySearchObject_SelectConditionGroupTree @ID, @LangID

-- tasFilterSubquery
exec spAsQuery_SelectSubqueries @ID, @LangID




