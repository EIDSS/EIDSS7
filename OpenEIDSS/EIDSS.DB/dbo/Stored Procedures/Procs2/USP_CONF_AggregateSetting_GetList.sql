/*******************************************************
NAME						: USP_CONF_AggregateSetting_GetList		


Description					: Retreives Entries from [tstAggrSetting] based on Customization Package

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					11/27/2018							Initial Created
			Lamont Mitchel					1/10/19				Added check for IntrowStatus = 0 in Where Clause
*******************************************************/
CREATE PROCEDURE [dbo].[USP_CONF_AggregateSetting_GetList]
	
	 @idfCustomizationPackage			BIGINT
     			

AS BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;
	Declare @idfsReferenceType			BIGINT ;

	SET NOCOUNT ON;

	BEGIN TRY
		SELECT 		
			[idfsAggrCaseType]
			,[idfCustomizationPackage]
			,[idfsStatisticAreaType]
			,[idfsStatisticPeriodType]
		FROM dbo.[tstAggrSetting]
		WHERE [idfCustomizationPackage] = @idfCustomizationPackage and  [intRowStatus] =0
			
	END TRY
	BEGIN CATCH
			THROW
	END CATCH
END



