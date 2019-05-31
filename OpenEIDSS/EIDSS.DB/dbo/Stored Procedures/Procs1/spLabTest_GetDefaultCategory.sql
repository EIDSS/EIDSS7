
CREATE PROCEDURE [dbo].[spLabTest_GetDefaultCategory]
	@idfsDiagnosis bigint, 
	@idfsTestName bigint
AS
	SELECT idfsTestCategory
	From trtTestForDisease 
	where idfsDiagnosis = @idfsDiagnosis
	and idfsTestName = @idfsTestName
RETURN 0
