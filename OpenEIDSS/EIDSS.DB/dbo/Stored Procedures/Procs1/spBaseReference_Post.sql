


--##SUMMARY Posts data from ReferenceDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.12.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
DECLARE @Action int
DECLARE @idfsBaseReference bigint
DECLARE @idfsReferenceType bigint
DECLARE @strDefault varchar(200)
DECLARE @Name nvarchar(200)
DECLARE @intHACode int
DECLARE @intOrder int
DECLARE @LangID nvarchar(50)

EXECUTE spBaseReference_Post
   @Action
  ,@idfsBaseReference
  ,@idfsReferenceType
  ,@strDefault
  ,@Name
  ,@intHACode
  ,@intOrder
  ,@LangID

*/




CREATE     PROCEDURE dbo.spBaseReference_Post 
	@Action INT, --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	@idfsBaseReference BIGINT, --##PARAM @idfsBaseReference - reference ID
	@idfsReferenceType BIGINT, --##PARAM @idfsReferenceType - reference Type ID
	@strDefault VARCHAR(200), --##PARAM @strDefault - default reference name, used if there is no refernece translation
	@Name  NVARCHAR(200), --##PARAM @Name - reference name in the language defined by @LangID
	@intHACode INT, --##PARAM @intHACode - bit mask for reference using
	@intOrder INT, --##PARAM @intOrder - reference record order for sorting
	@LangID  NVARCHAR(50) --##PARAM @LangID - language ID

AS
	IF @Action = 8
	BEGIN
		EXEC spsysBaseReference_Delete @idfsBaseReference
	END
	ELSE
	BEGIN
		EXEC dbo.spBaseReference_SysPost 
				@idfsBaseReference,
				@idfsReferenceType,
				@LangID,
				@strDefault,
				@Name,
				@intHACode,
				@intOrder
	END






