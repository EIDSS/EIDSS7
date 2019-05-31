




CREATE PROCEDURE dbo.spObjectTypeTree_Post
(
	@idfsParentObjectType	AS bigint,
	@idfsRelatedObjectType	AS bigint,
	@idfsStatus				AS bigint
)
AS

IF @idfsStatus=10107001 --'brrObjectTypeINACTIVE'
BEGIN
	DELETE
	FROM	trtObjectTypeToObjectType 
	WHERE	idfsParentObjectType=@idfsParentObjectType AND
			idfsRelatedObjectType=@idfsRelatedObjectType

END
ELSE
BEGIN
	UPDATE	trtObjectTypeToObjectType 
	SET		idfsStatus=@idfsStatus
	WHERE	idfsParentObjectType=@idfsParentObjectType AND
			idfsRelatedObjectType=@idfsRelatedObjectType

	
	IF @@ROWCOUNT=0
	BEGIN
		INSERT INTO trtObjectTypeToObjectType 
			(
				idfsParentObjectType,
				idfsRelatedObjectType,
				idfsStatus
			) 
		VALUES
			(
				@idfsParentObjectType,
				@idfsRelatedObjectType,
				@idfsStatus
			)
	END

END


