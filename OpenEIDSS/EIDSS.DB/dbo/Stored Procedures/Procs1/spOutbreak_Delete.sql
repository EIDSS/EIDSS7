
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

CREATE    PROCEDURE dbo.spOutbreak_Delete
	@ID AS bigint
as
DECLARE @RC AS BIT
EXEC spOutbreak_CanDelete @ID, @RC OUTPUT
IF @RC = 0
	RETURN -1
declare @idfLocation bigint
select @idfLocation = idfGeoLocation from tlbOutbreak 
where idfOutbreak = @ID

delete from tlbOutbreakNote
where idfOutbreak = @ID


delete tflOutbreakFiltered
where idfOutbreak = @ID

delete from tlbOutbreak
where idfOutbreak = @ID

exec spGeoLocation_Delete @idfLocation

update tlbHumanCase
set idfOutbreak = null
WHERE idfOutbreak = @ID

update tlbVetCase
set idfOutbreak = null
WHERE idfOutbreak = @ID

update tlbVectorSurveillanceSession
set idfOutbreak = null
WHERE idfOutbreak = @ID


RETURN 0


