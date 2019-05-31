
CREATE FUNCTION [dbo].[fnIsSampleTransferred]
(
	@idfMaterial bigint
)
RETURNS BIT
AS
BEGIN
	DECLARE @idfParentMaterial bigint
	DECLARE @idfsSampleKind bigint
	SELECT @idfParentMaterial = idfParentMaterial, @idfsSampleKind = idfsSampleKind
	FROM tlbMaterial
	WHERE idfMaterial = @idfMaterial
	AND intRowStatus = 0
	--AND blnAccessioned = 1

	IF @@ROWCOUNT = 0
		RETURN 0
	IF ISNULL(@idfsSampleKind,0) = 12675430000000 --transferred
		RETURN 1
	RETURN 0
	/*
	uncomment this if aliquotes/derivatives shall be taken into account 
	for TestResultForSampleTransferredOut event creation

	IF @idfParentMaterial IS NULL
		RETURN 0
	IF @idfParentMaterial = @idfMaterial
		RETURN 0
	RETURN dbo.fnIsSampleTransferred(@idfParentMaterial)
	*/
END

