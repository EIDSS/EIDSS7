


--##SUMMARY Posts statistic Type data. 
--##SUMMARY Called from Generic Statistic Types Editor form . 

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
DECLARE @Action int
DECLARE @idfsBaseReference bigint
DECLARE @strDefault nvarchar(200)
DECLARE @Name nvarchar(200)
DECLARE @idfsReferenceType bigint
DECLARE @idfsStatisticPeriodType bigint
DECLARE @idfsStatisticAreaType bigint
DECLARE @LangID nvarchar(50)

EXECUTE spStatisticType_Post
   @Action
  ,@idfsBaseReference
  ,@strDefault
  ,@Name
  ,@idfsReferenceType
  ,@idfsStatisticPeriodType
  ,@idfsStatisticAreaType
  ,@LangID
*/




CREATE             PROCEDURE dbo.spStatisticType_Post 
	@Action AS INT,  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	@idfsBaseReference AS BIGINT, --##PARAM @idfsBaseReference - ID of statistic Type record
	@strDefault AS NVARCHAR(200), --##PARAM @strDefault - English name of statistic Type
	@Name AS NVARCHAR(200), --##PARAM @Name - name of statistic Type in language defined by @LangID
	@idfsReferenceType AS BIGINT, --##PARAM @idfsReferenceType - parameter Type
	@idfsStatisticPeriodType AS BIGINT, --##PARAM @idfsStatisticPeriodType - statistic period Type, reference to rftStatisticPeriodType (19000091)
	@idfsStatisticAreaType AS BIGINT, --##PARAM @idfsStatisticAreaType - statistic Area Type, reference to rftStatisticAreaType (19000089)
	@blnRelatedWithAgeGroup AS BIT,
	@LangID As nvarchar(50) --##PARAM @LangID - language ID
AS
BEGIN
	IF @Action = 8
	BEGIN

		DELETE FROM  trtStatisticDataType
		WHERE  idfsStatisticDataType= @idfsBaseReference
		
		EXECUTE spsysBaseReference_Delete  @idfsBaseReference


	END
	ELSE
	BEGIN
		EXEC dbo.spBaseReference_SysPost 
				@idfsBaseReference,
				19000090,  --'rftStatisticDataType',
				@LangID,
				@strDefault,
				@Name,
				null,
				null
		IF @Action = 4 --Added
		BEGIN
			INSERT INTO trtStatisticDataType
					   (
						idfsStatisticDataType
					   ,idfsReferenceType
					   ,idfsStatisticAreaType
					   ,idfsStatisticPeriodType
					   ,blnRelatedWithAgeGroup
						)
				 VALUES
					   (
						@idfsBaseReference
					   ,@idfsReferenceType
					   ,@idfsStatisticAreaType
					   ,@idfsStatisticPeriodType
					   ,@blnRelatedWithAgeGroup
					   )		
		END
		IF @Action = 16 --Modified
		BEGIN
			UPDATE trtStatisticDataType
			   SET 
				   idfsReferenceType = @idfsReferenceType
				  ,idfsStatisticAreaType = @idfsStatisticAreaType
				  ,idfsStatisticPeriodType = @idfsStatisticPeriodType
				  ,blnRelatedWithAgeGroup = @blnRelatedWithAgeGroup
			 WHERE  idfsStatisticDataType = @idfsBaseReference
		END
		
	END

END



