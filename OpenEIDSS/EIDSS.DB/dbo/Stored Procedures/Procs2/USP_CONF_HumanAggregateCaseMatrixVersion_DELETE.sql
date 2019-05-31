/*******************************************************
NAME						: [USP_CONF_HumanAggregateCaseMatrixVersion_DELETE]		


Description					: Deletes[o Entries For Human Aggregate Case Matrix Version

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					01/24/19							Initial Created
*******************************************************/
CREATE PROCEDURE [dbo].[USP_CONF_HumanAggregateCaseMatrixVersion_DELETE]
	
@idfVersion								BIGINT = NULL
AS BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;
	SET NOCOUNT ON;

	BEGIN TRY
			IF EXISTS(SELECT * from [tlbAggrMatrixVersionHeader] WHERE idfVersion =  @idfVersion )
			 BEGIN
				DELETE FROM [tlbAggrMatrixVersionHeader] WHERE idfVersion =  @idfVersion 
				SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
			 END
			ELSE
			BEGIN
				SET @returnMsg = 'Record does not exists'
				SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
			END
		END TRY
		BEGIN CATCH
				THROW;
		END CATCH
END



