

--##SUMMARY Gets predefined layouts(reports)

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 02.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.11.2011

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

EXEC spAsGetPredefinedReports 'en'

*/

CREATE     Proc	[dbo].[spAsGetPredefinedReports]
	@LangID	nvarchar(50)
AS
	SELECT		lay.idflLayout/*, rfLay.[name]*/, rfSob.intHACode
	FROM		tasLayout lay
	--INNER JOIN	fnReference(@LangID, 19000050 /*'rftLayoutName'*/) rfLay
	--ON			rfLay.idfsReference = lay.idflPivotName
	INNER JOIN	tasQuerySearchObject qso
	ON			qso.idflQuery = lay.idflQuery
	AND			qso.idfParentQuerySearchObject IS NULL
	INNER JOIN  fnReference(@LangID, 19000082 /*'rftSearchObject'*/) rfSob
	ON			rfSob.idfsReference = qso.idfsSearchObject
	WHERE		lay.blnReadOnly=1
	--ORDER BY	rfLay.[name]


