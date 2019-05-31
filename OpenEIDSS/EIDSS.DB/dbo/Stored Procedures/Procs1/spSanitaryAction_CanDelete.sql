


--##SUMMARY Checks if Sanitary Action can be deleted.
--##SUMMARY This procedure is called from MeasureReference Editor.
--##SUMMARY We consider that Sanitary Action can be deleted if there is no reference to this action from Sanitary Action Matrix
--##SUMMARY from any other table



--##REMARKS Author: Zurin M.
--##REMARKS Create date: 07.06.2010
--##REMARKS Update date: 22.05.2013 by Romasheva S.

--##RETURNS 0 if Sanitary Action can't be deleted 
--##RETURNS 1 if Sanitary Action can be deleted 

/*
Example of procedure call:

DECLARE @ID bigint
DECLARE @Result BIT
EXEC spSanitaryAction_CanDelete 1, @Result OUTPUT

Print @Result

*/


create   procedure dbo.spSanitaryAction_CanDelete
	@ID as bigint --##PARAM @ID - Sanitary Action
	,@Result AS BIT OUTPUT --##PARAM  @Result - 0 if case can't be deleted, 1 in other case
as

IF EXISTS(SELECT * from dbo.tlbAggrSanitaryActionMTX  where idfsSanitaryAction = @ID and intRowStatus = 0)
	SET @Result = 0
ELSE
	SET @Result = 1

Return @Result


