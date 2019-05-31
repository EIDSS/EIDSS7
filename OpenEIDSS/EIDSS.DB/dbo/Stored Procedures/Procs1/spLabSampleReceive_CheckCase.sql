

CREATE PROCEDURE spLabSampleReceive_CheckCase
	@idfCase bigint
AS
BEGIN

	select	tlbHumanCase.idfsYNSpecimenCollected,
			tlbHumanCase.idfsNotCollectedReason
	from	tlbHumanCase
	where	idfHumanCase=@idfCase
END

