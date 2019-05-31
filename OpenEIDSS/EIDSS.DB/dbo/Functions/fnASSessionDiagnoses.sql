
--##SUMMARY RETURNS string of all AS session diagnoses divided by commas
--          The diagnoses shall be sorted by �Order� attribute, 
--          if order is not specified or it is the same for some diagnoses they shall be sorted alphabetically on national language. 

--##RETURNS Function returns string of all AS session diagnoses divided by commas

--##REMARKS Author: Gorodentseva T.
--##REMARKS Create date: 13.06.2013

/*
--Example of function call:
SELECT dbo.fnASSessionDiagnoses( 12677330000000, 'en' )
*/

CREATE FUNCTION [dbo].[fnASSessionDiagnoses]
(
	@idfMonitoringSession bigint
	,@LangID nvarchar(20)
)
RETURNS varchar(500)
AS
BEGIN
DECLARE @ret varchar(500)
SELECT @ret = name from dbo.vwAsSessionDiagnosis d
	WHERE		d.idfMonitoringSession = @idfMonitoringSession
		AND	dbo.fnGetLanguageCode(@LangID) = d.idfsLanguage
		

RETURN @ret
END

