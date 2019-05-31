

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

CREATE PROCEDURE [dbo].[spLabSample_Store]
	@idfMaterial bigint,
	@idfSubdivision bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	exec spFreezerSubdivision_Validate @idfSubdivision, @idfMaterial
	
	UPDATE	tlbMaterial
	SET		idfSubdivision=@idfSubdivision WHERE idfMaterial=@idfMaterial
END

