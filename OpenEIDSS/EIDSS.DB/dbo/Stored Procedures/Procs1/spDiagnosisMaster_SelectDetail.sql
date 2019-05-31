
--##SUMMARY Selects dummy of diagnosis for reference and matrix editors

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 14.01.2014

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

EXEC spDiagnosisMaster_SelectDetail 
*/


CREATE PROCEDURE [dbo].[spDiagnosisMaster_SelectDetail]

AS
	SELECT ISNULL(CAST(-1 as bigint),0) AS idfsDiagnosis


RETURN 0
