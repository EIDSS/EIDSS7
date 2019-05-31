
CREATE PROCEDURE [dbo].[spAsGetGlobalIdFromLocalId]
	@notificationType bigint,
	@localId bigint

AS
	if(@notificationType in (10056013,10056055))
		select idfsGlobalLayout from tasLayout where idflLayout = @localId
	else if(@notificationType in (10056056,10056057))
		select idfsGlobalLayoutFolder from tasLayoutFolder where idflLayoutFolder = @localId
	else if(@notificationType in (10056058,10056059))
		select idfsGlobalQuery from tasQuery where idflQuery = @localId
	else select 0 as bigint
		
RETURN 0

