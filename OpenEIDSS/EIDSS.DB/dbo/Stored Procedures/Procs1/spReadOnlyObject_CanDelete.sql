

--##SUMMARY Checks if an object could be deleted.
--##SUMMARY This procedure is called before the deletion of the readonly object. 

--##REMARKS Author: Vasilyev I.

--##RETURNS Returns 0 because object can not be deleted.

/*
Example of a call of procedure:
declare @ID bigint
declare @Result bit
exec spReadOnlyObject_CanDelete @ID, @Result output
print @Result
*/



CREATE	procedure	[dbo].[spReadOnlyObject_CanDelete]
( 
	@ID as bigint,--##PARAM  @ID - object ID
	@Result as bit output --##PARAM  @Result 0 because object can not be deleted
)
as

	set @Result = 0

	return @Result





