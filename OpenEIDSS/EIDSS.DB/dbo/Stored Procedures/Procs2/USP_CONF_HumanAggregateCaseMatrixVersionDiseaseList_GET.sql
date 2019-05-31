/*******************************************************
NAME						: [USP_CONF_HumanAggregateCaseMatrixVersionDiseaseList_GET]		


Description					: Retreives List of Diseases For Human Aggregate Case Matrix Version

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					01/24/19							Initial Created
*******************************************************/
CREATE PROCEDURE [dbo].[USP_CONF_HumanAggregateCaseMatrixVersionDiseaseList_GET]
	
@idfVersion								BIGINT = NULL
AS BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
			SELECT
				[idfAggrHumanCaseMTX], 
				[idfVersion], 
				[idfsDiagnosis], 
				[intNumRow], 
				[intRowStatus], 
				[rowguid], 
				[strMaintenanceFlag], 
				[strReservedAttribute], 
				[SourceSystemNameID], 
				[SourceSystemKeyValue]
			FROM [dbo].[tlbAggrHumanCaseMTX]
			WHERE idfVersion = @idfVersion and [intRowStatus] = 1
		END TRY
		BEGIN CATCH
				THROW;
		END CATCH
END



