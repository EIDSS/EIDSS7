
CREATE         PROCEDURE [dbo].[spPostalCode_Post](
	@strPostCode nvarchar(200),
	@idfsSettlement BIGINT,
	@idfPostalCode BIGINT = NULL OUTPUT
	)
as
if (@idfsSettlement is not null) and (@strPostCode is not null) and (len(@strPostCode) > 0)
begin
	if not exists	(	select	*	
						from	tlbPostalCode
						where	idfsSettlement = @idfsSettlement
								and strPostCode = @strPostCode
								AND intRowStatus = 0
					)
	BEGIN
		
		IF @idfPostalCode IS NULL
		BEGIN
			EXEC spsysGetNewID @idfPostalCode OUTPUT
		END
		
		insert into tlbPostalCode
			(
				idfPostalCode,
				idfsSettlement, 
				strPostCode 
			)
		values
			(
				@idfPostalCode,
				@idfsSettlement, 
				@strPostCode 
			)
	end
end



