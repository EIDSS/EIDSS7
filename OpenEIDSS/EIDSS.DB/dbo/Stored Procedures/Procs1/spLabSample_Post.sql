

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

CREATE PROCEDURE [dbo].[spLabSample_Post]
	@idfMaterial bigint,
	@idfSubdivision bigint,
	@idfInDepartment bigint=NULL,
	@strNote nvarchar(500)=NULL, 
	@strBarcode nvarchar(200) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	EXEC spLabSample_Store @idfMaterial, @idfSubdivision

	UPDATE	tlbMaterial
	SET		--idfSubdivision=@idfSubdivision,
			idfInDepartment=@idfInDepartment,
			strNote=@strNote,
			strBarcode = ISNULL(@strBarcode,strBarcode)
	WHERE idfMaterial=@idfMaterial

END

