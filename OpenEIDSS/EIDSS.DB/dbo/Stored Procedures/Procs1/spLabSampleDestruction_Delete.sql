

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

CREATE PROCEDURE [dbo].[spLabSampleDestruction_Delete]
	@ID bigint
AS
BEGIN

	UPDATE	tlbMaterial
	SET		idfsSampleStatus=10015007--cotInRepository
	WHERE	idfMaterial=@ID AND idfsSampleStatus in (10015003,10015002) --cotDestroy,cotDelete

END

