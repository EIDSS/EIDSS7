
--##SUMMARY Selects dummy of vector type for reference and matrix editors

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 12.01.2012

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

EXEC spVectorSubTypeMaster_SelectDetail 'en'
*/


CREATE PROCEDURE [dbo].[spVectorTypeMaster_SelectDetail]
	@LangID  NVARCHAR(50)--##PARAM @LangID - language ID 

AS
	SELECT ISNULL(CAST(-1 as bigint),0) AS idfsVectorType


RETURN 0
