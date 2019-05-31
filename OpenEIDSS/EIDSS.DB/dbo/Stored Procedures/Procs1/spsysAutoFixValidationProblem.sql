
--##SUMMARY This procedure for each record in tstInvalidObjects marked with blnCanAutoFix = 1 execute script stored in strFixQueryTemplate field 
--and set blnFixed = 1 if script was successfully executed.

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 24.06.2015

/*
Example of procedure call:

EXEC spsysAutoFixValidationProblem

*/
CREATE PROCEDURE [dbo].[spsysAutoFixValidationProblem]
AS

	DECLARE @Sql NVARCHAR(MAX) = ''
		, @id_problem INT

	DECLARE _T CURSOR FOR
		SELECT 
			tio.idfKey
			, tio.strFixQueryTemplate
		FROM tstInvalidObjects tio
		WHERE ISNULL(tio.blnCanAutoFix, 0) = 1
			AND ISNULL(tio.blnFixed, 0) = 0
	OPEN _T

	FETCH NEXT FROM _T into @id_problem
							, @Sql
	
	EXEC (@Sql)
	
	IF @@ROWCOUNT > 0 
		UPDATE tstInvalidObjects
		SET blnFixed = 1
		WHERE idfKey = @id_problem
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @Sql = ''
		
		FETCH NEXT FROM _T into @id_problem
							, @Sql
		
		IF @Sql <> ''
		BEGIN
			EXEC (@Sql)
			
			IF @@ROWCOUNT > 0 
				UPDATE tstInvalidObjects
				SET blnFixed = 1
				WHERE idfKey = @id_problem
			
		END
	END
	
	CLOSE _T
	DEALLOCATE _T
