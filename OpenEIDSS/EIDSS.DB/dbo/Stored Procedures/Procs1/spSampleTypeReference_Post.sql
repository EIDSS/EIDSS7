





CREATE     PROCEDURE dbo.spSampleTypeReference_Post 
	@Action INT,-- 4 - Added, 8 - Deleted, 16 - Modified
	@idfsBaseReference BIGINT,
	--@idfsReferenceType BIGINT,
	@strDefault VARCHAR(200),
	@strSampleCode NVARCHAR(50),
	@Name  NVARCHAR(200),
	@intHACode INT,
	@intOrder INT,
	@LangID  NVARCHAR(50)
AS
BEGIN
	
	Declare @idfsReferenceType BIGINT
	Select @idfsReferenceType = 19000087

	IF @Action = 8
	BEGIN

		DELETE FROM  trtSampleType
		WHERE idfsSampleType = @idfsBaseReference
		
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
		IF @Action = 4 --Added
		BEGIN
			INSERT INTO trtSampleType
			(idfsSampleType, strSampleCode) 
            VALUES  (@idfsBaseReference, @strSampleCode)
		END
		IF @Action = 16 --Modified
		BEGIN
			UPDATE trtSampleType
			SET strSampleCode = @strSampleCode
            WHERE idfsSampleType = @idfsBaseReference
		END
		
	END

END





