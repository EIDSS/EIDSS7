

CREATE  PROCEDURE dbo.spLocalSamplesTestsPreference_Remove
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

IF EXISTS (SELECT * FROM dbo.tstLocalSamplesTestsPreferences
	WHERE idfMaterial = @idfMaterial AND isnull(idfTesting,0) = isnull(@idfTesting,0) AND idfUserID = @idfUserID)
	BEGIN
		DELETE FROM dbo.tstLocalSamplesTestsPreferences
		WHERE idfMaterial = @idfMaterial AND isnull(idfTesting,0) = isnull(@idfTesting,0) AND idfUserID = @idfUserID
	END


