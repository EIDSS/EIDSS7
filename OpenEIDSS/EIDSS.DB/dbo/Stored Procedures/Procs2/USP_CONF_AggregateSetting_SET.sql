/*******************************************************
NAME						: USP_CONF_AggregateSetting_SET		


Description					: Creates Entries into [tstAggrSetting]

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					11/27/2018							Initial Created
*******************************************************/
CREATE PROCEDURE [dbo].[USP_CONF_AggregateSetting_SET]
	   @idfsAggrCaseType				BIGINT
	  ,@idfCustomizationPackage			BIGINT
      ,@idfsStatisticAreaType			BIGINT
      ,@idfsStatisticPeriodType			BIGINT
      ,@strValue						NVARCHAR(200)					

AS BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;
	Declare @idfsReferenceType			BIGINT ;

	SET NOCOUNT ON;

	BEGIN TRY
		IF EXISTS(
		SELECT   
					 [idfsAggrCaseType] 
					,[idfCustomizationPackage] 
					,[idfsStatisticAreaType] 
					,[idfsStatisticPeriodType] FROM [dbo].[tstAggrSetting] 
		WHERE 
					    [idfsAggrCaseType] = @idfsAggrCaseType
					AND [idfCustomizationPackage]  = @idfCustomizationPackage
					AND [intRowStatus] = 0
				 )
			BEGIN
			--Select 'Updating'
				UPDATE dbo.[tstAggrSetting]
				SET 
			
					[idfsStatisticAreaType] = @idfsStatisticAreaType
					,[idfsStatisticPeriodType] = @idfsStatisticPeriodType
				Where 
					    [idfsAggrCaseType] = @idfsAggrCaseType		
					AND [idfCustomizationPackage] = @idfCustomizationPackage 
					AND [intRowStatus] = 0				
			END
		ELSE
			BEGIN
			--Select 'Inserting'
				INSERT INTO [dbo].[tstAggrSetting]
				   (
						  [idfsAggrCaseType] 
						 ,[idfCustomizationPackage] 
						 ,[idfsStatisticAreaType] 
						 ,[idfsStatisticPeriodType]
					)
				Values
					(
						 @idfsAggrCaseType				
						,@idfCustomizationPackage			
						,@idfsStatisticAreaType			
						,@idfsStatisticPeriodType			
					)
			END
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage';
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END



