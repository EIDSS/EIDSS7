
--##SUMMARY Posts data from VectorSubTypeDetail form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 12.01.2012

--##RETURNS Doesn't use

/*
--Example of procedure call:

*/


CREATE PROCEDURE [dbo].[spVectorSubType_Post]
	@Action INT, --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	@idfsVectorSubType BIGINT OUTPUT, --##PARAM @idfsVectorSubType - vector subtype ID
	@idfsVectorType BIGINT, --##PARAM @idfsVectorType - parent vector ID
	@strTranslatedName NVARCHAR(200),--##PARAM @strTranslatedName - VectorType  name in language defined by @LangID parameter
	@strDefaultName VARCHAR(200),--##PARAM @strDefaultName - english VectorType name
	@strCode VARCHAR(50), --##PARAM @strCode - literal code of vector subtype 
	@intOrder INT, --##PARAM @intOrder - reference record order for sorting
	@LangID  NVARCHAR(50)--##PARAM @LangID - language ID 

AS
	IF @Action IS NULL 
		RETURN

	IF @Action = 8
	BEGIN


		DELETE FROM  dbo.trtVectorSubType
		WHERE idfsVectorSubType = @idfsVectorSubType

		EXECUTE spsysBaseReference_Delete  @idfsVectorSubType


	END
	ELSE
	BEGIN
		IF ISNULL(@idfsVectorSubType,-1)<0
			EXEC spsysGetNewID @idfsVectorSubType OUTPUT
		EXEC dbo.spBaseReference_SysPost 
				@idfsVectorSubType,
				19000141/*Vector sub type*/,
				@LangID,
				@strDefaultName,
				@strTranslatedName,
				128,
				@intOrder

		IF @Action = 4 --Added
		BEGIN

			INSERT INTO trtVectorSubType
			(
			idfsVectorSubType
			,idfsVectorType
			,strCode
			)
			VALUES
			(
			@idfsVectorSubType
			,@idfsVectorType
			,@strCode
			)
		END
		IF @Action = 16 --Modified
		BEGIN
		UPDATE trtVectorSubType
		SET
			strCode = @strCode
		WHERE 
			idfsVectorSubType = @idfsVectorSubType 
		END
		
	END



RETURN 0
