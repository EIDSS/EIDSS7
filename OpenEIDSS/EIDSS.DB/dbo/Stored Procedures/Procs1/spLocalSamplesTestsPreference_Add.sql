

CREATE  PROCEDURE dbo.spLocalSamplesTestsPreference_Add
(
	@idfTestingOrMaterial AS BIGINT, 
	@idfUserID AS BIGINT
)
AS

Declare @idfMaterial BIGINT
Declare @idfTesting BIGINT

SELECT 
	@idfMaterial = idfMaterial,
	@idfTesting = idfTesting
FROM dbo.tlbTesting
WHERE idfTesting = @idfTestingOrMaterial

IF @idfMaterial IS NULL
BEGIN
	SELECT @idfMaterial = @idfTestingOrMaterial
	SELECT @idfTesting = NULL
END

IF NOT EXISTS (SELECT * FROM dbo.tstLocalSamplesTestsPreferences
	WHERE idfMaterial = @idfMaterial AND isnull(idfTesting,0) = isnull(@idfTesting,0) AND idfUserID = @idfUserID)
	BEGIN
		Declare @idfSamplesTestsPreferences bigint
		EXEC dbo.spsysGetNewID @idfSamplesTestsPreferences output
	
		INSERT INTO dbo.tstLocalSamplesTestsPreferences
		(idfSamplesTestsPreferences, idfMaterial, idfTesting, idfUserID)
		VALUES
		(@idfSamplesTestsPreferences, @idfMaterial, @idfTesting, @idfUserID)
	END


