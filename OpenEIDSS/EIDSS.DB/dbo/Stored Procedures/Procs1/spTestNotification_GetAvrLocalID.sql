
CREATE PROCEDURE [dbo].[spTestNotification_GetAvrLocalID]
	@notificationType bigint,
	@globalId bigint
AS
	if(@notificationType in (10056013,10056055))
		select Top 1 idflLayout from tasLayout where idfsGlobalLayout = @globalId
	else if(@notificationType in (10056056,10056057))
		select Top 1 idflLayoutFolder from tasLayoutFolder where idfsGlobalLayoutFolder = @globalId
	else if(@notificationType in (10056058,10056059))
		select Top 1 idflQuery from tasQuery where idfsGlobalQuery = @globalId
	else select 0 as bigint
RETURN 0

