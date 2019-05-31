
CREATE FUNCTION [dbo].[fnEventLog_GetDiagnosisForObject]
(
	@idfsEventTypeID bigint,
	@idfObject bigint
)
RETURNS bigint
AS
BEGIN
	DECLARE @idfsDiagnosis bigint
	DECLARE @ObjectName NVARCHAR(50)
	SELECT @ObjectName = dbo.fnEventLog_GetObjectType(@idfsEventTypeID)
	IF @ObjectName = N'HumanCase'
	BEGIN
		SELECT @idfsDiagnosis = ISNULL(idfsFinalDiagnosis,idfsTentativeDiagnosis) from tlbHumanCase Where idfHumanCase = @idfObject
	END
	ELSE IF @ObjectName = N'VetCase'
	BEGIN
		SELECT @idfsDiagnosis = idfsShowDiagnosis from tlbVetCase Where idfVetCase = @idfObject
	END
	RETURN @idfsDiagnosis
END

