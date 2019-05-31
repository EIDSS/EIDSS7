/*******************************************************
NAME						: [USP_CONF_AggregateCaseMatrixVersion_GET]		


Description					: Retreives Entries For Human Aggregate Case Matrix Version

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					01/24/19							Initial Created
*******************************************************/
CREATE PROCEDURE [dbo].[USP_CONF_HumanAggregateCaseMatrixVersion_GET]
	
@idfVersion								BIGINT = NULL
AS BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
			IF @idfVersion IS NULL
			 BEGIN
				 SELECT 
				[idfVersion], 
				[idfsMatrixType], 
				[MatrixName], 
				[datStartDate], 
				[blnIsActive], 
				[intRowStatus], 
				[rowguid], 
				[blnIsDefault], 
				[strMaintenanceFlag], 
				[strReservedAttribute]
				FROM [dbo].[tlbAggrMatrixVersionHeader] where  intRowStatus =0
			 END
			 ELSE
			 BEGIN
				SELECT 
				[idfVersion], 
				[idfsMatrixType], 
				[MatrixName], 
				[datStartDate], 
				[blnIsActive], 
				[intRowStatus], 
				[rowguid], 
				[blnIsDefault], 
				[strMaintenanceFlag], 
				[strReservedAttribute]
				FROM [dbo].[tlbAggrMatrixVersionHeader]
				WHERE idfVersion = @idfVersion and intRowStatus =0
			 
			 END
	
		END TRY
		BEGIN CATCH
				THROW;
		END CATCH
END



