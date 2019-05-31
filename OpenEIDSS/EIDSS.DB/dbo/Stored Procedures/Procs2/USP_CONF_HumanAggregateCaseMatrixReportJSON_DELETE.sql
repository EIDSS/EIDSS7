/*******************************************************
NAME						: [USP_CONF_HumanAggregateCaseMatrixReportJSON_DELETE]


Description					: Deletes Entries For Human Aggregate Case Matrix Report FROM A JSON STRING

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					3/12/19							Initial Created
*******************************************************/
CREATE PROCEDURE [dbo].[USP_CONF_HumanAggregateCaseMatrixReportJSON_DELETE]
	

@idfAggrHumanCaseMTX	BIGINT

AS 
BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;
	Declare @idfsReferenceType			BIGINT ;
	Declare @JsonString				 Varchar(Max); 
	SET NOCOUNT ON;

	BEGIN TRY
			IF EXISTS (SELECT * FROM [dbo].[tlbAggrHumanCaseMTX] WHERE idfAggrHumanCaseMTX = @idfAggrHumanCaseMTX)
			BEGIN
					
				DELETE FROM [tlbAggrHumanCaseMTX] WHERE idfAggrHumanCaseMTX = @idfAggrHumanCaseMTX ;
				Print 'Deleted';
			END
			SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage',@idfAggrHumanCaseMTX 'idfAggrHumanCaseMTX'
		END TRY
		BEGIN CATCH
				THROW;
		END CATCH
END
