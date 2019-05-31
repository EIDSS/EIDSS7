/*******************************************************
NAME						: [USP_CONF_AggregateCaseMatrixVersionReport_POST]	


Description					: Deletes Entries For Human Aggregate Case Matrix Report and Version

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					01/24/19							Initial Created
*******************************************************/
CREATE PROCEDURE [dbo].[USP_CONF_HumanAggregateCaseMatrixReport_DELETE]
	

@idfAggrHumanCaseMTX	BIGINT NULL,
@idfVersion				BIGINT NULL, 
@idfsDiagnosis			BIGINT NULL, 
@intNumRow				INT	





AS BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;
	Declare @idfsReferenceType			BIGINT ;

	SET NOCOUNT ON;
		Declare @SupressSelect table
	( 
		retrunCode int,
		returnMessage varchar(200)
	)
	BEGIN TRY
		DELETE FROM [dbo].[tlbAggrHumanCaseMTX] where [idfVersion] = @idfVersion
		DELETE FROM [tlbAggrMatrixVersionHeader]  where [idfVersion] = @idfVersion
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
	END TRY
	BEGIN CATCH
				THROW;
		END CATCH
END
