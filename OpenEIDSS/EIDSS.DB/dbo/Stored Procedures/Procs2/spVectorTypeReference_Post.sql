


--##SUMMARY Posts data from VectorTypeEditor form

--##REMARKS Author: Zhdanova A.
--##REMARKS Create date: 12.09.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:

DECLARE @idfsBaseReference bigint

exec dbo.spsysGetNewID @idfsBaseReference output

EXECUTE [dbo].[spVectorTypeReference_Post] 
   4
  ,@idfsBaseReference
  ,'���!!!'
  ,'Test!!!'
  ,'T/111'
  ,1
  ,3
  ,'ru'

execute	spVectorTypeReference_SelectDetail 'ru'

EXECUTE [dbo].[spVectorTypeReference_Post] 
   16
  ,@idfsBaseReference
  ,'����!!!'
  ,'Test!!!'
  ,'T.111'
  ,1
  ,3
  ,'ru'

execute	spVectorTypeReference_SelectDetail 'ru'

EXECUTE [dbo].[spVectorTypeReference_Post] 
   8
  ,@idfsBaseReference
  ,''
  ,''
  ,''
  ,1
  ,3
  ,'en'

execute	spVectorTypeReference_SelectDetail 'ru'

*/


CREATE     PROCEDURE [dbo].[spVectorTypeReference_Post] 
	@Action INT,--##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	@idfsBaseReference BIGINT,--##PARAM @idfsBaseReference - vector type ID
	@strTranslatedName NVARCHAR(200),--##PARAM @strTranslatedName - VectorType  name in language defined by @LangID parameter
	@strDefaultName VARCHAR(200),--##PARAM @strDefaultName - english VectorType name
	@strCode  NVARCHAR(200),--##PARAM @strCode - string code of VectorType
	@bitCollectionByPool bit,--##PARAN @bitCollectionByPool - flag of collection metod
	@intOrder INT,--##PARAM @intOrder - VectorType order
	@LangID  NVARCHAR(50)--##PARAM @LangID - language ID 
AS
BEGIN
	IF @Action IS NULL 
		RETURN

	IF @Action = 8
	BEGIN

		--DELETE FROM dbo.trtVectorTypeForCountry 
		--WHERE idfsVectorType = @idfsBaseReference

		DELETE FROM  dbo.trtVectorType
		WHERE idfsVectorType = @idfsBaseReference

		EXECUTE spsysBaseReference_Delete  @idfsBaseReference


	END
	ELSE
	BEGIN
		IF @Action IS NOT NULL
		BEGIN
		EXEC dbo.spBaseReference_SysPost 
				@idfsBaseReference,
				19000140/*Vector type*/,
				@LangID,
				@strDefaultName,
				@strTranslatedName,
				128,
				@intOrder
		END

		IF @Action = 4 --Added
		BEGIN
				INSERT INTO dbo.trtVectorType
				(	
					idfsVectorType
					,strCode
					,bitCollectionByPool
				) 
                VALUES  
				(
					@idfsBaseReference
					,@strCode
					,@bitCollectionByPool
				)
		END
		IF @Action = 16 --Modified
		BEGIN
				UPDATE dbo.trtVectorType
				SET 
						strCode = @strCode
						,bitCollectionByPool = @bitCollectionByPool
                WHERE	idfsVectorType = @idfsBaseReference
		END
		
	END

END





