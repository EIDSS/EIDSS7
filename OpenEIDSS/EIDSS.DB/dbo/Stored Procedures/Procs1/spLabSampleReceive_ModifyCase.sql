

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

CREATE PROCEDURE [dbo].[spLabSampleReceive_ModifyCase] 
	@idfCase bigint,
	@strSampleNotes nvarchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS (
		SELECT tlbMaterial.idfMaterial
		FROM		tlbMaterial
		inner join	tlbHumanCase
		on			tlbHumanCase.idfHumanCase=@idfCase and
					(tlbHumanCase.idfsYNSpecimenCollected is null 
						or tlbHumanCase.idfsYNSpecimenCollected <> 10100001)
		WHERE tlbMaterial.idfHumanCase = @idfCase
			AND tlbMaterial.intRowStatus = 0
	)
	BEGIN
		UPDATE tlbHumanCase 
		SET idfsYNSpecimenCollected=10100001
		WHERE idfHumanCase=@idfCase
	END

	UPDATE tlbHumanCase
	SET strSampleNotes=@strSampleNotes
	WHERE idfHumanCase=@idfCase
	IF @@ROWCOUNT = 0
	BEGIN
		UPDATE tlbVetCase
		SET strSampleNotes=@strSampleNotes
		WHERE idfVetCase=@idfCase
	END

END


