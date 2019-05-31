
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/13/2017
-- Last modified by:		Joan Li
-- Description:				06/13/2017: Created based on V6 spStatisticType_Post:  V7 usp55
--                          purpose: inset, update and delete records from table:trtStatisticDataType
--                          06/15/2017: change action parameter
/*
----testing code:

EXECUTE usp_StatisticType_Set 'D',39850000000
select * from trtStatisticDataType
*/
--=====================================================================================================

CREATE             PROCEDURE [dbo].[usp_StatisticType_Set] 
	@Action Varchar(2)  --##PARAM @Action - set action,  I - add record, D - delete record, U - modify record
	,@idfsBaseReference AS BIGINT --##PARAM @idfsBaseReference - ID of statistic Type record
	,@strDefault AS NVARCHAR(200) =NULL --##PARAM @strDefault - English name of statistic Type
	,@Name AS NVARCHAR(200) =NULL --##PARAM @Name - name of statistic Type in language defined by @LangID
	,@idfsReferenceType AS BIGINT =NULL--##PARAM @idfsReferenceType - parameter Type
	,@idfsStatisticPeriodType AS BIGINT =NULL--##PARAM @idfsStatisticPeriodType - statistic period Type, reference to rftStatisticPeriodType (19000091)
	,@idfsStatisticAreaType AS BIGINT=NULL --##PARAM @idfsStatisticAreaType - statistic Area Type, reference to rftStatisticAreaType (19000089)
	,@blnRelatedWithAgeGroup AS BIT=NULL
	,@LangID As nvarchar(50) =NULL--##PARAM @LangID - language ID
AS
BEGIN
	IF upper(@Action) = 'D'  --delete
		BEGIN
			DELETE FROM  trtStatisticDataType
			WHERE  idfsStatisticDataType= @idfsBaseReference		
			EXECUTE usp_sysBaseReference_Delete  @idfsBaseReference
		END
	ELSE
		BEGIN  ----for update and insert 
			EXEC dbo.usp_BaseReference_SysSet
					@idfsBaseReference,
					19000090,  --'rftStatisticDataType',
					@LangID,
					@strDefault,
					@Name,
					null,
					null
			IF upper(@Action) = 'I' --Added
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
				END ----end action=I
			IF upper(@Action) = 'U' --Modified
				BEGIN
					UPDATE trtStatisticDataType
					   SET 
						   idfsReferenceType = @idfsReferenceType
						  ,idfsStatisticAreaType = @idfsStatisticAreaType
						  ,idfsStatisticPeriodType = @idfsStatisticPeriodType
						  ,blnRelatedWithAgeGroup = @blnRelatedWithAgeGroup
					 WHERE  idfsStatisticDataType = @idfsBaseReference
				END	----end action=U
		END --end action else <>U
END




