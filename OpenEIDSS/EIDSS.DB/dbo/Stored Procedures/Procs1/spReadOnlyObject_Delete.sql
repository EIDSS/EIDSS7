

--##SUMMARY Stub procedure for deleting readonly object.
--##SUMMARY It exists for model generation only.

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 10.10.2011

--##RETURNS Doesn't use


/*
Example of procedure call:

DECLARE @ID bigint
EXEC spReadOnlyObject_Delete @ID

*/




CREATE         Proc [dbo].[spReadOnlyObject_Delete]
		@ID bigint --##PARAM  @ID - object ID
As

	SELECT -1
	
	/* RAISERROR ('msgReadOnlyObjectDelete', 16, 1)
	return -1 */
	

