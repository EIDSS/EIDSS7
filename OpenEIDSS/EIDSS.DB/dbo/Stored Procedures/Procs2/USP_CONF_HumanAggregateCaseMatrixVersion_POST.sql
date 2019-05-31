/*******************************************************
NAME						: [USP_CONF_AggregateCaseMatrixVersion_POST]		


Description					: Saves Entries For Human Aggregate Case Matrix Version

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					01/24/19							Initial Created
*******************************************************/
CREATE PROCEDURE [dbo].[USP_CONF_HumanAggregateCaseMatrixVersion_POST]
	
@idfVersion								BIGINT = NULL,
@idfsMatrixType     					BIGINT,
@datStartDate							DATETIME,
@MatrixName								NVARCHAR(200),
@blnIsActive							BIT = 0,
@blnIsDefault							BIT = 0
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
		IF EXISTS (SELECT * FROM [tlbAggrMatrixVersionHeader] WHERE idfVersion = @idfVersion)
			BEGIN
				UPDATE [tlbAggrMatrixVersionHeader]
				SET
				
					 [MatrixName] =			@MatrixName
					,[datStartDate] =		@datStartDate
					,[blnIsActive] =		@blnIsActive
					,[intRowStatus] =		0
					,[blnIsDefault] =		@blnIsDefault
					,[strMaintenanceFlag] = NULL
					,[strReservedAttribute] = NULL
					WHERE [idfVersion] =	@idfVersion
			END
		ELSE
			BEGIN
			INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbAggrMatrixVersionHeader', @idfVersion OUTPUT
			INSERT INTO tlbAggrMatrixVersionHeader
			   (
						idfVersion
					   ,idfsMatrixType
					   ,MatrixName
					   ,datStartDate
					   ,blnIsActive
					   ,blnIsDefault
				)
			VALUES	
			   (
						@idfVersion
					   ,@idfsMatrixType
					   ,@MatrixName
					   ,@datStartDate
					   ,@blnIsActive
					   ,@blnIsDefault
				)
			END
			SELECT 
						idfVersion
					   ,idfsMatrixType
					   ,MatrixName
					   ,datStartDate
					   ,blnIsActive
					   ,blnIsDefault
					   ,@returnCode 'ReturnCode'
					   ,@returnMsg 'ReturnMessage'
			FROM tlbAggrMatrixVersionHeader where idfVersion = @idfVersion
		END TRY
		BEGIN CATCH
				THROW;
		END CATCH
END




