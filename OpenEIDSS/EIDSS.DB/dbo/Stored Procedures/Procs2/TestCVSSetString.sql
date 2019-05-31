-- EXEC dbo.TestCVSSetString
CREATE PROCEDURE dbo.TestCVSSetString
(
	@TestString NVARCHAR(4000) ='781320000000,782030000000,783200000000,783350000000,783480000000,783490000000',
	@idfsDisease BIGINT = 786380000000
)
AS
BEGIN
	DECLARE @TestTable TABLE ( idfSampleType BIGINT)
	
	UPDATE trtMaterialForDisease SET intRowStatus = 1 WHERE intRowStatus = 1 AND idfsDiagnosis = @idfsDisease
	INSERT INTO @TestTable SELECT VALUE AS idfsSampleType FROM string_split(@TestString, ',')

	IF (SELECT COUNT(idfSampleType) FROM @TestTable) > 0
	BEGIN
		UPDATE trtMaterialForDisease SET intRowStatus = 0
		WHERE idfsDiagnosis = @idfsDisease AND idfsSampleType = idfsSampleType 
	END
END