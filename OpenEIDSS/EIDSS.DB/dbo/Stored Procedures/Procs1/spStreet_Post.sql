

/************************************************************
* spStreet_Post.proc
************************************************************/

--##SUMMARY Posts street name for futher quick referencing in the system.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

DECLARE @strStreetName nvarchar(200)
DECLARE @idfsSettlement varchar(36)

EXECUTE @RC = [EIDSS_v3].[dbo].[spStreet_Post] 
   @strStreetName
  ,@idfsSettlement
*/


CREATE         PROCEDURE [dbo].[spStreet_Post](
	@strStreetName nvarchar(200),  --##PARAM @strStreetName - street name
	@idfsSettlement varchar(36),  --##PARAM @idfsSettlement - ID of settlement to which stree is belongs
	@idfStreet BIGINT = NULL OUTPUT
	)
as
if (@idfsSettlement is not null) and (@strStreetName is not null) and (len(@strStreetName) > 0)
begin
	if not exists	(	select	*	
						from	tlbStreet
						where	idfsSettlement = @idfsSettlement
								and strStreetName = @strStreetName
								AND intRowStatus = 0
					)
	BEGIN
		
		IF @idfStreet IS NULL
		BEGIN
			EXEC spsysGetNewID @idfStreet OUTPUT
		END
	
		insert into tlbStreet
			(
				idfStreet,
				idfsSettlement, 
				strStreetName 
			)
		values
			(
				@idfStreet,
				@idfsSettlement, 
				@strStreetName 
			)
	end
end



