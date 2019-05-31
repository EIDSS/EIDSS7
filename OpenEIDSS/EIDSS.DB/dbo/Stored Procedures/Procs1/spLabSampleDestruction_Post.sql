

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

CREATE PROCEDURE [dbo].[spLabSampleDestruction_Post]
	@idfMaterial bigint,
	@idfsSampleStatus bigint,
	@destroy bit,
	@idfsDestructionMethod bigint,
	@idfDestroyedByPerson bigint=null,
	@idfMarkedForDispositionByPerson bigint=null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

IF @destroy=1
	BEGIN
		
		UPDATE	tlbMaterial
		SET		idfsSampleStatus=@idfsSampleStatus,
				idfDestroyedByPerson=@idfDestroyedByPerson,
				datDestructionDate=getdate(),
				idfSubdivision=null,
				idfsDestructionMethod = @idfsDestructionMethod
		WHERE	idfMaterial=@idfMaterial
	END
	ELSE
	BEGIN
		UPDATE	tlbMaterial
		SET		idfsSampleStatus=@idfsSampleStatus,
				idfsDestructionMethod = @idfsDestructionMethod,
				idfMarkedForDispositionByPerson = @idfMarkedForDispositionByPerson
		WHERE	idfMaterial=@idfMaterial
	END
END

