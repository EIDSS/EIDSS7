/*******************************************************
NAME						: [USP_CONF_AggregateCaseMatrixVersionReport_POST]	


Description					: Saves Entries For Human Aggregate Case Matrix Report

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					01/24/19							Initial Created
*******************************************************/
CREATE PROCEDURE [dbo].[USP_CONF_HumanAggregateCaseMatrixReport_POST]
	

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
		IF EXISTS (SELECT * FROM [dbo].[tlbAggrHumanCaseMTX] WHERE idfVersion = @idfVersion AND idfsDiagnosis = @idfsDiagnosis )
			BEGIN
				UPDATE [dbo].[tlbAggrHumanCaseMTX]
				SET
				[intRowStatus] =		0
				WHERE [idfVersion] =	@idfVersion
				AND idfsDiagnosis =  @idfsDiagnosis
			END
			BEGIN
			INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbAggrHumanCaseMTX', @idfAggrHumanCaseMTX OUTPUT
			INSERT INTO [tlbAggrHumanCaseMTX]
			   (
						idfAggrHumanCaseMTX
						,idfVersion
					   ,idfsDiagnosis
					   ,intNumRow
					   ,intRowStatus
					   
				)
			VALUES	
			   (
						@idfAggrHumanCaseMTX
						,@idfVersion
					   ,@idfsDiagnosis
					   ,@intNumRow
					   ,1
				)
			END
			SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage',@idfAggrHumanCaseMTX 'idfAggrHumanCaseMTX'
		END TRY
		BEGIN CATCH
				THROW;
		END CATCH
END
