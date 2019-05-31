


--##SUMMARY Checks if a human case could be deleted.
--##SUMMARY This procedure is called before the deletion of the query.
--##SUMMARY Query can only be deleted when the procedure allows it.
--##SUMMARY The query is allowed to delete, if it is not read-only.

--##REMARKS Author: Mirnaya O.
--##REMARKS 
--##REMARKS Update date: 21.04.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.11.2011

--##RETURNS Returns 0 if the query can not be deleted.
--##RETURNS Returns 1 if the query can be deleted.


/*
Example of a call of procedure:

declare @ID bigint
declare @Result bit
exec spQuery_CanDelete @ID, @Result output
print @Result

*/


CREATE procedure	[dbo].[spQuery_CanDelete]
( 
	@ID bigint,
	@Result bit output
)
as

	set @Result = 1

	if exists	(	 
			select	* 
			from	tasQuery 
			where	idflQuery = @ID
					and IsNull(blnReadOnly, 0) = 1
				)
	begin
		set @Result = 0
	end
	else begin
		set @Result = 1
	end

	IF ISNULL((SELECT strValue FROM tstGlobalSiteOptions WHERE strName = 'DataValidation' AND intRowStatus = 0), 0) = 1
	BEGIN
		DECLARE @DataValidationResult INT	
		EXEC @DataValidationResult = spAVRQuery_Validate @ID
		IF @DataValidationResult <> 0
			SET @Result = 0
	END

	return @Result




